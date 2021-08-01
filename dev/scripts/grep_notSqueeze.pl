#!/bin/perl



open ( filein, "<",  $ARGV[0] ) 
    or die "Could not open file $ARGV[0]";

open ( fileout, ">>", $ARGV[1] ) 
    or die "Could not open file for writing $ARGV[1]";
	
while ( my $line = <filein> ) {
    if($line !~ m/[Squeeze]]/)
    {  
	print fileout $line;
    }
}
