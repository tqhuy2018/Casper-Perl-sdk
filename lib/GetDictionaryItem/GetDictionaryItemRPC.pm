# Class built for state_get_dictionary_item RPC call
package GetDictionaryItem::GetDictionaryItemRPC;
use LWP::UserAgent;
use Data::Dumper;
use Common::ErrorException;
use JSON qw( decode_json );
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
	
=cut
sub getDictionaryItem {
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
		    my $ret = GetDictionaryItem::GetDictionaryItemResult->fromJsonToGetDictionaryItemResult($decoded->{'result'});
		   	return $ret;
	    }
	}
	else {
	    die $response->status_line;
	}
}
1;