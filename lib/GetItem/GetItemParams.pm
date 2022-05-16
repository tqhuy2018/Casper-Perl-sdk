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

# get-set method for _key
sub setKey {
	my ( $self, $value) = @_;
	$self->{_key} = $value if defined($value);
	return $self->{_key};
}

sub getKey {
	my ( $self ) = @_;
	return $self->{_key};
}

# get-set method for _path
sub setPath {
	my ( $self, @value) = @_;
	$self->{_path} = \@value;
	return $self->{_path};
}

sub getPath {
	my ( $self ) = @_;
	my @list = @{$self->{_path}};
	wantarray ? @list : \@list;
}

# This function generate the parameter for the post method of the state_get_item RPC call, based on its value of
# _stateRootHash, _key and _path.
# the generated Json string from this function is somehow like this:
# {"method" : "state_get_item","id" : 1,"params" :{"state_root_hash" : "d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228","key":"withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1","path":[]},"jsonrpc" : "2.0"}
sub generateParameterStr {
	my ($self) = @_;
	my @listPath = @{$self->{_path}};
	my $totalPath = @listPath;
	my $pathStr = "[";
	if($totalPath > 0) {
		my $counter = 0;
		foreach(@listPath) {
			my $onePath = $_;
			$pathStr = $pathStr.'"'.$onePath.'"';
			if($counter < $totalPath-1) {
				$pathStr = $pathStr.",";
			}
			$counter ++;
		}
	}
	$pathStr = $pathStr."]";
	return '{"id": 1, "method": "state_get_item" , "params": {"state_root_hash": "'.$self->{_stateRootHash}.'", "key": "'.$self->{_key}.'", "path": '.$pathStr.'},  "jsonrpc": "2.0"}';
}
1;
