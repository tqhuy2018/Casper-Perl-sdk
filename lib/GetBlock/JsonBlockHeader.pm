# Class built for storing JsonBlockHeader information
package GetBlock::JsonBlockHeader;
sub new {
	my $class = shift;
	my $self = {
		_parentHash => shift,
		_stateRootHash => shift,
		_bodyHash => shift,
		_randomBit => shift,
		_accumulatedSeed => shift,
		_eraEnd => shift, # JsonEraEnd object 
		_timestamp => shift,
		_eraId => shift,
		_height => shift,
		_protocolVersion => shift,
		_proofs = [ @_ ], # list of JsonProof
	};
	bless $self, $class;
	return $self;
}

# get-set method for _parentHash
sub setParentHash {
	my ( $self, $value) = @_;
	$self->{_parentHash} = $value if defined($value);
	return $self->{_parentHash};
}

sub getParentHash {
	my ( $self ) = @_;
	return $self->{_parentHash};
}
sub fromJsonObjectToJsonBlockHeader {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonBlockHeader();
	$ret->setProposer($json->{'proposer'});
	return $ret;
}
1;
