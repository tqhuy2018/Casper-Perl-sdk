=comment
This provides blake2b256 hash to get the deploy body hash and deploy hash, used for account_put_deploy RPC method call
=cut

package Common::Utils;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}

sub getDeployHash {
	
}