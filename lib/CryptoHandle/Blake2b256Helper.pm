=comment
This provides blake2b256 hash to get the deploy body hash and deploy hash, used for account_put_deploy RPC method call
=cut

package CryptoHandle::Blake2b256Helper;
use Crypt::Digest::BLAKE2b_256 qw( blake2b_256 blake2b_256_hex blake2b_256_b64 blake2b_256_b64u
                             blake2b_256_file blake2b_256_file_hex blake2b_256_file_b64 blake2b_256_file_b64u );

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}
# This function get the blake2b256 from the given input string
sub getBlake2b256 {
	my @vars = @_;
	my $inputStr = $vars[1];
	my $length = length($inputStr)/2;
 	my @sequence = (0..$length-1);
 	my @list = ();
 	for my $i (@sequence) {
 		my $twoChar = substr $inputStr, $i * 2,2;
 		my $firstChar = substr $twoChar,0,1;
 		my $secondChar = substr $twoChar,1,1;
 		my $valueHex = hex($firstChar) * 16 + hex($secondChar);
 		push(@list,$valueHex);
 	}
 	my $total = @list;
	my @sequence2 = (0..$total-1);
	my $str = "";
	for my $i (@sequence2) {
		my $oneChar = chr($list[$i]);
		$str = $str.$oneChar;
	}
	return blake2b_256_hex($str);
}
1;