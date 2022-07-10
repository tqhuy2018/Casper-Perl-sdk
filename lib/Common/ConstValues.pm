=comment
This class hold information of const values defined in the SDK, which are:
- RPC calling method name
- RPC posting method URL
- Null value
- CLType (23 possible values)
- Transform (18 possible values)
- StoredValue (10 possible values)
=cut
use strict;
use warnings;
package Common::ConstValues;
sub new { bless {}, shift };

# method name
our $RPC_GET_STATE_ROOT_HASH 	= "chain_get_state_root_hash";
our $RPC_GET_PEERS 				= "info_get_peers";
our $RPC_GET_DEPLOY 			= "info_get_deploy";
our $RPC_GET_STATUS 			= "info_get_status";
our $RPC_GET_BLOCK_TRANSFERS 	= "chain_get_block_transfers";
our $RPC_GET_BLOCK	 			= "chain_get_block";
our $RPC_GET_ERA	 			= "chain_get_era_info_by_switch_block";
our $RPC_GET_ITEM	 			= "state_get_item";
our $RPC_GET_DICTIONARY_ITEM 	= "state_get_dictionary_item";
our $RPC_GET_BALANCE 			= "state_get_balance";
our $RPC_GET_AUCTION 			= "state_get_auction_info";
our $RPC_PUT_DEPLOY 			= "account_put_deploy";

# method URL
our $TEST_NET = "https://node-clarity-testnet.make.services/rpc";
our $MAIN_NET = "https://node-clarity-mainnet.make.services/rpc";

# NULL, INVALID, PURE_NULL value
our $NULL_VALUE = "NULL_VALUE";
our $INVALID_VALUE = "INVALID_VALUE";
our $PURE_NULL = "NULL";

# For CLParse to Json, used for account_put_deploy RPC call

our $PARSED_FIXED_STRING = "!!!!!___PARSED___!!!!!";

# CLType
our $CLTYPE_BOOL 		= "Bool";
our $CLTYPE_U8 			= "U8";
our $CLTYPE_U32 		= "U32";
our $CLTYPE_U64 		= "U64";
our $CLTYPE_U128 		= "U128";
our $CLTYPE_U256 		= "U256";
our $CLTYPE_U512 		= "U512";
our $CLTYPE_I32 		= "I32";
our $CLTYPE_I64 		= "I64";
our $CLTYPE_UNIT 		= "Unit";
our $CLTYPE_STRING 		= "String";
our $CLTYPE_KEY 		= "Key";
our $CLTYPE_UREF 		= "URef";
our $CLTYPE_PUBLIC_KEY 	= "PublicKey";
our $CLTYPE_OPTION	 	= "Option";
our $CLTYPE_LIST	 	= "List";
our $CLTYPE_BYTEARRAY 	= "ByteArray";
our $CLTYPE_RESULT	 	= "Result";
our $CLTYPE_MAP		 	= "Map";
our $CLTYPE_TUPLE1		= "Tuple1";
our $CLTYPE_TUPLE2		= "Tuple2";
our $CLTYPE_TUPLE3		= "Tuple3";
our $CLTYPE_ANY		 	= "Any";

our $CLTYPE_RESULT_OK	 	= "Result_Ok";
our $CLTYPE_RESULT_ERR	 	= "Result_Err";

our $CLPARSED_RESULT_OK	 	= "Ok";
our $CLPARSED_RESULT_ERR	= "Err";

# Transform
our $TRANSFORM_IDENTITY 				=  "Identity";
our $TRANSFORM_WRITE_CLVALUE 			=  "WriteCLValue";
our $TRANSFORM_WRITE_ACCOUNT 			=  "WriteAccount";
our $TRANSFORM_WRITE_CONTRACT_WASM 		=  "WriteContractWasm";
our $TRANSFORM_WRITE_CONTRACT	 		=  "WriteContract";
our $TRANSFORM_WRITE_CONTRACT_PACKAGE 	=  "WriteContractPackage";
our $TRANSFORM_WRITE_DEPLOY_INFO		=  "WriteDeployInfo";
our $TRANSFORM_WRITE_ERA_INFO			=  "WriteEraInfo";
our $TRANSFORM_WRITE_TRANSFER			=  "WriteTransfer";
our $TRANSFORM_WRITE_BID				=  "WriteBid";
our $TRANSFORM_WRITE_WITHDRAW			=  "WriteWithdraw";
our $TRANSFORM_ADD_INT32				=  "AddInt32";
our $TRANSFORM_ADD_UINT64				=  "AddUInt64";
our $TRANSFORM_ADD_UINT128				=  "AddUInt128";
our $TRANSFORM_ADD_UINT256				=  "AddUInt256";
our $TRANSFORM_ADD_UINT512				=  "AddUInt512";
our $TRANSFORM_ADDKEYS					=  "AddKeys";
our $TRANSFORM_FAILURE					=  "Failure";

# StoredValue
our $STORED_VALUE_CLVALUE                  = "CLValue";
our $STORED_VALUE_ACCOUNT                  = "Account";
our $STORED_VALUE_CONTRACT_WASM            = "ContractWasm";
our $STORED_VALUE_CONTRACT                 = "Contract";
our $STORED_VALUE_CONTRACT_PACKAGE         = "ContractPackage";
our $STORED_VALUE_TRANSFER                 = "Transfer";
our $STORED_VALUE_DEPLOY_INFO              = "DeployInfo";
our $STORED_VALUE_ERA_INFO                 = "EraInfo";
our $STORED_VALUE_BID                      = "Bid";
our $STORED_VALUE_WITHDRAW                 = "Withdraw";

# ExecutableDeployItem

our $EDI_MODULE_BYTES 						= "ModuleBytes";
our $EDI_STORED_CONTRACT_BY_HASH			= "StoredContractByHash";
our $EDI_STORED_CONTRACT_BY_NAME			= "StoredContractByName";
our $EDI_STORED_VERSIONED_CONTRACT_BY_NAME  = "StoredVersionedContractByName";
our $EDI_STORED_VERSIONED_CONTRACT_BY_HASH  = "StoredVersionedContractByHash";
our $EDI_TRANSFER							= "Transfer";

# Key path for Ed25519 and Secp256k1

our $READ_ED25519_PRIVATE_KEY_FILE			= "./Crypto/Ed25519/Perl_Ed25519ReadPrivateKey.pem";
our $READ_ED25519_PUBLIC_KEY_FILE			= "./Crypto/Ed25519/Perl_Ed25519ReadPublicKey.pem";

our $READ_SECP256K1_PRIVATE_KEY_FILE		= "./Crypto/Secp256k1/Perl_Secp256k1ReadPrivateKey.pem";
our $READ_SECP256K1_PUBLIC_KEY_FILE			= "./Crypto/Secp256k1/Perl_Secp256k1ReadPublicKey.pem";


# Error in general
our $ERROR_TRY_CATCH					 	= "ERROR";
our $ERROR_PUT_DEPLOY						= "ERROR_PUT_DEPLOY";
1;