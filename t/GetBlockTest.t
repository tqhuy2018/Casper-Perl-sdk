#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 12;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
use GetBlock::GetBlockResult;
use GetBlock::GetBlockRPC;
use Common::BlockIdentifier;

sub getBlock {
	my $getBlock = new GetBlock::GetBlockRPC();
	my $bi = new Common::BlockIdentifier();
	
	# Test 1: Call with block hash
	$bi->setBlockType("hash");
	$bi->setBlockHash("fe35810a3dcfbf853b9d3ac2445fe1fa4aaab047d881d95d9009dc257d396e7e");
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $getBResult = $getBlock->getBlock($postParamStr);
	ok($getBResult->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $block = $getBResult->getBlock();
	ok($block->getBlockHash() eq "fe35810a3dcfbf853b9d3ac2445fe1fa4aaab047d881d95d9009dc257d396e7e","Test 1 block hash value, Passed");
	
	# block header assertion
	my $header = $block->getHeader();
	ok($header->getParentHash() eq "df381e8a75ff5d2bf6ec86a032f14fcb20777a97b437ff5c7f9d4b444176c537", "Test 1 block header parent hash, Passed");
	ok($header->getStateRootHash() eq "bb3a1f9325c1da6820358f9b4981b84e0c28d924b0ef5776f6bb4cdd1328e261", "Test 1 block header state root hash, Passed");
	ok($header->getBodyHash() eq "6e78696e3840343c137ea2d4df8bc32f2807116d020b494dfda1aafca91167bc", "Test 1 block header body hash, Passed");
	ok($header->getRandomBit() == 0, "Test 1 block header random bit, Passed");
	ok($header->getAccumulatedSeed() eq "cee004428f64b0b5b8bc53c2755d976b6d83199a537cdb1ca433230a5ebd8735", "Test 1 block header accumulated_seed, Passed");
	ok($header->getTimestamp() eq "2022-04-07T03:14:18.240Z", "Test 1 block header timestamp, Passed");
	ok($header->getEraId() eq "4348", "Test 1 block header era id, Passed");
	ok($header->getHeight() eq "673041", "Test 1 block header height, Passed");
	ok($header->getProtocolVersion() eq "1.4.5", "Test 1 block header protocol_version, Passed");
	
	# block body assertion
	my $body = $block->getBody();
	ok($body->getProposer() eq "01a03c687285634a0115c0af1015ab0a53809f4826ee863c94e32ce48bcfdf447d", "Test 1 block body proposer, Passed");
	my @listDeployHash = $body->getDeployHashes();
	my $totalDH = @listDeployHash;
	ok($totalDH == 1, "Test 1, block body total deploy hash = 1 , Passed");
	my $counter = 0;
	foreach(@listDeployHash) {
		if($counter == 0) {
			ok($_ eq "db058cbd45f55d07f8b7a54c025bfb808ce748d516e0ebc130d635e3974068cf", "Test1 block body deploy hash first value, Passed");
		}
		$counter ++;
	}
	my @listTransferHash = $body->getTransferHashes();
	my $totalTH = @listTransferHash;
	ok($totalTH == 0, "Test 1, block body total transfer hash = 0 , Passed");
	
	# JsonProof assertion
	
	my @proofs = $block->getProofs();
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("12345");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $getBResult2 = $getBlock->getBlock($postParamHeightStr);
	ok($getBResult2->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $block2 = $getBResult2->getBlock();
	ok($block2->getBlockHash() eq "d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e","Test 1 block hash value, Passed");

	# Test 3: Call with no parameter, latest block transfer is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	print "\n".$postParamNoneStr."\n";
	my $getBResult3 = $getBlock->getBlock($postParamNoneStr);
	ok($getBResult3->getApiVersion() eq "1.4.5", "Test 3 api_version, Passed");
	my $block3 = $getBResult3->getBlock();
	ok(length($block3->getBlockHash()) > 0,"Test 3 block hash value, Passed");
	
	# Negative test: Test 4: Call with wrong block hash, latest block transfer is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	print "\n".$postParamStr4."\n";
	my $getBesult4 = $getBlock->getBlock($postParamStr4);
	ok($getBesult4->getApiVersion() eq "1.4.5", "Test 4 api_version, Passed");
	
	# Negative test: Test 5: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	print "\n".$postParamStr5."\n";
	my $error = $getBlock->getBlock($postParamStr5);
	ok($error->getErrorCode() eq "-32001", "Test error get state root hash with block height > U64.max, error code checked, Passed");
	ok($error->getErrorMessage() eq "block not known", "Test error get state root hash with block height > U64.max, error is thrown, error message checked, Passed");
	
	# Negative test: Test 6: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("75052400");
	my $postParamStr6 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	print "\n".$postParamStr6."\n";
	my $error2 = $getBlock->getBlock($postParamStr6);
	ok($error2->getErrorCode() eq "-32001", "Test error get state root hash with block height > U64.max, error code checked, Passed");
	ok($error2->getErrorMessage() eq "block not known", "Test error get state root hash with block height > U64.max, error is thrown, error message checked, Passed");
}
getBlock();