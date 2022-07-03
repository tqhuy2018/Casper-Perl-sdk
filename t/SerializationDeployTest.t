#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 34;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Serialization::CLTypeSerialization;
use CLValue::CLType;
use Common::ConstValues;
use Serialization::DeploySerializeHelper;
use GetDeploy::DeployHeader;

sub testAll {
	print("Deploy serialization test all called\n");
	testDeployHeaderSerialization();
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
	$headerSerialization->serializeForHeader($deployHeader);
}
testAll();
1;