# Class built for storing GetEraInfoResult information, the result of chain_get_era_info_by_switch_block RPC call
package GetEraInfoBySwitchBlock::GetEraInfoResult;
use GetEraInfoBySwitchBlock::EraSummary;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_eraSummary => shift, # EraSummary object, Optional value
		_isEraExists => shift,
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

# get-set method for _isEraExists
sub setIsEraExists {
	my ( $self, $value) = @_;
	$self->{_isEraExists} = $value if defined($value);
	return $self->{_isEraExists};
}

sub getIsEraExists {
	my ( $self ) = @_;
	return $self->{_isEraExists};
}

# This function parse the JsonObject (taken from server RPC method call) to GetEraInfoResult object
sub fromJsonToGetEraInfoResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetEraInfoBySwitchBlock::GetEraInfoResult();
	$ret->setApiVersion($json->{'api_version'});
	if($json->{'era_summary'}) {
		$ret->setIsEraExists(1);
		my $eraSummary = GetEraInfoBySwitchBlock::EraSummary->fromJsonToEraSummary($json->{'era_summary'});
		$ret->setEraSummary($eraSummary);
	} else {
		$ret->setIsEraExists(0);
	}
	return $ret;
}
1;