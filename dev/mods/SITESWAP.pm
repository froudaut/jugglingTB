#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## SITESWAP.pm   - Perl Implementation of the Siteswap juggling Notation    ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2010 - 2012  Frederic Roudaut  <frederic.roudaut@free.fr>  ##
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

package SITESWAP;
use common;
use lang;
use strict;
use Cwd;
use Term::ANSIColor;    
use modules::SITESWAP_GRAMMAR;    


$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

our $SITESWAP_INFO = "SITESWAP juggling Notation";
our $SITESWAP_HELP = $lang::MSG_SITESWAP_MENU_HELP;
our $SITESWAP_VERSION = "v0.7.8";


our %SITESWAP_CMDS = 
    (    
	 'anim'                  => ["$lang::MSG_SSWAP_MENU_ANIMATE_1","$lang::MSG_SSWAP_MENU_ANIMATE_2"], 
	 'draw'                  => ["$lang::MSG_SSWAP_MENU_DRAW_1", "$lang::MSG_SSWAP_MENU_DRAW_2"],
	 'drawStates'            => ["$lang::MSG_SSWAP_MENU_DRAWSTATES_1","$lang::MSG_SSWAP_MENU_DRAWSTATES_2"."\n\n"."$lang::MSG_SSWAP_MENU_DRAWSTATES_OPT"], 	     
	 'drawStatesAggr'        => ["$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_1","$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_2"."\n\n"."$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_OPT"],  
	 'jugglingLab'           => ["$lang::MSG_SSWAP_MENU_JUGGLINGLAB_1","$lang::MSG_SSWAP_MENU_JUGGLINGLAB_2"], 			 
	 'genSS'                 => ["$lang::MSG_SSWAP_MENU_GENSITESWAP_1","$lang::MSG_SSWAP_MENU_GENSITESWAP_2"."\n\n"."$lang::MSG_SSWAP_MENU_GENSITESWAP_OPT"],   
	 'genStates'             => ["$lang::MSG_SSWAP_MENU_GENSTATES_1","$lang::MSG_SSWAP_MENU_GENSTATES_2"], 			 
	 'genStatesAggr'         => ["$lang::MSG_SSWAP_MENU_GENAGGRSTATES_1","$lang::MSG_SSWAP_MENU_GENAGGRSTATES_2"],
	 'genDiagProbert'        => ["$lang::MSG_SSWAP_MENU_GENPROBERTDIAG_1","$lang::MSG_SSWAP_MENU_GENPROBERTDIAG_2"],
	 'genSSPerm'             => ["$lang::MSG_SSWAP_MENU_GENPERMSS_1","$lang::MSG_SSWAP_MENU_GENPERMSS_2"], 	
	 'genSSProbert'          => ["$lang::MSG_SSWAP_MENU_GENPROBERTSS_1","$lang::MSG_SSWAP_MENU_GENPROBERTSS_2"], 	
	 'genSSMagic'            => ["$lang::MSG_SSWAP_MENU_GENMAGICSS_1","$lang::MSG_SSWAP_MENU_GENMAGICSS_2"], 	
	 'genSSMagicStadler'     => ["$lang::MSG_SSWAP_MENU_GENMAGICSTADLERSS_1","$lang::MSG_SSWAP_MENU_GENMAGICSTADLERSS_2"], 	
	 'genScramblable'        => ["$lang::MSG_SSWAP_MENU_GENSCRAMBLABLESS_1","$lang::MSG_SSWAP_MENU_GENSCRAMBLABLESS_2"], 	
	 'isEquivalent'          => ["$lang::MSG_SSWAP_MENU_ISEQUIVALENT_1","$lang::MSG_SSWAP_MENU_ISEQUIVALENT_2"], 	
	 'isSyntaxValid'         => ["$lang::MSG_SSWAP_MENU_ISSYNTAXVALID_1","$lang::MSG_SSWAP_MENU_ISSYNTAXVALID_2"], 			 	
	 'isValid'               => ["$lang::MSG_SSWAP_MENU_ISVALID_1","$lang::MSG_SSWAP_MENU_ISVALID_2"], 
	 'inv'                   => ["$lang::MSG_SSWAP_MENU_INV_1","$lang::MSG_SSWAP_MENU_INV_2"], 
	 'expand'                => ["$lang::MSG_SSWAP_MENU_EXPAND_1","$lang::MSG_SSWAP_MENU_EXPAND_2"],   
	 'periodMin'             => ["$lang::MSG_SSWAP_MENU_PERIODMIN_1","$lang::MSG_SSWAP_MENU_PERIODMIN_2"],   
	 'shrink'                => ["$lang::MSG_SSWAP_MENU_SHRINK_1","$lang::MSG_SSWAP_MENU_SHRINK_2"],   
	 'normalize'             => ["$lang::MSG_SSWAP_MENU_NORMALIZE_1","$lang::MSG_SSWAP_MENU_NORMALIZE_2"],   
	 'getInfo'               => ["$lang::MSG_SSWAP_MENU_GETINFO_1","$lang::MSG_SSWAP_MENU_GETINFO_2"],   
	 'getObjNumber'          => ["$lang::MSG_SSWAP_MENU_GETNUMBER_1","$lang::MSG_SSWAP_MENU_GETNUMBER_2"],   
	 'getPeriod'             => ["$lang::MSG_SSWAP_MENU_GETPERIOD_1","$lang::MSG_SSWAP_MENU_GETPERIOD_2"],   
	 'getSSstatus'           => ["$lang::MSG_SSWAP_MENU_GETSSSTATUS_1","$lang::MSG_SSWAP_MENU_GETSSSTATUS_2"],   
	 'getSSType'             => ["$lang::MSG_SSWAP_MENU_GETSSTYPE_1","$lang::MSG_SSWAP_MENU_GETSSTYPE_2"],   
	 'writeStates_xls'       => ["$lang::MSG_SSWAP_MENU_WRITESTATES_1","$lang::MSG_SSWAP_MENU_WRITESTATES_2"],
	 'printSSList'           => ["$lang::MSG_SSWAP_MENU_PRINTSSLIST_1","$lang::MSG_SSWAP_MENU_PRINTSSLIST_2"],
    );

print "SITESWAP $SITESWAP::SITESWAP_VERSION loaded\n";

# To add debug behaviour 
our $SITESWAP_DEBUG=-1;

# Parameters for Excel writing
# It supports Excel 2007 with 1,048,576 rows x 16,384 columns.
my $EXCEL_MAX_COLS = 16000;	# Max columns
my $EXCEL_MAX_ROWS = 16000;	# Max rows
my $EXCEL_COL_START = 2;	# column pad for writing
my $EXCEL_ROW_START = 8;	# raw pad for writing

# When used in JugglingLab
my $balls_colors="{red}{green}{blue}{yellow}{magenta}{gray}{pink}{black}{cyan}{orange}";

sub sort_num { return $a <=> $b }

sub isSyntaxValid
{
    # res is the number of errors found during the parsing   
    # or -1 if a lexical error is found
    my $res= SITESWAP_GRAMMAR::parse($_[0]);     
    
    if ($res!=0) {
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    } else {
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return 0;
    }
}


sub isEquivalent
{
    if (&isValid($_[0],-1) < 0) {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[0]."\n";
	}
	return -1;
    }

    if (&isValid($_[1],-1) < 0) {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[1]."\n";
	}
	return -1;
    }

    my $src0=&normalize($_[0],-1);
    my $src1=&normalize($_[1],-1);

    my $src0_type=&getSSType($src0,-1);
    my $src1_type=&getSSType($src1,-1);

    if ($src0_type ne $src1_type) {
	# SS Families does not match
	if (scalar @_ != 3 || $_[2] != -1) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    if (length($src0) != length($src1)) {	
	if (scalar @_ != 3 || $_[2] != -1) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    if ($src0_type eq "R") {
	for (my $i=0; $i < length($src0); $i ++) {
	    if ($src0 eq $src1) {
		if (scalar @_ != 3 || $_[2] != -1) {
		    print colored [$common::COLOR_RESULT], "True\n";
		}
		return 1;
	    }
	    my $nsrc0 = substr($src0,1).substr($src0,0,1);
	    $src0 = $nsrc0;
	}
    } elsif ($src0_type eq "M") {		
	for (my $i=0; $i < length($src0); $i ++) {
	    if ($src0 eq $src1) {
		if (scalar @_ != 3 || $_[2] != -1) {
		    print colored [$common::COLOR_RESULT], "True\n";
		}
		return 1;
	    }
	    
	    if (substr($src0,0,1) eq "[") {
		for (my $j=0; $j < length ($src0); $j++) {
		    my $nsrc0 = substr($src0,1).substr($src0,0,1);
		    $src0=$nsrc0;
		    $i+=$j;
		    if (substr($src0,0,1) eq "]") {
			$src0 = substr($src0,1)."]";
			last;
		    }
		}
	    } else {
		my $nsrc0 = substr($src0,1).substr($src0,0,1);
		$src0 = $nsrc0;
	    }
	    
	}
    } elsif ($src0_type eq "S" || $src0_type eq "MS") {	
	for (my $i=0; $i < length($src0) ; $i ++) {
	    if ($src0 eq $src1) {
		if (scalar @_ != 3 || $_[2] != -1) {
		    print colored [$common::COLOR_RESULT], "True\n";
		}
		return 1;
	    }
	    
	    for (my $j=0; $j < length ($src0); $j++) {
		my $nsrc0 = substr($src0,1).substr($src0,0,1);
		$src0=$nsrc0;
		$i+=$j;
		if (substr($src0,0,1) eq ")") {
		    $src0 = substr($src0,1).")";
		    if ($src0 eq $src1) {
			if (scalar @_ != 3 || $_[2] != -1) {
			    print colored [$common::COLOR_RESULT], "True\n";
			}
			return 1;
		    }
		    last;
		}
	    }	 
	    
	}
    }       

    if (scalar @_ != 3 || $_[2] != -1) {
	print colored [$common::COLOR_RESULT], "False\n";
    }
    return -1;
}




sub inv
{
    
    if (&isValid($_[0],-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }

    my $src = &expand($_[0],-1);    
    my $mod= &getSSType($_[0],-1);
    if ($mod eq "M" || $mod eq "R") {
	my $inv_src = reverse $src;
	my @res=();
	for (my $i=0; $i < length($inv_src); $i++) {
	    if (substr($inv_src,$i,1) eq ']') {
		my $j =$i+1;
		my $mult ="";
		while (substr($inv_src,$j,1) ne '[' && $j < length ($inv_src)) {
		    $mult = $mult.substr($inv_src,$j,1);
		    $j ++;
		}
		
		$i = $j;
		#push(@res,"[".$mult."]");
		push(@res,$mult);
	    } else {
		push(@res,(substr($inv_src,$i,1)));
	    }		 		 
	}

	my @resf=();
	for (my $i=0; $i < scalar @res; $i++) {
	    for (my $j = 0; $j < length($res[$i]); $j++) {
		my $v = hex(substr($res[$i],$j,1));
		if (($resf[($i - $v)%(scalar @res)]) != "") {
		    $resf[($i - $v)%(scalar @res)]=($resf[($i - $v)%(scalar @res)]).sprintf("%x",$v);  		
		} else {
		    $resf[($i - $v)%(scalar @res)]=sprintf("%x",$v);  		
		}
	    }
	}

	for (my $i=0; $i < scalar @resf; $i++) {
	    if (length($resf[($i)]) > 1) {
		$resf[($i)] = '['.$resf[($i)].']';
	    }
	}

	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], &shrink(join('',@resf),-1)."\n";
	}

	return &shrink(join('',@resf),-1);
    }

    # Working Alternative for Asynchronous SS without multiplexes
    # ===========================================================
    # elsif($mod eq "R")
    # {
    # 	my $inv_src = reverse $src;
    # 	my @res=();
    # 	for(my $i=0; $i < length($inv_src); $i++)
    # 	{
    # 	    my $v = hex(substr($inv_src,$i,1));
    # 	    $res[($i - $v)%length($inv_src)]=sprintf("%x",$v);
    # 	}
    
    # 	if(scalar @_ == 1 || $_[1] != -1)
    # 	{
    # 	    print colored [$common::COLOR_RESULT], &shrink(join('',@res),-1)."\n";
    # 	}

    # 	return &shrink(join('',@res),-1);
    # }
    
    elsif ($mod eq "MS" || $mod eq "SM" || $mod eq "S") {
	my @res=();
	my @resf = ();
	my $cpt = 0;
	for (my $i=0; $i < length($src); $i++) {
	    my $val = substr($src,$i,1);
	    if ( $val ne '(' && $val ne ')' && $val ne ',' ) {
		if ($val ne '[' && $val ne ']') {
		    if (($i+1) < length($src) && substr($src,$i+1,1) eq "X") {
			$res[$cpt] = $val."X";
			$i ++;
		    } else {
			$res[$cpt] = $val;
		    }
		    $cpt ++;		    
		} elsif ($val eq '[') {
		    my $j = $i +1;
		    my $mult = '';
		    while (substr($src,$j,1) ne ']' && $j < length($src)) {
			$mult=$mult.substr($src,$j,1); 
			$j++;			
		    }
		    if (substr($src,$j,1) eq ']') {			
			$i = $j;
			$res[$cpt] = $mult; 
			$cpt ++;
		    }

		}
	    }
	}
	
	my @res2=reverse @res;
	
	for (my $i=0; $i < scalar @res2; $i++) {
	    my $v = hex($res2[$i]);	    
	    if (length ($res2[$i]) == 1) {
		if (($resf[($i - $v)%(scalar @res2)]) != "") {
		    $resf[($i - $v)%(scalar @res2)]=($resf[($i - $v)%(scalar @res2)]).sprintf("%x",$v);  		
		} else {
		    $resf[($i - $v)%(scalar @res2)]=sprintf("%x",$v);  		
		}	    
	    } elsif (length ($res2[$i]) == 2 && uc(substr($v,1,1)) eq "X") {
		$v = hex(substr($res2[$i],0,1));	    
		if ($i%2 == 0) {
		    if (($resf[($i - $v +1)%(scalar @res2)]) != "") {
			$resf[($i - $v +1)%(scalar @res2)]=($resf[($i - $v +1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
		    } else {
			$resf[($i - $v +1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
		    }	    
		} else {
		    if (($resf[($i - $v -1)%(scalar @res2)]) != "") {
			$resf[($i - $v -1)%(scalar @res2)]=($resf[($i - $v -1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
		    } else {
			$resf[($i - $v -1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
		    }	    
		}	
		$i++;
	    } else {
		for (my $j=0; $j < length($res2[$i]); $j ++) {		    
		    if ($j == (length($res2[$i]) -1) || ($j < (length($res2[$i]) -1) &&  uc(substr($res2[$i],$j+1,1)) ne "X")) {
			my $v = hex(substr($res2[$i],$j,1));
			if (($resf[($i - $v)%(scalar @res2)]) != "") {			    
			    $resf[($i - $v)%(scalar @res2)]=($resf[($i - $v)%(scalar @res2)]).sprintf("%x",$v);  		
			} else {
			    $resf[($i - $v)%(scalar @res2)]=sprintf("%x",$v);  		
			}	    
		    } else {
			$v = hex(substr($res2[$i],$j,1));		
			if ($i%2 == 0) {
			    if (($resf[($i - $v +1)%(scalar @res2)]) != "") {				
				$resf[($i - $v +1)%(scalar @res2)]=($resf[($i - $v +1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
			    } else {
				$resf[($i - $v +1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
			    }	    
			} else {
			    if (($resf[($i - $v -1)%(scalar @res2)]) != "") {
				$resf[($i - $v -1)%(scalar @res2)]=($resf[($i - $v -1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
			    } else {
				$resf[($i - $v -1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
			    }	    
			}
			$j++;
		    }						    		    
		    
		}		
	    }
	}

	my $resfs ="";
	for (my $i=0; $i < scalar @resf; $i++) {	    
	    my $v = uc($resf[$i]);
	    $v =~ s/X//g; 
	    if ($i%2==0) {
		if (length($v) > 1) {
		    $resfs = $resfs."([".$resf[$i]."]";
		} else {
		    $resfs = $resfs."(".$resf[$i];
		}
	    } else {
		if (length($v) > 1) {
		    $resfs = $resfs.",[".$resf[$i]."])";
		} else {
		    $resfs = $resfs.",".$resf[$i].")";
		}
	    }
	}

	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], &shrink($resfs,-1)."\n";
	}

	return &shrink($resfs,-1);	
    }

    # Working Alternative for Synchronous SS without multiplexes
    # ===========================================================
    # elsif($mod eq "S")
    # {
    # 	my @res=();
    # 	my @resf = ();
    # 	my $cpt = 0;
    # 	for(my $i=0; $i < length($src); $i++)
    # 	{
    # 	    my $val = substr($src,$i,1);
    # 	    if( $val ne '(' && $val ne ')' && $val ne ',' )
    # 	    {
    # 		if (($i+1) < length($src) && substr($src,$i+1,1) eq "X")
    # 		{
    # 		    $res[$cpt] = $val."X";
    # 		    $i ++;
    # 		}
    # 		else
    # 		{
    # 		    $res[$cpt] = $val;
    # 		}
    # 		$cpt ++;
    # 	    }
    # 	}

    # 	my @res2=reverse @res;

    # 	for (my $i=0; $i < scalar @res2; $i++)
    # 	{
    # 	    my $v = hex($res2[$i]);	    
    # 	    if(length ($res2[$i]) == 1)
    # 	    {
    # 		if(($resf[($i - $v)%(scalar @res2)]) != "")
    # 		{
    # 		    $resf[($i - $v)%(scalar @res2)]=($resf[($i - $v)%(scalar @res2)]).sprintf("%x",$v);  		
    # 		}
    # 		else
    # 		{
    # 		    $resf[($i - $v)%(scalar @res2)]=sprintf("%x",$v);  		
    # 		}	    
    # 	    }
    # 	    else
    # 	    {
    # 		$v = hex(substr($res2[$i],0,1));	    
    # 		if($i%2 == 0)
    # 		{
    # 		    if(($resf[($i - $v +1)%(scalar @res2)]) != "")
    # 		    {
    # 			$resf[($i - $v +1)%(scalar @res2)]=($resf[($i - $v +1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
    # 		    }
    # 		    else
    # 		    {
    # 			$resf[($i - $v +1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
    # 		    }	    
    # 		}
    # 		else
    # 		{
    # 		    if(($resf[($i - $v -1)%(scalar @res2)]) != "")
    # 		    {
    # 			$resf[($i - $v -1)%(scalar @res2)]=($resf[($i - $v -1)%(scalar @res2)]).sprintf("%x",$v)."X";  		
    # 		    }
    # 		    else
    # 		    {
    # 			$resf[($i - $v -1)%(scalar @res2)]=sprintf("%x",$v)."X";  		
    # 		    }	    
    # 		}
    
    # 	    }
    # 	}

    # 	my $resfs ="";
    # 	for(my $i=0; $i < scalar @resf; $i++)
    # 	{
    # 	    if($i%2==0)
    # 	    {
    # 		$resfs = $resfs."(".$resf[$i];
    # 	    }	    
    # 	    else
    # 	    {
    # 		$resfs = $resfs.",".$resf[$i].")";
    # 	    }
    # 	}

    # 	if(scalar @_ == 1 || $_[1] != -1)
    # 	{
    # 	    print colored [$common::COLOR_RESULT], $resfs."\n";
    # 	}

    # 	return &shrink($resfs,-1);
    # }


    return -1;
}


sub getObjNumber
{
    my $ss=&expand($_[0],-1);
    if (&isValid($ss,-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }

    my $mod=&getSSType($_[0],-1);
    if ($mod eq "R") 
    {	
	my $v=0;
	my $cpt=0;
	for (my $i=0; $i < length($ss); $i++)
	{
	    $v+=hex(substr($ss,$i,1));
	    $cpt++;	    
	}
	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], ($v/$cpt)."\n";
	}
	
	return ($v/$cpt);
    }

    elsif($mod eq "M")
    {
	my $v=0;
	my $cpt=0;
	my $inc = 1;
	for (my $i=0; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$cpt ++;
		$inc = -1;
	    }
	    elsif(substr($ss,$i,1) eq ']')
	    {
		$inc = 1;
	    }
	    else
	    {
		$v+=hex(substr($ss,$i,1));
		if($inc != -1)
		{
		    $cpt++;	    
		}
	    }
	}
	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], ($v/$cpt)."\n";
	}
	
	return ($v/$cpt);
    }

    elsif($mod eq "S")
    {
	my $v=0;
	my $cpt=0;
	my $inc = 1;
	for (my $i=0; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '(')
	    {
		$cpt ++;		
	    }
	    elsif(substr($ss,$i,1) eq ',')
	    {
		$cpt ++;
	    }
	    elsif(substr($ss,$i,1) eq ')' || substr($ss,$i,1) eq 'X')
	    {
 		# Nothing to do
	    }
	    else
	    {
		$v+=hex(substr($ss,$i,1));		
	    }
	}
	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], ($v/$cpt)."\n";
	}
	
	return ($v/$cpt);
    }

    elsif($mod eq "MS" || $mod eq "SM")
    {
	my $v=0;
	my $cpt=0;
	my $inc = 1;
	for (my $i=0; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '(')
	    {
		$cpt ++;		
	    }
	    elsif(substr($ss,$i,1) eq ',')
	    {
		$cpt ++;
	    }
	    elsif(substr($ss,$i,1) eq ')' || substr($ss,$i,1) eq 'X' || substr($ss,$i,1) eq '[' || substr($ss,$i,1) eq ']')
	    {
 		# Nothing to do
	    }
	    else
	    {
		$v+=hex(substr($ss,$i,1));		
	    }
	}
	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], ($v/$cpt)."\n";
	}
	
	return ($v/$cpt);
    }
}

sub getSSstatus
{
    my $ss=&expand($_[0],-1);
    if (&isValid($ss,-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }

    my $mod=&getSSType($_[0],-1);
    if ($mod eq "R" || $mod eq "M") 
    {	
	my $nbObjects=&getObjNumber($ss,-1);
	if($nbObjects > 15)
	{
	    if (scalar @_ == 1 || $_[1] != -1) {
		print colored [$common::COLOR_RESULT], "UNKNOWN\n";
	    }
	    return "UNKNOWN";
	}
	elsif(&isValid(sprintf("%x",$nbObjects).$ss,-1)==1)
	{
	    if (scalar @_ == 1 || $_[1] != -1) {
		print colored [$common::COLOR_RESULT], "GROUND\n";
	    }
	    return "GROUND";
	}
	else
	{
	    if (scalar @_ == 1 || $_[1] != -1) {
		print colored [$common::COLOR_RESULT], "EXCITED\n";
	    }
	    return "EXCITED";
	}
    }
    elsif ($mod eq "S" || $mod eq "MS" || $mod eq "SM") 
    {	
	my $nbObjects=&getObjNumber($ss,-1);
	if($nbObjects > 15)
	{
	    if (scalar @_ == 1 || $_[1] != -1) {
		print colored [$common::COLOR_RESULT], "UNKNOWN\n";
	    }
	    return "UNKNOWN";
	}
	elsif ($nbObjects%2 == 0)
	{
	    my $v = "(".sprintf("%x",$nbObjects).",".sprintf("%x",$nbObjects).")";
	    if(&isValid($v.$ss,-1)==1)
	    {		
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], "GROUND\n";
		}
		return "GROUND";
	    }
	    else
	    {
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], "EXCITED\n";
		}
		return "EXCITED";
	    }
	}
	else
	{
	    if($nbObjects + 1 > 15)
	    {
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], "UNKNOWN\n";
		}
		return "UNKNOWN";
	    }
	    my $v1 = "(".sprintf("%x",$nbObjects-1).",".sprintf("%x",$nbObjects+1).")";
	    my $v2 = "(".sprintf("%x",$nbObjects+1).",".sprintf("%x",$nbObjects-1).")";
	    if(&isValid($v1.$ss,-1)==1 || &isValid($v2.$ss,-1)==1)
	    {
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], "GROUND\n";
		}
		return "GROUND";
	    }
	    else
	    {
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], "EXCITED\n";
		}
		return "EXCITED";
	    }	   
	}       
    }  

    return -1;
}


sub getPeriod
{
    my $ss=&expand($_[0],-1);
    if (&isValid($ss,-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }

    my $mod=&getSSType($_[0],-1);
    if ($mod eq "R") 
    {	
	my $p=length($ss);	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], $p."\n";
	}
	
	return $p;
    }

    elsif($mod eq "M")
    {
	my $cpt=0;
	my $inc = 1;
	for (my $i=0; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$cpt ++;
		$inc = -1;
	    }
	    elsif(substr($ss,$i,1) eq ']')
	    {
		$inc = 1;
	    }
	    else
	    {
		if($inc != -1)
		{
		    $cpt++;	    
		}
	    }
	}
	
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], $cpt."\n";
	}
	
	return $cpt;
    }

    elsif($mod eq "S" || $mod eq "MS" || $mod eq "SM")
    {
	my @res = split(/\)/,$ss);

	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], ((scalar @res)*2)."\n";
	}
	
	return (scalar @res)*2;	
    }
    
}


sub getSSType
{
    if (&isValid($_[0],-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }

    if ($_[0] =~ /\(/ && $_[0] =~ /\[/) {
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], "MS"."\n";
	}
	return "MS";
    } elsif ($_[0] =~ /\(/) {
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], "S"."\n";
	}
	return "S";
    } elsif ($_[0] =~ /\[/) {
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], "M"."\n";
	}
	return "M";
    } else {
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], "R"."\n";
	}
	return "R";
    }    
}

# Expand SS and sort number in multiplex
sub normalize
{
    my $ss = &expand($_[0],-1);
    my $res = "";

    for (my $i =0; $i < length($ss); $i++) {
	if (substr($ss, $i, 1) eq "[") {
	    my $j = $i + 1;
	    my @mult = ();
	    while (substr($ss, $j, 1) ne "]") {
		if (uc(substr($ss, $j+1, 1)) eq "X") {
		    push(@mult, (substr($ss, $j, 1))."X");
		    $j++;
		} else {
		    push(@mult, (substr($ss, $j, 1)));
		}				
		$j ++;
	    }
	    $i = $j;
	    
	    $res = $res."[".(join('', reverse sort(@mult)))."]";	    
	} else {
	    $res = $res.substr($ss, $i, 1);
	}
    }
    
    if (scalar @_ == 1 || $_[1] != -1) {
	print colored [$common::COLOR_RESULT], $res."\n";
    }
    return $res;    
}


sub expand
{
    # the Syntax must be valid    
    my $pattern = uc($_[0]);
    $pattern =~ s/\s+//g;
    my @src=split('', $pattern);
    if ($src[scalar @src -1] ne "*") {
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], join('',@src)."\n";
	}
	return join('', @src);	    
    } else {
	# Remove the *
	pop(@src);    

	my $i = 0;
	my $tmp1 = "";
	my $tmp2 = "";
	my $res = "";
	my $resf = "";

	while ($i < scalar @src) {
	    $res = "";
	    $tmp1 = "";
	    $tmp2 = "";

	    while ($src[$i] ne "(" && $i < scalar @src) {
		$res = $res.$src[$i];
		$i++;	    
		if ($i >= scalar @src) {
		    if ((scalar @_ == 1) || ($_[1] != -1)) {
			print colored [$common::COLOR_RESULT], $res."\n";
		    }
		    return $res;
		}
	    }

	    if ($src[$i] eq "(") {
		$i++;
		
		while ($src[$i] ne ",") {	   
		    $tmp2=$tmp2.$src[$i];
		    $i++;
		    if ($i >= scalar @src) {
			if ((scalar @_ == 1) || ($_[1] != -1)) {
			    print colored [$common::COLOR_RESULT], $res."(".$tmp2."\n";
			}
			return $res."(".$tmp2;
		    }
		}
		if ($src[$i] eq ",") {
		    $i++;
		}
		while ($src[$i] ne ")") {
		    $tmp1=$tmp1.$src[$i];
		    $i++;
		    if ($i >= scalar @src) {
			if ((scalar @_ == 1) || ($_[1] != -1)) {
			    print colored [$common::COLOR_RESULT], $res."(".$tmp1.",s".$tmp2.")"."\n";
			}
			return $res."(".$tmp1.",s".$tmp2.")";
		    }
		}
		$res=$res."(".$tmp1.",".$tmp2.")";
		$i++;
	    }	

	    $resf = $resf.$res;
	}
        
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], join('',@src).$resf."\n";
	}
	return join('', @src).$resf;
    }
}


sub periodMin
{
    if (&isValid($_[0],-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }
    
    my $src = &expand($_[0],-1);    
    my $mod = &getSSType($_[0],-1);
    my @res =();

    if ($mod eq "M" || $mod eq "R") {	
	for (my $i=0; $i < length($src); $i++) {
	    if (substr($src,$i,1) eq '[') {
		my $j =$i+1;
		my $mult ="";
		while (substr($src,$j,1) ne ']' && $j < length ($src)) {
		    $mult = $mult.substr($src,$j,1);
		    $j ++;
		}
		
		$i = $j;
		push(@res,"[".$mult."]");
	    } else {
		push(@res,(substr($src,$i,1)));		
	    }		 		 
	}
	
	# Compute periode
	for (my $p=1; $p <= scalar @res; $p++) {
	    if ((scalar @res)%$p == 0) {
		my @resp = ();
		my $cpt = 0;	
		my $i=0;
		while (($i + $p -1) <scalar @res ) {					
		    $resp[$cpt] = join('',@res[$i..($i+$p-1)]);
		    $cpt ++;
		    $i += $p;
		}
		
		my $drap = -1;		
		for (my $j=0; $j < ($cpt -1); $j++) {
		    if ($resp[$j] ne $resp[$j+1]) {
			$drap = 1;
			last;
		    }		
		}
		
		if ($drap == -1) {
		    if (scalar @_ == 1 || $_[1] != -1) {
			print colored [$common::COLOR_RESULT], join('',@res[0..($p-1)])."\n";
		    }
		    return join('',@res[0..($p-1)]);
		}
	    }
	}
    } elsif ($mod eq "MS" || $mod eq "SM" || $mod eq "S") {
	my @res=();	
	my $cpt = 0;
	for (my $i=0; $i < length($src); $i++) {
	    my $val = substr($src,$i,1);
	    if ( $val ne '(' && $val ne ')' && $val ne ',' ) {
		if ($val ne '[' && $val ne ']') {
		    if (($i+1) < length($src) && substr($src,$i+1,1) eq "X") {
			$res[$cpt] = $val."X";
			$i ++;
		    } else {
			$res[$cpt] = $val;
		    }
		    $cpt ++;		    
		} elsif ($val eq '[') {
		    my $j = $i +1;
		    my $mult = '';
		    while (substr($src,$j,1) ne ']' && $j < length($src)) {
			$mult=$mult.substr($src,$j,1); 
			$j++;			
		    }
		    if (substr($src,$j,1) eq ']') {			
			$i = $j;
			$res[$cpt] = '['.$mult.']'; 
			$cpt ++;
		    }
		}
	    }
	}
	
	for (my $i=0; $i < scalar(@res); $i ++) {
	    if ($i%2 == 0) {
		$res[$i] = '('.$res[$i];
	    } else {
		$res[$i] = ','.$res[$i].")";
	    }

	}

	# Compute periode
	for (my $p=2; $p <= scalar @res; $p+=2) {
	    if ((scalar @res)%$p == 0) {
		my @resp = ();
		my $cpt = 0;	
		my $i=0;
		while (($i + $p -1) <scalar @res ) {					
		    $resp[$cpt] = join('',@res[$i..($i+$p-1)]);
		    $cpt ++;
		    $i += $p;
		}
		
		my $drap = -1;		
		for (my $j=0; $j < ($cpt -1); $j++) {
		    if ($resp[$j] ne $resp[$j+1]) {
			$drap = 1;
			last;
		    }		
		}
		
		if ($drap == -1) {
		    if (scalar @_ == 1 || $_[1] != -1) {
			print colored [$common::COLOR_RESULT], &shrink(join('',@res[0..($p-1)]),-1)."\n";
		    }
		    
		    return &shrink(join('',@res[0..($p-1)]),-1);		    
		}
	    }
	}
    }
}

sub shrink
{
    if (&isValid($_[0],-1) < 0) {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }
    
    my $src = &normalize($_[0],-1);    
    my $mod=&getSSType($_[0],-1);
    my @res =();

    if ($mod eq "M" || $mod eq "R") {
	if (scalar @_ == 1 || $_[1] != -1) {
	    print colored [$common::COLOR_RESULT], $src."\n";
	}
	return $src;	
    } elsif ($mod eq "MS" || $mod eq "SM" || $mod eq "S") {
	my @res=();	
	my $cpt = 0;
	for (my $i=0; $i < length($src); $i++) {
	    my $val = substr($src,$i,1);
	    if ( $val ne '(' && $val ne ')' && $val ne ',' ) {
		if ($val ne '[' && $val ne ']') {
		    if (($i+1) < length($src) && substr($src,$i+1,1) eq "X") {
			$res[$cpt] = $val."X";
			$i ++;
		    } else {
			$res[$cpt] = $val;
		    }
		    $cpt ++;		    
		} elsif ($val eq '[') {
		    my $j = $i +1;
		    my $mult = '';
		    while (substr($src,$j,1) ne ']' && $j < length($src)) {
			$mult=$mult.substr($src,$j,1); 
			$j++;			
		    }
		    if (substr($src,$j,1) eq ']') {			
			$i = $j;
			$res[$cpt] = $mult; 
			$cpt ++;
		    }
		}
	    }
	}
	
	if (scalar(@res) %2 != 0) {	    
	    if (scalar @_ == 1 || $_[1] != -1) {
		print colored [$common::COLOR_RESULT], $src."\n";
	    }
	    
	    return $src;
	} else {
	    my $drap = -1;
	    for (my $i=0; $i < (scalar @res)/2; $i+=2) {
		if ($res[$i] ne ($res[$i + (scalar @res)/2 +1]) || $res[$i+1] ne ($res[$i + (scalar @res)/2])) {
		    $drap=1;
		    last;
		}		   
	    }
	    if ($drap == 1) {
		my $resfs ="";
		for (my $j=0; $j < scalar @res; $j++) {	    
		    my $v = uc($res[$j]);
		    $v =~ s/X//g; 
		    if ($j%2==0) {
			if (length($v) > 1) {
			    $resfs = $resfs."([".$res[$j]."]";
			} else {
			    $resfs = $resfs."(".$res[$j];
			}
		    } else {
			if (length($v) > 1) {
			    $resfs = $resfs.",[".$res[$j]."])";
			} else {
			    $resfs = $resfs.",".$res[$j].")";
			}
		    }
		}

		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], $resfs."\n";
		}
		
		return $resfs;
	    } else {
		my @resf = @res[0..(scalar @res)/2-1];		
		my $resfs ="";
		for (my $j=0; $j < scalar @resf; $j++) {	    
		    my $v = uc($res[$j]);
		    $v =~ s/X//g; 
		    if ($j%2==0) {
			if (length($v) > 1) {
			    $resfs = $resfs."([".$resf[$j]."]";
			} else {
			    $resfs = $resfs."(".$resf[$j];
			}
		    } else {
			if (length($v) > 1) {
			    $resfs = $resfs.",[".$resf[$j]."])";
			} else {
			    $resfs = $resfs.",".$resf[$j].")";
			}
		    }
		}
		
		if (scalar @_ == 1 || $_[1] != -1) {
		    print colored [$common::COLOR_RESULT], $resfs.'*'."\n";
		}
		
		return $resfs.'*';		
	    }
	}

	
    }
}


sub getInfo
{   
    # Check the Syntax validity
    if ( isSyntaxValid($_[0],-1) == -1) {
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1;
	}
	return -1;
    }
    
    ## Expand eventually the siteswap
    ## Remove all spaces first and put everything in uppercase
    my $pattern = &expand($_[0],-1);
    my @st=split('', $pattern);

    my @catchesMap = ();	## Map containing all the catches times (modulo the period)    
    my @throwsMap =();		## Map containing all the throws values     
    my @multMap = ();		## Map containing all the multiplexes throws times 
    my @multNumMap = ();	## Map containing all the objects numbers in multiplexes throws 
    my @multThrowsMap = ();	## Map containing all the multiplexes throws 

    my $mod="unknown";
    my $smod="vanilla";
    my $contain_multiplex=0;
    my $objnum_multiplex=0;    
    my $true_multiplexing=0;
    my $val_multiplex="";
    my $side="right";
    my $curtime=0;
    my $sum = 0;
    my $i=0;
    my $j=0;
    my $tmp=0;
    my $period=0;
    

    for ($i=0; $i<scalar @st; $i++) {
	if ($mod eq "unknown") {
	    if ($st[$i] eq "(") {
		$mod = "synchronous";
	    } else {
		$mod = "asynchronous";
	    }
	} elsif ($mod eq "asynchronous" && (($st[$i] eq "(") || ($st[$i] eq ")") || ($st[$i] eq ","))) {
	    if ((scalar @_ == 1) || ($_[1] != -1)) {
		print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1; 
	    }
	    return -1;
	} elsif ($mod eq "synchronous" && ($st[$i] eq ")") && ($i<scalar @st -1) && ($st[$i+1] ne "(") && ($st[$i+1] ne "*")) {
	    if ((scalar @_ == 1) || ($_[1] != -1)) {
		print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1;
	    }
	    return -1;
	}
	
	if ($st[$i] eq "[") {
	    $smod="multiplex";
	    $objnum_multiplex=0;
	    $contain_multiplex++;
	    $val_multiplex="";
	    push(@multMap,$curtime); 	    
	} elsif ($st[$i] eq "]") {	 
	    $curtime ++;	
	    push(@multNumMap,$objnum_multiplex);
	    if ($val_multiplex =~ /0/ && $objnum_multiplex > 1)
	    {
		if ((scalar @_ == 1) || ($_[1] != -1)) {
		    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR8;
		}
		return -1;
	    }
	    else
	    {
		push(@multThrowsMap,$val_multiplex);
	    }
	    $objnum_multiplex=0;
	    $val_multiplex="";
	    $smod="vanilla";
	} elsif ($st[$i] eq ")") {	    	    
	    $side="right";
	    if ($i>0 && $st[$i-1] ne "]") {
		$curtime ++;
	    }
	} elsif ($st[$i] eq ",") {
	    if ($i >0 && $st[$i -1] ne "]") {
		$curtime ++;
	    }
	    $side="left";
	}	

	if($mod eq "synchronous" &&  ($st[$i] eq "1" || $st[$i] eq "3" || $st[$i] eq "5" || $st[$i] eq "7" || $st[$i] eq "9"
				      || $st[$i] eq "B" || $st[$i] eq "D" || $st[$i] eq "F"))
	{
	    if ((scalar @_ == 1) || ($_[1] != -1)) {
		print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR7;
	    }
	    return -1;
	}

	elsif ($st[$i] eq "0" || $st[$i] eq "1" || $st[$i] eq "2" || $st[$i] eq "3" || $st[$i] eq "4" 
	       || $st[$i] eq "5" || $st[$i] eq "6" || $st[$i] eq "7" || $st[$i] eq "8" || $st[$i] eq "9") {	    
	    
	    # Compute the sum
	    $sum += int($st[$i]);

	    # Add the throws to the throwsMap
	    push(@throwsMap,int($st[$i])); 	    

	    # If Multiplex, increment the number of objects in this one 
	    if ($smod eq "multiplex") {
		$objnum_multiplex++;
		$val_multiplex = $val_multiplex.$st[$i];
	    } 	    

	    # Synchronous throw with X => Add 1 to the catch time slot
	    if (($i < scalar @st -1) && ($st[$i+1] eq "X")) 
	    {
		if($st[$i] eq "0")
		{
		    if ((scalar @_ == 1) || ($_[1] != -1)) {
			print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR6;
		    }
		    return -1;
		}

		my $ad=0;
		if ($side eq "right" && $mod eq "synchronous") {
		    $ad=+1;
		} elsif ($mod eq "synchronous") {
		    $ad=-1;
		}

		$tmp = int($st[$i]) + $ad + $curtime;
		push(@catchesMap,$tmp); 	    
	    } else {
		$tmp = int($st[$i]) + $curtime;
		push(@catchesMap,$tmp); 	    
	    }
	    
	    if ($smod eq "vanilla" && $mod ne "synchronous") {
		$curtime ++;
	    }
	} elsif ($st[$i] eq "A" || $st[$i] eq "B" || $st[$i] eq "C" || $st[$i] eq "D" || $st[$i] eq "E"
		 || $st[$i] eq "F") {	
	    my $hex=ord($st[$i])-ord("A") + 10;	    
	    
	    #Compute the sum
	    $sum += $hex;

	    # Add the throws to the throwsMap
	    push(@throwsMap,$hex); 	    
	    
	    # If Multiplex, increment the number of objects in this one 
	    if ($smod eq "multiplex") {
		$objnum_multiplex++;
		$val_multiplex = $val_multiplex.$st[$i];
	    }
 	    
	    # Synchronous throw with X => Add 1 to the catch time slot
	    if (($i < scalar @st -1) && ($st[$i+1] eq "X")) {
		my $ad=0;
		if ($side eq "right" && $mod eq "synchronous") {
		    $ad=+1;
		} elsif ($mod eq "synchronous") {
		    $ad=-1;
		}

		$tmp = $hex + $ad + $curtime;
		push(@catchesMap,$tmp) ; 	
	    } else {
		$tmp = $hex + $curtime;
		push(@catchesMap, $tmp) ; 	
	    }
	    
	    if ($smod eq "vanilla" && $mod ne "synchronous") {
		$curtime ++;
	    }
	}
    }

    # Right we now know the period
    $period = $curtime;    

    # Compute and Print the Catches Map for debugging purpose
    my @catchesMaptmp =();    
    @catchesMaptmp = map {$_ % $period} @catchesMap;	
    @catchesMap=@catchesMaptmp;        

    if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
	print $lang::MSG_SSWAP_GENERAL9." : ";
	for ($i=0; $i < scalar @catchesMap; $i++) {
	    print $catchesMap[$i]." ";
	}
	print "\n";
    }

    if ($contain_multiplex==0) {
	#It does not contain multiplex at all
	# Sort all the Catches Times and check all values are different
	my @out = sort @catchesMap;
        
	for ($i=1; $i < scalar @out; $i++) {
	    if ($out[$i] == $out[$i-1]) {	
		
		if ((scalar @_ == 1) || ($_[1] != -1)) {
		    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR2; 
		}
		return -1;
	    }
	}    
    } else {
	# It does contain multiplexes
	# Thus check that Identical values in the Catches Map correspond to multiplexes Times and the reverse.	
	if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
	    print $contain_multiplex." Multiplex(es)\n"; 
	    print $lang::MSG_SSWAP_GENERAL8." : ";
	    for ($i=0; $i < scalar @multMap; $i++) {	
		print $multMap[$i]." ";
	    }
	    print "\n";    

	    print $lang::MSG_SSWAP_GENERAL7." : ";
	    for ($i=0; $i < scalar @multNumMap; $i++) {
		print $multNumMap[$i]." ";
	    }
	    print "\n";    
	}

	#print "Multiplex(es) Throws Map : ";
	#for ($i=0; $i < scalar @multThrowsMap; $i++)
	#{	   
	#    print $multThrowsMap[$i]."\n";
	#}

	my @simltRecv = ();
	my $found = -1;


	# Check Simultaneous reception. Ie at least 2 receptions from 2 values different of 2        
	if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
	    for ($i=0; $i < scalar @multMap; $i++) {
		for ($j=0; $j < scalar @catchesMap; $j++) {
		    if ($multMap[$i] == $catchesMap[$j] && $throwsMap[$j] != 2) {
			push(@simltRecv,$throwsMap[$j]);
			if (scalar @simltRecv >=2) {
			    print $lang::MSG_SSWAP_ISVALID_MSG1;
			    $found=0;			
			    last;
			}
		    }
		}

		if ($found==0) {
		    last;
		}	    
	    }
	}

	# Sort all the Catches Times and check that Identical values in the Catches Map 
	# correspond to multiplexes Times and the reverse.	
	my @out = sort @catchesMap;
	my @multNumMapTmp = @multNumMap;


	for ($i=1; $i < scalar @out; $i++) {	
	    if ($out[$i] == $out[$i-1]) {
		$found = -1;
		for ($j=0; $j < scalar @multMap; $j++) {	   
		    if ($multMap[$j] == $out[$i]) {
			$multNumMapTmp[$j] = $multNumMapTmp[$j] -1;
			$found=0;			
			#last;
		    }
		}

		if ($found==-1) {
		    # 2 Catches are on a hand not considered to throw a multiplex at this time
		    if ((scalar @_ == 1) || ($_[1] != -1)) {
			print colored [$common::COLOR_RESULT], "False : ".$lang::MSG_SSWAP_ISVALID_ERR4."\n"; 
		    }
		    return -1; 
		}
	    }
	}

	for ($i=0; $i < scalar @multNumMapTmp; $i++) {	   
	    if ($multNumMapTmp[$i] != 1) {			
		if ((scalar @_ == 1) || ($_[1] != -1)) {
		    print colored [$common::COLOR_RESULT], "False : ".$lang::MSG_SSWAP_ISVALID_ERR5."\n"; 
		}
		return -1; 
	    }
	}	

	# Check according to the multiplexes if it is a true Multiplexing only swp and if it contains 
	# at least a clustered multiplex throw. 
	$found = -1;
	for ($i=0; $i < scalar @multThrowsMap; $i++) {
	    if ($found != -1) {		
		last;
	    }
	    
	    my @mult =();
	    for ($j=0;$j<length($multThrowsMap[$i]);$j++) {
		if (substr($multThrowsMap[$i],$j,1) ne "2") {
		    push(@mult,substr($multThrowsMap[$i],$j,1));
		} else {
		    # One Multiplex contains an held object. It is not a True Multiplexing Only Siteswap
		    $true_multiplexing=-1;
		}
	    }	    

	    @mult = sort @mult;

	    # check if it contains at least a clustered multiplex throw. 
	    # Ie a Multiplex with at least 2 identical throws different from 2
	    for ($j=1; $j < scalar @mult; $j++) {				
		if ($mult[$j] == $mult[$j-1]) {
		    if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
			print $lang::MSG_SSWAP_ISVALID_MSG2;			
		    }
		    $found=0;
		    last;
		}
	    }
	}

	if ($true_multiplexing!=-1) {
	    if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
		print $lang::MSG_SSWAP_ISVALID_MSG3;
	    }
	}
	
    }
    

    # Check the Average and compute the objects number     
    if ($period == 0)
    {
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    if ($sum % $period != 0) {		
	if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
	    print $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
	    print $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
	}
	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR3a.$sum.$lang::MSG_SSWAP_ISVALID_ERR3b;
	}
	return -1;
    } else {
	if ((scalar @_ == 1) || ($_[1] != -1) && ($_[1] != -2)) {
	    if ($mod eq "synchronous") {
		print $lang::MSG_SSWAP_GENERAL1b."\n"; 
	    } else {
		print $lang::MSG_SSWAP_GENERAL1."\n"; 
	    }
	    
	    my $status = getSSstatus($_[0],-1);
	    print $status." Siteswap"."\n";
	    print $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
	    print $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
	    print $lang::MSG_SSWAP_GENERAL13." : ".&periodMin($_[0],-1)."\n"; 
	    print $lang::MSG_SSWAP_GENERAL2." : ". $sum / $period."\n"; 	    	
	    print $lang::MSG_SSWAP_GENERAL12." : ".&inv($_[0],-1)."\n"; 	    	
	}

	if ((scalar @_ == 1) || ($_[1] != -1)) {
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return 1;
    }    
    
}

sub isValid
{
    if ((scalar @_ == 1) || ($_[1] != -1)) {
	return getInfo($_[0],-2);
    } else {
	return getInfo($_[0],-1);
    }
}


sub anim
{
    my $pwd = cwd();
    open(FILE,"> tmp/jugglingLabApplet.htm") || die ("$lang::MSG_GENERAL_ERR1 <tmp/jugglingLabApplet.htm> $lang::MSG_GENERAL_ERR1b") ;
    
    print FILE "<applet archive=\"../data/JugglingLab/bin/JugglingLab.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
    print FILE "<param name=\"config\" value=\"entry=none;view=edit;\"/>\n";
    print FILE "<param name=\"notation\" value=\"siteswap\"/>\n";
    print FILE "<param name=\"pattern\" value=\"$_[0]\"/>\n";
    print FILE "<param name=\"colors\" value=\"mixed\"/>\n";
    print FILE "</applet>\n";
    close(FILE);

    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/tmp/jugglingLabApplet.htm");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/tmp/jugglingLabApplet.htm &");
    }
}


sub draw
{
    require modules::LADDER;    
    if(&getSSType($_[0],-1) eq "R" || &getSSType($_[0],-1) eq "M")
    {
	push(@_,"-m 1");
    }
    elsif(&getSSType($_[0],-1) eq "S" || &getSSType($_[0],-1) eq "MS")
    {
	push(@_,"-m 2");
    }    

    &LADDER::draw(@_);
}



sub jugglingLab
{
    my $pwd = cwd();
    open(FILE,"> tmp/jugglingLabApplet.htm") || die ("$lang::MSG_GENERAL_ERR1 <tmp/jugglingLabApplet.htm> $lang::MSG_GENERAL_ERR1b") ;
    
    print FILE "<applet archive=\"../data/JugglingLab/bin/JugglingLab.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
    print FILE "<param name=\"config\" value=\"entry=siteswap;view=edit\"/> \n";
    print FILE "<param name=\"notation\" value=\"siteswap\"/>\n";
    print FILE "<param name=\"colors\" value=\"mixed\"/>\n";
    print FILE "</applet>\n";
    close(FILE);
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/tmp/jugglingLabApplet.htm");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/tmp/jugglingLabApplet.htm &");
    }
}


sub genSS
{
    # Usage :    nombre_objets lancer_max periode [options]
    #
    #les options incluent :
    #-s  mode synchrone             -j <nombre> definit le nombre de jongleurs
    #-n  donne le nombre d'objets   -m <nombre>  multiplex avec au moins le
    #-no imprime juste les nombres               nombre donne de lancers simultanes
    #-g  figures Ground             -mf permet les receptions multiples
    #-ng figures excitees           -mc empeche les lancers multiplex par lots
    #-f  liste complete (avec       -mt  true multiplexing patterns*
    #     les figures composees)    -d <nombre> retard de communication (passing)
    #-se disable starting/ending    -l <nombre>  passing leader person number
    #-prime premiers seulement      -x <lancer> ..  exclure les lancers pour soi
    #-rot avec permutations         -i <lancer> ..  inclure les lancers pour soi
    #      des figures              -lame supprimer les '11' en mode asynchrone
    #-cp connected patterns only    -jp  show all juggler permutations*

    my $writeFile=-1;
    my @result = ();

    if (scalar @_ > 3) {
	if (index($_[3], "-O") >= 0) {
	    my $opt=substr($_[3],index($_[3],'-O')+2);
	    @result=`$conf::JAVA_CMD -cp data/JugglingLab/bin/JugglingLab_0.5.3.jar jugglinglab/generator/siteswapGenerator $_[0] $_[1] $_[2] ${opt}`;
	    if (scalar @_ > 4) {
		open(FILE,">> $conf::RESULTS/$_[4]") || die ("$lang::MSG_GENERAL_ERR1 <$_[4]> $lang::MSG_GENERAL_ERR1b") ;
		$writeFile = 1;
	    }		  		  
	} else {
	    @result=`$conf::JAVA_CMD -cp data/JugglingLab/bin/JugglingLab_0.5.3.jar jugglinglab/generator/siteswapGenerator $_[0] $_[1] $_[2]`;
	    open(FILE,">> $conf::RESULTS/$_[3]") || die ("$lang::MSG_GENERAL_ERR1 <$_[3]> $lang::MSG_GENERAL_ERR1b") ;
	    $writeFile = 1;
	}
    } else {
	@result=`$conf::JAVA_CMD -cp data/JugglingLab/bin/JugglingLab_0.5.3.jar jugglinglab/generator/siteswapGenerator $_[0] $_[1] $_[2]`;
    }
    

    if ($writeFile == 1) {
	print FILE "================================================================\n";
	print FILE $lang::MSG_SSWAP_GENSITESWAP_1;
	print FILE scalar @result;
	print FILE $lang::MSG_SSWAP_GENSITESWAP_2;
	print FILE $lang::MSG_SSWAP_GENSITESWAP_3;
	print FILE $_[0];
	print FILE $lang::MSG_SSWAP_GENSITESWAP_4;
	print FILE $_[1];
	print FILE $lang::MSG_SSWAP_GENSITESWAP_5;
	print FILE $_[2];
	print FILE $lang::MSG_SSWAP_GENSITESWAP_6;	
	print FILE "================================================================\n";
	print FILE @result;    
    } else {
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_1;
	print colored [$common::COLOR_RESULT], scalar @result;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_2;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_3;
	print colored [$common::COLOR_RESULT], $_[0];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_4;
	print colored [$common::COLOR_RESULT], $_[1];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_5;
	print colored [$common::COLOR_RESULT], $_[2];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSITESWAP_6;
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print @result;    
    }

    if (scalar @_ > 3) 
    {	
	close FILE;
    }		  		  
    
    return @result;
}



sub genDiagProbert
{
    my $balls=$_[0];		# number of objects
    my $heightss=$_[1];		# max height for the siteswaps
    my $p=$_[2];		# siteswaps period
    my $f =$_[3];		# file
    my $marge = 5;
    
    if ($balls < 0 || $balls > 15 || $p < 0) {
	return;
    }

    my @diagram=();
    my $marge = 5;
    my $comment = $balls.",".$p;

    for (my $i=0; $i < $p ; $i++) {
	for (my $j=0; $j < $p ; $j++) {
	    if ($balls-$j+$i < 0 || $balls-$j+$i > 15 || ($heightss != -1 && $balls-$j+$i > $heightss)) {
		$diagram[$i][$j] = "-";
	    } else {
		$diagram[$i][$j]=sprintf("%x",$balls-$j+$i);
	    }
	}

    }

    if (scalar @_ == 4 && $f!=-1 && "XLS:"=~substr(uc($f),0,4)) {
	use Excel::Writer::XLSX;    
	# Create a new Excel workbook
	my $workbook =();
	my $size_auto = 6;
	my $starti = 8;
	my $startj = 2;
	my $f="$conf::RESULTS/".substr($f,4).'.xlsx';
	$workbook = Excel::Writer::XLSX->new($f) or die ("$lang::MSG_GENERAL_ERR2 <$f".'.xlsx>');	
        
	$workbook->set_properties(
	    title    => 'Martin Probert\'s Diagram',
	    author   => "$common::AUTHOR",
	    comments => 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (gen_probert_diag)",
	    );

	# Add a worksheet
	my $worksheet = $workbook->add_worksheet("Probert's Diagram="."$comment");
	
	# Add and define formats    
	# Array Headers  Format
	my $format1a = $workbook->add_format(fg_color => 'yellow');
	$format1a->set_bold();
	$format1a->set_color( 'red' );
	$format1a->set_align( 'center' );	        
	$format1a->set_align( 'vcenter' );	        
	
	my $format1b = $workbook->add_format();
	$format1b->set_bold();
	$format1b->set_color( 'red' );
	$format1b->set_align( 'center' );	        
	
	# Default format
	my $format0 = $workbook->add_format();
	$format0->set_align( 'right' );	        
	#$worksheet->set_column( 'A:Z', $conf::EXCELCOLSIZE, $format0);
	#$worksheet->set_column( $startj,$startj, length($states[0]) + 2);

	$worksheet->merge_range ('B2:L2', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1a, $format1b);	
	$worksheet->merge_range ('B3:L3', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$balls, $format1b);	
	if ($heightss == -1) {
	    $worksheet->merge_range ('B4:L4', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h, $format1b);    
	} else {
	    $worksheet->merge_range ('B4:L4', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$heightss, $format1b);    
	}	
	$worksheet->merge_range ('B5:L5', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1d.": ".$p, $format1b);	

	if (uc($conf::EXCELCOLSIZE) eq "AUTO") {	    
	    $worksheet->set_column( $startj, $startj, $size_auto, $format0);
	} else {
	    $worksheet->set_column( $startj, $startj, $conf::EXCELCOLSIZE, $format0);
	    #$worksheet->Columns($startj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	}
	for (my $j=0; $j < $p ; $j++) {
	    $worksheet->write_string( $starti, $j+$startj+1, $j, $format1a);
	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$worksheet->set_column( $j+$startj+1, $j+$startj+1, $size_auto, $format0);
	    } else {
		$worksheet->set_column( $j+$startj+1, $j+$startj+1, $conf::EXCELCOLSIZE, $format0);		
	    }

	}

	for (my $i=0; $i < $p ; $i++) {
	    for (my $j=0; $j < $p ; $j++) {		
		if ($j == 0) {
		    $worksheet->write_string( $i + $starti+1, $startj, $i, $format1a);
		}
		
		$worksheet->write_string( $i + $starti +1, $j + $startj +1, $diagram[$i][$j], $format0);
		
	    }	
	}

    } elsif (scalar @_ == 4 && $f!=-1) {
	open(FILE,">>$conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "\n================================================================\n";
	print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1a."\n";	
	print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$balls."\n";	
	if ($heightss == -1) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h."\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$heightss."\n";	
	}	
	print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1d.": ".$p;
	print FILE "\n================================================================\n\n";
	my $size_auto = 6;
	my $starti = 8;
	my $startj = 2;
	
	print FILE ' ' x ($marge);		
	for (my $j=0; $j < $p ; $j++) {
	    print FILE ' ' x ($marge - length($j));
	    print FILE $j;
	}
	print FILE "\n";
	
	for (my $i=0; $i < $p ; $i++) {
	    for (my $j=0; $j < $p ; $j++) {
		
		if ($j == 0) {
		    print FILE ' ' x ($marge  - length($i));
		    print FILE $i;
		}
		
		print FILE ' ' x ($marge - length($diagram[$i][$j]));
		print FILE $diagram[$i][$j];		
	    }	
	    print FILE "\n";
	}    
	close FILE;

    } elsif (scalar @_ == 3) {
	print colored [$common::COLOR_RESULT],"\n================================================================\n";
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1a."\n";	
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$balls."\n";	
	if ($heightss == -1) {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h."\n";	
	} else {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$heightss."\n";	
	}	

	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1d.": ".$p;
	print colored [$common::COLOR_RESULT],"\n================================================================\n\n";

	print ' ' x ($marge);		
	for (my $j=0; $j < $p ; $j++) {
	    print ' ' x ($marge - length($j));
	    print $j;
	}
	print " \n";
	
	for (my $i=0; $i < $p ; $i++) {
	    for (my $j=0; $j < $p ; $j++) {
		
		if ($j == 0) {
		    print ' ' x ($marge  - length($i));
		    print $i;
		}
		
		print ' ' x ($marge - length($diagram[$i][$j]));
		print colored [$common::COLOR_RESULT], $diagram[$i][$j];
		
	    }	
	    print "\n";
	}
	print "\n\n";
    }

    return @diagram;

}


sub genSSProbert
{
    my $balls=$_[0];		# Objects Number
    my $heightss=$_[1];		# max height for the siteswaps
    my $p=$_[2];		# Period
    my $opt=$_[3];		# Options : currently : -p for removing permutation equivalence; -t for giving associated Time Reversed SS
    my $f=$_[4];
    
    sub genSSProbert_in
    {
	my @vect=@{$_[0]};
	my @diagram=@{$_[1]};
	my $cpt = $_[2];
	my $p = $_[3];
	my $opt = $_[4];
	my @res =();	
	for (my $i=0; $i < $_[3]; $i++) {	    
	    &common::displayComputingPrompt();
	    my @vect2=@vect;
	    if ($vect[$i]==1) {	
		$vect2[$i]=0;
		my @subss=genSSProbert_in(\@vect2,\@diagram, $cpt+1,$p, $opt);

		if (scalar @subss == 0) {		 		   		    		    
		    push(@res,$diagram[$i][$cpt]);		    		    		    
		} else {
		    for (my $j=0; $j < scalar @subss; $j++) {
			if ($opt =~ "-p") {
			    my $drap = -1;
			    for (my $k =0; $k < scalar @res; $k++) {
				&common::displayComputingPrompt();
				if ($cpt==0 && (($diagram[$i][$cpt].$subss[$j]) =~ /-/ 
						|| &isEquivalent($res[$k],$diagram[$i][$cpt].$subss[$j],-1)==1)) {	
				    if ($SITESWAP_DEBUG>=1) {
					print $lang::MSG_SSWAP_GENPROBERTSS_MSG1f.$diagram[$i][$cpt].$subss[$j]."\n";
				    }
				    $drap = 1;
				    last;
				}			    			    
			    }
			    
			    if ($drap == -1) {				
				push(@res,$diagram[$i][$cpt].$subss[$j]); 		
			    }			    
			} else {
			    if ($cpt==0 && (($diagram[$i][$cpt].$subss[$j]) !~ /-/)) {
				push(@res,$diagram[$i][$cpt].$subss[$j]);						    
			    } elsif ($cpt!=0) {
				push(@res,$diagram[$i][$cpt].$subss[$j]);						    
			    }
			}		
		    }
		}
	    }
	}
	
	&common::hideComputingPrompt();
	return @res;
    }

my @diagram=genDiagProbert($balls,$heightss,$p,-1); #$_[0] = Objects Numbers ; $_[1] = Hight Max Siteswaps; $_[2] = period

my @vect_ch=();
for (my $i=0; $i < $p; $i++) {
    $vect_ch[$i]=1;
}

my @res=genSSProbert_in(\@vect_ch,\@diagram, 0, $p, $opt);

&common::hideComputingPrompt();
my $pwd = cwd();

if (scalar @_ >= 5 && $_[4] != -1) 
{
    if("HTML:"=~substr($_[4],0,5)) 
    {	
	#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
	#dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
	mkdir($conf::RESULTS."/lib");
	copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
	copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

	$f =substr($_[4],5);    
	open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	print FILE_JML "<?xml version=\"1.0\"?>\n";
	print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	print FILE_JML "<jml version=\"1.1\">\n";
	print FILE_JML "<patternlist>\n";
	print FILE_JML "<title>Vanilla Siteswaps (Probert)</title>\n";
	print FILE_JML "<line display=\"========================================\"/>\n";	   
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\"/>\n";	   	
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$balls."\"/>\n";	   	
	if ($heightss == -1) {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\"/>\n";	   
	} else {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$heightss."\"/>\n";	   	
	}
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\"/>\n";	   
	if ($opt =~ "-p") {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\"/>\n";	   
	}
        print FILE_JML "<line display=\"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]"."\"/>\n";	   
	print colored [$common::COLOR_RESULT],"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]"."\n";	   
	print FILE_JML "<line display=\"========================================\"/>\n";	   
	print FILE_JML "<line display=\"\"/>\n";	   
	close FILE_JML;
	
	open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
	print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
	print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
	print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
	print FILE "</applet>\n";
	close(FILE);		
    }
    else
    {
	$f =$_[4];    
	open(FILE,">>$conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "\n================================================================\n";
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\n";	
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$balls."\n";	
	if ($heightss == -1) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$heightss."\n";	
	}
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\n";
	if ($opt =~ "-p") {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\n"; 
	}
	print FILE "[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]";     
	print colored [$common::COLOR_RESULT],"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]"."\n"; 
	print FILE "\n================================================================\n\n";

	if ($opt=~"-t") {
	    print FILE "SITESWAP"."\t"."TIME REVERSED SS"."\n";	
	    print FILE "========"."\t"."================"."\n";	
	}	
    }

    if("HTML:"=~substr($_[4],0,5)) 
    {		
	open(FILE,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
	for (my $i=0; $i < scalar @res; $i++) {	    	
	    &common::displayComputingPrompt();
	    if ($opt=~"-t") {
		print FILE "<line display=\"".$res[$i]."\t\t(TR:".&inv($res[$i],-1).")";	
		print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
		print FILE ";colors=$balls_colors\" />\n";				    

	    } else {
		print FILE "<line display=\"".$res[$i];				
		print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
		print FILE ";colors=$balls_colors\" />\n";				    
	    }
	}

	print FILE "<line display=\"\" />\n";
	print FILE "<line display=\"\" />\n";
	print FILE "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
	print FILE "</patternlist>\n";
	print FILE "</jml>\n";
	close FILE;

	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
	}

	close FILE;
	&common::hideComputingPrompt();		
    }
    else
    {
	for (my $i=0; $i < scalar @res; $i++) {	    	
	    &common::displayComputingPrompt();
	    if ($opt=~"-t") {
		print FILE $res[$i]."\t\t".&inv($res[$i],-1)."\n";	
	    } else {
		print FILE $res[$i]."\n";	
	    }
	}

	close FILE;
	&common::hideComputingPrompt();
    }

} elsif (scalar @_ < 5) {
    print colored [$common::COLOR_RESULT],"\n================================================================\n";
    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\n";	    
    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$balls."\n";	
    if ($heightss == -1) {
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\n";	
    } else {
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$heightss."\n";	
    }
    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\n";
    if ($opt =~ "-p") {
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\n"; 
    }
    print colored [$common::COLOR_RESULT],"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]"; 
    print colored [$common::COLOR_RESULT],"\n================================================================\n\n";
    
    if ($opt=~"-t") {
	print colored [$common::COLOR_RESULT],"SITESWAP"."\t"."TIME REVERSED SS"."\n";	
	print colored [$common::COLOR_RESULT],"========"."\t"."================"."\n";	
    }

    for (my $i=0; $i < scalar @res; $i++) {	 
	if ($opt=~"-t") {	    
	    print $res[$i]."\t\t".&inv($res[$i],-1)."\n";	
	} else {
	    print $res[$i]."\n";	
	}
    }
}

return @res;
}


sub genScramblable
{
    my $mod = uc(shift);    
    my $ss = $_[0];
    my @res =();
    my @resF =();
    my $opts = "-1";
    my $hmax=15;
    my $nb_throws = 0;
    my @setH = ();
    
    for (my $i =0; $i <= $hmax ; $i++)
    {		
	$setH[$i] =0;	
    }
    
    if($mod eq "R" || $mod eq "A")
    {	
	$opts = $_[1];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++)
	{		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);
	shift;
	@resF=&printSSList((\@res,@_));
    }    
    elsif($mod eq "S")
    {	
	$opts = $_[1];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++)
	{		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_sync(\@setH, $nb_throws, $hmax);
	shift;
	@resF=&printSSList((\@res,@_));
    }    
    elsif($mod eq "M")
    {	
	$opts = $_[1];
	my $mult = $_[2];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++)
	{		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_mult(\@setH, $nb_throws, $hmax, $mult);
	shift;shift;	
	@resF=&printSSList((\@res,$opts,@_));
    }    
    elsif($mod eq "MS" || $mod eq "SM")
    {	
	$opts = $_[1];
	my $mult = $_[2];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++)
	{		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_mult_sync(\@setH, $nb_throws, $hmax, $mult);
	shift;shift;
	@resF=&printSSList((\@res,$opts,@_));
    }    

    return @resF;
}


sub genSSMagic
{   
    my $mod = uc(shift);    
    my @res =();
    # $_[0] is either all/every, odd/impair, even/pair; 
    my $nb_throws = $_[1]; #NbThrows
    my $f = '';
    my $opts = "-1";
    my $nbObjects=0;
    my $hmax=0;
    my @setH = ();
    my $pwd = cwd();

    if($mod eq "R" || $mod eq "A")
    {	
	$opts = $_[2];

	if($nb_throws <= 0)
	{
	    @res=();
	}
	elsif(uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL")
	{    
	    $hmax = $nb_throws -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    $setH[$i] = 1;	
		    $nbObjects += $i;
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);
	    }
	}    
	elsif(uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR")
	{    
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 == 0)
		    {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);    
	    }
	}    
	elsif(uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR")
	{
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {	    
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 != 0)
		    {
			$setH[$i] = 1;
			$nbObjects += $i;
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);    
	    }
	}

	if (scalar @_ == 4 && $_[3] != -1)
	{	    	    
	    if("HTML:"=~substr(uc($_[3]),0,5)) 
	    {
		$f =substr($_[3],5);
	    }
	    else
	    {
		$f =$_[3];
	    }	
	    
	    if("HTML:"=~substr(uc($_[3]),0,5)) 
	    {
		#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
		#dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
		mkdir($conf::RESULTS."/lib");
		copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
		copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"1.1\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>Magic Siteswaps</title>\n";
		print FILE_JML "<line display=\"Magic Siteswaps\""."/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1p"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if($opts =~ "-p") 
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL6"." : ".$nb_throws."\"/>\n";     
		if($nbObjects == int($nbObjects))
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
		}
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
		print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
		print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
		print FILE "</applet>\n";
		close(FILE);				
	    }
	    else
	    {
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if($opts =~ "-p") 
		{
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
		if($nbObjects == int($nbObjects))
		{
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
		}
		print FILE "================================================================\n\n";	
	    }
	}

	elsif(scalar @_ == 3)
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1p."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if($opts =~ "-p") 
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
	    if($nbObjects == int($nbObjects))
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	}

	shift;
	shift;	
	@res=&printSSListWithoutHeaders((\@res,@_));

	if (scalar @_ == 2 && $_[1] != -1)
	{
	    if("HTML:"=~substr(uc($_[1]),0,5)) 
	    {
		open(FILE_JML,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 $f.jml $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"   [ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\"/>\n";     
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
		print FILE_JML "</patternlist>\n";
		print FILE_JML "</jml>\n";
		close FILE_JML;
		
		if ($common::OS eq "MSWin32") {
		    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
		} else {
		    # Unix-like OS
		    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
		}
	    }
	    else
	    {
		close FILE;
	    }
	}
    }

    elsif($mod eq "M")
    {
	my $mult = $_[2];
	$opts = $_[3];

	if($nb_throws <= 0)
	{
	    @res=();
	}    
	elsif(uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL")
	{    
	    $hmax = $nb_throws -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    $setH[$i] = 1;			
		}
		@res=&__genSSFromContain_mult(\@setH, $nb_throws, $hmax,$mult);
	    }
	}
	elsif(uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR")
	{    
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 == 0)
		    {
			$setH[$i] = 1;	
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_mult(\@setH, $nb_throws, $hmax,$mult);    
	    }
	}    
	elsif(uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR")
	{
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {	    
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 != 0)
		    {
			$setH[$i] = 1;
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_mult(\@setH, $nb_throws, $hmax, $mult);    
	    }
	}

	if (scalar @_ == 5 && $_[4] != -1)
	{
	    if("HTML:"=~substr(uc($_[4]),0,5)) 
	    {
		$f =substr($_[4],5);
	    }
	    else
	    {
		$f =$_[4];
	    }	
	    
	    if("HTML:"=~substr(uc($_[4]),0,5)) 
	    {
		#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
		#dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
		mkdir($conf::RESULTS."/lib");
		copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
		copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"1.1\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"Magic Siteswaps\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1p"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if($opts =~ "-p") 
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL15"." : ".$nb_throws."\"/>\n";     				
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL16"." : ".$mult."\"/>\n";     		
		print FILE_JML "<line display=\"========================================\""."/>\n";
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
		print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
		print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
		print FILE "</applet>\n";
		close(FILE);
	    }
	    else
	    {
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if($opts =~ "-p") 
		{
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";        
		print FILE "================================================================\n\n";
	    }
	}	
	
	elsif(scalar @_ == 4)
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1p."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if($opts =~ "-p") 
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";    
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";

	}	
	
	shift;
	shift;
	shift;
	@res=&printSSListWithoutHeaders((\@res,@_));
	if (scalar @_ == 2 && $_[1] != -1)
	{	    
	    if("HTML:"=~substr(uc($_[1]),0,5)) 
	    {
		open(FILE_JML,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 $f.jml $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"   [ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\"/>\n";     
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
		print FILE_JML "</patternlist>\n";
		print FILE_JML "</jml>\n";
		close FILE_JML;

		if ($common::OS eq "MSWin32") {
		    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
		} else {
		    # Unix-like OS
		    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
		}
	    }
	    else
	    {
		close FILE;
	    }
	}
    }    

    elsif($mod eq "S")
    {
	$opts = $_[2];

	if($nb_throws <= 0)
	{
	    @res=();
	}	
	elsif(uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL")
	{    
	    # Not possible with synchronous pattern
	    @res=();	    
	}	
	elsif(uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR")
	{    
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 == 0)
		    {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;
		@res=&__genSSFromContain_sync(\@setH, $nb_throws, $hmax);    	    
	    }
	}    
	elsif(uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR")
	{
	    # Not possible with synchronous pattern
	    @res=();		    
	}
	
	if (scalar @_ == 4 && $_[3] != -1)
	{
	    if("HTML:"=~substr(uc($_[3]),0,5)) 
	    {
		$f =substr($_[3],5);
	    }
	    else
	    {
		$f =$_[3];
	    }	
	    
	    if("HTML:"=~substr(uc($_[3]),0,5)) 
	    {
		#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
		#dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
		mkdir($conf::RESULTS."/lib");
		copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
		copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"1.1\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>Magic Siteswaps</title>\n";
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"Magic Siteswaps\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1bp"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if($opts =~ "-p") 
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL6"." : ".$nb_throws."\"/>\n";     
		if($nbObjects == int($nbObjects))
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
		}
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
		print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
		print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
		print FILE "</applet>\n";
		close(FILE);		
	    }
	    else
	    {
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if($opts =~ "-p") 
		{
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
		if($nbObjects == int($nbObjects))
		{
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
		}
		print FILE "================================================================\n\n";
	    }
	}

	elsif(scalar @_ == 3)
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1bp."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if($opts =~ "-p") 
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
	    if($nbObjects == int($nbObjects))
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	}


	shift;
	shift;
	@res=&printSSListWithoutHeaders((\@res,@_));
	if (scalar @_ == 2 && $_[1] != -1)
	{
	    if("HTML:"=~substr(uc($_[1]),0,5)) 
	    {
		open(FILE_JML,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 $f.jml $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"   [ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1bp."]"."\"/>\n";     
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
		print FILE_JML "</patternlist>\n";
		print FILE_JML "</jml>\n";
		close FILE_JML;

		if ($common::OS eq "MSWin32") {
		    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
		} else {
		    # Unix-like OS
		    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
		}
	    }
	    else
	    {
		close FILE;
	    }
	}	
    }    

    elsif($mod eq "MS" || $mod eq "SM")
    {
	my $mult = $_[2];
	$opts = $_[3];

	if($nb_throws <= 0)
	{
	    @res=();
	}	
	elsif(uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL")
	{    
	    # Not possible with synchronous pattern
	    @res=();	    
	}	
	elsif(uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR")
	{    
	    $hmax = $nb_throws*2 -1;
	    if($hmax <= 15)
	    {
		for (my $i =0; $i <= $hmax ; $i++)
		{
		    if($i%2 == 0)
		    {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    }
		    else
		    {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;
		@res=&__genSSFromContain_mult_sync(\@setH, $nb_throws, $hmax, $mult);    	    		
	    }
	}    
	elsif(uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR")
	{
	    # Not possible with synchronous pattern
	    @res=();	    
	    #if((scalar @_ == 4 && $_[3] != -1) || (scalar @_ == 3))
	    #{
	    #	print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1bp."]"."\n";     
	    #}
	}
	
	if (scalar @_ == 5 && $_[4] != -1)
	{
	    if("HTML:"=~substr(uc($_[4]),0,5)) 
	    {
		$f =substr($_[4],5);
	    }
	    else
	    {
		$f =$_[4];
	    }	
	    
	    if("HTML:"=~substr(uc($_[4]),0,5)) 
	    {
		#use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
		#dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
		mkdir($conf::RESULTS."/lib");
		copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
		copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"1.1\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>Magic Siteswaps</title>\n";
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"Magic Siteswaps\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1bp"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if($opts =~ "-p") 
		{
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL15"." : ".$nb_throws."\"/>\n";     				
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL16"." : ".$mult."\"/>\n";     		
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
		print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
		print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
		print FILE "</applet>\n";
		close(FILE);		
	    }
	    else
	    {
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if($opts =~ "-p") 
		{
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";        
		print FILE "================================================================\n\n";
	    }
	}	

	elsif(scalar @_ == 4)
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1bp."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if($opts =~ "-p") 
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";    
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";

	}	

	shift;
	shift;
	shift;
	@res=&printSSListWithoutHeaders((\@res,@_));
	if (scalar @_ == 2 && $_[1] != -1)
	{
	    if("HTML:"=~substr(uc($_[1]),0,5)) 
	    {
		open(FILE_JML,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 $f.jml $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"   [ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1bp."]"."\"/>\n";     
		print FILE_JML "<line display=\"\" />\n";
		print FILE_JML "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
		print FILE_JML "</patternlist>\n";
		print FILE_JML "</jml>\n";
		close FILE_JML;

		if ($common::OS eq "MSWin32") {
		    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
		} else {
		    # Unix-like OS
		    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
		}
	    }
	}
	else
	{
	    close FILE;
	}
    }    

    return @res;

}


sub __genSSFromContain_any
{
    # Return all the (asynchronous) combination of $_[0] values. Even Invalid SS are returned
    &common::displayComputingPrompt();	    
    my @tab = @{$_[0]};		# Symbol/SS to use next
    my $p = $_[1];	        # Period
    my $hmax = $_[2];		# Height Max	  
    my @res = ();       

    if($p <= 0)
    {
     	for (my $i = 0; $i <= $hmax; $i ++)
     	{		  
     	    if($tab[$i] > 0)
     	    {		 
     		push(@res,sprintf("%x",$i));
     	    }		  
     	}
     	&common::hideComputingPrompt();	    
     	return @res;
    }

    else
    {
	for (my $i = 0; $i <= $hmax; $i ++)
	{
	    my $nbcount = $tab[$i];
	    if($nbcount > 0)
	    {		
		my @tab2=@tab;
		$nbcount --;
		$tab2[$i]=$nbcount;
		my @subres= &__genSSFromContain_any(\@tab2,$p-1,$hmax);
		if(scalar @subres ==0)
		{
		    push(@res,sprintf("%x",$i));
		}
		else
		{
		    for(my $j =0; $j < scalar @subres; $j++)
		    {			
			push(@res,sprintf("%x",$i).$subres[$j]);			
		    }
		}		
	    }
	}
	&common::hideComputingPrompt();	    	
	return @res;
    }	
}


sub __genSSFromContain_async
{
    #Only valid SS are returned    
    my @resF = ();

    # Onlid valid SS are returned
    my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
    
    for (my $i = 0; $i < scalar @res; $i ++)
    {		  
	&common::displayComputingPrompt();	    
	if (&isValid($res[$i],-1)==1)
	{
	    push(@resF,$res[$i]);			    
	}
	
	elsif ($SITESWAP_DEBUG>=1) 			    
	{
	    print $res[$i]." => Shift Equivalence\n";
	}									 	    		  
    }
    
    &common::hideComputingPrompt();	    
    return @resF;
}



sub __genSSFromContain_mult
{
    sub __genSSFromContain_mult_single
    {    
	my $ss=$_[0];
	my $mult = $_[1];
	my @res = ();
	
	for (my $j =0; $j <= length($ss); $j++)
	{
	    my $v = substr($ss,0,$j)."[";
	    for (my $k = 2; $k < length($ss) -$j+1; $k++)
	    {	    	    	    	    
		&common::displayComputingPrompt();	    	    
		my $v2 = $v.substr($ss,$j,$k)."]".substr($ss,$j+$k);
		push(@res, $v2);
		if($mult > 1)
		{
		    my $v2 = $v.substr($ss,$j,$k)."]";
		    my @resv2= &__genSSFromContain_mult_single(substr($ss,$j+$k),$mult-1);
		    for(my $l =0; $l < scalar @resv2; $l ++)
		    {			    
			push(@res, $v2.$resv2[$l]);
		    }
		}		    
	    }		
	}     
	
	&common::hideComputingPrompt();	        
	return @res;		
    }

# Onlid valid SS are returned
my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
my $mult = $_[3];	
my @resF=@res;

for (my $i =0; $i < scalar @res; $i++)
{	    	   
    for (my $j =0; $j <= length($res[$i]); $j++)
    {
	my $v = substr($res[$i],0,$j)."[";
	for (my $k = 2; $k < length($res[$i]) -$j+1; $k++)
	{
	    my $v2 = $v.substr($res[$i],$j,$k)."]".substr($res[$i],$j+$k);
	    if (&isValid($v2,-1)==1)
	    {
		push(@resF, $v2);		    					    
	    }
	    
	    elsif ($SITESWAP_DEBUG>=1) 			    
	    {
		print $v2." => Shift Equivalence\n";
	    }						
	    
	    if($mult > 1)
	    {
		my $v2 = $v.substr($res[$i],$j,$k)."]";
		my @resv2= &__genSSFromContain_mult_single(substr($res[$i],$j+$k),$mult-1);
		for(my $l =0; $l < scalar @resv2; $l ++)
		{	
		    if (&isValid($v2.$resv2[$l],-1)==1)
		    {
			push(@resF, $v2.$resv2[$l]);			 			    
		    }

		    elsif ($SITESWAP_DEBUG>=1) 			    
		    {
			print $v2.$resv2[$l]." => Shift Equivalence\n";
		    }						
		}
	    }
	}		
    }     
}
@res = @resF;
return @res;		
}


sub __genSSFromContain_sync
{
    sub __genSSFromContain_sync_single
    {
	my $ss = $_[0];
	my @res = ();

	if ((length ($ss))% 2 != 0 || length ($ss) < 2)
	{
	    return @res;	    
	}
	elsif(length ($ss) == 2)
	{
	    my $v1 = substr($ss,0,1);
	    my $v2 = substr($ss,1,1);
	    my $v = '';
	    $v = "(".$v1.",".$v2.")";
	    push (@res, $v);
	    $v = "(".$v1."x,".$v2."x)";
	    push (@res, $v);
	    $v = "(".$v1."x,".$v2.")";
	    push (@res, $v);
	    $v = "(".$v1.",".$v2."x)";
	    push (@res, $v);		
	    return @res;	    
	}
	else
	{
	    my $v1 = substr($ss,0,1);
	    my $v2 = substr($ss,1,1);
	    my $v = '';
	    my @restmp = &__genSSFromContain_sync_single(substr($ss,2));
	    for(my $i = 0; $i < scalar @restmp; $i++)
	    {
		$v = "(".$v1.",".$v2.")".$restmp[$i];
		push (@res, $v);
		$v = "(".$v1."x,".$v2."x)".$restmp[$i];
		push (@res, $v);
		$v = "(".$v1."x,".$v2.")".$restmp[$i];
		push (@res, $v);
		$v = "(".$v1.",".$v2."x)".$restmp[$i];
		push (@res, $v);		
	    }
	    return @res;
	}	
    }

#Only valid SS are returned
my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
my @resF = ();

&common::displayComputingPrompt();	    
my @tab = @{$_[0]};		# Symbol/SS to use next
my $p = $_[1];		        # Period
my $hmax = $_[2];		# Height Max	  

for(my $i = 0; $i < scalar @res; $i++)
{
    &common::displayComputingPrompt();	    
    if(length($res[$i])%2 == 0)
    {
	my @vext = &__genSSFromContain_sync_single($res[$i]);	    	
	for(my $j=0; $j < scalar @vext; $j ++)
	{
	    if(&isValid($vext[$j],-1)==1) 
	    {
		push(@resF, $vext[$j]);	    		
	    }
	    elsif ($SITESWAP_DEBUG>=1) 
	    {
		print $vext[$j]." => Shift Equivalence\n";
	    }	
	}
    }
}

&common::hideComputingPrompt();	    	
return @resF;	
}


sub __genSSFromContain_mult_sync
{
    sub __genSSFromContain_mult_sync_all_mult
    {
	# Return all possible siteswap (appending x to different values) from a multiplex one
	my $ss = $_[0];
	my @res = ();
	
	if(length($ss) == 0)
	{
	    return @res;
	}
	
	if(length($ss) == 1)
	{
	    my $v = substr($ss,0,1);
	    push(@res,$v);
	    push(@res,$v."x");
	    return @res;
	}
	
	if((substr($ss,0,1) eq '[' && substr($ss,length ($ss) -1,1) ne "]") 
	   || (substr($ss,0,1) ne '[' && substr($ss,length ($ss) -1,1) eq "]"))
	{
	    return -1;
	}
	
	if((substr($ss,0,1) eq '[' && substr($ss,length ($ss) -1,1) eq "]"))
	{
	    my $v = substr($ss,1,1);
	    my @restmp=&__genSSFromContain_mult_sync_all_mult(substr($ss,2,length($ss)-3));
	    for (my $j =0; $j < scalar(@restmp); $j++)
	    {
		push(@res,"[".$v.$restmp[$j]."]");
		push(@res,"[".$v."x".$restmp[$j]."]");
	    }	    
	}
	else
	{
	    my $v = substr($ss,0,1);
	    my @restmp=&__genSSFromContain_mult_sync_all_mult(substr($ss,1,length($ss)-1));
	    for (my $j =0; $j < scalar(@restmp); $j++)
	    {
		push(@res,$v.$restmp[$j]);
		push(@res,$v."x".$restmp[$j]);
	    }
	}
	
	return @res;
    }

sub __genSSFromContain_mult_sync_a_single()
{   
    # Return all available Multiplexes from a vanilla ss (valid or not)
    my $ss= $_[0];
    my $mult = $_[1];
    my @res = ();
    
    for (my $j =0; $j <= length($ss); $j++)
    {
	my $v = substr($ss,0,$j)."[";
	for (my $k = 2; $k < length($ss) -$j+1; $k++)
	{	    	    	    	    
	    &common::displayComputingPrompt();	    	    
	    my $v2 = $v.substr($ss,$j,$k)."]".substr($ss,$j+$k);
	    push(@res, $v2);
	    if($mult > 1)
	    {
		my $v2 = $v.substr($ss,$j,$k)."]";
		my @resv2= &__genSSFromContain_mult_sync_a_single(substr($ss,$j+$k),$mult-1);
		for(my $l =0; $l < scalar @resv2; $l ++)
		{			    
		    push(@res, $v2.$resv2[$l]);
		}
	    }		    
	}		
    }     
    
    &common::hideComputingPrompt();	        
    return @res;		
}

sub __genSSFromContain_mult_sync_b_single
{
    # Return all available Synchronous from a Multiplex ss (valid or not)
    
    sub __genSSFromContain_mult_sync_b_single_in
    {
	my @ss=@{$_[0]};
	my @res = ();
	if (scalar @ss % 2 != 0 || scalar @ss == 0)
	{
	    return @res;
	}
	elsif (scalar @ss == 2)
	{
	    my $v1 = $ss[0];
	    my $v2 = $ss[1];
	    my @extandv1 = &__genSSFromContain_mult_sync_all_mult($v1);
	    my @extandv2 = &__genSSFromContain_mult_sync_all_mult($v2);
	    for (my $i=0; $i < scalar @extandv1; $i++)
	    {
		for (my $j=0; $j < scalar @extandv2; $j++)
		{
		    push(@res,"(".$extandv1[$i].",".$extandv2[$j].")");		  
		}
	    }
	    return @res;
	}
	else
	{
	    my @ssn = @ss[2..scalar @ss-1];
	    my @restmp = &__genSSFromContain_mult_sync_b_single_in(\@ssn);
	    for(my $i=0; $i < scalar @restmp; $i++)
	    {
		my $v1 = $ss[0];
		my $v2 = $ss[1];
		my @extandv1 = &__genSSFromContain_mult_sync_all_mult($v1);
		my @extandv2 = &__genSSFromContain_mult_sync_all_mult($v2);
		for (my $i=0; $i < scalar @extandv1; $i++)
		{
		    for (my $j=0; $j < scalar @extandv2; $j++)
		    {
			push(@res,"(".$extandv1[$i].",".$extandv2[$j].")".$restmp[$i]);
		    }
		}	
	    }
	    return @res;
	}
	
    }

my $ss=$_[0];
my @res = ();
my $cpt = 0;
my $multiplex=-1;
# split the times
for(my $i =0; $i<length($ss);$i++)
{
    if(substr($ss,$i,1) eq "]")
    {
	$multiplex=-1;
	$res[$cpt]=$res[$cpt]."]";
	$cpt++;
    }
    elsif(substr($ss,$i,1) eq "[")
    {
	$res[$cpt]="[";
	$multiplex=1;
    }
    else
    {
	if($multiplex == -1)
	{
	    $res[$cpt]=substr($ss,$i,1);
	    $cpt ++;
	}
	else
	{
	    $res[$cpt]=$res[$cpt].substr($ss,$i,1);
	}
    }
}

my @resF=&__genSSFromContain_mult_sync_b_single_in(\@res);

return @resF;

}


# Onlid valid SS are returned
my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
my $mult = $_[3];	
my @resF=();

for (my $i =0; $i < scalar @res; $i++)
{	    	
    my @res_mult= &__genSSFromContain_mult_sync_a_single($res[$i],$mult);
    for(my $j =0; $j < scalar @res_mult; $j ++)
    {	
	my @res_mult_sync= &__genSSFromContain_mult_sync_b_single($res_mult[$j]);
	for(my $k =0; $k < scalar @res_mult_sync; $k ++)
	{
	    if (&isValid($res_mult_sync[$k],-1)==1)
	    {
		push(@resF, $res_mult_sync[$k]);			 			    
	    }
	    
	    elsif ($SITESWAP_DEBUG>=1) 			    
	    {
		print $res_mult_sync[$k]." => Shift Equivalence\n";
	    }						
	}
    }
}		

@res = @resF;
return @res;		
}


sub printSSList
{
    my @res = @{$_[0]};
    my $pwd = cwd();

    if (scalar @_ == 3 && $_[2] != -1)
    {
	my $f = $_[2];
	if("HTML:"=~substr(uc($_[2]),0,5)) 
	{	
	    #use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);
	    #dircopy("./data/JugglingLab/bin",$conf::RESULTS."/lib");	    	    
	    mkdir($conf::RESULTS."/lib");
	    copy("./data/lib/JugglingLab.jar",$conf::RESULTS."/lib/JugglingLab.jar");	    	    
	    copy("./data/lib/JugglingLab_0.5.3.jar",$conf::RESULTS."/lib/JugglingLab_0.5.3.jar");	    	    

	    $f = substr($_[2],5);
	    open(FILE_JML,"> $conf::RESULTS/$f.jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"1.1\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>Siteswaps</title>\n";
	    #print FILE_JML "<line display=\"========================================\""."/>\n";	   	    
	    #print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
	    print FILE "<applet archive=\"./lib/JugglingLab_0.5.3.jar\" code=\"JugglingLab\" width=\"850\" height=\"500\" >\n";
	    print FILE "<param name=\"config\" value=\"entry=none;view=edit\"/> \n";
	    print FILE "<param name=\"jmlfile\" value=\"$f.jml\"/> \n";
	    print FILE "</applet>\n";
	    close(FILE);	    
	}
    }

    @res = &printSSListWithoutHeaders(@_);
    if (scalar @_ == 3 && $_[2] != -1)
    {
	my $f = $_[2];
	if("HTML:"=~substr(uc($_[2]),0,5)) 
	{	
	    $f = substr($_[2],5);
	    open(FILE_JML,">> $conf::RESULTS/$f.jml") || die ("$lang::MSG_GENERAL_ERR1 $f.jml $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<line display=\"\" />\n";
	    print FILE_JML "<line display=\"   [ => ".(scalar @res)." (Siteswap(s)]"."\"/>\n";     
	    print FILE_JML "<line display=\"\" />\n";
	    print FILE_JML "<line display=\"----------- Created by JTB (Module SITESWAP $SITESWAP_VERSION)\" />\n";		
	    print FILE_JML "</patternlist>\n";
	    print FILE_JML "</jml>\n";
	    close FILE_JML;

	    if ($common::OS eq "MSWin32") {
		system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
	    } else {
		# Unix-like OS
		system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");
	    }
	}
    }

}



sub printSSListWithoutHeaders
{      
    my @res = @{$_[0]};
    # options : 
    # -p1 : remove redundancies, -p2 : remove redundancies (ground states prefered), 
    # -e : show if states are excited, -s : sort by number of objects, 
    # -i : info (number of objects/Period) 
    my $opts = $_[1];       
    my $nbObjects = 0;
    my @resF = ();
    my %hashTableSS = ();

    my $xmarge = 30;
    
    if (scalar @_ == 3 && $_[2] != -1)
    {
	my $f = $_[2];
	if("HTML:"=~substr(uc($_[2]),0,5)) 
	{
	    $f=substr($_[2],5).".jml";
	}
	open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
    }	
    
    if($opts =~ "-p2") 
    {	
	for (my $i = 0; $i < scalar @res; $i++) 
	{	    
	    if(&isValid($res[$i],-1)==1)
	    {
		# remove redundancies (First entry is the good one)
		my $drap = -1;
		for (my $j =0; $j < scalar @resF; $j++)
		{
		    &common::displayComputingPrompt();	    
		    if ($resF[$j] eq "-1")
		    {
			next;
		    }
		    
		    if(&isEquivalent($resF[$j],$res[$i],-1)==1)		    
		    {
			if(&getSSstatus($resF[$j],-1) eq "GROUND")			    
			{
			    #do nothing
			    $drap = 1;			   
			}
			
			elsif(&getSSstatus($res[$i],-1) eq "GROUND")
			{
			    if ($SITESWAP_DEBUG>=1) {
				if (scalar @_ == 3 && $_[2] != -1 || scalar @_ == 2)
				{					
				    print FILE $resF[$j]." => Shift Equivalence\n";
				}
			    }
			    $resF[$j] = "-1";			    
			}								
			else
			{
			    if ($SITESWAP_DEBUG>=1) {
				if (scalar @_ == 3 && $_[2] != -1 || scalar @_ == 2)
				{
				    print FILE $res[$i]." => Shift Equivalence\n";
				}
			    }
			    $drap = 1;			    
			}
			last;
		    }		    		    
		}
		
		if($drap == -1)
		{
		    push(@resF, $res[$i]);		    
		}		 
	    }
	}

	&common::hideComputingPrompt();	    
	my @resF2 =();
	for (my $i = 0; $i < scalar @resF; $i++) 
	{
	    if (scalar @_ == 3 && $_[2] != -1)
	    {
		&common::displayComputingPrompt();	    
	    }

	    if($resF[$i] ne "-1")
	    {
		$nbObjects = &getObjNumber($resF[$i],-1);
		my $period = &getPeriod($resF[$i],-1);
		if($opts =~ "-e") 
		{			
		    if($opts =~ "-s") 
		    {	
			if( exists( $hashTableSS{$nbObjects} ) )
			{
			    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$resF[$i];			    
			}
			else
			{
			    $hashTableSS{$nbObjects} = $resF[$i];			    
			}					
		    }
		    else 
		    {		
			if($opts =~ "-i") 
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    if(&getSSstatus($resF[$i],-1) eq "GROUND")
				    {
					print FILE "<line display=\"  $resF[$i]".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				    {
					print FILE "<line display=\"* $resF[$i] *".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    else
				    {
					print FILE "<line display=\"? $resF[$i] ?".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				}
				else
				{
				    if(&getSSstatus($resF[$i],-1) eq "GROUND")
				    {
					print FILE "  ".$resF[$i].(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				    }
				    elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				    {
					print FILE "* ".$resF[$i]." *".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";		
				    }
				    else
				    {
					print FILE "? ".$resF[$i]." ?".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";		
				    }
				}
			    } elsif (scalar @_ == 2)
			    {
				if(&getSSstatus($resF[$i],-1) eq "GROUND")
				{
				    print "  ".$resF[$i].(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
				elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				{
				    print "* ".$resF[$i]." *".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
				else
				{
				    print "? ".$resF[$i]." ?".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    if(&getSSstatus($resF[$i],-1) eq "GROUND")
				    {
					print FILE "<line display=\" $resF[$i]";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				    {
					print FILE "<line display=\"* $resF[$i] *";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    else
				    {
					print FILE "<line display=\"? $resF[$i] ?";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				}
				else
				{
				    if(&getSSstatus($resF[$i],-1) eq "GROUND")
				    {
					print FILE "  ".$resF[$i]."\n";
				    }
				    elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				    {
					print FILE "* ".$resF[$i]." *"."\n";
				    }
				    else
				    {
					print FILE "?  ".$resF[$i]." ?"."\n";
				    }
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				if(&getSSstatus($resF[$i],-1) eq "GROUND")
				{
				    print "  ".$resF[$i]."\n";
				}
				elsif(&getSSstatus($resF[$i],-1) eq "EXCITED")
				{
				    print "* ".$resF[$i]." *"."\n";
				}
				else
				{
				    print "? ".$resF[$i]." ?"."\n";
				}
			    }
			}
		    }
		}
		else
		{
		    if($opts =~ "-s") 
		    {	
			if( exists( $hashTableSS{$nbObjects} ) )
			{
			    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$resF[$i];			    
			}
			else
			{
			    $hashTableSS{$nbObjects} = $resF[$i];			    
			}					
		    }

		    elsif($opts =~ "-i") 
		    {
			if (scalar @_ == 3 && $_[2] != -1)
			{
			    if("HTML:"=~substr(uc($_[2]),0,5)) 
			    {
				print FILE "<line display=\"  $resF[$i]".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
				print FILE ";colors=$balls_colors\" />\n";				    
			    }
			    else
			    {
				print FILE $resF[$i].(' ' x ($xmarge - length(@resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }
			}
			elsif (scalar @_ == 2)
			{
			    print $resF[$i].(' ' x ($xmarge - length(@resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			}
		    }
		    else
		    {
			if (scalar @_ == 3 && $_[2] != -1)
			{
			    if("HTML:"=~substr(uc($_[2]),0,5)) 
			    {
				print FILE "<line display=\"  $resF[$i]".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				print FILE "\" notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
				print FILE ";colors=$balls_colors\" />\n";				    
			    }
			    else
			    {
				print FILE $resF[$i]."\n";
			    }
			}
			elsif (scalar @_ == 2)
			{
			    print $resF[$i]."\n";
			}			
		    }
		}
		
		push(@resF2,$resF[$i]);
	    }
	}
	@resF=@resF2;
    }
    
    else
    {
	for (my $i = 0; $i < scalar @res; $i++) {	

	    if (scalar @_ == 3 && $_[2] != -1)
	    {
		&common::displayComputingPrompt();	    
	    }
	    
	    if(&isValid($res[$i],-1)==1)
	    {			    
		if($opts =~ "-p1") 
		{
		    # remove redundancies (First entry is the good one)
		    my $drap = -1;
		    for (my $j =0; $j < scalar @resF; $j++)
		    {
			if (scalar @_ == 3 && $_[2] != -1)
			{
			    &common::displayComputingPrompt();	    
			}

			if(&isEquivalent($resF[$j],$res[$i],-1)==1) 
			{
			    if ($SITESWAP_DEBUG>=1) {
				if (scalar @_ == 3 && $_[2] != -1 || scalar @_ == 2)
				{
				    print $res[$i]." => Shift Equivalence\n";
				} 
			    }		
			    $drap = 1;			
			    last;
			}
		    }
		    if($drap == -1)
		    {
			push(@resF, $res[$i]);
			$nbObjects = &getObjNumber($res[$i],-1);
			my $period = &getPeriod($res[$i],-1);
			if($opts =~ "-e") 
			{
			    if($opts =~ "-s") 
			    {	
				if( exists( $hashTableSS{$nbObjects} ) )
				{
				    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				}
				else
				{
				    $hashTableSS{$nbObjects} = $res[$i];			    
				}					
			    }
			    else
			    {		       	    
				if($opts =~ "-i") 
				{
				    if (scalar @_ == 3 && $_[2] != -1)
				    {
					if("HTML:"=~substr(uc($_[2]),0,5)) 
					{
					    if(&getSSstatus($res[$i],-1) eq "GROUND")
					    {
						print FILE "<line display=\"  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
						print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   
					    }
					    else
					    {
						print FILE "<line display=\"* $res[$i] *".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
						print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   
					    }
					}
					else
					{
					    if(&getSSstatus($res[$i],-1) eq "GROUND")
					    {
						print FILE "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
					    }
					    else
					    {
						print FILE "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
					    }
					}
				    }
				    elsif (scalar @_ == 2)
				    {
					if(&getSSstatus($res[$i],-1) eq "GROUND")
					{
					    print "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
					}
					else
					{
					    print "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
					}
				    }					
				}
				else
				{
				    if (scalar @_ == 3 && $_[2] != -1)
				    {
					if("HTML:"=~substr(uc($_[2]),0,5)) 
					{
					    if(&getSSstatus($res[$i],-1) eq "GROUND")
					    {
						print FILE "<line display=\"  $res[$i]";
						print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   
					    }
					    else
					    {
						print FILE "<line display=\"* $res[$i] *";
						print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   											    
					    }
					}
					else
					{
					    if(&getSSstatus($res[$i],-1) eq "GROUND")
					    {
						print FILE "  ".$res[$i]."\n";
					    }
					    else
					    {
						print FILE "* ".$res[$i]." *"."\n";
					    }
					}
				    }
				    elsif (scalar @_ == 2)
				    {
					if(&getSSstatus($res[$i],-1) eq "GROUND")
					{
					    print "  ".$res[$i]."\n";
					}
					else
					{
					    print "* ".$res[$i]." *\n";
					}
				    }				
				}
			    }
			}
			else
			{
			    if($opts =~ "-s") 
			    {	
				if( exists( $hashTableSS{$nbObjects} ) )
				{
				    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				}
				else
				{
				    $hashTableSS{$nbObjects} = $res[$i];			    
				}					
			    }
			    elsif($opts =~ "-i") 
			    {
				if (scalar @_ == 3 && $_[2] != -1)
				{
				    if("HTML:"=~substr(uc($_[2]),0,5)) 
				    {
					print FILE "<line display=\"  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					print FILE ";colors=$balls_colors\" />\n";				   
				    }
				    else
				    {
					print FILE $res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				    }
				}
				elsif (scalar @_ == 2)
				{
				    print $res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}				    				    				    
			    }
			    else
			    {
				if (scalar @_ == 3 && $_[2] != -1)
				{
				    if("HTML:"=~substr(uc($_[2]),0,5)) 
				    {
					print FILE "<line display=\"$res[$i]";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					print FILE ";colors=$balls_colors\" />\n";				   
				    }
				    else
				    {
					print FILE $res[$i]."\n";
				    }
				}
				elsif (scalar @_ == 2)
				{
				    print $res[$i]."\n";  
				}				 
			    }
			}
			
		    }
		}
		
		else
		{
		    push(@resF, $res[$i]);
		    $nbObjects = &getObjNumber($res[$i],-1);
		    my $period = &getPeriod($res[$i],-1);
		    if($opts =~ "-e") 
		    {			
			if($opts =~ "-s") 
			{	
			    if( exists( $hashTableSS{$nbObjects} ) )
			    {
				$hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
			    }
			    else
			    {
				$hashTableSS{$nbObjects} = $res[$i];			    
			    }								   
			}
			elsif($opts =~ "-i") 
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				    {
					print FILE "<line display=\"  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					print FILE ";colors=$balls_colors\" />\n";				   
				    }
				    else
				    {
				    }
				}
				else
				{
				    if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				    {
					print FILE "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				    }
				    else
				    {
					print FILE "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";		   
				    }
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				{
				    print "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";  
				}
				else
				{
				    print "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";  
				}
			    }
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				    {
					print FILE "<line display=\"  $res[$i] ";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					print FILE ";colors=$balls_colors\" />\n";				   
				    }
				    else
				    {
					print FILE "<line display=\"* $res[$i] *";
					print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					print FILE ";colors=$balls_colors\" />\n";				   
				    }
				}
				else
				{
				    if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				    {
					print FILE "  ".$res[$i]."\n";
				    }
				    else
				    {
					print FILE "* ".$res[$i]." *\n";
				    }
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				if(&getSSstatus($res[$i],-1) eq "GROUND")			    
				{
				    print "  ".$res[$i]."\n";
				}
				else
				{
				    print "* ".$res[$i]." *\n";  					
				}
			    }
			}
		    }
		    
		    else
		    {
			if($opts =~ "-s") 
			{		
			    if( exists( $hashTableSS{$nbObjects} ) )
			    {
				$hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
			    }
			    else
			    {
				$hashTableSS{$nbObjects} = $res[$i];			    
			    }								   			    		    
			}
			elsif($opts =~ "-i") 
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE $res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print $res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }
			    
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"$res[$i]";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$i]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{					
				    print FILE $res[$i]."\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print $res[$i]."\n";  
			    }
			}
		    }
		}
		
	    }
	    else
	    {
		if ($SITESWAP_DEBUG>=1) {
		    if (scalar @_ == 3 && $_[2] != -1  || scalar @_ == 2)
		    {
			print "  ".$res[$i]." => Invalid\n";			    
		    }

		}
		
	    }	
	}
    }

    if($opts =~ "-s") 
    {
	# while (my ($key, $val) = each(%hashTableSS)) 
	# {
	# 	print "========== ".$key." ==============\n";
	# 	@res = split(/:/,$val);
	# 	for(my $j =0; $j < scalar @res; $j++)
	# 	{
	# 	    print $res[$j]."\n";
	# 	}   
	# 	print "\n";
	# }

	for my $nbObjects (sort sort_num keys(%hashTableSS)) 
	{
	    if (scalar @_ == 3 && $_[2] != -1)
	    {
		&common::displayComputingPrompt();	    		
		if("HTML:"=~substr(uc($_[2]),0,5)) 
		{		    
		    print FILE "<line display=\"============== ".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17." ==============\"/>\n";
		}
		else
		{
		    print FILE "============== ".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17." ==============\n";
		}
	    }
	    elsif (scalar @_ == 2)
	    {
		print "============== ".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17." ==============\n";
	    }
	    

	    my $val = $hashTableSS{ $nbObjects };
	    @res = split(/:/,$val);
	    for(my $j =0; $j < scalar @res; $j++)
	    {
		if (scalar @_ == 3 && $_[2] != -1)
		{
		    &common::displayComputingPrompt();	    
		}

		if($opts =~ "-e") 
		{
		    if($opts =~ "-i") 
		    {
			my $period = &getPeriod($res[$j],-1);
			if(&getSSstatus($res[$j],-1) eq "GROUND")
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"  $res[$j]".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }				
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"* $res[$j] *".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }			    
			}
			
		    }
		    else
		    {

			if(&getSSstatus($res[$j],-1) eq "GROUND")
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"  $res[$j]";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "  ".$res[$j]." \n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "  ".$res[$j]." \n";
			    }
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"* $res[$j] *";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "* ".$res[$j]." *\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "* ".$res[$j]." *\n";
			    }				
			}
		    }
		}
		
		else
		{
		    if($opts =~ "-i") 
		    {
			my $period = &getPeriod($res[$j],-1);
			if(&getSSstatus($res[$j],-1) eq "GROUND")
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"  $res[$j]".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }				
			}
			else
			{
			    if (scalar @_ == 3 && $_[2] != -1)
			    {
				if("HTML:"=~substr(uc($_[2]),0,5)) 
				{
				    print FILE "<line display=\"*  $res[$j] *".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			    elsif (scalar @_ == 2)
			    {
				print "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }
			    
			}
			
		    }
		    else
		    {
			if (scalar @_ == 3 && $_[2] != -1)
			{
			    if("HTML:"=~substr(uc($_[2]),0,5)) 
			    {
				print FILE "<line display=\"$res[$j]";
				print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				print FILE ";colors=$balls_colors\" />\n";				   
			    }
			    else
			    {
				print FILE $res[$j]."\n";
			    }
			}
			elsif (scalar @_ == 2)
			{
			    print $res[$j]."\n";
			}	
		    }		
		}
	    }

	    if (scalar @_ == 3 && $_[2] != -1)
	    {
		if("HTML:"=~substr(uc($_[2]),0,5)) 
		{				 
		}
		else
		{
		    print FILE "\n";
		}
	    }
	    elsif (scalar @_ == 2)
	    {
		print "\n";
	    }
	}	    
    }


    if (scalar @_ == 3 && $_[2] != -1)
    {
	&common::hideComputingPrompt();	    
	if("HTML:"=~substr(uc($_[2]),0,5)) 
	{				 
	}
	else
	{
	    print FILE "\n[ => ".(scalar @resF)." Siteswap(s)]"."\n";     
	}
	close FILE;
	print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @resF)." Siteswap(s)]"."\n";     

    }
    elsif (scalar @_ == 2)
    {
	print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @resF)." Siteswap(s)]"."\n";     
    }            
    
    return @resF;    
}



sub genSSMagicStadler
{
    my $p_max = $_[0];		# Period Maximum
    my $opts = $_[1];
    my @res =();
    my $f = "";

    # Partial But Quick Generation. Some Magic SS are not given by this algo
    for (my $p = 1; $p <= $p_max; $p +=2) {
	@res =();
	my $nbObjects=(($p-1)*($p)/2)/$p;
	if (scalar @_ == 3 && $_[2] != -1)
	{
	    my $f = $_[2];
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE "\n================================================================\n";	   
	    print FILE "-- MAGIC SITESWAPS (Stadler Algorithm) --\n";	   
	    print FILE $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";	    
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects;
	    print FILE "\n================================================================\n";	    
	}
	elsif (scalar @_ == 2)
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    	    
	    print colored [$common::COLOR_RESULT], "-- MAGIC SITESWAPS (Stadler Algorithm) --\n";	   
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects;
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";	    
	}
	
	for (my $q = 2; $q < $p;$q++) {
	    my $ss = "";
	    for (my $k =0; $k < $p ; $k++) {
		$ss = $ss.sprintf("%x",(($q-1)*$k )% $p);
	    }	    	 	    
	    
	    if($opts =~ '-e')
	    {
		if(&getSSstatus($ss,-1) eq "GROUND")	       
		{
		    if (scalar @_ == 3 && $_[2] != -1)
		    {
			print FILE "  ".$ss."\n";
		    }
		    elsif (scalar @_ == 2)
		    {
			print "  ".$ss."\n";
		    }
		}
		else
		{
		    if (scalar @_ == 3 && $_[2] != -1)
		    {
			print FILE "*  ".$ss." *\n";
		    }
		    elsif (scalar @_ == 2)
		    {
			print "*  ".$ss." *\n";
		    }
		}
	    }
	    else
	    {
		if (scalar @_ == 3 && $_[2] != -1)
		{
		    print FILE $ss."\n";
		}
		elsif (scalar @_ == 2)
		{
		    print $ss."\n";
		}
	    }

	    push(@res,$ss);
	}

	if (scalar @_ == 3 && $_[2] != -1)
	{
	    print FILE "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\n";     
	    close FILE;
	}
	elsif (scalar @_ == 2)
	{
	    print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\n";     
	}
    }
    
    return @res;
}


sub genSSPerm
{
    # Permutation Vector Generation
    sub __genPerm
    {	  
	my $p = $_[0];
	my @tab_p = ();
	my @res =();
	my $cpt = -1;
	if (scalar @_ == 1) {
	    for (my $i=0 ; $i < $p ;$i++) {
		$tab_p[$i]=0;
	    }
	    $cpt = $p;
	} else {
	    $cpt = $_[1];
	    @tab_p=@{$_[2]};
	}

	for (my $i=0 ; $i < $p ;$i++) {
	    if ($tab_p[$i]==0) {
		my @tab_tmp = @tab_p;
		my $cpt_tmp = $cpt -1;		 		  
		if ($cpt_tmp > 0) {
		    $tab_tmp[$i] = 1;
		    my @restmp = &__genPerm($p,$cpt_tmp,\@tab_tmp);
		    for (my $j=0;$j<scalar @restmp; $j ++) {
			push(@res, $i.$restmp[$j]);			  
		    }
		} else {
		    push(@res,$i);		      
		}
	    }
	}	  	
	return @res;
    }


sub __compute_new_vector_init
{
    my $v= $_[0];		# Originel vector
    my $p= $_[1];
    my @res = ();
    for (my $i=0; $i < length $v; $i++) {
	$res[$i]=(hex(substr($v,$i,1))-$i)%$p;		
    }
    return join('',@res);
}

sub __compute_vector_Q
{
    # Give all possible Multiplex according to a Max SS high and the multiplex size.
    my $balls=$_[0];
    my $period=$_[1];    

    my @res=();
    my @restmp =();
    
    for (my $i=0; $i < $period; $i++) {
	&common::displayComputingPrompt();
	@restmp =();
	for (my $j=0; $j <= $balls; $j++) {
	    &common::displayComputingPrompt();
	    if (@res == 0) {
		push(@restmp, sprintf("%x",$j));	       
	    } else {
		foreach my $el (@res) {
		    my $sum = 0;
		    for (my $k =0; $k < length $el; $k++) {
			$sum += hex(substr($el,$k,1));			 
		    }
		    if ($sum <= $balls) {			 
			my $v = $el.sprintf("%x",$j);			
			push(@restmp, $v );
		    }
		}
	    }
	}
	
	@res=@restmp;
    }
    
    @res = array_del_duplicate(@res);
    my @resF = ();

    foreach my $el (@res) {
	my $sum = 0;		
	for (my $k =0; $k < length($el); $k++) {
	    $sum += hex(substr($el,$k,1));			 
	}
	if ($sum == $balls) {
	    #push(@resF,sprintf("%x",$el));
	    push(@resF,$el);
	}
    }
    
    &common::hideComputingPrompt();	      
    return @resF;
}


my $balls = $_[0];
my $p =$_[1];
my @resSS=();

# Gen the all possible permutations vectors P
my @permut = &__genPerm($p);

if ($SITESWAP_DEBUG>=2) {
    print "=== Permutations\n";
    for (my $i = 0; $i < scalar @permut; $i++)
    {
	print $permut[$i]."\n";
    }
    print "\n";
}

# Gen P' = P - (0, 1, 2, ...) % PERIOD
my @vect_Pprim = ();
for (my $i =0; $i < scalar(@permut); $i++) {	  
    push(@vect_Pprim,(__compute_new_vector_init($permut[$i],$p)));
}

if ($SITESWAP_DEBUG>=2) {
    print "=== P' = P -(0,1,...) % Period \n";
    for (my $i = 0; $i < scalar @vect_Pprim; $i++)
    {
	print $vect_Pprim[$i]."\n";
    }
    print "\n";
}


for (my $i =0; $i < scalar @vect_Pprim; $i++) {
    # Compute the average of the new vector
    my $average = 0;
    for (my $j = 0; $j < length($vect_Pprim[$i]); $j++) {
	$average+=hex(substr($vect_Pprim[$i],$j,1));	
    }
    if ($average % $balls == 0) {
	$average=$average/$balls;
	# Compute the vectors Q related to P' 
	my @vect_Q=&__compute_vector_Q($balls - $average,$p);	
	if ($SITESWAP_DEBUG>=2) {
	    print "=== Q \n";
	}
	for (my $k =0; $k < scalar(@vect_Q); $k++) {
	    if ($SITESWAP_DEBUG>=2) {
		print "Q=".$vect_Q[$k]."\n";
	    }
	    my $v ="";
	    for (my $l =0; $l < length ($vect_Q[$k]); $l++) 
	    {
		$v=$v.(hex(substr($vect_Pprim[$i],$l,1))+$p*hex(substr($vect_Q[$k],$l,1)));
	    }	    
	    push(@resSS,$v);
	}
	if ($SITESWAP_DEBUG>=2) {
	    print "\n";
	}
    }
}
if ($SITESWAP_DEBUG>=2) {
    print "=== RES = P'+pQ  \n";
    for (my $i = 0; $i < scalar @resSS; $i++)
    {
	print $resSS[$i]."\n";
    }
    print "\n";
}

shift;
shift;

# This is not the optimum way to do it. It would be better to cut before but at least it is simple to implement 
# just be more patient ;-)
my @resF = &printSSList((\@resSS,@_));
return @resF;
}      



sub genStates
{
    my $mod = uc(shift);    
    
    if ($mod eq "R" || $mod eq "A") {
	return __gen_states_async(@_);
    } elsif ($mod eq "M") {
	return __gen_states_multiplex(@_);
    } elsif ($mod eq "S") {
	return __gen_states_sync(@_);
    } elsif ($mod eq "SM" || $mod eq "MS") {
	return __gen_states_multiplex_sync(@_);
    }    
}


sub genStatesAggr
{    
    my ($res1,$res2)= ();
    my $mod = uc(shift);    
    my $nbparams = scalar @_;
    my $balls = $_[0];
    my $highMaxss = $_[1];
    my $multiplex = $_[2];

    if ($mod eq "R" || $mod eq "A") {
	($res1, $res2) = genStates('R',$_[0],$_[1],-1);	    
    } elsif ($mod eq "M") {
	($res1, $res2)= genStates('M', $_[0],$_[1],$_[2],-1);
    } elsif ($mod eq "S") {
	($res1, $res2)= genStates('S',$_[0],$_[1],-1);	    
    } elsif ($mod eq "SM" || $mod eq "MS") {
	($res1, $res2)= genStates('MS', $_[0],$_[1],$_[2],-1);	    	
    } else {
	return -1;
    }

    my @matrix = @{$res1};
    my @states = @{$res2};   
    my $cptmax = 5;
    my $cpt = 0;
    my $modified = 1;
    
    # Do it until no more modification are possible. $cptmax is used to avoid loops  
    while ($cpt < $cptmax && $modified == 1) {
	$cpt ++;
	$modified = 0;

	#Check Row by Row if only one destination exists from a states
	my @states_to_remove = ();
	foreach my $el1 (@states) {
	    my $idx_el1 = __get_idx_state(\@states,$el1);
	    &common::displayComputingPrompt();
	    my $f = 0;
	    my $res = "";
	    my $elres = "";

	    foreach my $el2 (@states) {	
		my $idx_el2 = __get_idx_state(\@states,$el2);
		if ($matrix[$idx_el1][$idx_el2] ne "") {
		    $res = $matrix[$idx_el1][$idx_el2];
		    $elres = $el2;		    
		    $f ++;
		}	    
	    }
	    if ($f == 1 && ($elres ne $el1)) {
		$modified = 1;
		# Only one destination exists from that state
		# So update all transitions toward that state with this new state found. 
		# And enhance the siteswap for these new transitions
		# Remove that state after
		
		foreach my $el3 (@states) {
		    my $idx_el3 = __get_idx_state(\@states,$el3);
		    &common::displayComputingPrompt();
		    my $v = "";
		    if ($matrix[$idx_el3][$idx_el1] ne "") {					      		
			my $v1 = $matrix[$idx_el3][$idx_el1];
			$v1 =~ s/\s+//g;
			my $v2 = $res;
			$v2 =~ s/\s+//g;

			my @nL =  split(/;/,$v1);
			my @resL =  split(/;/,$v2);			
			$v = "";

			foreach my $id1 (@nL) {
			    foreach my $id2 (@resL) {
				if ($v eq "") {
				    $v = $id1.$id2;
				} else {
				    $v = $id1.$id2."; ".$v;
				}
			    }
			}
		    }

		    my $idx_elres=__get_idx_state(\@states,$elres);
		    if ($matrix[$idx_el3][$idx_elres] ne "") {
			if ($v ne "") {
			    $v = $v."; ";
			}
			$matrix[$idx_el3][$idx_elres] = $v.$matrix[$idx_el3][$idx_elres]; 
		    } else {
			$matrix[$idx_el3][$idx_elres] = $v; 
		    }
		}
		
		# Prepare the removing of the state no more necessary
		push(@states_to_remove,$el1);	    
	    }	    	    
	}

	# Remove the state no more necessary
	foreach my $s (@states_to_remove) {	
	    &common::displayComputingPrompt();
	    my ($param1,$param2) = __del_state(\@matrix,\@states, $s);
	    @matrix=@{$param1};
	    @states=@{$param2};
	}    
	
	#Check Column by Column if only one source exists for a state
	@states_to_remove = ();
	foreach my $el2 (@states) {
	    my $idx_el2=__get_idx_state(\@states,$el2);
	    &common::displayComputingPrompt();
	    my $f = 0;
	    my $res = "";
	    my $elres = "";
	    
	    foreach my $el1 (@states) {	    
		my $idx_el1=__get_idx_state(\@states,$el1);
		&common::displayComputingPrompt();
		if ($matrix[$idx_el1][$idx_el2] ne "") {
		    $res = $matrix[$idx_el1][$idx_el2];
		    $elres = $el1;
		    $f ++;
		}	    
	    }	
	    
	    if ($f == 1 && ($elres ne $el2)) {
		$modified = 1;
		# Only one source exists for that state		
		# So update all transitions to that state with the new states found and its destinations related. 
		# And enhance the siteswap for these new transitions
		# Remove that state after	
		foreach my $el3 (@states) {
		    my $idx_el3=__get_idx_state(\@states,$el3);
		    &common::displayComputingPrompt();
		    my $v = "";
		    if ($matrix[$idx_el2][$idx_el3] ne "") {	      
			my $v1 = $matrix[$idx_el2][$idx_el3];
			$v1 =~ s/\s+//g;
			my $v2 = $res;
			$v2 =~ s/\s+//g;
			
			my @nL =  split(/;/,$v1);
			my @resL =  split(/;/,$v2);			
			$v = "";
			
			foreach my $id1 (@resL) {
			    foreach my $id2 (@nL) {
				if ($v eq "") {
				    $v = $id1.$id2;
				} else {
				    $v = $id1.$id2."; ".$v;
				}
			    }
			}
			
			
			my $idx_elres=__get_idx_state(\@states,$elres);
			if ($matrix[$idx_elres][$idx_el3] ne "") {
			    if ($v ne "") {
				$v = $v."; ";
			    }
			    
			    $matrix[$idx_elres][$idx_el3] = $v.$matrix[$idx_elres][$idx_el3]; 
			    
			} else {
			    $matrix[$idx_elres][$idx_el3] = $v; 
			}
			
		    }		
		}	
		
		# Prepare the removing of the state no more necessary
		push(@states_to_remove,$el2);
	    }
	    
	}
	
	# Remove the state no more necessary
	foreach my $s (@states_to_remove) {	
	    &common::displayComputingPrompt();
	    ($res1,$res2) = __del_state(\@matrix,\@states, $s);
	    @matrix=@{$res1};
	    @states=@{$res2};
	}    
	
    }    
    
    &common::hideComputingPrompt();
    # Do the Printing/Writing of the results
    if (($mod eq "R" || $mod eq "A" || $mod eq "S") && $nbparams == 3 && $_[2]!=-1) {
	if ("XLS:"=~substr(uc($_[2]),0,4)) {
	    if ($mod eq "R" || $mod eq "A") {
		__write_xls_from_states(\@matrix,\@states,substr($_[2],4),"A,".$balls.",".$highMaxss.","."-1,R");  
	    } else {
		__write_xls_from_states(\@matrix,\@states,substr($_[2],4),"S,".$balls.",".$highMaxss.","."-1,R");  
	    }
	} else {	  	
	    if ($mod eq "R" || $mod eq "A") {
		__write_from_states(\@matrix,\@states,$_[2],"1,".$balls.",".$highMaxss.","."-1,R");
	    } else {
		__write_from_states(\@matrix,\@states,$_[2],"S,".$balls.",".$highMaxss.","."-1,R");
	    }
	}
    } elsif (($mod eq "M" || $mod eq "MS" || $mod eq "SM") && $nbparams == 4 && $_[3]!=-1) {
	if ("XLS:"=~substr(uc($_[3]),0,4)) {
	    if ($mod eq "M") {
		__write_xls_from_states(\@matrix,\@states,substr($_[3],4),"A,".$balls.",".$highMaxss.",".$multiplex.",R");  
	    } else {
		__write_xls_from_states(\@matrix,\@states,substr($_[3],4),"S,".$balls.",".$highMaxss.",-1,R");  
	    }
	} else {
	    if ($mod eq "M") {
		__write_from_states(\@matrix,\@states,$_[3],"A,".$balls.",".$highMaxss.",".$multiplex.",R");
	    } else {
		__write_from_states(\@matrix,\@states,$_[3],"S,".$balls.",".$highMaxss.",-1,R");
	    }
	}
    } elsif (($mod eq "R" || $mod eq "A" )&& $nbparams ==  2) {
	__write_from_states(\@matrix,\@states,"A,".$balls.",".$highMaxss.",-1,R");
    } elsif ($mod eq "S" && $nbparams ==  2) {
	__write_from_states(\@matrix,\@states,"S,".$balls.",".$highMaxss.",-1,R");	    
    } elsif ($mod eq "M" && $nbparams ==  3) {
	__write_from_states(\@matrix,\@states,"A,".$balls.",".$highMaxss.",".$multiplex.",R");
    } elsif (($mod eq "MS" || $mod eq "SM") && $nbparams ==  3) {
	__write_from_states(\@matrix,\@states,"S,".$balls.",".$highMaxss.",".$multiplex.",R");
    }
    
    return (\@matrix, \@states);    
}


sub __get_idx_state
{
    my @states=@{$_[0]};
    my $el_to_find=$_[1];
    my $cpt = 0;
    
    foreach my $el (@states) {
	if ($el eq $el_to_find) {
	    return $cpt;
	}
	$cpt ++;
    }
    
    return -1;
}


sub __del_state
{
    my @matrix=@{$_[0]};
    my @states=@{$_[1]};

    my $el_to_remove=$_[2];
    my $nbstates = scalar(@states);
    my $el_to_remove_idx=__get_idx_state(\@states,$el_to_remove);

    # Remove the column in the matrix
    for (my $i=0 ; $i<$nbstates; $i++) {		
	for (my $j=$el_to_remove_idx; $j<$nbstates-1 ; $j++) {	
	    $matrix[$i][$j]=$matrix[$i][$j+1];
	}		
    }

    # Remove the row in the matrix
    for (my $j=0 ; $j<$nbstates; $j++) {	
	for (my $i=$el_to_remove_idx; $i<$nbstates-1 ; $i++) {	
	    $matrix[$i][$j]=$matrix[$i+1][$j];
	}		
    }

    # remove the state from its list
    my @res = ();     
    foreach my $el (@states) {
	if ($el ne $el_to_remove) {
	    push(@res,$el)  
	}
    }
    
    return (\@matrix, \@res);
}



sub __write_from_states
{            
    my @matrix = @{$_[0]};
    my @states = @{$_[1]};
    my $file = "";
    my $comment = "";
    if (scalar @_ == 4) {
	$file = $_[2];
	$comment = $_[3];
    } elsif (scalar @_ == 3) {
	$comment = $_[2];
    } 

    # To Adapt the column size
    my $matrix_marge =  0;    
    my $matrix_marge_pad =  2;
    my $nbtransitions = 0;
    foreach my $i (@states) {
	my $idx_i=__get_idx_state(\@states,$i);
	if (length($i) > $matrix_marge) { 
	    $matrix_marge = length($i);
	}
	foreach my $j (@states) {
	    my $idx_j=__get_idx_state(\@states,$j);
	    if ($matrix[$idx_i][$idx_j] ne "") {
		$nbtransitions += scalar (split(/;/, $matrix[$idx_i][$idx_j]));		
	    }	    
	    if (length($matrix[$idx_i][$idx_j]) > $matrix_marge) { 
		$matrix_marge = length($matrix[$idx_i][$idx_j]);
	    }
	}	
    }   

    $matrix_marge += $matrix_marge_pad;
    
    my @col = split(/,/, $comment);
    
    print  $lang::MSG_SSWAP_WRITE_TXT_FROM_STATES2;

    if (scalar @_ == 4 && $_[2]!=-1) {
	open(FILE,">> $conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "\n================================================================\n";
	if ($col[4] eq "R" || $col[4] eq "A") {
	    print FILE $lang::MSG_SSWAP_GENAGGRSTATESASYNC_MSG1a."\n";
	} else {
	    print FILE $lang::MSG_SSWAP_GENSTATESASYNC_MSG1a."\n";
	}
	if ($col[0] eq "A") {
	    print FILE $lang::MSG_SSWAP_GENERAL1."\n";	
	} elsif ($col[0] eq "S") {
	    print FILE $lang::MSG_SSWAP_GENERAL1b."\n";		    
	}
	if ($col[1] ne "-1") {
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$col[1]."\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENERAL2b."\n";	
	}
	if ($col[2] ne "-1") {
	    print FILE $lang::MSG_SSWAP_GENERAL3." : ".$col[2]."\n";
	}
	if ($col[3] ne "-1") {
	    print FILE $lang::MSG_SSWAP_GENERAL4." : ".$col[3]."\n";
	}

	print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";
	print FILE "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";	
	print FILE "================================================================\n\n\n";	
    } elsif (scalar @_ == 3) {
	print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	if ($col[4] eq "R" || $col[4] eq "A") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENAGGRSTATESASYNC_MSG1a."\n";
	} else {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSTATESASYNC_MSG1a."\n";
	}
	if ($col[0] eq "A") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1."\n";	
	} elsif ($col[0] eq "S") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1b."\n";		    
	}
	if ($col[1] ne "-1") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$col[1]."\n";	
	} else {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2b."\n";	
	}
	if ($col[2] ne "-1") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL3." : ".$col[2]."\n";
	}
	if ($col[3] ne "-1") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL4." : ".$col[3]."\n";
	}
	print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";	
	print colored [$common::COLOR_RESULT], "==========================================================================\n\n\n";
    }
    

    my @statestmp = @states;
    unshift(@statestmp,"-1");

    foreach my $i (@statestmp) {
	foreach my $j (@statestmp) {
	    if (scalar @_ == 4) {
		&common::displayComputingPrompt();
	    }

	    if ($j eq "-1"  && $i eq "-1") {
		if (scalar @_ == 4 && $_[2]!=-1) {	      	      
		    print FILE ' ' x ($matrix_marge);	    
		} elsif (scalar @_ == 3) {
		    print  ' ' x ($matrix_marge);	    
		}
	    } elsif ($j eq "-1" && $i ne "-1") {
		if (scalar @_ == 4 && $_[2]!=-1) {
		    print FILE ' ' x ($matrix_marge - length($i)).$i;	    
		} elsif (scalar @_ == 3) {
		    print ' ' x ($matrix_marge - length($i)).$i;	    
		}
	    } elsif ($i eq "-1" && $j ne "-1") {
		if (scalar @_ == 4 && $_[2]!=-1) {
		    print FILE ' ' x ($matrix_marge - length($j)).$j;	    
		} elsif (scalar @_ == 3) {
		    print ' ' x ($matrix_marge - length($j)).$j;	    
		}
	    } else {
		if (scalar @_ == 4 && $_[2]!=-1) {
		    my $idx_i=__get_idx_state(\@states,$i);
		    my $idx_j=__get_idx_state(\@states,$j);
		    print FILE ' ' x ($matrix_marge - length($matrix[$idx_i][$idx_j])).$matrix[$idx_i][$idx_j];
		} elsif (scalar @_ == 3) {
		    my $idx_i=__get_idx_state(\@states,$i);
		    my $idx_j=__get_idx_state(\@states,$j);
		    print colored [$common::COLOR_RESULT], ' ' x ($matrix_marge - length($matrix[$idx_i][$idx_j])).$matrix[$idx_i][$idx_j];    
		}
		
	    }	
	}
	
	
	if (scalar @_ == 4 && $_[2]!=-1) {
	    print FILE "\n";
	} elsif (scalar @_ == 3) {
	    print "\n";
	}
    }
    
    if (scalar @_ == 4 && $_[2]!=-1) {
	print FILE "\n\n";
	close(FILE);	
    } elsif (scalar @_ == 3) {
	print "\n\n";
    }   

    if (scalar @_ == 4) {
	&common::hideComputingPrompt();
    }

}


sub __write_xls_from_states
{
    my @matrix = @{$_[0]};
    my @states = @{$_[1]};
    my $file = $_[2];
    my $comment = $_[3];
    my $MAXSTATES = 16500 ;	# Number max of states for setting the columns size in Excel
    # Printing Alignement
    my $starti = $EXCEL_ROW_START ;
    my $startj = $EXCEL_COL_START -1;

    use Excel::Writer::XLSX;    
    
    if (scalar @states > $MAXSTATES) {
	print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES1;
	return -1;
    }

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;

    # Create a new Excel workbook
    my $workbook =();
    if (scalar @_ == 4 && $_[2]!=-1) {
	my $f="$conf::RESULTS/$_[2]".'.xlsx';
	$workbook = Excel::Writer::XLSX->new($f) or die ("$lang::MSG_GENERAL_ERR2 <$_[2]".'.xlsx>');	
    } else {
	return -1;
    }
    
    $workbook->set_properties(
	title    => 'States/Transition Matrix',
	author   => "$common::AUTHOR",
	comments => 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (genStates)",
	);

    # Add a worksheet
    my $worksheet = $workbook->add_worksheet("Matrix="."$comment");
    
    # Add and define formats    
    # Array Headers  Format
    my $format1 = $workbook->add_format(fg_color => 'yellow');
    $format1->set_bold();
    $format1->set_color( 'red' );
    $format1->set_align( 'center' );
    $format1->set_align( 'vcenter' );
    #$format1->set_rotation( 270 );
    $format1->set_rotation( -90 );

    my $format1b = $workbook->add_format(fg_color => 'yellow');
    $format1b->set_bold();
    $format1b->set_color( 'red' );
    $format1b->set_align( 'center' );	        
    $format1b->set_align( 'vcenter' );	        
    
    my $format1c = $workbook->add_format();
    $format1c->set_bold();
    $format1c->set_color( 'red' );
    $format1c->set_align( 'center' );	        
    
    # Median Cells Format
    my $format2 = $workbook->add_format(
	fg_color => 'yellow',
	pattern  => 1,
	border   => 0
	);
    $format2->set_align( 'right' );	        

    # Symetrics Cells Format
    my $format2b = $workbook->add_format(
	fg_color => 'silver',
	pattern  => 1,
	border   => 0
	);
    $format2b->set_align( 'right' );	        
    
    my $format3 = $workbook->add_format(
	fg_color => 'magenta',
	pattern  => 1,
	border   => 0
	);
    $format3->set_align( 'center' );	        
    $format3->set_bold();

    my $format4 = $workbook->add_format(
	fg_color => 'cyan',
	pattern  => 1,
	border   => 0
	);
    $format4->set_align( 'center' );	        
    $format4->set_bold();
    
    my $format5 = $workbook->add_format(
	fg_color => 'lime',
	pattern  => 1,
	border   => 0
	);
    $format5->set_align( 'center' );	        
    $format5->set_bold();
    
    # Default format
    my $format0 = $workbook->add_format();
    $format0->set_align( 'right' );	        
    #$worksheet->set_column( 'A:Z', $conf::EXCELCOLSIZE, $format0);
    $worksheet->set_column( $startj,$startj, length($states[0]) + 2);

    # Handle Excol Column Autofit 
    my $matrix_marge_pad =  0;    
    my $nbtransitions =0;
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {	
	# To Adapt the column size	
	foreach my $j (@states) {
	    my $idx_j=__get_idx_state(\@states,$j);
	    my $matrix_marge =  6;	#Marge min
	    foreach my $i (@states) {	
		my $idx_i=__get_idx_state(\@states,$i);

		if ($matrix[$idx_i][$idx_j] ne "") {
		    if ($SITESWAP_DEBUG>=1) {
			print $i." ===".$matrix[$idx_i][$idx_j]."===> ".$j."\n";		   			
		    }
		    $nbtransitions += scalar (split(/;/, $matrix[$idx_i][$idx_j]));
		    if (length($matrix[$idx_i][$idx_j]) > $matrix_marge) { 
			$matrix_marge = length($matrix[$idx_i][$idx_j]);						
		    }		    
		}		
	    }		  
	    $worksheet->set_column( $idx_j+$startj+1,$idx_j+$startj+1, $matrix_marge + $matrix_marge_pad, $format0);
	}   
    } else {
	$worksheet->set_column( $startj+1,$MAXSTATES, $conf::EXCELCOLSIZE, $format0);
    }
    
    $worksheet->set_row( $starti, length($states[0])*8 + $matrix_marge_pad);

    my @col = split(/,/, $comment);
    if ($col[0] eq "A") {
	$worksheet->merge_range ('B2:P2', $lang::MSG_SSWAP_GENERAL1, $format1c);	
	#$worksheet->write ('H2', $lang::MSG_SSWAP_GENERAL1, $format1c);	
    } elsif ($col[0] eq "S") {
	$worksheet->merge_range ('B2:P2', $lang::MSG_SSWAP_GENERAL1b, $format1c);	
	#$worksheet->write ('H2', $lang::MSG_SSWAP_GENERAL1b, $format1c);	
    }
    if ($col[1] ne "-1") {
	$worksheet->merge_range ('B3:P3', $lang::MSG_SSWAP_GENERAL2." : ".$col[1], $format1c);	
	#$worksheet->write ('H3', $lang::MSG_SSWAP_GENERAL2." : ".$col[1], $format1c);	
    } else {
	$worksheet->merge_range ('B3:P3', $lang::MSG_SSWAP_GENERAL2b, $format1c);	
	#$worksheet->write ('H3', $lang::MSG_SSWAP_GENERAL2b, $format1c);	
    }
    if ($col[2] ne "-1") {
	$worksheet->merge_range ('B4:P4', $lang::MSG_SSWAP_GENERAL3." : ".$col[2], $format1c);
	#$worksheet->write ('H4', $lang::MSG_SSWAP_GENERAL3." : ".$col[2], $format1c);
    }
    if ($col[3] ne "-1") {
	$worksheet->merge_range ('B5:P5', $lang::MSG_SSWAP_GENERAL4." : ".$col[3], $format1c);	
	#$worksheet->write ('H5', $lang::MSG_SSWAP_GENERAL4." : ".$col[3], $format1c);	
    }
    if ($col[4] ne "-1") {
	if ($col[4] eq "R" || $col[4] eq "A") {
	    $worksheet->merge_range ('B6:P6', $lang::MSG_SSWAP_GENAGGRSTATESASYNC_MSG1a, $format1c);	
	    #$worksheet->write ('H6', $lang::MSG_SSWAP_GENAGGRSTATESASYNC_MSG1a, $format1c);	
	}
    }
    

    # Let's go for the printing ...    
    my $cptj = -1;

    foreach my $i (@states) {	  
	my $idx_i=__get_idx_state(\@states,$i);
	$worksheet->write_string( $idx_i+$starti+1, $startj, $i, $format1b);	  	  	  	
	
	foreach my $j (@states) { 	    
	    my $idx_j=__get_idx_state(\@states,$j);
	    &common::displayComputingPrompt();
	    if ($cptj==-1) {
		$worksheet->write_string( $starti, $idx_j+$startj+1, $j, $format1);
	    } else {
		$cptj==-1;
	    }
	    
	    #if(substr($matrix[$idx_i][$idx_j],0,1) =~ /+/)
	    if ($matrix[$idx_i][$idx_j] =~ /\+/ &&
		$matrix[$idx_i][$idx_j] =~ /-/) {
		$worksheet->write_string( $idx_i+$starti+1, 
					  $idx_j+$startj+1,
					  $matrix[$idx_i][$idx_j], $format5);	  	 
	    } elsif ($matrix[$idx_i][$idx_j] =~ /\+/) {
		$worksheet->write_string( $idx_i+$starti+1, 
					  $idx_j+$startj+1,
					  $matrix[$idx_i][$idx_j], $format4);	  	 
	    }
	    #elsif(substr($matrix[$idx_i][$idx_j],0,1) =~ /-/)
	    elsif ($matrix[$idx_i][$idx_j] =~ /-/) {
		$worksheet->write_string( $idx_i+$starti+1, 
					  $idx_j+$startj+1,
					  $matrix[$idx_i][$idx_j], $format3);	  	 
	    } elsif ($matrix[$idx_i][$idx_j] ne "") {
		$worksheet->write_string( $idx_i+$starti+1, 
					  $idx_j+$startj+1,
					  $matrix[$idx_i][$idx_j], $format0);	  	 
	    }	    
	}	
    }	 
    
    # Coloring for Median Cells
    my $idx_i =0;
    foreach my $i (@states) {
	#my $idx_i=__get_idx_state(\@states,$i); 
	my $w = $matrix[$idx_i][$idx_i];     
	# Thus Median Cells with transitions are wrote twice !! Not very optimum but ...
	if ($w eq "") {
	    $worksheet->write_string( $idx_i+$starti+1,
				      $idx_i+$startj+1, 
				      "", $format2);	        
	} else {
	    $worksheet->write_string( $idx_i+$starti+1, 
				      $idx_i+$startj+1, 
				      $w, $format2);	        
	}
	$idx_i ++;
	&common::displayComputingPrompt();
    }

    # Coloring for Symetric Cells
    $idx_i =0;
    foreach my $i (@states) {
	if ($i =~ ",") {
	    my @res=split(/,/,$i);
	    my $nstate=$res[1].",".$res[0];
	    my $idx_j=__get_idx_state(\@states,$nstate); 
	    my $w = $matrix[$idx_i][$idx_j];     
	    # Thus Median Cells with transitions are wrote twice !! Not very optimum but ...
	    if ($w eq "") {
		$worksheet->write_string( $idx_i+$starti+1,
					  $idx_j+$startj+1, 
					  "", $format2b);	        
	    } else {
		$worksheet->write_string( $idx_i+$starti+1, 
					  $idx_j+$startj+1, 
					  $w, $format2b);	        
	    }
	} else {
	    last;
	}

	$idx_i ++;
	&common::displayComputingPrompt();
    }	
    
    # print the number of states and transitions    
    if ($col[4] eq "-1") {
	$worksheet->merge_range ('B6:P6', "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n", $format1c);	
	#$worksheet->write ('H6', "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n", $format1c);	
    } else {
	$worksheet->merge_range ('B7:P7', "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n", $format1c);	
	#$worksheet->write ('H7', "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n", $format1c);	
    }
    &common::hideComputingPrompt();
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";	
    #$worksheet->close();    
}



sub __get_states_async
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $matrix_size=2**$highMaxss;    
    my @res = ();
    my $b="";

    # Generate all the possibles states using the Height of the SS
    for (my $i=0; $i < $matrix_size; $i++) {
	&common::displayComputingPrompt();
	my $b = substr(reverse(dec2binwith0($i)),0,$highMaxss);
	
	# Filter by checking the number of balls
	if ($_[0] == -1 || int($b =~ tr/1//) == $balls) {		
	    push(@res, $b);
	}	    			
    }
    
    &common::hideComputingPrompt();
    return sort(@res);
}


sub __get_states_multiplex
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);

    my @prev_states=();

    if (scalar @_ >= 4) {	
	@prev_states=@{$_[3]};
    }

    my $currentHigh  = 0;
    
    if (scalar @_ == 5) {
	$currentHigh = $_[4];	
    }    
    
    my $s = @prev_states;
    my @res = ();
    
    if ($currentHigh >= $highMaxss) {       
	for (my $i=0; $i < $s; $i++) {	    	    
	    &common::displayComputingPrompt();
	    my $v=pop(@prev_states);
	    
	    if ($balls != -1) {
		my $c=0;
		for (my $j =0; $j < length($v); $j++) {
		    $c += hex(substr($v,$j,1));
		}

		if ($c == $balls) {
		    push(@res,$v);	
		}		
	    } else {
		push(@res,$v);	
	    }
	}		

	&common::hideComputingPrompt();
	return sort(@res);
    }
    
    if ($s == 0) {
	for (my $i=0; $i <= $multiplex; $i++) {	    	 
	    &common::displayComputingPrompt();
	    push(@res,sprintf("%x",$i));
	}		
    } else {    
	for (my $j = 0; $j < $s; $j++) {	
	    my $v = pop(@prev_states); 	
	    for (my $i=0; $i <= $multiplex; $i++) {	    	 
		&common::displayComputingPrompt();
		push(@res,sprintf("%x",$i).$v);				    	    
	    }		
	}
    }

    &common::hideComputingPrompt();
    __get_states_multiplex($_[0], $_[1], $_[2], \@res, $currentHigh+1);
}

# Give all possible Multiplex according to a Max SS high and the multiplex size.
sub __get_multiplex
{
    my $balls = -1;
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);    
    my $nbthrows = 0;

    if ($_[0] == -1) {
	$nbthrows = $multiplex;
    } else {
	$balls = hex($_[0]);
	if ($balls < $multiplex) {
	    $nbthrows = $balls;
	} else {
	    $nbthrows = $multiplex;
	}
    }

    my @res=();
    my @restmp =();
    
    for (my $i=0; $i < $nbthrows; $i++) {
	&common::displayComputingPrompt();
	@restmp =();
	for (my $j=1; $j <= $highMaxss; $j++) {
	    &common::displayComputingPrompt();
	    if (@res == 0) {
		push(@restmp, sprintf("%x",$j));	       
	    } else {
		foreach my $el (@res) {
		    my $v = $el.sprintf("%x",$j);
		    $v = join('',reverse(sort(split(//,$v))));
		    push(@restmp, $v );
		}
	    }
	}
	@res=@restmp;
    }
    
    @res = array_del_duplicate(@res);
    &common::hideComputingPrompt();

    #foreach my $el (@res)
    #{
    #print $el."\n";
    #}

    return @res;
}


sub __get_states_sync
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=int(hex($_[1])/2);
    
    my $matrix_size=2**$highMaxss;    
    my @res = ();
    my $b="";

    # Generate all the possibles states using the Height of the SS
    for (my $i=0; $i < $matrix_size; $i++) {
	&common::displayComputingPrompt();		
	my $b1 = substr(reverse(dec2binwith0($i)),0,$highMaxss);
	for (my $j=0; $j < $matrix_size; $j++) {
	    &common::displayComputingPrompt();		
	    my $b2 = substr(reverse(dec2binwith0($j)),0,$highMaxss);	    
	    $b = $b1.$b2;
	    # Filter by checking the number of balls
	    if ($balls == -1 || int($b =~ tr/1//) == $balls && ($b1 ne "" && $b2 ne "")) {		
		push(@res, $b1.",".$b2);	
	    }	    
	}		
    }
    
    &common::hideComputingPrompt();
    return sort(@res);
}


# Give all possible Multiplex for Sync siteswap according to a Max SS high and the multiplex size.
sub __get_multiplex_sync_single
{    
    #Generation of all the possible Multiplex with 'x' from a single one
    sub __expand_multiplex_sync_single
    {	
	my $mult=$_[0];
	my @new=();
	
	if (length($mult) == 0) {	    
	    return @new;
	} elsif (length($mult) == 1) {	
	    push(@new, $mult);
	    push(@new, $mult."x");	
	    
	    return @new;
	}
	
	my @old=__expand_multiplex_sync_single(substr($mult,1));		
	foreach my $el (@old) {	
	    push(@new, substr($mult,0,1).$el);
	    push(@new, substr($mult,0,1)."x".$el);
	}
	return @new;	
    }


my $balls = $_[0];
my $highMaxss=hex($_[1]);
my $multiplex=hex($_[2]);
my @res=();
my @ret=();
my @restmp =();
my $nbthrows = 0;

if ($_[0] == -1) {
    $nbthrows = $multiplex;
} else {
    $balls = hex($_[0]);
    if ($balls < $multiplex) {
	$nbthrows = $balls;
    } else {
	$nbthrows = $multiplex;
    }
}


for (my $i=0; $i < $nbthrows; $i++) {
    @restmp =();
    for (my $j=2; $j <= $highMaxss; $j+=2) {
	if (@res == 0) {
	    push(@restmp, sprintf("%x",$j));	       	         		
	} else {
	    foreach my $el (@res) {
		my $v = $el.sprintf("%x",$j);
		$v = join('',reverse(sort(split(//,$v))));
		push(@restmp, $v );	
	    }
	}
    }
    @res=@restmp;
}

@res = array_del_duplicate(@res);

#Add all the possible Multiplex with 'x' 
foreach my $el (@res) {
    @ret=(@ret,__expand_multiplex_sync_single($el));                
}

return @ret;
}


sub __get_states_multiplex_sync
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=int(hex($_[1])/2);
    my $multiplex=hex($_[2]);
    my @prev_states=();

    if (scalar @_ >= 4) {	
	@prev_states=@{$_[3]};
    }

    my $currentHigh  = 0;
    
    if (scalar @_ == 5) {
	$currentHigh = $_[4];	
    }    
    
    my $s = @prev_states;
    my @res = ();
    
    if ($currentHigh >= $highMaxss) {       
	for (my $i=0; $i < $s; $i++) {	    	    
	    &common::displayComputingPrompt();		
	    my $v=pop(@prev_states);
	    
	    if ($balls != -1) {
		#Last and third Pruning : Final states must not exceed the max number of objects 
		my $c=0;
		for (my $j =0; $j < length($v); $j++) {		    
		    if (substr($v,$j,1) ne ',') {
			$c += hex(substr($v,$j,1))
		    }
		}
		if ($c == $balls) {		    
		    push(@res,$v);	
		}		
	    } else {
		push(@res,$v);	
	    }
	}		

	&common::hideComputingPrompt();
	return sort(@res);
    }
    
    if ($s == 0) {
	for (my $i=0; $i <= $multiplex; $i++) {	    	        	 
	    for (my $j=0; $j <= $multiplex; $j++) {
		&common::displayComputingPrompt();		
		#First Pruning : new states must not exceed the max number of objects
		if ($balls == -1 || (($i + $j) <= $balls)) {
		    push(@res,sprintf("%x",$i).",".sprintf("%x",$j));	
		}
	    }		
	}
    } else {    
	for (my $k = 0; $k < $s; $k++) {	
	    my $v = pop(@prev_states); 	
	    for (my $i=0; $i <= $multiplex; $i++) {	    	
		&common::displayComputingPrompt();		
		my $idx = rindex($v,',');		
		my $rhand=substr($v,0,$idx);
		my $lhand=substr($v,$idx+1);

		for (my $j=0; $j <= $multiplex; $j++) {	    
		    if ($balls != -1) {
			my $c=0;
			for (my $l =0; $l < length(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand); $l++) {
			    if (substr(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand,$l,1) ne '.') {
				$c += hex(substr(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand,$l,1));
			    }
			}

			if ($c <= $balls) {
			    #Second Pruning : new enhanced states must not exceed the max number of objects			    
			    push(@res,sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand); 			    
			}		
		    } else {
			push(@res,sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand); 
		    }
		}		
	    }		
	}
    }
    
    &common::hideComputingPrompt();
    __get_states_multiplex_sync($_[0], $_[1], $_[2], \@res, $currentHigh+1);
}


sub __gen_states_async
{       
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    
    my @matrix=();
    
    # Get all the possible states
    my @states=__get_states_async($_[0],$_[1]);        
    
    #build the Matrix    
    foreach my $el (@states) {       	
	&common::displayComputingPrompt();		
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	my $b = substr(reverse($el),0,$highMaxss);
	if (substr($b, 0, 1) == 0) {
	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";	    
	    my $bn3=reverse($bn);	    
	    my $idx_bn3 = __get_idx_state(\@states,$bn3);
	    if ($idx_bn3 >= 0) {
		if ($matrix[$idx_state_el][$idx_bn3] ne "") {
		    $matrix[$idx_state_el][$idx_bn3]="0; ".$matrix[$idx_state_el][$idx_bn3];
		} else {
		    $matrix[$idx_state_el][$idx_bn3]="0";
		}
	    } elsif (scalar @_ == 2 || (scalar @_ == 3 && $_[2]!=-1)) {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
	    }
	    
	    if ($balls==-1) {
		#Adding of an object
		$bn=substr($b, 1, length($b) -1);
		$bn="1".${bn};	
		$bn3=reverse($bn);
		my $idx_bn3 = __get_idx_state(\@states,$bn3);
		if ( $idx_bn3 >= 0) {
		    $matrix[$idx_state_el][$idx_bn3]="+";
		} elsif (scalar @_ == 2 || (scalar @_ == 3 && $_[2]!=-1)) {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}	    
	    }
	} else {	 
	    if ($balls==-1) {
		#Removing of an object
		my $bn=substr($b, 1, length($b) -1);
		$bn="0".${bn};
		my $bn3=reverse($bn);	    
		my $idx_bn3 = __get_idx_state(\@states,$bn3);
		if ($idx_bn3 >= 0) {
		    $matrix[$idx_state_el][$idx_bn3]="-";	 	    
		} elsif (scalar @_ == 2 || (scalar @_ == 3 && $_[2]!=-1)) {	       
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}
	    }

	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";
	    for (my $k=0; $k<length($bn); $k++) {		
		if (substr($bn, $k, 1) == 0 && $k+1 <= 15) {
		    my $bn2=substr($bn, 0, $k)."1".substr($bn, $k+1, length($bn)-$k);		    
		    my $bn3=reverse($bn2);		   
		    my $idx_bn3 = __get_idx_state(\@states,$bn3);
		    if ($idx_bn3 >= 0) {
			if ($matrix[$idx_state_el][$idx_bn3] ne "") {
			    $matrix[$idx_state_el][$idx_bn3]=sprintf("%x",($k+1))."; ".$matrix[$idx_state_el][$idx_bn3]; 	 
			} else {
			    $matrix[$idx_state_el][$idx_bn3]=sprintf("%x",($k+1));	 
			}
		    } elsif (scalar @_ == 2 || (scalar @_ == 3 && $_[2]!=-1)) {	       
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		    }
		}
	    }

	}    
    }

    &common::hideComputingPrompt();

    if (scalar @_ == 3 && $_[2]==-1) {
	return (\@matrix, \@states);
    }
    
    if (scalar @_ == 3 && $_[2]!=-1) {	
	if ("XLS:"=~substr(uc($_[2]),0,4)) {
	    __write_xls_from_states(\@matrix,\@states,substr($_[2],4),"A,".$_[0].",".$_[1].","."-1,-1");   
	} else {	    	    
	    __write_from_states(\@matrix,\@states,$_[2], "A,".$_[0].",".$_[1].","."-1,-1");
	}
       	
    } elsif (scalar @_ == 2) {	
	__write_from_states(\@matrix,\@states, "A,".$_[0].",".$_[1].","."-1,-1");
    }
    
    return (\@matrix, \@states);
}


sub __gen_states_multiplex
{   
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);
    
    my @matrix=();
    
    my @states=__get_states_multiplex($_[0], $_[1], $_[2]);	
    
    #build the Matrix    
    foreach my $el (@states) {
	&common::displayComputingPrompt();		
	my $mult=0;
	my $sum=0;
	my $nstate=-1;	    	
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	$mult = hex(substr($el,length($el)-1));
	
	if ($mult != 0) {
	    # Here the computing is slightly different.
	    # All the possible multiplexes are selected first, and according to them the new states are established.
	    my @mult_list=__get_multiplex($_[0],$_[1],substr($el,length($el)-1));
	    
	  LOOP1: foreach my $el_mult (@mult_list) {		  
	      my @nstate_tmp = reverse(split(//, "0".substr($el,0,length($el)-1)));
	      for (my $i=0; $i<length($el_mult); $i++) {
		  &common::displayComputingPrompt();
		  {
		      my $v=hex(substr($el_mult,$i,1));
		      if (hex($nstate_tmp[$v -1]) + 1 > 15) {
			  next LOOP1;
		      }			    
		      $nstate_tmp[$v -1] = sprintf("%x", (hex($nstate_tmp[$v -1]) + 1));  
		  }
	      }

	      $nstate = join('',reverse(@nstate_tmp));
	      
	      my $idx_nstate=__get_idx_state(\@states,$nstate);
	      if ($idx_nstate >= 0) {		    
		  if (length($el_mult)>=2) {
		      
		      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
			  $matrix[$idx_state_el][$idx_nstate]=
			      "[".$el_mult."], ".$matrix[$idx_state_el][$idx_nstate];			 
		      } else {
			  $matrix[$idx_state_el][$idx_nstate]="[".$el_mult."]";			 
		      }
		  } else {
		      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
			  $matrix[$idx_state_el][$idx_nstate]=$el_mult."; ".$matrix[$idx_state_el][$idx_nstate];			 
		      } else {
			  $matrix[$idx_state_el][$idx_nstate]=$el_mult;			 
		      }
		  }
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }
	  }

	    if ($balls == -1) {
		# Removing of one or several objects
		for (my $r = 1; $r <= $mult; $r ++) {
		    my $nm = $mult - $r;
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {		    
			$matrix[$idx_state_el][$idx_nstate]="-".sprintf("%x",$r);		    
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
		    }
		}
	    }	    
	} else {
	    &common::displayComputingPrompt();
	    my $idx_nstate=__get_idx_state(\@states,"0".substr($el,0,length($el)-1));
	    if ($idx_nstate >= 0) {		    
		$matrix[$idx_state_el][$idx_nstate]="0";		    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1."0".substr($el,0,length($el)-1)."\n";		    
	    }	    

	    if ($balls == -1) {
		# Adding of one or several objects
		for (my $nm = 1; $nm <= $multiplex; $nm ++) {
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {		    
			$matrix[$idx_state_el][$idx_nstate]="+".sprintf("%x",$nm);		    
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
		    }
		}
	    }	    
	}
    }

    &common::hideComputingPrompt();

    if (scalar @_ == 4 && $_[3]==-1) {
	return (\@matrix, \@states);
    }

    # Print or Write the Matrix    
    if (scalar @_ == 4 && $_[3]!=-1) {
	if ("XLS:"=~substr(uc($_[3]),0,4)) {
	    __write_xls_from_states(\@matrix,\@states,substr($_[3],4),"A,".$_[0].",".$_[1].",".$_[2].",-1");  
	} else {	    
	    __write_from_states(\@matrix,\@states,$_[3],"A,".$_[0].",".$_[1].",".$_[2].",-1");		  
	}
    } elsif (scalar @_ == 3) {	
	__write_from_states(\@matrix,\@states,"A,".$_[0].",".$_[1].",".$_[2].",-1");		  
    }

    return (\@matrix, \@states);
}


sub __gen_states_sync
{    
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my @matrix=();    
    my $nstate=();
    
    # Get all the possible states
    my @states=__get_states_sync($_[0], $_[1]);    

    #build the Matrix    
    foreach my $el (@states) {       
	&common::displayComputingPrompt();		
	my $idx = rindex($el,',');
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	my $rhand=substr($el,0,$idx);
	my $rhandth=hex(substr($rhand,length($rhand)-1));
	my $lhand=substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));

	if ($rhandth eq "0" && $lhandth eq "0") {		
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    	 	    
	    my $idx_nstates = __get_idx_state(\@states,$nstate);
	    if ($idx_nstates >=0) {
		$matrix[$idx_state_el][$idx_nstates]="(0,0)";		  	 
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
	    }

	    if ($balls == -1) {
		# Adding of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(+,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Right Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";	    	 	    
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Left Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }
	    
	} elsif ($rhandth eq "1" && $lhandth eq "1") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);
	    
	    # Start by right Hand ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "?";
		    if ($k > $idx) {
			$x = 2*(length($nstate)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x)."x" ;
		    } else {
			$x = 2*(length($rhand)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x);
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    
		    {
			# ... And then left hand ...
			for (my $l=0; $l<length($bnstate); $l++) {
			    &common::displayComputingPrompt();		
			    if (substr($bnstate, $l, 1) eq "0") {
				my $y = "?";			
				if ($l > $idx) {		
				    $y = 2*(length($nstate)-$l);
				    if ($y > $highMaxss) {
					next;
				    }
				    $y = sprintf("%x",$y);			    
				} else {
				    $y = 2*(length($rhand)-$l);
				    if ($y > $highMaxss) {
					next;
				    }
				    $y = sprintf("%x",$y)."x" ;
				}				
				my $idx_bn = __get_idx_state(\@states,substr($bnstate, 0, $l)."1".substr($bnstate, $l+1));
				if ($idx_bn >=0) {	
				    if ($matrix[$idx_state_el][$idx_bn] ne "") {
					$matrix[$idx_state_el][$idx_bn]= "(".$x.",".$y."); ".$matrix[$idx_state_el][$idx_bn];
				    } else {
					$matrix[$idx_state_el][$idx_bn]= "(".$x.",".$y.")";  
				    }
				} else {
				    &common::hideComputingPrompt();
				    #print $lang::MSG_SSWAP_GENSTATES_MSG1.substr($bnstate, 0, $l)."1".substr($bnstate, $l+1)."\n";
				}
			    }
			}
		    }
		}
	    }

	    if ($balls == -1) {
		# Removing of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(-,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(-,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstates = __get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }

	} elsif ($rhandth eq "1" && $lhandth eq "0") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);
	    
	    # Only right Hand throws ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "?";
		    my $y = "0";
		    if ($k > $idx) {
			$x = 2*(length($nstate)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x)."x" ;
		    } else {
			$x = 2*(length($rhand)-$k);
			if ($x > $highMaxss) {
			    next;
			}
			$x = sprintf("%x",$x);
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    		    
		    my $idx_bnstate = __get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {
			if ($matrix[$idx_state_el][$idx_bnstate] ne "") {
			    $matrix[$idx_state_el][$idx_bnstate]=
				"(".$x.",".$y."); ".$matrix[$idx_state_el][$idx_bnstate];
			} else {
			    $matrix[$idx_state_el][$idx_bnstate]="(".$x.",".$y.")";		    			   			
			}
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    		
	    }
	    
	    if ($balls == -1) {
		# Adding of one object (in Left Hand)
		# => Keep object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    if ($matrix[$idx_state_el][$idx_nstate] ne "") {
			$matrix[$idx_state_el][$idx_nstate]="(-,+)"."; ".$matrix[$idx_state_el][$idx_nstate];
		    } else {
			$matrix[$idx_state_el][$idx_nstate]="(-,+)";
		    }			    		  					    
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		
		# Remove only object in Right Hand and do not add object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(-,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }

	} elsif ($rhandth eq "0" && $lhandth eq "1") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    
	    
	    # Only Left Hand throws ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "0";
		    my $y = "?";
		    if ($k > $idx) {
			$y = 2*(length($nstate)-$k);
			if ($y > $highMaxss) {
			    next;
			}
			$y = sprintf("%x",$y);
		    } else {
			$y= 2*(length($rhand)-$k);
			if ($y > $highMaxss) {
			    next;
			}
			$y = sprintf("%x",$y)."x";
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    
		    my $idx_bnstate = __get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {		    
			if ($matrix[$idx_state_el][$idx_bnstate] ne "") {
			    $matrix[$idx_state_el][$idx_bnstate]="(".$x.",".$y."); ".$matrix[$idx_state_el][$idx_bnstate];
			} else {
			    $matrix[$idx_state_el][$idx_bnstate]="(".$x.",".$y.")";
			}
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    	    
	    }

	    if ($balls == -1) {
		# Adding of one object (in Right Hand)
		# => Keep object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    if ($matrix[$idx_state_el][$idx_nstate] ne "") {
			$matrix[$idx_state_el][$idx_nstate]="(+,-)"."; ".$matrix[$idx_state_el][$idx_nstate];
		    } else {
			$matrix[$idx_state_el][$idx_nstate]="(+,-)";
		    }			    		  					    	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}	    
		
		# Remove only object in Left Hand and do not add object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}	    	    
	    }
	}	
    }
    
    &common::hideComputingPrompt();
    
    if (scalar @_ == 3 && $_[2]==-1) {
	return (\@matrix, \@states);
    }
    
    # Print or Write the Matrix    
    if (scalar @_ == 3 && $_[2]!=-1) {
	if ("XLS:"=~substr(uc($_[2]),0,4)) {
	    __write_xls_from_states(\@matrix,\@states,substr($_[2],4),"S,".$_[0].",".$_[1].","."-1,-1");		  
	} else {	   
	    __write_from_states(\@matrix,\@states,$_[2], "S,".$_[0].",".$_[1].","."-1,-1");
	}
	
    } elsif (scalar @_ == 2) {
	__write_from_states(\@matrix,\@states, "S,".$_[0].",".$_[1].","."-1,-1");
    }
    
    return (\@matrix, \@states);
    
}


sub __gen_states_multiplex_sync
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);
    
    my @matrix=();
    
    my @states=__get_states_multiplex_sync($_[0], $_[1], $_[2]);	
    
    #build the Matrix    
  LOOP_MAIN: foreach my $el (@states) {
      my $idx = rindex($el,',');
      my $idx_state_el=__get_idx_state(\@states, $el);
      
      my $rhand   =substr($el,0,$idx);
      my $rhandth =hex(substr($rhand,length($rhand)-1));
      my $lhand   =substr($el,$idx+1);
      my $lhandth =hex(substr($lhand,length($lhand)-1));		

      if ($rhandth != 0 && $lhandth != 0) {
	  my @mult_list_right=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$rhandth));

	LOOP1: foreach my $el_mult_right (@mult_list_right) {		
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);
	    
	    for (my $i=0; $i<length($el_mult_right); $i++) {
		# Handle x on multiplex from right hand		    
		if (length($el_mult_right)>1 && hex(substr($el_mult_right, $i, 1)) > 0 && substr($el_mult_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_mult_right, $i, 1)) > 0) {  						   
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";
		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
		    }
		    $nrhand = $mult_to_add_loc_tmp;						
		}		    
	    }
	    
	    my $nrhand_sav = $nrhand;
	    my $nlhand_sav = '0'.substr($lhand,0,length($lhand)-1); 
	    my $mult_to_add_loc_tmp = "";	
	    for (my $j=0;$j<length($nlhand_sav);$j++) {
		my $r = hex(substr($mult_to_add_nlhand, $j, 1)) + hex(substr($nlhand_sav, $j, 1));
		if ( $r> 15) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
	    }
	    $nlhand = $mult_to_add_loc_tmp;					    
	    $nlhand_sav = $nlhand;

	    my @mult_list_left=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$lhandth));
	  LOOP2: foreach my $el_mult_left (@mult_list_left) {
	      $nrhand = $nrhand_sav;
	      # Handle x on multiplex from right hand on left Hand				
	      $nlhand=$nlhand_sav;	      
	      
	      my $mult_to_add_nrhand='0' x length($nrhand);
	      for (my $i=0; $i<length($el_mult_left); $i++) {
		  # Handle x on multiplex from left hand
		  if (length($el_mult_left)>1 && hex(substr($el_mult_left, $i, 1)) > 0 && substr($el_mult_left, $i +1, 1) eq "x") {
		      $mult_to_add_nrhand = ('0' x (length($nrhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      for (my $j=0;$j<length($nrhand_sav);$j++) {
			  my $r = hex(substr($nrhand_sav, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
			  if ( $r> 15) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nrhand = $mult_to_add_loc_tmp;	
		      $i++;
		      #last;
		  } elsif (hex(substr($el_mult_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";	
		      for (my $j=0;$j<length($mult_to_add_loc);$j++) {
			  my $r = hex(substr($mult_to_add_loc, $j, 1)) + hex(substr($nlhand, $j, 1));
			  if ( $r> 15) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nlhand = $mult_to_add_loc_tmp;					    
		  }
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    
		  my $res="(";
		  if (length($el_mult_right) > 1 && !(length($el_mult_right) == 2 && substr($el_mult_right,1,1) eq 'x')) {	
		      $res = $res."[".$el_mult_right."],";
		  } else {
		      $res = $res.$el_mult_right.",";
		  }
		  
		  if (length($el_mult_left) > 1 && !(length($el_mult_left) == 2 && substr($el_mult_left,1,1) eq 'x')) {
		      $res = $res."[".$el_mult_left."])";
		  } else {
		      $res = $res.$el_mult_left.")";
		  }
		  if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		      $matrix[$idx_state_el][$idx_nstate]
			  = $res."; ".$matrix[$idx_state_el][$idx_nstate];				
		  } else {
		      $matrix[$idx_state_el][$idx_nstate]=$res;
		  }
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }		
	}

	  if ($balls == -1) {
	      # Removing of one or several objects in Both Hand
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).$nmrhand.",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  if ($rhandth - $nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($lhandth - $nmlhand == 0) {
			      $matrix[$idx_state_el][$idx_nstate]="(-".sprintf("%x",$rhandth - $nmrhand).",)";		  
			  } elsif ($rhandth - $nmrhand == 0) {
			      $matrix[$idx_state_el][$idx_nstate]="(,-".sprintf("%x",$lhandth - $nmlhand).")";		  
			  } else {
			      $matrix[$idx_state_el][$idx_nstate]="(-".sprintf("%x",$rhandth - $nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";    
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }	    
	  }

      } elsif ($rhandth != 0 && $lhandth == 0) {	 
	  my @mult_list_right=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$rhandth));
	  
	LOOP1: foreach my $el_mult_right (@mult_list_right) {		
	    &common::displayComputingPrompt();
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);

	    for (my $i=0; $i<length($el_mult_right); $i++) {
		# Handle x on multiplex from right hand
		if (length($el_mult_right)>1 && hex(substr($el_mult_right, $i, 1)) > 0 && substr($el_mult_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_mult_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";

		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));			    
		    }
		    $nrhand = $mult_to_add_loc_tmp;			
		}
	    }
	    
	    # Handle x on multiplex from right hand
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);			
	    my $mult_to_add_loc_tmp ="";
	    for (my $j=0;$j<length($nlhand);$j++) {
		my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_nlhand, $j, 1));
		if ( $r> 15) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
	    }
	    $nlhand=$mult_to_add_loc_tmp;
	    
	    my $nstate=$nrhand.",".$nlhand;
	    my $idx_nstate=__get_idx_state(\@states, $nstate);

	    if ($idx_nstate >= 0) {		    
		my $res="(";
		if (length($el_mult_right) > 1 && !(length($el_mult_right) == 2 && substr($el_mult_right,1,1) eq 'x')) {			  
		    $res = $res."[".$el_mult_right."],0)";
		} else {
		    $res = $res.$el_mult_right.",0)";
		}
		
		if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		    $matrix[$idx_state_el][$idx_nstate]
			=$res."; ".$matrix[$idx_state_el][$idx_nstate];				
		} else {
		    $matrix[$idx_state_el][$idx_nstate]=$res;				
		}	    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	    }	    	       		
	}

	  if ($balls == -1) {
	      # Adding of one or several objects (in Left Hand) and Removing of one or several objects (in Right Hand)
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $multiplex; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);
		      if ($idx_nstate >=0) {
			  if ($rhandth - $nmrhand == 0 && $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($nmlhand == 0) {
			      $matrix[$idx_state_el][$idx_nstate]="(-".sprintf("%x",$rhandth - $nmrhand).",)";		  
			  } elsif ($rhandth - $nmrhand == 0) {			    
			      $matrix[$idx_state_el][$idx_nstate]="(,+".sprintf("%x",$nmlhand).")";
			  } else {
			      # A collapse could occur there
			      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
				  $matrix[$idx_state_el][$idx_nstate]="(-".sprintf("%x",$rhandth - $nmrhand).",+".sprintf("%x",$nmlhand).")"."; ".$matrix[$idx_state_el][$idx_nstate];
			      } else {
				  $matrix[$idx_state_el][$idx_nstate]="(-".sprintf("%x",$rhandth - $nmrhand).",+".sprintf("%x",$nmlhand).")";	
			      }
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	  }	    

      } elsif ($rhandth == 0 && $lhandth != 0) {	    		
	  my $nrhand='0'.substr($rhand,0,length($rhand)-1);	    
	  my $nrhand_sav = $nrhand;

	  my @mult_list_left=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$lhandth));
	  LOOP1 : foreach my $el_mult_left (@mult_list_left) {		
	      $nrhand = $nrhand_sav;
	      my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	      my $mult_to_add_nrhand='0' x length($nrhand);

	      for (my $i=0; $i<length($el_mult_left); $i++) {
		  # Handle x on multiplex from left hand
		  my $mult_to_add_nrhand = '0' x length($nrhand);
		  if (length($el_mult_left)>1 && hex(substr($el_mult_left, $i, 1)) > 0 && substr($el_mult_left, $i +1, 1) eq "x") {
		      my $mult_to_add_nrhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1)); 
		      my $mult_to_add_nrhand_tmp = "";
		      for (my $j =0; $j < length($mult_to_add_nrhand); $j++) {
			  my $r = hex(substr($mult_to_add_nrhand,$j,1)) + hex(substr($mult_to_add_nrhand2,$j,1));
			  if ( $r> 15) {
			      next LOOP1;
			  }
			  $mult_to_add_nrhand_tmp = $mult_to_add_nrhand_tmp.(sprintf("%x",$r));			
		      }
		      $mult_to_add_nrhand = $mult_to_add_nrhand_tmp;
		      $i++;
		      #last;
		  } elsif (hex(substr($el_mult_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      
		      for (my $j=0;$j<length($nlhand);$j++) {
			  my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			  if ( $r> 15) {
			      next LOOP1;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		      }
		      $nlhand = $mult_to_add_loc_tmp;			
		  }
		  
		  # Handle x on multiplex from left hand		    
		  my $mult_to_add_loc_tmp = "";
		  for (my $j=0;$j<length($nrhand);$j++) {
		      my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
		      if ( $r> 15) {
			  next LOOP1;
		      }
		      $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		  }
		  $nrhand = $mult_to_add_loc_tmp;
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    
		  my $res="(0,";

		  if (length($el_mult_left) > 1 && !(length($el_mult_left) == 2 && substr($el_mult_left,1,1) eq 'x')) {
		      $res = $res."[".$el_mult_left."])";
		  } else {
		      $res = $res.$el_mult_left.")";
		  }
		  
		  if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		      $matrix[$idx_state_el][$idx_nstate]=
			  $res."; ".$matrix[$idx_state_el][$idx_nstate];      
		  } else {
		      $matrix[$idx_state_el][$idx_nstate]=$res;				
		  }	    
		  
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }

	  if ($balls == -1) {
	      # Adding of one or several objects (in Right Hand) and Removing of one or several objects (in Left Hand)
	      for (my $nmrhand = 0; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  if ($nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($nmrhand == 0) {
			      $matrix[$idx_state_el][$idx_nstate]="(,-".sprintf("%x",$lhandth - $nmlhand).")";		  
			  } elsif ($lhandth - $nmlhand == 0) {
			      $matrix[$idx_state_el][$idx_nstate]="(+".sprintf("%x",$nmrhand).",)";		  
			  } else {
			      # A collapse could occur there
			      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
				  $matrix[$idx_state_el][$idx_nstate]="(+".sprintf("%x",$nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")"."; ".$matrix[$idx_state_el][$idx_nstate];
			      } else {
				  $matrix[$idx_state_el][$idx_nstate]="(+".sprintf("%x",$nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";
			      }			    		  
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	  }	    
      } elsif ($rhandth == 0 && $lhandth == 0) {	    		
	  my $nrhand='0'.substr($rhand,0,length($rhand)-1);				
	  my $nlhand='0'.substr($lhand,0,length($lhand)-1);	
	  
	  &common::displayComputingPrompt();
	  my $nstate=$nrhand.",".$nlhand;
	  my $idx_nstate=__get_idx_state(\@states, $nstate);

	  if ($idx_nstate >= 0) {		    
	      my $res="(0,0)";
	      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		  $matrix[$idx_state_el][$idx_nstate]=
		      $res."; ".$matrix[$idx_state_el][$idx_nstate];				
	      } else {
		  $matrix[$idx_state_el][$idx_nstate]=$res;				
	      }				  
	  } else {
	      &common::hideComputingPrompt();
	      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	  }	

	  if ($balls == -1) {
	      #Adding of one or several objects (in each hand)
	      # ==> Both Hands
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		      $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);
		      if ($idx_nstate >=0) {
			  $matrix[$idx_state_el][$idx_nstate]="(+".sprintf("%x",$nmrhand).",+".sprintf("%x",$nmlhand).")";		  	 
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	      # ==> Right Hand only
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1)."0";	    	 	    
		  my $idx_nstate=__get_idx_state(\@states, $nstate);
		  if ($idx_nstate >=0) {
		      $matrix[$idx_state_el][$idx_nstate]="(+".sprintf("%x",$nmrhand).",)";		  	 
		  } else {
		      &common::hideComputingPrompt();
		      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		  }
	      }
	      # ==> Left Hand only
	      for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		  $nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);	    	 	    
		  my $idx_nstate=__get_idx_state(\@states, $nstate);

		  if ($idx_nstate >=0) {
		      $matrix[$idx_state_el][$idx_nstate]="(,+".sprintf("%x",$nmlhand).")";		  	 
		  } else {
		      &common::hideComputingPrompt();
		      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		  }
	      }    				    
	  }    
      } 
  }
    
    &common::hideComputingPrompt();
    
    if (scalar @_ == 4 && $_[3]==-1) {
	return (\@matrix, \@states);
    }
    
    # Print or Write the Matrix    
    if (scalar @_ == 4 && $_[3]!=-1) {
	if ("XLS:"=~substr(uc($_[3]),0,4)) {
	    __write_xls_from_states(\@matrix,\@states,substr($_[3],4),"S,".$_[0].",".$_[1].",".$_[2].",-1");	
	} else {	    
	    __write_from_states(\@matrix,\@states,$_[3],"S,".$_[0].",".$_[1].",".$_[2].",-1");
	}
    } elsif (scalar @_ == 3) {
	__write_from_states(\@matrix,\@states,"S,".$_[0].",".$_[1].",".$_[2].",-1");
    }
    
    return (\@matrix, \@states);
}


sub __drawStates 
{
    # Graphviz must be installed prior
    
    # Drawing supports are the following :     
    #     - bmp (Windows Bitmap Format),
    #     - cmapx (client-side imagemap for use in html and xhtml),
    #     - dia (GTK+ based diagrams), 
    #     - eps (Encapsulated PostScript),
    #     - fig (XFIG graphics), 
    #     - gd, gd2 (GD/GD2 formats),
    #     - gif (bitmap graphics), 
    #     - gtk (GTK canvas)
    #     - hpgl (HP pen plotters) and pcl (Laserjet printers), 
    #     - imap (imagemap files for httpd servers for each node or edge that has a non-null "href" attribute.), 
    #     - jpg, jpeg, jpe (JPEG)
    #     - mif (FrameMaker graphics), 
    #     - pdf (Portable Document Format),
    #     - png (Portable Network Graphics format), // Default one 
    #     - ps (PostScript), 
    #     - ps2 (PostScript for PDF),
    #     - svg, svgz (Structured Vector Graphics),
    #     - tif, tiff (Tag Image File Format),
    #     - vml, vmlz (Vector Markup Language),
    #     - vrml (VRML),
    #     - wbmp (Wireless BitMap format),
    #     - xlib (Xlib canvas),
    #     - canon, dot, xdot : Output in DOT langage, 
    #     - plain , plain-ext : Output in plain text

    # Generation Filters are the following :
    #     - circo : filter for circular layout of graphs // Default one
    #     - dot : filter for drawing directed graphs
    #     - neato : filter for drawing undirected graphs
    #     - twopi : filter for radial layouts of graphs    
    #     - fdp : filter for drawing undirected graphs
    #     - sfdp : filter for drawing large undirected graphs    
    #     - osage : filter for drawing clustered graphs
    
    my @matrix=@{$_[0]};
    my @states=@{$_[1]};
    my $fileOutput=$_[2];
    my $fileOutputType="png";
    my $genFilter="circo";

    if (scalar @_ > 3) {
	$fileOutputType=$_[3];
    }
    if (scalar @_ > 4) {
	$genFilter=$_[4];
    }
    
    open(GRAPHVIZ,"> tmp\\${fileOutput}.graphviz") || die ("$lang::MSG_GENERAL_ERR1 <tmp\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
    print GRAPHVIZ "digraph Transition_States_Matrix{\n";    
    
    print GRAPHVIZ "node [color=blue]\n";
    foreach my $i (@states) {		
	print GRAPHVIZ "\"".${i}."\""." [label=\"".${i}."\"] // node ".${i}."\n";
    }
    
    foreach my $i (@states) {	
	foreach my $j (@states) {
	    my $idx_state_i=__get_idx_state(\@states, $i);
	    my $idx_state_j=__get_idx_state(\@states, $j);
	    if ($matrix[$idx_state_i][$idx_state_j] ne "") {
		print GRAPHVIZ "\"".${i}."\""."->"."\"".${j}."\""." [taillabel=\"".$matrix[$idx_state_i][$idx_state_j]."\", fontcolor=red, fontname=\"Times-Bold\"]\n";	
	    }
	}	
    }
    
    print GRAPHVIZ "}";
    close GRAPHVIZ;        
    print $lang::MSG_GENERAL_GRAPHVIZ;
    system("\"".$conf::GRAPHVIZ_BIN."\\".$genFilter.".exe\" -T".$fileOutputType." -Nfontsize=\"12\" -Efontsize=\"12\" -v -o"."$conf::RESULTS/$fileOutput"." tmp\\${fileOutput}.graphviz");   

    if ($SITESWAP_DEBUG <= 0) {
	unlink "tmp\\${fileOutput}.graphviz";
    }
    
}


sub drawStates
{
    my $mod = uc(shift);
    my $res1 = "";
    my $stat1 = "";

    if ($mod eq "R" || $mod eq "A") {
	($res1, $stat1) =__gen_states_async($_[0],$_[1],-1);	    
	#@states=__get_states_async($_[0],$_[1]);
	shift; shift;
    } elsif ($mod eq "M") {
	($res1, $stat1)=__gen_states_multiplex($_[0],$_[1],$_[2],-1);
	#@states=__get_states_multiplex($_[0],$_[1],$_[2]);
	shift; shift; shift;
    } elsif ($mod eq "S") {
	($res1, $stat1)=__gen_states_sync($_[0],$_[1],-1);	    
	#@states=__get_states_sync($_[0],$_[1]);
	shift; shift;
    } elsif ($mod eq "SM" || $mod eq "MS") {
	($res1, $stat1)=__gen_states_multiplex_sync($_[0],$_[1],$_[2],-1);	    
	#@states=__get_states_multiplex_sync($_[0],$_[1],$_[2]);
	shift; shift; shift;
    }
    
    my @res=@{$res1};
    my @states=@{$stat1};

    __drawStates(\@res,\@states,@_);
}


sub drawStatesAggr
{
    my $mod = uc(shift);
    my $res1 = "";
    my $stat1 = "";

    if ($mod eq "R" || $mod eq "A") {
	($res1, $stat1) = genStatesAggr('R',$_[0],$_[1],-1);	    
	shift; shift;
    } elsif ($mod eq "M") {
	($res1, $stat1)= genStatesAggr('M',$_[0],$_[1],$_[2],-1);
	shift; shift; shift;
    } elsif ($mod eq "S") {
	($res1, $stat1)= genStatesAggr('S',$_[0],$_[1],-1);	    
	shift; shift;
    } elsif ($mod eq "SM" || $mod eq "MS") {
	($res1, $stat1)= genStatesAggr('MS',$_[0],$_[1],$_[2],-1);	    	
	shift; shift; shift;
    }
    
    my @res=@{$res1};
    my @states=@{$stat1};
    
    __drawStates(\@res,\@states,@_);
}


sub dec2bin {
    my $str = unpack("B32", pack("N", shift));
    $str =~ s/^0+(?=\d)//;	# otherwise you'll get leading zeros
    return $str;
}

sub dec2binwith0 {
    my $str = unpack("B32", pack("N", shift));
    return $str;
}

sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub array_del_duplicate {
    my %seen = ();
    my @r = ();
    foreach my $a (@_) {
	unless ($seen{$a}) {
	    push @r, $a;
	    $seen{$a} = 1;
	}
    }
    return @r;
}



######################################################################
#
# The Followings procedure uses OLE and thus are dedicated to Windows (With Excel License set)
#
######################################################################

my $OS=$^O;
if($OS eq "MSWin32")
{
    use Win32::OLE;
    use Win32::OLE qw(in with);
    # not limited to Win32::OLE::Const 'Microsoft Excel'
    use Win32::OLE::Const;
}


sub writeStates_xls
{
    my $mod = uc(shift);    

    if ($mod eq "R" || $mod eq "A") {
	return __write_states_async_xls(@_);
    } elsif ($mod eq "M") {
	return __write_states_multiplex_xls(@_);
    } elsif ($mod eq "S") {
	return __write_states_sync_xls(@_);
    } elsif ($mod eq "SM" || $mod eq "MS") {
	return __write_states_multiplex_sync_xls(@_);
    }    
}


sub __get_xls_sheet
{
    my $i = $_[0];
    my $j = $_[1];
    my $nb_states =$_[2];
    my $cur_sheet=1;		#Sheets start at 1 ...
    my $cur_sheet_row = 1;
    my $cur_sheet_col = 1;
    my $nb_sheets_for_col = 1;

    my $max_col = $EXCEL_MAX_COLS - $EXCEL_COL_START;
    my $max_row = $EXCEL_MAX_ROWS - $EXCEL_ROW_START;
    
    if ($i > $max_row) {	
	$cur_sheet_row = int($i / $max_row);
	if ($i % $max_row != 0) {
	    $cur_sheet_row ++;
	}
    }

    $nb_sheets_for_col = int($nb_states / $max_col);
    if ($nb_states % $max_col != 0) {
	$nb_sheets_for_col ++;
    }

    if ($j > $max_col) {
	$cur_sheet_col = int($j / $max_col);
	
	if ($j % $max_col != 0) {
	    $cur_sheet_col ++;
	}	
    }
    
    $cur_sheet = ($cur_sheet_row -1) * $nb_sheets_for_col + $cur_sheet_col ;
    return $cur_sheet ;
}

sub __get_xls_cell
{
    my $i = $_[0];
    my $j = $_[1];
    my $max_col = $EXCEL_MAX_COLS - $EXCEL_COL_START;
    my $max_row = $EXCEL_MAX_ROWS - $EXCEL_ROW_START;    
    my $row = 0;
    my $col = 0;

    if ($i > $max_row) {
	if ($i % $max_row !=0) {
	    $row = $i - int($i / $max_row)*$max_row + $EXCEL_ROW_START;
	} else {
	    $row = $i - int($i / $max_row -1)*$max_row + $EXCEL_ROW_START;
	}
    } else {
	$row = $i + $EXCEL_ROW_START;
    }

    if ($j > $max_col) {	
	if ($j % $max_col !=0) {
	    $col = $j - int($j / $max_col)*$max_col + $EXCEL_COL_START ;
	} else {
	    $col = $j - int($j / $max_col -1)*$max_col + $EXCEL_COL_START ;
	}
    } else {
	$col = $j + $EXCEL_COL_START;
    }  

    return ($row, $col) ;
}



sub __get_nb_xls_sheets
{
    return __get_nb_xls_sheets_for_col($_[0]) * __get_nb_xls_sheets_for_row($_[0]);
}

sub __get_nb_xls_sheets_for_col 
{
    my $nbstates = $_[0];
    my $nbsheets = 1;
    my $max_col = $EXCEL_MAX_COLS - $EXCEL_COL_START;   

    if ($nbstates >= $max_col) {
	if ($nbstates % $max_col != 0) {
	    $nbsheets = int($nbstates / $max_col) + 1;
	} else {
	    $nbsheets = int($nbstates / $max_col);
	}
    }
    
    return $nbsheets;
}

sub __get_nb_xls_sheets_for_row
{
    my $nbstates = $_[0];
    my $nbsheets = 1;
    my $max_row = $EXCEL_MAX_ROWS - $EXCEL_ROW_START;
    
    if ($nbstates >= $max_row) {	
	if ($nbstates % $max_row != 0) {
	    $nbsheets = $nbsheets * int($nbstates / $max_row) +1;
	} else {
	    $nbsheets = $nbsheets * int($nbstates / $max_row);
	}
    }       

    return $nbsheets;
}


sub __write_states_async_xls
{
    # It supports Excel 2007 with 1,048,576 rows x 16,384 columns.
    
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }    
    my $highMaxss=hex($_[1]);
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[2].".xlsx";    
    my $nbtransitions = 0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    #my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=__get_states_async($_[0],$_[1]);        

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = __get_nb_xls_sheets (scalar @states);

    # Generation of needed sheets
    my $comment ="A,".$balls.",".sprintf("%x",$highMaxss).",-1,-1";
    if ($nbsheets > 1) {	
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment."__(1)";
    } else {
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment;
    }

    for (my $i = 1; $i < $nbsheets; $i++) {
	#$Book -> Worksheets -> Add({After => $Book -> Worksheets($Book -> Worksheets -> {Count})});
	$Book -> Worksheets -> Add({After => $Book -> Worksheets($i)});
	$Book -> Worksheets($i +1) -> {'Name'} = "Matrix__".$comment."__(".($i+1).")";
    }    


    # Writing of the Main Header
    # select worksheet number 1
    #my $Sheet = $Book->ActiveSheet;
    #$Book->Sheets(1)->Select();
    my $Sheet = $Book->Sheets(1);
    $Sheet->Range('B2:B4')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B4')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B4')-> Font -> {'size'} = 12;    
    $Sheet->Range('B2:B6')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};    
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENERAL1;	
    if ($balls != -1) {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".sprintf("%x",$balls);	
    } else {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }   

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 	
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < __get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = __get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'ColumnWidth'} = length($states[0]) + 2;
	    $Sheet->Cells($celli, $cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	 
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$idx];
	}

	$jdx_sheet++;
    }


    # Write the Body Excel file    
    foreach my $el (@states) {       	
	&common::displayComputingPrompt();		
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	my $b = substr(reverse($el),0,$highMaxss);
	if (substr($b, 0, 1) == 0) {
	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";	    
	    my $bn3=reverse($bn);	    
	    my $idx_bn3 = __get_idx_state(\@states,$bn3);
	    if ($idx_bn3 >= 0) {
		my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states)); 
		my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		$nbtransitions++;
		if ($SITESWAP_DEBUG >=1) {
		    print $el." ===0"."===> ".$bn3."\n";		   
		    
		}
		if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {		    
		    $Sheet->Cells($celli,$cellj)->{'Value'}="0; ".($Sheet->Cells($celli, $cellj)->{'Value'});
		} else {
		    $Sheet->Cells($celli,$cellj)->{'Value'}="0";
		}
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
	    }
	    
	    if ($balls==-1) {
		#Adding of an object
		$bn=substr($b, 1, length($b) -1);
		$bn="1".${bn};	
		$bn3=reverse($bn);
		my $idx_bn3 = __get_idx_state(\@states,$bn3);
		if ( $idx_bn3 >= 0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bn3 +1,scalar @states));	     
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {
			print $el." ===+"."===> ".$bn3."\n";		   
			
		    }
		    $Sheet->Cells($celli, $cellj)->{'Value'}="+";		    
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}	    
	    }
	} else {	 
	    if ($balls==-1) {
		#Removing of an object
		my $bn=substr($b, 1, length($b) -1);
		$bn="0".${bn};
		my $bn3=reverse($bn);	    
		my $idx_bn3 = __get_idx_state(\@states,$bn3);
		if ($idx_bn3 >= 0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states));
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {
			print $el." ===-"."===> ".$bn3."\n";		   
			
		    }
		    $Sheet->Cells($celli, $cellj)->{'Value'}="-";	 	    
		} else {	       
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}
	    }

	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";
	    for (my $k=0; $k<length($bn); $k++) {		
		if (substr($bn, $k, 1) == 0 && $k+1 <= 15) {
		    my $bn2=substr($bn, 0, $k)."1".substr($bn, $k+1, length($bn)-$k);		    
		    my $bn3=reverse($bn2);		   
		    my $idx_bn3 = __get_idx_state(\@states,$bn3);	
		    if ($idx_bn3 >= 0) {
			my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states));
			my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bn3 +1);
			$nbtransitions++;
			if ($SITESWAP_DEBUG >=1) {
			    print $el." ===".sprintf("%x",($k+1))."===> ".$bn3."\n";		   
			    
			}
			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}=sprintf("%x",($k+1))."; ".($Sheet->Cells($celli, $cellj)->{'Value'}); 
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}=sprintf("%x",($k+1));	 
			}
		    } else {	       
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		    }
		}
	    }

	}    
    }
    
    my $idx_i =0;
    my $idx_j =0;
    foreach my $i (@states) {    	 
	
	# Coloring Median States
	my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }
    
    #$last_row = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByRows})    -> {Row};
    #$last_col = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByColumns}) -> {Column};

    &common::hideComputingPrompt();
    $Sheet->Range('B5')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);				
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    }
	    
	    $idx_sheet ++;
	}
	&common::hideComputingPrompt();
    }

    print colored [$common::COLOR_RESULT], "[ => ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";

    #$Book->Sheets(1)->Select();
    $Excel -> {'DisplayAlerts'} = 0; # This turns off the "This file already exists" message.
    $Book -> SaveAs ($file) or die $!;
    $Book->Close;    
    #$Excel->Quit();      
}



sub __write_states_multiplex_xls
{   
    # It supports Excel 2007 with 1,048,576 rows x 16,384 columns.
    
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[3].".xlsx";    
    my $nbtransitions=0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    #my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=__get_states_multiplex($_[0], $_[1], $_[2]);	

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = __get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="A,".$balls.",".sprintf("%x",$highMaxss).",".sprintf("%x",$multiplex).",-1";
    if ($nbsheets > 1) {	
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment."__(1)";
    } else {
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment;
    }

    for (my $i = 1; $i < $nbsheets; $i++) {
	#$Book -> Worksheets -> Add({After => $Book -> Worksheets($Book -> Worksheets -> {Count})});
	$Book -> Worksheets -> Add({After => $Book -> Worksheets($i)});
	$Book -> Worksheets($i +1) -> {'Name'} = "Matrix__".$comment."__(".($i+1).")";
    }    


    # Writing of the Main Header
    # select worksheet number 1
    #my $Sheet = $Book->ActiveSheet;
    #$Book->Sheets(1)->Select();
    my $Sheet = $Book->Sheets(1);
    $Sheet->Range('B2:B5')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B5')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B5')-> Font -> {'size'} = 12;    
    $Sheet->Range('B2:B6')-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENERAL1;	
    if ($balls != -1) {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".sprintf("%x",$balls);	
    } else {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }
    if ($multiplex != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL4." : ".sprintf("%x",$multiplex);
    }    

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);
	    
	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		# Will be done at the end
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    } else {	
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < __get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = __get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb -> {'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'ColumnWidth'} = length($states[0]) + 2;
	    $Sheet->Cells($celli, $cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	 
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$idx];
	}

	$jdx_sheet++;
    }


    # Write the Body Excel file            
    foreach my $el (@states) {
	&common::displayComputingPrompt();		
	my $mult=0;
	my $sum=0;
	my $nstate=-1;	    	
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	$mult = hex(substr($el,length($el)-1));
	
	if ($mult != 0) {
	    # Here the computing is slightly different.
	    # All the possible multiplexes are selected first, and according to them the new states are established.
	    my @mult_list=__get_multiplex($_[0],$_[1],substr($el,length($el)-1));
	    
	  LOOP1: foreach my $el_mult (@mult_list) {		  
	      my @nstate_tmp = reverse(split(//, "0".substr($el,0,length($el)-1)));
	      for (my $i=0; $i<length($el_mult); $i++) {
		  &common::displayComputingPrompt();
		  {
		      my $v=hex(substr($el_mult,$i,1));
		      if (hex($nstate_tmp[$v -1]) + 1 > 15) {
			  next LOOP1;
		      }			    
		      $nstate_tmp[$v -1] = sprintf("%x", (hex($nstate_tmp[$v -1]) + 1));  
		  }
	      }
	      
	      $nstate = join('',reverse(@nstate_tmp));
	      
	      my $idx_nstate=__get_idx_state(\@states,$nstate);
	      if ($idx_nstate >= 0) {		    
		  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  $nbtransitions++;
		  if ($SITESWAP_DEBUG >=1) {
		      print $el." ===[".$el_mult."]===> ".$nstate."\n";		   
		      
		  }

		  if (length($el_mult)>=2) {		      
		      if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = "[".$el_mult."], ".($Sheet->Cells($celli,$cellj)->{'Value'}) ;    
		      } else {
			  $Sheet->Cells($celli,$cellj)->{'Value'} ="[".$el_mult."]";			 
		      }
		  } else {
		      if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $el_mult."; ".($Sheet->Cells($celli,$cellj)->{'Value'});			 
		      } else {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $el_mult;			 
		      }
		  }
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }
	  }

	    if ($balls == -1) {
		# Removing of one or several objects
		for (my $r = 1; $r <= $mult; $r ++) {
		    my $nm = $mult - $r;
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {
			my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			$nbtransitions++;
			if ($SITESWAP_DEBUG >=1) {
			    print $el." ===[".sprintf("%x",$r)."]===> ".$nstate."\n";		   			    
			}

			$Sheet->Cells($celli,$cellj)->{'Value'}="-".sprintf("%x",$r);		    
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
		    }
		}
	    }	    
	} else {
	    &common::displayComputingPrompt();
	    $nstate = "0".substr($el,0,length($el)-1);
	    my $idx_nstate=__get_idx_state(\@states,$nstate);
	    if ($idx_nstate >= 0) {		    
		my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		$nbtransitions++;
		if ($SITESWAP_DEBUG >=1) {
		    print $el." ===0"."===> ".$nstate."\n";		   		      
		}

		$Sheet->Cells($celli,$cellj)->{'Value'}="0";		    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1."0".substr($el,0,length($el)-1)."\n";		    
	    }	    

	    if ($balls == -1) {
		# Adding of one or several objects
		for (my $nm = 1; $nm <= $multiplex; $nm ++) {
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {		    
			my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			$nbtransitions++;
			if ($SITESWAP_DEBUG >=1) {
			    print $el." ===+".sprintf("%x",$nm)."===> ".$nstate."\n";		   		      
			}

			$Sheet->Cells($celli,$cellj)->{'Value'}="+".sprintf("%x",$nm);		    
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
		    }
		}
	    }	    
	}
    }

    
    my $idx_i =0;
    my $idx_j =0;
    foreach my $i (@states) {    	 
	
	# Coloring Median States
	my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }

    &common::hideComputingPrompt();        
    $Sheet->Range('B6')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";
    
    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);				
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    }
	    
	    $idx_sheet ++;
	}
	&common::hideComputingPrompt();
    }

    print colored [$common::COLOR_RESULT], "[ => ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";
    
    #$Book->Sheets(1)->Select();
    $Excel -> {'DisplayAlerts'} = 0; # This turns off the "This file already exists" message.
    $Book -> SaveAs ($file) or die $!;
    $Book->Close;    
    #$Excel->Quit();      
}



sub __write_states_sync_xls
{    
    # It supports Excel 2007 with 1,048,576 rows x 16,384 columns.
    
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[2].".xlsx";        
    my $nbtransitions=0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    #my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    #	|| Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=__get_states_sync($_[0], $_[1]);    

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = __get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="S,".$balls.",".sprintf("%x",$highMaxss).",-1,-1";
    if ($nbsheets > 1) {	
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment."__(1)";
    } else {
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment;
    }

    for (my $i = 1; $i < $nbsheets; $i++) {
	#$Book -> Worksheets -> Add({After => $Book -> Worksheets($Book -> Worksheets -> {Count})});
	$Book -> Worksheets -> Add({After => $Book -> Worksheets($i)});
	$Book -> Worksheets($i +1) -> {'Name'} = "Matrix__".$comment."__(".($i+1).")";
    }    


    # Writing of the Main Header
    # select worksheet number 1
    #my $Sheet = $Book->ActiveSheet;
    #$Book->Sheets(1)->Select();
    my $Sheet = $Book->Sheets(1);
    $Sheet->Range('B2:B4')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B4')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B4')-> Font -> {'size'} = 12;
    $Sheet->Range('B2:B6')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENERAL1b;	
    if ($balls != -1) {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".sprintf("%x",$balls);	
    } else {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }

    
    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < __get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = __get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'ColumnWidth'} = length($states[0]) + 2;
	    $Sheet->Cells($celli, $cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	 
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$idx];
	}

	$jdx_sheet++;
    }


    # Write the Body Excel file    
    my $nstate=();        
    foreach my $el (@states) {       
	&common::displayComputingPrompt();		
	my $idx = rindex($el,',');
	my $idx_state_el=__get_idx_state(\@states, $el);
	
	my $rhand=substr($el,0,$idx);
	my $rhandth=hex(substr($rhand,length($rhand)-1));
	my $lhand=substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));

	if ($rhandth eq "0" && $lhandth eq "0") {		
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    	 	    
	    my $idx_nstate = __get_idx_state(\@states,$nstate);
	    if ($idx_nstate >=0) {
		my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		$nbtransitions++;
		if ($SITESWAP_DEBUG >=1) {		   
		    print $rhand.",".$lhand." ===(0,0)===> ".$nstate."\n";		   
		}		
		$Sheet->Cells($celli, $cellj)->{'Value'}="(0,0)";		  	 
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
	    }

	    if ($balls == -1) {
		# Adding of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,+)===> ".$nstate."\n";		   
		    }		
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Right Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";	    	 	    
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,)===> ".$nstate."\n";		   
		    }		
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Left Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,+)";		  	 
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,+)===> ".$nstate."\n";		   
		    }		
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }
	    
	} elsif ($rhandth eq "1" && $lhandth eq "1") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);
	    
	    # Start by right Hand ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "?";
		    if ($k > $idx) {
			$x = 2*(length($nstate)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x)."x" ;
		    } else {
			$x = 2*(length($rhand)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x);
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    
		    {
			# ... And then left hand ...
			for (my $l=0; $l<length($bnstate); $l++) {
			    &common::displayComputingPrompt();		
			    if (substr($bnstate, $l, 1) eq "0") {
				my $y = "?";			
				if ($l > $idx) {		
				    $y = 2*(length($nstate)-$l);
				    if ($y > $highMaxss) {
					next;
				    }
				    $y = sprintf("%x",$y);			    
				} else {
				    $y = 2*(length($rhand)-$l);
				    if ($y > $highMaxss) {
					next;
				    }
				    $y = sprintf("%x",$y)."x" ;
				}				
				my $idx_bn = __get_idx_state(\@states,substr($bnstate, 0, $l)."1".substr($bnstate, $l+1));
				if ($idx_bn >=0) {	
				    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bn +1, scalar @states)); 
				    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bn +1);
				    $nbtransitions++;
				    if ($SITESWAP_DEBUG >=1) {		   
					print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
				    }		
				    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
					$Sheet->Cells($celli, $cellj)->{'Value'}= "(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
				    } else {
					$Sheet->Cells($celli, $cellj)->{'Value'}= "(".$x.",".$y.")";  
				    }
				} else {
				    &common::hideComputingPrompt();
				    #print $lang::MSG_SSWAP_GENSTATES_MSG1.substr($bnstate, 0, $l)."1".substr($bnstate, $l+1)."\n";
				}
			    }
			}
		    }
		}
	    }

	    if ($balls == -1) {
		# Removing of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);		
		if ($idx_nstate >=0) {		    
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,-)===> ".$nstate."\n";		   
		    }		
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,-)";		  	
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);		
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,-)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }

	} elsif ($rhandth eq "1" && $lhandth eq "0") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);
	    
	    # Only right Hand throws ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "?";
		    my $y = "0";
		    if ($k > $idx) {
			$x = 2*(length($nstate)-$k);
			if ($x > $highMaxss) {
			    next;
			}			
			$x = sprintf("%x",$x)."x" ;
		    } else {
			$x = 2*(length($rhand)-$k);
			if ($x > $highMaxss) {
			    next;
			}
			$x = sprintf("%x",$x);
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    		    
		    my $idx_bnstate = __get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {
			my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bnstate +1, scalar @states)); 
			my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bnstate +1);
			$nbtransitions++;
			if ($SITESWAP_DEBUG >=1) {		   
			    print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
			}		

			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y.")";		    			   			
			}
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    		
	    }
	    
	    if ($balls == -1) {
		# Adding of one object (in Left Hand)
		# => Keep object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,+)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,+)===> ".$nstate."\n";		   
		    }		

		    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(-,+)"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
		    } else {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(-,+)";
		    }			    		  					    
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		
		# Remove only object in Right Hand and do not add object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
	    }

	} elsif ($rhandth eq "0" && $lhandth eq "1") {
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    
	    
	    # Only Left Hand throws ...
	    for (my $k=0; $k<length($nstate); $k++) {
		&common::displayComputingPrompt();		
		if (substr($nstate, $k, 1) eq "0") {
		    my $x = "0";
		    my $y = "?";
		    if ($k > $idx) {
			$y = 2*(length($nstate)-$k);
			if ($y > $highMaxss) {
			    next;
			}
			$y = sprintf("%x",$y);
		    } else {
			$y= 2*(length($rhand)-$k);
			if ($y > $highMaxss) {
			    next;
			}
			$y = sprintf("%x",$y)."x";
		    }
		    
		    my $bnstate=substr($nstate, 0, $k)."1".substr($nstate, $k+1);		    
		    my $idx_bnstate = __get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {		    
			my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_bnstate +1, scalar @states)); 
			my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_bnstate +1);
			$nbtransitions++;
			if ($SITESWAP_DEBUG >=1) {		   
			    print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
			}		

			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y.")";
			}
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    	    
	    }

	    if ($balls == -1) {
		# Adding of one object (in Right Hand)
		# => Keep object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,-)===> ".$nstate."\n";		   
		    }		

		    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(+,-)"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
		    } else {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(+,-)";
		    }			    		  					    	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}	    
		
		# Remove only object in Left Hand and do not add object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = __get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $nbtransitions++;
		    if ($SITESWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,-)===> ".$nstate."\n";		   
		    }		

		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}	    	    
	    }
	}	
    }
    
    my $idx_i =0;
    my $idx_j =0;
    foreach my $i (@states) {    	 
	
	# Coloring Median States
	my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	# Coloring Symetrics states 	
	if ($i =~ ",") {
	    my @res=split(/,/,$i);
	    my $nstate=$res[1].",".$res[0];
	    my $idx_nj=__get_idx_state(\@states,$nstate); 
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_nj +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_nj + 1);
	    $Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 15;
	}
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }

    &common::hideComputingPrompt();        
    $Sheet->Range('B5')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);				
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    }
	    
	    $idx_sheet ++;
	}
	&common::hideComputingPrompt();
    }

    print colored [$common::COLOR_RESULT], "[ => ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";

    #$Book->Sheets(1)->Select();
    $Excel -> {'DisplayAlerts'} = 0; # This turns off the "This file already exists" message.
    $Book -> SaveAs ($file) or die $!;
    $Book->Close;    
    #$Excel->Quit();      
}



sub __write_states_multiplex_sync_xls
{
    my $balls=$_[0];
    if ($balls != -1) {
	$balls=hex($balls);
    }
    my $highMaxss=hex($_[1]);
    my $multiplex=hex($_[2]);        
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[3].".xlsx";        
    my $nbtransitions = 0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    #my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Created with JugglingTB, Module SITESWAP '.$SITESWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=__get_states_multiplex_sync($_[0], $_[1], $_[2]);	

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = __get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="S,".$balls.",".sprintf("%x",$highMaxss).",".sprintf("%x",$multiplex).",-1";
    if ($nbsheets > 1) {	
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment."__(1)";
    } else {
	$Book -> Worksheets(1) -> {'Name'} = "Matrix__".$comment;
    }

    for (my $i = 1; $i < $nbsheets; $i++) {
	#$Book -> Worksheets -> Add({After => $Book -> Worksheets($Book -> Worksheets -> {Count})});
	$Book -> Worksheets -> Add({After => $Book -> Worksheets($i)});
	$Book -> Worksheets($i +1) -> {'Name'} = "Matrix__".$comment."__(".($i+1).")";
    }    


    # Writing of the Main Header
    # select worksheet number 1
    #my $Sheet = $Book->ActiveSheet;
    #$Book->Sheets(1)->Select();
    my $Sheet = $Book->Sheets(1);
    $Sheet->Range('B2:B5')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B5')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B5')-> Font -> {'size'} = 12;
    $Sheet->Range('B2:B6')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENERAL1b;	
    if ($balls != -1) {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".sprintf("%x",$balls);	
    } else {
	$Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }
    if ($multiplex != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL4." : ".sprintf("%x",$multiplex);
    }
    

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < __get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = __get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'ColumnWidth'} = length($states[0]) + 2;
	    $Sheet->Cells($celli, $cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	 
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$idx];
	}

	$jdx_sheet++;
    }    
    
    # Write the Body Excel file    
  LOOP_MAIN: foreach my $el (@states) {
      my $idx = rindex($el,',');
      my $idx_state_el=__get_idx_state(\@states, $el);
      
      my $rhand   =substr($el,0,$idx);
      my $rhandth =hex(substr($rhand,length($rhand)-1));
      my $lhand   =substr($el,$idx+1);

      my $lhandth =hex(substr($lhand,length($lhand)-1));		

      if ($rhandth != 0 && $lhandth != 0) {
	  my @mult_list_right=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$rhandth));

	LOOP1: foreach my $el_mult_right (@mult_list_right) {		    
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);		    		 
	    my $mult_to_add_nlhand='0' x length($nrhand);
	    
	    for (my $i=0; $i<length($el_mult_right); $i++) {	
		# Handle x on multiplex from right hand		    
		if (length($el_mult_right)>1 && hex(substr($el_mult_right, $i, 1)) > 0 && substr($el_mult_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.sprintf("%x",$r);			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;
		    #last;
		} elsif (hex(substr($el_mult_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";
		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
		    }
		    
		    $nrhand = $mult_to_add_loc_tmp;						
		}		    
	    }
	    
	    my $nrhand_sav = $nrhand;
	    my $nlhand_sav = '0'.substr($lhand,0,length($lhand)-1); 
	    my $mult_to_add_loc_tmp = "";	
	    for (my $j=0;$j<length($nlhand_sav);$j++) {
		my $r = hex(substr($mult_to_add_nlhand, $j, 1)) + hex(substr($nlhand_sav, $j, 1));
		if ( $r> 15) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
	    }
	    $nlhand = $mult_to_add_loc_tmp;					    
	    my $nlhand_sav = '0'.substr($lhand,0,length($lhand)-1); 
	    my $mult_to_add_loc_tmp = "";	
	    for (my $j=0;$j<length($nlhand_sav);$j++) {
		my $r = hex(substr($mult_to_add_nlhand, $j, 1)) + hex(substr($nlhand_sav, $j, 1));
		if ( $r> 15) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
	    }
	    $nlhand = $mult_to_add_loc_tmp;					    
	    $nlhand_sav = $nlhand;

	    my @mult_list_left=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$lhandth));
	  LOOP2: foreach my $el_mult_left (@mult_list_left) {	      
	      $nrhand = $nrhand_sav;	      
	      $nlhand = $nlhand_sav;
	      # Handle x on multiplex from right hand on left Hand					            	      
	      my $mult_to_add_nrhand='0' x length($nrhand);
	      for (my $i=0; $i<length($el_mult_left); $i++) {
		  # Handle x on multiplex from left hand
		  if (length($el_mult_left)>1 && hex(substr($el_mult_left, $i, 1)) > 0 && substr($el_mult_left, $i +1, 1) eq "x") {
		      $mult_to_add_nrhand = ('0' x (length($nrhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      for (my $j=0;$j<length($nrhand);$j++) {
			  my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
			  if ( $r> 15) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      
		      $nrhand = $mult_to_add_loc_tmp;			    
		      $i++;
		      #last;
		  } elsif (hex(substr($el_mult_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";	
		      for (my $j=0;$j<length($mult_to_add_loc);$j++) {
			  my $r = hex(substr($mult_to_add_loc, $j, 1)) + hex(substr($nlhand, $j, 1));
			  if ( $r> 15) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nlhand = $mult_to_add_loc_tmp;					    
		  }
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {	
		  $nbtransitions++;		  
		  if ($SITESWAP_DEBUG >=1) {		   
		      print $rhand.",".$lhand." ===([".$el_mult_right."],[".$el_mult_left."])===> ".$nrhand.",".$nlhand."\n";		   
		  }
		  
		  my $res="(";
		  if (length($el_mult_right) > 1 && !(length($el_mult_right) == 2 && substr($el_mult_right,1,1) eq 'x')) {	
		      $res = $res."[".$el_mult_right."],";
		  } else {
		      $res = $res.$el_mult_right.",";
		  }
		  
		  if (length($el_mult_left) > 1 && !(length($el_mult_left) == 2 && substr($el_mult_left,1,1) eq 'x')) {
		      $res = $res."[".$el_mult_left."])";
		  } else {
		      $res = $res.$el_mult_left.")";
		  }
		  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		      $Sheet->Cells($celli, $cellj)->{'Value'}
		      = $res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};				
		  } else {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
		  }
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }	
	}

	  if ($balls == -1) {
	      # Removing of one or several objects in Both Hand
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).$nmrhand.",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($rhandth - $nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($lhandth - $nmlhand == 0) {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(-".sprintf("%x",$rhandth - $nmrhand).",)";		  
			  } elsif ($rhandth - $nmrhand == 0) {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(,-".sprintf("%x",$lhandth - $nmlhand).")";		  
			  } else {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(-".sprintf("%x",$rhandth - $nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";    
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }	    
	  }
	  
      } elsif ($rhandth != 0 && $lhandth == 0) {	 
	  my @mult_list_right=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$rhandth));
	  
	LOOP1: foreach my $el_mult_right (@mult_list_right) {		
	    &common::displayComputingPrompt();
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);

	    for (my $i=0; $i<length($el_mult_right); $i++) {
		# Handle x on multiplex from right hand
		if (length($el_mult_right)>1 && hex(substr($el_mult_right, $i, 1)) > 0 && substr($el_mult_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_mult_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_mult_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";

		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> 15) {
			    next LOOP1;
			}
			$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));			    
		    }
		    $nrhand = $mult_to_add_loc_tmp;			
		}
	    }
	    
	    # Handle x on multiplex from right hand
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);			
	    my $mult_to_add_loc_tmp ="";
	    for (my $j=0;$j<length($nlhand);$j++) {
		my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_nlhand, $j, 1));
		if ( $r> 15) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
	    }
	    $nlhand=$mult_to_add_loc_tmp;
	    
	    my $nstate=$nrhand.",".$nlhand;
	    
	    my $idx_nstate=__get_idx_state(\@states, $nstate);

	    if ($idx_nstate >= 0) {		    
		$nbtransitions++;
		if ($SITESWAP_DEBUG >=1) {		   
		    print $rhand.",".$lhand." ===([".$el_mult_right."],"."0".")===> ".$nrhand.",".$nlhand."\n";		   
		}

		my $res="(";
		if (length($el_mult_right) > 1 && !(length($el_mult_right) == 2 && substr($el_mult_right,1,1) eq 'x')) {			  
		    $res = $res."[".$el_mult_right."],0)";
		} else {
		    $res = $res.$el_mult_right.",0)";
		}
		
		my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		    $Sheet->Cells($celli, $cellj)->{'Value'}
		    =$res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};				
		} else {
		    $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
		}	    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	    }	    	       		
	}

	  if ($balls == -1) {
	      # Adding of one or several objects (in Left Hand) and Removing of one or several objects (in Right Hand)
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $multiplex; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);
		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($rhandth - $nmrhand == 0 && $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($nmlhand == 0) {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(-".sprintf("%x",$rhandth - $nmrhand).",)";		  
			  } elsif ($rhandth - $nmrhand == 0) {		
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(,+".sprintf("%x",$nmlhand).")";
			  } else {
			      $nbtransitions++;
			      # A collapse could occur there
			      if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
				  $Sheet->Cells($celli, $cellj)->{'Value'}="(-".sprintf("%x",$rhandth - $nmrhand).",+".sprintf("%x",$nmlhand).")"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			      } else {
				  $Sheet->Cells($celli, $cellj)->{'Value'}="(-".sprintf("%x",$rhandth - $nmrhand).",+".sprintf("%x",$nmlhand).")";	
			      }
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	  }	    

      } elsif ($rhandth == 0 && $lhandth != 0) {	    		
	  my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	  my $nrhand_sav = $nrhand;
	  
	  my @mult_list_left=__get_multiplex_sync_single($_[0],$_[1],sprintf("%x",$lhandth));
	  LOOP1 : foreach my $el_mult_left (@mult_list_left) {		
	      $nrhand = $nrhand_sav;
	      my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	      my $mult_to_add_nrhand='0' x length($nrhand);

	      for (my $i=0; $i<length($el_mult_left); $i++) {
		  # Handle x on multiplex from left hand
		  my $mult_to_add_nrhand = '0' x length($nrhand);
		  if (length($el_mult_left)>1 && hex(substr($el_mult_left, $i, 1)) > 0 && substr($el_mult_left, $i +1, 1) eq "x") {
		      my $mult_to_add_nrhand2 = ('0' x (length($nrhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1)); 
		      my $mult_to_add_nrhand_tmp = "";
		      for (my $j =0; $j < length($mult_to_add_nrhand); $j++) {
			  my $r = hex(substr($mult_to_add_nrhand,$j,1)) + hex(substr($mult_to_add_nrhand2,$j,1));
			  if ( $r> 15) {
			      next LOOP1;
			  }
			  $mult_to_add_nrhand_tmp = $mult_to_add_nrhand_tmp.(sprintf("%x",$r));			
		      }
		      $mult_to_add_nrhand = $mult_to_add_nrhand_tmp;
		      $i++;
		      #last;
		  } elsif (hex(substr($el_mult_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_mult_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_mult_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      
		      for (my $j=0;$j<length($nlhand);$j++) {
			  my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			  if ( $r> 15) {
			      next LOOP1;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		      }
		      $nlhand = $mult_to_add_loc_tmp;			
		  }
		  
		  # Handle x on multiplex from left hand		    
		  my $mult_to_add_loc_tmp = "";
		  for (my $j=0;$j<length($nrhand);$j++) {
		      my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
		      if ( $r> 15) {
			  next LOOP1;
		      }
		      $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		  }
		  $nrhand = $mult_to_add_loc_tmp;
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    
		  $nbtransitions++;
		  if ($SITESWAP_DEBUG >=1) {		   
		      print $rhand.",".$lhand." ===(0".",[".$el_mult_left."])===> ".$nrhand.",".$nlhand."\n";		   
		  }
		  

		  my $res="(0,";

		  if (length($el_mult_left) > 1 && !(length($el_mult_left) == 2 && substr($el_mult_left,1,1) eq 'x')) {
		      $res = $res."[".$el_mult_left."])";
		  } else {
		      $res = $res.$el_mult_left.")";
		  }
		  
		  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=
			  $res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};      
		  } else {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
		  }	    
		  
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }

	  if ($balls == -1) {
	      # Adding of one or several objects (in Right Hand) and Removing of one or several objects (in Left Hand)
	      for (my $nmrhand = 0; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } elsif ($nmrhand == 0) {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(,-".sprintf("%x",$lhandth - $nmlhand).")";		  
			  } elsif ($lhandth - $nmlhand == 0) {
			      $nbtransitions++;
			      $Sheet->Cells($celli, $cellj)->{'Value'}="(+".sprintf("%x",$nmrhand).",)";		  
			  } else {
			      $nbtransitions++;
			      # A collapse could occur there
			      if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
				  $Sheet->Cells($celli, $cellj)->{'Value'}="(+".sprintf("%x",$nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			      } else {
				  $Sheet->Cells($celli, $cellj)->{'Value'}="(+".sprintf("%x",$nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";
			      }			    		  
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	  }	    
      } elsif ($rhandth == 0 && $lhandth == 0) {	    		
	  my $nrhand='0'.substr($rhand,0,length($rhand)-1);				
	  my $nlhand='0'.substr($lhand,0,length($lhand)-1);	
	  
	  &common::displayComputingPrompt();
	  my $nstate=$nrhand.",".$nlhand;
	  my $idx_nstate=__get_idx_state(\@states, $nstate);

	  if ($idx_nstate >= 0) {		    
	      $nbtransitions ++;
	      if ($SITESWAP_DEBUG >=1) {		   
		  print $rhand.",".$lhand." ===(0".","."0".")===> ".$nrhand.",".$nlhand."\n";		   
	      }	  

	      my $res="(0,0)";
	      my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
	      my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
	      if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		  $Sheet->Cells($celli, $cellj)->{'Value'}=
		      $res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};				
	      } else {
		  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
	      }				  
	  } else {
	      &common::hideComputingPrompt();
	      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	  }	

	  if ($balls == -1) {
	      #Adding of one or several objects (in each hand)
	      # ==> Both Hands
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		      $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=__get_idx_state(\@states, $nstate);		      

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($SITESWAP_DEBUG >=1) {		   
			      print $rhand.",".$lhand." ===(+".sprintf("%x",$nmrhand).",+".sprintf("%x",$nmlhand).")===> ".$nstate."\n";		   
			  }
			  $Sheet->Cells($celli, $cellj)->{'Value'}="(+".sprintf("%x",$nmrhand).",+".sprintf("%x",$nmlhand).")";		  	
			  $nbtransitions++;
			  if ($SITESWAP_DEBUG >=1) {		   
			      print $rhand.",".$lhand." ===(+".sprintf("%x",$nmrhand).",+".sprintf("%x",$nmlhand).")===> ".$nrhand.",".$nlhand."\n";		   
			  }	  

		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	      # ==> Right Hand only
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1)."0";	    	 	
		  my $idx_nstate=__get_idx_state(\@states, $nstate);

		  if ($idx_nstate >=0) {
		      my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		      my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		      $Sheet->Cells($celli, $cellj)->{'Value'}="(+".sprintf("%x",$nmrhand).",)";		  	 
		      $nbtransitions++;
		      if ($SITESWAP_DEBUG >=1) {		   
			  print $rhand.",".$lhand." ===(+".sprintf("%x",$nmrhand).",)===> ".$nstate."\n";		   
		      }

		  } else {
		      &common::hideComputingPrompt();
		      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		  }
	      }
	      # ==> Left Hand only
	      for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		  $nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);	    	 	
		  my $idx_nstate=__get_idx_state(\@states, $nstate);

		  if ($idx_nstate >=0) {
		      my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		      my ($celli, $cellj) = __get_xls_cell($idx_state_el +1, $idx_nstate +1);
		      $Sheet->Cells($celli, $cellj)->{'Value'}="(,+".sprintf("%x",$nmlhand).")";		  	 
		      $nbtransitions++;
		      if ($SITESWAP_DEBUG >=1) {		   
			  print $rhand.",".$lhand." ===(,+".sprintf("%x",$nmlhand).")===> ".$nstate."\n";		   
		      }
		  } else {
		      &common::hideComputingPrompt();
		      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		  }
	      }    				    
	  }    
      } 
  }


    my $idx_i =0;
    my $idx_j =0;
    foreach my $i (@states) {    	 
	
	# Coloring Median States
	my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	# Coloring Symetrics states 	
	if ($i =~ ",") {
	    my @res=split(/,/,$i);
	    my $nstate=$res[1].",".$res[0];
	    my $idx_nj=__get_idx_state(\@states,$nstate); 
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_nj +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_nj + 1);
	    $Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 15;
	}
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = __get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 12;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }

    
    #$last_row = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByRows})    -> {Row};
    #$last_col = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByColumns}) -> {Column};
    &common::hideComputingPrompt();        
    $Sheet->Range('B6')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < __get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * __get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = __get_xls_cell(0, $jdx +1);				
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    }
	    
	    $idx_sheet ++;
	}
	&common::hideComputingPrompt();
    }

    print colored [$common::COLOR_RESULT], "[ => ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";

    #$Book->Sheets(1)->Select();
    $Excel -> {'DisplayAlerts'} = 0; # This turns off the "This file already exists" message.
    $Book -> SaveAs ($file) or die $!;
    $Book->Close;    
    #$Excel->Quit();  
}

######################################################################
#  Test function to generate States/Transitions diagrams in Excel
######################################################################
sub __test_gen_all_states
{    
    if (uc($_[0]) eq "R" || uc($_[0]) eq "A") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {
		print "============== Matrix_R_-1_".sprintf("%x",$i)."==============\n";
		&writeStates_xls("R","-1", sprintf("%x",$i), "Matrix_R_any_".sprintf("%x",$i));		
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Matrix_R_".sprintf("%x",$i)."_".sprintf("%x",$j)."==============\n";
		    &writeStates_xls("R",sprintf("%x",$i), sprintf("%x",$j), "Matrix_R_".sprintf("%x",$i)."_".sprintf("%x",$j));
		}
	    }
	}
    } elsif (uc($_[0]) eq "S") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {		
		print "============== Matrix_S_any_".sprintf("%x",$i)."==============\n";
		&writeStates_xls("S",-1, sprintf("%x",$i), "Matrix_S_any_".sprintf("%x",$i));	   	
	    }
	} else {
	    $starti = hex($_[1]);

	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Matrix_S_".sprintf("%x",$i)."_".sprintf("%x",$j)."==============\n";
		    &writeStates_xls("S",sprintf("%x",$i), sprintf("%x",$j), "Matrix_S_".sprintf("%x",$i)."_".sprintf("%x",$j));	   
		}
	    }
	}
    } elsif (uc($_[0]) eq "M") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = hex($_[3]);

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Matrix_M_any_".sprintf("%x",$i)."_".sprintf("%x",$m)."==============\n";
		    &writeStates_xls("M",-1, sprintf("%x",$i), sprintf("%x",$m), "Matrix_M_any_".sprintf("%x",$i)."_".sprintf("%x",$m));	
		}
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Matrix_M_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m)."==============\n";
			&writeStates_xls("M",sprintf("%x",$i), sprintf("%x",$j), sprintf("%x",$m), "Matrix_M_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m));			
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MS" || uc($_[0]) eq "SM") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = hex($_[3]);

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Matrix_MS_any_".sprintf("%x",$i)."_".sprintf("%x",$m)."==============\n";
		    &writeStates_xls("MS",-1, sprintf("%x",$i), sprintf("%x",$m), "Matrix_MS_any_".sprintf("%x",$i)."_".sprintf("%x",$m));			    
		}
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Matrix_MS_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m)."==============\n";
			&writeStates_xls("MS",sprintf("%x",$i), sprintf("%x",$j), sprintf("%x",$m), "Matrix_MS_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m));			
		    }
		}
	    }
	}
    }
}


sub __test_gen_all_aggr_states
{    
    if (uc($_[0]) eq "R" || uc($_[0]) eq "A") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {
		print "============== Aggr_Matrix_R_-1_".sprintf("%x",$i)."==============\n";
		&genStatesAggr("R","-1", sprintf("%x",$i), "XLS:Aggr_Matrix_R_any_".sprintf("%x",$i));		
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Aggr_Matrix_R_".sprintf("%x",$i)."_".sprintf("%x",$j)."==============\n";
		    &genStatesAggr("R",sprintf("%x",$i), sprintf("%x",$j), "XLS:Aggr_Matrix_R_".sprintf("%x",$i)."_".sprintf("%x",$j));
		}
	    }
	}
    } elsif (uc($_[0]) eq "S") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {		
		print "============== Aggr_Matrix_S_any_".sprintf("%x",$i)."==============\n";
		&genStatesAggr("S",-1, sprintf("%x",$i), "XLS:Aggr_Matrix_S_any_".sprintf("%x",$i));	   	
	    }
	} else {
	    $starti = hex($_[1]);

	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Aggr_Matrix_S_".sprintf("%x",$i)."_".sprintf("%x",$j)."==============\n";
		    &genStatesAggr("S",sprintf("%x",$i), sprintf("%x",$j), "XLS:Aggr_Matrix_S_".sprintf("%x",$i)."_".sprintf("%x",$j));	   
		}
	    }
	}
    } elsif (uc($_[0]) eq "M") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = hex($_[3]);

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Aggr_Matrix_M_any_".sprintf("%x",$i)."_".sprintf("%x",$m)."==============\n";
		    &genStatesAggr("M",-1, sprintf("%x",$i), sprintf("%x",$m), "XLS:Aggr_Matrix_M_any_".sprintf("%x",$i)."_".sprintf("%x",$m));	
		}
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Aggr_Matrix_M_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m)."==============\n";
			&genStatesAggr("M",sprintf("%x",$i), sprintf("%x",$j), sprintf("%x",$m), "XLS:Aggr_Matrix_M_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m));			
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MS" || uc($_[0]) eq "SM") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = hex($_[3]);

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Aggr_Matrix_MS_any_".sprintf("%x",$i)."_".sprintf("%x",$m)."==============\n";
		    &genStatesAggr("MS",-1, sprintf("%x",$i), sprintf("%x",$m), "XLS:Matrix_MS_any_".sprintf("%x",$i)."_".sprintf("%x",$m));			    
		}
	    }
	} else {
	    $starti = hex($_[1]);
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Aggr_Matrix_MS_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m)."==============\n";
			&genStatesAggr("MS",sprintf("%x",$i), sprintf("%x",$j), sprintf("%x",$m), "XLS:Aggr_Matrix_MS_".sprintf("%x",$i)."_".sprintf("%x",$j)."_".sprintf("%x",$m));			
		    }
		}
	    }
	}
    }
}


######################################################################
#  Test functions to generate Vanilla Siteswaps from Probert's Diagram
######################################################################
sub __test_gen_all_ss_probert
{
    my $start_period = 8;
    my $end_period = 15;
    my $start_number = 2;
    my $end_number = 15;
    my $state = "HTML";
    my $start_f ="";
    my $end_f =".txt";
    
    if(scalar @_ == 2)
    {
	$start_period = $_[1];
	$start_number = $_[0];
    }

    if($state eq "HTML")
    {
	$start_f="HTML:";
	$end_f="";
    }

    for (my $i=$start_number; $i<=$end_number;$i++) {
	for (my $j=$start_period;$j<=$end_period;$j++) {
	    print "============== Gen : Period=".$j."; Objects=".$i." ==============\n";
	    &genSSProbert($i,"-1",$j,'-t',$start_f."SSProbert_".$i."_p".$j.$end_f);
	}
    }
}

sub __test_gen_all_ss_reduced_probert
{
    my $start_period = 8;
    my $end_period = 15;
    my $start_number = 1;
    my $end_number = 15;
    my $state = "HTML";
    my $start_f ="";
    my $end_f =".txt";
    
    if(scalar @_ == 2)
    {
	$start_period = $_[1];
	$start_number = $_[0];
    }

    if($state eq "HTML")
    {
	$start_f="HTML:";
	$end_f="";
    }

    for (my $i=$start_number; $i<=$end_number;$i++) {
	for (my $j=$start_period;$j<=$end_period;$j++) {
	    print "============== Gen : Period=".$j."; Objects=".$i." ==============\n";
	    &genSSProbert($i,"-1",$j,'-p -t',$start_f."SSProbert_reduced_".$i."_p".$j.$end_f);
	}
    }
}


######################################################################
#  Test functions to generate Magic Siteswaps 
######################################################################
sub __test_gen_magic_ss
{
    
    my $start_period = 0;
    if(scalar @_ > 1)
    {
	$start_period = $_[1];
    }

    my $end_period = 15;   
    my $nbmax_mult = 8;

    my $mod = $_[0];
    my $state = "HTML";
    my $start_f ="";
    my $end_f =".txt";
    
    if($state eq "HTML")
    {
	$start_f="HTML:";
	$end_f="";
    }

    if ($mod eq "A" ||$mod eq "R")
    {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";
	    print "== ALL == "."\n";
	    &genSSMagic($mod,"all",$i,'-e',$start_f."MagicSS-R_all_".$i.$end_f);
	    print "== ALL REDUCED ==  "."\n";
	    &genSSMagic($mod,"all",$i,'-p2 -e',$start_f."MagicSS-R_all_reduced_".$i.$end_f);
	    print "== EVEN == "."\n";
	    &genSSMagic($mod,"Pair",$i,'-e',$start_f."MagicSS-R_even_".$i.$end_f);
	    print "== EVEN REDUCED ==  "."\n";
	    &genSSMagic($mod,"Pair",$i,'-p2 -e',$start_f."MagicSS-R_even_reduced_".$i.$end_f);
	    print "== ODD == "."\n";
	    &genSSMagic($mod,"Impair",$i,'-e',$start_f."MagicSS-R_odd_".$i.$end_f);
	    print "== ODD REDUCED == "."\n";
	    &genSSMagic($mod,"Impair",$i,'-p2 -e',$start_f."MagicSS-R_odd_reduced_".$i.$end_f);
	}   
    }
    elsif ($mod eq "M")
    {	
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";
	    print "== ALL == "."\n";
	    &genSSMagic($mod,"all",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-M_all_".$i.$end_f);
	    print "== ALL REDUCED == \n ";
	    &genSSMagic($mod,"all",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-M_all_reduced_".$i.$end_f);
	    print "== EVEN == "."\n";
	    &genSSMagic($mod,"Pair",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-M_even_".$i.$end_f);
	    print "== EVEN REDUCED ==  "."\n";
	    &genSSMagic($mod,"Pair",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-M_even_reduced_".$i.$end_f);
	    print "== ODD == "."\n";
	    &genSSMagic($mod,"Impair",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-M_odd_".$i.$end_f);
	    print "== ODD REDUCED == "."\n";
	    &genSSMagic($mod,"Impair",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-M_odd_reduced_".$i.$end_f);
	}   
    }
    elsif ($mod eq "S")
    {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";
	    #print "== ALL == "."\n";
	    #&genSSMagic($mod,"all",$i,'-e',$start_f."MagicSS-S_all_".$i.$end_f);
	    #print "== ALL REDUCED ==  "."\n";
	    #&genSSMagic($mod,"all",$i,'-p2 -e',$start_f."MagicSS-S_all_reduced_".$i.$end_f);
	    print "== EVEN == "."\n";
	    &genSSMagic($mod,"Pair",$i,'-e',$start_f."MagicSS-S_even_".$i.$end_f);
	    print "== EVEN REDUCED ==  "."\n";
	    &genSSMagic($mod,"Pair",$i,'-p2 -e',$start_f."MagicSS-S_even_reduced_".$i.$end_f);
	    #print "== ODD == "."\n";
	    #&genSSMagic($mod,"Impair",$i,'-e',$start_f."MagicSS-S_odd_".$i.$end_f);
	    #print "== ODD REDUCED == "."\n";
	    #&genSSMagic($mod,"Impair",$i,'-p2 -e',$start_f."MagicSS-S_odd_reduced_".$i.$end_f);
	}   
    }
    elsif ($mod eq "MS" || $mod eq "SM")
    {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";
	    #print "== ALL == "."\n";
	    #&genSSMagic($mod,"all",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-MS_all_".$i.$end_f);
	    #print "== ALL REDUCED ==  "."\n";
	    #&genSSMagic($mod,"all",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-MS_all_reduced_".$i.$end_f);
	    print "== EVEN == "."\n";
	    &genSSMagic($mod,"Pair",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-MS_even_".$i.$end_f);
	    print "== EVEN REDUCED ==  "."\n";
	    &genSSMagic($mod,"Pair",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-MS_even_reduced_".$i.$end_f);
	    #print "== ODD == "."\n";
	    #&genSSMagic($mod,"Impair",$i,$nbmax_mult,'-e -s',$start_f."MagicSS-MS_odd_".$i.$end_f);
	    #print "== ODD REDUCED == "."\n";
	    #&genSSMagic($mod,"Impair",$i,$nbmax_mult,'-p2 -e -s',$start_f."MagicSS-MS_odd_reduced_".$i.$end_f);
	}   
    }
    
}



######################################################################
#  Tests 
######################################################################
sub __test 
{
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"531\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('531');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"532\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('532');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"345\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('345');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"b97531\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('b97531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] ) *\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('( 2x , [22x] ) ( 2 , [22] ) ( 2 , [22x] ) *');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"24[54]\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('24[54]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"([44],[44])(4,0)\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('([44],[44])(4,0)');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"([4x4],2)(0,2)(2,[22])*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('([4x4],2)(0,2)(2,[22])*');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6,4)(2,4)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6,4)(2,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6,4)(4x,2x)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6,4)(4x,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6,4x)(4x,2)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6,4x)(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6,4x)(2x,4)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6,4x)(2x,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6x,4)(2,4x)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6x,4)(2,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6x,4)(4,2x)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6x,4x)(2x,4x)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6x,4x)(2x,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6x,4x)(4,2)*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6x,4x)(4,2)*');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(6x,4)(2x,4)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(6x,4)(2x,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"[432]0[66]\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('[432]0[66]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(0x,2x)(4x,6x)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(0x,2x)(4x,6x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(0x,2)(4,6)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(0x,2)(4,6)');       

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(1,3)(5,7)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(1,3)(5,7');           

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Validity : SSWAP::isValid(\"(7x,5x)(3x,1x)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid('(7x,5x)(3x,1x)');           

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] )*\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('( 2x , [22x] ) ( 2 , [22] )( 2,[22x] )*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"[43]2[44]3\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[43]2[44]3');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"[43]2[43]4\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[43]2[43]4'); 

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"[01]2345\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[01]2345');        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"[01]2354\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[01]2354');        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGen States/Transitions Matrix : SSWAP::genStates(\"R\",3,5);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &genStates('R',3,5);        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence : SSWAP::isEquivalent(SSWAP::inv('714',-1),'741');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent(SSWAP::inv('714',-1),'741');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence : SSWAP::isEquivalent(SSWAP::inv('714',-1),'714');\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent(SSWAP::inv('714',-1),'714');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('3[43]23[32]','3[34]23[23]');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('3[43]23[32]','3[34]23[23]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('3[43]23[32]','3[23]3[43]2');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('3[43]23[32]','3[23]3[43]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('(6x,4)(4,6x)','(4,6x)(6x,4)');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('(6x,4)(4,6x)','(4,6x)(6x,4)');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('(6x,4)*','(4,6x)(6x,4)');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('(6x,4)*','(4,6x)(6x,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('(6x,4)*','(4,6x)*');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('(6x,4)*','(4,6x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('([4x4],2)(0,2)(2,[22])*','(2,[4x4])(2,0)([22],2)*');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('([4x4],2)(0,2)(2,[22])*','(2,[4x4])(2,0)([22],2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('(2x,[22x])(2,[22])(2,[22x])*','(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)(2x,[22x])');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('(2x,[22x])(2,[22])(2,[22x])*','(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)(2x,[22x])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence :  SSWAP::isEquivalent('(2x,[22x])(2,[22])(2,[22x])*','(2,[22x])([22x],2x)([22],2)([22x],2)(2x,[22x])(2,[22])');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent('(2x,[22x])(2,[22])(2,[22x])*','(2,[22x])([22x],2x)([22],2)([22x],2)(2x,[22x])(2,[22])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::inv('3[31]2');\n\t\t==> 1[32]3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &inv('3[31]2');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('3[13]2');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('3[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('9753197531');\n\t\t==> 9753197531\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('9753197531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('9753197531*');\n\t\t==> 9753197531\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('9753197531*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6,4)(2,4)(4,6)(4,2)');\n\t\t==> (6,4)(2,4)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6,4)(2,4)(4,6)(4,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6,4)(4x,2x)(4,6)(2x,4x)');\n\t\t==> (6,4)(4x,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6,4)(4x,2x)(4,6)(2x,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6,4x)(4x,2)(4x,6)(2,4x)');\n\t\t==> (6,4x)(4x,2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6,4x)(4x,2)(4x,6)(2,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6,4x)(2x,4)(4x,6)(4,2x)');\n\t\t==> (6,4x)(2x,4)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6,4x)(2x,4)(4x,6)(4,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6x,4)(2,4x)(4,6x)(4x,2)');\n\t\t==> (6x,4)(2,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6x,4)(2,4x)(4,6x)(4x,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6x,4)(4,2x)(4,6x)(2x,4)');\n\t\t==> (6x,4)(4,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6x,4)(4,2x)(4,6x)(2x,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6x,4x)(2x,4x)(4x,6x)(4x,2x)');\n\t\t==> (6x,4x)(2x,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6x,4x)(2x,4x)(4x,6x)(4x,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(6x,4x)(4,2)(4x,6x)(2,4)');\n\t\t==> (6x,4x)(4,2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(6x,4x)(4,2)(4x,6x)(2,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');\n\t\t==> ([4x4],2)(0,2)(2,[22])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('[64][62]1[22]2[64][62]1[22]2');\n\t\t==> [64][62]1[22]2[64][62]1[22]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('[64][62]1[22]2[64][62]1[22]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('([22x],2)(2,[22x])');\n\t\t==> ([2x2],2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('([22x],2)(2,[22x])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');\n\t\t==> (2x,[2x2])(2,[22])(2,[2x2])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('3[13]2');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('3[31]2');   

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('3[13]2*');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('3[31]2*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('3[13]23[13]2');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('3[31]23[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('3[13]23[13]23[31]2');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('3[31]23[31]23[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('97531975319753197531');\n\t\t==> 9753197531\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('97531975319753197531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('9753197531*');\n\t\t==> 9753197531\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('9753197531*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6,4)(2,4)(4,6)(4,2)(6,4)(2,4)(4,6)(4,2)');\n\t\t==> (6,4)(2,4)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6,4)(2,4)(4,6)(4,2)(6,4)(2,4)(4,6)(4,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6,4)(4x,2x)(4,6)(2x,4x)(6,4)(4x,2x)(4,6)(2x,4x)');\n\t\t==> (6,4)(4x,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6,4)(4x,2x)(4,6)(2x,4x)(6,4)(4x,2x)(4,6)(2x,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6,4x)(4x,2)(4x,6)(2,4x)(6,4x)(4x,2)(4x,6)(2,4x)');\n\t\t==> (6,4x)(4x,2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6,4x)(4x,2)(4x,6)(2,4x)(6,4x)(4x,2)(4x,6)(2,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)');\n\t\t==> (6,4x)(2x,4)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6x,4)(2,4x)(4,6x)(4x,2)(6x,4)(2,4x)(4,6x)(4x,2)');\n\t\t==> (6x,4)(2,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6x,4)(2,4x)(4,6x)(4x,2)(6x,4)(2,4x)(4,6x)(4x,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6x,4)(4,2x)*');\n\t\t==> (6x,4)(4,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6x,4x)(2x,4x)(4x,6x)(4x,2x)(6x,4x)(2x,4x)(4x,6x)(4x,2x)');\n\t\t==> (6x,4x)(2x,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6x,4x)(2x,4x)(4x,6x)(4x,2x)(6x,4x)(2x,4x)(4x,6x)(4x,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)');\n\t\t==> (6x,4x)(4,2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');\n\t\t==> ([4x4],2)(0,2)(2,[22])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');\n\t\t==> ([4x4],2)(0,2)(2,[22])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('([4x4],2)(0,2)(2,[22])*');\n\t\t==> ([4x4],2)(0,2)(2,[22])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('([4x4],2)(0,2)(2,[22])*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('[64][62]1[22]2[64][62]1[22]2');\n\t\t==> [64][62]1[22]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('[64][62]1[22]2[64][62]1[22]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('([22x],2)(2,[22x])');\n\t\t==> ([2x2],2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('([22x],2)(2,[22x])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');\n\t\t==> (2x,[2x2])(2,[22])(2,[2x2])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::periodMin('(2x,[22x])(2,[22])(2,[22x])*');\n\t\t==> (2x,[2x2])(2,[22])(2,[2x2])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &periodMin('(2x,[22x])(2,[22])(2,[22x])*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"531\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('531');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"532\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('532');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"345\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('345');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"b97531\");\n\t\t==> 6\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('b97531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] ) *\");\n\t\t==> 6\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('( 2x , [22x] ) ( 2 , [22] ) ( 2 , [22x] ) *');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"24[54]\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('24[54]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"([44],[44])(4,0)\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('([44],[44])(4,0)');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"([4x4],2)(0,2)(2,[22])*\");\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('([4x4],2)(0,2)(2,[22])*');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6,4)(2,4)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6,4)(2,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6,4)(4x,2x)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6,4)(4x,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6,4x)(4x,2)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6,4x)(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6,4x)(2x,4)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6,4x)(2x,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6x,4)(2,4x)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6x,4)(2,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6x,4)(4,2x)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6x,4x)(2x,4x)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6x,4x)(2x,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6x,4x)(4,2)*\");\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6x,4x)(4,2)*');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"(6x,4)(2x,4)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('(6x,4)(2x,4)');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Period : SSWAP::getPeriod(\"[432]0[66]\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriod('[432]0[66]');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"531\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('531');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"532\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('532');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"345\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('345');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"b97531\");\n\t\t==> 6\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('b97531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] ) *\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('( 2x , [22x] ) ( 2 , [22] ) ( 2 , [22x] ) *');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"24[54]\");\n\t\t==> 5\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('24[54]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"([44],[44])(4,0)\");\n\t\t==> 5\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('([44],[44])(4,0)');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"([4x4],2)(0,2)(2,[22])*\");\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('([4x4],2)(0,2)(2,[22])*');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6,4)(2,4)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6,4)(2,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6,4)(4x,2x)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6,4)(4x,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6,4x)(4x,2)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6,4x)(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6,4x)(2x,4)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6,4x)(2x,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6x,4)(2,4x)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6x,4)(2,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6x,4)(4,2x)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6x,4x)(2x,4x)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6x,4x)(2x,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6x,4x)(4,2)*\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6x,4x)(4,2)*');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"(6x,4)(2x,4)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('(6x,4)(2x,4)');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Objects Number : SSWAP::getObjNumber(\"[432]0[66]\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getObjNumber('[432]0[66]');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"531\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('531');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"532\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('532');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"345\");\n\t\t==> EXCITED\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('345');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"b97531\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('b97531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] ) *\");\n\t\t==> EXCITED\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('( 2x , [22x] ) ( 2 , [22] ) ( 2 , [22x] ) *');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"24[54]\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('24[54]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"([44],[44])(4,0)\");\n\t\t==> EXCITED\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('([44],[44])(4,0)');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"([4x4],2)(0,2)(2,[22])*\");\n\t\t==> EXCITED\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('([4x4],2)(0,2)(2,[22])*');    

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6,4)(2,4)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6,4)(2,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6,4)(4x,2x)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6,4)(4x,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6,4x)(4x,2)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6,4x)(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6,4x)(2x,4)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6,4x)(2x,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6x,4)(2,4x)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6x,4)(2,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6x,4)(4,2x)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6x,4x)(2x,4x)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6x,4x)(2x,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6x,4x)(4,2)*\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6x,4x)(4,2)*');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"(6x,4)(2x,4)\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('(6x,4)(2x,4)');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"[432]0[66]\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('[432]0[66]');
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"([604],2)\");\n\t\t==> GROUND\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('([604],2)');

    
}


1;

