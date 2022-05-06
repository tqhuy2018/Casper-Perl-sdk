#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 363;

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
use Common::BlockIdentifier;
use GetStateRootHash::GetStateRootHashRPC;

sub getStateRootHash {
	my $bi = new Common::BlockIdentifier();
	# Test 1: Call with block hash
	$bi->setBlockType("hash");
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam();
	my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash1 = $getStateRootHashRPC->getStateRootHash($postParamStr);
	print "state root hash 1 :".$stateRootHash1."\n";
	ok($stateRootHash1 eq "6da6cb8ff1e35656fba9a71868af803abef40dd6fce6161d2a18fe339a0525cb", "Test get state root hash based on block_identifier of type hash, Passed");
	
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("1234");
	my $postParamHeightStr = $bi->generatePostParam();
	my $getStateRootHashRPC2 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash2 = $getStateRootHashRPC2->getStateRootHash($postParamHeightStr);
	print "state root hash 2 :".$stateRootHash2."\n";
	ok($stateRootHash2 eq "dc8e7315e3421ccf3f25281d03dce28b7cda688a8e1d6d8fc39d47b064d2ef67", "Test get state root hash based on block_identifier of type height, Passed");
	
	# Test 3: Call with no parameter, latest state root hash is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamNoneStr;
	my $getStateRootHashRPC3 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash3 = $getStateRootHashRPC3->getStateRootHash($postParamNoneStr);
	print "state root hash 3 :".$stateRootHash3."\n";
	ok(length($stateRootHash3) > 0, "Test get state root hash with block identifier set with no param - latest state_root_hash is retrieved, Passed");
	
	# Test 4: Call with wrong block hash, latest state root hash is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr4;
	my $getStateRootHashRPC4 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash4 = $getStateRootHashRPC4->getStateRootHash($postParamStr4);
	print "state root hash 4 :".$stateRootHash4."\n";
	ok(length($stateRootHash4) > 0, "Test get state root hash with wrong block identifier hash - latest state_root_hash is retrieved, Passed");
	
	# Test 5: Call with too big block height, error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam();
	my $getStateRootHashRPC5 = new GetStateRootHash::GetStateRootHashRPC();
	
	try{
		$getStateRootHashRPC5->getStateRootHash($postParamStr5);
	} catch Error::Simple with {
	     my $err = shift;
	};
}
getStateRootHash();