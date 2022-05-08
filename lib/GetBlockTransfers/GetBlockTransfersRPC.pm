package GetBlockTransfers::GetBlockTransfersRPC;

use Common::ErrorException;
use JSON qw( decode_json );
sub new {
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub getBlockTransfers {
	my @list = @_;
	my $uri = 'https://node-clarity-testnet.make.services/rpc';
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
		    my $stateRootHash = GetBlockTransfers::GetBlockTransfersResult->fromJsonObjectToGetBlockTransfersResult($decoded->{'result'});
		   	return $stateRootHash;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;