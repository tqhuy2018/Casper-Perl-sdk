# Class built for storing JsonExecutionResult information

package GetDeploy::ExecutionResult::JsonExecutionResult;

sub new {
	my $class = shift;
	my $self = {
		_blockHash => shift,
		_result => shift, # ExecutionResult object
	};
	bless $self, $class;
	return $self;
}