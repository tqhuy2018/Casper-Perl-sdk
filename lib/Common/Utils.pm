=comment
This provides some helper methods in general
=cut

package Common::Utils;

sub new {
	my $class = shift;
	my $self = {
	};
	bless $self, $class;
	return $self;
}

sub fromDeployHashToAnscii {
	my @vars = @_;
	my $deployHash = $vars[1];
	my $length = length($deployHash)/2;
	my @sequence = (0..$length-1);
	my $ret = "";
	for my $i (@sequence)  {
		my $twoChar = substr $deployHash,$i*2,2;
		my $firstChar = substr $twoChar,0,1;
		my $secondChar = substr $twoChar,1,1;
		my $value = hex($firstChar) * 16 + hex($secondChar);
		my $char = chr($value);
		$ret = $ret.$char;
	}
	return $ret;
}
1;