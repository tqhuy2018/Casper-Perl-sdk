#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 12;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
use GetBlockTransfers::GetBlockTransfersResult;
use GetBlockTransfers::GetBlockTransfersRPC;
use Common::BlockIdentifier;

sub getBlockTransfers {
	my $getBlockTransfers = new GetBlockTransfers::GetBlockTransfersRPC();
	my $bi = new Common::BlockIdentifier();
	
	# Test 1: Call with block hash
	$bi->setBlockType("hash");
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	my $getBTResult = $getBlockTransfers->getBlockTransfers($postParamStr);
	ok($getBTResult->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	ok($getBTResult->getBlockHash() eq "d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e", "Test 1 block_hash, Passed");
	
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("12345");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	my $getBTResult2 = $getBlockTransfers->getBlockTransfers($postParamHeightStr);
	ok($getBTResult2->getApiVersion() eq "1.4.5", "Test 2 api_version, Passed");
	ok($getBTResult2->getBlockHash() eq "bbf21fe52a97c64e6b95098b1f2e098337efc9f9b63ae2ba0de37ef5a0da4b6f", "Test 2 block_hash, Passed");

	# Test 3: Call with no parameter, latest block transfer is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	print "\n".$postParamNoneStr."\n";
	my $getBTResult3 = $getBlockTransfers->getBlockTransfers($postParamNoneStr);
	ok($getBTResult3->getApiVersion() eq "1.4.5", "Test 3 api_version, Passed");
	ok(length($getBTResult3->getBlockHash()) > 0, "Test 3 block_hash, Passed");
	
	# Negative test: Test 4: Call with wrong block hash, latest block transfer is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	print "\n".$postParamStr4."\n";
	my $getBTResult4 = $getBlockTransfers->getBlockTransfers($postParamStr4);
	ok($getBTResult4->getApiVersion() eq "1.4.5", "Test 4 api_version, Passed");
	ok(length($getBTResult4->getBlockHash()) > 0, "Test 4 block_hash, Passed");
	
	# Negative test: Test 5: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	print "\n".$postParamStr5."\n";
	my $error = $getBlockTransfers->getBlockTransfers($postParamStr5);
	ok($error->getErrorCode() eq "-32001", "Test error get state root hash with block height > U64.max, error code checked, Passed");
	ok($error->getErrorMessage() eq "block not known", "Test error get state root hash with block height > U64.max, error is thrown, error message checked, Passed");
	
	# Negative test: Test 6: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("75052400");
	my $postParamStr6 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	print "\n".$postParamStr6."\n";
	my $error2 = $getBlockTransfers->getBlockTransfers($postParamStr6);
	ok($error2->getErrorCode() eq "-32001", "Test error get state root hash with block height > U64.max, error code checked, Passed");
	ok($error2->getErrorMessage() eq "block not known", "Test error get state root hash with block height > U64.max, error is thrown, error message checked, Passed");
}
getBlockTransfers();