# Class built for storing GetAuctionInfoResult information, taken from state_get_item RPC method
package GetAuction::GetAuctionInfoResult;
use GetAuction::AuctionState;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_auctionState => shift,  # GetAuction::AuctionState object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _apiVersion
sub setApiVersion {
	my ( $self, $value) = @_;
	$self->{_apiVersion} = $value if defined($value);
	return $self->{_apiVersion};
}

sub getApiVersion {
	my ( $self ) = @_;
	return $self->{_apiVersion};
}

# get-set method for _auctionState
sub setAuctionState {
	my ( $self, $value) = @_;
	$self->{_auctionState} = $value if defined($value);
	return $self->{_auctionState};
}

sub getAuctionState {
	my ( $self ) = @_;
	return $self->{_auctionState};
}

# This function parse the JsonObject (taken from server RPC method call) to generate the GetAuctionInfoResult object
sub fromJsonToGetItemResult { 
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::GetAuctionInfoResult();
	$ret->setApiVersion($json->{'api_version'});
	my $as = GetAuction::AuctionState->fromJsonObjectToAuctionState($json->{'auction_state'});
	$ret->setAuctionState($as);
	return $ret;
}
1;