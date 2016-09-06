#!/usr/bin/perl -w

# $Id: expand.pl,v 1.1 2012/11/27 11:58:11 rmon Exp $

use strict;

my $dsc = "\n";
#my $dsc = "\0";

foreach my $i (@ARGV) {
	if($i =~ /^@(.*)/) {
		my $id = $1;
		$id .= '.cf' if($id !~ /\.cf$/);
		cf($id);
	} else {
		print $i, $dsc;
	}
}

sub cf {
	my $fn = shift;
	open(my $is, '<', $fn) or die $!;
	while(<$is>) {
		chomp;
		next if /^#/;
		next if /^$/;
		print $_ , $dsc;
	}
	close($is);
}
