#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 6;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use CryptoHandle::Secp256k1Handle;
use Crypt::PK::ECC;
use Common::ConstValues;
use CryptoHandle::KeyPair;
use Encode qw( encode );

# This function tests the generation of the private/public key pair in PEM string format
sub testGenerateKey {
	my $keyPair = new CryptoHandle::KeyPair();
	my $secp256k1 = new CryptoHandle::Secp256k1Handle();
	$keyPair = $secp256k1->generateKey();
	my $private_pem = $keyPair->getPrivateKey();
	my $public_pem = $keyPair->getPublicKey();
	my $privateLength = length($private_pem);
	my $publicLength = length($public_pem);
	# private key length and public key length assertion
	ok($privateLength == 223,"Test generate private key, Passed");
	ok($publicLength == 174,"Test generate private key, Passed");
}

# This function tests the generation of private/public key pair and writes them to pem files.
sub testWriteKeyPair {
	my $secp256k1 = new CryptoHandle::Secp256k1Handle();
	# Positive path, write private and public key to  correct file path
	my $privateKeyFilePath = "./Crypto/Secp256k1/Secp256k1WritePrivateKey.pem";
	my $publicKeyFilePath = "./Crypto/Secp256k1/Secp256k1WritePrivateKey.pem";
	my $result = $secp256k1->generateAndWriteKeyPairToPemFile($privateKeyFilePath,$publicKeyFilePath);
	ok($result == 1,"Test write private/public key pair to correct file path, Passed");
	# Negateive test
	my $wrongPrivateFilePath = "./aaWrongPath/aaWrongPrivateName.pem";
	my $wrongPublicFilePath = "./aaWrongPath/aaWrongPrivateName.pem";
	my $result = $secp256k1->generateAndWriteKeyPairToPemFile($wrongPrivateFilePath,$wrongPublicFilePath);
	ok($result == 0,"Test write private/public key pair to incorrect file path, Passed");
}

# This function tests the read private key from Pem file
sub testReadPrivateKey {
	my $secp256k1 = new CryptoHandle::Secp256k1Handle();
	# Positive path, read private key from a correct path and correct private PEM file format
	my $privateKey = $secp256k1->readPrivateKeyFromPemFile("./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem");
	my $privateLength = length($privateKey);
	ok($privateLength == 223,"Test read private key, Passed");
	# Negative path 1, read private key from an incorrect file path
	my $error = $secp256k1->readPrivateKeyFromPemFile("./Crypto/Secp256k1/wrongPrivateKeyPath.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read private key from wrong path, error thrown, Passed");
	# Negative path 2, read private key from a correct file path but incorrect file format
	my $error2 = $secp256k1->readPrivateKeyFromPemFile("./Crypto/Secp256k1/Ed25519PublicKeyWrite.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read private key from correct path but incorrect Pem file format, error thrown, Passed");
}

# This function tests the read public key from Pem file
sub testReadPublicKey {
	my $secp256k1 = new CryptoHandle::Secp256k1Handle();
	# Positive path, read public key from a correct path and correct private PEM file format
	my $publicKey = $secp256k1->readPublicKeyFromPemFile("./Crypto/Secp256k1/Ed25519PublicKeyWrite.pem");
	my $publicLength = length($publicKey);
	ok($publicLength == 174,"Test read public key, Passed");
	# Negative path 1, read public key from an incorrect file path
	my $error = $secp256k1->readPublicKeyFromPemFile("./Crypto/Secp256k1/wrongPublicKeyPath.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read public key from wrong path, error thrown, Passed");
	# Negative path 2, read public key from a correct file path but incorrect file format
	my $error2 = $secp256k1->readPublicKeyFromPemFile("./Crypto/Secp256k1/Ed25519PublicKeyWrite.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read public key from correct path but incorrect Pem file format, error thrown, Passed");
}
# This function tests the message signing and  verification of the signed message
sub testSignAndVerify {
	my $secp256k1 = new CryptoHandle::Secp256k1Handle();
	my $message1 = "7e86be76bc2031558f810b79602380ad2badfb7d65aef810e30891a8c0d3b3ee";
	my $message2 = "Hello, World!";
	my $keyPair = new CryptoHandle::KeyPair();
	$keyPair = $secp256k1->generateKey();
	my $privateKeyPem = $keyPair->getPrivateKey();
	my $pk = Crypt::PK::ECC->new();
	my $privateKey =  $pk->import_key(\$privateKeyPem);
	my $publicKey = $keyPair->getPublicKey();
	my $signature = $secp256k1->signMessage($message1,$privateKey);
	ok(length($signature) == 128," Test sign message, Passed");
	
	
}
testGenerateKey();
testWriteKeyPair();
testReadPrivateKey();
testReadPublicKey();
testSignAndVerify();

#testKeyGeneration();