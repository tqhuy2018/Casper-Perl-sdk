#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 8;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
#use Digest::BLAKE2 qw(blake2b blake2b_hex blake2b_base64 blake2b_base64url blake2b_ascii85);
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
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;
use GetDeploy::ExecutableDeployItem::NamedArg;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;
use Serialization::ExecutableDeployItemSerializationHelper;

sub testAll {
	# blake2b
#print blake2b('Japan Break Industries');
#print blake2b_hex('Japan Break Industries');
	testDeployHeaderSerialization();
	testDeployApprovalSerialization();
	testForExecutableDeployItemTransfer();
	testForExecutableDeployItemStoredContractByName();
	testForExecutableDeployItemStoredContractByHash();
	testForExecutableDeployItemStoredVersionedContractByHash();
	testForExecutableDeployItemStoredVersionedContractByName();
	testDeploySerialization();
}

# Deploy header serialization assertion
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

# Deploy approvals serialization assertion
sub testDeployApprovalSerialization {
	my @listApprovals = ();
	# Test for Approval list with 1 element
	my $oneA = new GetDeploy::Approval();
	$oneA->setSigner("0149bae8d79362d088197f8f68c5e8431fa074f780d290a2b1988b7201872cb5bc");
	$oneA->setSignature("012d56b8a5620326484df6cdf770e6d2e054e64deabba5c4f34573bd6331239f8a4bfe2db9c14ec19b0cb4d6694bb3c1727e3d33501187391cfd47136840117b04");
	@listApprovals = ($oneA);
	my $serializationHelper = new Serialization::DeploySerializeHelper();
	my $approvalSerialization = $serializationHelper->serializeForDeployApproval(@listApprovals);
	ok($approvalSerialization eq "010000000149bae8d79362d088197f8f68c5e8431fa074f780d290a2b1988b7201872cb5bc012d56b8a5620326484df6cdf770e6d2e054e64deabba5c4f34573bd6331239f8a4bfe2db9c14ec19b0cb4d6694bb3c1727e3d33501187391cfd47136840117b04","Test serialization for Deploy Approvals passed");
}

# Deploy serialization assertion
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

# EDI_TRANSFER assertion
sub testForExecutableDeployItemTransfer {
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
	my $ediSerializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $serializationTransfer = $ediSerializationHelper->serializeForExecutableDeployItem($session);
	ok($serializationTransfer eq "050100000006000000616d6f756e7404000000e803000001","Test serialization for ExecutableDeployItem_Transfer passed");
}

# EDI_STORE_CONTRACT_BY_NAME assertion
sub testForExecutableDeployItemStoredContractByName {
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
	my $ediSerializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $serializationStoredByName = $ediSerializationHelper->serializeForExecutableDeployItem($payment);
	ok($serializationStoredByName eq "020e0000006361737065722d6578616d706c65130000006578616d706c652d656e7472792d706f696e7401000000080000007175616e7469747904000000e803000001","Test serialization for ExecutableDeployItem_StoredContractByName passed");
}

# EDI_STORE_CONTRACT_BY_HASH assertion
sub testForExecutableDeployItemStoredContractByHash {
	my $ediHash = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$ediHash->setItsType($Common::ConstValues::EDI_STORED_CONTRACT_BY_HASH);
	my $ediHashIn = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash();
	$ediHashIn->setItsHash("33fb5db59a34a95bd8ebf1feb0c09f4aa580d951e2666d1c656e73b675ee2c4a");
	$ediHashIn->setEntryPoint("example-entry-point");
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1 NamedArgs
    my $oneA = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneA->setItsName("quantity");
    my $oneCLValue = new CLValue::CLValue();
	my $oneCLType = new CLValue::CLType();
	my $oneCLParse = new CLValue::CLParse();
	$oneCLType->setItsTypeStr($Common::ConstValues::CLTYPE_U512);
	$oneCLValue->setCLType($oneCLType);
	$oneCLParse->setItsCLType($oneCLType);
	$oneCLParse->setItsValueStr("94000000000");
	$oneCLValue->setParse($oneCLParse);
	$oneA->setCLValue($oneCLValue);
	my $ra = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listA = ($oneA);
	$ra->setListNamedArg(@listA);
	$ediHashIn->setArgs($ra);
	$ediHash->setItsValue($ediHashIn);
	my $ediSerializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $serializationStoredByHash = $ediSerializationHelper->serializeForExecutableDeployItem($ediHash);
	ok($serializationStoredByHash eq "0133fb5db59a34a95bd8ebf1feb0c09f4aa580d951e2666d1c656e73b675ee2c4a130000006578616d706c652d656e7472792d706f696e7401000000080000007175616e746974790600000005002cd6e21508","Test serialization for ExecutableDeployItem_StoredContractByHash passed");
}

# EDI_STORE_VERSIONED_CONTRACT_BY_HASH assertion
sub testForExecutableDeployItemStoredVersionedContractByHash {
	my $ediHash = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$ediHash->setItsType($Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_HASH);
	my $ediHashIn = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash();
	$ediHashIn->setItsHash("9571c94fac8598c5e3669c3f3ae6e4e517488b88b45588c3fec6ac613aca9baa");
	$ediHashIn->setEntryPoint("res");
	$ediHashIn->setVersion($Common::ConstValues::NULL_VALUE);
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1 NamedArgs
    my $oneA = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneA->setItsName("target");
    my $oneCLValue = new CLValue::CLValue();
	my $oneCLType = new CLValue::CLType();
	my $oneCLParse = new CLValue::CLParse();
	$oneCLType->setItsTypeStr($Common::ConstValues::CLTYPE_PUBLIC_KEY);
	$oneCLValue->setCLType($oneCLType);
	$oneCLParse->setItsCLType($oneCLType);
	$oneCLParse->setItsValueStr("01394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b");
	$oneCLValue->setParse($oneCLParse);
	$oneA->setCLValue($oneCLValue);
	my $ra = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listA = ($oneA);
	$ra->setListNamedArg(@listA);
	$ediHashIn->setArgs($ra);
	$ediHash->setItsValue($ediHashIn);
	my $ediSerializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $serializationStoredByHash = $ediSerializationHelper->serializeForExecutableDeployItem($ediHash);
	#print($serializationStoredByHash."\n");
	ok($serializationStoredByHash eq "039571c94fac8598c5e3669c3f3ae6e4e517488b88b45588c3fec6ac613aca9baa000300000072657301000000060000007461726765742100000001394476bd8202887ac0e42ae9d8f96d7e02d81cc204533506f1fd199e95b1fd2b16","Test serialization for ExecutableDeployItem_StoredVersionedContractByHash passed");
}

# EDI_STORE_VERSIONED_CONTRACT_BY_NAME assertion
sub testForExecutableDeployItemStoredVersionedContractByName {
	my $ediHash = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem();
	$ediHash->setItsType($Common::ConstValues::EDI_STORED_VERSIONED_CONTRACT_BY_NAME);
	my $ediHashIn = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName();
	$ediHashIn->setItsName("Hello, World!");
	$ediHashIn->setEntryPoint("res");
	$ediHashIn->setVersion("1234");
	# set up RuntimeArgs with 1 element of NamedArg only
    # setup 1 NamedArgs
    my $oneA = new GetDeploy::ExecutableDeployItem::NamedArg();
    $oneA->setItsName("target");
    my $oneCLValue = new CLValue::CLValue();
	my $oneCLType = new CLValue::CLType();
	my $oneCLParse = new CLValue::CLParse();
	$oneCLType->setItsTypeStr($Common::ConstValues::CLTYPE_U64);
	$oneCLValue->setCLType($oneCLType);
	$oneCLParse->setItsCLType($oneCLType);
	$oneCLParse->setItsValueStr("1642167289561");
	$oneCLValue->setParse($oneCLParse);
	$oneA->setCLValue($oneCLValue);
	my $ra = new GetDeploy::ExecutableDeployItem::RuntimeArgs();
	my @listA = ($oneA);
	$ra->setListNamedArg(@listA);
	$ediHashIn->setArgs($ra);
	$ediHash->setItsValue($ediHashIn);
	my $ediSerializationHelper = new Serialization::ExecutableDeployItemSerializationHelper();
	my $serializationStoredByHash = $ediSerializationHelper->serializeForExecutableDeployItem($ediHash);
	ok($serializationStoredByHash eq "040d00000048656c6c6f2c20576f726c642101d204000003000000726573010000000600000074617267657408000000d946cc587e01000005","Test serialization for ExecutableDeployItem_StoredVersionedContractByName passed");
}
testAll();
1;