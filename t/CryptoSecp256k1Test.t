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
sub generateKey {
	my $pk = Crypt::PK::ECC->new();
	$pk->generate_key('secp256k1');
	my $private_pem = $pk->export_key_pem('private_short');
	my $public_pem = $pk->export_key_pem('public_short');
	print "private key pem is:".$private_pem."\n";
	print "public key pem is:".$public_pem."\n";
	my $message = "HELLO WORLD!";
	my $privateKeyPath = "./Crypto/Secp256k1/Secp256k1_Perl_secret_key.pem";
	my $privateKey = Crypt::PK::ECC->new($privateKeyPath);
	my $signature = $privateKey->sign_message($message,"SHA256");
	my $signature7518 = $privateKey->sign_message_rfc7518($message,"SHA256");
	#print "Signature raw:".$signature."\n";
	#$signature = "hello world";
	$signature =~ s/(.)/sprintf '%04x', ord $1/seg;
	$signature7518 =~ s/(.)/sprintf '%04x', ord $1/seg;
	#print "signature hexa is:".hex($signature)."\n";
	print "signature in key generation is:".$signature."\n";
	print "signature2 is:".$signature7518."\n";
	
	#my $signature3 = ecc_sign_message($privateKeyPath,$message);
	#$signature3 =~ s/(.)/sprintf '%04x', ord $1/seg;
	#print "Signature 3 is:".$signature3."\n";
}
#generateKey();
testKeyGeneration();