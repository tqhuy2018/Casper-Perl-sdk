#!/usr/bin/perl


package main;


use GetPeerRPC;

use BlockIdentifier;

use GetStateRootHashRPC;


sub getPeer {
	$getPeer = new GetPeerRPC();
	$getPeer->getPeers();
}
sub getStateRootHash {
	print "\nget State root hash called";
	print "\nTest 1: Call with block hash, type:".BLOCK_HASH."\n";
	my $bi = new BlockIdentifier();
	$bi->setBlockType("hash");
	print "Block type:".$bi->getBlockType()."\n";
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr;
	my $getStateRootHashRPC = new GetStateRootHashRPC();
	my $stateRootHash1 = $getStateRootHashRPC->getStateRootHash($postParamStr);
	print "state root hash 1 :".$stateRootHash1."\n";
	print "\nTest 2: Call with block height\n";
	$bi->setBlockType("height");
	$bi->setBlockHeight("1234");
	my $postParamHeightStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamHeightStr;
	my $getStateRootHashRPC2 = new GetStateRootHashRPC();
	my $stateRootHash2 = $getStateRootHashRPC2->getStateRootHash($postParamHeightStr);
	print "state root hash 2 :".$stateRootHash2."\n";
	
	print "\nTest 3: Call with no parameter, latest state root hash is retrieved\n";
	$bi->setBlockType("none");
	my $postParamNoneStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamNoneStr;
	my $getStateRootHashRPC3 = new GetStateRootHashRPC();
	my $stateRootHash3 = $getStateRootHashRPC3->getStateRootHash($postParamNoneStr);
	print "state root hash 3 :".$stateRootHash3."\n";
	
	print "\nTest 4: Call with wrong block hash, latest state root hash is retrieved\n";
	$bi->setBlockType("hash");
	$bi->setBlockHash("aaa");
	my $postParamStr4 = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr4;
	my $getStateRootHashRPC4 = new GetStateRootHashRPC();
	my $stateRootHash4 = $getStateRootHashRPC4->getStateRootHash($postParamStr4);
	print "state root hash 3 :".$stateRootHash4."\n";
	
	print "\nTest 5: Call with too big block height, latest state root hash is retrieved\n";
	$bi->setBlockType("height");
	$bi->setBlockHeight("999999988777");
	my $postParamStr5 = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr5;
	my $getStateRootHashRPC5 = new GetStateRootHashRPC();
	my $stateRootHash5 = $getStateRootHashRPC5->getStateRootHash($postParamStr5);
	print "state root hash 3 :".$stateRootHash4."\n"
}

getPeer();
getStateRootHash();