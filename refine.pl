#!/usr/bin/perl -w

# $Id: refine.pl,v 1.1 2015/01/21 14:36:34 rmon Exp $

use strict;

use Sort::Versions;

#use Data::Dumper;

my %map = ();

while(<STDIN>) {
	chomp;
	if(/^(.+)-([^-]+)\.txz$/) {
		my $id = $1;
		my $tag = $2;
		if(!defined($map{$id})) {
			$map{$id} = [ $tag ];
		} else {
			push(@{$map{$id}}, $tag);
		}
	}
}

my @l = keys(%map);
foreach my $i (@l) {
	my $n = scalar(@{$map{$i}});
	if($n > 1) {
		my @tags = sort { versioncmp($b, $a) } @{$map{$i}};
		shift(@tags);
		foreach my $j (@tags) {
			print $i, '-', $j, '.txz', "\n";
		}
	}
}
