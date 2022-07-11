# Put Deploy RPC method call

## 1. Method declaration

The call for account_put_deploy RPC method is done through this function in "PutDeployRPC.pm" file under folder "PutDeploy":

```Perl
sub putDeploy
```
From this the GetAuctionInfoResult is retrieved through this function in "GetAuctionInfoResult.pm" file under folder "GetAuction":

```Perl
sub fromJsonToGetItemResult
```

## 2. Input & Output: 

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
## Put deploy test 

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

The above manual is for exising account in the test net. If you are familiar with the Casper system and Casper Signer, you can create your own Ed25519 or Secp256k1 account and do the test with your account.
 
Here is a brief description of the steps to do:

### Test account_put_deploy RPC method call with your own account 

Install Casper Signer. Create 1 account of type Ed25519 (for example, Secp256k1 is quite the same). 

<img width="306" alt="Screen Shot 2022-07-11 at 18 17 10" src="https://user-images.githubusercontent.com/94465107/178252948-b25b0d24-899a-4449-9434-57ad577175d1.png">

Download the private key for the newly created account. 

<img width="301" alt="Screen Shot 2022-06-28 at 14 56 03" src="https://user-images.githubusercontent.com/94465107/176126462-facea106-07cf-412b-8ccf-e5842d175fa0.png">

Give it a name, for example "Ed25519PrivateKeyPerl01.pem". Copy the key to the folder "t/Crypto/Ed25519" of the SDK.

<img width="1440" alt="Screen Shot 2022-07-11 at 18 19 19" src="https://user-images.githubusercontent.com/94465107/178253319-21dd9d0e-f5ed-45e6-802f-b3f5f0272e33.png">


In Eclipse, Right click the folder "t/Crypto/Ed25519" and hit "Refresh", you will then see the new "Ed25519PrivateKeyPerl01.pem" file is there.

Here is the file/folder structure before updated.

<img width="1440" alt="Screen Shot 2022-07-11 at 18 20 55" src="https://user-images.githubusercontent.com/94465107/178253582-ad8cec64-d683-41f0-ab25-a0750d8871ba.png">

And here is the file/folder structure after being updated, with the new "Ed25519PrivateKeyPerl01.pem" file appears.

<img width="1440" alt="Screen Shot 2022-07-11 at 18 28 41" src="https://user-images.githubusercontent.com/94465107/178254925-e11a2900-2e76-46d8-837a-3af83a17f78d.png">


Open CSPR test net at this address: https://testnet.cspr.live/

And make sure that in Casper Signer the active key is the already Ed25519 created key. If you have several keys in the list, please select other key and then select the Ed25519 Perl key again to make sure that in the CSPR test site, the account is link to the Perl Ed25519 account areadly being created.

<img width="305" alt="Screen Shot 2022-07-11 at 18 23 07" src="https://user-images.githubusercontent.com/94465107/178253839-9c627e23-16fe-45fc-a629-b5b780ad7b52.png">

The newly account will be connect to the site of Casper test net, in this example the account is "01a70c9c157a1cd8dbe00d5b12bb90ee7113f3b0d74e007f65daf4ebd1ba8e4282"

<img width="1440" alt="Screen Shot 2022-07-11 at 18 26 28" src="https://user-images.githubusercontent.com/94465107/178255073-ab505b83-6780-4567-8b81-2f2464a0827c.png">


And here is the Account detail, with no token at all.

From Casper test net choose Tool->Faucet and request for a 1000 CSPR token for the newly created account.
<img width="1440" alt="Screen Shot 2022-07-11 at 18 32 48" src="https://user-images.githubusercontent.com/94465107/178255430-8533da34-fae1-4967-937e-1b5dbc6889bc.png">

Make sure the check box "I'm not a robot" is checked and then click "Request tokens"

<img width="1440" alt="Screen Shot 2022-07-11 at 18 47 51" src="https://user-images.githubusercontent.com/94465107/178257953-2029d7ee-1052-42c4-b33f-80e4892de382.png">


Wait for 1-5 minutes and refresh the page for the account, you will now see the account with 1000 CSPR tokens.

<img width="1440" alt="Screen Shot 2022-07-11 at 18 51 57" src="https://user-images.githubusercontent.com/94465107/178258240-7410c068-0969-4b0b-a49f-58ca9b376c6b.png">



In file "ConstValues" under folder "lib/Common" of the Casper Perl SDK find for the variable "$READ_ED25519_PRIVATE_KEY_FILE", change its value to your pem name "Ed25519PrivateKeyPerl01.pem". It is the path for the private key of the account you are working on.

<img width="1440" alt="Screen Shot 2022-07-11 at 18 53 24" src="https://user-images.githubusercontent.com/94465107/178258768-c7886dd0-18a1-41c8-a643-586d1e783dc9.png">

In file "PutDeployTest.t" under folder "t" of the test folder, find for testPutDeploy function and replace the accountEd25519 value with the new account you have created, in this example it is "01afed08ed3ccf68a087db0e15e0b9d90d5d7c0f6eb3a3cc84eff52e81db733a50".

<img width="1440" alt="Screen Shot 2022-07-11 at 18 59 42" src="https://user-images.githubusercontent.com/94465107/178259761-06847272-a6dc-4051-bafc-de5eb1b93667.png">


Now you can test the new account by openning the file "PutDeployTest.t" and hit the Run button

<img width="1440" alt="Screen Shot 2022-07-11 at 18 53 24" src="https://user-images.githubusercontent.com/94465107/178262391-90c00190-5df8-4a43-99fe-3ebaa6d99e99.png">


There will be 2 lines informing the deploys have just been successfully posted in the log panel (1 deploy for Ed25519 account, 1 deploy for Secp256k1 account), like this "Put deploy successfull with deploy hash:8b9848dd5cf1cdba777a560cc08a2fb7ea87ae9f87ee32570bb9baf115cb4870".
Copy the second deploy hash, which is for Ed25519 account.

<img width="1440" alt="Screen Shot 2022-07-11 at 19 02 50" src="https://user-images.githubusercontent.com/94465107/178260483-8cbfe093-e0ea-48b6-a1e0-17a0228a8ee4.png">


Copy the deploy hash, in this example "8b9848dd5cf1cdba777a560cc08a2fb7ea87ae9f87ee32570bb9baf115cb4870" and search for it in the Test net

<img width="1440" alt="Screen Shot 2022-07-11 at 19 07 22" src="https://user-images.githubusercontent.com/94465107/178261093-2c50b345-0082-4c70-9bf2-7b1fcf648482.png">


As you can see, the deploy is in Pending mode, and not listed in the Account deploy list, as you go to the Account detail page.


<img width="1440" alt="Screen Shot 2022-07-11 at 19 10 12" src="https://user-images.githubusercontent.com/94465107/178261391-a1bdc20f-6345-4ae5-90b6-e090ab1e5275.png">


The deploy will be there in hours, but as you can see the deploy in Pending mode, then the Deploy is put to the system successfully.

The procedure for Secp256k1 account is quite the same, as long as you create the right account, copy the private key for the account to the right folder and point to it correctly, change the Secp256k1 account for sending the deploy in the PutDeployTest file, then the test will be done without error.

