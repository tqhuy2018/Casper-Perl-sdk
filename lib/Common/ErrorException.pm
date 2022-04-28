=comment
This class handles error information when call for  RPC method.
The error can be invalid param, 
=cut

package Common::ErrorException;

sub new {
	my $class = shift;
	my $self = {
		_errorCode => shift,
		_errorMessage => shift,
	};
	bless $self, $class;
	return $self;
}
sub setErrorCode {
	my ( $self, $errorCode) = @_;
	$self->{_errorCode} = $errorCode if defined($errorCode);
	return $self->{_errorCode};
}

sub getErrorCode {
	my ( $self ) = @_;
	return $self->{_errorCode};
}
sub setErrorMessage {
	my ( $self, $errorMessage) = @_;
	$self->{_errorMessage} = $errorMessage if defined($errorMessage);
	return $self->{_errorMessage};
}

sub getErrorMessage {
	my ( $self ) = @_;
	return $self->{_errorMessage};
}
1;