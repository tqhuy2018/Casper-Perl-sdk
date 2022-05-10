#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 59;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

use Common::ConstValues;
use GetItem::GetItemParams;
use GetItem::GetItemResult;
use GetItem::GetItemRPC;

sub getItem {
	my $getItemRPC = new GetItem::GetItemRPC();
	my $getItemParams = new GetItem::GetItemParams();
	# Test 1: Test for StoredValue of type CLValue
	$getItemParams->setStateRootHash("340a09b06bae99d868c68111b691c70d9d5a253c0f2fd7ee257a04a198d3818e");
	$getItemParams->setKey("uref-ba620eee2b06c6df4cd8da58dd5c5aa6d42f3a502de61bb06dc70b164eee4119-007");
	my $paramStr = $getItemParams->generateParameterStr();
	print "\n".$paramStr."\n";
	my $getItemResult = $getItemRPC->getItem($paramStr);
	ok($getItemResult->getApiVersion() eq "1.4.5", "Test 1 api version, Passed");
	ok(length($getItemResult->getMerkleProof()) == 35056, "Test 1, merkle proof, Passed"); 
}
getItem();