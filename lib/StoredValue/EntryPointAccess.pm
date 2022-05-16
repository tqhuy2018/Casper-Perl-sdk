# Class built for storing EntryPointAccess information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the EntryPointAccess object
package StoredValue::EntryPointAccess;
sub new {
	my $class = shift;
	my $self = {
		_isPublic => shift, 
		_groups => [ @_ ], # list of Group object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _isPublic
sub setIsPublic {
	my ( $self, $value) = @_;
	$self->{_isPublic} = $value if defined($value);
	return $self->{_isPublic};
}

sub getIsPublic {
	my ( $self ) = @_;
	return $self->{_isPublic};
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

# This function parse the Json object (taken from server RPC method call) to get the EntryPointAccess object 
sub fromJsonObjectToEntryPointAccess {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::EntryPointAccess();
	if ($json eq "Public") { # access of type Public enum
		$ret->setAccess($json);
	} else { # access of type Groups - list of Group object
		my @listGroupJson = @{$json->{'Groups'}};
		my $totalGroup = @listGroupJson;
		if($totalGroup > 0) {
			my @listGroup = ();
			foreach(@listGroupJson) {
				push(@listGroup,$_);
			}
			$ret->setGroups(@listGroup);
		}
	}
	return $ret;
}
1;