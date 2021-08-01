#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## purify-lang.pl   -  purify scripts for checking lang.pm in jugglingTB    ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015  Frederic Roudaut  <frederic.roudaut@free.fr>         ##
##                                                                          ##
##                                                                          ##
## This program is free software; you can redistribute it and/or modify it  ##
## under the terms of the GNU General Public License version 2 as           ##
## published by the Free Software Foundation; version 2.                    ##
##                                                                          ##
## This program is distributed in the hope that it will be useful, but      ##
## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
## General Public License for more details.                                 ##
##                                                                          ##
##############################################################################

use strict;
use warnings;
use File::Grep qw( fgrep fmap fdo );

#goto STEP2;

 STEP1:print "=== STEP 1 : Check that all Variables in Lang.pm are defined in French and English ===\n";
open FILE,"< ../lang.pm" or die "E/S : $!\n";
my %dict=();
my $mod = "";
while (my $line = <FILE>){
    if($line =~ "FRENCH")
    {
	$mod = "F";
    }
    elsif($line =~ "ENGLISH")
    {
	$mod = "E";
    }
    else
    {
	my $key = "";

	if($line =~ "our")
	{
	    my $left=index($line,'$');
	    my $right=index($line,'=');
	    $key = substr($line,$left+1,$right-$left-1);
	    $key =~ s/\s+//g;
	    
	    if($mod eq "F")
	    {
		if(exists($dict{$key}))
		{
		    print "PURIFY - $key defined several times in French.\n";
		    $dict{$key} ++;
		}
		else
		{
		    $dict{$key} = 1;
		}
	    }
	    elsif($mod eq "E")
	    {
		if(exists($dict{$key}))
		{
		    delete $dict{$key};
		}
		else
		{
		    print "PURIFY - $key not defined in French.\n";
		}
	    }	    
	} 
    }
}

foreach my $key (keys(%dict))
{
    print "PURIFY - $key not defined in English.\n";
}


print "\n\n";
STEP2: print "=== STEP 2 : Check that all Variables in Lang.pm are used ===\n";
open FILE,"< ../lang.pm" or die "E/S : $!\n";
while (my $line = <FILE>){
    my $found = -1;
    my $v = "";

    if($line =~ "our")
    {
	my $left=index($line,'$');
	my $right=index($line,'=');
	$v = substr($line,$left+1,$right-$left-1);
	$v =~ s/\s+//g;

	if ( fgrep { /$v/ } glob "../jugglingTB.pl ../modules/*" ) 
	{
	    $found = 1;	    
	}
    }
    if ($v ne "" && $found == -1)
    {
	print "PURIFY - Not Found : $v\n"; 
    }
    
}
close FILE;

print "\n\n";
STEP3:print "=== STEP 3 : Check that all Variables are defined in Lang.pm ===\n";
foreach my $file (glob "../jugglingTB.pl ../modules/*")
{
    print "=> File : $file\n";
    open FILE,"< $file" or die "E/S : $!\n";
    while (my $line = <FILE>){
	my $v = "";
	my $found = -1;

	if($line =~ '\$lang::')
	{
	    my $newline=$line;

	    while(index($newline,'$lang::') != -1)
	    {
		my $left=index($newline,'$lang::');
		my $right=-1;
		$v = substr($newline,$left+7);
		for (my $i=0; $i< length $v; $i++)
		{
		    if(substr($v,$i,1) eq " " || substr($v,$i,1) eq "." || substr($v,$i,1) eq "\$" || substr($v,$i,1) eq "<" || substr($v,$i,1) eq ";" 
		       || substr($v,$i,1) eq "," || substr($v,$i,1) eq "\"" || substr($v,$i,1) eq "\'" || substr($v,$i,1) eq "\\" || substr($v,$i,1) eq ")"
		       || substr($v,$i,1) eq "]" )
		    {
			$right = $i;
			last;
		    }
		}		
		if ($right == -1)
		{
		    print "\t"."Cannot detect end in : $v\n";    
		    $newline = "";
		}
		else
		{
		    $newline = substr($newline,$left+7+$right);
		    $v = substr($v,0,$right);
		    $v =~ s/\s+//g;
		    
		    if ( !fgrep { /$v/ } glob "../lang.pm" ) 
		    {
			print "PURIFY - Not Found ".$v."\n";
		    }
		}
	    }
	    
	}
    }
    close FILE;
}
