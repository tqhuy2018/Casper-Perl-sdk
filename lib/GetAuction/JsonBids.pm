# Class built for storing JsonBids information
package GetAuction::JsonBids;
sub new {
	my $class = shift;
	my $self = {
		_bid => shift, # JsonBid object
		_publicKey => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _bid
sub setBid {
	my ( $self, $value) = @_;
	$self->{_bid} = $value if defined($value);
	return $self->{_bid};
}

sub getBid {
	my ( $self ) = @_;
	return $self->{_bid};
}

# get-set method for _publicKey
sub setPublicKey {
	my ( $self, $value) = @_;
	$self->{_publicKey} = $value if defined($value);
	return $self->{_publicKey};
}

sub getPublicKey {
	my ( $self ) = @_;
	return $self->{_publicKey};
}
