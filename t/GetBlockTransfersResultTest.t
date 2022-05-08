#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 18;

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
	ok($getBTResult->getApiVersion() eq "1.4.5", "Test api_version, Passed");
	ok($getBTResult->getBlockHash() eq "d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e", "Test block_hash, Passed");
	
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("12345");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
	my $getBTResult2 = $getBlockTransfers->getBlockTransfers($postParamHeightStr);
	ok($getBTResult2->getApiVersion() eq "1.4.5", "Test api_version, Passed");
	ok($getBTResult2->getBlockHash() eq "bbf21fe52a97c64e6b95098b1f2e098337efc9f9b63ae2ba0de37ef5a0da4b6f", "Test block_hash, Passed");

	
}
getBlockTransfers();