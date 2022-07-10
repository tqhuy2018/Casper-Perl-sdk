=comment
Class for handling Ed25519 Crypto tasks
The following tasks are being implemented:
Sign message
Verify message
Generate key pair
Read private/public key from Pem file
Write private/public key from Pem file
=cut
use Common::ConstValues;
use CryptoHandle::KeyPair;
use Crypt::PK::Ed25519;
package CryptoHandle::Ed25519Handle;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
=comment
This function generates the private/public key pair in PEM string format, then return the key pair, wrapped in
Crypt::KeyPair class
=cut
sub generateKey {
	my $pk = Crypt::PK::Ed25519->new->generate_key;
	my $private_pem = $pk->export_key_pem('private');
	my $public_pem  = $pk->export_key_pem('public');
	my $keyPair = new CryptoHandle::KeyPair();
	$keyPair->setPrivateKey($private_pem);
	$keyPair->setPublicKey($public_pem);
	return $keyPair;
}
# This function reads private key from pem file and return the private key
# input: pem file path
# output: if the file path is correct and the Pem file is in correct format then the private key is returned
# otherwise error message is returned
sub readPrivateKeyFromPemFile {
	my @vars = @_;
	my $privateKeyPath = $vars[1];
	my $privatePem;
	eval {
		my $pk = Crypt::PK::Ed25519->new;
		$privatePem = $pk->import_key($privateKeyPath);
	};
	if(my $e = $@) {
		return $Common::ConstValues::ERROR_TRY_CATCH;
	} else {
		return $privatePem;
	}
}
# This function reads public key from pem file and return the public key
# input: pem file path
# output: if the file path is correct and the Pem file is in correct format then the public key is returned
# otherwise error message is returned
sub readPublicKeyFromPemFile {
	my @vars = @_;
	my $publicKeyPath = $vars[1];
	my $publicPem;
	eval {
		my $pk = Crypt::PK::Ed25519->new();
		$publicPem = $pk->import_key($publicKeyPath);
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
# and return the private key in Pem format
# if the file name/file path is incorrect: error thrown, return the error message
sub generateAndWritePrivateKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $filePath = $vars[1];
	# generate the key
	my $pk = Crypt::PK::Ed25519->new->generate_key;
	my $privatePem = $pk->export_key_pem('private');
	# write the key to file path
	eval {
		Crypt::Misc::write_rawfile($filePath,$privatePem);
	};
	if(my $e = $@) {
		return $Common::ConstValues::ERROR_TRY_CATCH;
	} else {
		return $privatePem;
	}
}
# This function get private key and file path as input and then write private key to file path
# input: file name
# output: 
# if the file name/file path is correct: the public key in Pem format is written to the file name
# and return 1
# if the file name/file path is incorrect: return 0
sub writeGivenPrivateKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $privateKey = $vars[1];
	my $filePath = $vars[2];
	# write the key to file path
	eval {
		Crypt::Misc::write_rawfile($filePath,$privateKey);
	};
	if(my $e = $@) {
		return 1;
	} else {
		return 0;
	}
}
# This function get public key and file path as input and then write public key to file path
# input: file name
# output: 
# if the file name/file path is correct: the public key in Pem format is written to the file name
# and return 1
# if the file name/file path is incorrect: return 0
sub writeGivenPublicKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $publicKey = $vars[1];
	my $filePath = $vars[2];
	# write the key to file path
	eval {
		Crypt::Misc::write_rawfile($filePath,$publicKey);
	};
	if(my $e = $@) {
		return 1;
	} else {
		return 0;
	}
}

# This function generates the public key and then write it to a file
# input: file name
# output: 
# if the file name/file path is correct: the public key in Pem format is written to the file name
# and return the public key in Pem format
# if the file name/file path is incorrect: error thrown
sub generateAndWritePublicKeyToPemFile {
	# get the file path
	my @vars = @_;
	my $filePath = $vars[1];
	# generate the key
	my $pk = Crypt::PK::Ed25519->new->generate_key;
	my $publicPem = $pk->export_key_pem('public');
	# write the key to file path
	eval {
		Crypt::Misc::write_rawfile($filePath,$publicPem);
	};
	if(my $e = $@) {
		return $Common::ConstValues::ERROR_TRY_CATCH;
	} else {
		return $publicPem;
	}
}
# This function generates the private/public key pair and then write them to separated PEM files
# input: private and public file name
# output: 
# if the file name/file path is correct: the private/public keys in Pem format are written to the files with given file paths
# and return 1
# if the file name/file path is incorrect: return 0
sub generateAndWriteKeyPairToPemFile {
	# get the file path
	my @vars = @_;
	my $privateFilePath = $vars[1];
	my $publicFilePath = $vars[2];
	# generate the key
	my $pk = Crypt::PK::Ed25519->new->generate_key;
	my $success = 1;
	eval {
		my $privatePem = $pk->export_key_pem('private');
		# write private key to file path
		Crypt::Misc::write_rawfile($privateFilePath,$privatePem);
	};
	if(my $e = $@) {
		$success = 0;
	}
	eval {
		my $publicPem = $pk->export_key_pem('public');
		# write public key to file path
		Crypt::Misc::write_rawfile($publicFilePath,$publicPem);
	};
	if(my $e = $@) {
		$success = 0;
	}
	return $success;
}
# This function signs the message base on the given private key and original message
# input: original message and private key
# output: signed message
sub signMessage {
	my @vars = @_;
	my $message = $vars[1];
	my $privateKey = $vars[2];
	#my $priv = Crypt::PK::Ed25519->new('./Crypto/Ed25519/Ed25519Perl_secret_key.pem');
	my $signature = $privateKey->sign_message($message);
	#print "Ed25519 signature:".$signature."\n";
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
	$signature =~ s/(..)/chr(hex($1))/eg;
	my $ret = $publicKey->verify_message($signature,$originalMessage);
	return $ret;
}
1;