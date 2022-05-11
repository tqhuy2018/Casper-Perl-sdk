#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 66;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

use Common::ConstValues;
use GetAuction::GetAuctionInfoResult;
use GetAuction::GetAuctionInfoRPC;
use Common::BlockIdentifier;

# Test 1: Call with block hash
sub getAuction1 {
	my $getAuction = new GetAuction::GetAuctionInfoRPC();
	my $bi = new Common::BlockIdentifier();
	$bi->setBlockType("hash");
	$bi->setBlockHash("fe35810a3dcfbf853b9d3ac2445fe1fa4aaab047d881d95d9009dc257d396e7e");
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_AUCTION);
	print "\n".$postParamStr."\n";
	my $getAResult = $getAuction->getAuction($postParamStr);
	ok($getAResult->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $as = $getAResult->getAuctionState();
	ok($as->getStateRootHash() eq "bb3a1f9325c1da6820358f9b4981b84e0c28d924b0ef5776f6bb4cdd1328e261","Test 1 state root hash value, Passed");
	ok($as->getBlockHeight() eq "673041","Test 1 block height value, Passed");
	my @listEV = $as->getEraValidators();
	my $totalEV = @listEV;
	ok($totalEV == 2, "Test 1, total EraValidators = 2 , Passed");
	my $oneEV = $listEV[0];
	ok($oneEV->getEraId() eq "4348", "Test 1st EraValidators, era id value, Passed");
	my @listVW = $oneEV->getValidatorWeights();
	my $totalVW = @listVW;
	ok($totalVW > 0, "Test 2, EraValidators, total ValidatorWeights, Passed");
	my $vw1 = $listVW[0];
	ok($vw1->getPublicKey() eq "0101f5170c996cc02b581d8200f0d95a737840234f31bf1fa21cca35137f8507b0","Test 1, EraValidators, 1st ValidatorWeights - public_key, Passed");
	ok($vw1->getWeight() eq "1285021522858","Test 1, EraValidators, 1st ValidatorWeights - weight, Passed");
	$vw1 = $listVW[1];
	ok($vw1->getPublicKey() eq "01028e248170a7f328bf7a04696d8f271a1debb54763e05e537eefc1cf24531bc7","Test 1, EraValidators, 2nd ValidatorWeights - public_key, Passed");
	ok($vw1->getWeight() eq "3488957206790","Test 1, EraValidators, 2nd ValidatorWeights - weight, Passed");
	$vw1 = $listVW[2];
	ok($vw1->getPublicKey() eq "0106618e1493f73ee0bc67ffbad4ba4e3863b995d61786d9b9a68ec7676f697981","Test 1, EraValidators, 2nd ValidatorWeights - public_key, Passed");
	ok($vw1->getWeight() eq "2297106992905","Test 1, EraValidators, 2nd ValidatorWeights - weight, Passed");
	# bid = 1550
	my @listJsonBids = $as->getBids();
	my $totalBids = @listJsonBids;
	ok($totalBids == 1550, "Test 1, total JsonBids = 1550, Passed");
	# assertion for 1st JsonBids
	my $oneJBids = $listJsonBids[0];
	ok($oneJBids->getPublicKey() eq "01001b79b9a6e13d2b96e916f7fa7dff40496ba5188479263ca0fb2ccf8b714305", "Test1, 1st bid public key, Passed");
	my $oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-68f12244cf9e37759aa78e3146c431cc4577fc122272989b9f9ebf2e8f27d741-007","Test1, 1st bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test1, 1st bid bonding_purse, Passed");
	ok($oneJBid->getStakedAmount() eq "908982507030", "Test1, 1st bid staked_amount, Passed");
	ok($oneJBid->getInactive() == 1, "Test1, 1st bid inactive, Passed");
	my @delegators = $oneJBid->getDelegators();
	my $totalD = @delegators;
	ok($totalD == 1, "Test1, 1st bid, total delegator = 1, Passed");
	my $oneD = $delegators[0];
	ok($oneD->getBondingPurse() eq "uref-401f87167d733d8dd7d3efbf135a91ccd42fffb77b02d4a0075b963f14f1fbb4-007", "Test 1, 1st bid - delegator bonding_purse, Passed");
	ok($oneD->getDelegatee() eq "01001b79b9a6e13d2b96e916f7fa7dff40496ba5188479263ca0fb2ccf8b714305", "Test 1, 1st bid - delegator delegatee, Passed");
	ok($oneD->getPublicKey() eq "018b34b15e023844531621cb52d42e216a2ea56034f0f40bf7cee566c32eae4f83", "Test 1, 1st bid - delegator public_key, Passed");
	ok($oneD->getStakedAmount() eq "30268476029", "Test 1, 1st bid - delegator bonding_purse, Passed");
	
	# assertion for 2nd JsonBids
	$oneJBids = $listJsonBids[1];
	ok($oneJBids->getPublicKey() eq "0100d89e0684002f6ac2673af21954ee2737c276fed07bc22fc40a2ebac385a3e0", "Test1, 2nd bid public key, Passed");
	$oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-33222ffae1c18188fd1715097d4b0c6f74ddd4c490366905b25439d46befae93-007","Test1, 2nd bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test1, 2nd bid bonding_purse, Passed");
	ok($oneJBid->getStakedAmount() eq "943354239674", "Test1, 2nd bid staked_amount, Passed");
	ok($oneJBid->getInactive() == 1, "Test1, 2nd bid inactive, Passed");
	@delegators = $oneJBid->getDelegators();
	$totalD = @delegators;
	ok($totalD == 0, "Test1, 1st bid, total delegator = 1, Passed");
	
	# assertion for 7th JsonBids
	$oneJBids = $listJsonBids[6];
	ok($oneJBids->getPublicKey() eq "0101a458aa2b551c5a49e56326f9bb298bb308e1babc875647ae0290c42f13feac", "Test1, 7th bid public key, Passed");
	$oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-64150f5d056449035b900c19900e27535a5da3200a2c6a9db88ac427c01da41e-007","Test1, 7th bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test1, 7th bid bonding_purse, Passed");
	ok($oneJBid->getStakedAmount() eq "2484838159416", "Test1, 7th bid staked_amount, Passed");
	ok($oneJBid->getInactive() == 1, "Test1, 7th bid inactive, Passed");
	@delegators = $oneJBid->getDelegators();
	$totalD = @delegators;
	ok($totalD == 10, "Test1, 7th bid, total delegator = 10, Passed");
	# assertion for 1st delegator
	$oneD = $delegators[0];
	ok($oneD->getBondingPurse() eq "uref-5dfa5cd7f3066ff3be8f43d5e551bd6835ba2ce8a202a93cfc97914b5dafcf0c-007", "Test 1, 7th bid - delegator bonding_purse, Passed");
	ok($oneD->getDelegatee() eq "0101a458aa2b551c5a49e56326f9bb298bb308e1babc875647ae0290c42f13feac", "Test 1, 7th bid - delegator delegatee, Passed");
	ok($oneD->getPublicKey() eq "010ca8f91a2704a56701bdc4cc16f70e341e01281ef20bcb5475bf83ffe48841bd", "Test 1, 7th bid - delegator public_key, Passed");
	ok($oneD->getStakedAmount() eq "79248958449", "Test 1, 1st bid - delegator bonding_purse, Passed");
	# assertion for 2nd delegator
	$oneD = $delegators[1];
	ok($oneD->getBondingPurse() eq "uref-39fe229a86f7d6d2a0f855175de6b888a07fc0f9bbd50f1ef11a2d5eda0321b9-007", "Test 1, 7th bid - delegator bonding_purse, Passed");
	ok($oneD->getDelegatee() eq "0101a458aa2b551c5a49e56326f9bb298bb308e1babc875647ae0290c42f13feac", "Test 1, 7th bid - delegator delegatee, Passed");
	ok($oneD->getPublicKey() eq "01270a577d2d106c4d29402775f3dffcb9f04aad542579dd4d1cfad20572ebcb7c", "Test 1, 7th bid - delegator public_key, Passed");
	ok($oneD->getStakedAmount() eq "3563893957", "Test 1, 1st bid - delegator bonding_purse, Passed");
}
# Test 2: Call with block height
sub getAuction2 {
	my $getAuction = new GetAuction::GetAuctionInfoRPC();
	my $bi = new Common::BlockIdentifier();
	$bi->setBlockType("height");
	$bi->setBlockHeight(100);
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_AUCTION);
	print "\n".$postParamStr."\n";
	my $getAResult = $getAuction->getAuction($postParamStr);
	ok($getAResult->getApiVersion() eq "1.4.5", "Test 1 api_version, Passed");
	my $as = $getAResult->getAuctionState();
	ok($as->getStateRootHash() eq "c50822987f4b0b620825f7b8941c7bd446a426c8b8fa2f19bec432727a32d196","Test 2 state root hash value, Passed");
	ok($as->getBlockHeight() eq "100","Test 2 block height value, Passed");
	my @listEV = $as->getEraValidators();
	my $totalEV = @listEV;
	ok($totalEV == 2, "Test 1, total EraValidators = 2 , Passed");
	my $oneEV = $listEV[0];
	ok($oneEV->getEraId() eq "0", "Test 1st EraValidators, era id value, Passed");
	my @listVW = $oneEV->getValidatorWeights();
	my $totalVW = @listVW;
	ok($totalVW == 2, "Test 2, EraValidators, total ValidatorWeights, Passed");
	my $vw1 = $listVW[0];
	ok($vw1->getPublicKey() eq "0106ca7c39cd272dbf21a86eeb3b36b7c26e2e9b94af64292419f7862936bca2ca","Test 2, EraValidators, 1st ValidatorWeights - public_key, Passed");
	ok($vw1->getWeight() eq "1000000000000","Test 2, EraValidators, 1st ValidatorWeights - weight, Passed");
	$vw1 = $listVW[1];
	ok($vw1->getPublicKey() eq "017d96b9a63abcb61c870a4f55187a0a7ac24096bdb5fc585c12a686a4d892009e","Test 2, EraValidators, 2nd ValidatorWeights - public_key, Passed");
	ok($vw1->getWeight() eq "1000000000000","Test 2, EraValidators, 2nd ValidatorWeights - weight, Passed");
	# bid = 57
	my @listJsonBids = $as->getBids();
	my $totalBids = @listJsonBids;
	ok($totalBids == 57, "Test 1, total JsonBids = 1550, Passed");
	# assertion for 1st JsonBids
	my $oneJBids = $listJsonBids[0];
	ok($oneJBids->getPublicKey() eq "0106ca7c39cd272dbf21a86eeb3b36b7c26e2e9b94af64292419f7862936bca2ca", "Test 2, 1st bid public key, Passed");
	my $oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-b71209b79d2e2770995ef7d18de48598187f1a6b3518f324a615d1d1e91bac16-007","Test 2, 1st bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test 2, 1st bid bonding_purse, Passed");
	ok($oneJBid->getStakedAmount() eq "1000000000000", "Test 2, 1st bid staked_amount, Passed");
	ok($oneJBid->getInactive() == 0, "Test 2, 1st bid inactive, Passed");
	my @delegators = $oneJBid->getDelegators();
	my $totalD = @delegators;
	ok($totalD == 0, "Test 2, 1st bid, total delegator = 0, Passed");
		
	# assertion for 2nd JsonBids
	$oneJBids = $listJsonBids[1];
	ok($oneJBids->getPublicKey() eq "010b0f958cae89f265d7585f8abc67639fd68f9764390682801c744b0e126fb9b3", "Test1, 2nd bid public key, Passed");
	$oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-bfaccb266a7a9f3e466e9876637db577b997866a6a36baef779dbff368c5a0e7-007","Test1, 2nd bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test1, 2nd bid bonding_purse, Passed");
	ok($oneJBid->getStakedAmount() eq "999000000000", "Test1, 2nd bid staked_amount, Passed");
	ok($oneJBid->getInactive() == 0, "Test1, 2nd bid inactive, Passed");
	@delegators = $oneJBid->getDelegators();
	$totalD = @delegators;
	ok($totalD == 0, "Test1, 1st bid, total delegator = 1, Passed");	
}

getAuction1();
getAuction2();
