=comment
This class hold the information retrieved from the  chain_get_block_transfers RPC call
=cut
package GetBlockTransfers::GetBlockTransfersResult;
use GetDeploy::ExecutionResult::Transform::CasperTransfer;
sub new {
	my $class = shift;
	my $self = {
		_apiVersion => shift,
		_blockHash => shift,
		_transfers => [ @_ ], # List of CasperTransfer
	};
	bless $self, $class;
	return $self;
}
sub fromJsonObjectToGetBlockTransfersResult {
	
	my $ret = new GetBlockTransfers::GetBlockTransfersResult();
	return $ret;
}
