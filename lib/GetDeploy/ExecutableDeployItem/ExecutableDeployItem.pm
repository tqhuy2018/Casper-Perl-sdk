package GetDeploy::ExecutableDeployItem::ExecutableDeployItem;

sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless $class, $self;
	return $self;
}
1;