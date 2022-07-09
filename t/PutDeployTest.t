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
	# These accounts are from Swift
	#my $accountEd25519 = "0152a685e0edd9060da4a0d52e500d65e21789df3cbfcb878c91ffeaea756d1c53";
	#my $accountSecp256k1 = "0202572ee4c44b925477dc7cd252f678e8cc407da31b2257e70e11cf6bcb278eb04b";
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
	print $date, "\n";
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
	print "Deploy hash is:".$deployBodyHash."\n";
	my $deployHash = $deployHeader->getDeployHash();
	print("Deploy hash is:".$deployHash."\n");
	$deploy->setDeployHash($deployHash);
	my $util = new Common::Utils();
	# Setup approvals
	my $oneApproval = new GetDeploy::Approval();
	if ($isEd25519 == 1) {
		$oneApproval->setSigner($accountEd25519);
		my $ed25519 = new CryptoHandle::Ed25519Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $signature = $ed25519->signMessage($hashAnscii);
		$signature = "01".$signature;
		print "Signature is:".$signature."\n";
		$oneApproval->setSignature($signature);
	} else {
		$oneApproval->setSigner($accountSecp256k1);
		my $secp256k1 = new CryptoHandle::Secp256k1Handle();
		my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
		my $privateKey = Crypt::PK::ECC->new("./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem");
		my $signature = $secp256k1->signMessage($hashAnscii,$privateKey);
		$signature = "02".$signature;
		print "Signature is:".$signature."\n";
		$oneApproval->setSignature($signature);
	}
	my @listApprovals = ($oneApproval);
	$deploy->setApprovals(@listApprovals);
	my $putDeployRPC = new PutDeploy::PutDeployRPC();
	$putDeployRPC->putDeploy($deploy);
}

#testPutDeploy(0);
testPutDeploy(0);