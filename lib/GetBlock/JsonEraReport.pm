# Class built for storing JsonEraReport information
package GetBlock::JsonEraReport;

sub new {
	my $class = shift;
	my $self = {
		_equivocators => [ @_ ], # list of PublicKey, in String format
		_inactiveValidators => [ @_ ], # list of PublicKey, in String format
		_rewards => [ @_ ], # list of Reward object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _equivocators
sub setEquivocators {
	my ( $self, @value) = @_;
	$self->{_equivocators} = \@value;
	return $self->{_equivocators};
}

sub getEquivocators {
	my ( $self ) = @_;
	my @list = @{$self->{_equivocators}};
	wantarray ? @list : \@list;
}

# get-set method for _inactiveValidators
sub setInactiveValidators {
	my ( $self, @value) = @_;
	$self->{_inactiveValidators} = \@value;
	return $self->{_inactiveValidators};
}

sub getInactiveValidators {
	my ( $self ) = @_;
	my @list = @{$self->{_inactiveValidators}};
	wantarray ? @list : \@list;
}

# get-set method for _rewards
sub setRewards {
	my ( $self, @value) = @_;
	$self->{_rewards} = \@value;
	return $self->{_rewards};
}

sub getRewards {
	my ( $self ) = @_;
	my @list = @{$self->{_rewards}};
	wantarray ? @list : \@list;
}

# This function parse the JsonObject (taken from server RPC method call) to JsonEraReport object
sub fromJsonToJsonEraReport {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonEraReport();
	my @listEJson = $json->{'equivocators'};
	my $totalE = @listEJson;
	if($totalE > 0) {
		my @listE = ();
		foreach(@listEJson) {
			push(@listE,$_);
		}
		$ret->setEquivocators(@listE);
	}
	my @listVJson = $json->{'inactive_validators'};
	my $totalV = @listVJson;
	if($totalV > 0 ) {
		my @listV = ();
		foreach(@listVJson) {
			push(@listV, $_);
		}
		$ret->setInactiveValidators(@listV);
	}
	my @listRewardJson = $json->{'rewards'};
	my $totalR = @listRewardJson;
	if($totalR > 0) {
		my @listReward = ();
		foreach(@listRewardJson) {
			my $oneReward = GetBlock::Reward->fromJsonToReward($_);
			push(@listReward,$oneReward);
		}
		$ret->setRewards(@listReward);
	}
	return $ret;
}
1;