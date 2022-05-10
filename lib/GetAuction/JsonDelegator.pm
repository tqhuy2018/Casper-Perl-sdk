# Class built for storing JsonDelegator information
package GetAuction::JsonDelegator;
sub new {
	my $class = shift;
	my $self = {
		_bondingPurse => shift,
		_delegatee => shift,
		_publicKey => shift,
		_stakedAmount => shift,
	};
	bless $self, $class;
	return $self;
}