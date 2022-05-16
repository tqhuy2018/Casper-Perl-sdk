=comment
Class built for storing ExecutableDeployItem enum of type StoredContractVersionedByHash and 
# handles the change from JsonObject to ExecutableDeployItem_StoredVersionedContractByHash object
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash;

use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_itsHash => shift,
		_version => shift, # Optional value
		_entryPoint => shift, 
		_args => shift,
	};
	bless  $self, $class;
	return $self;
}

# get-set method for _itsHash

sub setItsHash {
	my ( $self, $itsHash) = @_;
	$self->{_itsHash} = $itsHash if defined($itsHash);
	return $self->{_itsHash};
}

sub getItsHash {
	my ( $self ) = @_;
	return $self->{_itsHash};
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
sub fromJsonObjectToEDIStoredContractVersionedByHash {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredVersionedContractByHash();
	my $hash = $json->{'hash'};
    $ret->setItsHash($hash);
    $ret->setEntryPoint($json->{'entry_point'});
    my @argsJson = $json->{'args'};
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
    $ret->setArgs($args);
	return $ret;
}

1;