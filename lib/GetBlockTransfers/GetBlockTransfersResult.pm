=comment
This class hold the information retrieved from the chain_get_block_transfers RPC call
=cut
package GetBlockTransfers::GetBlockTransfersResult;
use GetDeploy::ExecutionResult::Transform::CasperTransfer;

sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_blockHash => shift,
		_transfers => [ @_ ], # List of CasperTransfer object
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

# get-set method for _blockHash
sub setBlockHash {
	my ( $self, $value) = @_;
	$self->{_blockHash} = $value if defined($value);
	return $self->{_blockHash};
}

sub getBlockHash {
	my ( $self ) = @_;
	return $self->{_blockHash};
}

# get-set method for _transfers
sub setTransfers {
	my ( $self, @value) = @_;
	$self->{_transfers} = \@value;
	return $self->{_transfers};
}

sub getTransfers {
	my ( $self ) = @_;
	my @list = @{$self->{_transfers}};
	wantarray ? @list : \@list;
}

# This function parse the JsonObject (taken from server RPC method call) to GetBlockTransfersResult object
sub fromJsonObjectToGetBlockTransfersResult {
	my @list = @_;
	my $json = $list[1];
	my $ret = new GetBlockTransfers::GetBlockTransfersResult();
	$ret->setApiVersion($json->{'api_version'});
	$ret->setBlockHash($json->{'block_hash'});
	my @listTransferJson = @{$json->{'transfers'}};
	my $totalTransfer = @listTransferJson;
	if($totalTransfer > 0) {
		my @transfers = ();
		foreach(@listTransferJson) {
			my $oneTransfer = GetDeploy::ExecutionResult::Transform::CasperTransfer->fromJsonToTransfer($_);
			push(@transfers,$oneTransfer);
		}
		$ret->setTransfers(@transfers);
	}
	return $ret;
}
1;