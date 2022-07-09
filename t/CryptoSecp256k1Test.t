#!/usr/bin/env perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use Test::Simple tests => 6;
use FindBin qw( $RealBin );
use lib "$RealBin/../lib";
use Crypt::Secp256k1Handle;
use Crypt::PK::ECC;
use Encode qw( encode );
sub testKeyGeneration {
	my $secp256k1 = new Crypt::Secp256k1Handle();
	$secp256k1->generateKey();
	$secp256k1->readPrivateKeyFromPemFile();
	$secp256k1->signMessage("HELLO WORLD!");
}
=comment
This function generate the private/public key pair in PEM string format
=cut
sub testGenerateKey {
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $private_pem = $pk->export_key_pem('private_short');
	my $public_pem = $pk->export_key_pem('public_short');
	my $privateLength = length($private_pem);
	my $publicLength = length($public_pem);
	# private key length and public key length assertion
	ok($privateLength == 223,"Test generate private key, Passed");
	ok($publicLength == 174,"Test generate private key, Passed");
}
sub testReadPrivateKey {
	my $secp256k1 = new Crypt::Secp256k1Handle();
	# Positive path, read private key from a correct path and correct private PEM file format
	my $privateKey = $secp256k1->readPrivateKeyFromPemFile("./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem");
	my $privateLength = length($privateKey);
	print "Private key length:".$privateLength."\n";
	ok($privateLength == 223,"Test read private key, Passed");
	# Negative path, read private key from an incorrect file path
	$secp256k1->readPrivateKeyFromPemFile("./Crypto/Secp256k1/wrongPrivateKeyPath.pem");
}
testGenerateKey();
testReadPrivateKey();

#testKeyGeneration();