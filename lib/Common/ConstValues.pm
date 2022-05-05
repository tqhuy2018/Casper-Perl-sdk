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
1;