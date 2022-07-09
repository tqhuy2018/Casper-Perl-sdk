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
use Crypt::Misc 'write_rawfile';
use Common::ConstValues;
package Crypt::Secp256k1Handle;


sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
=comment
This function generates the private/public key pair in PEM string format
=cut
sub generateKey {
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $private_pem = $pk->export_key_pem('private_short');
	my $public_pem = $pk->export_key_pem('public_short');
}
# This function reads private key from pem file and return the private key
sub readPrivateKeyFromPemFile {
	my @vars = @_;
	my $privateKeyPath = $vars[1];
	my $privatePem;
	eval {
		my $pk = Crypt::PK::ECC->new($privateKeyPath);
		$privatePem = $pk->export_key_pem('private_short');
	};
	if(my $e = $@) {
		return $Common::ConstValues::ERROR_TRY_CATCH;
	} else {
		return $privatePem;
	}
}
# This function reads public key from pem file and return the public key
sub readPublicKeyFromPemFile {
	my @vars = @_;
	my $privateKeyPath = $vars[1];
	my $publicPem;
	eval {
		my $pk = Crypt::PK::ECC->new($privateKeyPath);
		$publicPem = $pk->export_key_pem('public_short');
	};
	if(my $e = $@) {
		return $Common::ConstValues::ERROR_TRY_CATCH;
	} else {
		return $publicPem;
	}
}
# This function generates the private key and then write it to a file
# input: file name
# output: 
# if the file name/file path is correct: the private key in Pem format is written to the file name
# if the file name/file path is incorrect: error thrown
sub writePrivateKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $filePath = $vars[1];
	# generate the key
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $privatePem = $pk->export_key_pem('private_short');
	# write the key to file path
	Crypt::Misc::write_rawfile($filePath,$privatePem);
	#Crypt::Misc::write_rawfile("./Crypto/Secp256k1/Ed25519PublicKeyWrite.pem",$private_pem);
}
# This function generates the public key and then write it to a file
# input: file name
# output: 
# if the file name/file path is correct: the public key in Pem format is written to the file name
# if the file name/file path is incorrect: error thrown
sub writePublicKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $filePath = $vars[1];
	# generate the key
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $publicPem = $pk->export_key_pem('public_short');
	# write the key to file path
	Crypt::Misc::write_rawfile($filePath,$publicPem);
}
# This function generates the private/public key pair and then write them to separated PEM files
# input: private and public file name
# output: 
# if the file name/file path is correct: the private/public keys in Pem format are written to the files with given file paths
# if the file name/file path is incorrect: error thrown
sub writeKeyPairToPemFile {
	# get the file path
	my @vars = @_;
	my $privateFilePath = $vars[1];
	my $publicFilePath = $vars[2];
	# generate the key
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $privatePem = $pk->export_key_pem('private_short');
	# write private key to file path
	Crypt::Misc::write_rawfile($privateFilePath,$privatePem);
	my $publicPem = $pk->export_key_pem('public_short');
	# write public key to file path
	Crypt::Misc::write_rawfile($publicFilePath,$publicPem);
}
# This function signs the message base on the given private key and original message
# input: private key and original message
# output: signed message

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
# This function verifies the message base on the given public key, original message and signed message
# input: public key, original message, signed message
# output: if the signature is correct for the public key, return 1, else return 0
sub verifyMessage {
	my @vars = @_;
	my $publicKey = $vars[1];
	my $originalMessage = $vars[2];
	my $signature = $vars[3];
	my $ret = $publicKey->verify_message($signature,$originalMessage);
	return $ret;
}
1;