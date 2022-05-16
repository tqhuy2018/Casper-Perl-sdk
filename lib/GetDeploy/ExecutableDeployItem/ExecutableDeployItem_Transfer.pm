=comment
Class built for storing ExecutableDeployItem enum of type Transfer
and handles the change from JsonObject to ExecutableDeployItem_Transfer object
=cut

package GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer;
use GetDeploy::ExecutableDeployItem::RuntimeArgs;

sub new {
	my $class = shift;
	my $self = {
		_args => shift,
	};
	bless  $self, $class;
	return $self;
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

# This function turn the JsonObject to a ExecutableDeployItem_Transfer object
sub fromJsonObjectToEDITransfer {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutableDeployItem::ExecutableDeployItem_Transfer();
    my @argsJson = $json->{'args'};
    my $args = GetDeploy::ExecutableDeployItem::RuntimeArgs->fromJsonListToRuntimeArgs(@argsJson);
    $ret->setArgs($args);
	return $ret;
}
1;