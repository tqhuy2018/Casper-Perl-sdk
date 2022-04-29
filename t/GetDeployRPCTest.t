#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 2;

#use CLValue::CLType;
#use  GetPeers::GetPeerRPC;


use FindBin qw( $RealBin );
use lib "$RealBin/../lib";

use GetDeploy::GetDeployRPC;
use GetDeploy::GetDeployParams;

sub getDeploy {
	#print("In deploy, The value of PI is $Common::ConstValues::BLOCK_HASH.\n");
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	print "\ndeploy hash:".$deploy->getDeployHash();
	print "\ndeploy header body hash:".$deploy->getHeader()->getBodyHash()."\n";
	print "\ndeploy header account:".$deploy->getHeader()->getAccount()."\n";
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	print "total d:".$dl."\n";
	return 100;
}

sub hello_world
{
return "Hello world!";
}

sub get_number
{
return int(rand(1000));
}
ok( hello_world( ) eq "Hello world!", "My Testcase 1" );
ok( getDeploy( ) > 0, "My Testcase 2" );
