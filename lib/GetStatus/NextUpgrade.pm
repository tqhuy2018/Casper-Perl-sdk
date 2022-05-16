=comment
This class hold the information of the NextUpgrade and handles the work of parsing Json object to a NextUpgrade object
=cut
package GetStatus::NextUpgrade;
use Scalar::Util qw(looks_like_number);
sub new {
	my $class = shift;
	my $self = {
		_protocolVersion => shift,
		_activationPointEraId => shift,
		_activationPointTimestamp => shift, # Optional value
	};
	bless $self, $class;
	return $self;
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

# get-set method for _activationPointEraId
sub setActivationPointEraId {
	my ( $self, $value) = @_;
	$self->{_activationPointEraId} = $value if defined($value);
	return $self->{_activationPointEraId};
}

sub getActivationPointEraId {
	my ( $self ) = @_;
	return $self->{_activationPointEraId};
}

# get-set method for _activationPointTimestamp
sub setActivationPointTimestamp {
	my ( $self, $value) = @_;
	$self->{_activationPointTimestamp} = $value if defined($value);
	return $self->{_activationPointTimestamp};
}

sub getActivationPointTimestamp {
	my ( $self ) = @_;
	return $self->{_activationPointTimestamp};
}

# This function parse a Json object to a NextUpgrade object
sub fromJsonObjectToNextUpgrade {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetStatus::NextUpgrade();
	$ret->setProtocolVersion($json->{'protocol_version'});
	if (looks_like_number($json->{'activation_point'})) {
		$ret->setActivationPointEraId($json->{'activation_point'});	
	} else {
		$ret->setActivationPointTimestamp($json->{'activation_point'});
	}
	return $ret;
}
1;