# Class built for storing Groups information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the Groups object
package StoredValue::Groups;
sub new {
	my $class = shift;
	my $self = {
		_group => shift,
		_keys => [ @_ ], # list of URef - in String format
	};
	bless $self, $class;
	return $self;
}

# get-set method for _group
sub setGroup {
	my ( $self, $value) = @_;
	$self->{_group} = $value if defined($value);
	return $self->{_group};
}

sub getGroup {
	my ( $self ) = @_;
	return $self->{_group};
}

# get-set method for _keys
sub setKeys {
	my ( $self, @value) = @_;
	$self->{_keys} = \@value;
	return $self->{_keys};
}

sub getKeys {
	my ( $self ) = @_;
	my @list = @{$self->{_keys}};
	wantarray ? @list : \@list;
}

# This function parse the Json object (taken from server RPC method call) to get the Groups object
sub fromJsonObjectToGroups {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::Groups();
	$ret->setGroup($json->{'group'});
	# get list of keys 
	my @listJson = @{$json->{'keys'}};
	my $total = @listJson;
	if($total > 0) {
		my @listK = ();
		foreach(@listJson) {
			push(@listK, $_);
		}
		$ret->setKeys(@listK);
	}
	return $ret;
}
1;