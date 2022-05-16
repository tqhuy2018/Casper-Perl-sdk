=comment
This class hold the information of the MinimalBlockInfo
and handles the work of parsing a Json object to a MinimalBlockInfo object
=cut
package GetStatus::MinimalBlockInfo;

sub new {
	my $class = shift;
	my $self = {
		_creator => shift,
		_eraId => shift,
		_blockHash => shift,
		_height => shift, 
		_stateRootHash => shift,
		_timeStamp => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _creator
sub setCreator {
	my ( $self, $value) = @_;
	$self->{_creator} = $value if defined($value);
	return $self->{_creator};
}

sub getCreator {
	my ( $self ) = @_;
	return $self->{_creator};
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

# get-set method for _blockHash
sub setBlockHash {
	my ( $self, $value) = @_;
	$self->{_blockHash} = $value if defined($value);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
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

# get-set method for _timeStamp
sub setTimeStamp {
	my ( $self, $value) = @_;
	$self->{_timeStamp} = $value if defined($value);
	return $self->{_timeStamp};
}

sub getTimeStamp {
	my ( $self ) = @_;
	return $self->{_timeStamp};
}

# This function parse a Json object to a MinimalBlockInfo object
sub fromJsonObjectToMinimalBlockInfo {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetStatus::MinimalBlockInfo();
	$ret->setCreator($json->{'creator'});
	$ret->setEraId($json->{'era_id'});
	$ret->setBlockHash($json->{'hash'});
	$ret->setHeight($json->{'height'});
	$ret->setStateRootHash($json->{'state_root_hash'});
	$ret->setTimeStamp($json->{'timestamp'});
	return $ret;
}
1;