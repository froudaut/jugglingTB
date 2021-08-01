#!/bin/perl


## A little service function to Remove Equivalent Symetric Sync SS 
sub __hex_split {
    my $v = uc($_[0]);
    $v =~ s/X//;
    return hex($v);
}

sub __hex_split_compare_single {
    my $an = &__hex_split($a);
    my $bn = &__hex_split($b);

    if($an < $bn) {
	return -1;
    }
    elsif ($an == $bn) {
	if (uc($a) =~ m/X/ && uc($b) !~ m/X/)
	{
	    return 1;
	}
	else
	{
	    return 0;
	}
	
    }
    else {
	return 1;
    }	
}

sub __norm_ss_mult {

    my $vm = '';
    my $ss = $_[0];
    for(my $i=0; $i < length($ss); $i++)
    {
	if(substr($ss,$i,1) eq '[')
	{
	    $i++;
	    $v = '';
	    @v_l = ();
	    while($i < length($ss) && substr($ss,$i,1) ne ']')
	    {
		if($i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		{
		    push(@v_l, substr($ss,$i,1).'X');
		    $i+=2;
		}
		else
		{
		    push(@v_l, substr($ss,$i,1));
		    $i++;
		}			 
	    }
	    
	    $v = join('',sort __hex_split_compare_single (@v_l));		
	    $vm .= '['.$v.']';
	}
	
	elsif(substr($ss,$i,1) ne ']')
	{
	    $vm .= substr($ss,$i,1);
	}
    }
    
    $ss = $vm;
    return $ss;
    
}



sub __fix_reduce_symetrix_S
{

    my $filename = $_[0];
    $filename =~ s/\.txt//g;
    my @list_ss = ();
    my @list_prfix = ();

    open(my $fhout, '>:encoding(UTF-8)', $filename.'-reduced.txt')
    	or die "Could not open file $filename-reduced.txt $!";
    
    #If a Fill is defined as 2nd parameter, this is an input list
    if(scalar @_ > 1)
    {
	open(my $fhin, '<:encoding(UTF-8)', $_[1])
	or die "Could not open file $_[1] $!";
	while (my $ss = <$fhin>) {
	    chomp $ss;
	    $ss =~ s/\s+//g;
	    $ss =~ s/\*//g;
	    push @list_ss, $ss;
	    print $fhout $ss."\n";
	}

	close($fhin);
    }
	
    
    open(my $fh, '<:encoding(UTF-8)', $filename.'.txt')
	or die "Could not open file $filename.txt $!";

    while (my $ss = <$fh>) {
	chomp $ss;
	$ss =~ s/\s+//g;
	$ss =~ s/\*//g;
	my $new_ss_reorder = '';
	my $cpt = 0;
	my $insync = -1;
	my $v_r = '';
	my $v_l = '';

	if($ss eq '')
	{
	    next;
	}
	for(my $i = 0; $i < length($ss); $i++)
	{	    
	    if(substr($ss,$i,1) eq '!' || substr($ss,$i,1) eq '*') 
	    {
		if($insync eq '-1')
		{
		    $new_ss_reorder .= substr($ss,$i,1);
		}
	    }
	    elsif(substr($ss,$i,1) eq '(')
	    {
		$insync = 'R';
	    }	    	    
	    elsif(substr($ss,$i,1) eq ',')
	    {
		$insync = 'L';
	    }
	    elsif(substr($ss,$i,1) eq ')')
	    {
		$insync = '-1';
		$new_ss_reorder .= '('.$v_r.','.$v_l.')';
		$cpt++;
		$v_l = '';
		$v_r = '';
	    }
	    else
	    {
		if($insync eq 'R')
		{
		    $v_l .= substr($ss,$i,1);
		}
		elsif($insync eq 'L')
		{
		    $v_r .= substr($ss,$i,1);
		}		    
	    }	    
	}

	$new_ss_reorder = &__norm_ss_mult($new_ss_reorder);
	my $found = -1;
	for(my $i = 0; $i < scalar(@list_ss); $i++)
	{
	    my $rec_ss_norm = &__norm_ss_mult($list_ss[$i]);
	    if($new_ss_reorder eq $rec_ss_norm)
	    {
		$found = 1;
		last;
	    }
	}

	if($found == -1)
	{
	    push @list_ss, $ss;
	    print $fhout $ss."\n";
	    #print "==> KEEP ".$ss."\n";
	}
	else
	{
	    print "==> DUPLICATE ".$ss."\n";
	}
    }

    print $fhout "\n[ => ".(scalar @list_ss)." Siteswap(s)]\n";
    close($fh);
    close($fhout);

}


#input = "ReversibleSSFromJL-S" #for example
#my $f_in=$ARGV[0];

$f_in="ReversibleSSFromJL-MS";
#&__fix_reduce_symetrix_S($f_in.'_11_4_2.txt',$f_in.'_11_4_2-reduced-tmp.txt');

for(my $i=0; $i<=15; $i++) {
    for(my $j=0; $j<=15; $j++) {
	eval {
	    print "===== ".$f_in.'_'.$i.'_'.$j.'_2.txt'." =====\n";
	    &__fix_reduce_symetrix_S($f_in.'_'.$i.'_'.$j.'_2.txt');
	}
    }
}
