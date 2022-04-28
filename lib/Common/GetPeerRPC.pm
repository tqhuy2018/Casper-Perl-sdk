

=comment
This class handles info_get_peers RPC call
=cut
package Common::GetPeerRPC;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );

sub new {
	print "getPeerRPC called";
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}
=comment
This function does info_get_peers RPC call
=cut
sub getPeers {
	 my( $self ) = @_;
	# Prints the message using two different delimeters.
	# https://node-clarity-testnet.make.services/rpc
	# https://node-clarity-mainnet.make.services/rpc
	my $uri = 'https://node-clarity-testnet.make.services/rpc';
	my $json = '{"params" :  [], "id" :  1, "method": "info_get_peers", "jsonrpc" :  "2.0"}';
	my $req = HTTP::Request->new( 'POST', $uri );
	$req->header( 'Content-Type' => 'application/json');
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request( $req );
	if ($response->is_success) {
	    my $d = $response->decoded_content;
	    my $decoded = decode_json($d);
	    print "\njsonRPC = ".$decoded->{'jsonrpc'}."\n";
	    print "\nid=".$decoded->{'id'}."\n";
	    print "\napi_version:" . $decoded->{'result'}{'api_version'}."\n";
	    my @peers = @{$decoded->{'result'}{'peers'}};
	    my $totalPeer = @peers;
	    print "Total peer is:".$totalPeer."\n";
	    my $firstPeer = $peers[0];
	    print "First peer node_id is:".$firstPeer->{'node_id'}."\n";
	    print "First peer address is:".$firstPeer->{'address'};
	}
	else {
	    die $response->status_line;
	}
}
=comment
q^{ foreach my $peer(@peers) {
		    	print "Get peer number ".$counter."\n";
		    	$counter += 1;
		    	print "peer node_id:".$peer->{'node_id'}."\n";
		    	print "peer address:".$peer->{'address'}."\n";
		    }^ if 0;
=cut 
1;
