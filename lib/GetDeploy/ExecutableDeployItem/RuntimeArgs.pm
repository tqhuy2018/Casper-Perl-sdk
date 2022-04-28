package GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_listNamedArg => [ @_ ],
	};
	bless $class, $self;
	return $self;
}
1;