=comment
This class handles info_get_deploy RPC call
=cut

package GetDeploy::GetDeployRPC;

use JSON qw( decode_json );
use JSON qw( encode_json );

use GetDeploy::Deploy;
use GetDeploy::DeployHeader;
use GetDeploy::ExecutableDeployItem::ExecutableDeployItem;

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
sub getDeploy {
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
		    print "\napi_version:" . $decoded->{'result'}{'api_version'}."\n";
		    
		    #get the deploy header
		    my $deployHeaderJson = $decoded->{'result'}{'deploy'}{'header'};
		    print "deployHeaderJson is:".encode_json($deployHeaderJson)."\n";
		    my $deployHeaderStr = encode_json($deployHeaderJson);
		    my $deployHeader = GetDeploy::DeployHeader->fromJsonObjectToDeployHeader($deployHeaderStr);
		    print "deploy header hash: ".$deployHeader->getBodyHash()."\n";
		    my $deploy = new GetDeploy::Deploy();
		    $deploy->setDeployHash($decoded->{'result'}{'deploy'}{'hash'});
		    $deploy->setHeader($deployHeader);
		    
		    #get the deploy payment
		    my $paymentJson = $decoded->{'result'}{'deploy'}{'payment'};
		    my $paymentStr = encode_json($paymentJson);
		    my $payment = GetDeploy::ExecutableDeployItem::ExecutableDeployItem->fromJsonToExecutableDeployItem($paymentStr);
		    print "\npayment type:".$payment->getItsType();
		    
		    print "\n----------------------------------------------------------------------\n";
		    print "\n----------------------------------------------------------------------\n";
		    #get the deploy session
		    my $sessionJson = $decoded->{'result'}{'deploy'}{'session'};
		    my $sessionStr = encode_json($sessionJson);
		    my $session = GetDeploy::ExecutableDeployItem::ExecutableDeployItem->fromJsonToExecutableDeployItem($sessionStr);
		    print "\nsession type:".$session->getItsType();
		    
		    return $deploy;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;