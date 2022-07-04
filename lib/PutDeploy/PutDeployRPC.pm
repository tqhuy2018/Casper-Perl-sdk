# This class handles account_put_deploy RPC call
package PutDeploy::PutDeployRPC;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );

use PutDeploy::PutDeployResult;
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
This function does account_put_deploy RPC call
 * This function initiate the process of sending POST request with given parameter in JSON string format like this:
 * {"id": 1,"method": "account_put_deploy","jsonrpc": "2.0","params": 
 	[{"header": {"account": "0152a685e0edd9060da4a0d52e500d65e21789df3cbfcb878c91ffeaea756d1c53",
 	"timestamp": "2022-06-28T11:35:19.349Z","ttl":"1h 30m","gas_price":1,
 	"body_hash":"798a65dae48dbefb398ba2f0916fa5591950768b7a467ca609a9a631caf13001","dependencies": [],
 	"chain_name": "casper-test"},
 	"payment": {"ModuleBytes": {"module_bytes": "","args": 
 	[["amount",{"bytes": "0400ca9a3b","cl_type":"U512","parsed":"1000000000"}]]}},
 	"session": {"Transfer": {"args": [["amount",{"bytes": "04005ed0b2","cl_type":"U512","parsed":"3000000000"}],
 	["target",{"bytes": "015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a","cl_type":"PublicKey","parsed":"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a"}],
 	["id",{"bytes": "010000000000000000","cl_type":{"Option": "U64"},"parsed":0}],["spender",{"bytes": "01dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b","cl_type":"Key","parsed":{"Hash":"hash-dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b"}}]]}},
 	"approvals": [{"signer": "0152a685e0edd9060da4a0d52e500d65e21789df3cbfcb878c91ffeaea756d1c53",
 	"signature": "016596f09083d32eaffc50556f1a5d22202e8927d5aa3267639aff4b9d3412b5ae4a3475a5da6c1c1086a9a090b0e1090db5d7e1b7084bb60b2fee3ce9447a2a04"}],
 	"hash": "65c6ccdc5aacc9dcd073ca79358bf0b5115061e8d561b3e6f461a34a6c5858f0"}]}
 * Then the PutDeployResult is retrieved by parsing JsonObject result taken from the RPC POST request
=cut
sub putDeploy {
	my ($self) = @_;
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
	    	my $putDeployResult = new PutDeploy::PutDeployResult();
	    	$putDeployResult = PutDeploy::PutDeployResult->fromJsonObjectToPutDeployResult($decoded->{'result'});
		    return $deployResult;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;