#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 363;

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use Common::ConstValues;
sub getPeers {
	
}
getPeers();