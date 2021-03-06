#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 7;

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
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash1 = $getStateRootHashRPC->getStateRootHash($postParamStr);
	ok($stateRootHash1 eq "6da6cb8ff1e35656fba9a71868af803abef40dd6fce6161d2a18fe339a0525cb", "Test get state root hash based on block_identifier of type hash, Passed");
	
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("1234");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC2 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash2 = $getStateRootHashRPC2->getStateRootHash($postParamHeightStr);
	ok($stateRootHash2 eq "dc8e7315e3421ccf3f25281d03dce28b7cda688a8e1d6d8fc39d47b064d2ef67", "Test get state root hash based on block_identifier of type height, Passed");
	
	# Test 3: Call with no parameter, latest state root hash is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC3 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash3 = $getStateRootHashRPC3->getStateRootHash($postParamNoneStr);
	ok(length($stateRootHash3) > 0, "Test get state root hash with block identifier set with no param - latest state_root_hash is retrieved, Passed");
	
	# Negative test: Test 4: Call with wrong block hash, latest state root hash is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC4 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash4 = $getStateRootHashRPC4->getStateRootHash($postParamStr4);
	ok(length($stateRootHash4) > 0, "Test get state root hash with wrong block identifier hash - latest state_root_hash is retrieved, Passed");
	# Negative test: Test 5: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC5 = new GetStateRootHash::GetStateRootHashRPC();
	my $error = $getStateRootHashRPC5->getStateRootHash($postParamStr5);
	ok($error->getErrorCode() eq "-32001", "Test error get state root hash with block height > U64.max, error code checked, Passed");
	ok($error->getErrorMessage() eq "block not known", "Test error get state root hash with block height > U64.max, error is thrown, error message checked, Passed");
	# Negative test: Test 6: Call with too big block height with the height <= U64.Max, latest state root hash is retrieved;
	$bi->setBlockType("height");
	$bi->setBlockHeight("75052400");
	my $postParamStr6 = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC6 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash6 = $getStateRootHashRPC5->getStateRootHash($postParamStr6);
	ok(length($stateRootHash6) > 0, "Test get state root hash with wrong block identifier height, but value <= U64.max value - latest state_root_hash is retrieved, Passed");
}
getStateRootHash();