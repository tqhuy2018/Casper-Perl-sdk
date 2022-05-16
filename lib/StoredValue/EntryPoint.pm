# Class built for storing EntryPoint information, which used in StoredValue object
# and handles the work of parsing the Json object (taken from server RPC method call) to get the EntryPoint object
package StoredValue::EntryPoint;
use CLValue::CLType;
use StoredValue::Parameter;
use StoredValue::EntryPointAccess;
sub new {
	my $class = shift;
	my $self = {
		_access => shift, # EntryPointAccess object
		_args => [ @_ ], # list of Parameter object
		_name => shift,
		_ret => shift, # of type CLType
		_entryPointType => shift, # String of either Session or Contract - an enum type
	};
	bless $self, $class;
	return $self;
}

# get-set method for _access
sub setAccess {
	my ( $self, $value) = @_;
	$self->{_access} = $value if defined($value);
	return $self->{_access};
}

sub getAccess {
	my ( $self ) = @_;
	return $self->{_access};
}

# get-set method for _name
sub setName {
	my ( $self, $value) = @_;
	$self->{_name} = $value if defined($value);
	return $self->{_name};
}

sub getName {
	my ( $self ) = @_;
	return $self->{_name};
}

# get-set method for _ret
sub setRet {
	my ( $self, $value) = @_;
	$self->{_ret} = $value if defined($value);
	return $self->{_ret};
}

sub getRet {
	my ( $self ) = @_;
	return $self->{_ret};
}

# get-set method for _entryPointType
sub setEntryPointType {
	my ( $self, $value) = @_;
	$self->{_entryPointType} = $value if defined($value);
	return $self->{_entryPointType};
}

sub getEntryPointType {
	my ( $self ) = @_;
	return $self->{_entryPointType};
}

# get-set method for _args
sub setArgs {
	my ( $self, @value) = @_;
	$self->{_args} = \@value;
	return $self->{_args};
}

sub getArgs {
	my ( $self ) = @_;
	my @list = @{$self->{_args}};
	wantarray ? @list : \@list;
}

# This function parse the Json object (taken from server RPC method call) to get the EntryPoint object
sub fromJsonObjectToEntryPoint {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::EntryPoint();
	$ret->setName($json->{'name'});
	
	# get list of Parameter in args
	my @listJson = @{$json->{'args'}};
	my $total = @listJson;
	if($total > 0) {
		my @listP = ();
		foreach(@listJson) {
			my $oneP = StoredValue::Parameter->fromJsonObjectToParameter($_);
			push(@listP, $oneP);
		}
		$ret->setNamedKeys(@listP);
	}
	my $clType = CLValue::CLType->getCLType($json->{'ret'});
	$ret->setRet($clType);
	$ret->setEntryPointType($json->{'entry_point_type'});
	# get access - of type EntryPointAccess
	my $accessJson = $json->{'access'};
	my $access = StoredValue::EntryPointAccess->fromJsonObjectToEntryPointAccess($json->{'access'});
	$ret->setAccess($access);
	return $ret;
}
1;