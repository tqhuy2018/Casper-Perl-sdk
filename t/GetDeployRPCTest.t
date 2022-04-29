#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;

use Test::Simple tests => 100;

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
	ok($deploy->getHeader()->getAccount() eq "01a080d935c4c9415b3d296f7570d99a49e10da8dc293c7ec3a6a3d8758f2e128c","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "dfa3a2b76fdbe1e2fd8fc37e2feaabb4d0a5392e9b82a68372f2921c899326bb","Test deploy body account - Passed");
	ok($deploy->getDeployHash() eq "55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa","Test deploy hash - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	print "total d:".$dl."\n";
	return 100;
}


#ok( hello_world( ) eq "Hello world!", "My Testcase 1" );
ok( getDeploy( ) > 0, "My Testcase 2" );
