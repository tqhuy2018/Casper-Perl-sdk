# Perl Casper SDK manual on classes and methods

## RPC Calls

The calling the RPC follow this sequence:

- Create the POST request with corresponding paramters for each methods

- Send the POST request to the Casper server (test net or main net or localhost) 

- Get the Json message back from the server. The message could either be error message or the json string representing the object need to retrieve. If you send wrong parameter, such as in "chain_get_state_root_hash" RPC call, if you send BlockIdentifier with too big block height (that does not exist) then you will get error message back from Casper server. If you send correct parameter, you will get expected json message for the data you need.

- Handle the data sent back from Casper server for the POST request. Depends on the RPC method call, the corresponding json data is sent back in type of [String:Value] form. The task of the SDK is to parse this json data and put in correct data type built for each RPC method.

## List of RPC methods:

1) [Get state root hash (chain_get_state_root_hash)](#i-get-state-root-hash)

2) [Get peer list (info_get_peers)](#ii-get-peers-list)

3) [Get Deploy (info_get_deploy)](#iii-get-deploy)

4) [Get Status (info_get_status)](#iv-get-status)

5) [GetBlockTransfersResult transfer (chain_get_block_transfers)](#v-get-block-transfers)

6) [Get Block (chain_get_block)](#vi-get-block)

7) [Get Era by switch block (chain_get_era_info_by_switch_block)](#vii-get-era-info-by-switch-block)

8) [Get Item (state_get_item)](#vii-get-item)

9) [Get Dictionary item (state_get_dictionary_item)](#ix-get-dictionaray-item)

10) [Get balance (state_get_balance)](#x-get-balance)

11) [Get Auction info (state_get_auction_info)](#xi-get-auction-info)

12) Put Deploy (account_put_deploy) 

### I. Get State Root Hash  

The task is done in file "GetStateRootHashRPC.pm" in folder "GetStateRootHash"

#### 1. Method declaration

```Perl
sub getStateRootHash
```

#### 2. Input & Output: 

The sample code for calling chain_get_state_root_hash RPC is done in the "GetStateRootHashTest.t" file under "t" folder of the SDK.
The procedure for calling the get state root hash is: 
First you need to instantiate an instance of the BlockIdentifier class (which declared in file "BlockIdentifier.pm" under folder "Common"). The BlockIdentifier object is used to set the input parameter for the chain_get_state_root_hash call.
When the parameter for the BlockIdentifier is set, the BlockIdentifier then generate the post parameter for sending to Casper server to get the state root hash back. The sending POST request is sent and handled within file "GetStateRootHashRPC.pm" in folder "GetStateRootHash". Then the state root hash is retrieved if the correct data for the POST request is used, otherwise there will be error object thrown. 

- Here are some examples of correct data to send:

	- *Set the BlockIdentifier with type of Hash and pass a correct block hash to the BlockIdentifier*

	- *Set the BlockIdentifier with type of Height and pass a correct block height to the BlockIdentifier*

- Here are some examples of incorrect data to send:

	- *Set the BlockIdentifier with type of Hash and pass a incorrect block hash to the BlockIdentifier*

	- *Set the BlockIdentifier with type of Height and pass a incorrect block height to the BlockIdentifier - for example the height is too big, bigger than the max current height of the block, or bigger than U64.max.*

Please refer to the "GetStateRootHashTest.t" under "t" folder to see the real example of how to generate the parameter with correct and incorrect data.

**In detail:**

**Input:** NSString represents the json parameter needed to send along with the POST method to Casper server. This parameter is build based on the BlockIdentifier.

When call this method to get the state root hash, you need to declare a BlockIdentifier object and then assign the height or hash or just none to the BlockIdentifier. Then the BlockIdentifier is transfer to the jsonString parameter. The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
```
2. Use the $postParamStr to call the function:

```Perl
my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
my $stateRootHash = $getStateRootHashRPC->getStateRootHash($postParamStr);
```

**Output:** the state root hash is retrieved if the correct data for the POST request is used, otherwise there will be error object thrown. 

This process is done within the function "sub getStateRootHash" of the class "GetStateRootHash::GetStateRootHashRPC" (declare in file GetStateRootHashRPC.pm under folder lib/GetStateRootHash).

### II. Get Peers List  

The task is done in file "GetPeerPRC.pm" and "GetPeerResult.pm"

#### 1. Method declaration

From file "GetPeerPRC.pm" call this method

```Perl
sub getPeers
```

This method call other method from file "GetPeerResult.pm" to get the state root hash or handle the error retrieved from the http response.

```Perl
sub fromJsonObjectToGetPeersResult
```

#### 2. Input & Output: 

In this function of file "GetPeerPRC.pm"

```Perl
sub getPeers
```

- **Input:** NSString represents the json parameter needed to send along with the POST method to Casper server. This string is just simple as:

```Perl
{"params" : [],"id" : 1,"method":"info_get_peers","jsonrpc" : "2.0"}
```

The retrieve of PeerEntry List is done with this function:

```Perl
GetPeers::GetPeersResult->fromJsonObjectToGetPeersResult($json)
```
in which $json is the $json data retrieved from the http response.

- **Output:** List of peer defined in class GetPeersResult, which contain a list of PeerEntry - a class contain of nodeId and address.

### III. Get Deploy 

#### 1. Method declaration

The call for Get Deploy RPC method is done through this function in "GetDeployRPC.pm" file under folder "GetDeploy"

```Perl
sub getDeployResult
```

From this the GetDeployResult is retrieved through this function, defined in "GetDeployResult.m" file

```Perl
GetDeploy::GetDeployResult->fromJsonObjectToGetDeployResult($json) 
```

#### 2. Input & Output: 

* In this function of file "GetDeployRPC.pm"

```Perl
sub getDeployResult
```

- **Input:** is the string of parameter sent to Http Post request to the RPC method, which in form of

```Perl
{"id" : 1,"method" : "info_get_deploy","params" : {"deploy_hash" : "6e74f836d7b10dd5db7430497e106ddf56e30afee993dd29b85a91c1cd903583"},"jsonrpc" : "2.0"}
```
To generate such string, you need to use GetDeployParams class, which declared in file "GetDeployParams.pm"

Instantiate the GetDeployParams, then assign the deploy_hash to the object and use function generatePostParam to generate such parameter string like above.

Sample  code for this process

```Perl
my $getDeployParams = new GetDeploy::GetDeployParams();
$getDeployParams->setDeployHash("55968ee1a0a7bb5d03505cd50996b4366af705692645e54125184a885c8a65aa");
my $paramStr = $getDeployParams->generateParameterStr();
my $getDeployRPC = new GetDeploy::GetDeployRPC();
my $getDeployResult = $getDeployRPC->getDeployResult($paramStr);
```

- **Output:** The ouput is handler in HttpHandler class and then pass to fromJsonObjectToGetDeployResult function, described below:

* For function 

```Perl
sub fromJsonObjectToGetDeployResult 
```

- **Input:** The Json object represents the GetDeployResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data GetDeployResult is taken to pass to the function to get the Deploy information.

- **Output:** The GetDeployResult which contains all information of the Deploy. From this result you can retrieve information of Deploy hash, Deploy header, Deploy session, payment, ExecutionResults.

### IV. Get Status

#### 1. Method declaration

The call for Get Status RPC method is done through this function in file "GetStatusResultRPC.pm" in folder "GetStatus":

```Perl
sub getStatus
```

From this the GetStatusResult is retrieved through this function in file "GetStatusResult.m" in the same folder of "GetStatus":

```Perl
sub fromJsonObjectToGetStatusResult
```

#### 2. Input & Output: 

* In this function in file "GetStatusResultRPC.pm":

```Perl
sub getStatus
```

- **Input:** a JsonString of value 
```Perl
{"params" : [],"id" : 1,"method":"info_get_status","jsonrpc" : "2.0"}
```

- **Output:** The ouput is handler in HttpHandler class and then pass to fromJsonDictToGetStatusResult function, described below:

* In this function in file "GetStatusResult.pm":

```Perl
sub fromJsonObjectToGetStatusResult
```

- **Input:** The Json object represents the GetStatusResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetStatusResult object is taken through this function.

- **Output:** The GetStatusResult which contains all information of the status. From this result you can retrieve information such as: api_version,chainspec_name,starting_state_root_hash,peers,last_added_block_info...

### V. Get Block Transfers

#### 1. Method declaration

The call for Get Block Transfers RPC method is done through this function in "GetBlockTransfersRPC.pm" file under folder "GetBlockTransfers":

```Perl
sub getBlockTransfers
```

From this the GetBlockTransfersResult is retrieved through this function, in "GetBlockTransfersResult.pm" file, which is also in folder "GetBlockTransfers":

```Perl
sub fromJsonObjectToGetBlockTransfersResult
```

#### 2. Input & Output: 

* In this function in file "GetBlockTransfersRPC.pm":

```Perl
sub getBlockTransfers
```

- **Input:** a JsonString of such value:

```Perl
{"method" : "chain_get_block_transfers","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK_TRANSFERS);
```
2. Use the $postParamStr to call the function:

```Perl
my $getBlockTransfers = new GetBlockTransfers::GetBlockTransfersRPC();
my $getBTResult = $getBlockTransfers->getBlockTransfers($postParamStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBlockTransfersResult object.

The code for this process is in function getBlockTransfers of file "GetBlockTransferRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetBlockTransfers::GetBlockTransfersResult->fromJsonObjectToGetBlockTransfersResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetBlockTransfersResult.pm":

```Perl
sub fromJsonObjectToGetBlockTransfersResult
```

**Input:** The Json object represents the GetBlockTransfersResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBlockTransfersResult is taken.

**Output:** The GetBlockTransfersResult which contains all information of the Block Transfers. From this result you can retrieve information such as: api_version,block_hash, list of transfers. (Transfer is wrap in class Transfer.h and all information of Transfer can retrieve from this result).

### VI. Get Block 

#### 1. Method declaration

The call for Get Block Transfers RPC method is done through this function in "GetBlockRPC.pm" file under folder "GetBlock":

```Perl
sub getBlock
```

From this the GetBlockResult is retrieved through this function in file "GetBlockResult.pm" under the same folder "GetBlock":

```Perl
sub fromJsonObjectToGetBlockResult
```

#### 2. Input & Output: 

* For function in file "GetBlockRPC.pm":

```Perl
sub getBlock
}
```

**Input:** a JsonString of such value:
```Perl
{"method" : "chain_get_block","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBlockTransfersResult object.

The code for this process is in function getBlockTransfers of file "GetBlockTransferRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetBlockTransfers::GetBlockTransfersResult->fromJsonObjectToGetBlockTransfersResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetBlockResult.pm":

```Perl
sub fromJsonObjectToGetBlockResult
```

**Input:** The Json object represents the GetBlockResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBlockResult is taken to pass to the function to get the block information.

**Output:** The GetBlockResult which contains all information of the block. From this result you can retrieve information such as: api_version,JsonBlock object(in which you can retrieve information such as: blockHash, JsonBlockHeader,JsonBlockBody, list of proof)

### VII. Get Era Info By Switch Block

#### 1. Method declaration

The call for Get Era Info RPC method is done through this function in "GetEraInfoBySwitchBlockRPC.pm" file under folder "GetEraInfoBySwitchBlock"

```Perl
sub getEraInfo 
```

Fro this the GetEraInfoResult is retrieved through this function, also in "GetEraInfoResult.m" file

```Perl
sub fromJsonToGetEraInfoResult
```

#### 2. Input & Output: 

* For function in file "GetEraInfoBySwitchBlockRPC.pm":

```Perl
sub getEraInfo
```

**Input:** a JsonString of such value:
```Perl
{"method" : "chain_get_era_info_by_switch_block","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_BLOCK);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function GetEraInfoResult of file "GetEraInfoBySwitchBlockRPC.pm" like this:

```Perl
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetEraInfoBySwitchBlock::GetEraInfoResult->fromJsonToGetEraInfoResult($decoded->{'result'});
	return $ret;
}
```
* For this function in file "GetEraInfoResult.pm" under folder "GetEraInfoBySwitchBlock":

```Perl
sub fromJsonToGetEraInfoResult
```

**Input:** The Json object represents the GetEraInfoResult object. This Json object is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that the JSON data the GetEraInfoResult is retrieved.

**Output:** The GetEraInfoResult which contains all information of the era info. From this result you can retrieve information such as: api_version, era_summary (in which you can retrieve information such as: block_hash, era_id, state_root_hash, merkle_proof, stored_value).


### VII. Get Item

#### 1. Method declaration

The call for Get Item RPC method is done through this function in file "GetItemRPC.pm" under folder "GetItem":

```Perl
sub getItem
```

From this the GetItemResult is retrieved through this function in file "GetItemResult.pm", also under folder "GetItem": 

```Perl
sub fromJsonToGetItemResult
```

#### 2. Input & Output: 

* For this function in file "GetItemRPC.pm":

```Perl
sub getItem
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_item","id" : 1,"params" :{"state_root_hash" : "d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228","key":"withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1","path":[]},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetItemParams class, which declared in file "GetItemParams.pm" under folder "GetItem"

Instantiate the GetItemParams, then assign the GetItemParams object with state_root_hash, key, and path, then use function "generateParameterStr" of the "GetItemParams" class to generate such parameter string like above.

Sample  code for this process:

```Perl
my $getItemRPC = new GetItem::GetItemRPC();
my $getItemParams = new GetItem::GetItemParams();
$getItemParams->setStateRootHash("340a09b06bae99d868c68111b691c70d9d5a253c0f2fd7ee257a04a198d3818e");
$getItemParams->setKey("uref-ba620eee2b06c6df4cd8da58dd5c5aa6d42f3a502de61bb06dc70b164eee4119-007");
my $paramStr = $getItemParams->generateParameterStr();
my $getItemResult = $getItemRPC->getItem($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function getItem of file "GetItemRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
   	my $ret = GetItem::GetItemResult->fromJsonToGetItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetItemResult.pm":

```Perl
sub fromJsonToGetItemResult
```

**Input:** The Json object represents the GetItemResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetItemResult is retrieved.

**Output:** The GetItemResult which contains all information of the item. From this result you can retrieve information such as: api_version,merkle_proof, stored_value.

### IX. Get Dictionaray Item

#### 1. Method declaration

The call for Get Dictionary Item RPC method is done through this function in "GetDictionaryItemRPC.pm" file under "GetDictionaryItem" folder:

```Perl
sub getDictionaryItem
```

From this the GetDictionaryItemResult is retrieved through this function in "GetDictionaryItemResult.pm" file, also under "GetDictionaryItem" folder:

```Perl
sub fromJsonToGetDictionaryItemResult
```

#### 2. Input & Output: 

* For this function in file "GetDictionaryItemRPC.pm": 

```Perl
sub getDictionaryItem
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_dictionary_item","id" : 1,"params" :{"state_root_hash" : "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8","dictionary_identifier":{"AccountNamedKey":{"dictionary_name":"dict_name","key":"account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877","dictionary_item_key":"abc_name"}}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetDictionaryItemParams class, which declared in file "GetDictionaryItemParams.pm" under folder "GetDictionaryItem"

Instantiate the GetDictionaryItemParams, then assign the GetDictionaryItemParams object with state_root_hash and an DictionaryIdentifier value.
The DictionaryIdentifier can be 1 among 4 possible classes defined in folder "DictionaryIdentifierEnum".
When the state_root_hash and DictionaryIdentifier value are sets, use function "toJsonString" of the "GetDictionaryItemParams" class to generate such parameter string like above.

Sample  code for this process, with DictionaryIdentifier of type AccountNamedKey

```Perl
my $getDIRPC = new GetDictionaryItem::GetDictionaryItemRPC();
my $getDIParams = new GetDictionaryItem::GetDictionaryItemParams();
my $diANK = new GetDictionaryItem::DIAccountNamedKey();
$diANK->setKey("account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877");
$diANK->setDictionaryName("dict_name");
$diANK->setDictionaryItemKey("abc_name");
my $di = new GetDictionaryItem::DictionaryIdentifier();
$di->setItsType("AccountNamedKey");
$di->setItsValue($diANK);
$getDIParams->setStateRootHash("146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8");
$getDIParams->setDictionaryIdentifier($di);
my $paramStr = $getDIParams->generateParameterStr();
my $getDIResult = $getDIRPC->getDictionaryItem($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetEraInfoResult object.

The code for this process is in function getDictionaryItem of file "GetDictionaryItemRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetDictionaryItem::GetDictionaryItemResult->fromJsonToGetDictionaryItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetDictionaryItemResult.pm": 

```Perl
sub fromJsonToGetDictionaryItemResult 
```

**Input:** The Json object represents the GetDictionaryItemResult object. This NSDictionaray is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetDictionaryItemResult is retrieved.

**Output:** The GetDictionaryItemResult which contains all information of the dictionary item. From this result you can retrieve information such as: api_version,dictionary_key, merkle_proof,stored_value.

### X. Get Balance

#### 1. Method declaration

The call for Get Balance RPC method is done through this function in "GetBalanceResultRPC.pm" file under folder "GetBalance":

```Perl
sub getBalance
```

From this the GetBalanceResult is retrieved through this function, in "GetBalanceResult.pm" file, also under folder "GetBalance":

```Perl
sub fromJsonToGetBalanceResult
```

#### 2. Input & Output: 

* For this function in file "GetBalanceResultRPC.pm":  

```Perl
sub getBalance
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_balance","id" : 1,"params" :{"state_root_hash" : "8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189","purse_uref":"uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007"},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type GetBalanceParams class, which declared in file "GetBalanceParams.pm" under folder "GetBalance".

Instantiate the GetBalanceParams, then assign the GetBalanceParams with state_root_hash and purse_uref then use function "generateParameterStr" of the "GetBalanceParams" class to generate such parameter string like above.

Sample  code for this process

```Perl
my $rpc = new GetBalance::GetBalanceResultRPC();
my $params = new GetBalance::GetBalanceParams();
$params->setStateRootHash("8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189");
$params->setPurseUref("uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007");
my $paramStr = $params->generateParameterStr();
my $result = $rpc->getBalance($paramStr);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetBalanceResult object.

The code for this process is in function getBalance of file "GetBalanceResultRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetBalance::GetBalanceResult->fromJsonToGetBalanceResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetBalanceResult.pm": 
```Perl
sub fromJsonToGetBalanceResult
```

**Input:** The Json object represents the GetBalanceResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetBalanceResult is taken.

**Output:** The GetBalanceResult which contains all information of the balance. From this result you can retrieve information such as: api_version,balance_value, merkle_proof.

### XI. Get Auction Info

#### 1. Method declaration

The call for Get Auction RPC method is done through this function in "GetAuctionInfoRPC.pm" file under folder "GetAuction":

```Perl
sub getAuction
```

From this the GetAuctionInfoResult is retrieved through this function in "GetAuctionInfoResult.pm" file under folder "GetAuction":

```Perl
sub fromJsonToGetItemResult
```

#### 2. Input & Output: 

* For this function in file "GetAuctionInfoRPC.pm": 

```Perl
sub getAuction
```

**Input:** a JsonString of such value:
```Perl
{"method" : "state_get_auction_info","id" : 1,"params" : {"block_identifier" : {"Hash" :"d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e"}},"jsonrpc" : "2.0"}
```

To generate such string, you need to use an object of type BlockIdentifier class, which declared in file "BlockIdentifier.pm" under folder "Common"

Instantiate the BlockIdentifier, then assign the block with block hash or block height or just assign nothing to the object and use function "generatePostParam" of the "BlockIdentifier" class to generate such parameter string like above.
The whole sequence can be seen as the following code:
1. Declare a BlockIdentifier and assign its value
```Perl
my $bi = new Common::BlockIdentifier();
# Call with block hash
$bi->setBlockType("hash");
$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");

# or you can set the block attribute like this

$bi->setBlockType("height");
$bi->setBlockHeight("1234");

or like this

$bi->setBlockType("none");
   
# then you generate the jsonString to call the generatePostParam function
my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_AUCTION);
```

**Output:** The result of the Post request for the RPC method is a Json string data back, which can represents the error or the GetAuctionInfoResult object.

The code for this process is in function getAuction of file "GetAuctionInfoRPC.pm" like this:

```Perl
my $d = $response->decoded_content;
my $decoded = decode_json($d);
my $errorCode = $decoded->{'error'}{'code'};
if($errorCode) {
	my $errorException = new Common::ErrorException();
	$errorException->setErrorCode($errorCode);
	$errorException->setErrorMessage($decoded->{'error'}{'message'});
	return $errorException;
} else {
    	my $ret = GetAuction::GetAuctionInfoResult->fromJsonToGetItemResult($decoded->{'result'});
	return $ret;
}
```

* For this function in file "GetAuctionInfoResult.pm":

```Perl
sub fromJsonToGetItemResult 
```

**Input:** The Json object represents the GetAuctionInfoResult object. This Json is returned from the POST method when call the RPC method. Information is sent back as JSON data and from that JSON data the GetAuctionInfoResult is taken.

**Output:** The GetAuctionInfoResult which contains all information of the aunction. From this result you can retrieve information such as: api_version,auction_state (in which you can retrieve information such as state_root_hash, block_height, list of JsonEraValidators).


### XII. Put Deploy

#### 1. Method declaration

The call for account_put_deploy RPC method is done through this function in "PutDeployRPC.pm" file under folder "PutDeploy":

```Perl
sub putDeploy
```
From this the GetAuctionInfoResult is retrieved through this function in "GetAuctionInfoResult.pm" file under folder "GetAuction":

```Perl
sub fromJsonToGetItemResult
```

#### 2. Input & Output: 

* For this function in file "PutDeployRPC.pm": 

```Perl
sub putDeploy
```
**Input:** A deploy object that will be posted to the system. 
From this deploy, a string for posting that deploy is generated using this function, aslo in file "PutDeployRPC.pm"
```Perl
sub fromDeployToJsonString
```
The result of this function is a Json string represent the deploy, that can later use as parameter for the POST request. The Json string is somehow like this:
```Perl
{"id": 1,"method": "account_put_deploy","jsonrpc": "2.0","params": [{"header": {"account": "0152a685e0edd9060da4a0d52e500d65e21789df3cbfcb878c91ffeaea756d1c53",
"timestamp": "2022-06-28T11:35:19.349Z","ttl":"1h 30m","gas_price":1,
"body_hash":"798a65dae48dbefb398ba2f0916fa5591950768b7a467ca609a9a631caf13001","dependencies": [],
"chain_name": "casper-test"},
"payment": {"ModuleBytes": {"module_bytes": "","args": 
[["amount",{"bytes": "0400ca9a3b","cl_type":"U512","parsed":"1000000000"}]]}},
"session": {"Transfer": {"args": [["amount",{"bytes": "04005ed0b2","cl_type":"U512","parsed":"3000000000"}],
["target",{"bytes": "015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a","cl_type":"PublicKey","parsed":"015f12b5776c66d2782a4408d3910f64485dd4047448040955573aa026256cfa0a"}],
["id",{"bytes": "010000000000000000","cl_type":{"Option": "U64"},"parsed":0}],["spender",{"bytes": "01dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b","cl_type":"Key","parsed":{"Hash":"hash-dde7472639058717a42e22d297d6cf3e07906bb57bc28efceac3677f8a3dc83b"}}]]}},
"approvals": [{"signer": "0152a685e0edd9060da4a0d52e500d65e21789df3cbfcb878c91ffeaea756d1c53",
"signature": "016596f09083d32eaffc50556f1a5d22202e8927d5aa3267639aff4b9d3412b5ae4a3475a5da6c1c1086a9a090b0e1090db5d7e1b7084bb60b2fee3ce9447a2a04"}],
"hash": "65c6ccdc5aacc9dcd073ca79358bf0b5115061e8d561b3e6f461a34a6c5858f0"}]}
```
The rule for generating the Json string from the deploy is:

First get the deploy header - make it to part of the Json string

Then get the deploy payment - make it to part of the Json string

Get the deploy session - make it to part of the Json string

Get the approval - make it to part of the Json string

Get the deploy - hash - make it to part of the Json string

Build the full Json string for the deploy.

The code for the whole process is done in this code

```Perl
sub fromDeployToJsonString {
	my @vars = @_;
	my $deploy = new GetDeploy::Deploy();
	$deploy = $vars[0];
	my $deployHeader = new GetDeploy::DeployHeader();
	$deployHeader = $deploy->getHeader();
	my $ediToJsonHelper = new PutDeploy::ExecutableDeployItemToJsonHelper();
	my $headerString = "\"header\": {\"account\": \"".$deployHeader->getAccount()."\",\"timestamp\": \"".$deployHeader->getTimestamp()."\",\"ttl\":\"".$deployHeader->getTTL()."\",\"gas_price\":".$deployHeader->getGasPrice().",\"body_hash\":\"".$deployHeader->getBodyHash(). "\",\"dependencies\": [],\"chain_name\": \"".$deployHeader->getChainName()."\"}";
    	my $paymentJsonStr = "\"payment\": ".$ediToJsonHelper->toJsonString($deploy->getPayment());
   	my $sessionJsonStr = "\"session\": ".$ediToJsonHelper->toJsonString($deploy->getSession());
    	my $approval = new GetDeploy::Approval();
    	my @approvalList = $deploy->getApprovals();
    	$approval = $approvalList[0];
    	my $approvalJsonStr = "\"approvals\": [{\"signer\": \"".$approval->getSigner()."\",\"signature\": \"".$approval->getSignature()."\"}]";
    	my $hashStr = "\"hash\": \"".$deploy->getDeployHash()."\"";
    	my $deployJsonStr = "{\"id\": 1,\"method\": \"account_put_deploy\",\"jsonrpc\": \"2.0\",\"params\": [{".$headerString.",".$paymentJsonStr.",".$sessionJsonStr.",".$approvalJsonStr.",".$hashStr."}]}";
    return $deployJsonStr;
}
```
Output: If the deploy is sent successfully to the system, then the result will be a Json string back like this
```Perl
{
    "jsonrpc": "2.0",
    "id": 1,
    "result": {
        "api_version": "1.4.6",
        "deploy_hash": "542a5128dbd4c6ebdfc11ee390eb9858b25e0a2c9d2975f90900aadd7b81d5dc"
    }
}
```
The PutDeployResult object is then retrieved by parsing that Json string. The work is done in this code in function "putDeploy" in file "PutDeployRPC.pm":

```Perl
my $putDeployResult = new PutDeploy::PutDeployResult();
$putDeployResult = PutDeploy::PutDeployResult->fromJsonObjectToPutDeployResult($decoded->{'result'});
return $putDeployResult->getDeployHash();
```

If the deploy fails to send to the system (for some reasons, such as you send a deploy with time_stamp in the very old past, or send insufficient amount of token, then the result will be a Json string back somehow like this:
```Perl
{
    "jsonrpc": "2.0",
    "id": 1,
    "error": {
        "code": -32602,
        "message": "Invalid params",
        "data": null
    }
}
```

A line of code checking for this error 

```Perl
 my $errorCode = $decoded->{'error'}{'code'};
```
And then if the errorCode does exist, an Error message is returned

```Perl
return $Common::ConstValues::ERROR_PUT_DEPLOY;
```
#### Put deploy test 

There are positive and negative test cases for putting deploy of Ed25519 account and Secp256k1 account.

The Ed25519 account is using this account "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4" which you can see the account detail at this address https://testnet.cspr.live/account/011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4

The Secp256k1 account is using this account "0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499" which you can see the account detail at this address https://testnet.cspr.live/account/0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499

The test is done in file "PutDeployRPCTest" under package "com.casper.sdk.putdeploy" of the "test" folder.

The function for doing the positive test for both Ed25519 and Secp256k1 is 

```Perl
sub testPutDeploy
```

This function takes 1 parameter with value 1 or 0 to determine what type of account is using. If the value of the input is 1, then the account of type Ed25519 is used, and if the input value is 0, the account of type Secp256k1 is used.

The procedure for making a positive test is to create a deploy by assigning its header value. All the value for deploy header except for the body hash can be assigned by putting sample value.
Then the payment and session of the deploy is assign by putting sample value for a transfer deploy.
The deploy body hash is then calculated based on the payment and session of the deploy by calling this code line: 

```Kotlin
my $deployBodyHash = $deploy->getBodyHash();
$deployHeader->setBodyHash($deployBodyHash);
```
The body hash is generated by using blake2b256 over the (paymentSerialization + sessionSerialization)

Then the header.body_hash is assigned by that body hash value.

The deploy hash is generated based on the deploy header, by getting the blake2b256 value over the deployHeaderSerialization.

You also need to generate the signature for the account by using the Ed25519 or Secp256k1 Crypto function, based on the account you are using to put the deploy. The signature is generated by siging the account with the Ed25519 or Secp256k1 private key.

For Ed25519 account, the private key for signing the account is loaded from the file "Perl_Ed25519ReadPrivateKey.pem" under folder "Crypto/Ed25519" of the SDK test folder (the "t" folder). The private key is read from the Pem file, then a signature with length of 128 will be generated, and a prefix of "01" will be added to the signature to make the real signature to use for putting the deploy. The pem file "Perl_Ed25519ReadPrivateKey.pem" is generated from Casper Signer from the account of the Ed25519 account (private key corresponding to account "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4")

For Secp256k1 account, the private key for signing the account is loaded from the file "Perl_Secp256k1ReadPrivateKey.pem" under folder "Crypto/Secp256k1" of the SDK test folder (the "t" folder). The private key is read from the Pem file, then a signature with length of 128 will be generated, and a prefix of "02" will be added to the signature to make the real signature to use for putting the deploy. The pem file "Perl_Secp256k1ReadPrivateKey.pem" is generated from Casper Signer from the account of the Secp256k1 account. (private key corresponding to account "0203b32877c189197706bd62b27690a1857661ab8e53ea07146f1450c9ca59e2d499")

After each time the "PutDeployTest" is called, the deploy hash is printed out in the log region in Eclipse (or in Terminal/Command Prompt if you run the test from command line), like this:

<img width="1440" alt="Screen Shot 2022-07-11 at 17 04 35" src="https://user-images.githubusercontent.com/94465107/178241695-b487bf83-a96a-44aa-976b-ac94bed1906e.png">

Copy the deploy hash and paste it to the search box in the CSPR test net site, like this

<img width="1440" alt="Screen Shot 2022-07-11 at 17 10 47" src="https://user-images.githubusercontent.com/94465107/178242145-3b8871c7-2519-4fbb-8afc-ad0d770a1330.png">

You will see the information of the deploy (in pending mode) like this:

<img width="1440" alt="Screen Shot 2022-07-11 at 17 13 09" src="https://user-images.githubusercontent.com/94465107/178242278-5b95ace9-f90f-478b-9583-d590e635ff1c.png">


You will have to wait up to 1 day for the deploy to appear in the deploy list for the account that put the account to the system.

For example this is the list of deploys being created for account "011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4" by going to this address https://testnet.cspr.live/account/011e22df016929612d5670e20a625124561c5c06c3a2587f0ec10489c35fc8a2b4 and scroll down.

<img width="1440" alt="Screen Shot 2022-07-11 at 17 00 25" src="https://user-images.githubusercontent.com/94465107/178239917-db6e4491-29eb-4539-a194-54011fa7642b.png">

For Secp256k1 account, you can see a list of deploy being put by going to this address and scroll down: 
<img width="1440" alt="Screen Shot 2022-07-11 at 17 02 26" src="https://user-images.githubusercontent.com/94465107/178240244-16257b49-9107-4b79-9acf-acaa3dbe959b.png">


