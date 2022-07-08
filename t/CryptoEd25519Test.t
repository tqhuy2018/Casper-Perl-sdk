#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 6;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Crypt::Ed25519Handle;
sub testKeyGeneration {
	my $ed25519 = new Crypt::Ed25519Handle();
	$ed25519->keyGeneration();
}
testKeyGeneration();