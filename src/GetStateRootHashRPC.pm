#!/usr/bin/perl

package GetStateRootHashRPC


sub new {
	print "GetStateRootHashRPC called";
	my $class = shift;
	my $self = {};
	bless $self, $class;
	return $self;
}

sub getStateRootHash {
	
}