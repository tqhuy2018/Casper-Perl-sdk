# Class built for storing Operation information
# and handles the change from Json object to CasperOperation object
package GetDeploy::ExecutionResult::CasperOperation;

sub new {
	my $class = shift;
	my $self = {
		_key => shift,
		_kind => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _key
sub setKey {
	my ($self,$key) = @_;
	$self->{_key} = $key if defined($key);
	return $self->{_key};
}
sub getKey {
	my ($self)  = @_;
	return $self->{_key};
}

# get-set method for _kind
sub setKind {
	my ($self,$kind) = @_;
	$self->{_kind} = $kind if defined($kind);
	return $self->{_kind};
}
sub getKind {
	my ($self) = @_;
	return $self->{_kind};
}

# This function turn Json Object to a CasperOperation object
sub fromJsonObjectToCasperOperation {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::CasperOperation();
	$ret->setKey($json->{'key'});
	$ret->setKind($json->{'kind'});
	return $ret;
}
1;