#!/bin/perl


## A little service function to concat Scramblable Siteswaps for ex 

my $f_src=$ARGV[0]; # ex: "ScramblableSSFromJL-S";
my $f_dst=$f_src.'_any';

for (my $i = 2; $i < 16; $i++)
{
    for (my $j = 2; $j < 16; $j+=2)
    {
	open ( fileout, ">>", $f_dst."_".$j.".txt" ) 
	    or die "Could not open file ".$f_dst."_".$j.".txt : $!";

	open ( filein, "<", $f_src."_".$i."_".$j.".txt" ) or
	    print "Could not open file ".$f_src."_".$i."_".$j.".txt : $!\n";
	
	while ( my $line = <filein> ) {
  	    $line =~ s/\*//g;
	    print fileout $line;
	}

	print fileout "\n\n";
    }
}
