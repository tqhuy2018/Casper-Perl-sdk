package GetEraInfoBySwitchBlock::GetEraInfoResult;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_eraSummary => shift, # EraSummary object, Optional value
	};
	bless $self, $class;
	return $self;
}
# get-set method for _apiVersion
sub setApiVersion {
	my ( $self, $value) = @_;
	$self->{_apiVersion} = $value if defined($value);
	return $self->{_apiVersion};
}

sub getApiVersion {
	my ( $self ) = @_;
	return $self->{_apiVersion};
}
# get-set method for _eraSummary
sub setEraSummary {
	my ( $self, $value) = @_;
	$self->{_eraSummary} = $value if defined($value);
	return $self->{_eraSummary};
}

sub getEraSummary {
	my ( $self ) = @_;
	return $self->{_eraSummary};
}
# This function parse the JsonObject (taken from server RPC method call) to GetEraInfoResult object
sub fromJsonToGetEraInfoResult {
	
}