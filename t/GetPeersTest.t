#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 363;


use  GetPeers::GetPeerRPC;
use  GetPeers::PeerEntry;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
use GetPeers::GetPeerRPC;
sub getPeers {
	my $getPeer = new GetPeers::GetPeerRPC();
	my $getPeerResult = $getPeer->getPeers();
	ok($getPeerResult->getApiVersion() eq "1.4.5", "Test api_version, Passed");
}
getPeers();