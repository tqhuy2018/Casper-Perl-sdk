#!/usr/bin/perl
use LWP::UserAgent;
use Data::Dumper;

package GetStateRootHashRPC;

use ErrorException;

use JSON qw( decode_json );

sub new {
	print "GetStateRootHashRPC called";
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub getStateRootHash {
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
	    	#die "\nError exception";
	    } else {
		    print "\napi_version:" . $decoded->{'result'}{'api_version'}."\n";
		    my $stateRootHash = $decoded->{'result'}{'state_root_hash'};
		   	print "state root hash:".$stateRootHash."\n";
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;