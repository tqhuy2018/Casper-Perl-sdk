# Class built for storing Account information, which used in StoredValue object
# and handles the work of parsing the JsonObject (taken from server RPC method call) to get the Account object
package StoredValue::Account;
use StoredValue::ActionThresholds;
use StoredValue::AssociatedKey;
sub new {
	my $class = shift;
	my $self = {
		_accountHash => shift,
		_namedKeys => [ @_ ], # List of NamedKey
		_mainPurse => shift,
		_associatedKeys => [ @_ ], # List of AssociatedKey
		_actionThresholds => shift, # ActionThresholds object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _accountHash
sub setAccountHash {
	my ( $self, $value) = @_;
	$self->{_accountHash} = $value if defined($value);
	return $self->{_accountHash};
}
 
sub getAccountHash {
	my ( $self ) = @_;
	return $self->{_accountHash};
}

# get-set method for _namedKeys
sub setNamedKeys {
	my ( $self, @value) = @_;
	$self->{_namedKeys} = \@value;
	return $self->{_namedKeys};
}

sub getNamedKeys {
	my ( $self ) = @_;
	my @list = @{$self->{_namedKeys}};
	wantarray ? @list : \@list;
}

# get-set method for _mainPurse
sub setMainPurse {
	my ( $self, $value) = @_;
	$self->{_mainPurse} = $value if defined($value);
	return $self->{_mainPurse};
}

sub getMainPurse {
	my ( $self ) = @_;
	return $self->{_mainPurse};
}

# get-set method for _associatedKeys
sub setAssociatedKeys {
	my ( $self, @value) = @_;
	$self->{_associatedKeys} = \@value;
	return $self->{_associatedKeys};
}

sub getAssociatedKeys {
	my ( $self ) = @_;
	my @list = @{$self->{_associatedKeys}};
	wantarray ? @list : \@list;
}

# get-set method for _actionThresholds
sub setActionThresholds {
	my ( $self, $value) = @_;
	$self->{_actionThresholds} = $value if defined($value);
	return $self->{_actionThresholds};
}

sub getActionThresholds {
	my ( $self ) = @_;
	return $self->{_actionThresholds};
}

# This function parse the JsonObject (taken from server RPC method call) to get the Account object
sub fromJsonObjectToAccount {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::Account();
	$ret->setAccountHash($json->{'account_hash'});
	$ret->setMainPurse($json->{'main_purse'});
	my $at = StoredValue::ActionThresholds->fromJsonObjectToActionThresholds($json->{'action_thresholds'});
	$ret->setActionThresholds($at);
	# get NameKeys
	my @listNKJson = @{$json->{'named_keys'}};
	my $totalNK = @listNKJson;
	if($totalNK > 0) {
		my @listNK = ();
		foreach(@listNKJson) {
			my $oneNK = GetDeploy::ExecutionResult::Transform::NamedKey->fromJsonObjectToNamedKey($_);
			push(@listNK, $oneNK);
		}
		$ret->setNamedKeys(@listNK);
	}
	# get AssociatedKey
	my @listAKJson = @{$json->{'associated_keys'}};
	my $totalAK = @listAKJson;
	if($totalAK > 0) {
		my @listAK = ();
		foreach(@listAKJson) {
			my $oneAK = StoredValue::AssociatedKey->fromJsonObjectToAssociatedKey($_);
			push(@listAK,$oneAK);
		}
		$ret->setAssociatedKeys(@listAK);
	}
	return $ret;
}
1;