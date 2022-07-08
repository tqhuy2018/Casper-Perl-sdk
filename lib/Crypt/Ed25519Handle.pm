=comment
Class for handling Ed25519 Crypto tasks
The following tasks are being implemented:
Sign message
Verify message
Generate key pair
Read private/public key from Pem file
Write private/public key from Pem file
=cut
use Crypt::PK::Ed25519;
package Crypt::Ed25519Handle;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
sub keyGeneration {
	my $pk = Crypt::PK::Ed25519->new->generate_key;
	my $private_pem = $pk->export_key_pem('private');
	my $public_pem  = $pk->export_key_pem('public');
	print "Private key Ed25519:".$private_pem."\n";
	print "Public key Ed25519:".$public_pem."\n";
}
sub signMessage {
	my @vars = @_;
	my $message = $vars[1];
	my $priv = Crypt::PK::Ed25519->new('./Crypto/Ed25519/Ed25519Perl_secret_key.pem');
	my $signature = $priv->sign_message($message);
	print "Ed25519 signature:".$signature."\n";
	$signature =~ s/(.)/sprintf '%02x', ord $1/seg;
	return $signature;
}
1;