=comment
This class hold the quotient and remainder of a divide math equation
=cut

package Serialization::QuotientNRemainder;
#constructor
sub new {
	my $class = shift;
	my $self = {
		_remainder => shift, 
		_quotient => shift,
			};
	bless $self, $class;
	return $self;
}
#get-set method for _remainder
sub setRemainder {
	my ($self,$value) = @_;
	$self->{_remainder} = "".$value if defined ($value);
	return $self->{_remainder};
}
sub getRemainder {
	my ($self) = @_;
	return $self->{_remainder};
}

#get-set method for _quotient
sub setQuotient {
	my ($self,$value) = @_;
	$self->{_quotient} = "".$value if defined ($value);
	return $self->{_quotient};
}
sub getQuotient {
	my ($self) = @_;
	return $self->{_quotient};
}
1;