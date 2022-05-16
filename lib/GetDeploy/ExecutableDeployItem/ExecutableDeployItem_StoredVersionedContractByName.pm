=comment
Class built for storing ExecutableDeployItem enum of type StoredContractVersionedByHash
and handles the change from JsonObject to ExecutableDeployItem_StoredVersionedContractByName object
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_itsName => shift,
		_version => shift, # Optional value
		_entryPoint => shift, 
		_args => shift,
	};
	bless  $self, $class;
	return $self;
}

# get-set method for _itsHash

sub setItsName {
	my ( $self, $itsName) = @_;
	$self->{_itsName} = $itsName if defined($itsName);
	return $self->{_itsName};
}

sub getItsName {
	my ( $self ) = @_;
	return $self->{_itsName};
}

# get-set method for version

sub setVersion {
	my ($self,$version) = @_;
	$self->{_version} = $version if defined ($version);
	return $self->{_version};
}
sub getVersion {
	my ($self) = @_;
	return $self->{_version};
}

# get-set method for entryPoint

sub setEntryPoint {
	my ($self,$entryPoint) = @_;
	$self->{_entryPoint} = $entryPoint if defined ($entryPoint);
	return $self->{_entryPoint};
}
sub getEntryPoint {
	my ($self)  = @_;
	return $self->{_entryPoint};
}

# get-set method for args

sub setArgs {
	my ( $self, $args) = @_;
	$self->{_args} = $args if defined($args);
	return $self->{_args};
}

sub getArgs {
	my ( $self ) = @_;
	return $self->{_args};
}
# This function turn the JsonObject to a ExecutableDeployItem_StoredVersionedContractByHash object
sub fromJsonObjectToEDIStoredContractVersionedByName {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByName();
    $ret->setItsName($json->{'name'});
    $ret->setEntryPoint($json->{'entry_point'});
    my @argsJson = $json->{'args'};
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
    $ret->setArgs($args);
	return $ret;
}

1;