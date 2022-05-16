# Class built for storing VestingSchedule information
# and handles the change from Json object to VestingSchedule object
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
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::VestingSchedule();
	$ret->setInitialReleaseTimestampMillis($json->{'initial_release_timestamp_millis'});
	my @listLAJson = @{$json->{'locked_amounts'}};
	my $totalLA = @listLAJson;
	if($totalLA > 0 ) {
		my @listLA = ();
		foreach(@listLAJson) {
			push(@listLA,$_);
		}
		$ret->setLockedAmounts(@listLA);
	}
	return $ret;
}
1;