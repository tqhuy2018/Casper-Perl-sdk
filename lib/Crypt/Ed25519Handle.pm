=comment
Class for handling Ed25519 Crypto tasks
The following tasks are being implemented:
Sign message
Verify message
Generate key pair
Read private/public key from Pem file
Write private/public key from Pem file
=cut

package Crypt::Ed25519Handle;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
sub keyGeneration {
	
}
1;