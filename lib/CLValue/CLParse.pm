package CLValue::CLParse;
sub new {
	my $class = shift;
	my $self = {
		# Value of the Parse in String format
		_itsValueInStr => shift,
		# The CLType of the CLParse
		_itsCLType => shift,
		# innerParsed to hold value for the following type: 
    	# Option,  Result,  Tuple1 will take only 1 item of innerParsed
    	# Map,  Tuple2 will take 2  item of innerParsed
    	# Tuple3 will take 3 item of innerParsed
		_innerParsed1 => shift,
		_innerParsed2 => shift,
		_innerParsed3 => shift,
		_itsValue => [ @_ ],
	}
}