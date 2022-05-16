# Class built for storing NamedArg information 
# and handles the change from Json object to NamedArg object
package GetDeploy::ExecutableDeployItem::NamedArg;

use JSON;
use CLValue::CLType;
use CLValue::CLParse;
use CLValue::CLValue;

sub new {
	my $class = shift;
	my $self = {
		_itsName => shift,
		_clValue => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsName
sub setItsName {
	my ($self,$itsName) = @_;
	$self->{_itsName} = $itsName if defined ($itsName);
	return $self->{_itsName};
}
sub getItsName {
	my ($self) = @_;
	return $self->{_itsName};
}

# get-set method for clValue
sub setCLValue {
	my ($self,$clValue) = @_;
	$self->{_clValue} = $clValue if defined ($clValue);
	return $self->{_clValue};
}
sub getCLValue {
	my ($self) = @_;
	return $self->{_clValue};
}

# This function turn a Json object to an NamedArg object
sub fromJsonArrayToNamedArg {
	my @list = @_;
	my $jsonStr = encode_json($list[1]);
    my @nameArgJson = @{$list[1]};
   	my $counter = 0;
   	my $ret = new GetDeploy::ExecutableDeployItem::NamedArg();
	foreach(@nameArgJson) {
    	if($counter == 0) {
    		my $account = $_;
   			$ret->setItsName($account);
   		} elsif($counter == 1) {
   			my $clValueJson = $_;
   			my $bytes = $clValueJson->{'bytes'};
   			my $clType = CLValue::CLType->getCLType($clValueJson->{'cl_type'});
   			my $clParse = CLValue::CLParse->getCLParsed($clValueJson->{'parsed'},$clType);
   			my $clValue = new CLValue::CLValue();
   			$clValue->setBytes($bytes);
   			$clValue->setCLType($clType);
   			$clValue->setParse($clParse);
   			$ret->setCLValue($clValue);
   		}
    	$counter ++;
    }
    return $ret;
}
1;