#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 18;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Common::ConstValues;
use  GetStatus::GetStatusResult;
use GetStatus::GetStatusRPC;
use  GetPeers::PeerEntry;

sub getStatus {
	my $getStatus = new GetStatus::GetStatusRPC();
	my $getStatusResult = $getStatus->getStatus();
	ok($getStatusResult->getApiVersion() eq "1.4.5", "Test api_version, Passed");
	ok($getStatusResult->getChainspecName() eq "casper-test", "Test chainspec_name, Passed");
	ok($getStatusResult->getStartingStateRootHash() eq "5b14ac556100f5ff7e6069b59ea0583a17e96d65f8674febf45f1fda8d51a0e1", "Test starting_state_root_hash, Passed");
	ok($getStatusResult->getOurPublicSigningKey() eq "017d96b9a63abcb61c870a4f55187a0a7ac24096bdb5fc585c12a686a4d892009e", "Test our_public_signing_key, Passed");
	ok($getStatusResult->getRoundLength() eq "32s 768ms", "Test round_length, Passed");
	ok($getStatusResult->getBuildVersion() eq "1.4.5-a7f6a648d-casper-mainnet", "Test build_version, Passed");
	ok(length($getStatusResult->getUptime()) > 0, "Test uptime, Passed");
	my $mbi = $getStatusResult->getLastAddedBlockInfo();
	ok (length($mbi->getCreator()) > 0, "Test last_added_block_info - creator, Passed");
	ok (length($mbi->getEraId()) > 0, "Test last_added_block_info - era_id, Passed");
	ok (length($mbi->getHeight()) > 0, "Test last_added_block_info - height, Passed");
	ok (length($mbi->getTimeStamp()) > 0, "Test last_added_block_info - timestamp, Passed");
	ok (length($mbi->getStateRootHash()) > 0, "Test last_added_block_info - state_root_hash, Passed");
	ok (length($mbi->getBlockHash()) > 0, "Test last_added_block_info - hash, Passed");
	# my $nu = $getStatusResult->getNextUpgrade();
	my @peerList = $getStatusResult->getPeers();
	my $totalPeerEntry = @peerList;
	ok($totalPeerEntry > 0, "Test total PeerEntry > 0, Passed");
	my $counter = 0;
	foreach(@peerList) {
		if ($counter == 0) {
			my $onePE = $_;
			ok(length($onePE->getNodeId()) > 0, "Test first peer node_id not null, Passed");
			ok(length($onePE->getAddress()) > 0, "Test first peer address not null, Passed");
		} elsif ($counter == 1) {
			my $onePE = $_;
			ok(length($onePE->getNodeId()) > 0, "Test 2nd peer node_id not null, Passed");
			ok(length($onePE->getAddress()) > 0, "Test 2nd peer address not null, Passed");
		}
		$counter ++;
	}
}
getStatus();