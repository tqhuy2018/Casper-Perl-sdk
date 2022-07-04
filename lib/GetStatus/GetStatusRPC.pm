# This class handles info_get_status RPC call
package GetStatus::GetStatusRPC;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );

use GetStatus::GetStatusResult;
sub new {
	my $class = shift;
	my $self = {_url=>shift};
	bless $self, $class;
	return $self;
}
=comment
This function does info_get_status RPC call
 * This function initiate the process of sending POST request with given parameter in JSON string format like this:
 * {"params" :  [], "id" :  1, "method": "info_get_status", "jsonrpc" :  "2.0"}
 * Then the GetStatusResult is retrieved by parsing JsonObject result taken from the RPC POST request
=cut
sub getStatus {
	my( $self ) = @_;
	my $uri = $self->{_url};
	if($uri) {
	} else {
		$uri = $Common::ConstValues::TEST_NET;
	}
	my $json = '{"params" :  [], "id" :  1, "method": "info_get_status", "jsonrpc" :  "2.0"}';
	my $req = HTTP::Request->new( 'POST', $uri );
	$req->header( 'Content-Type' => 'application/json');
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request( $req );
	if ($response->is_success) {
	    my $d = $response->decoded_content;
	    my $decoded = decode_json($d);
	    my $ret = GetStatus::GetStatusResult->fromJsonObjectToGetStatusResult($decoded->{'result'});
	    return $ret;
	}
	else {
	    die $response->status_line;
	}
}
1;
