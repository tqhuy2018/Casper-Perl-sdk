=comment
Class built for storing ExecutableDeployItem enum of type ModuleBytes
=cut
package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_ModuleBytes;

sub new {
	my $class = shift;
	my $self = {
		_moduleBytes => shift,
		_args => shift,
	};
	bless $class, $self;
	return $self;
}

#get-set methods for moduleBytes

sub setModuleBytes {
	my ( $self, $moduleBytes) = @_;
	$self->{_moduleBytes} = $moduleBytes if defined($moduleBytes);
	return $self->{_moduleBytes};
}

sub getModuleBytes {
	my ( $self ) = @_;
	return $self->{_moduleBytes};
}

#get-set methods for args

sub setArgs {
	my ( $self, $args) = @_;
	$self->{_args} = $args if defined($args);
	return $self->{_args};
}

sub getArgs {
	my ( $self ) = @_;
	return $self->{_args};
}


1;