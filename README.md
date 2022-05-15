# Casper-Perl-sdk

Perl SDK library for interacting with a CSPR node.

## What is CSPR-Perl-SDK?

SDK  to streamline the 3rd party Perl client integration processes. Such 3rd parties include exchanges & app developers. 

## System requirement

The SDK use Perl 5.30.2. To run the SDK you need to have Perl 5.8.3 or above installed in your system.

## Build and test
To run Perl on specific Operating System, please refer to the Perl language main site for how to set up on each Operating System at this address: https://www.perl.org/get.html

The SDK can be built and tested in different IDEs and from command line.

For Windows user, for fast and easy installation and usage of the command line for Perl, please install "Strawberry Perl" - As the document at the Perl main page:

 A 100% Open Source Perl for Windows that is exactly the same as Perl everywhere else; this includes using modules from CPAN, without the need for binary packages. 
 
### Build and test from IDE
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

Download the Casper Perl SDK from Github, place it somewhere in your local hard drive. From Eclipse you can then import the project 

### Build and test from command line
Download the Source code from Github and put it in your local computer.
From the Terminal(Mac OS) or Command Prompt (Windows) enter the root folder of the SDK. Then enter the "t" folder of the SDK.
Run this command to test for each test file in the "t" folder.

```Perl
perl "test file".
```

For example if you want to test for file "GetAuction.t" which contain all test for the "state_get_auction_info" RPC call, run this command:

```Perl
perl GetAuction.t
```
If you want to test for file "GetDeployRPCTest.t" run this command:

```Perl
perl GetDeployRPCTest.t
```

To test for all file, enter the root folder of the SDK and run this command:

```Perl
make test
```
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
