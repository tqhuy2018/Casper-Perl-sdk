=comment
Class built for storing ExecutableDeployItem enum of type ModuleBytes
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
#This does seem to be in need
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