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

#Test information for deploy at this address: https://testnet.cspr.live/deploy/55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa
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
	my $deployPayment = $deploy->getPayment();
	print "deployPayment type:".$deployPayment->getItsType();
	
	# Test assertion for Deploy Header
	ok($deploy->getHeader()->getAccount() eq "01a080d935c4c9415b3d296f7570d99a49e10da8dc293c7ec3a6a3d8758f2e128c","Test deploy header account - Passed");
	ok($deploy->getHeader()->getBodyHash() eq "dfa3a2b76fdbe1e2fd8fc37e2feaabb4d0a5392e9b82a68372f2921c899326bb","Test deploy body account - Passed");
	ok($deploy->getHeader()->getChainName() eq "casper-test","Test deploy header chain name - Passed");
	ok($deploy->getHeader()->getTimestamp() eq "2022-04-27T08:23:59.420Z","Test deploy header timestamp - Passed");
	ok($deploy->getHeader()->getTTL() eq "30m","Test deploy header ttl - Passed");
	ok($deploy->getHeader()->getGasPrice() == 1,"Test deploy header gas price - Passed");
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	ok($dl == 0, "Test deploy header dependencies - Passed");
	
	# Test assertion for Deploy hash
	ok($deploy->getDeployHash() eq "55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa","Test deploy hash - Passed");
	
	# Test assertion for Deploy payment
	
	my $payment = $deploy->getPayment();
	ok($payment->getItsType() eq "ModuleBytes","Test deploy payment of type ModuleBytes - Passed");
	my $paymentValue = $payment->getItsValue();
	ok($paymentValue->getModuleBytes() eq "","Test deploy payment module_bytes - Passed");
	my $paymentArgs = $paymentValue->getArgs();
	my @listArgs = @{$paymentArgs->getListNamedArg()};
	my $totalArgs = @listArgs;
	print "total Args:".$totalArgs."\n";
	#Test for first args
	my $counter1 = 0;
	my $oneNA;
	foreach(@listArgs) {
		if($counter1 == 2) {
			$oneNA = $_;
		}
		$counter1 ++;
	}
	# The real args list contains 1 element, but the list in Perl hold 1 + 2 = 3 elements with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgs - 2 == 1, "Test payment total args = 1 - Passed");
	ok($oneNA->getItsName() eq "amount", "Test payment first arg name = amount - Passed");
	my $paymentFirstArgCLValue = $oneNA->getCLValue();
	ok($paymentFirstArgCLValue->getBytes() eq "0500c817a804","Test payment first arg CLValue, bytes value = 0500c817a804 - Passed");
	ok($paymentFirstArgCLValue->getCLType()->getItsTypeStr() eq "U512","Test payment first arg CLValue, cl_type = U512 - Passed");
	ok($paymentFirstArgCLValue->getParse()->getItsValueStr() eq "20000000000","Test payment first arg CLValue, parse = 20000000000 - Passed");
	
	#Test assertion for Deploy session
	
	my $session = $deploy->getSession();
	ok($session->getItsType() eq "StoredContractByHash", "Test deploy session of type StoredContractByHash - Passed");
	my $sessionValue = $session->getItsValue();
	my $sessionArgs = $sessionValue->getArgs();
	my @listArgsSession = @{$sessionArgs->getListNamedArg()};
	my $totalArgsSession = @listArgsSession;
	print "total session args".$totalArgsSession."\n";
	# The real args list contains 9 element, but the list in Perl hold 9 + 2 = 11 element with 2 items other hold the other information for the 
	# main value of NamedArg, then in the assertion, we have to minus 2 to the total size of the list Args.
	ok($totalArgsSession - 2 == 9, "Test session total args = 9 - Passed");
	$counter1 = 0;
	my $oneNASession;
	my $oneNASession2;
	foreach(@listArgsSession) {
		if($counter1 == 10) {
			$oneNASession = $_;
		} elsif($counter1 == 2) {
			$oneNASession2 = $_;
		}
		$counter1 ++;
	}
	# Assertion for 9th Arg
	ok($oneNASession->getItsName() eq "pair", "Test session 9th arg name = pair - Passed");
	my $sessionArgCLValue = $oneNASession->getCLValue();
	ok($sessionArgCLValue->getBytes() eq "0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b","Test session 9th arg CLValue, bytes value = 0101562ed7abecc624b8eebb7eb33f542c99b2ce0e0383980e31476507f70267b55b - Passed");
	ok($sessionArgCLValue->getCLType()->getItsTypeStr() eq "Option","Test session 9th arg CLValue, cl_type = Option - Passed");
	ok($sessionArgCLValue->getCLType()->getInnerCLType1()->getItsTypeStr() eq "Key","Test session 9th arg CLValue, cl_type = Option(Key) Passed");
	# Assertion for first Arg
	ok($oneNASession2->getItsName() eq "token_a", "Test session first arg name = token_a - Passed");
	my $sessionArgCLValue2 = $oneNASession2->getCLValue();
	ok($sessionArgCLValue2->getBytes() eq "01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test session first arg CLValue, bytes value = 01beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
	ok($sessionArgCLValue2->getCLType()->getItsTypeStr() eq "Key","Test session first arg CLValue, cl_type = Key - Passed");
	ok($sessionArgCLValue2->getParse()->getItsValueStr() eq "hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9","Test payment first arg CLValue, parse = hash-beb48e371fecfb567a7f35535069aa22d31668c459dc9cb30391b4cd628768b9 - Passed");
	
	return 100;
}

getDeploy();
