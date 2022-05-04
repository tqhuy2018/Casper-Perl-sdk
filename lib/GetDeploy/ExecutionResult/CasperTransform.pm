# Class built for storing Transform information

package GetDeploy::ExecutionResult::CasperTransform;

sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => [ @_ ],
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsType

sub setItsType {
	my ($self,$itsType) = @_;
	$self->{_itsType} = $itsType if defined($itsType);
	return $self->{_itsType};
}

sub getItsType {
	my ($self) = @_;
	return $self->{_itsType};
}

# get-set method for _itsValue

sub setItsValue {
	my ($self,@list) = @_;
	$self->{_itsValue} = \@list;
	return $self->{_itsValue};
}
sub getItsValue {
	my ($self) = @_;
	my @ret = @{$self->{_itsValue}};
	wantarray ? @ret : \@ret;
}
1;