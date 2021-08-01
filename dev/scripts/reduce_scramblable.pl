#!/bin/perl


## A little service function to Remove Similar Scramblable Siteswaps and sort throws
## On V, M, MS, S families
sub __fix_reduce_ss_scramblable
{   
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
    
    my $filename = $_[0];
    open(my $fh, '<:encoding(UTF-8)', $filename)
	or die "Could not open file '$filename' $!";
    
    my @res = ();
    my $isSync = -1;
    
    while (my $ss = <$fh>) {
	chomp $ss;
	$ss =~ s/\*//g;
	$ss =~ s/\s+//g;   #Remove white
	my @res_in = ();

	if($ss eq ''  || $ss =~ /^==/ )
	{	    
	    next;
	}
	if(&isValid($ss,-1) < 0)
	{
	    print "Invalid :".$ss."\n";
	    next;
	}
	
	for(my $i=0; $i < length($ss); $i++)
	{
	    
	    if(substr($ss,$i,1) eq '[')
	    {
		my @v = ();
		$i++;
		while(substr($ss,$i,1) ne ']')
		{
		    if($i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		    {
			push(@v,substr($ss,$i,1).'X');
			$i++;
		    }
		    else
		    {
			push(@v,substr($ss,$i,1));
		    }
		    $i++;
		}
		push(@res_in, join('',sort __hex_split_compare_single (@v)));
		
	    }
	    elsif(substr($ss,$i,1) eq '(' || substr($ss,$i,1) eq ')' || substr($ss,$i,1) eq ',')
	    {
		$isSync = 1;
	    }
	    else
	    {
		if($i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		{
		    push(@res_in,substr($ss,$i,1).'X');
		    $i++;
		}
		else
		{
		    push(@res_in,substr($ss,$i,1));
		}
	    }
	}

	@res_in = sort { &__hex_split($a) <=> &__hex_split($b) } @res_in;
	
	my $ss_final = '';

	if($isSync == -1)
	{
	    for(my $i=0;$i < scalar @res_in;$i++)
	    {
		if(length($res_in[$i]) < 2 || (length($res_in[$i]) == 2 && uc(substr($res_in[$i],1,1)) eq 'X'))
		{
		    $ss_final .= $res_in[$i];
		}
		else
		{
		    $ss_final .= '['.$res_in[$i].']';
		}		 
	    }
	}
	else
	{
	    for(my $i=0;$i < scalar @res_in;$i+=2)
	    {
		my $v1 = '';
		my $v2 = '';
		if(length($res_in[$i]) < 2 || (length($res_in[$i]) == 2 && uc(substr($res_in[$i],1,1)) eq 'X'))
		{
		    $v1 = $res_in[$i];
		}
		else
		{
		    $v1 = '['.$res_in[$i].']';
		}		 
		if(length($res_in[$i+1]) < 2 || (length($res_in[$i+1]) == 2 && uc(substr($res_in[$i+1],1,1)) eq 'X'))
		{
		    $v2 = $res_in[$i+1];
		}
		else
		{
		    $v2 = '['.$res_in[$i+1].']';
		}
		
		$ss_final .= '('.$v1.','.$v2.')';
	    }
	}

	push(@res, lc($ss_final));
    }

    close($fh);

    @res = sort @res;
    @res = uniq(@res);

    if(scalar @_ > 1)
    {	    
	open(FH, '>', $_[1]) or die $!;
    }

    for(my $i = 0; $i < scalar @res; $i++)
    {
	if(&getSSstatus($res[$i],-1) ne 'GROUND')
	{	    
	    if(scalar @_ > 1)
	    {
		print FH '* '.$res[$i].' *'."\n";
	    }
	    else
	    {
		print colored [$common::COLOR_RESULT], '* '.$res[$i].' *'."\n";
	    }
	}
	else
	{
	    if(scalar @_ > 1)
	    {
		print FH $res[$i]."\n";
	    }	    
	    else
	    {
		print colored [$common::COLOR_RESULT], $res[$i]."\n";	
	    }
	}
    }
    

    print "\n".'[ => '.scalar(@res).' Siteswap(s) ]'."\n\n";
    if(scalar @_ > 1)
    {
	print FH "\n".'[ => '.scalar(@res).' Siteswap(s) ]'."\n";
	close(FH)
    }	
}


sub __fix_reduce_ss_scramblable_dir
{

    my $directory = $_[0];
    my @dir_list = ();
    opendir (DIR, $directory) or die $!;
    while (my $file = readdir(DIR)) {
	# Use a regular expression to ignore files beginning with a period
        next if ($file =~ m/^\./);
	push @dir_list, $file;
    }
    closedir(DIR); 

    for (my $i=0; $i < scalar @dir_list; $i++)
    {
	my $file = $dir_list[$i];
	print "==> $file\n";
	my $fres = $file;
	$fres =~ s/\.txt/-reduced\.txt/;
	$fres = $directory.'/'.$fres;
	&__fix_reduce_ss_scramblable($directory.'/'.$file,$fres);
    }

}


&__fix_reduce_scramblable_dir($ARGV[0]);
