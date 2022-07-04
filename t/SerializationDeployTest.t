#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 10;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Serialization::CLTypeSerialization;
use CLValue::CLType;
use CLValue::CLValue;
use CLValue::CLParse;
use Common::ConstValues;
use Serialization::DeploySerializeHelper;
use GetDeploy::DeployHeader;
use GetDeploy::Approval;
use GetDeploy::Deploy;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;
use GetDeploy::ExecutableDeployItem::NamedArg;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub testAll {
	print("Deploy serialization test all called\n");
	testDeployHeaderSerialization();
	testDeployApprovalSerialization();
	testDeploySerialization();
}
sub testDeployHeaderSerialization {
	my $deployHeader = new GetDeploy::DeployHeader();
	$deployHeader->setAccount("01d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900c");
	$deployHeader->setTimestamp("2020-11-17T00:39:24.072Z");
	$deployHeader->setTTL("1h");
	$deployHeader->setGasPrice("1");
	$deployHeader->setBodyHash("4811966d37fe5674a8af4001884ea0d9042d1c06668da0c963769c3a01ebd08f");
	my @dependency = ("0101010101010101010101010101010101010101010101010101010101010101");
	$deployHeader->setDependencies(@dependency);
	$deployHeader->setChainName("casper-example");
	my $headerSerialization = new Serialization::DeploySerializeHelper();
	my $headerSerializationStr = $headerSerialization->serializeForHeader($deployHeader);
	ok($headerSerializationStr eq "01d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900ca856a4d37501000080ee36000000000001000000000000004811966d37fe5674a8af4001884ea0d9042d1c06668da0c963769c3a01ebd08f0100000001010101010101010101010101010101010101010101010101010101010101010e0000006361737065722d6578616d706c65","Test serialization for Deploy Header passed");
}

sub testDeployApprovalSerialization {
	my @listApprovals = ();
	# Test for Approval list with 1 element
	my $oneA = new GetDeploy::Approval();
	$oneA->setSigner("0149bae8d79362d088197f8f68c5e8431fa074f780d290a2b1988b7201872cb5bc");
	$oneA->setSignature("012d56b8a5620326484df6cdf770e6d2e054e64deabba5c4f34573bd6331239f8a4bfe2db9c14ec19b0cb4d6694bb3c1727e3d33501187391cfd47136840117b04");
	@listApprovals = ($oneA);
	my $serializationHelper = new Serialization::DeploySerializeHelper();
	my $approvalSerialization = $serializationHelper->serializeForDeployApproval(@listApprovals);
	ok($approvalSerialization eq "010000000149bae8d79362d088197f8f68c5e8431fa074f780d290a2b1988b7201872cb5bc012d56b8a5620326484df6cdf770e6d2e054e64deabba5c4f34573bd6331239f8a4bfe2db9c14ec19b0cb4d6694bb3c1727e3d33501187391cfd47136840117b04","Test serialization for Deploy Approvals Serialization passed");
}
sub testDeploySerialization {
	my $deploy = new GetDeploy::Deploy();
	
	# Setup for Deploy header
	my $deployHeader = new GetDeploy::DeployHeader();
	$deployHeader->setAccount("01d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900c");
	$deployHeader->setTimestamp("2020-11-17T00:39:24.072Z");
	$deployHeader->setTTL("1h");
	$deployHeader->setGasPrice("1");
	$deployHeader->setBodyHash("4811966d37fe5674a8af4001884ea0d9042d1c06668da0c963769c3a01ebd08f");
	my @dependency = ("0101010101010101010101010101010101010101010101010101010101010101");
	$deployHeader->setDependencies(@dependency);
	$deployHeader->setChainName("casper-example");
	$deploy->setHeader($deployHeader);
	
	# Setup for deploy payment
	
	my $payment = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$payment->setItsType($Common::ConstValues::EDI_STORED_CONTRACT_BY_NAME);
	my $edi_byname = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName();
	$edi_byname->setItsName("casper-example");
	$edi_byname->setEntryPoint("example-entry-point");
	
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1 NamedArgs
    my $oneA = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneA->setItsName("quantity");
    my $oneCLValue = new CLValue::CLValue();
	my $oneCLType = new CLValue::CLType();
	my $oneCLParse = new CLValue::CLParse();
	$oneCLType->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$oneCLValue->setCLType($oneCLType);
	$oneCLParse->setItsCLType($oneCLType);
	$oneCLParse->setItsValueStr("1000");
	$oneCLValue->setParse($oneCLParse);
	$oneA->setCLValue($oneCLValue);
	my $ra = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listA = ($oneA);
	$ra->setListNamedArg(@listA);
	$edi_byname->setArgs($ra);
	$payment->setItsValue($edi_byname);
	$deploy->setPayment($payment);
	
	# Setup for deploy session
	
	my $session = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$session->setItsType($Common::ConstValues::EDI_TRANSFER);
	my $ediSession = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1 NamedArgs
    my $oneNASession = new  GetDeploy::ExecutableDeployItem::NamedArg();
	$oneNASession->setItsName("amount");
	my $oneCLValueSession = new CLValue::CLValue();
	my $oneCLTypeSession = new CLValue::CLType();
	my $oneCLParseSession = new CLValue::CLParse();
	$oneCLTypeSession->setItsTypeStr($Common::ConstValues::CLTYPE_I32);
	$oneCLValueSession->setCLType($oneCLTypeSession);
	$oneCLParseSession->setItsCLType($oneCLTypeSession);
	$oneCLParseSession->setItsValueStr("1000");
	$oneCLValueSession->setParse($oneCLParseSession);
	$oneNASession->setCLValue($oneCLValueSession);
	my $raSession = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listASession = ($oneNASession);
	$raSession->setListNamedArg($oneNASession);
	$ediSession->setArgs($raSession);
	$session->setItsValue($ediSession);
	$deploy->setSession($session);
	
	# Setup approvals
	my @listApprovals = ();
	my $oneApproval = new GetDeploy::Approval();
	$oneApproval->setSigner("01d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900c");
	$oneApproval->setSignature("012dbf03817a51794a8e19e0724884075e6d1fbec326b766ecfa6658b41f81290da85e23b24e88b1c8d9761185c961daee1adab0649912a6477bcd2e69bd91bd08");
	@listApprovals = ($oneApproval);
	$deploy->setApprovals(@listApprovals);
	$deploy->setDeployHash("01da3c604f71e0e7df83ff1ab4ef15bb04de64ca02e3d2b78de6950e8b5ee187");
	
	# Get the deploy serialization
	my $serializationHelper = new Serialization::DeploySerializeHelper();
	my $deploySerialization = $serializationHelper->serializeForDeploy($deploy);
	ok($deploySerialization eq "01d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900ca856a4d37501000080ee36000000000001000000000000004811966d37fe5674a8af4001884ea0d9042d1c06668da0c963769c3a01ebd08f0100000001010101010101010101010101010101010101010101010101010101010101010e0000006361737065722d6578616d706c6501da3c604f71e0e7df83ff1ab4ef15bb04de64ca02e3d2b78de6950e8b5ee187020e0000006361737065722d6578616d706c65130000006578616d706c652d656e7472792d706f696e7401000000080000007175616e7469747904000000e803000001050100000006000000616d6f756e7404000000e8030000010100000001d9bf2148748a85c89da5aad8ee0b0fc2d105fd39d41a4c796536354f0ae2900c012dbf03817a51794a8e19e0724884075e6d1fbec326b766ecfa6658b41f81290da85e23b24e88b1c8d9761185c961daee1adab0649912a6477bcd2e69bd91bd08","Test serialization for Deploy Serialization passed");
	
}

testAll();
1;