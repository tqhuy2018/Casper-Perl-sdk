# Class built for storing JsonBids information
package GetAuction::JsonBids;
use GetAuction::JsonBid;
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

# This function parse the JsonObject (taken from server RPC method call) to JsonBids object
sub fromJsonObjectToJsonBids {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::JsonBids();
	my $bid = GetAuction::JsonBid->fromJsonObjectToJsonBid($json->{'bid'});
	$ret->setBid($bid);
	$ret->setPublicKey($json->{'public_key'});
	return $ret;
}
1;
