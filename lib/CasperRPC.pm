package CasperRPC;
# declare method for each RPC call
# for example with chain_get_state_root_hash there will be function like this
# sub getStateRootHash
# this function will take the BlockIdentifier parameter as the input
# output: state root hash string or error is thrown