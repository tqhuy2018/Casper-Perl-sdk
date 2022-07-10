#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 15;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use CryptoHandle::Ed25519Handle;
use CryptoHandle::KeyPair;

# This function tests the generation of the private/public key pair in PEM string format
sub testGenerateKey {
	my $keyPair = new CryptoHandle::KeyPair();
	my $ed25519 = new CryptoHandle::Ed25519Handle();
	$keyPair = $ed25519->generateKey();
	my $private_pem = $keyPair->getPrivateKey();
	my $public_pem = $keyPair->getPublicKey();
	my $privateLength = length($private_pem);
	my $publicLength = length($public_pem);
	# private key length and public key length assertion
	ok($privateLength == 135,"Test generate private key, Passed");
	ok($publicLength == 113,"Test generate private key, Passed");
}

# This function tests the generation of private/public key pair and writes them to pem files.
sub testWriteKeyPair {
	my $ed25519 = new CryptoHandle::Ed25519Handle();
	# Positive path, write private and public key to  correct file path
	my $privateKeyFilePath = "./Crypto/Ed25519/Perl_Ed25519WritePrivateKey.pem";
	my $publicKeyFilePath = "./Crypto/Ed25519/Perl_Ed25519WritePublicKey.pem";
	my $result = $ed25519->generateAndWriteKeyPairToPemFile($privateKeyFilePath,$publicKeyFilePath);
	ok($result == 1,"Test write private/public key pair to correct file path, Passed");
	# Negateive test
	my $wrongPrivateFilePath = "./aaWrongPath/aaWrongPrivateName.pem";
	my $wrongPublicFilePath = "./aaWrongPath/aaWrongPrivateName.pem";
	$result = $ed25519->generateAndWriteKeyPairToPemFile($wrongPrivateFilePath,$wrongPublicFilePath);
	ok($result == 0,"Test write private/public key pair to incorrect file path, Passed");
}
# This function tests the read private key from Pem file
sub testReadPrivateKey {
	my $ed25519 = new CryptoHandle::Ed25519Handle();
	# Positive path, read private key from a correct path and correct private PEM file format
	my $privateKey = $ed25519->readPrivateKeyFromPemFile("./Crypto/Ed25519/Perl_Ed25519ReadPrivateKey.pem");
	# The private key in raw format is somehow like this Crypt::PK::Ed25519=SCALAR(0x13e272850)
	my $privateLength = length($privateKey);
	ok($privateLength > 0,"Test read private key, Passed");
	# Negative path 1, read private key from an incorrect file path
	my $error = $ed25519->readPrivateKeyFromPemFile("./Crypto/Ed25519/wrongPrivateKeyPath.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read private key from wrong path, error thrown, Passed");
	# Negative path 2, read private key from a correct file path but incorrect file format
	my $error2 = $ed25519->readPrivateKeyFromPemFile("./Crypto/Ed25519/Perl_Ed25519WritePublicKey.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read private key from correct path but incorrect Pem file format, error thrown, Passed");
}

# This function tests the read public key from Pem file
sub testReadPublicKey {
	my $ed25519 = new CryptoHandle::Ed25519Handle();
	# Positive path, read public key from a correct path and correct private PEM file format
	my $publicKey = $ed25519->readPublicKeyFromPemFile("./Crypto/Ed25519/Perl_Ed25519WritePublicKey.pem");
	my $publicLength = length($publicKey);
	# The public key in raw format is somehow like this Crypt::PK::Ed25519=SCALAR(0x12308ebd0)
	ok($publicLength > 0,"Test read public key, Passed");
	# Negative path 1, read public key from an incorrect file path
	my $error = $ed25519->readPublicKeyFromPemFile("./Crypto/Ed25519/wrongPublicKeyPath.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read public key from wrong path, error thrown, Passed");
	# Negative path 2, read public key from a correct file path but incorrect file format
	my $error2 = $ed25519->readPublicKeyFromPemFile("./Crypto/Ed25519/Perl_Ed25519WritePrivateKey.pem");
	ok($error eq $Common::ConstValues::ERROR_TRY_CATCH,"Negative test - read public key from correct path but incorrect Pem file format, error thrown, Passed");
}
# This function tests the message signing and  verification of the signed message
sub testSignAndVerify {
	# positive path
	my $ed25519 = new CryptoHandle::Ed25519Handle();
	my $message1 = "7e86be76bc2031558f810b79602380ad2badfb7d65aef810e30891a8c0d3b3ee";
	my $message2 = "Hello, World!";
	my $keyPair = new CryptoHandle::KeyPair();
	$keyPair = $ed25519->generateKey();
	my $privateKeyPem = $keyPair->getPrivateKey();
	#my $pk = Crypt::PK::ECC->new();
	my $privateKey =  Crypt::PK::Ed25519->new(\$privateKeyPem);
	my $signature = $ed25519->signMessage($message1,$privateKey);
	my $signature2 = $ed25519->signMessage($message2,$privateKey);
	ok(length($signature) == 128," Test sign message, Passed");
	my $publicKeyPem = $keyPair->getPublicKey();
	my $publicKey = Crypt::PK::Ed25519->new(\$publicKeyPem);
	my $ret = $ed25519->verifyMessage($publicKey,$message1,$signature);
	ok($ret == 1," Test verify message, Passed");
	
	# negative path 
	# Negative path 1 - verify with a different public key - private key pair
	# This test use a different public key - a newly generated public key
	my $keyPair2 = new CryptoHandle::KeyPair();
	$keyPair2 = $ed25519->generateKey();
	my $publicKeyPem2 = $keyPair2->getPublicKey();
	my $publicKey2 = Crypt::PK::Ed25519->new(\$publicKeyPem2);
	my $ret2 = $ed25519->verifyMessage($publicKey2,$message1,$signature);
	ok($ret2 == 0," Test verify message, Passed");
	# Negative path 2 - verify with a correct public key - private key pair but wrong message
	# This should be message1 but message2 is put into usage
	my $ret3 = $ed25519->verifyMessage($publicKey,$message2,$signature);
	ok($ret3 == 0," Test verify message, Passed");
	# Negative path 3 - verify with a correct public key - private key pair but wrong signature
    my $ret4 = $ed25519->verifyMessage($publicKey,$message1,$signature2);
	ok($ret4 == 0," Test verify message, Passed");
}
testGenerateKey();
testWriteKeyPair();
testReadPrivateKey();
testReadPublicKey();
testSignAndVerify();
