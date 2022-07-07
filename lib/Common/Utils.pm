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