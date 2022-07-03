#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 10;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Serialization::CLTypeSerialization;
use CLValue::CLType;
use Common::ConstValues;
use Serialization::DeploySerializeHelper;
use GetDeploy::DeployHeader;
use GetDeploy::Approval;

sub testAll {
	print("Deploy serialization test all called\n");
	testDeployHeaderSerialization();
	testDeployApprovalSerialization();
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
	
}
testAll();
1;