# Class built for storing EraInfo information
# and handles the change from Json object to EraInfo object
package GetDeploy::ExecutionResult::Transform::EraInfo;
use GetDeploy::ExecutionResult::Transform::SeigniorageAllocation;

sub new {
	my $class = shift,
	my $self = {
		_seigniorageAllocations => [ @_ ] , # List of SeigniorageAllocation object
	};
	bless $self,$class;
	return $self;
}

# get-set method for _seigniorageAllocations
sub setSeigniorageAllocations {
	my ($self,@list) = @_;
	$self->{_seigniorageAllocations} = \@list;
	return $self->{_seigniorageAllocations};
}
sub getSeigniorageAllocations {
	my ($self)  = @_;
	my @ret = @ {$self->{_seigniorageAllocations}};
	wantarray ? @ret : \@ret;
}

# This function parse the JsonObject (taken from server RPC method call) to get the EraInfo object
sub fromJsonObjectToEraInfo {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetDeploy::ExecutionResult::Transform::EraInfo();
	my @listSAJson = @{$json->{'seigniorage_allocations'}};
	my $totalSA = @listSAJson;
	if($totalSA > 0) {
		my @retList = ();
		foreach(@listSAJson) {
			my $oneSA = GetDeploy::ExecutionResult::Transform::SeigniorageAllocation->fromJsonToSeigniorageAllocation($_);
			push(@retList,$oneSA);
		}
		$ret->setSeigniorageAllocations(@retList);
	}
	return $ret;
}
1;