#!/usr/bin/perl

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

package main;

use Error ':try';
use strict;
use warnings;

use GetPeers::GetPeerRPC;
use Common::ConstValues;
use Common::BlockIdentifier;
use GetStateRootHash::GetStateRootHashRPC;

use GetDeploy::GetDeployParams;
use GetDeploy::GetDeployRPC;
use GetDeploy::GetDeployResult;

sub getPeer {
	my $getPeer = new GetPeers::GetPeerRPC();
	$getPeer->getPeers();
}
sub getStateRootHash {
	print "\nget State root hash called";
	my $bi = new Common::BlockIdentifier();
	$bi->setBlockType("hash");
	print "Block type:".$bi->getBlockType()."\n";
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr;
	my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash1 = $getStateRootHashRPC->getStateRootHash($postParamStr);
	print "state root hash 1 :".$stateRootHash1."\n";
	print "\nTest 2: Call with block height\n";
	$bi->setBlockType("height");
	$bi->setBlockHeight("1234");
	
	
	my $postParamHeightStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamHeightStr;
	my $getStateRootHashRPC2 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash2 = $getStateRootHashRPC2->getStateRootHash($postParamHeightStr);
	print "state root hash 2 :".$stateRootHash2."\n";
	
	print "\nTest 3: Call with no parameter, latest state root hash is retrieved\n";
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamNoneStr;
	my $getStateRootHashRPC3 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash3 = $getStateRootHashRPC3->getStateRootHash($postParamNoneStr);
	print "state root hash 3 :".$stateRootHash3."\n";
	
	print "\nTest 4: Call with wrong block hash, latest state root hash is retrieved\n";
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr4;
	my $getStateRootHashRPC4 = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash4 = $getStateRootHashRPC4->getStateRootHash($postParamStr4);
	print "state root hash 3 :".$stateRootHash4."\n";
	
	print "\nTest 5: Call with too big block height, latest state root hash is retrieved\n";
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr5;
	my $getStateRootHashRPC5 = new GetStateRootHash::GetStateRootHashRPC();
	#my $stateRootHash5 = $getStateRootHashRPC5->getStateRootHash($postParamStr5);
	#print "state root hash 5 :".$stateRootHash4."\n"
	
	try{
		$getStateRootHashRPC5->getStateRootHash($postParamStr5);
	} catch Error::Simple with {
	     my $err = shift;
	     #print "ERROR: $err";
	};
}
sub getDeploy {
	#print("In deploy, The value of PI is $Common::ConstValues::BLOCK_HASH.\n");
	my $getDeployParams = new GetDeploy::GetDeployParams();
	$getDeployParams->setDeployHash("9ff98d8027795a002e41a709d5b5846e49c2e9f9c8bfbe74e4c857adc26d5571");
	my $paramStr = $getDeployParams->generateParameterStr();
	my $getDeployRPC = new GetDeploy::GetDeployRPC();
	my $deploy = $getDeployRPC->getDeploy($paramStr);
	print "\ndeploy hash:".$deploy->getDeployHash();
	print "\ndeploy header body hash:".$deploy->getHeader()->getBodyHash()."\n";
	print "\ndeploy header account:".$deploy->getHeader()->getAccount()."\n";
	my @d = $deploy->getHeader()->getDependencies();
	my $dl = @d;
	print "total d:".$dl."\n";
}
#getPeer();
#getStateRootHash();
getDeploy();