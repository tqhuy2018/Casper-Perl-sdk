# Class built for storing JsonEraEnd information
package GetBlock::JsonEraEnd;
use  GetBlock::JsonEraReport;
sub new {
	my $class = shift;
	my $self = {
		_eraReport => shift, # JsonEraReport object
		_nextEraValidatorWeights => [ @_ ], # list of ValidatorWeight object
	};
	bless $self, $class;
	return $self;
}

# get-set method for _eraReport
sub setEraReport {
	my ( $self, $value) = @_;
	$self->{_eraReport} = $value if defined($value);
	return $self->{_eraReport};
}

sub getEraReport {
	my ( $self ) = @_;
	return $self->{_eraReport};
}

# get-set method for nextEraValidatorWeights
sub setNextEraValidatorWeights {
	my ( $self, @value) = @_;
	$self->{_nextEraValidatorWeights} = \@value;
	return $self->{_nextEraValidatorWeights};
}

sub getNextEraValidatorWeights {
	my ( $self ) = @_;
	my @list = @{$self->{_nextEraValidatorWeights}};
	wantarray ? @list : \@list;
}

# This function parse the JsonObject (taken from server RPC method call) to JsonEraEnd object
sub fromJsonObjToJsonEraEnd {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlock::JsonEraEnd();
	if ($json->{'era_report'}) {
		my $eraReport = GetBlock::JsonEraReport->fromJsonToJsonEraReport($json->{'era_report'});
		$ret->setEraReport($eraReport);
	}
	my @listVWJson = @{$json->{'next_era_validator_weights'}};
	my $totalVW = @listVWJson;
	if($totalVW > 0 ) {
		my @listVW = ();
		foreach(@listVWJson) {
			my $oneVW = GetBlock::ValidatorWeight->fromJsonToValidatorWeight($_);
			push(@listVW,$oneVW);
		}
		$ret->setNextEraValidatorWeights(@listVW);
	}
	return $ret;
}
1;