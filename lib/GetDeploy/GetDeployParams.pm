=comment
This class generate the parameter for sending for POST method of info_get_deploy RPC call
The generated parameter is somehow like this:
{"id" :  1, "method" :  "info_get_deploy", "params" :  {"deploy_hash" :  "6e74f836d7b10dd5db7430497e106ddf56e30afee993dd29b85a91c1cd903583"}, "jsonrpc" :  "2.0"}
The only part in the Json string is different is the "deploy_hash" value, based on the _deployHash value of the GetDeployParams object.
To generate the parameter, simple instantiate one GetDeployParams object
my $gdp = new GetDeploy::GetDeployParams();
Then assign the _deployHash variable value
$gdp->setDeployHash("one valid deploy hash value here");
Then you can get the parameter for the info_get_deploy RPC method call by calling this function
my $parameterStr = $gdp->generateParameterStr();
=cut
package GetDeploy::GetDeployParams;

sub new {
	my $class = shift;
	my $self = {
		_deployHash => shift,
	};
	bless $self, $class;
	return $self;
}

sub setDeployHash {
	my ( $self, $deployHash) = @_;
	$self->{_deployHash} = $deployHash if defined($deployHash);
	return $self->{_deployHash};
}

sub getDeployHash {
	my ( $self ) = @_;
	return $self->{_deployHash};
}
=comment
This function generate the parameter string for info_get_deploy RPC call
=cut
sub generateParameterStr {
	my ( $self ) = @_;
	return '{"id" :  1, "method" :  "info_get_deploy", "params" :  {"deploy_hash" :  "'.$self->{_deployHash}.'"}, "jsonrpc" :  "2.0"}';
}
1;