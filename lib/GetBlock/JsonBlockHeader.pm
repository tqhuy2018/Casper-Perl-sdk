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

# get-set method for _bodyHash
sub setBodyHash {
	my ( $self, $value) = @_;
	$self->{_bodyHash} = $value if defined($value);
	return $self->{_bodyHash};
}

sub getBodyHash {
	my ( $self ) = @_;
	return $self->{_bodyHash};
}

# get-set method for _randomBit
sub setRandomBit {
	my ( $self, $value) = @_;
	$self->{_randomBit} = $value if defined($value);
	return $self->{_randomBit};
}

sub getRandomBit {
	my ( $self ) = @_;
	return $self->{_randomBit};
}

# get-set method for _accumulatedSeed
sub setAccumulatedSeed {
	my ( $self, $value) = @_;
	$self->{_accumulatedSeed} = $value if defined($value);
	return $self->{_accumulatedSeed};
}

sub getAccumulatedSeed {
	my ( $self ) = @_;
	return $self->{_accumulatedSeed};
}

# get-set method for _eraEnd
sub setEraEnd {
	my ( $self, $value) = @_;
	$self->{_eraEnd} = $value if defined($value);
	return $self->{_eraEnd};
}

sub getEraEnd {
	my ( $self ) = @_;
	return $self->{_eraEnd};
}

# get-set method for _timestamp
sub setTimestamp {
	my ( $self, $value) = @_;
	$self->{_timestamp} = $value if defined($value);
	return $self->{_timestamp};
}

sub getTimestamp {
	my ( $self ) = @_;
	return $self->{_timestamp};
}

# get-set method for _eraId
sub setEraId {
	my ( $self, $value) = @_;
	$self->{_eraId} = $value if defined($value);
	return $self->{_eraId};
}

sub getEraId {
	my ( $self ) = @_;
	return $self->{_eraId};
}

# get-set method for _height
sub setHeight {
	my ( $self, $value) = @_;
	$self->{_height} = $value if defined($value);
	return $self->{_height};
}

sub getHeight {
	my ( $self ) = @_;
	return $self->{_height};	
}

# get-set method for _protocolVersion
sub setProtocolVersion {
	my ( $self, $value) = @_;
	$self->{_protocolVersion} = $value if defined($value);
	return $self->{_protocolVersion};
}

sub getProtocolVersion {
	my ( $self ) = @_;
	return $self->{_protocolVersion};	
}

# This function parse the JsonObject (taken from server RPC method call) to JsonBlockHeader object
sub fromJsonObjectToJsonBlockHeader {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonBlockHeader();
	$ret->setParentHash($json->{'parent_hash'});
	$ret->setStateRootHash($json->{'state_root_hash'});
	$ret->setBodyHash($json->{'body_hash'});
	$ret->setRandomBit($json->{'random_bit'});
	$ret->setAccumulatedSeed($json->{'accumulated_seed'});
	if($json->{'era_end'}) {
		my $eraEnd = GetBlock::JsonEraEnd->fromJsonObjToJsonEraEnd($json->{'era_end'});
		$ret->setEraEnd($eraEnd);
	}
	$ret->setTimestamp($json->{'timestamp'});
	$ret->setEraId($json->{'era_id'});
	$ret->setHeight($json->{'height'});
	$ret->setProtocolVersion($json->{'protocol_version'});
	return $ret;
}
1;