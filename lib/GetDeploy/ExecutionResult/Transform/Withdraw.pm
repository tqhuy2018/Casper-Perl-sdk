# Class built for storing Withdraw information
# and handles the change from Json object to Withdraw object
package GetDeploy::ExecutionResult::Transform::Withdraw;
use GetDeploy::ExecutionResult::Transform::UnbondingPurse;
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
	my @list = @_;
	my @json = @{$list[1]};
	my $totalWithdraw = @json;
	my @listUP = ();
	foreach(@json) {
		my $oneUP = GetDeploy::ExecutionResult::Transform::UnbondingPurse->fromJsonToUnbondingPurse($_);
		push(@listUP,$oneUP);
	}
	my $ret = new GetDeploy::ExecutionResult::Transform::Withdraw();
	$ret->setListUnbondingPurse(@listUP);
	return $ret;
}
1;