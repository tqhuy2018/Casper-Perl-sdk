
package BlockIdentifier;

sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_blockHeight => shift,
		_isNone => shift,
	};
	bless $self, $class;
	return $self;
}
sub setBlockHash {
	my ( $self, $blockHash) = @_;
	$self->{_blockHash} = $blockHash if defined($blockHash);
	return $self->{_blockHash};
}
sub setBlockHeight {
	my ( $self, $blockHeight) = @_;
	$self->{_blockHeight} = $blockHeight if defined($blockHeight);
	return $self->{_blockHeight};
}
sub setIsNone {
	my ( $self, $isNone) = @_;
	$self->{_isNone} = $isNone if defined($isNone);
	return $self->{_isNone};
}
sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}
1;
