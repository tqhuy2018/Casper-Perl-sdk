#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 59;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

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
	my $totalProof = @proofs;
	ok($totalProof == 100, "Test total proof = 100, Passed");
	my $firstProof = $proofs[0];
	ok($firstProof->getPublicKey() eq "0101f5170c996cc02b581d8200f0d95a737840234f31bf1fa21cca35137f8507b0", "Test 1, first proof public key, Passed");
	ok($firstProof->getSignature() eq "011eff8fe46b617dde8ff3c694307fe23584f1f0cfba6f4827e13c7199f35f8525059c3232fddbc693189a1d8e9ebe0f481666c63b8582c662dbc7be9f17ae890d", "Test 1, first proof signature, Passed");
	
	# Test 2: Call with block height
	$bi->setBlockType("height");
	$bi->setBlockHeight("694679");
	my $postParamHeightStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $getBResult2 = $getBlock->getBlock($postParamHeightStr);
	ok($getBResult2->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $block2 = $getBResult2->getBlock();
	ok($block2->getBlockHash() eq "cadcf10d323ad4dc9b5b11f1e940a8d51287888a9d7322e39302f911181edcd0","Test 2 block hash value, Passed");
	
	# block header assertion
	$header = $block2->getHeader();
	ok($header->getParentHash() eq "44d3dd56284eb635289f9947956eb37c2b35e41de790867894fd8728af12b157", "Test 2 block header parent hash, Passed");
	ok($header->getStateRootHash() eq "32c36e787fb8a2eac0a726f6d42742300e3c7c96b08a858406cc90968acddbf7", "Test 2 block header state root hash, Passed");
	ok($header->getBodyHash() eq "949acecbdc9cfcf7b11c8768083fd85c2958105a0fbdfdaa08e61805ca80bb3e", "Test 2 block header body hash, Passed");
	ok($header->getRandomBit() == 1, "Test 2 block header random bit, Passed");
	ok($header->getAccumulatedSeed() eq "320bdd706cf5a29f5744e8c7346ba8828f2b2506e47e3cb2369f49f7e2ac6eb5", "Test 2 block header accumulated_seed, Passed");
	ok($header->getTimestamp() eq "2022-04-15T08:45:23.840Z", "Test 2 block header timestamp, Passed");
	ok($header->getEraId() eq "4447", "Test 2 block header era id, Passed");
	ok($header->getHeight() eq "694679", "Test 2 block header height, Passed");
	ok($header->getProtocolVersion() eq "1.4.5", "Test 2 block header protocol_version, Passed");
	
	# block body assertion
	$body = $block2->getBody();
	ok($body->getProposer() eq "01a03c687285634a0115c0af1015ab0a53809f4826ee863c94e32ce48bcfdf447d", "Test 2 block body proposer, Passed");
	@listDeployHash = $body->getDeployHashes();
	$totalDH = @listDeployHash;
	ok($totalDH == 5, "Test 2, block body total deploy hash = 5 , Passed");
	$counter = 0;
	foreach(@listDeployHash) {
		if($counter == 0) {
			ok($_ eq "1c5a7be92131e6130ca97ae50a526b0c875bfe45aca300b732fa67731708a522", "Test2 block body deploy hash 1st value, Passed");
		} elsif($counter == 1) {
			ok($_ eq "120d335ec367fbe37a245e37e7dc9a31ce0b9537bba8042300af53e5f6aa0cad", "Test2 block body deploy hash 2nd value, Passed");
		} elsif($counter == 2) {
			ok($_ eq "7064cb1bcf9414da181684452f5b2a47499c9f4582cd85b897fbedaff54a2a04", "Test2 block body deploy hash 3rd value, Passed");
		} elsif($counter == 3) {
			ok($_ eq "71909e9568ed0d8cbb60f31e25102db485c3cd0d0f5623a0d4e5f89afe4c90c2", "Test2 block body deploy hash 4th value, Passed");
		} elsif($counter == 4) {
			ok($_ eq "d88ba9fdceff53b5d4803534a41470b191e6f76eb7a936f85b8fcb4fa42a7390", "Test2 block body deploy hash 5th value, Passed");
		} 
		$counter ++;
	}
	@listTransferHash = $body->getTransferHashes();
	$totalTH = @listTransferHash;
	ok($totalTH == 0, "Test 1, block body total transfer hash = 0 , Passed");
	
	# JsonProof assertion
	@proofs = $block2->getProofs();
	$totalProof = @proofs;
	ok($totalProof == 99, "Test total proof = 99, Passed");
	$firstProof = $proofs[0];
	ok($firstProof->getPublicKey() eq "0101f5170c996cc02b581d8200f0d95a737840234f31bf1fa21cca35137f8507b0", "Test 1, first proof public key, Passed");
	ok($firstProof->getSignature() eq "0150e4cc09528fa642bc725b017cfdd3219f6898612f9c18ec819fa7510c6fe09bb55ccdd8474ef9d94e061b8bc158147ab6e647921e3fa8b8ecaa430513d2210a", "Test 1, first proof signature, Passed");

	# Test 3: Call with no parameter, latest block transfer is retrieved;
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $getBResult3 = $getBlock->getBlock($postParamNoneStr);
	ok($getBResult3->getApiVersion() eq "1.4.5", "Test 3 api_version, Passed");
	my $block3 = $getBResult3->getBlock();
	ok(length($block3->getBlockHash()) > 0,"Test 3 block hash value, Passed");
	# block header assertion
	$header = $block3->getHeader();
	ok(length($header->getParentHash()) > 0, "Test 3 block header parent hash, Passed");
	ok(length($header->getStateRootHash()) > 0, "Test 3 block header state root hash, Passed");
	ok(length($header->getBodyHash()) > 0, "Test 3 block header body hash, Passed");
	
	ok(length($header->getAccumulatedSeed()) > 0, "Test 3 block header accumulated_seed, Passed");
	ok(length($header->getTimestamp()) > 0 , "Test 3 block header timestamp, Passed");
	ok(length($header->getEraId()) > 0, "Test 3 block header era id, Passed");
	ok(looks_like_number($header->getHeight()) == 1, "Test 3 block header height, Passed");
	ok(length($header->getProtocolVersion()) > 0 , "Test 3 block header protocol_version, Passed");
	
	# block body assertion
	$body = $block3->getBody();
	ok(length($body->getProposer()) > 0 , "Test 3 block body proposer, Passed");
	
	# JsonProof assertion
	@proofs = $block3->getProofs();
	$totalProof = @proofs;
	ok($totalProof > 0, "Test total proof > 0, Passed");
	$firstProof = $proofs[0];
	ok(length($firstProof->getPublicKey()) > 0, "Test 3, first proof public key, Passed");
	ok(length($firstProof->getSignature()) > 0, "Test 3, first proof signature, Passed");
	
	# Negative test: Test 4: Call with wrong block hash, latest block transfer is retrieved;
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $getBesult4 = $getBlock->getBlock($postParamStr4);
	ok($getBesult4->getApiVersion() eq "1.4.5", "Test 4 api_version, Passed");
	
	# Negative test: Test 5: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $error = $getBlock->getBlock($postParamStr5);
	ok($error->getErrorCode() eq "-32001", "Test error get block with block height > U64.max, error code checked, Passed");
	ok($error->getErrorMessage() eq "block not known", "Test error get block with block height > U64.max, error is thrown, error message checked, Passed");
	
	# Negative test: Test 6: Call with too big block height with the height > U64.Max , error is thrown;
	$bi->setBlockType("height");
	$bi->setBlockHeight("75052400");
	my $postParamStr6 = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
	my $error2 = $getBlock->getBlock($postParamStr6);
	ok($error2->getErrorCode() eq "-32001", "Test error get block with block height > U64.max, error code checked, Passed");
	ok($error2->getErrorMessage() eq "block not known", "Test error get block with block height > U64.max, error is thrown, error message checked, Passed");
}
getBlock();