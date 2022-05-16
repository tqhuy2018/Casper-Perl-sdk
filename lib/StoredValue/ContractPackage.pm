# Class built for storing EntryPoint information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the ContractPackage object
package StoredValue::ContractPackage;

sub new {
	my $class = shift;
	my $self = {
		_accessKey => shift,
		_disabledVersions => [ @_ ], # list of DisabledVersion object
		_groups => [ @_ ], # list of Groups object
		_versions => [ @_ ], # list of ContractVersion object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _accessKey
sub setAccessKey {
	my ( $self, $value) = @_;
	$self->{_accessKey} = $value if defined($value);
	return $self->{_accessKey};
}

sub getAccessKey {
	my ( $self ) = @_;
	return $self->{_accessKey};
}
# get-set method for _disabledVersions
sub setDisabledVersions {
	my ( $self, @value) = @_;
	$self->{_disabledVersions} = \@value;
	return $self->{_disabledVersions};
}

sub getDisabledVersions {
	my ( $self ) = @_;
	my @list = @{$self->{_disabledVersions}};
	wantarray ? @list : \@list;
}

# get-set method for _groups
sub setGroups {
	my ( $self, @value) = @_;
	$self->{_groups} = \@value;
	return $self->{_groups};
}

sub getGroups {
	my ( $self ) = @_;
	my @list = @{$self->{_groups}};
	wantarray ? @list : \@list;
}

# get-set method for _versions
sub setVersions {
	my ( $self, @value) = @_;
	$self->{_versions} = \@value;
	return $self->{_versions};
}

sub getVersions {
	my ( $self ) = @_;
	my @list = @{$self->{_versions}};
	wantarray ? @list : \@list;
}

# This function parse the Json object (taken from server RPC method call) to get the ContractPackage object 
sub fromJsonObjectToContractPackage {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::ContractPackage();
	$ret->setAccessKey($json->{'access_key'});
	
	# get list of DisableVersion object
	my @listDVJson = @{$json->{'disabled_versions'}};
	my $totalDV = @listDVJson;
	if($totalDV > 0) {
		my @listDV = ();
		foreach(@listDVJson) {
			my $oneDV = StoredValue::DisabledVersion->fromJsonObjectToDisabledVersion($_);
			push(@listDV,$oneDV);
		}
		$ret->setDisabledVersions(@listDV);
	}
	
	# get list of Groups object
	my @listGroupJson = @{$json->{'groups'}};
	my $totalGroup = @listGroupJson;
	if($totalGroup > 0) {
		my @listGroup = ();
		foreach(@listGroupJson) {
			my $oneGroup = StoredValue::Groups->fromJsonObjectToGroups($_);
			push(@listGroup,$oneGroup);
		}
		$ret->setGroups(@listGroup);
	}
	
	# get list of ContractVersion object
	my @listVersionJson = @{$json->{'versions'}};
	my $totalVersion = @listVersionJson;
	if($totalVersion > 0) {
		my @listVersion = ();
		foreach(@listVersionJson) {
			my $oneVersion = StoredValue::ContractVersion->fromJsonObjectToContractVersion($_);
			push(@listVersion,$oneVersion);
		}
		$ret->setVersions(@listVersion);
	}
	return $ret;
}