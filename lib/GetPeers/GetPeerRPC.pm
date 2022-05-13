# This class handles info_get_peers RPC call
package GetPeers::GetPeerRPC;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );
use GetPeers::GetPeersResult;

sub new {
	my $class = shift;
	my $self = {_url=>shift};
	bless $self, $class;
	return $self;
}

# get-set method for _url
sub setUrl {
	my ($self,$value) = @_;
	$self->{_url} = $value if defined ($value);
	return $self->{_url};
}
sub getUrl {
	my ($self) = @_;
	return $self->{_url};
}

=comment
This function does info_get_peers RPC call
=cut
sub getPeers {
	 my( $self ) = @_;
	my $uri = $self->{_url};
	if($uri) {
	} else {
		$uri = $Common::ConstValues::TEST_NET;
	}
	my $json = '{"params" :  [], "id" :  1, "method": "info_get_peers", "jsonrpc" :  "2.0"}';
	my $req = HTTP::Request->new( 'POST', $uri );
	$req->header( 'Content-Type' => 'application/json');
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request( $req );
	if ($response->is_success) {
	    my $d = $response->decoded_content;
	    my $decoded = decode_json($d);
	    my $ret = GetPeers::GetPeersResult->fromJsonObjectToGetPeersResult($decoded->{'result'});
	    return $ret;
	}
	else {
	    die $response->status_line;
	}
}
1;
