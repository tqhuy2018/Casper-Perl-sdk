#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 6;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Time::HiRes qw(time);
use POSIX qw(strftime);

use Serialization::CLParseSerialization;
use CLValue::CLType;
use CLValue::CLParse;
use CLValue::CLValue;
use Common::ConstValues;
use GetDeploy::Deploy;
use GetDeploy::DeployHeader;
use GetDeploy::ExecutableDeployItem::NamedArg;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;
use  GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use GetDeploy::Approval;
use CryptoHandle::Secp256k1Handle;
use CryptoHandle::Ed25519Handle;
use PutDeploy::PutDeployRPC;
use Common::Utils;
# test put deploy with input isEd25519 = int, 1 then use Ed25519 account, 0 then use Secp256k1 account
sub testPutDeploy {
	my @list = @_;
	my $isEd25519 = int($list[0]);
	my $accountEd25519 = "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4";
	my $accountSecp256k1 = "0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499";
	my $deploy = new GetDeploy::Deploy();
	my $deployHeader = new GetDeploy::DeployHeader();
	if ($isEd25519 == 1) {
		$deployHeader->setAccount($accountEd25519);
	} else {
		$deployHeader->setAccount($accountSecp256k1);
	}
	# get current time to assign the timestamp value
	my $t = time;
	my $date = strftime "%Y-%m-%dT%H:%M:%S", localtime $t;
	$date .= sprintf ".%03d", ($t-int($t))*1000;
	$date = $date."Z";
	#$date = "2022-07-08T08:11:27.149Z";
	$deployHeader->setTimestamp($date);
	$deployHeader->setChainName("casper-test");
	$deployHeader->setTTL("1h 30m");
	$deployHeader->setGasPrice(1);
	# Setup for deploy payment of type  ExecutableDeployItem_ModuleBytes
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1st NamedArgs
	my $clValue = new CLValue::CLValue();
	$clValue->setBytes("0400ca9a3b");
	my $clType = new CLValue::CLType();
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	my $clParse = new CLValue::CLParse();
	$clParse->setItsCLType($clType);
	$clParse->setItsValueStr("1000000000");
	$clValue->setCLType($clType);
	$clValue->setParse($clParse);
	my $namedArg = new GetDeploy::ExecutableDeployItem::NamedArg();
	$namedArg->setItsName("amount");
	$namedArg->setCLValue($clValue);
	my $runTimeArgs = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listArgs = ($namedArg);
	$runTimeArgs->setListNamedArg(@listArgs);
	
	my $payment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$payment->setItsType($Common::ConstValues::EDI_MODULE_BYTES);
	my $ediPayment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes();
	$ediPayment->setModuleBytes("");
	$ediPayment->setArgs($runTimeArgs);
	$payment->setItsValue($ediPayment);
	$deploy->setPayment($payment);
	
	# Setup for deploy session of type ExecutableDeployItem_Transfer
	
	# set up RuntimeArgs with 4 elements of NamedArg
    # setup 1st NamedArg - CLValue of type U512
    my $oneNASession1 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession1->setItsName("amount");
    my $oneCLValueSession1 = new CLValue::CLValue();
    my $oneCLTypeSession1 = new CLValue::CLType();
    my $oneCLParseSession1 = new CLValue::CLParse();
    $oneCLTypeSession1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
    $oneCLParseSession1->setItsCLType($oneCLTypeSession1);
    $oneCLParseSession1->setItsValueStr("3000000000");
    $oneCLValueSession1->setCLType($oneCLTypeSession1);
    $oneCLValueSession1->setParse($oneCLParseSession1);
    $oneCLValueSession1->setBytes("04005ed0b2");
	$oneNASession1->setCLValue($oneCLValueSession1);
	
	# setup 2nd NamedArg - CLValue of type PublicKey
	my $oneNASession2 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession2->setItsName("target");
    my $oneCLValueSession2 = new CLValue::CLValue();
    my $oneCLTypeSession2 = new CLValue::CLType();
    my $oneCLParseSession2 = new CLValue::CLParse();
    $oneCLTypeSession2->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
    $oneCLParseSession2->setItsCLType($oneCLTypeSession2);
    $oneCLParseSession2->setItsValueStr("015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a");
    $oneCLValueSession2->setCLType($oneCLTypeSession2);
    $oneCLValueSession2->setParse($oneCLParseSession2);
    $oneCLValueSession2->setBytes("015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a");
	$oneNASession2->setCLValue($oneCLValueSession2);
	
	# setup 3rd NamedArg - CLValue of type Option(U64(0))
	my $oneNASession3 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession3->setItsName("id");
    my $oneCLValueSession3 = new CLValue::CLValue();
    my $oneCLTypeSession3 = new CLValue::CLType();
    my $oneCLParseSession3 = new CLValue::CLParse();
    $oneCLTypeSession3->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
    $oneCLParseSession3->setItsCLType($oneCLTypeSession3);
    $oneCLParseSession3->setItsValueStr("ok");
    # setup U64 CLParse as inner parse for the Option(U64) CLParse
    my $clTypeOptionIn = new CLValue::CLType();
    $clTypeOptionIn->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
    my $clParseOptionIn = new CLValue::CLParse();
    $clParseOptionIn->setItsCLType($clTypeOptionIn);
    $clParseOptionIn->setItsValueStr("0");
    $oneCLTypeSession3->setInnerCLType1($clTypeOptionIn);
    $oneCLParseSession3->setInnerParse1($clParseOptionIn);
    
    $oneCLValueSession3->setCLType($oneCLTypeSession3);
    $oneCLValueSession3->setParse($oneCLParseSession3);
    $oneCLValueSession3->setBytes("010000000000000000");
	$oneNASession3->setCLValue($oneCLValueSession3);
	# setup 4th NamedArg - CLValue of type Key
	
	my $oneNASession4 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession4->setItsName("spender");
    my $oneCLValueSession4 = new CLValue::CLValue();
    my $oneCLTypeSession4 = new CLValue::CLType();
    my $oneCLParseSession4 = new CLValue::CLParse();
    $oneCLTypeSession4->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
    $oneCLParseSession4->setItsCLType($oneCLTypeSession4);
    $oneCLParseSession4->setItsValueStr("hash-dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b");
    $oneCLValueSession4->setCLType($oneCLTypeSession4);
    $oneCLValueSession4->setParse($oneCLParseSession4);
    $oneCLValueSession4->setBytes("01dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b");
	$oneNASession4->setCLValue($oneCLValueSession4);
	my $runTimeArgsSession = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listArgsSession = ($oneNASession1,$oneNASession2,$oneNASession3,$oneNASession4);
	$runTimeArgsSession->setListNamedArg(@listArgsSession);
	
	my $session = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$session->setItsType($Common::ConstValues::EDI_TRANSFER);
	my $ediSession = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
	$ediSession->setArgs($runTimeArgsSession);
	$session->setItsValue($ediSession);
	$deploy->setHeader($deployHeader);
	
	$deploy->setSession($session);
	my $deployBodyHash = $deploy->getBodyHash();
	$deployHeader->setBodyHash($deployBodyHash);
	my $deployHash = $deployHeader->getDeployHash();
	$deploy->setDeployHash($deployHash);
	my $util = new Common::Utils();
	# Setup approvals
	my $oneApproval = new GetDeploy::Approval();
	if ($isEd25519 == 1) {
		$oneApproval->setSigner($accountEd25519);
		my $ed25519 = new CryptoHandle::Ed25519Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $privateKey = Crypt::PK::Ed25519->new($Common::ConstValues::READ_ED25519_PRIVATE_KEY_FILE);
		my $signature = $ed25519->signMessage($hashAnscii,$privateKey);
		$signature = "01".$signature;
		$oneApproval->setSignature($signature);
	} else {
		$oneApproval->setSigner($accountSecp256k1);
		my $secp256k1 = new CryptoHandle::Secp256k1Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $privateKey = Crypt::PK::ECC->new($Common::ConstValues::READ_SECP256K1_PRIVATE_KEY_FILE);
		my $signature = $secp256k1->signMessage($hashAnscii,$privateKey);
		$signature = "02".$signature;
		$oneApproval->setSignature($signature);
	}
	my @listApprovals = ($oneApproval);
	$deploy->setApprovals(@listApprovals);
	my $putDeployRPC = new PutDeploy::PutDeployRPC();
	if ($isEd25519 == 0) {
		$putDeployRPC->setPutDeployCounter(0);
	}
	my $deployHashRet = $putDeployRPC->putDeploy($deploy);
	return $deployHashRet;
}
# This function setup a deploy, used for account_put_deploy RPC call
# input: an integer value, with value 1 means deploy account is of type Ed25519
# value 0 means deploy account is of type Secp256k1s
# output: a deploy with all information for account_put_deploy RPC call
sub setupDeploy {
	my @vars = @_;
	my $isEd25519 = int($vars[0]);
	my $toTransferPublicKey = $vars[1];
	my $amountToTransfer = $vars[2];
	my $accountEd25519 = "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4";
	my $accountSecp256k1 = "0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499";
	my $deploy = new GetDeploy::Deploy();
	my $deployHeader = new GetDeploy::DeployHeader();
	if ($isEd25519 == 1) {
		$deployHeader->setAccount($accountEd25519);
	} else {
		$deployHeader->setAccount($accountSecp256k1);
	}
	# get current time to assign the timestamp value
	my $t = time;
	my $date = strftime "%Y-%m-%dT%H:%M:%S", localtime $t;
	$date .= sprintf ".%03d", ($t-int($t))*1000;
	$date = $date."Z";
	#$date = "2022-07-08T08:11:27.149Z";
	$deployHeader->setTimestamp($date);
	$deployHeader->setChainName("casper-test");
	$deployHeader->setTTL("1h 30m");
	$deployHeader->setGasPrice(1);
	# Setup for deploy payment of type  ExecutableDeployItem_ModuleBytes
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1st NamedArgs
	my $clValue = new CLValue::CLValue();
	$clValue->setBytes("0400ca9a3b");
	my $clType = new CLValue::CLType();
	$clType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	my $clParse = new CLValue::CLParse();
	$clParse->setItsCLType($clType);
	$clParse->setItsValueStr("1000000000");
	$clValue->setCLType($clType);
	$clValue->setParse($clParse);
	my $namedArg = new GetDeploy::ExecutableDeployItem::NamedArg();
	$namedArg->setItsName("amount");
	$namedArg->setCLValue($clValue);
	my $runTimeArgs = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listArgs = ($namedArg);
	$runTimeArgs->setListNamedArg(@listArgs);
	
	my $payment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$payment->setItsType($Common::ConstValues::EDI_MODULE_BYTES);
	my $ediPayment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes();
	$ediPayment->setModuleBytes("");
	$ediPayment->setArgs($runTimeArgs);
	$payment->setItsValue($ediPayment);
	$deploy->setPayment($payment);
	
	# Setup for deploy session of type ExecutableDeployItem_Transfer
	
	# set up RuntimeArgs with 4 elements of NamedArg
    # setup 1st NamedArg - CLValue of type U512
    my $oneNASession1 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession1->setItsName("amount");
    my $oneCLValueSession1 = new CLValue::CLValue();
    my $oneCLTypeSession1 = new CLValue::CLType();
    my $oneCLParseSession1 = new CLValue::CLParse();
    $oneCLTypeSession1->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
    $oneCLParseSession1->setItsCLType($oneCLTypeSession1);
    $oneCLParseSession1->setItsValueStr($amountToTransfer);
    $oneCLValueSession1->setCLType($oneCLTypeSession1);
    $oneCLValueSession1->setParse($oneCLParseSession1);
    $oneCLValueSession1->setBytes("04005ed0b2");
	$oneNASession1->setCLValue($oneCLValueSession1);
	
	# setup 2nd NamedArg - CLValue of type PublicKey
	my $oneNASession2 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession2->setItsName("target");
    my $oneCLValueSession2 = new CLValue::CLValue();
    my $oneCLTypeSession2 = new CLValue::CLType();
    my $oneCLParseSession2 = new CLValue::CLParse();
    $oneCLTypeSession2->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
    $oneCLParseSession2->setItsCLType($oneCLTypeSession2);
    $oneCLParseSession2->setItsValueStr($toTransferPublicKey);#"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a");
    $oneCLValueSession2->setCLType($oneCLTypeSession2);
    $oneCLValueSession2->setParse($oneCLParseSession2);
    $oneCLValueSession2->setBytes($toTransferPublicKey);
	$oneNASession2->setCLValue($oneCLValueSession2);
	
	# setup 3rd NamedArg - CLValue of type Option(U64(0))
	my $oneNASession3 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession3->setItsName("id");
    my $oneCLValueSession3 = new CLValue::CLValue();
    my $oneCLTypeSession3 = new CLValue::CLType();
    my $oneCLParseSession3 = new CLValue::CLParse();
    $oneCLTypeSession3->setItsTypeStr($Common::ConstValues::CLTYPE_OPTION);
    $oneCLParseSession3->setItsCLType($oneCLTypeSession3);
    $oneCLParseSession3->setItsValueStr("ok");
    # setup U64 CLParse as inner parse for the Option(U64) CLParse
    my $clTypeOptionIn = new CLValue::CLType();
    $clTypeOptionIn->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
    my $clParseOptionIn = new CLValue::CLParse();
    $clParseOptionIn->setItsCLType($clTypeOptionIn);
    $clParseOptionIn->setItsValueStr("0");
    $oneCLTypeSession3->setInnerCLType1($clTypeOptionIn);
    $oneCLParseSession3->setInnerParse1($clParseOptionIn);
    
    $oneCLValueSession3->setCLType($oneCLTypeSession3);
    $oneCLValueSession3->setParse($oneCLParseSession3);
    $oneCLValueSession3->setBytes("010000000000000000");
	$oneNASession3->setCLValue($oneCLValueSession3);
	# setup 4th NamedArg - CLValue of type Key
	
	my $oneNASession4 = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneNASession4->setItsName("spender");
    my $oneCLValueSession4 = new CLValue::CLValue();
    my $oneCLTypeSession4 = new CLValue::CLType();
    my $oneCLParseSession4 = new CLValue::CLParse();
    $oneCLTypeSession4->setItsTypeStr($Common::ConstValues::CLTYPE_KEY);
    $oneCLParseSession4->setItsCLType($oneCLTypeSession4);
    $oneCLParseSession4->setItsValueStr("hash-dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b");
    $oneCLValueSession4->setCLType($oneCLTypeSession4);
    $oneCLValueSession4->setParse($oneCLParseSession4);
    $oneCLValueSession4->setBytes("01dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b");
	$oneNASession4->setCLValue($oneCLValueSession4);
	my $runTimeArgsSession = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listArgsSession = ($oneNASession1,$oneNASession2,$oneNASession3,$oneNASession4);
	$runTimeArgsSession->setListNamedArg(@listArgsSession);
	
	my $session = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$session->setItsType($Common::ConstValues::EDI_TRANSFER);
	my $ediSession = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
	$ediSession->setArgs($runTimeArgsSession);
	$session->setItsValue($ediSession);
	$deploy->setHeader($deployHeader);
	
	$deploy->setSession($session);
	my $deployBodyHash = $deploy->getBodyHash();
	$deployHeader->setBodyHash($deployBodyHash);
	my $deployHash = $deployHeader->getDeployHash();
	$deploy->setDeployHash($deployHash);
	my $util = new Common::Utils();
	# Setup approvals
	my $oneApproval = new GetDeploy::Approval();
	if ($isEd25519 == 1) {
		$oneApproval->setSigner($accountEd25519);
		my $ed25519 = new CryptoHandle::Ed25519Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $privateKey = Crypt::PK::Ed25519->new($Common::ConstValues::READ_ED25519_PRIVATE_KEY_FILE);
		my $signature = $ed25519->signMessage($hashAnscii,$privateKey);
		$signature = "01".$signature;
		$oneApproval->setSignature($signature);
	} else {
		$oneApproval->setSigner($accountSecp256k1);
		my $secp256k1 = new CryptoHandle::Secp256k1Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $privateKey = Crypt::PK::ECC->new($Common::ConstValues::READ_SECP256K1_PRIVATE_KEY_FILE);
		my $signature = $secp256k1->signMessage($hashAnscii,$privateKey);
		$signature = "02".$signature;
		$oneApproval->setSignature($signature);
	}
	my @listApprovals = ($oneApproval);
	$deploy->setApprovals(@listApprovals);
	return $deploy;
}
# This function does all the test
sub testAll {
	negativeTest();
}
sub positiveTest {
	# Positive test
	# Test put deploy with Secp256k1 account
	my $deployHash = testPutDeploy(0);
	ok(length($deployHash)>0, "Test put deploy with Secp256k1 account passed");
	# Test put deploy with Ed25519 account
	my $deployHash2 = testPutDeploy(1);
	ok(length($deployHash2)>0, "Test put deploy with Ed25519 account passed");
}
sub negativeTest {
	# Negative test
	my $putDeployRPC = new PutDeploy::PutDeployRPC();
	# Setup deploy with Ed25519 account
	# Negative path 1 - put deploy with wrong deploy hash - for ed25519 account
	my $deploy1 = setupDeploy(1,"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a","3000000000");
	$deploy1->setDeployHash("66273a933cd78da040d83165398cff94cbd0122dd297d9f3867a35ae633fdbb2","3000000000");
	my $error = $putDeployRPC->putDeploy($deploy1);
	ok($error eq $Common::ConstValues::ERROR_PUT_DEPLOY, "Test negative put deploy with Ed25519 account, wrong deploy hash, passed");
	# Negative path 2 - put deploy with wrong deploy hash - for secp256k1 account
	my $deploy2 = setupDeploy(0,"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a","3000000000");
	$deploy2->setDeployHash("62889cf406766131e99200acfd210290051e6391254b25411d265834c7ba8219","3000000000");
	my $error2 = $putDeployRPC->putDeploy($deploy2);
	ok($error2 eq $Common::ConstValues::ERROR_PUT_DEPLOY, "Test negative put deploy with Secp256k1 account, wrong deploy hash, passed");
 	# Negative path 3 - put a transfer deploy for Ed25519 account, to a wrong public key address, stored in toTransferPublicKey input
    my $deploy3 = setupDeploy(1,"011cfdde555e3000000300df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4","3000000000");
	$error = $putDeployRPC->putDeploy($deploy3);
	ok($error eq $Common::ConstValues::ERROR_PUT_DEPLOY, "Test negative put deploy with Ed25519 account, wrong target public key, passed");
    # Negative path 4 - put a transfer deploy for Secp256k1 account, to a wrong public key address, stored in toTransferPublicKey input
    my $deploy4 = setupDeploy(0,"bb0000002858ce861a3d47e3a8616f1918b4c68387c90d56aafc5efa49b71ebca32","3000000000");
	$error = $putDeployRPC->putDeploy($deploy4);
	ok($error eq $Common::ConstValues::ERROR_PUT_DEPLOY, "Test negative put deploy with Secp256k1 account, wrong target public key, passed");
    # Negative path 5 - put a transfer deploy for Ed25519 account, to a correct public key address, stored in toTransferPublicKey input, but wrong amount to send - too small amount to send
    # Try to send only 300, when the minimum amount is 2500000000
    my $deploy5 = setupDeploy(1,"01fd708b1df7264949b649c423395f882ac7f35732116c989a0edfed3166fbb729","300");
 	$error = $putDeployRPC->putDeploy($deploy5);
	ok($error eq $Common::ConstValues::ERROR_PUT_DEPLOY, "Test negative put deploy with Ed25519 account, sending insufficient amount, passed");
}
testAll();

