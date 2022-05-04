# Class built for storing VestingSchedule information

package GetDeploy::ExecutionResult::Transform::VestingSchedule;

sub new {
	my $class = shift,
	my $self = {
		_initialReleaseTimestampMillis => shift,
		_lockedAmounts => [ @_ ], # List of U512Class object
	};
	bless $self,$class;
	return $self;
}

# get-set method for _initialReleaseTimestampMillis
sub setInitialReleaseTimestampMillis {
	my ($self,$value) = @_;
	$self->{_initialReleaseTimestampMillis} = $value if defined($value);
	return $self->{_initialReleaseTimestampMillis};
}
sub getInitialReleaseTimestampMillis {
	my ($self)  = @_;
	return $self->{_initialReleaseTimestampMillis};
}

# get-set method for _lockedAmounts
sub setLockedAmounts {
	my ( $self, @list) = @_;
	$self->{_lockedAmounts} = \@list;
	return $self->{_lockedAmounts};
}

sub getLockedAmounts {
	my ( $self ) = @_;
	my @list = @{ $self->{_lockedAmounts} };
	wantarray ? @list :\@list;
}

# This function parse the JsonObject (taken from server RPC method call) to get the VestingSchedule object
sub fromJsonToVestingSchedule {
	
}