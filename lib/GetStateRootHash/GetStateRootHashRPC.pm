# This class handles the chain_get_state_root_hash RPC call
package GetStateRootHash::GetStateRootHashRPC;
#use lib 'Common/ErrorException';
use Common::ErrorException;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );
our $VERSION = 0.01;

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
This function does chain_get_state_root_hash RPC call
The procedure for this process is:
1. Assign the url for the post method, by default the url will be the test net 
(url for test net is: https://node-clarity-testnet.make.services/rpc which defined in Common::ConstValues class)
You can change the url to main net or localhost for the method by calling the function setUrl.
2. Get the Post parameter to send along with the Post method. In this method it is defined in this $json variable, at this code line:
my $json = $list[1];
3. Send the post method and read the response data back.
If the response error encapsulated in json, there will be error thrown.
Otherwise, the state root hash is retrieved by parsing the json data back, using $decoded->{'result'}{'state_root_hash'}
=cut
sub getStateRootHash {
	my @list = @_;
	my $uri = $self->{_url};
	if($uri) {
	} else {
		$uri = $Common::ConstValues::TEST_NET;
	}
	my $json = $list[1];
	my $req = HTTP::Request->new( 'POST', $uri );
	$req->header( 'Content-Type' => 'application/json');
	$req->content( $json );
	my $lwp = LWP::UserAgent->new;
	my $response = $lwp->request( $req );
	if ($response->is_success) {
	    my $d = $response->decoded_content;
	    my $decoded = decode_json($d);
	    my $errorCode = $decoded->{'error'}{'code'};
	    if($errorCode) {
	    	my $errorException = new Common::ErrorException();
	    	$errorException->setErrorCode($errorCode);
	    	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	    	return $errorException;
	    } else {
		    my $stateRootHash = $decoded->{'result'}{'state_root_hash'};
		   	return $stateRootHash;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;