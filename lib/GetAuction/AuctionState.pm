# Class built for storing AuctionState information
package GetAuction::AuctionState;
use GetAuction::JsonEraValidators;
use GetAuction::JsonBids;

sub new {
	my $class = shift;
	my $self = {
		_stateRootHash => shift,
		_blockHeight => shift, 
		_eraValidators => [ @_ ], # list of JsonEraValidators object
		_bids => [ @_ ], # list of JsonBids object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _stateRootHash
sub setStateRootHash {
	my ( $self, $value) = @_;
	$self->{_stateRootHash} = $value if defined($value);
	return $self->{_stateRootHash};
}

sub getStateRootHash {
	my ( $self ) = @_;
	return $self->{_stateRootHash};
}

# get-set method for _blockHeight
sub setBlockHeight {
	my ( $self, $value) = @_;
	$self->{_blockHeight} = $value if defined($value);
	return $self->{_blockHeight};
}

sub getBlockHeight {
	my ( $self ) = @_;
	return $self->{_blockHeight};
}

# get-set method for _eraValidators
sub setEraValidators {
	my ( $self, @value) = @_;
	$self->{_eraValidators} = \@value;
	return $self->{_eraValidators};
}

sub getEraValidators {
	my ( $self ) = @_;
	my @list = @{$self->{_eraValidators}};
	wantarray ? @list : \@list;
}

# get-set method for _bids
sub setBids {
	my ( $self, @value) = @_;
	$self->{_bids} = \@value;
	return $self->{_bids};
}

sub getBids {
	my ( $self ) = @_;
	my @list = @{$self->{_bids}};
	wantarray ? @list : \@list;
}

# This function parse the JsonObject (taken from server RPC method call) to AuctionState object
sub fromJsonObjectToAuctionState {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::AuctionState();
	$ret->setStateRootHash($json->{'state_root_hash'});
	$ret->setBlockHeight($json->{'block_height'});
	my @eraValidaforJsonList = @{$json->{'era_validators'}};
	my $totalEV = @eraValidaforJsonList;
	if($totalEV > 0 ) {
		my @listEV = ();
		foreach(@eraValidaforJsonList) {
			my $oneEV = GetAuction::JsonEraValidators->fromJsonObjectToJsonEraValidators($_);
			push(@listEV,$oneEV);
		}
		$ret->setEraValidators(@listEV);
	}
	my @bidListJson = @{$json->{'bids'}};
	my $totalBid = @bidListJson;
	if($totalBid > 0) {
		my @listBid = ();
		foreach(@bidListJson) {
			my $oneBid = GetAuction::JsonBids->fromJsonObjectToJsonBids($_);
			push(@listBid,$oneBid);
		}
		$ret->setBids(@listBid);
	}
	return $ret;
}
1;