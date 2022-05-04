# Class built for storing Withdraw information

package GetDeploy::ExecutionResult::Transform::Withdraw;

sub new {
	my $class = shift,
	my $self = {
		_listUnbondingPurse => [ @_ ], # List of UnbondingPurse object
	};
	bless $self,$class;
	return $self;
}

# get-set method for _listUnbondingPurse
sub setListUnbondingPurse {
	my ( $self, @list) = @_;
	$self->{_listUnbondingPurse} = \@list;
	return $self->{_listUnbondingPurse};
}

sub getListUnbondingPurse {
	my ( $self ) = @_;
	my @list = @{ $self->{_listUnbondingPurse} };
	wantarray ? @list :\@list;
}
# This function parse the JsonArray (taken from server RPC method call) to get the Withdraw object with UnbondingPurse list
sub fromJsonArrayToWithdraw {
	
}