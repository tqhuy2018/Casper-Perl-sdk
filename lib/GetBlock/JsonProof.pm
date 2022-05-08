# Class built for storing JsonProof information
package GetBlock::JsonProof;

sub new {
	my $class = shift;
	my $self = {
		_publicKey => shift, 
		_signature => shift,
	};
	bless $self, $class;
	return $self;
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

# get-set method for _validator
sub setSignature {
	my ( $self, $value) = @_;
	$self->{_signature} = $value if defined($value);
	return $self->{_signature};
}

sub getSignature {
	my ( $self ) = @_;
	return $self->{_signature};
}

# This function parse the JsonObject (taken from server RPC method call) to JsonProof object
sub fromJsonToJsonProof {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonProof();
	$ret->setPublicKey($json->{'public_key'});
	$ret->setSignature($json->{'signature'});
	return $ret;
}
1;