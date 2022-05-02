=comment
Class built for storing ExecutableDeployItem enum of type StoredContractByName
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName;

use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_itsName => shift,
		_entryPoint => shift, 
		_args => shift,
	};
	bless  $self, $class;
	return $self;
}

#get-set method for _itsName

sub setItsName {
	my ( $self, $itsName) = @_;
	$self->{_itsName} = $itsName if defined($itsName);
	return $self->{_itsName};
}

sub getItsName {
	my ( $self ) = @_;
	return $self->{_itsName};
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
#This function turn the JsonObject to a ExecutableDeployItem_StoredContractByName object
sub fromJsonObjectToEDIStoredContractByName {
	my @list = @_;
	print "\nstr json to get edimb is:".$list[1]."\n";
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_StoredContractByName();
	my $name = $json->{'name'};
    $ret->setItsName($name);
    $ret->setEntryPoint($json->{'entry_point'});
    print "Hash is:".$hash." and entryPoint:".$json->{'entry_point'}."\n";
    my @argsJson = $json->{'args'};
    print "\nargs for payment:".@argsJson."\n";
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
    $ret->setArgs($args);
	return $ret;
}

1;