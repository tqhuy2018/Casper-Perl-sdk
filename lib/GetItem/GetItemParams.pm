# Class built for storing GetItemParams information. This class generate the string parameter to send the 
# post method for the state_get_item RPC call
package GetItem::GetItemParams;
sub new {
	my $class = shift;
	my $self = {
		_stateRootHash => shift,
		_key => shift, 
		_path => [ @_ ], # list of Path in String format
	};
	bless $self, $class;
	return $self;
}

# get-set method for _stateRootHash
sub setStateRootHash {
	my ( $self, $value) = @_;
	$self->{_stateRootHash} = $value if defined($value);
	return $self->{_stateRootHash};
}

sub getStateRootHash {
	my ( $self ) = @_;
	return $self->{_stateRootHash};
}

# This function generate the parameter for the post method of the state_get_item RPC call
sub generateParameterStr {
	
}
1;
