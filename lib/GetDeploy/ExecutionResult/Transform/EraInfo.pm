# Class built for storing EraInfo information

package GetDeploy::ExecutionResult::Transform::EraInfo;

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

sub fromJsonArrayToEraInfo {
	
}