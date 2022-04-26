#!/usr/bin/perl

package main;

use GetPeerRPC;

use BlockIdentifier;
sub getPeer {
	$getPeer = new GetPeerRPC();
	$getPeer->getPeers();
}
sub getStateRootHash {
	print "\nget State root hash called";
	my $bi = new BlockIdentifier();
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam();
	print "\npostparams is:".$postParamStr;
}

getPeer();
getStateRootHash();