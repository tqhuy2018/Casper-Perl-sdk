=comment
This class handles error information when call for  RPC method.
The error can be invalid param, 
=cut
use strict;
use warnings;
package Common::ConstValues;
sub new { bless {}, shift };

our $TEST_NET = "https://node-clarity-testnet.make.services/rpc";
our $MAIN_NET = "https://node-clarity-testnet.make.services/rpc";
our $NULL_VALUE = "NULL_VALUE";

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
our $CLTYPE_PUBLICKEY 	= "PublicKey";
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



1;