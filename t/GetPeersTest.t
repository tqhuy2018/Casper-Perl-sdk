#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 6;




use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
use  GetPeers::GetPeerRPC;
use  GetPeers::PeerEntry;

sub getPeers {
	my $getPeer = new GetPeers::GetPeerRPC();
	my $getPeerResult = $getPeer->getPeers();
	ok($getPeerResult->getApiVersion() eq "1.4.5", "Test api_version, Passed");
	my @peerList = $getPeerResult->getPeers();
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
getPeers();