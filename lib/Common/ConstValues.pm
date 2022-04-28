=comment
This class handles error information when call for  RPC method.
The error can be invalid param, 
=cut
use strict;
use warnings;
package Common::ConstValues;
sub new {
	my $class = shift;
	my $self = {
		
	};
	bless $self,$class;
	return $self;
}
my $BLOCK_HASH = "hash";
my $BLOCK_HEIGHT = "height";
