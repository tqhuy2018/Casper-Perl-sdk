# Class built for storing ActionThresholds information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the ActionThresholds object
package StoredValue::ActionThresholds;
sub new {
	my $class = shift;
	my $self = {
		_deployment => shift,
		_keyManagement => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _deployment
sub setDeployment {
	my ( $self, $value) = @_;
	$self->{_deployment} = $value if defined($value);
	return $self->{_deployment};
}

sub getDeployment {
	my ( $self ) = @_;
	return $self->{_deployment};
}

# get-set method for _keyManagement
sub setKeyManagement {
	my ( $self, $value) = @_;
	$self->{_keyManagement} = $value if defined($value);
	return $self->{_keyManagement};
}

sub getKeyManagement {
	my ( $self ) = @_;
	return $self->{_keyManagement};
}

# This function parse the JsonObject (taken from server RPC method call) to get the ActionThresholds object
sub fromJsonObjectToActionThresholds {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::ActionThresholds();
	$ret->setDeployment($json->{'deployment'});
	$ret->setKeyManagement($json->{'key_management'});
	return $ret;
}
1;