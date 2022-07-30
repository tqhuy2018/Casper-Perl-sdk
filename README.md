# Casper-Perl-sdk

Perl SDK library for interacting with a CSPR node.

## What is CSPR-Perl-SDK?

SDK to streamline the 3rd party Perl client integration processes. Such 3rd parties include exchanges & app developers. 

## System requirement

The SDK use Perl 5.30.2. To run the SDK you need to have Perl 5.8.3 or above installed in your system.

## Run and test

You can run and test the SDK from command line interface or other IDE such as Eclipse.

To run and test the SDK you will need to install Perl and some Perl libraries.

### Install Perl

To run Perl on specific Operating System, please refer to the Perl language main site for how to set up on each Operating System at this address: https://www.perl.org/get.html

The SDK can be built and tested in different IDEs and from command line.

For Windows user, for fast and easy installation and usage of the command line for Perl, please install "Strawberry Perl" - As the document at the Perl main page:

A 100% Open Source Perl for Windows that is exactly the same as Perl everywhere else; this includes using modules from CPAN, without the need for binary packages. 

### Install libraries for Ed25519, Secp256k1, Blake2b256 

The SDK uses outside libraries for doing Ed25519, Secp256k1 Crypto and Blake2b256 Hash task from the following address:

Blake2b256: https://metacpan.org/pod/Crypt::Digest::BLAKE2b_256

Ed25519: https://metacpan.org/pod/Crypt::PK::Ed25519

Secp256k1: https://metacpan.org/pod/Crypt::PK::ECC

You need to install all the libraries before you can run and test the Casper Perl SDK.

#### For Windows users

The libraries can be installed following these steps:

- Open Command Prompt
- Run this command "perl -MCPAN -e shell"
- Then run this command "install CryptX"

#### For Mac users

There are several steps need to be done before you can run these command above.

First of all, before installing the libraries, you have to assign the read/write permission for the Perl folder. In general the Perl setting folder is in this path "/Library/Perl/..."

Open "Terminal" and run this command "open /Library/Perl"

You can see the folder for Perl, there can be sereral folders for some Perl version like this:

<img width="1179" alt="Screen Shot 2022-07-12 at 10 16 14" src="https://user-images.githubusercontent.com/94465107/178401243-154ffbe2-89f5-463d-a621-f7ae36eeec71.png">


Right click on the Perl latest version (or the version you are working on - by default it will be the latest) then choose "Get Info".

<img width="1250" alt="Screen Shot 2022-07-12 at 10 16 57" src="https://user-images.githubusercontent.com/94465107/178401290-f520e1eb-e285-47d9-be5b-5d5a08ac070a.png">

The detail information of the Perl folder is shown. Take attention to the "Sharing & Permission" region. There can be some accounts with "Read only" permission. You have to give the account "Read & Write" permission.

<img width="594" alt="Screen Shot 2022-07-12 at 10 21 54" src="https://user-images.githubusercontent.com/94465107/178402232-c5e52d71-25cd-4629-abc1-51f439d60726.png">

Click on the Lock at the bottom to begin the Permission assignment.

<img width="1057" alt="Screen Shot 2022-07-12 at 10 31 09" src="https://user-images.githubusercontent.com/94465107/178402804-af2e5791-976b-411b-b5ac-e4d5154888c5.png">

A window appears like this, enter your Administrator user name and password, then click "OK"

<img width="1252" alt="Screen Shot 2022-07-12 at 10 33 40" src="https://user-images.githubusercontent.com/94465107/178403424-7f7e8178-33e7-4ee9-b51d-d5d054d44212.png">

You will see the Lock is now in Open mode, click on each "Privilege" row to set the account Right.

<img width="309" alt="Screen Shot 2022-07-12 at 10 39 37" src="https://user-images.githubusercontent.com/94465107/178403852-3035971e-8957-4220-a5b0-929aeb25d634.png">

First set Permission for "admin" account. Click on the "Privilege" row for "admin" account, choose "Read & Write"

<img width="309" alt="Screen Shot 2022-07-12 at 10 46 10" src="https://user-images.githubusercontent.com/94465107/178404822-a986d65b-5cf4-4a73-b209-b14fe315e361.png">

Click on the "..." Circle in the bottom and choose "Apply to enclosed items..."

<img width="303" alt="Screen Shot 2022-07-12 at 10 51 04" src="https://user-images.githubusercontent.com/94465107/178405136-ffbf9206-86bf-4f63-9a4d-c4d6b2455bef.png">

Click "OK" for the confirmation Window.

<img width="308" alt="Screen Shot 2022-07-12 at 10 59 45" src="https://user-images.githubusercontent.com/94465107/178405877-f874b1ba-b681-4f57-b986-921cdc47fc44.png">


Now the "admin" account can have the right to Read&Write all folder/subfolder of the Perl/5.30 folder (5.30 is the Perl version in this manual).

Do it the same for the rest of the user, to make sure that when you install the Libraries, you won't face the problem of Read/Write deny problem. If the "admin" account user is not in the list, add this account by clicking the "+" button, then assign the permission "Read/Write" to this "admin" account.
When all the account Privilege is set to "Read & Write", you can click the Lock icon again to lock the Permission setting section. Then close the information window for the folder. The Permission setting is now done.

<img width="305" alt="Screen Shot 2022-07-12 at 11 00 57" src="https://user-images.githubusercontent.com/94465107/178406417-e9a84c23-233d-4d11-9815-451efc4db052.png">

You can now run the command line to install the outside libraries.

Open Terminal and type these commands:

```Perl
sudo perl -MCPAN -e shell
install CryptX
```

You can now run the libraries for Blake2b256, Ed25519 and Secp256k1

### Run and test from IDE

There are variety of IDE for Perl as described in this link: https://www.dunebook.com/best-perl-ide-and-editors/. 
In this document, we focus on how to implement the SDK in Eclipse as IDE, with EPIC add on installed.
First you need to install Eclipse from this address:
https://www.eclipse.org/downloads/
Download the Eclipse installation file (Choose the "Get Eclipse IDE 2022‑03"), install it, choose "Eclipse IDE for Java Developers" is good enough, as in this image below.
<img width="960" alt="step0" src="https://user-images.githubusercontent.com/94465107/168452628-444541ba-b8da-4231-98d7-829f0d4593c3.png">

Then open Eclipse, and hit "Help->Eclipse Marketplace", as in this image:

<img width="960" alt="step1" src="https://user-images.githubusercontent.com/94465107/168452655-8bfc9ce1-208b-4d3c-8cfc-51411b32c3db.png">

Search for keyword "EPIC", you will see the first result of EPIC addon for Perl in Eclipse appears, choose to install it, as this image 

<img width="960" alt="step2" src="https://user-images.githubusercontent.com/94465107/168452673-cacebfc7-1941-4a5c-a78d-fc8171e3e8da.png">

Accept by clicking all the checkbox during the process of installing EPIC addon

<img width="960" alt="step3" src="https://user-images.githubusercontent.com/94465107/168452684-26285935-b61a-4316-a6fd-0b7cb0c1adf7.png">

Next restart Eclipse and now you are ready to load the Casper Perl SDK in Eclipse.

Download the Casper Perl SDK from Github, place it somewhere in your local hard drive. From Eclipse you can then import the project.

From Eclipse choose "File-> Open Projects from File System..."

<img width="960" alt="step5" src="https://user-images.githubusercontent.com/94465107/168452733-4c5c31f1-f4db-4ff4-802c-5394868962b7.png">

Hit the "Directory" button

<img width="960" alt="step51" src="https://user-images.githubusercontent.com/94465107/168452768-700d24c2-3211-493f-a1c0-b9653aa35e43.png">
 
and choose the already downloaded Casper Perk SDK.

<img width="960" alt="step52" src="https://user-images.githubusercontent.com/94465107/168452773-0a2e73e5-98ac-42b2-b593-cccb4731920c.png">

Click "Finish", you then will see the project in the "Package Explorer" tab of Eclipse
<img width="960" alt="step6" src="https://user-images.githubusercontent.com/94465107/168452788-8164063f-ef37-4d1c-8d5d-b462a1d5e2ea.png">

Double click on  the "Casper-Perl-sdk" project to expand it.
The source code for the SDK is in the "lib" folder.
The test file for the SDK is in the "t" folder.
To test for the RPC calls, expand the "t" folder. You will see a list of test file in that folder.
To test for each file, just click on each file, for example to test for "GetAuctionTest.t" file, Double click on that file. Then in Eclispe hit "Run->Run". You will see the result of the test in the Console window, like this:
<img width="960" alt="step7" src="https://user-images.githubusercontent.com/94465107/168452870-6e403562-2086-4476-b35b-a7d7aa869547.png">
Follow the same procedure, click on each test file in the "t" folder to test for RPC call that you wish to do.

### Run and test from command line
Download the Source code from Github and put it in your local computer.
From the Terminal(Mac OS) or Command Prompt (Windows) enter the root folder of the SDK. Then enter the "t" folder of the SDK.
Run this command to test for each test file in the "t" folder.

```Perl
perl "test file"
```

For example if you want to test for file "GetAuction.t" which contain all test for the "state_get_auction_info" RPC call, run this command:

```Perl
perl GetAuction.t
```
If you want to test for file "GetDeployRPCTest.t" run this command:

```Perl
perl GetDeployRPCTest.t
```

# Usage: Run the module of the SDK

A sample project can be found at this address: https://github.com/hienbui9999/SampleCasperSDKCall_Perl

The SDK provide functionality in form of module. To use the module in other Perl project, simply copy all file/folders under the "lib" folder of the SDK and copy it under the "lib" folder of other project.

After that, you can call the function directly within the "lib" folder of project or create other file outside of the "lib" folder, for example in the root directory of the project, then call the class/function of the Casper SDK in the "lib" folder.

Detail of how to call the module function of the SDK from other files:

Create 1 simple project in Perl by create 1 folder, for example let call it "SamplePerlProject" and make the same folder "SamplePerlProject" somewhere in your hard disk.

Create a folder with name "lib" under the "SamplePerlProject" folder.

Copy all the file/folder under the "lib" folder of the Casper-Perl-sdk SDK to the "lib" folder under "SamplePerlProject" folder.

Under "SamplePerlProject" folder create 1 Perl file with name "test.pl" with the following content, just to implement the call for "chain_get_state_root_hash" RPC call.

```Perl
#!/usr/bin/perl
$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;
use strict;
use warnings;
use FindBin qw( $RealBin );
use lib "$RealBin/lib";
use GetStateRootHash::GetStateRootHashRPC;
use Common::ConstValues;
use Common::BlockIdentifier;
sub testFunc {
	my $bi = new Common::BlockIdentifier();
	# Test 1: Call with block hash
	$bi->setBlockType("hash");
	$bi->setBlockHash("d16cb633eea197fec519aee2cfe050fe9a3b7e390642ccae8366455cc91c822e");
	my $postParamStr = $bi->generatePostParam($Common::ConstValues::RPC_GET_STATE_ROOT_HASH);
	my $getStateRootHashRPC = new GetStateRootHash::GetStateRootHashRPC();
	my $stateRootHash1 = $getStateRootHashRPC->getStateRootHash($postParamStr);
	print $stateRootHash1;
}
testFunc();
```
Somehow the structure of the "SamplePerlProject" is like this

<img width="710" alt="Screen Shot 2022-05-15 at 10 35 59" src="https://user-images.githubusercontent.com/94465107/168456059-78df9514-694b-4bd4-b50d-83f3145f9437.png">

To run the "test.pl" file, in Terminal or Command Prompt enter to the folder of the "test.pl" file and run this command

```Perl
perl test.pl
```

Or in Eclipse double click the file "test.pl" and then hit "Run->Run" to run the file.

You will see the state root hash value printed in the Terminal or Console Window of Eclipse.

Full code for a sample project can be found at this address: https://github.com/hienbui9999/SampleCasperSDKCall_Perl

# Information for Secp256k1, Ed25519 Key Wrapper and Put Deploy

## Key wrapper specification:

The Key wrapper do the following work:(for both Secp256k1 and Ed25519):

- (PrivateKey,PublicKey) generation

- Sign message 

- Verify message

- Read PrivateKey/PublicKey from PEM file

- Write PrivateKey/PublicKey to PEM file

The key wrapper is used in account_put_deploy RPC method to generate approvals signature based on deploy hash.

The Blake2b256 hash and Crypto task for Ed25519 and Secp256k1 use Crypt and CryptX at this address:

https://metacpan.org/pod/Crypt::Digest::BLAKE2b_256 for blake2b256 hash function

https://metacpan.org/pod/Crypt::PK::ECC for Secp256k1 Crypto task

https://metacpan.org/pod/Crypt::PK::Ed25519 for Ed25519 Crypto task

The Blake2b256 hash is implemented in file "Blake2b256Helper.pm" under folder "CryptoHandle"

The Ed25519 crypto task is implemented in file "Ed25519Handle.pm" under folder "CryptoHandle"

The Secp256k1 crypto task is implemented in file "Secp256k1Handle.pm" under folder "CryptoHandle"

# Perl version of CLType primitives, Casper Domain Specific Objects and Serialization
 
 ## CLType primitives
 
 A detail information on CLType primitive can be read here 
 
 [Perl SDK CLType primitive](./docs/CLValue.md)

# Documentation for classes and methods

* [List of classes and methods](./docs/Help.md#list-of-rpc-methods)

  -  [Get State Root Hash](./docs/Help.md#i-get-state-root-hash)

  -  [Get Peer List](./docs/Help.md#ii-get-peers-list)

  -  [Get Deploy](./docs/Help.md#iii-get-deploy)
  
  -  [Get Status](./docs/Help.md#iv-get-status)
  
  -  [Get Block Transfers](./docs/Help.md#v-get-block-transfers)
  
  -  [Get Block](./docs/Help.md#vi-get-block)
  
  -  [Get Era Info By Switch Block](./docs/Help.md#vii-get-era-info-by-switch-block)
  
  -  [Get Item](./docs/Help.md#vii-get-item)
  
  -  [Get Dictionary Item](./docs/Help.md#ix-get-dictionaray-item)
  
  -  [Get Balance](./docs/Help.md#x-get-balance)
  
  -  [Get Auction Info](./docs/Help.md#xi-get-auction-info)
  
  -  [Put Deploy](./docs/PutDeploy.md)
