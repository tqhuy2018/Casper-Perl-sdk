#!/usr/bin/perl

package main;

use GetPeerRPC;

use BlockIdentifier;

$getPeer = new GetPeerRPC();
$getPeer->getPeers();