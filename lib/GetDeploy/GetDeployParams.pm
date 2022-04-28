=comment
This class generate the parameter for sending for POST method of info_get_deploy RPC call
The generated parameter is somehow like this:
{"id" :  1, "method" :  "info_get_deploy", "params" :  {"deploy_hash" :  "6e74f836d7b10dd5db7430497e106ddf56e30afee993dd29b85a91c1cd903583"}, "jsonrpc" :  "2.0"}
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
	print "\ngenerate deploy parameter with deploy hash:".$self->{_deployHash}."\n";
	return '{"id" :  1, "method" :  "info_get_deploy", "params" :  {"deploy_hash" :  "'.$self->{_deployHash}.'"}, "jsonrpc" :  "2.0"}';
}
1;