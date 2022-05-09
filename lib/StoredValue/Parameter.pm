# Class built for storing Parameter information
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

# This function parse the JsonObject (taken from server RPC method call) to get the Account object
sub fromJsonObjectToParameter {
	
}
1;