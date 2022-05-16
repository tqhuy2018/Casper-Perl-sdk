=comment
Class built for storing ExecutableDeployItem enum of type ModuleBytes 
and handles the change from JsonObject to ExecutableDeployItem_ModuleBytes object
=cut
package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_moduleBytes => shift,
		_args => shift, # RuntimeArgs object
	};
	bless  $self, $class;
	return $self;
}

#get-set method for moduleBytes
sub setModuleBytes {
	my ( $self, $moduleBytes) = @_;
	$self->{_moduleBytes} = $moduleBytes if defined($moduleBytes);
	return $self->{_moduleBytes};
}

sub getModuleBytes {
	my ( $self ) = @_;
	return $self->{_moduleBytes};
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

# This function parse the JsonObject (taken from server RPC method call) to ExecutableDeployItem_ModuleBytes object
sub fromJsonObjectToEDIModuleBytes {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes();
	my $mb = $json->{'module_bytes'};
    $ret->setModuleBytes($mb);
    my @argsJson = $json->{'args'};
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
    $ret->setArgs($args);
	return $ret;
}

1;