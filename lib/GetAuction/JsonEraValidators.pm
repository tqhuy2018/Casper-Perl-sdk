# Class built for storing JsonEraValidators information
package GetAuction::JsonEraValidators;
use GetAuction::JsonValidatorWeights;
sub new {
	my $class = shift;
	my $self = {
		_eraId => shift, 
		_validatorWeights => [ @_ ], # list of JsonValidatorWeights object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _eraId
sub setEraId {
	my ( $self, $value) = @_;
	$self->{_eraId} = $value if defined($value);
	return $self->{_eraId};
}

sub getEraId {
	my ( $self ) = @_;
	return $self->{_eraId};
}

# get-set method for _validatorWeights
sub setValidatorWeights {
	my ( $self, @value) = @_;
	$self->{_validatorWeights} = \@value;
	return $self->{_validatorWeights};
}

sub getValidatorWeights {
	my ( $self ) = @_;
	my @list = @{$self->{_validatorWeights}};
	wantarray ? @list : \@list;
}
# This function parse the JsonObject (taken from server RPC method call) to JsonEraValidators object
sub fromJsonObjectToJsonEraValidators {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetAuction::JsonEraValidators();
	$ret->setEraId($json->{'era_id'});
	my @listVWJson = @{$json->{'validator_weights'}};
	my $totalVW = @listVWJson;
	if($totalVW > 0 ) {
		my @listVW = ();
		foreach(@listVWJson) {
			my $oneVW = GetAuction::JsonValidatorWeights->fromJsonObjectToJsonValidatorWeights($_);
			push(@listVW,$oneVW);
		}
		$ret->setValidatorWeights(@listVW);
	}
	return $ret;
}
1;