#!/usr/bin/perl

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use LWP::UserAgent;
use Data::Dumper;

package GetPeerRPC;

use JSON qw( decode_json );

sub new {
	print "getPeerRPC called";
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub getPeers {
	 my( $self ) = @_;
	# Prints the message using two different delimeters.
	# https://node-clarity-testnet.make.services/rpc
	# https://node-clarity-mainnet.make.services/rpc
	print "Hello, world!\n";
	print qq=Did you say "Hello?"\n=;
	print "What can I do?\n";
	my $uri = 'https://node-clarity-testnet.make.services/rpc';
	my $json = '{"params" :  [], "id" :  1, "method": "info_get_peers", "jsonrpc" :  "2.0"}';
	my $req = HTTP::Request->new( 'POST', $uri );
	$req->header( 'Content-Type' => 'application/json');
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request( $req );
	if ($response->is_success) {
	   #print $response->decoded_content;
	    my $d = $response->decoded_content;
	    my $decoded = decode_json($d);
	    print "\njsonRPC = ".$decoded->{'jsonrpc'}."\n";
	    print "\nid=".$decoded->{'id'}."\n";
	    print "\napi_version:" . $decoded->{'result'}{'api_version'}."\n";
	    my @peers = @{$decoded->{'result'}{'peers'}};
	    my $counter = 0;
	    my $totalPeer = @peers;
	   
	    print "Total peer is:".$totalPeer."\n";
	    my $firstPeer = $peers[0];
	    print "First peer node_id is:".$firstPeer->{'node_id'}."\n";
	    print "First peer address is:".$firstPeer->{'address'};
		 q^{ foreach my $peer(@peers) {
		    	print "Get peer number ".$counter."\n";
		    	$counter += 1;
		    	print "peer node_id:".$peer->{'node_id'}."\n";
		    	print "peer address:".$peer->{'address'}."\n";
		    }^ if 0;
	}
	else {
	    die $response->status_line;
	}
}
1;
