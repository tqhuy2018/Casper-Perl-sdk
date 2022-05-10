#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 59;

use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Scalar::Util qw(looks_like_number);

use Common::ConstValues;
use GetAuction::GetAuctionInfoResult;
use GetAuction::GetAuctionInfoRPC;
use Common::BlockIdentifier;

sub getAuction1 {
	my $getAuction = new GetAuction::GetAuctionInfoRPC();
	my $bi = new Common::BlockIdentifier();
	# Test 1: Call with block hash
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
	# bid = 1550
	my @listJsonBids = $as->getBids();
	my $totalBids = @listJsonBids;
	ok($totalBids == 1550, "Test 1, total JsonBids = 1550, Passed");
	my $oneJBids = $listJsonBids[0];
	ok($oneJBids->getPublicKey() eq "01001b79b9a6e13d2b96e916f7fa7dff40496ba5188479263ca0fb2ccf8b714305", "Test1, 1st bid public key, Passed");
	my $oneJBid = $oneJBids->getBid();
	ok($oneJBid->getBondingPurse() eq "uref-68f12244cf9e37759aa78e3146c431cc4577fc122272989b9f9ebf2e8f27d741-007","Test1, 1st bid bonding_purse, Passed");
	ok($oneJBid->getDelegationRate() == 10, "Test1, 1st bid bonding_purse, Passed");
}
getAuction1();
