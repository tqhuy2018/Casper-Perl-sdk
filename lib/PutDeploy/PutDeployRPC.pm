# This class handles account_put_deploy RPC call
package PutDeploy::PutDeployRPC;
use LWP::UserAgent;
use Data::Dumper;
use JSON qw( decode_json );

use  PutDeploy::PutDeployResult;
use GetDeploy::Deploy;
use GetDeploy::DeployHeader;
use PutDeploy::ExecutableDeployItemToJsonHelper;
use GetDeploy::Approval;
use  Common::ErrorException;
use CryptoHandle::Secp256k1Handle;
use Common::Utils;
sub new {
	my $class = shift;
	my $self = {_url=>shift,_putDeployCounter=>shift,};
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
# get-set method for _putDeployCounter
sub setPutDeployCounter {
	my ($self,$value) = @_;
	$self->{_putDeployCounter} = $value if defined ($value);
	return $self->{_putDeployCounter};
}
sub getPutDeployCounter {
	my ($self) = @_;
	return $self->{_putDeployCounter};
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
	my $deploy = $list[1];
	my $json = fromDeployToJsonString($deploy);
	#print "deploy json is:".$json."\n";
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
	    	my $errorMessage = $decoded->{'error'}{'message'};
	    	if ($errorMessage eq "invalid deploy: the approval at index 0 is invalid: asymmetric key error: failed to verify secp256k1 signature: signature error") {
				$self->{_putDeployCounter} = $self->{_putDeployCounter} + 1;
				if($self->{_putDeployCounter} < 10) {
					my @listA = ();
					$deploy->setApprovals(@listA);
					my $oneA = new GetDeploy::Approval();
					$oneA->setSigner($deploy->getHeader()->getAccount());
					my $deployHash = $deploy->getDeployHash();
					my $secp256k1 = new CryptoHandle::Secp256k1Handle();
					my $util = new Common::Utils();
					my $hashAnscii = $util->fromDeployHashToAnscii($deployHash);
					my $privateKey = Crypt::PK::ECC->new($Common::ConstValues::READ_SECP256K1_PRIVATE_KEY_FILE);
					my $signature = $secp256k1->signMessage($hashAnscii,$privateKey);
					$signature = "02".$signature;
					$oneA->setSignature($signature);
					@listA=($oneA);
					$deploy->setApprovals(@listA);
					putDeploy("0",$deploy);
					return 1;
				}
            }
	    	return $Common::ConstValues::ERROR_PUT_DEPLOY;
	    } else {
	    	$self->{_putDeployCounter} = 0;
	    	my $putDeployResult = new PutDeploy::PutDeployResult();
	    	$putDeployResult = PutDeploy::PutDeployResult->fromJsonObjectToPutDeployResult($decoded->{'result'});
	    	print "Put deploy successful with deploy hash:".$putDeployResult->getDeployHash()."\n";
		    return $putDeployResult->getDeployHash();
	    }
	}
	else {
	    die $response->status_line;
	}
}
sub fromDeployToJsonString {
	my @vars = @_;
	my $deploy = new GetDeploy::Deploy();
	$deploy = $vars[0];
	my $deployHeader = new GetDeploy::DeployHeader();
	$deployHeader = $deploy->getHeader();
	my $ediToJsonHelper = new PutDeploy::ExecutableDeployItemToJsonHelper();
	my $headerString = "\"header\": {\"account\": \"".$deployHeader->getAccount()."\",\"timestamp\": \"".$deployHeader->getTimestamp()."\",\"ttl\":\"".$deployHeader->getTTL()."\",\"gas_price\":".$deployHeader->getGasPrice().",\"body_hash\":\"".$deployHeader->getBodyHash(). "\",\"dependencies\": [],\"chain_name\": \"".$deployHeader->getChainName()."\"}";
    my $paymentJsonStr = "\"payment\": ".$ediToJsonHelper->toJsonString($deploy->getPayment());
    my $sessionJsonStr = "\"session\": ".$ediToJsonHelper->toJsonString($deploy->getSession());
    my $approval = new GetDeploy::Approval();
    my @approvalList = $deploy->getApprovals();
    $approval = $approvalList[0];
    my $approvalJsonStr = "\"approvals\": [{\"signer\": \"".$approval->getSigner()."\",\"signature\": \"".$approval->getSignature()."\"}]";
    my $hashStr = "\"hash\": \"".$deploy->getDeployHash()."\"";
    my $deployJsonStr = "{\"id\": 1,\"method\": \"account_put_deploy\",\"jsonrpc\": \"2.0\",\"params\": [{".$headerString.",".$paymentJsonStr.",".$sessionJsonStr.",".$approvalJsonStr.",".$hashStr."}]}";
    return $deployJsonStr;
}
1;