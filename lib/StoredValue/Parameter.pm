# Class built for storing Parameter information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the Parameter object
package StoredValue::Parameter;
sub new {
	my $class = shift;
	my $self = {
		_name => shift,
		_clType => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _name
sub setName {
	my ( $self, $value) = @_;
	$self->{_name} = $value if defined($value);
	return $self->{_name};
}

sub getName {
	my ( $self ) = @_;
	return $self->{_name};
}

# get-set method for _name
sub setClType {
	my ( $self, $value) = @_;
	$self->{_clType} = $value if defined($value);
	return $self->{_clType};
}

sub getClType {
	my ( $self ) = @_;
	return $self->{_clType};
}

# This function parse the Json object (taken from server RPC method call) to get the Parameter object
sub fromJsonObjectToParameter {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::Parameter();
	$ret->setName($json->{'name'});
	my $clType = CLValue::CLType->getCLType($json->{'cl_type'});
	$ret->setClType($clType);
	return $ret;
}
1;