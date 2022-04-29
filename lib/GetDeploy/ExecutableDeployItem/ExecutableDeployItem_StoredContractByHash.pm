=comment
Class built for storing ExecutableDeployItem enum of type StoredContractByHash
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash;

use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_itsHash => shift,
		_entryPoint => shift, 
		_args => shift,
	};
	bless  $self, $class;
	return $self;
}

#get-set method for moduleBytes

sub setItsHash {
	my ( $self, $itsHash) = @_;
	$self->{_itsHash} = $itsHash if defined($itsHash);
	return $self->{_itsHash};
}

sub getItsHash {
	my ( $self ) = @_;
	return $self->{_itsHash};
}

#get-set method for entryPoint

sub setEntryPoint {
	my ($self,$entryPoint) = @_;
	$self->{_entryPoint} = $entryPoint if defined ($entryPoint);
	return $self->{_entryPoint};
}
sub getEntryPoint {
	my ($self)  = @_;
	return $self->{_entryPoint};
}

#get-set method for args

sub setArgs {
	my ( $self, $args) = @_;
	$self->{_args} = $args if defined($args);
	return $self->{_args};
}

sub getArgs {
	my ( $self ) = @_;
	return $self->{_args};
}
#This function turn the JsonObject to a ExecutableDeployItem_StoredContractByHash object
sub fromJsonObjectToEDIStoredContractByHash {
	my @list = @_;
	print "\nstr json to get edimb is:".$list[1]."\n";
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByHash();
	my $hash = $json->{'hash'};
    $ret->setItsHash($hash);
    $ret->setEntryPoint($json->{'entry_point'});
    print "Hash is:".$hash." and entryPoint:".$json->{'entry_point'}."\n";
    my @argsJson = $json->{'args'};
    print "\nargs for payment:".@argsJson."\n";
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
	return $ret;
}

1;