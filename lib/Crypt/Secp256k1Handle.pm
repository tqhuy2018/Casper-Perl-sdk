=comment
Class for handling Secp256k1 Crypto tasks
The following tasks are being implemented:
Sign message
Verify message
Generate key pair
Read private/public key from Pem file
Write private/public key from Pem file
=cut
use Crypt::PK::ECC;
package Crypt::Secp256k1Handle;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
=comment
This function generate the private/public key pair in PEM string format
=cut
sub generateKey {
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $private_pem = $pk->export_key_pem('private_short');
	my $public_pem = $pk->export_key_pem('public_short');
	print "private key pem is:".$private_pem."\n";
	print "public key pem is:".$public_pem."\n";
}
sub readPrivateKeyFromPemFile {
	my $pk = Crypt::PK::ECC->new("./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem");
	print "private key is:".$pk;
	my $private_pem = $pk->export_key_pem('private_short');
	my $public_pem = $pk->export_key_pem('public_short');
	print "private key pem is:".$private_pem."\n";
}
sub readPublicKeyFromPemFile {
	
}
sub writePrivateKeyToPemFile {
	
}
sub writePublicKeyToPemFile {
	
}
sub signMessage {
	my @vars = @_;
	my $message = $vars[1];
	print "message to sign is:".$message."\n";
	my $privateKey = Crypt::PK::ECC->new("./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem");
	print "Private key type:".$privateKey."\n";
	my $signature = $privateKey->sign_message_rfc7518($message,"SHA256");
	$signature =~ s/(.)/sprintf '%02x', ord $1/seg;
	return $signature;
}
sub shortenSignature {
	my @vars = @_;
	my $signature = $vars[0];
	my $length = length($signature)/2;
	my @sequence = (0..$length-1);
	my $ret = "";
	for my $i (@sequence) {
		my $twoChar = substr $signature,$i * 2,2;
		if ($i % 2 == 1) {
			$ret = $ret.$twoChar;
		}
	}
	return $ret;
}
sub verifyMessage {
	
}
1;