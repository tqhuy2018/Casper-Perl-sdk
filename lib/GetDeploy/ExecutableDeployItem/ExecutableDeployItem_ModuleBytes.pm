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
1;