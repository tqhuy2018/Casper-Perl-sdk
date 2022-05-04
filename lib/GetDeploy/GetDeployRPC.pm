=comment
This class handles info_get_deploy RPC call
=cut

package GetDeploy::GetDeployRPC;

use JSON qw( decode_json );
use JSON qw( encode_json );

use HTTP::Request;
use LWP::UserAgent;
use GetDeploy::Deploy;
use GetDeploy::DeployHeader;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;
use GetDeploy::GetDeployResult;

sub new {
	print "GetDeployRPC called";
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}
=comment
This function does info_get_deploy RPC call
=cut
sub getDeployResult {
	my @list = @_;
	print "\nparameter str is:".$list[1]."\n";
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
	    print "\njsonRPC = ".$decoded->{'jsonrpc'}."\n";
	    print "\nid=".$decoded->{'id'}."\n";
	    my $errorCode = $decoded->{'error'}{'code'};
	    if($errorCode) {
	    	my $errorException = new ErrorException();
	    	print "error code:".$errorCode."\n";
	    	print "error message:".$decoded->{'error'}{'message'}."\n";
	    	$errorException->setErrorCode($errorCode);
	    	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	    	die "\nError exception";
	    } else {
	    	my $deployResult = new GetDeploy::GetDeployResult();
		    print "\napi_version:" . $decoded->{'result'}{'api_version'}."\n";
	    	$deployResult = GetDeploy::GetDeployResult->fromJsonObjectToGetDeployResult($decoded->{'result'});
		    #$deployResult->setApiVersion($decoded->{'result'}{'api_version'});
		    return $deployResult;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;