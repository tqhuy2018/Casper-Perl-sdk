=comment
This class is used for storing private/public key pair, used for Secp256k1 and Ed25519 key pair
=cut

package CryptoHandle::KeyPair;

sub new {
	my $class = shift;
	my $self = {
		_privateKey => shift,
		_publicKey => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _privateKey
sub setPrivateKey {
	my ( $self, $value) = @_;
	$self->{_privateKey} = $value if defined($value);
	return $self->{_privateKey};
}

sub getPrivateKey {
	my ( $self ) = @_;
	return $self->{_privateKey};
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
1;