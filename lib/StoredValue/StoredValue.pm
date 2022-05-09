=comment
Class built for storing StoredValue information.
This class has two atrributes: _itsType and _itsValue
The StoredValue can be 1 among 10 possible values as described in this link: 
https://docs.rs/casper-node/latest/casper_node/types/json_compatibility/enum.StoredValue.html
In detail, the value can be 1 among these values:
 	CLValue(CLValue),
    Account(Account),
    ContractWasm(String),
    Contract(Contract),
    ContractPackage(ContractPackage),
    Transfer(Transfer),
    DeployInfo(DeployInfo),
    EraInfo(EraInfo),
    Bid(Box<Bid>),
    Withdraw(Vec<UnbondingPurse>),
The attribute _itsType in this StoredValue::StoredValue class hold the type of 1 among 10 possible type above,
The attribute _itsValue in this StoredValue::StoredValue class hold the value of the stored value

=cut 
package StoredValue::StoredValue;
use CLValue::CLValue;
use Common::ConstValues;
sub new {
	my $class = shift;
	my $self = {
		_itsType => shift,
		_itsValue => shift,
	};
	bless $self, $class;
	return $self;
}

# get-set method for _itsType
sub setItsType {
	my ( $self, $value) = @_;
	$self->{_itsType} = $value if defined($value);
	return $self->{_itsType};
}

sub getItsType {
	my ( $self ) = @_;
	return $self->{_itsType};
}

# get-set method for _itsValue
sub setItsValue {
	my ( $self, $value) = @_;
	$self->{_itsValue} = $value if defined($value);
	return $self->{_itsValue};
}

sub getItsValue {
	my ( $self ) = @_;
	return $self->{_itsValue};
}

# This function parse the JsonObject (taken from server RPC method call) to get the StoredValue object
sub fromJsonObjectToStoredValue {
	my @list = @_;
	my $json = $list[1];
	my $ret = new StoredValue::StoredValue();
	my $clValueJson = $json->{'CLValue'};
	if($clValueJson) {
		my $clValue = new CLValue::CLValue->fromJsonObjToCLValue($clValueJson);
		$ret->setItsValue($clValue);
		$ret->setItsType($Common::ConstValues::STORED_VALUE_CLVALUE);
		return $ret;
	}
	my $account = $json->{'Account'};
	if($account) {
		
	}
	return $ret;
}