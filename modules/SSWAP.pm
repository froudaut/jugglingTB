#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## SSWAP.pm   - Perl Implementation of the Siteswap juggling Notation       ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2010-2021  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
##                                                                          ##
##                                                                          ##
## This program is free software; you can redistribute it and/or modify it  ##
## under the terms of the GNU General Public License version 3 as           ##
## published by the Free Software Foundation; version 3.                    ##
##                                                                          ##
## This program is distributed in the hope that it will be useful, but      ##
## WITHOUT ANY WARRANTY; without even the implied warranty of               ##
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU        ##
## General Public License for more details.                                 ##
##                                                                          ##
##############################################################################

package SSWAP;
use common;
use lang;
use strict;
use Cwd;
use Term::ANSIColor;    
use modules::SSWAP_GRAMMAR;    
use modules::LADDER;    
use Getopt::Long qw(GetOptionsFromString);
use Set::Scalar;
use File::Copy;
use List::MoreUtils qw(uniq);
use List::MoreUtils qw(any);
use POSIX;

$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

our $SSWAP_INFO = "SITESWAP juggling Notation";
our $SSWAP_HELP = $lang::MSG_SSWAP_MENU_HELP;
our $SSWAP_VERSION = "v1.5";


our %SSWAP_CMDS = 
    (    
	 'anim'                  => ["$lang::MSG_SSWAP_MENU_ANIMATE_1","$lang::MSG_SSWAP_MENU_ANIMATE_2"], 
	 'animAntiSS'            => ["$lang::MSG_SSWAP_MENU_ANIMATE_ANTISS_1","$lang::MSG_SSWAP_MENU_ANIMATE_ANTISS_2"], 
	 'genTransTeodoro'       => ["$lang::MSG_SSWAP_MENU_GENTRANSTEODORO_1","$lang::MSG_SSWAP_MENU_GENTRANSTEODORO_2"],	 
	 'realsim'               => ["$lang::MSG_SSWAP_MENU_REALSIM_1","$lang::MSG_SSWAP_MENU_REALSIM_2"], 	 
	 'draw'                  => ["$lang::MSG_SSWAP_MENU_DRAW_1", "$lang::MSG_SSWAP_MENU_DRAW_2"],
	 'drawStates'            => ["$lang::MSG_SSWAP_MENU_DRAWSTATES_1","$lang::MSG_SSWAP_MENU_DRAWSTATES_2"."\n\n"."$lang::MSG_SSWAP_MENU_DRAWSTATES_OPT"], 
	 'drawStatesAggr'        => ["$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_1","$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_2"."\n\n"."$lang::MSG_SSWAP_MENU_DRAWAGGRSTATES_OPT"], 
	 'genSS'                 => ["$lang::MSG_SSWAP_MENU_GENSS_1","$lang::MSG_SSWAP_MENU_GENSS_2"],
	 'genSSFromStates'       => ["$lang::MSG_SSWAP_MENU_GENSSFROMSTATES_1","$lang::MSG_SSWAP_MENU_GENSSFROMSTATES_2"],   
	 'genSSFromStatesAggr'   => ["$lang::MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_1","$lang::MSG_SSWAP_MENU_GENSSFROMAGGRSTATES_2"],   
	 'genSSPrime'            => ["$lang::MSG_SSWAP_MENU_GENSSPRIME_1","$lang::MSG_SSWAP_MENU_GENSSPRIME_2"],
	 'genStates'             => ["$lang::MSG_SSWAP_MENU_GENSTATES_1","$lang::MSG_SSWAP_MENU_GENSTATES_2"], 			  
	 'getStates'             => ["$lang::MSG_SSWAP_MENU_GETSTATES_1","$lang::MSG_SSWAP_MENU_GETSTATES_2"], 		    
	 'getAnagrammes'         => ["$lang::MSG_SSWAP_MENU_GETANAGRAMMES_1","$lang::MSG_SSWAP_MENU_GETANAGRAMMES_2"], 		    
	 'genStatesAggr'         => ["$lang::MSG_SSWAP_MENU_GENAGGRSTATES_1","$lang::MSG_SSWAP_MENU_GENAGGRSTATES_2"],
	 'genDiagProbert'        => ["$lang::MSG_SSWAP_MENU_GENPROBERTDIAG_1","$lang::MSG_SSWAP_MENU_GENPROBERTDIAG_2"],
	 'genSSPerm'             => ["$lang::MSG_SSWAP_MENU_GENPERMSS_1","$lang::MSG_SSWAP_MENU_GENPERMSS_2"],
	 #'genPolyrythmOld'       => ["$lang::MSG_SSWAP_MENU_GENPOLYRYTHMOLD_1","$lang::MSG_SSWAP_MENU_GENPOLYRYTHMOLD_2"],
	 'genPolyrythm'          => ["$lang::MSG_SSWAP_MENU_GENPOLYRYTHM_1","$lang::MSG_SSWAP_MENU_GENPOLYRYTHM_2"],
	 'genPolyrythmMult'      => ["$lang::MSG_SSWAP_MENU_GENPOLYRYTHMMULT_1","$lang::MSG_SSWAP_MENU_GENPOLYRYTHMMULT_2"],
	 'genSSProbert'          => ["$lang::MSG_SSWAP_MENU_GENPROBERTSS_1","$lang::MSG_SSWAP_MENU_GENPROBERTSS_2"],
	 'genSSMagic'            => ["$lang::MSG_SSWAP_MENU_GENMAGICSS_1","$lang::MSG_SSWAP_MENU_GENMAGICSS_2"],
	 'genSSMagicStadler'     => ["$lang::MSG_SSWAP_MENU_GENMAGICSTADLERSS_1","$lang::MSG_SSWAP_MENU_GENMAGICSTADLERSS_2"],
	 'genScramblablePolster' => ["$lang::MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_1","$lang::MSG_SSWAP_MENU_GENSCRAMBLABLEPOLSTERSS_2"],
	 'genSSFromThrows'       => ["$lang::MSG_SSWAP_MENU_GENSSFROMTHROWS_1","$lang::MSG_SSWAP_MENU_GENSSFROMTHROWS_2"],
 	 'genTrans'              => ["$lang::MSG_SSWAP_MENU_GENTRANS_1","$lang::MSG_SSWAP_MENU_GENTRANS_2"],
 	 'showVanillaDiag'       => ["$lang::MSG_SSWAP_MENU_SHOWVANILLADIAG_1","$lang::MSG_SSWAP_MENU_SHOWVANILLADIAG_2"], 
	 'genTransBtwnSS'        => ["$lang::MSG_SSWAP_MENU_GENTRANSBTWNSS_1","$lang::MSG_SSWAP_MENU_GENTRANSBTWNSS_2"],
	 'genTransBtwnSSAggr'    => ["$lang::MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_1","$lang::MSG_SSWAP_MENU_GENTRANSBTWNSSAGGR_2"],
	 'genTransBtwnStates'    => ["$lang::MSG_SSWAP_MENU_GENTRANSBTWNSTATES_1","$lang::MSG_SSWAP_MENU_GENTRANSBTWNSTATES_2"],
	 'genTransBtwnStatesAggr' => ["$lang::MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_1","$lang::MSG_SSWAP_MENU_GENTRANSBTWNAGGRSTATES_2"],
	 'isEquivalent'          => ["$lang::MSG_SSWAP_MENU_ISEQUIVALENT_1","$lang::MSG_SSWAP_MENU_ISEQUIVALENT_2"], 	
	 'isSyntaxValid'         => ["$lang::MSG_SSWAP_MENU_ISSYNTAXVALID_1","$lang::MSG_SSWAP_MENU_ISSYNTAXVALID_2"], 
	 'isValid'               => ["$lang::MSG_SSWAP_MENU_ISVALID_1","$lang::MSG_SSWAP_MENU_ISVALID_2"], 
	 'isPalindrome'          => ["$lang::MSG_SSWAP_MENU_ISPALINDROME_1","$lang::MSG_SSWAP_MENU_ISPALINDROME_2"], 
	 'isPrime'               => ["$lang::MSG_SSWAP_MENU_ISPRIME_1","$lang::MSG_SSWAP_MENU_ISPRIME_2"],
	 'isFullMagic'           => ["$lang::MSG_SSWAP_MENU_ISFULLMAGIC_1","$lang::MSG_SSWAP_MENU_ISFULLMAGIC_2"],
	 'isReversible'          => ["$lang::MSG_SSWAP_MENU_ISREVERSIBLE_1","$lang::MSG_SSWAP_MENU_ISREVERSIBLE_2"], 
	 'isScramblable'         => ["$lang::MSG_SSWAP_MENU_ISSCRAMBLABLE_1","$lang::MSG_SSWAP_MENU_ISSCRAMBLABLE_2"], 
	 'isSqueeze'             => ["$lang::MSG_SSWAP_MENU_ISSQUEEZE_1","$lang::MSG_SSWAP_MENU_ISSQUEEZE_2"], 
	 'timeRevDiag'           => ["$lang::MSG_SSWAP_MENU_TIMEREVDIAG_1","$lang::MSG_SSWAP_MENU_TIMEREVDIAG_2"], 
	 'timeRev'               => ["$lang::MSG_SSWAP_MENU_TIMEREV_1","$lang::MSG_SSWAP_MENU_TIMEREV_2"], 
	 'sym'                   => ["$lang::MSG_SSWAP_MENU_SYM_1","$lang::MSG_SSWAP_MENU_SYM_2"],
 	 'symDiag'               => ["$lang::MSG_SSWAP_MENU_SYMDIAG_1","$lang::MSG_SSWAP_MENU_SYMDIAG_2"], 
	 'simplify'              => ["$lang::MSG_SSWAP_MENU_SIMPLIFY_1","$lang::MSG_SSWAP_MENU_SIMPLIFY_2"],   
	 'getPeriodMin'          => ["$lang::MSG_SSWAP_MENU_PERIODMIN_1","$lang::MSG_SSWAP_MENU_PERIODMIN_2"],   
	 'getHeightMin'          => ["$lang::MSG_SSWAP_MENU_GETHEIGHTMIN_1","$lang::MSG_SSWAP_MENU_GETHEIGHTMIN_2"],   
	 'getHeightMax'          => ["$lang::MSG_SSWAP_MENU_GETHEIGHTMAX_1","$lang::MSG_SSWAP_MENU_GETHEIGHTMAX_2"],   
	 'shrink'                => ["$lang::MSG_SSWAP_MENU_SHRINK_1","$lang::MSG_SSWAP_MENU_SHRINK_2"],   
	 'expandSync'            => ["$lang::MSG_SSWAP_MENU_EXPANDSYNC_1","$lang::MSG_SSWAP_MENU_EXPANDSYNC_2"],  
	 'getInfo'               => ["$lang::MSG_SSWAP_MENU_GETINFO_1","$lang::MSG_SSWAP_MENU_GETINFO_2"],   
	 'getOrbits'             => ["$lang::MSG_SSWAP_MENU_GETORBITS_1","$lang::MSG_SSWAP_MENU_GETORBITS_2"],   
	 'getOrbitsAggr'         => ["$lang::MSG_SSWAP_MENU_GETORBITSAGGR_1","$lang::MSG_SSWAP_MENU_GETORBITSAGGR_2"],   
	 'getObjNumber'          => ["$lang::MSG_SSWAP_MENU_GETNUMBER_1","$lang::MSG_SSWAP_MENU_GETNUMBER_2"],   
	 'getPeriod'             => ["$lang::MSG_SSWAP_MENU_GETPERIOD_1","$lang::MSG_SSWAP_MENU_GETPERIOD_2"],   
	 'getSSstatus'           => ["$lang::MSG_SSWAP_MENU_GETSSSTATUS_1","$lang::MSG_SSWAP_MENU_GETSSSTATUS_2"],   
	 'getSSType'             => ["$lang::MSG_SSWAP_MENU_GETSSTYPE_1","$lang::MSG_SSWAP_MENU_GETSSTYPE_2"],   
	 'writeStates_xls'       => ["$lang::MSG_SSWAP_MENU_WRITESTATES_1","$lang::MSG_SSWAP_MENU_WRITESTATES_2"],
	 'printSSList'           => ["$lang::MSG_SSWAP_MENU_PRINTSSLIST_1","$lang::MSG_SSWAP_MENU_PRINTSSLIST_2"],
	 'printSSListHTML'       => ["$lang::MSG_SSWAP_MENU_PRINTSSLISTHTML_1","$lang::MSG_SSWAP_MENU_PRINTSSLISTHTML_2"],	 
	 'toStack'               => ["$lang::MSG_SSWAP_MENU_TOSTACK_1","$lang::MSG_SSWAP_MENU_TOSTACK_2"],	 
	 'jdeep'                 => ["$lang::MSG_SSWAP_MENU_JDEEP_1","$lang::MSG_SSWAP_MENU_JDEEP_2"],
	 'dual'                  => ["$lang::MSG_SSWAP_MENU_DUAL_1","$lang::MSG_SSWAP_MENU_DUAL_2"],
 	 'slideSwitchSync'       => ["$lang::MSG_SSWAP_MENU_SLIDESWITCHSYNC_1","$lang::MSG_SSWAP_MENU_SLIDESWITCHSYNC_2"],
	 'polyrythmFountain'     => ["$lang::MSG_SSWAP_MENU_POLYRYTHMFOUNTAIN_1","$lang::MSG_SSWAP_MENU_POLYRYTHMFOUNTAIN_2"],
	 'lowerHeightOnTempo'    => ["$lang::MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_1","$lang::MSG_SSWAP_MENU_LOWERHEIGHTONTEMPO_2"],
    );


print "SSWAP $SSWAP::SSWAP_VERSION loaded\n";

# To add debug behaviour 
our $SSWAP_DEBUG=1;

# Parameters for Excel writing
# It supports Excel 2007 with 1,048,576 rows x 16,384 columns.
my $EXCEL_MAX_COLS = 16000;	# Max columns
my $EXCEL_MAX_ROWS = 16000;	# Max rows
my $EXCEL_COL_START = 2;	# column pad for writing
my $EXCEL_ROW_START = 9;	# raw pad for writing

# When used in JugglingLab
my $balls_colors="{red}{green}{blue}{yellow}{magenta}{gray}{pink}{black}{cyan}{orange}";
my $JUGGLING_LAB_PATH=$conf::JUGGLING_LAB_PATH;
if(substr($JUGGLING_LAB_PATH,0,5) eq '[CWD]')
{
    my $pwd = cwd();
    $JUGGLING_LAB_PATH = $pwd.'/'.substr($JUGGLING_LAB_PATH,5);
}

my $MAX_MULT = 15;
my $MAX_HEIGHT = 15;
my $MAX_NBOBJ = 15;


## 
## README : How to write SS Lists results in Files SSHTML/JML/TXT or stdout ? 
##
##   # -- Example for function with 5 parameters : 
##
## $opts = $_[3];
## $f = $_[4];
##
## if ($f eq "") {
##      ### Issue the results on stdout 
##      @res = &printSSListWithoutHeaders((\@res,$_[3]));
## }
## elsif ("JML:"=~substr($f,0,4)) 
##      {
##         ### Code to issue an JML file with extension .jml for JugglingLab view
##	   @res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
##      }  	
## elsif ("SSHTML:"=~substr($_[4],0,7)) 	
##      {
##         ### Code to issue an HTML file with extension .html with some information on the Siteswaps.";   
##         @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[3],$_[4]);				
##      }
## elsif ($f ne "-1")
##      {
##        ### Issue the results into a given file 
##        @res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
##      }
##


sub sort_num { return $a <=> $b }


# Compute the the PGCD of two numbers
sub __pgcd
{
    my $m=$_[0];
    my $n=$_[1];
    my $r=0;

    while($m%$n !=0)
    {
	$r=$m%$n;
	$m=$n;
	$n=$r;
    }

    return $r;
}

# Check if two number are relatively prime
sub __prime
{
    my $m=$_[0];
    my $n=$_[1];
    if(&__pgcd($m,$n) == 1)
    {
	return 1;
    }
    else
    {
	return -1;
    }
}


sub __slideAsyncToSync_toRight
{
    my $ss = $_[0].$_[0];
    $ss =~ s/\s+//g;

    my $period=getPeriod($ss,-1);
    my @result_left = ''x (2*$period);
    my @result_right = ''x (2*$period);
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat on the right
    my @ss_split_all = ();
    my $beat = 0;
    my $valid_right = 1;
    my $valid_left = 1;
    
    for(my $i=0; $i < length($ss); $i++)
    {
	if(substr($ss,$i,1) eq '[')
	{
	    $i++;
	    while(substr($ss,$i,1) ne ']')
	    {		
		if(hex(substr($ss,$i,1)) % 2 == 0)
		{
		    $result_right[$beat] .= substr($ss,$i,1);			
		    if($beat % 2 == 0)
		    {
			$result_left[$beat] .= substr($ss,$i,1);
		    }
		    else
		    {
			$result_left[($beat+2)%$period] .= substr($ss,$i,1);
		    }
		}
		else
		{
		    if($beat % 2 == 0)
		    {
			$result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
			$result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
			if(hex(substr($ss,$i,1))-1 == 0)
			{
			    $valid_right = -1;
			}
		    }
		    else
		    {
			$result_left[($beat+2)%$period] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
			if(hex(substr($ss,$i,1))-1 == 0)
			{
			    $valid_left = -1;
			}
			$result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
		    }
		}
		$i++;
	    }
	}
	else
	{
	    if(hex(substr($ss,$i,1)) % 2 == 0)
	    {
		$result_right[$beat] .= substr($ss,$i,1);		    
		if($beat % 2 == 0)
		{
		    $result_left[$beat] .= substr($ss,$i,1);
		}
		else
		{
		    $result_left[($beat+2)%$period] .= substr($ss,$i,1);
		}
	    }
	    else
	    {
		if($beat % 2 == 0)
		{
		    $result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
		    $result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
		    if(hex(substr($ss,$i,1))-1 == 0)
		    {
			$valid_right = -1;
		    }
		}
		else
		{
		    $result_left[($beat+2)%$period] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
		    if(hex(substr($ss,$i,1))-1 == 0)
		    {
			$valid_left = -1;
		    }
		    $result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';		    
		}
	    }
	}
	$beat++;
    }

    for(my $i=0; $i < scalar @result_left; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_left[$i]) > 2 || (length($result_left[$i]) == 2 && uc(substr($result_left[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_left[$i].']';
	}
	else
	{
	    $v1 = $result_left[$i];
	}
	if(length($result_left[$i+1]) > 2 || (length($result_left[$i+1]) == 2 && uc(substr($result_left[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_left[$i+1].']';
	}
	else
	{
	    $v2 = $result_left[$i+1];
	}
	$result_left_ss .= '('.$v1.','.$v2.')';
    }

    for(my $i=0; $i < scalar @result_right; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_right[$i]) > 2 || (length($result_right[$i]) == 2 && uc(substr($result_right[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_right[$i].']';
	}
	else
	{
	    $v1 = $result_right[$i];
	}
	if(length($result_right[$i+1]) > 2 || (length($result_right[$i+1]) == 2 && uc(substr($result_right[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_right[$i+1].']';
	}
	else
	{
	    $v2 = $result_right[$i+1];
	}
	$result_right_ss .= '('.$v1.','.$v2.')';
    }

    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP:: __slideAsyncToSync_toRight : Before Checking Validity\n";
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";    
    }
    
    if($valid_right != 1)
    {
	$result_right_ss = -1;
    }
    if($valid_left != 1)
    {
	$result_left_ss = -1;
    }
    
    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";
    }

    return (lc($result_right_ss),lc($result_left_ss));
}


sub __slideAsyncToSync_toLeft
{
    my $ss = $_[0].$_[0];
    $ss =~ s/\s+//g;
    
    my $period=getPeriod($ss,-1);
    my @result_left = ''x (2*$period);
    my @result_right = ''x (2*$period);
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat on the right
    my @ss_split_all = ();
    my $beat = 0;
    my $valid_right = 1;
    my $valid_left = 1;
    
    for(my $i=0; $i < length($ss); $i++)
    {
	if(substr($ss,$i,1) eq '[')
	{
	    $i++;
	    while(substr($ss,$i,1) ne ']')
	    {		
		if(hex(substr($ss,$i,1)) % 2 == 0)
		{
		    $result_left[$beat] .= substr($ss,$i,1);
		    if($beat % 2 == 0)
		    {		
			if($beat >= 2)
			{
			    $result_right[$beat-2] .= substr($ss,$i,1);
			}
			else
			{
			    $result_right[$period-2] .= substr($ss,$i,1);
			}
		    }
		    else
		    {		
			$result_right[$beat] .= substr($ss,$i,1);		    
		    }
		}
		else
		{
		    if($beat % 2 == 0)
		    {
			$result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
			if(hex(substr($ss,$i,1))-1 == 0)
			{
			    $valid_left = -1;
			}
			if($beat >= 2)
			{
			    $result_right[$beat-2] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
			}
			else
			{
			    $result_right[$period-2] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
			}			
		    }
		    else
		    {
			$result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
			$result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
			if(hex(substr($ss,$i,1))-1 == 0)
			{
			    $valid_right = -1;
			}
		    }
		}
		$i++;
	    }
	}
	else
	{
	    if(hex(substr($ss,$i,1)) % 2 == 0)
	    {
		$result_left[$beat] .= substr($ss,$i,1);
		if($beat % 2 == 0)
		{
		    if($beat != 0)
		    {
			$result_right[$beat-2] .= substr($ss,$i,1);
		    }
		    else
		    {
			$result_right[$period-2] .= substr($ss,$i,1);
		    }
		}
		else
		{
		    $result_right[$beat] .= substr($ss,$i,1);		    
		}
	    }
	    else
	    {
		if($beat % 2 == 0)
		{
		    $result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
		    if(hex(substr($ss,$i,1))-1 == 0)
		    {
			$valid_left = -1;
		    }
		    if($beat != 0)
		    {			
			$result_right[$beat-2] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
		    }
		    else
		    {
			$result_right[$period-2] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
		    }			
		}
		else
		{
		    $result_left[$beat] .= sprintf("%x",hex(substr($ss,$i,1))+1).'X';
		    $result_right[$beat] .= sprintf("%x",hex(substr($ss,$i,1))-1).'X';
		    if(hex(substr($ss,$i,1))-1 == 0)
		    {
			$valid_right = -1;
		    }
		}
	    }
	}
	$beat++;
    }

    for(my $i=0; $i < scalar @result_left; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_left[$i]) > 2 || (length($result_left[$i]) == 2 && uc(substr($result_left[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_left[$i].']';
	}
	else
	{
	    $v1 = $result_left[$i];
	}
	if(length($result_left[$i+1]) > 2 || (length($result_left[$i+1]) == 2 && uc(substr($result_left[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_left[$i+1].']';
	}
	else
	{
	    $v2 = $result_left[$i+1];
	}
	$result_left_ss .= '('.$v1.','.$v2.')';
    }

    for(my $i=0; $i < scalar @result_right; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_right[$i]) > 2 || (length($result_right[$i]) == 2 && uc(substr($result_right[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_right[$i].']';
	}
	else
	{
	    $v1 = $result_right[$i];
	}
	if(length($result_right[$i+1]) > 2 || (length($result_right[$i+1]) == 2 && uc(substr($result_right[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_right[$i+1].']';
	}
	else
	{
	    $v2 = $result_right[$i+1];
	}
	$result_right_ss .= '('.$v1.','.$v2.')';
    }

    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP:: __slideAsyncToSync_toLeft : Before Checking Validity\n";
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";    
    }
    
    if($valid_right != 1)
    {
	$result_right_ss = -1;
    }
    if($valid_left != 1)
    {
	$result_left_ss = -1;
    }
    
    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R-1: ".lc($result_right_ss)."\n";
	print "L-1: ".lc($result_left_ss)."\n";
    }
    
    return (lc($result_right_ss),lc($result_left_ss));
}


sub __slideSyncToAsync_toRight
{
    my $ss = $_[0];
    $ss =~ s/\s+//g;

    my $period = &getPeriod($ss,-1);
    my @result_left = ''x (2*getPeriod($ss,-1));
    my @result_right = ''x (2*getPeriod($ss,-1));
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat in the right
    my @ss_split_all = ();
    
    $ss = &expandSync($ss,-1);
    my @ss_split = split(/\(/, $ss);
    shift @ss_split;
    my $cpt = 0;
    for (my $i=0; $i < scalar(@ss_split); $i++)
    {
	my $right = (split(/,/,$ss_split[$i]))[0];
	my $tmp = (split(/,/,$ss_split[$i]))[1];
	my $left = substr($tmp,0,length($tmp)-1);
	push(@ss_split_all, $right);
	push(@ss_split_all, $left);
    }	
    
    for (my $i=0; $i < scalar(@ss_split_all); $i++)
    {	
	if(length($ss_split_all[$i]) == 1)
	{
	    $result_left[$i] .= $ss_split_all[$i];
	    
	    if($i % 2 == 0)
	    {
		$result_right[$i] .= $ss_split_all[$i];
	    }

	    else
	    {
		if($i !=1)
		{
		    $result_right[$i-2] .= $ss_split_all[$i];
		}
		else
		{
		    $result_right[$period-1] .= $ss_split_all[$i];
		}
	    }
	}
	
	elsif(uc(substr($ss_split_all[$i],1)) eq 'X')
	{	    
	    if($i % 2 == 0)
	    {
		$result_left[$i] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		$result_right[$i] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))-1);
	    }

	    else
	    {
		$result_left[$i] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))-1);
		if($i!=1)
		{
		    $result_right[$i-2] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		}
		else
		{
		    $result_right[$period-1] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		}
	    }	    
	}
	
	elsif(substr($ss_split_all[$i],0,1) eq '[')
	{										
	    my $mult=substr($ss_split_all[$i],1,length($ss_split_all[$i])-2);
	    for (my $j=0; $j < length($mult);$j++)
	    {
		if($i % 2 == 0)
		{
		    if($j+1 < length($mult) && uc(substr($mult,$j+1,1)) eq 'X')
		    {
			$result_left[$i] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			$result_right[$i] .= sprintf("%x",hex(substr($mult,$j,1))-1);
			$j++;
		    }
		    else
		    {
			$result_left[$i] .= substr($mult,$j,1);
			$result_right[$i] .= substr($mult,$j,1);
		    }
		}

		else
		{
		    if($j+1 < length($mult) && uc(substr($mult,$j+1,1)) eq 'X')
		    {
			$result_left[$i] .= sprintf("%x",hex(substr($mult,$j,1))-1);
			if($i!=1)
			{
			    $result_right[$i-2] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			}
			else
			{
			    $result_right[$period-1] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			}
			$j++;
		    }
		    else
		    {
			$result_left[$i] .= substr($mult,$j,1);
			if($i !=1)
			{
			    $result_right[$i-2] .= substr($mult,$j,1);
			}
			else
			{
			    $result_right[$period-1] .= substr($mult,$j,1);
			}
		    }
		}
	    }
	}
	
	else
	{
	    return (-1,-1);
	}
    }      	
    
    for(my $i=0; $i < scalar @result_left; $i++)
    {
	if(length($result_left[$i]) > 1)
	{
	    $result_left_ss .= '['.$result_left[$i].']';
	}
	else
	{
	    $result_left_ss .= $result_left[$i];
	}
    }

    for(my $i=0; $i < scalar @result_right; $i++)
    {
	if(length($result_right[$i]) > 1)
	{
	    $result_right_ss .= '['.$result_right[$i].']';
	}
	else
	{
	    $result_right_ss .= $result_right[$i];
	}
    }

    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";
    }

    return (lc($result_right_ss),lc($result_left_ss));
}


sub __slideSyncToAsync_toLeft
{
    my $ss = $_[0];
    $ss =~ s/\s+//g;

    my $period = &getPeriod($ss,-1);
    my @result_left = ''x (2*getPeriod($ss,-1));
    my @result_right = ''x (2*getPeriod($ss,-1));
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat in the right
    my @ss_split_all = ();
    
    $ss = &expandSync($ss,-1);
    my @ss_split = split(/\(/, $ss);
    shift @ss_split;
    my $cpt = 0;
    for (my $i=0; $i < scalar(@ss_split); $i++)
    {
	my $right = (split(/,/,$ss_split[$i]))[0];
	my $tmp = (split(/,/,$ss_split[$i]))[1];
	my $left = substr($tmp,0,length($tmp)-1);
	push(@ss_split_all, $right);
	push(@ss_split_all, $left);
    }	
    
    for (my $i=0; $i < scalar(@ss_split_all); $i++)
    {	
	if(length($ss_split_all[$i]) == 1)
	{	    	    
	    if($i % 2 == 0)
	    {
		$result_left[$i] .= $ss_split_all[$i];
		if($i!=0)
		{
		    $result_right[$i-2] .= $ss_split_all[$i];
		}
		else
		{
		    $result_right[$period-2] .= $ss_split_all[$i];
		}
	    }

	    else
	    {
		if($i!=1)
		{
		    $result_left[$i-2] .= $ss_split_all[$i];
		    $result_right[$i-2] .= $ss_split_all[$i];
		}
		else
		{
		    $result_left[$period-1] .= $ss_split_all[$i];
		    $result_right[$period-1] .= $ss_split_all[$i];
		}
	    }
	}
	
	elsif(uc(substr($ss_split_all[$i],1)) eq 'X')
	{	    
	    if($i % 2 == 0)
	    {
		$result_left[$i] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))-1);
		if($i!=0)
		{
		    $result_right[$i-2] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		}
		else
		{
		    $result_right[$period-2] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		}
	    }

	    else
	    {
		if($i!=1)
		{		    
		    $result_left[$i-2] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		    $result_right[$i-2] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))-1);
		}
		else
		{
		    $result_left[$period-1] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))+1);
		    $result_right[$period-1] .= sprintf("%x",hex(substr($ss_split_all[$i],0,1))-1);
		}
	    }	    
	}
	
	elsif(substr($ss_split_all[$i],0,1) eq '[')
	{										
	    my $mult=substr($ss_split_all[$i],1,length($ss_split_all[$i])-2);
	    for (my $j=0; $j < length($mult);$j++)
	    {
		if($i % 2 == 0)
		{
		    if($j+1 < length($mult) && uc(substr($mult,$j+1,1)) eq 'X')
		    {
			$result_left[$i] .= sprintf("%x",hex(substr($mult,$j,1))-1);
			if($i!=0)
			{
			    $result_right[$i-2] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			}
			else
			{
			    $result_right[$period-2] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			}
			$j++;
		    }
		    else
		    {
			$result_left[$i] .= substr($mult,$j,1);
			if($i!=0)
			{
			    $result_right[$i-2] .= substr($mult,$j,1);
			}
			else
			{
			    $result_right[$period-2] .= substr($mult,$j,1);
			}
		    }
		}

		else
		{
		    if($j+1 < length($mult) && uc(substr($mult,$j+1,1)) eq 'X')
		    {
			if($i!=1)
			{
			    $result_left[$i-2] .= sprintf("%x",hex(substr($mult,$j,1))+1);			    
			    $result_right[$i-2] .= sprintf("%x",hex(substr($mult,$j,1))-1);

			}
			else
			{
			    $result_left[$period-1] .= sprintf("%x",hex(substr($mult,$j,1))+1);
			    $result_right[$period-1] .= sprintf("%x",hex(substr($mult,$j,1))-1);
			}
			$j++;
		    }
		    else
		    {
			if($i !=1)
			{
			    $result_left[$i-2] .= substr($mult,$j,1);
			    $result_right[$i-2] .= substr($mult,$j,1);
			}
			else
			{
			    $result_left[$period-1] .= substr($mult,$j,1);
			    $result_right[$period-1] .= substr($mult,$j,1);
			}
		    }
		}
	    }
	}
	
	else
	{
	    return (-1,-1);
	}
    }      	
    
    for(my $i=0; $i < scalar @result_left; $i++)
    {
	if(length($result_left[$i]) > 1)
	{
	    $result_left_ss .= '['.$result_left[$i].']';
	}
	else
	{
	    $result_left_ss .= $result_left[$i];
	}
    }

    for(my $i=0; $i < scalar @result_right; $i++)
    {
	if(length($result_right[$i]) > 1)
	{
	    $result_right_ss .= '['.$result_right[$i].']';
	}
	else
	{
	    $result_right_ss .= $result_right[$i];
	}
    }

    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R-1: ".lc($result_right_ss)."\n";
	print "L-1: ".lc($result_left_ss)."\n";
    }
    return (lc($result_right_ss),lc($result_left_ss));
}



sub __slideMultiSync_toRight
{
    # Double the period before comparaison to take into account eventual last "*" ( TO DO: using ! and *! or *! for Async at the end is currently not recommended !)
    my $ss = $_[0].$_[0];
    my $period = &getPeriod($ss,-1);
    my @result_left = ''x (2*getPeriod($ss,-1));
    my @result_right = ''x (2*getPeriod($ss,-1));
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat in the right
    my $valid_right = 1;
    my $valid_left = 1;
    
    my ($beat, $src_left_tmp, $src_right_tmp) = &LADDER::__build_lists($ss);
    
    my @src_left = @{$src_left_tmp};
    my @src_right = @{$src_right_tmp};
    
    for(my $i=0; $i < $beat; $i++)
    {
	if($src_right[$i] eq '')
	{
	    $result_left[2*$i] .= '0';
	    $result_right[(2*$i+2)%(2*$period)] .= '0';
	}	
	else
	{
	    for (my $j=0; $j < length($src_right[$i]); $j++)
	    {
		if($j+1 == length($src_right[$i]) || (($j+1 < length($src_right[$i])) && (uc(substr($src_right[$i],$j+1,1)) ne 'X')))
		{
		    if(hex(substr($src_right[$i],$j,1)) %2 == 0)
		    {
			$result_left[2*$i] .= substr($src_right[$i],$j,1);
			$result_right[(2*$i+2)%(2*$period)] .= substr($src_right[$i],$j,1);			
		    }
		    else
		    {
			$result_left[2*$i] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1).'X';
			$result_right[(2*$i+2)%(2*$period)] .= sprintf("%x",hex(substr($src_right[$i],$j,1))-1).'X';
			if(hex(substr($src_right[$i],$j,1)) == 1)
			{
			    $valid_right = -1;
			}
		    }		    
		}
		elsif(($j+1 < length($src_right[$i])) && (uc(substr($src_right[$i],$j+1,1)) eq 'X'))
		{
		    if(hex(substr($src_right[$i],$j,1)) %2 == 0)
		    {			
			$result_left[2*$i] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1);
			$result_right[(2*$i+2)%(2*$period)] .= sprintf("%x",hex(substr($src_right[$i],$j,1))-1);		       
		    }
		    else
		    {
			$result_left[2*$i] .= substr($src_right[$i],$j,1).'X';
			$result_right[(2*$i+2)%(2*$period)] .= substr($src_right[$i],$j,1).'X';		       
		    }
		    $j++;
		}		    		    		
	    }	    	
	}
	
	if($src_left[$i] eq '')
	{
	    $result_left[(2*$i+1+2)%(2*$period)] .= '0';
	    $result_right[2*$i+1] .= '0';
	}
	else
	{
	    for (my $j=0; $j < length($src_left[$i]); $j++)
	    {
		if($j+1 == length($src_left[$i]) || (($j+1 < length($src_left[$i])) && (uc(substr($src_left[$i],$j+1,1)) ne 'X')))
		{
		    if(hex(substr($src_left[$i],$j,1)) %2 == 0)
		    {
			$result_left[(2*$i+1+2)%(2*$period)] .= substr($src_left[$i],$j,1);
			$result_right[2*$i+1] .= substr($src_left[$i],$j,1);
		    }
		    else
		    {
			$result_left[(2*$i+1+2)%(2*$period)] .= sprintf("%x",hex(substr($src_left[$i],$j,1))-1).'X';			
			if(hex(substr($src_left[$i],$j,1)) == 1)
			{
			    $valid_left = -1;
			}
			$result_right[2*$i+1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1).'X';			
		    }		    
		}
		elsif(($j+1 < length($src_left[$i])) && (uc(substr($src_left[$i],$j+1,1)) eq 'X'))
		{
		    if(hex(substr($src_left[$i],$j,1)) %2 == 0)
		    {
			$result_left[(2*$i+1+2)%(2*$period)] .= sprintf("%x",hex(substr($src_left[$i],$j,1))-1);
			$result_right[2*$i+1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1);
		    }
		    else
		    {
			$result_left[(2*$i+1+2)%(2*$period)] .= substr($src_left[$i],$j,1).'X';
			$result_right[2*$i+1] .= substr($src_left[$i],$j,1).'X';
		    }
		    $j++;
		}		    		    		
	    }	    	
	}		
    }
    
    for(my $i=0; $i < scalar @result_left; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_left[$i]) > 2 || (length($result_left[$i]) == 2 && uc(substr($result_left[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_left[$i].']';
	}
	else
	{
	    $v1 = $result_left[$i];
	}
	if(length($result_left[$i+1]) > 2 || (length($result_left[$i+1]) == 2 && uc(substr($result_left[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_left[$i+1].']';
	}
	else
	{
	    $v2 = $result_left[$i+1];
	}
	$result_left_ss .= '('.$v1.','.$v2.')'.'!';
    }

    for(my $i=0; $i < scalar @result_right; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_right[$i]) > 2 || (length($result_right[$i]) == 2 && uc(substr($result_right[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_right[$i].']';
	}
	else
	{
	    $v1 = $result_right[$i];
	}
	if(length($result_right[$i+1]) > 2 || (length($result_right[$i+1]) == 2 && uc(substr($result_right[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_right[$i+1].']';
	}
	else
	{
	    $v2 = $result_right[$i+1];
	}
	$result_right_ss .= '('.$v1.','.$v2.')'.'!';
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP:: __slideMultiSync_toRight : Before Checking Validity\n";
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";    
    }
    
    if($valid_right != 1)
    {
	$result_right_ss = -1;
    }
    if($valid_left != 1)
    {
	$result_left_ss = -1;
    }
    
    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R+1: ".lc($result_right_ss)."\n";
	print "L+1: ".lc($result_left_ss)."\n";
    }

    return (lc($result_right_ss),lc($result_left_ss));    
}


sub __slideMultiSync_toLeft
{
    # Double the period before comparaison to take into account eventual last "*" ( TO DO: using ! and *! or *! for Async at the end is currently not recommended !)
    my $ss = $_[0].$_[0];
    my $period = &getPeriod($ss,-1);
    my @result_left = ''x (2*getPeriod($ss,-1));
    my @result_right = ''x (2*getPeriod($ss,-1));
    my $result_left_ss = '';         # Left Hand Slide from 1 beat on the right 
    my $result_right_ss = '';        # Right Hand Slide from 1 beat in the right
    my $valid_right = 1;
    my $valid_left = 1;
    
    my ($beat, $src_left_tmp, $src_right_tmp) = &LADDER::__build_lists($ss);
    
    my @src_left = @{$src_left_tmp};
    my @src_right = @{$src_right_tmp};
    
    for(my $i=0; $i < $beat; $i++)
    {
	if($src_right[$i] eq '')
	{
	    $result_left[2*$i] .= '0';
	    if(2*$i != 0)
	    {
		$result_right[2*$i-2] .= '0';
	    }
	    else
	    {
		$result_right[2*$period-2] .= '0';
	    }
	}	
	else
	{
	    for (my $j=0; $j < length($src_right[$i]); $j++)
	    {
		if($j+1 == length($src_right[$i]) || (($j+1 < length($src_right[$i])) && (uc(substr($src_right[$i],$j+1,1)) ne 'X')))
		{
		    if(hex(substr($src_right[$i],$j,1)) %2 == 0)
		    {
			$result_left[2*$i] .= substr($src_right[$i],$j,1);
			if(2*$i != 0)
			{
			    $result_right[2*$i-2] .= substr($src_right[$i],$j,1);
			}
			else
			{
			    $result_right[2*$period-2] .= substr($src_right[$i],$j,1);
			}
		    }
		    else
		    {
			$result_left[2*$i] .= sprintf("%x",hex(substr($src_right[$i],$j,1))-1).'X';
			if(hex(substr($src_right[$i],$j,1)) == 1)
			{
			    $valid_left = -1;
			}
			if(2*$i != 0)
			{
			    $result_right[2*$i-2] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1).'X';
			}
			else
			{
			    $result_right[2*$period-2] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1).'X';
			}
		    }		    
		}
		elsif(($j+1 < length($src_right[$i])) && (uc(substr($src_right[$i],$j+1,1)) eq 'X'))
		{
		    if(hex(substr($src_right[$i],$j,1)) %2 == 0)
		    {			
			$result_left[2*$i] .= sprintf("%x",hex(substr($src_right[$i],$j,1))-1);
			if(2*$i != 0)
			{
			    $result_right[2*$i-2] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1);
			}
			else
			{
			    $result_right[2*$period-2] .= sprintf("%x",hex(substr($src_right[$i],$j,1))+1);
			}			    
		    }
		    else
		    {
			$result_left[2*$i] .= substr($src_right[$i],$j,1).'X';
			if(2*$i != 0)
			{
			    $result_right[2*$i-2] .= substr($src_right[$i],$j,1).'X';
			}
			else
			{
			    $result_right[2*$period-2] .= substr($src_right[$i],$j,1).'X';
			}			    
		    }
		    $j++;
		}		    		    		
	    }	    	
	}
	
	if($src_left[$i] eq '')
	{
	    if(2*$i+1 != 1)
	    {
		$result_left[2*$i+1-2] .= '0';
	    }
	    else
	    {
		$result_left[2*$period -1] .= '0';
	    }
	    $result_right[2*$i+1] .= '0';	    
	}
	else
	{
	    for (my $j=0; $j < length($src_left[$i]); $j++)
	    {
		if($j+1 == length($src_left[$i]) || (($j+1 < length($src_left[$i])) && (uc(substr($src_left[$i],$j+1,1)) ne 'X')))
		{
		    if(hex(substr($src_left[$i],$j,1)) %2 == 0)
		    {
			if(2*$i+1 != 1)
			{
			    $result_left[2*$i+1-2] .= substr($src_left[$i],$j,1);
			}
			else
			{
			    $result_left[2*$period -1] .= substr($src_left[$i],$j,1);
			}
			$result_right[2*$i+1] .= substr($src_left[$i],$j,1);
		    }
		    else
		    {
			if(2*$i+1 != 1)
			{
			    $result_left[2*$i+1-2] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1).'X';
			}
			else
			{
			    $result_left[2*$period-1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1).'X';
			}			
			$result_right[2*$i+1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))-1).'X';
			if(hex(substr($src_left[$i],$j,1)) == 1)
			{
			    $valid_right = -1;
			}
		    }		    
		}
		elsif(($j+1 < length($src_left[$i])) && (uc(substr($src_left[$i],$j+1,1)) eq 'X'))
		{
		    if(hex(substr($src_left[$i],$j,1)) %2 == 0)
		    {
			if(2*$i+1 != 1)
			{
			    $result_left[2*$i+1-2] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1);
			}
			else
			{
			    $result_left[2*$period-1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))+1);
			}
			$result_right[2*$i+1] .= sprintf("%x",hex(substr($src_left[$i],$j,1))-1);
		    }
		    else
		    {
			if(2*$i+1 != 1)
			{
			    $result_left[2*$i+1-2] .= substr($src_left[$i],$j,1).'X';
			}
			else
			{
			    $result_left[2*$period-1] .= substr($src_left[$i],$j,1).'X';
			}
			$result_right[2*$i+1] .= substr($src_left[$i],$j,1).'X';
		    }
		    $j++;
		}		    		    		
	    }	    	
	}		
    }
    
    for(my $i=0; $i < scalar @result_left; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_left[$i]) > 2 || (length($result_left[$i]) == 2 && uc(substr($result_left[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_left[$i].']';
	}
	else
	{
	    $v1 = $result_left[$i];
	}
	if(length($result_left[$i+1]) > 2 || (length($result_left[$i+1]) == 2 && uc(substr($result_left[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_left[$i+1].']';
	}
	else
	{
	    $v2 = $result_left[$i+1];
	}
	$result_left_ss .= '('.$v1.','.$v2.')'.'!';
    }

    for(my $i=0; $i < scalar @result_right; $i+=2)
    {
	my $v1 = '';
	my $v2 = '';
	
	if(length($result_right[$i]) > 2 || (length($result_right[$i]) == 2 && uc(substr($result_right[$i],1)) ne 'X'))
	{
	    $v1 = '['.$result_right[$i].']';
	}
	else
	{
	    $v1 = $result_right[$i];
	}
	if(length($result_right[$i+1]) > 2 || (length($result_right[$i+1]) == 2 && uc(substr($result_right[$i+1],1)) ne 'X'))
	{
	    $v2 = '['.$result_right[$i+1].']';
	}
	else
	{
	    $v2 = $result_right[$i+1];
	}
	$result_right_ss .= '('.$v1.','.$v2.')'.'!';
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP:: __slideMultiSync_toRight : Before Checking Validity\n";
	print "R-1: ".lc($result_right_ss)."\n";
	print "L-1: ".lc($result_left_ss)."\n";    
    }
    
    if($valid_right != 1)
    {
	$result_right_ss = -1;
    }
    if($valid_left != 1)
    {
	$result_left_ss = -1;
    }
    
    if(scalar @_ == 1 || $_[1] != -1)
    {
	print "R-1: ".lc($result_right_ss)."\n";
	print "L-1: ".lc($result_left_ss)."\n";
    }

    return (lc($result_right_ss),lc($result_left_ss));
    
}



sub slideSwitchSync
{
    my $ss = $_[0];
    my $mod = &getSSType($ss,-1);
    my $opt = $_[1];

    if ($mod eq 'V' || $mod eq 'M')
    {
	my ($s1,$s2)=&__slideAsyncToSync_toRight($ss, $opt);
	my ($s3,$s4)=&__slideAsyncToSync_toLeft($ss, $opt);
	return ($s1,$s2,$s3,$s4);
    }
    elsif ($mod eq 'S' || $mod eq 'MS' || $mod eq 'SM')
    {
	my ($s1,$s2)=&__slideSyncToAsync_toRight($ss, $opt);
	my ($s3,$s4)=&__slideSyncToAsync_toLeft($ss, $opt);
	return ($s1,$s2,$s3,$s4);
    }
    elsif ($mod eq 'MULTI')
    {
	my ($s1,$s2)=&__slideMultiSync_toRight($ss, $opt);
	my ($s3,$s4)=&__slideMultiSync_toLeft($ss, $opt);
	return ($s1,$s2,$s3,$s4);
    }
    else
    {
	if(scalar @_ == 1 || $_[1] != -1)
	{
	    print $lang::MSG_SSWAP_SLIDESWITCHSYNC_ERR1;
	}
	return (-1,-1,-1,-1);
    }    
}


sub simplify
{
    ##### A few simplifications on siteswap
    #####

    my $ss = lc($_[0]);
    $ss =~ s/\s+//g;

    # Change *0* by 0	
    $ss =~ s/\*0\*/0/g;
    # Change 0!0* by 0	
    $ss =~ s/0!0\*/0/g;
    # Change !00* by 0	
    $ss =~ s/!00\*/0/g;
    # Change !0*0 by 0	
    $ss =~ s/!0\*0/0/g;
    # Change *00! by 0	
    $ss =~ s/\*00!/0/g;
    # Change *0!0 by 0	
    $ss =~ s/\*0!0/0/g;
    # Change 0** by 0	
    $ss =~ s/0\*\*/0/g;
    
    # remove *0!  	
    $ss =~ s/\*0!//g;
    # remove 0*!  	
    $ss =~ s/0\*!//g;
    # remove 0!*  	
    $ss =~ s/0!\*//g;
    # remove !*0  	
    $ss =~ s/!\*0//g;
    # remove *!0  	
    $ss =~ s/\*!0//g;
    # remove !0*  	
    $ss =~ s/!0\*//g;
    # remove !00!  	
    $ss =~ s/!00!//g;
    # remove 0!0!  	
    $ss =~ s/0!0!//g;
    # Remove all "**"
    $ss =~ s/\*\*//g;
    # remove !(0,0)! 
    $ss =~ s/!\(0,0\)!//g;

    # change !0 by *
    $ss =~ s/!0/\*/g;
    # change 0! by *
    $ss =~ s/0!/\*/g;


    my $ss_type = '' ; # &getSSType($_[0],-1);
    
    # IF "0*" at the start and "*" at the end ==> Remove and Set 0 at the end
    if(substr($ss,0,2) eq "0*" && length($ss) >= 1 && substr($ss,length($ss) -1) eq "*")
    {
	$ss = substr($ss,2,length($ss)-3)."0";
    }

    # IF "0" at the start and "!" at the end after a sync throw ==> Remove and Set *
    if(substr($ss,0,1) eq "0" && length($ss) >= 2 && substr($ss,length($ss) -2) eq ")!")
    {
	$ss = substr($ss,1,length($ss)-2)."*";
	$ss = &__sym_in($ss);
    }
    # IF "0" at the start and "!*" at the end after a sync throw ==> Remove and set to 0
    if(substr($ss,0,1) eq "0" && length($ss) >= 3 && substr($ss,length($ss) -3) eq ")!*")
    {
	$ss = substr($ss,1,length($ss)-3);  
	$ss = &__sym_in($ss);	
    }

    # IF "*" at the start and "*" at the end 
    ##   ==> IF Async or Multiplex :  Swap the hand ...
    ##   ==> Else Remove and do a symetrie
    $ss_type = &getSSType($ss,-1);
    if(substr($ss,0,1) eq "*" && length($ss) > 1 && substr($ss,length($ss) -1) eq "*")
    {
	$ss = substr($ss,1,length($ss)-2);
	if($ss_type eq "V")
	{
	    $ss = substr($ss,1).substr($ss,0,1);
	    if (uc(substr($ss,0,1)) eq "X")
	    {
		$ss = substr($ss,1).substr($ss,0,1);
	    }
	}

	elsif($ss_type eq "M")
	{	
	    if (substr($ss,0,1) ne "[")
	    {
		$ss = substr($ss,1).substr($ss,0,1);
		if (uc(substr($ss,0,1)) eq "X")
		{
		    $ss = substr($ss,1).substr($ss,0,1);
		}
	    }
	    else
	    {
		my $endm = -1;
		my $i=1;

		while($endm==-1 && $i < length($ss))
		{
		    if(substr($ss,$i,1) eq "]")
		    {
			$i++;
			last;
		    }
		    else 
		    {			
			$i++;
		    }
		}			    
		
		$ss = substr($ss,$i).substr($ss,0,$i);
	    }
	}

	else
	{
	    $ss = &__sym_in($ss);		
	}
    }

    # Remove all "**"
    $ss =~ s/\*\*//g;

    $ss= &shrink($ss,-1);
    
    if($ss_type eq "S" || $ss_type eq "MS" || $ss_type eq "SM")
    {
	# Add * for Symetry if needed.
	if(substr($ss,length($ss)-1,1) ne "*" && length($ss)%2 == 0)
	{
	    my $ss_test = substr($ss,0,length($ss)/2).'*';
	    if(&isSyntaxValid($ss_test,-1)!=-1 && &isValid($ss_test,-1)==1 && &isEquivalent($ss,$ss_test,'',-1)==1)
	    {
		$ss = $ss_test;
	    }		
	}	    
    }
    
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$ss\n";
    }

    return $ss;
}


sub isSyntaxValid
{
    # res is the Siteswap Type found during the parsing :
    # Async : 1
    # Multiplex : 2
    # Sync : 3
    # Multiplex Sync : 4
    # MultiSync : 5
    # Unknown : 0
    # or -1 if a lexical/syntaxic error is found
    my $res= SSWAP_GRAMMAR::parse($_[0],$_[1]);
    
    if ($res==-1) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    } else {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return $res;
    }
}


sub isEquivalent
{
    # $_[0] : $ss1;
    # $_[1] : $ss2;
    # $_[2] : $opts; 
    #         -c <y|n> : Check the color model (default: n)
    #         -s <y|n> : Check the Symetry (default: n)
    #         -p <y|n> : Check the Permutation Equivalence (default: y)
    # $_[3] : if value is -1, silently run it;

    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $ret = &GetOptionsFromString(uc($_[2]),    
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
	);
    
    # If the ss is symetric you do not have to not consider it !
    if(&getPeriod($_[1],"-1")%2 != 0)
    {
	$sym_check="N";
    }

    sub __unsort_multiplex
    {

	my @src = @{$_[0]};
 	for(my $l=0; $l < scalar @src; $l++)
	{
	    my $k=0;
	    my $cpt = 0;
	    my @tab = ();
	    my $v='';
	    
	    while($k < length($src[$l]))
	    {
		if($k == (length($src[$l]) - 1))
		{
		    $tab[$cpt]=substr($src[$l],$k);
		}
		elsif(uc(substr($src[$l],$k+1,1)) eq "X")
		{
		    $v = substr($src[$l],$k,2);
		    $k++;
		    $tab[$cpt]=$v;
		}	    
		else
		{
		    $v = substr($src[$l],$k,1);
		    $tab[$cpt]=$v;
		}

		
		$cpt ++;
		$k++;		   
	    }	

	    my $drap=1;

	    while($drap == 1)
	    {
		$drap = 0;
		for(my $i=0; $i < scalar @tab - 1; $i++)
		{
		    my $v1 = substr($tab[$i],0,1);
		    my $v2 = substr($tab[$i+1],0,1);
		    
		    if($v1 > $v2 || ($v1 == $v2 && (length ($tab[$i]) > length ($tab[$i+1]))))
		    {
			my $tm = $tab[$i];
			$tab[$i] = $tab[$i+1];
			$tab[$i+1] = $tm;
			$drap = 1;
		    }
		}
		
		for(my $i=scalar @tab -1; $i > 0; $i--)
		{
		    my $v1 = substr($tab[$i],0,1);
		    my $v2 = substr($tab[$i-1],0,1);
		    
		    if($v1 < $v2 || ($v1 == $v2 && (length ($tab[$i]) < length ($tab[$i-1]))))
		    {
			my $tm = $tab[$i];
			$tab[$i] = $tab[$i-1];
			$tab[$i-1] = $tm;
			$drap = 1;
		    }
		}
	    }
	    $src[$l] = join('', @tab);	    
	}	

	return @src;
    }



    sub __isEquivalent_in
    {

	# $_[0] : $ss1;
	# $_[1] : $ss2;
	# $_[2] : $opts; 
	#         -c <y|n> : Check the color model (default: n)
	#         -s <y|n> : Check the Symetry (default: n)
	#         -p <y|n> : Check the Permutation Equivalence (default: y)
	# $_[3] : if value is -1, silently run it;


	my $color_check = "N";
	my $sym_check = "N";
	my $perm_check = "Y";
	my $ret = &GetOptionsFromString(uc($_[2]),    
					"-C:s" => \$color_check,
					"-S:s" => \$sym_check,
					"-P:s" => \$perm_check,
	    );

	if (&isValid($_[0],-1) < 0) {
	    if ((scalar @_ == 3) || ($_[3] ne "-1")) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[0]."\n";
	    }
	    return -1;
	}
	
	if (&isValid($_[1],-1) < 0) {
	    if ((scalar @_ == 3) || ($_[3] ne "-1")) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[1]."\n";
	    }
	    return -1;
	}

	# Double the period before comparaison to take into account eventual last "*" ( TO DO: using ! and *! or *! for Async at the end is currently not recommended !)
	my ($beat0, $src0_left_tmp, $src0_right_tmp) = &LADDER::__build_lists(&shrink($_[0],-1).&shrink($_[0],-1));
	my ($beat1, $src1_left_tmp, $src1_right_tmp) = &LADDER::__build_lists(&shrink($_[1],-1).&shrink($_[1],-1));

	my @src0_left = @{$src0_left_tmp};
	my @src0_right = @{$src0_right_tmp};
	my @src1_left = @{$src1_left_tmp};
	my @src1_right = @{$src1_right_tmp};
	
	# print "=======0================".&shrink($_[0],-1).&shrink($_[0],-1)."========================".&shrink($_[0],-1)."\n";
	# print "=======1================".&shrink($_[1],-1).&shrink($_[1],-1)."========================".&shrink($_[1],-1)."\n";

	if($color_check eq "N")
	{
	    @src0_left =  &__unsort_multiplex(\@src0_left);
	    @src1_left =  &__unsort_multiplex(\@src1_left);
	    @src0_right =  &__unsort_multiplex(\@src0_right);
	    @src1_right =  &__unsort_multiplex(\@src1_right);	    
	}
	
	my $beat = $beat0;
	if($beat0 < $beat1)
	{
	    $beat = $beat1;
	}
	
	for(my $i=0; $i<$beat;$i++)
	{
	    if($src0_left[$i%$beat0] ne $src1_left[$i%$beat1])
	    {
		if(($src0_left[$i%$beat0] eq "0" && $src1_left[$i%$beat1] eq "") ||
		   ($src0_left[$i%$beat0] eq "" && $src1_left[$i%$beat1] eq "0"))
		{}
		else
		{
		    return -1;
		}
	    }
	    if($src0_right[$i%$beat0] ne $src1_right[$i%$beat1])
	    {
		if(($src0_right[$i%$beat0] eq "0" && $src1_right[$i%$beat1] eq "") ||
		   ($src0_right[$i%$beat0] eq "" && $src1_right[$i%$beat1] eq "0"))
		{}
		else
		{
		    return -1;
		}
	    }	
	}
	
	return 1;
    }


    my $ss0 = &LADDER::toMultiSync($_[0],2,-1);
    my $ss1 = &LADDER::toMultiSync($_[1],2,-1);
    my $res = -1; 

    if($perm_check eq "N")
    {
	$res = &__isEquivalent_in(@_);
    }

    if($res == -1)
    {
	if(uc($perm_check) eq "Y") # Default case : symetry is checked also since the permutation does not consider the beat 
	{
	    my $i=0;

	    while($i<length($ss1))
	    {
		my $new_ss = "";
		while($i < length($ss1) && (substr($ss1,0,1) eq "!" || substr($ss1,0,1) eq "*"))
		{
		    $i++;
		}
		$new_ss=substr($ss1,$i).substr($ss1,0,$i);
		if(uc(substr($new_ss,0,1)) eq "X")
		{
		    $new_ss=substr($new_ss,1).substr($new_ss,0,1);
		    $i++;
		}

		if(scalar @_ >= 4)
		{
		    $res = &__isEquivalent_in($ss0,$new_ss,$_[2],$_[3]);
		}
		elsif(scalar @_ == 3)
		{
		    $res = &__isEquivalent_in($ss0,$new_ss,$_[2]);   
		}
		else
		{
		    $res = &__isEquivalent_in($ss0,$new_ss);   
		}
		
		if($res == 1)
		{
		    last;
		}
		$i++;
	    }          

	}
    }
    if($res == -1 && (uc($sym_check) eq "Y" || uc($perm_check) eq "Y"))
    {
	# in some Sync case, the previous check is not enough ... check the sym also  
	my $sym = &LADDER::toMultiSync(&sym($_[1],-1).&sym($_[1],-1),2,-1);
	my $i=0;

	while($i<length($sym))
	{
	    my $new_ss = "";
	    while($i < length($sym) && (substr($sym,0,1) eq "!" || substr($sym,0,1) eq "*"))
	    {
		$i++;
	    }
	    $new_ss=substr($sym,$i).substr($sym,0,$i);
	    if(uc(substr($new_ss,0,1)) eq "X")
	    {
		$new_ss=substr($new_ss,1).substr($new_ss,0,1);
		$i++;
	    }
	    if(scalar @_ >= 4)
	    {
		$res = &__isEquivalent_in($ss0,$new_ss,$_[2],$_[3]);
	    }
	    elsif(scalar @_ == 3)
	    {
		$res = &__isEquivalent_in($ss0,$new_ss,$_[2]);   
	    }
	    else
	    {
		$res = &__isEquivalent_in($ss0,$new_ss);   
	    }
	    
	    if($res == 1)
	    {
		last;
	    }
	    $i++;
	}    	
    }


    if ((scalar @_ <=3) || ($_[3] ne "-1")) {
	if($res==1)
	{
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	else
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}	
    }

    return $res;

}


sub timeRevDiag
{       
    my $ss = &LADDER::toMultiSync($_[0],0,-1);
    my $period_orig=&getPeriod($ss,-1);    
    my $nbrec=int ((&getHeightMax($ss,-1)+$period_orig)/$period_orig + 1);
    $ss = $ss x $nbrec;     
    my $color_mode = 2;
    my $dot_mode = 1;  # Sync Hack : Do not remove 0 after sync throw  
    my ($period_orig,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &LADDER::__build_dicts($_[0], $color_mode, $dot_mode);
    my ($period,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand_tmp) = &LADDER::__build_dicts($ss, $color_mode, $dot_mode);

    my %ss_hash = %{$ss_hash_tmp};
    my %transit_hash = %{$transit_hash_tmp};
    my $time_max = 0;
    
    # Keep a view on all the objects on each Beat in the Transition MAP
    # Here we assume that all objects are present. There is no objects hole 
    my $objects_hash_tmp = &LADDER::__build_objectsNbBeatsMAP_from_transitionsMAP(\%transit_hash);
    my %objects_hash = %{$objects_hash_tmp};
    
    # Now we can reverse the Multiplex
    my %transit_hash_tmp = ();
    while ( my ($key, $value) = each(%transit_hash) ) {		   
	my $v1 = (split(/:/,$key))[0];
	my $v2 = (split(/:/,$value))[0];	
	my $src = '';
	my $dst = '';
	
	if(exists $objects_hash{$v1} && $objects_hash{$v1} > 1)
	{
	    $src = $v1.":".($objects_hash{$v1} - 1 - (split(/:/,$key))[1]);
	}
	else
	{
	    $src = $key;
	}
	if(exists $objects_hash{$v2} && $objects_hash{$v2} > 1)
	{
	    $dst = $v2.":".($objects_hash{$v2} - 1 - (split(/:/,$value))[1]);
	}
	else
	{
	    $dst = $value;
	}

	$transit_hash_tmp{$src} = $dst;

    }
    %transit_hash=%transit_hash_tmp;

    # Remove initial and Final Periods : ie isolate the period to invert   
    my %transit_hash_tmp=();
    while (my ($key, $value) = each(%transit_hash)) 
    { 	 
     	for(my $p=0; $p < $period; $p++)
     	{
     	    my $v1="R".$p.":";
     	    my $v2="L".$p.":";
     	    if($value =~ $v1 || $value =~ $v2)
     	    {
		my $vin = substr((split(/:/,$value))[0],1);

		if(($vin > $period - $period_orig - 1) && $vin < $period )
		{
		    $transit_hash_tmp{$key}=$value;
		    if($vin > $time_max)
		    {
			$time_max = $vin;
		    }		    
		}
     	    }
     	}   
    }
    
    %transit_hash=%transit_hash_tmp;
    
    # Invert Key/value and do operations
    %transit_hash_tmp = ();
    while (my ($key, $value) = each(%transit_hash)) {		   
     	my $v1 = (split(/:/,$key))[0];
	my $vtm1 = $time_max - substr($v1,1) ;
     	my $v2 = (split(/:/,$value))[0];
	my $vtm2 = $time_max - substr($v2,1) ;

	my $src = substr($v2,0,1).$vtm2.":".(split(/:/,$value))[1];
	my $dst = substr($v1,0,1).$vtm1.":".(split(/:/,$key))[1];

     	$transit_hash_tmp{$src} = $dst;
    }
    %transit_hash=%transit_hash_tmp;

    my $ss_res = &LADDER::__get_ss_from_transitionsMAP(\%transit_hash,$queue_hand);    
    $ss_res = &simplify($ss_res,-1);
    my $opts="";

    # We do not have the correct SS according to the color mode choosen but we will have the correct diagramm
    if (scalar @_>= 2 && $_[1] ne "-1") {
	if (&getSSType($_[0],-1) eq "V" || &getSSType($_[0],-1) eq "M") {
	    $opts = $_[2]." -m 1";
	} elsif (&getSSType($_[0],-1) eq "S" || &getSSType($_[0],-1) eq "MS") {
	    $opts = $_[2]." -m 2";
	} 
	else {
	    $opts = $_[2]." -m 0";
	} 

	#draw("$ss_res",$_[1],$_[2],\%transit_hash);        
	&LADDER::inv($_[0],$_[1],$opts." ".$_[2]." -S 1 -v ".$ss_res);        
    }
    
    if (scalar @_== 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], lc($ss_res)."\n";
    }
    
    return lc($ss_res);
}


sub timeRev
{       
    my $ss = $_[0];
    $ss =~ s/\s+//g;   #Remove white
    my $mod = &getSSType($_[0],-1);
    my $period = &getPeriod($_[0],-1);
    my $result = '';
    
    if ($mod eq 'V')
    {
	my @res = (0) x $period;
	for(my $i=0;$i<length($ss);$i++)
	{
	    $res[($i+hex(substr($ss,$i,1)))%$period] = substr($ss,$i,1);
	}
	$result = join('',reverse(@res));	
    }
    
    elsif ($mod eq 'M')
    {
	my @res = (0) x $period;
	my $cpt = 0;
	for(my $i=0;$i<length($ss);$i++)
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$i++;
		while(substr($ss,$i,1) ne ']')
		{
		    if($res[($cpt+hex(substr($ss,$i,1)))%$period] == 0)
		    {
			$res[($cpt+hex(substr($ss,$i,1)))%$period] = substr($ss,$i,1);
		    }
		    else
		    {
			$res[($cpt+hex(substr($ss,$i,1)))%$period] .= substr($ss,$i,1);
		    }
		    $i++;
		}
		$i++;
		$cpt ++;
	    }
	    else
	    {
		if($res[($cpt+hex(substr($ss,$i,1)))%$period] == 0)
		{
		    $res[($cpt+hex(substr($ss,$i,1)))%$period] = substr($ss,$i,1);
		}
		else
		{
		    $res[($cpt+hex(substr($ss,$i,1)))%$period] .= substr($ss,$i,1);
		}
		$cpt ++;
	    }
	}

	@res = reverse(@res);
	for(my $i=0; $i < scalar (@res); $i++)
	{
	    if(length($res[$i]) == 1)
	    {
		$result .= $res[$i];
	    }
	    else
	    {
		$result .= '['.$res[$i].']';		
	    }
	}
    }

    elsif ($mod eq 'S')
    {
	my $ss = uc(&expandSync($ss,-1));
	my @res_r = (0) x $period/2;
	my @res_l = (0) x $period/2;

	my @ss_split=split(/\(/,$ss);
	for(my $i=1;$i<scalar @ss_split;$i++)
	{
	    my $right=(split(/,/,$ss_split[$i]))[0];
	    my $left=(split(/,/,$ss_split[$i]))[1];
	    $left=substr($left,0,length($left)-1);

	    if((length($right) > 1) && (uc(substr($right,1,1)) eq 'X'))
	    {	
		$res_l[(($i*2+hex(substr($right,0,1)))%$period)/2] = substr($right,0,1).'X';
	    }
	    else
	    {
		$res_r[(($i*2+hex(substr($right,0,1)))%$period)/2] = substr($right,0,1);
	    }

	    if((length($left)> 1) && (uc(substr($left,1,1)) eq 'X'))
	    {	
		$res_r[(($i*2+hex(substr($left,0,1)))%$period)/2] = substr($left,0,1).'X';
	    }
	    else
	    {
		$res_l[(($i*2+hex(substr($left,0,1)))%$period)/2] = substr($left,0,1);
	    }
	}

	@res_r = reverse(@res_r);
	@res_l = reverse(@res_l);

	for(my $i=0;$i<scalar @res_r;$i++)
	{
	    $result = $result.'('.$res_r[$i].','.$res_l[$i].')'; 
	}

	$result = &simplify($result,-1);
    }

    elsif ($mod eq 'SM' || $mod eq 'MS')
    {
	my $ss = uc(&expandSync($ss,-1));
	my @res_r = (0) x $period/2;
	my @res_l = (0) x $period/2;

	my @ss_split=split(/\(/,$ss);
	for(my $i=1;$i<scalar @ss_split;$i++)
	{
	    my $right=(split(/,/,$ss_split[$i]))[0];
	    my $left=(split(/,/,$ss_split[$i]))[1];
	    $left=substr($left,0,length($left)-1);

	    for (my $j=0;$j<length($right);$j++)
	    {
		if(substr($right,$j,1) eq '[')
		{
		    $j++;
		    while(substr($right,$j,1) ne ']')
		    {
			if($j+1 < length($right) && (uc(substr($right,$j+1,1)) eq 'X'))
			{
			    if($res_l[(($i*2+hex(substr($right,$j,1)))%$period)/2]==0)
			    {
				$res_l[(($i*2+hex(substr($right,$j,1)))%$period)/2] = substr($right,$j,1).'X';
			    }
			    else
			    {
				$res_l[(($i*2+hex(substr($right,$j,1)))%$period)/2] .= substr($right,$j,1).'X';
			    }
			    $j++;
			}
			else
			{
			    if($res_r[(($i*2+hex(substr($right,$j,1)))%$period)/2]==0)
			    {
				$res_r[(($i*2+hex(substr($right,$j,1)))%$period)/2] = substr($right,$j,1);
			    }
			    else
			    {
				$res_r[(($i*2+hex(substr($right,$j,1)))%$period)/2] .= substr($right,$j,1);
			    }
			}
			$j++;
		    }
		    $j++;
		}
		else
		{
		    if((length($right) > 1) && (uc(substr($right,1,1)) eq 'X'))
		    {
			if($res_l[(($i*2+hex(substr($right,0,1)))%$period)/2] == 0)
			{
			    $res_l[(($i*2+hex(substr($right,0,1)))%$period)/2] = substr($right,0,1).'X';
			}
			else
			{
			    $res_l[(($i*2+hex(substr($right,0,1)))%$period)/2] .= substr($right,0,1).'X';
			}
			$j++;
		    }
		    else
		    {
			if($res_r[(($i*2+hex(substr($right,0,1)))%$period)/2] == 0)
			{
			    $res_r[(($i*2+hex(substr($right,0,1)))%$period)/2] = substr($right,0,1);
			}
			else
			{
			    $res_r[(($i*2+hex(substr($right,0,1)))%$period)/2] .= substr($right,0,1);
			}
		    }
		}				
	    }

	    for (my $j=0;$j<length($left);$j++)
	    {
		if(substr($left,$j,1) eq '[')
		{
		    $j++;
		    while(substr($left,$j,1) ne ']')
		    {
			if($j+1 < length($left) && (uc(substr($left,$j+1,1)) eq 'X'))
			{
			    if($res_r[(($i*2+hex(substr($left,$j,1)))%$period)/2] == 0)
			    {
				$res_r[(($i*2+hex(substr($left,$j,1)))%$period)/2] = substr($left,$j,1).'X';
			    }
			    else
			    {
				$res_r[(($i*2+hex(substr($left,$j,1)))%$period)/2] .= substr($left,$j,1).'X';
			    }
			    $j++;
			}
			else
			{
			    if($res_l[(($i*2+hex(substr($left,$j,1)))%$period)/2]==0)
			    {
				$res_l[(($i*2+hex(substr($left,$j,1)))%$period)/2] = substr($left,$j,1);
			    }
			    else
			    {
				$res_l[(($i*2+hex(substr($left,$j,1)))%$period)/2] .= substr($left,$j,1);
			    }
			}
			$j++;
		    }
		    $j++;
		}
		else
		{
		    if((length($left) > 1) && (uc(substr($left,1,1)) eq 'X'))
		    {
			if($res_r[(($i*2+hex(substr($left,0,1)))%$period)/2] == 0)
			{
			    $res_r[(($i*2+hex(substr($left,0,1)))%$period)/2] = substr($left,0,1).'X';
			}
			else
			{
			    $res_r[(($i*2+hex(substr($left,0,1)))%$period)/2] .= substr($left,0,1).'X';
			}
			$j++;
		    }
		    else
		    {
			if($res_l[(($i*2+hex(substr($left,0,1)))%$period)/2] == 0)
			{
			    $res_l[(($i*2+hex(substr($left,0,1)))%$period)/2] = substr($left,0,1);
			}
			else
			{
			    $res_l[(($i*2+hex(substr($left,0,1)))%$period)/2] .= substr($left,0,1);
			}
		    }
		}				
	    }
	    
	}
	
	@res_r = reverse(@res_r);
	@res_l = reverse(@res_l);

	for(my $i=0;$i<scalar @res_r;$i++)
	{
	    my $val_r = $res_r[$i];
	    my $val_l = $res_l[$i];
	    if(length($val_r) > 2 || (length($val_r) == 2 && uc(substr($val_r,1,1) ne 'X')))
	    {
		$val_r = '['.$val_r.']';
	    }

	    if(length($val_l) > 2 || (length($val_l) == 2 && uc(substr($val_l,1,1) ne 'X')))
	    {
		$val_l = '['.$val_l.']';
	    }
	    
	    $result = $result.'('.$val_r.','.$val_l.')'; 
	}

	$result = &simplify($result,-1);
    }

    elsif ($mod eq 'MULTI')
    {
	$result = &timeRevDiag($ss,-1);
    }

    else
    {
	$result = -1;
	if (scalar @_== 1 || $_[1] ne "-1") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_TIMEREV_ERR0.$ss."\n";
	}

	return $result;
    }
    
    if (scalar @_== 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], lc($result)."\n";
    }

    return lc($result);	
}


sub symDiag
{
    # $_[0] : SS
    # $_[1] : File for drawing result or -1 for nothing
    # $_[2] : Options
    
    my $res = &__sym_in($_[0]);
    $res = &simplify($res,-1);
    
    if(scalar @_ >= 2 && $_[1] ne "-1") {
	&draw($res,$_[1],$_[2]);           
    }
    
    if(scalar @_== 1 || $_[1] ne "-1") 
    {	
	print colored [$common::COLOR_RESULT], $res."\n";
    }

    return $res;
}


sub sym
{       
    my $ss = $_[0];
    $ss =~ s/\s+//g;   #Remove white
    my $mod = &getSSType($_[0],-1);
    my $result = '';
    
    if ($mod eq 'V')
    {
	$result = substr($ss,1).substr($ss,0,1);
    }

    elsif ($mod eq 'M')
    {
	if(substr($ss,0,1) eq '[')
	{
	    my $i=1;
	    my $val='';
	    while(substr($ss,$i,1) ne ']')
	    {
		$val .= substr($ss,$i,1); 
		$i++;
	    }
	    if($i+1 < length ($ss))
	    {
		$result = substr($ss,$i+1).'['.$val.']';
	    }
	    else
	    {
		$result = '['.$val.']';
	    }
	}
	else
	{
	    $result = substr($ss,1).substr($ss,0,1);
	}
    }

    elsif ($mod eq 'S' || $mod eq 'MS' || $mod eq 'SM')
    {
	my $sym = -1;
	if(substr($ss,length($ss)-1,1) eq '*')
	{	    
	    $ss = substr($ss,0,length($ss)-1);
	    $sym = 1;
	}
	my @ss_split=split(/\(/,$ss);
	for(my $i=1;$i<scalar @ss_split;$i++)
	{
	    my $right=(split(/,/,$ss_split[$i]))[0];
	    my $left=(split(/,/,$ss_split[$i]))[1];
	    $left=substr($left,0,length($left)-1);
	    $result .= '('.$left.','.$right.')';
	}
	if($sym == 1)
	{
	    $result .= '*';
	}	    
    }

    elsif ($mod eq 'MULTI')
    {
	$result = &symDiag($ss,-1);
    }
    
    else
    {
	$result = -1;
	if (scalar @_== 1 || $_[1] ne "-1") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_SYM_ERR0.$ss."\n";
	}

	return $result;
    }

    if(scalar @_== 1 || $_[1] ne "-1") 
    {	
	print colored [$common::COLOR_RESULT], $result."\n";
    }

    return $result;
    
}


sub __sym_in
{
    # $_[0] : SS

    my $ss=uc(&LADDER::toMultiSync($_[0],0,-1));

    my $period_orig=&getPeriod($ss,-1);                
    my $dot_mode = 1;  # Sync Hack : Do not remove 0 after sync throw  
    my $color_mode = 2; # Colorization Mode for Multiplexes # No need here to have it as a parameter. It has no impact ! 
    my ($period,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &LADDER::__build_dicts($ss, $color_mode, $dot_mode);
    
    my %ss_hash = %{$ss_hash_tmp};
    my %transit_hash = %{$transit_hash_tmp};
    my %transit_hash_tmp2 = ();

    while (my ($key, $value) = each(%transit_hash)) {			   
	my $v1 = (split(/:/,$key))[0];
	my $v2 = (split(/:/,$value))[0];
	my $vtm1 = "";
	my $vtm2 = "";
	if($v1 =~ "R")
	{
	    $vtm1="L";
	}
	else
	{
	    $vtm1="R";
	}
	if($v2 =~ "R")
	{
	    $vtm2="L";
	}
	else
	{
	    $vtm2="R";
	}

	my $src=$vtm1.substr($v1,1).":".((split(/:/,$key))[1]); 
	my $dst=$vtm2.substr($v2,1).":".((split(/:/,$key))[1]); 	
	$transit_hash_tmp2{$src} = $dst;
    }
    
    my %transit_hash_res=%transit_hash_tmp2;
    
    my $ss_res = &LADDER::__get_ss_from_transitionsMAP(\%transit_hash_res, $queue_hand);
    # On Sync Siteswap, it has no impact moving the "*" at the end ...
    if(substr($ss_res,0,1) eq "*" && (&getSSType($ss_res,-1) eq "S" || &getSSType($ss_res,-1) eq "MS"))
    {
	$ss_res = substr($ss_res,1)."*";
    }
    
    return $ss_res;
}



sub dual
{    
    # $_[0] : SS
    # $_[1] : Height Max
    # $_[2] : File for drawing result or -1 for nothing
    # $_[3] : Options

    
    sub __dual_getNbMultMax
    {
	my $cpt = 0;
	
	for (my $i=0; $i < length($_[0]); $i++)
	{
	    if(substr($_[0],$i,1) eq '[')
	    {
		my $cpt_tmp = 0;
		$i ++;
		while (substr($_[0],$i,1) ne ']')
		{
		    $cpt_tmp ++;
		    $i++;
		}
		if ($cpt_tmp > $cpt)
		{
		    $cpt = $cpt_tmp;
		}
	    }
	    elsif ($cpt < 1)
	    {
		$cpt = 1;
	    }	      
	}
	return $cpt;
    }

    
    my $res = '';

    if ( $_[0] ne 'V' && $_[0] ne 'M')
    {
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_DUAL_ERR0." : ".$_[0]."\n";
	return -1
    }
    
    if (isValid($_[1],-1) == -1)
    {
	if (($_[0] eq 'V' && (scalar @_ <= 3 || $_[3] ne "-1")) || ($_[0] eq 'M' && (scalar @_ <= 4 || $_[4] ne "-1"))) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[1]."\n";
	}
	return -1;
    }     
    
    my $sstype = &getSSType($_[1],-1);
    
    if ($sstype ne 'V' && $sstype ne 'M')
    {
	if (($_[0] eq 'V' && (scalar @_ <= 3 || $_[3] ne "-1")) || ($_[0] eq 'M' && (scalar @_ <= 4 || $_[4] ne "-1"))) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_DUAL_ERR0." : ".$_[1]."\n";
	}    
	return -1
    }

    if (hex($_[2]) < getHeightMax($_[1],-1))
    {
	if (($_[0] eq 'V' && (scalar @_ <= 3 || $_[3] ne "-1")) || ($_[0] eq 'M' && (scalar @_ <= 4 || $_[4] ne "-1"))) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_DUAL_ERR1." : <".getHeightMax($_[1],-1).">\n";
	}
	return -1;
    }
    
    if($_[0] eq 'V' && $sstype eq 'M')
    {
	if (scalar @_ <= 3 || $_[3] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_DUAL_ERR2." : ".$_[0]."\n";
	}
	return -1;
    }
    
    elsif($_[0] eq 'V' && $sstype eq 'V')
    {
	for (my $i=0;$i<length($_[1]);$i++)
	{
	    $res = sprintf("%x",hex($_[2])-hex(substr($_[1],$i,1))).$res;
	}
    }
    else
    {
	my $nb = &__dual_getNbMultMax($_[1]);
	my $res_tmp = '';
	
	if($_[3] < $nb)
	{
	    if(scalar @_ <= 4 || $_[4] ne "-1")
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_DUAL_ERR3." : <".$_[3].">\n";
	    }
	    return -1;
	}

	for (my $i=0; $i < length($_[1]); $i++)
	{
	    my $mult='';
	    my $cpt_tmp = 0;
	    if(substr($_[1],$i,1) eq '[')
	    {
		$i ++;
		while (substr($_[1],$i,1) ne ']')
		{
		    $cpt_tmp ++;
		    $mult = $mult.substr($_[1],$i,1);
		    $i++;
		}
		$i++;
	    }
	    else
	    {
		$mult = substr($_[1],$i,1);
		$cpt_tmp = 1;
	    }
	    
	    my $val = '0'x($_[3] - $cpt_tmp).$mult;
	    my $val_c = '';
	    for (my $j=0;$j<length($val);$j++)
	    {
		$val_c = $val_c.sprintf("%x",hex($_[2])-hex(substr($val,$j,1)));
	    }
	    $res_tmp = $res_tmp.'['.$val_c.']';
	}
	
	for (my $i=0; $i < length($res_tmp); $i++)
	{
	    if(substr($res_tmp,$i,1) eq '[')
	    {
		$res = ']'.$res;
	    }
	    elsif(substr($res_tmp,$i,1) eq ']')
	    {
		$res = '['.$res;
	    }
	    else
	    {
		$res=substr($res_tmp,$i,1).$res;
	    }			
	}
    }
    
    
    if ($_[0] eq 'V' && scalar @_ > 3 && $_[3] ne "-1")
    {
	&draw($res,$_[3],$_[4]);           
    }
    elsif ($_[0] eq 'M' && scalar @_ > 4 && $_[4] ne "-1")
    {
	&draw($res,$_[4],$_[5]);           
    }

    if (($_[0] eq 'V' && (scalar @_ <= 3 || $_[3] ne "-1")) || ($_[0] eq 'M' && (scalar @_ <= 4 || $_[4] ne "-1")))
    {	
	print colored [$common::COLOR_RESULT], $res."\n";
    }

    return $res;
}


# Return Aggregated Orbits related to a Siteswap 
sub getOrbitsAggr
{
    # $_[0] : ss
    # $_[1] : Optional : Colorization Mode for Multiplexes (Default : 2)
    # $_[2] : File for results or -1 for silence run 

    my $hmax = $MAX_HEIGHT;
    my $mult_ss = 30;

    my $ss = uc(&expandSync($_[0],-1)) ; # x $mult_ss;
    $ss =~ s/\s+//g;
    my $color_mode = 2; # Colorization Mode for Multiplexes (Default : 2)
    my $dot_mode = 1;  # Sync Hack : keep it as generated after a Multisync transformation (if 0 : Remove 0 after sync throw) 

    if(scalar @_ > 1)
    {
	$color_mode = $_[1];
    }

    # Build Colorization and dicts
    my $period_orig = &getPeriod($ss,-1); 
    my ($period,  $transit_hash_tmp, $ss_hash_tmp) = &LADDER::__build_dicts($ss, $color_mode, $dot_mode);
    my %ss_hash = %{$ss_hash_tmp};
    my %transit_hash = %{$transit_hash_tmp};
    
    # Compute the Orbite Cycle
    my %orbit_cycles_prepa = ();
    my %orbit_cycles_num_prepa = ();
    for (my $i = 0; $i < $period ; $i++) {
	for (my $j = 0; $j < $MAX_MULT; $j++) {
	    my $stop = 0;
	    while($stop < 2)
	    {
		my $k = 0;
		if($stop == 0)
		{
		    $k = "R".$i.":".$j;
		}
		else
		{
		    $k = "L".$i.":".$j;
		}
		$stop++;
		if(exists $transit_hash{$k})
		{		    	    
		    my $v1a = substr((split(/:/,$transit_hash{$k}))[0],0,1);
		    my $v1b = substr((split(/:/,$transit_hash{$k}))[0],1);
		    my $v2 = (split(/:/,$transit_hash{$k}))[1];
		    
		    if($v1b >= $period)
		    {
			my $v1c = $v1b % $period;
			if(($v1b-$v1c) % 2 == 0)
			{
			    if(exists ($orbit_cycles_prepa{$k}))
			    {
				print "== SSWAP::getOrbitsAggr : Should be a bug somewhere ! \n";
			    }
			    else
			    {
				if(exists ($orbit_cycles_num_prepa{$v1a.$v1c}))
				{
				    $orbit_cycles_num_prepa{$v1a.$v1c} ++;
				}
				else
				{
				    $orbit_cycles_num_prepa{$v1a.$v1c} = 0;
				}
				$orbit_cycles_prepa{$k} = $v1a.$v1c.":".$orbit_cycles_num_prepa{$v1a.$v1c};
			    }
			}
			elsif($v1a eq "R")
			{
			    if(exists ($orbit_cycles_prepa{$k}))
			    {
				print "== SSWAP::getOrbitsAggr : Should be a bug somewhere ! \n";
			    }
			    else
			    {
				if(exists ($orbit_cycles_num_prepa{"L".$v1c}))
				{
				    $orbit_cycles_num_prepa{"L".$v1c} ++;
				}
				else
				{
				    $orbit_cycles_num_prepa{"L".$v1c} = 0;
				}
				$orbit_cycles_prepa{$k} = "L".$v1c.":".$orbit_cycles_num_prepa{"L".$v1c};
			    }
			}
			else
			{
			    if(exists ($orbit_cycles_prepa{$k}))
			    {
				print "== SSWAP::getOrbitsAggr : Should be a bug somewhere ! \n";
			    }
			    else
			    {
				if(exists ($orbit_cycles_num_prepa{"R".$v1c}))
				{
				    $orbit_cycles_num_prepa{"R".$v1c} ++;
				}
				else
				{
				    $orbit_cycles_num_prepa{"R".$v1c} = 0;
				}
				$orbit_cycles_prepa{$k} = "R".$v1c.":".$orbit_cycles_num_prepa{"R".$v1c};
			    }
			}
		    }
		    else
		    {
			if(exists ($orbit_cycles_prepa{$k}))
			{
			    print "== SSWAP::getOrbitsAggr : Should be a bug somewhere ! \n";
			}
			else
			{
			    if(exists ($orbit_cycles_num_prepa{$v1a.$v1b}))
			    {
				$orbit_cycles_num_prepa{$v1a.$v1b} ++;
			    }
			    else
			    {
				$orbit_cycles_num_prepa{$v1a.$v1b} = 0;
			    }
			    
			    $orbit_cycles_prepa{$k} = $v1a.$v1b.":".$orbit_cycles_num_prepa{$v1a.$v1b};
			}
		    }    
		}
	    }
	}
    }

    my %orbit_cycles_prepa_tmp=%orbit_cycles_prepa;
    my %orbit_cycles=();

    my $cpt = 0;
    for (my $i = 0; $i < $period ; $i++) {
	for (my $j = 0; $j < $MAX_MULT; $j++) {
	    my $stop = 0;
	    while($stop < 2)
	    {
		my $k = 0;
		if($stop == 0)
		{
		    $k = "R".$i.":".$j;
		}
		else
		{
		    $k = "L".$i.":".$j;
		}
		$stop++;
		if(exists $orbit_cycles_prepa_tmp{$k} && $orbit_cycles_prepa_tmp{$k} ne "")
		{
		    my $val=$orbit_cycles_prepa_tmp{$k};
		    $orbit_cycles{$cpt}=$k.";".$val;
		    my $compute = 1;
		    while($compute == 1)
		    {
			if(exists $orbit_cycles_prepa_tmp{$val})
			{
			    $orbit_cycles{$cpt}=$orbit_cycles{$cpt}.";".$orbit_cycles_prepa_tmp{$val}; 
			    my $val2=$orbit_cycles_prepa_tmp{$val};
			    undef $orbit_cycles_prepa_tmp{$val};
			    undef $orbit_cycles_prepa_tmp{$k};
			    $val = $val2;
			}
			else
			{
			    $compute = -1;
			    if(exists $orbit_cycles{$cpt})
			    {
				$cpt ++;	      
			    }
			}
		    }
		}
	    }
	}
    }


    # Get Siteswap/throws related to cycle
    my %orbit_ss = ();
    my %orbit_throws = ();
    
    foreach my $i (sort keys (%orbit_cycles)) {
	my %ss_hash_tmp = ();    
	my @unicycl = split(/;/,$orbit_cycles{$i});
	
	for(my $j=0;$j < scalar @unicycl -1; $j++)
	{
	    $ss_hash_tmp{$unicycl[$j]}=$ss_hash{$unicycl[$j]};
	    $orbit_throws{$i} = $orbit_throws{$i}.$ss_hash{$unicycl[$j]};
	}
	
	foreach my $k (sort keys (%orbit_cycles_prepa))
	{
	    if(!exists $ss_hash_tmp{$k})
	    {
		$ss_hash_tmp{$k} = "0";
	    }
	}
	$orbit_ss{$i}=&LADDER::__get_ss_from_ssMAP(\%ss_hash_tmp);
    }
    
    # Get final Orbit cycles by removing null cycles
    my %final_orbit_cycles=();
    my $cpt = 0;
    
    foreach my $i (sort keys (%orbit_ss)) { 	   
	if(&getObjNumber($orbit_ss{$i},"-1") != 0)
	{
	    $final_orbit_cycles{$i}=$orbit_cycles{$i};
	    $cpt++;
	}
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::getOrbitsAggr :\n";
    }
    
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	open(FILE,">> $conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "==== AGGREGATED ORBITS =============\n";
    }
    
    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "==== AGGREGATED ORBITS =============\n";
	print "\n\t== CYCLES TIMES :\n";
	
	foreach my $i (sort keys (%orbit_cycles)) { 	   
	    print "\t".$i." => ".$orbit_cycles{$i}."\n";
	}
	print "\n";
    }
    elsif (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\n\t"."== CYCLES TIMES : \n";
	foreach my $i (sort keys (%orbit_cycles)) { 	   
	    print FILE "\t".$i." => ".$orbit_cycles{$i}."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t== VALID CYCLES TIMES :\n";	
	foreach my $i (sort keys (%final_orbit_cycles)) { 	   
	    print "\t".$i." => ".$final_orbit_cycles{$i}."\n";
	}
	print "\n";
    }
    elsif (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== VALID CYCLES TIMES : \n";
	foreach my $i (sort keys (%final_orbit_cycles)) { 	   
	    print FILE "\t".$i." => ".$final_orbit_cycles{$i}."\n";
	}
	print FILE "\n";
    }


    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t"."== THROWS :\n";
	foreach my $i (sort keys (%orbit_throws)) { 	    
	    print "\t".$i." => ".$orbit_throws{$i}."\n";
	}
	print "\n";
    }            
    elsif (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== THROWS :\n";
	foreach my $i (sort keys (%orbit_throws)) { 	    
	    print FILE "\t".$i." => ".$orbit_throws{$i}."\n";
	}
	print FILE "\n";
    }
    
    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t"."== SITESWAPS :\n";
	foreach my $i (sort keys (%orbit_ss)) {
	    # A bad hack to handle * at the end ;-(
	    if ((&isValid($orbit_ss{$i},-1))==-1)
	    {
		$orbit_ss{$i} = $orbit_ss{$i}."*";
	    } 	   
	    print "\t".$i." => ".$orbit_ss{$i}."\n";
	}
	print "\n";
    }    
    elsif (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== SITESWAPS :\n";
	foreach my $i (sort keys (%orbit_ss)) { 	   
	    # A bad hack to handle * at the end ;-(
	    if ((&isValid($orbit_ss{$i},-1))==-1)
	    {
		$orbit_ss{$i} = $orbit_ss{$i}."*";
	    }
	    print FILE "\t".$i." => ".$orbit_ss{$i}."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t"."== NB OBJECTS :\n";
	foreach my $i (sort keys (%orbit_ss)) { 	   
	    print "\t".$i." => ".&getObjNumber($orbit_ss{$i},"-1")."\n";
	}
	print "\n";
	print "====================================\n\n";
    }    
    elsif (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== NB OBJECTS :\n";
	foreach my $i (sort keys (%orbit_ss)) { 	   
	    print FILE "\t".$i." => ".&getObjNumber($orbit_ss{$i},"-1")."\n";
	}
	print FILE "\n";
	print FILE "====================================\n\n";
	close FILE;
    }
    
    return (\%final_orbit_cycles, \%orbit_throws, \%orbit_ss);
    
}


# Return Orbits related to a Siteswap 
sub getOrbits
{
    # $_[0] : ss
    # $_[1] : Optional : Colorization Mode for Multiplexes (Default : 2)
    # $_[2] : File for results or -1 for silence run 

    # Shrink to have a reduction on the Orbits
    sub __shrinkOrbs
    {
	my $res = "";
	my $src=$_[0];
	my $drap = -1;

	for(my $bloc=1; $bloc <= length($src); $bloc ++)
	{
	    if($drap == 1) {last;}
	    if(length($src)%$bloc != 0)
	    {
		next;
	    }
	    
	    my $cpt = length($src) / $bloc;
	    my $min = substr($src, 0, $bloc);
	    for(my $i=1; $i < $cpt ; $i++)
	    {	    
		if($min ne substr($src,$i*$bloc,$bloc))
		{		
		    last;
		}
		elsif(($i+1)*$bloc == length($src))
		{
		    $drap = 1;
		    $res = substr($src, 0, $bloc);
		}	    
	    }
	}
	
	if($drap == -1)
	{
	    $res = $src;
	}

	return $res;
    }


    sub __isEquivalentPermut
    {
	my $vect1 = $_[0];
	my $vect2 = $_[1];
	if(length($vect1)!=length($vect2))
	{
	    return -1;
	}
	for (my $i=0; $i < length($vect2)-1; $i++)
	{
	    if($vect1 eq $vect2)
	    {return 1;}
	    $vect2=substr($vect2,1).substr($vect2,0,1);
	    if($vect1 eq $vect2)
	    {return 1;}
	}
	
	return -1;
    }

    my $hmax = $MAX_HEIGHT;
    my $mult_ss = 30;
    my $ss = uc($_[0]) x $mult_ss;
    $ss =~ s/\s+//g;
    my $color_mode = 2; # Colorization Mode for Multiplexes (Default : 2)
    my $dot_mode = 1;  # Sync Hack : keep it as generated after a Multisync transformation (if 0 : Remove 0 after sync throw) 

    if(scalar @_ > 1)
    {
	$color_mode = $_[1];
    }

    # Build Colorization and dicts
    my $loopss = int(&getHeightMax($_[0],-1)/&getPeriod($_[0],-1)) + 1;
    my $period_orig = &getPeriod($_[0] x $loopss,-1); # TO DO ? Twice to handle last eventual "*"
    my ($period,  $transit_hash_tmp, $ss_hash_tmp) = &LADDER::__build_dicts($ss, $color_mode, $dot_mode);
    my %ss_hash = %{$ss_hash_tmp};
    my %transit_hash = %{$transit_hash_tmp};
    my %color_hash = %{&LADDER::__build_colorMAP_from_transitionsMAP(\%transit_hash)};
    my %reverse_color_hash = reverse %color_hash;

    # For the orbits :
    my %orbits_throws_hash = ();
    my %orbits_time_hash = ();
    my %orbits_ss_hash = ();
    my %orbits_transit_hash = ();
    my %ss_start_hash = ();


    my $cpt_color=0;
    for($cpt_color=0; $cpt_color < scalar @common::GRAPHVIZ_COLOR_TABLE; $cpt_color++)
    {       
	my $stop = -1;
	# TO DO : TO CHECK IF NECESSARY : Do not start to 0, to have the complete view of all catches !
	for (my $i = 0; $i < $period_orig  ; $i++) 
	{
	    if($stop ==-1)
	    {
		for (my $j = 0; $j < $MAX_MULT; $j++) {
		    my $k = "R".$i.":".$j;
		    if(exists $color_hash{$k} && ($color_hash{$k} eq $common::GRAPHVIZ_COLOR_TABLE[$cpt_color]))
		    {	
			if(exists $ss_hash{$k})
			{			
			    if(!exists $ss_start_hash{$cpt_color})
			    {
				$ss_start_hash{$cpt_color} = $i;
			    }
			    
			    my $kc="R".($i%$period_orig).":".$j;		
			    if(substr($orbits_time_hash{$cpt_color},0,length($kc)) eq $kc)
			    {
				$stop=1;
				last;
			    }
			    $orbits_time_hash{$cpt_color}=$orbits_time_hash{$cpt_color}."$kc".";";
			    $orbits_throws_hash{$cpt_color}=$orbits_throws_hash{$cpt_color}.$ss_hash{$k};	   	    
			    #$orbits_transit_hash{$cpt_color}{$k}=$transit_hash{$k};
			    my $tr = $transit_hash{$k};
			    my $v1 = substr((split(/:/,$tr))[0],0,1);
			    my $v2 = substr((split(/:/,$tr))[0],1);
			    my $v3 = (split(/:/,$tr))[1];
			    if($ss_start_hash{$cpt_color} %2 == 0)
			    {
				$orbits_transit_hash{$cpt_color}{"R".($i-$ss_start_hash{$cpt_color}).":".$j}=$v1.($v2-$ss_start_hash{$cpt_color}).":".$v3;
			    }
			    else
			    {
				if($v1 eq "R")
				{
				    $v1 = "L";
				}
				else
				{
				    $v1 = "R";
				}

				$orbits_transit_hash{$cpt_color}{"L".($i-$ss_start_hash{$cpt_color}).":".$j}=$v1.($v2-$ss_start_hash{$cpt_color}).":".$v3;
			    }
			}
		    }
		    else
		    {
			$k = "L".$i.":".$j;
			if(exists $color_hash{$k} && ($color_hash{$k} eq $common::GRAPHVIZ_COLOR_TABLE[$cpt_color]))
			{
			    if(exists $ss_hash{$k})
			    {	
				if(!exists $ss_start_hash{$cpt_color})
				{
				    $ss_start_hash{$cpt_color} = $i;
				}

				my $kc="L".($i%$period_orig).":".$j;		
				if(substr($orbits_time_hash{$cpt_color},0,length($kc)) eq $kc)
				{
				    $stop=1;
				    last;
				}	
				$orbits_time_hash{$cpt_color}=$orbits_time_hash{$cpt_color}."$kc".";";
				$orbits_throws_hash{$cpt_color}=$orbits_throws_hash{$cpt_color}.$ss_hash{$k};	   	    
				my $tr = $transit_hash{$k};
				my $v1 = substr((split(/:/,$tr))[0],0,1);
				my $v2 = substr((split(/:/,$tr))[0],1);
				my $v3 = (split(/:/,$tr))[1];
				if($ss_start_hash{$cpt_color} %2 == 0)
				{
				    $orbits_transit_hash{$cpt_color}{"L".($i-$ss_start_hash{$cpt_color}).":".$j}=$v1.($v2-$ss_start_hash{$cpt_color}).":".$v3;
				}
				else
				{
				    if($v1 eq "R")
				    {
					$v1 = "L";
				    }
				    else
				    {
					$v1 = "R";
				    }
				    $orbits_transit_hash{$cpt_color}{"R".($i-$ss_start_hash{$cpt_color}).":".$j}=$v1.($v2-$ss_start_hash{$cpt_color}).":".$v3;
				}
			    }
			}
		    }
		}
	    }	
	}

	my $stop2 = -1;
	for (my $l = $period_orig; $l < $period  ; $l++) 
	{
	    if($stop2 ==-1)
	    {
		for (my $m = 0; $m < $MAX_MULT; $m++) {
		    my $s = "R".$l.":".$m;
		    if(exists $color_hash{$s} && ($color_hash{$s} eq $common::GRAPHVIZ_COLOR_TABLE[$cpt_color]))
		    {	
			if(exists $ss_hash{$s})
			{	
			    my $v1 = "R";
			    if($ss_start_hash{$cpt_color}-1 %2 == 0)
			    {
				$v1 = "R";
			    }
			    else
			    {
				$v1 = "L";
			    }

			    if(!exists $orbits_transit_hash{$cpt_color}{$v1.($l-1-$ss_start_hash{$cpt_color}).":0"})
			    {
				$orbits_transit_hash{$cpt_color}{$v1.($l-1-$ss_start_hash{$cpt_color}).":0"}=$v1.($l-1-$ss_start_hash{$cpt_color}).":0";
			    }
			    $stop2 = 1;
			    last;
			}
		    }
		    else
		    {
			$s = "L".$l.":".$m;
			if(exists $color_hash{$s} && ($color_hash{$s} eq $common::GRAPHVIZ_COLOR_TABLE[$cpt_color]))
			{
			    if(exists $ss_hash{$s})
			    {
				my $v1 = "L";
				if($ss_start_hash{$cpt_color}-1 %2 == 0)
				{
				    $v1 = "L";
				}
				else
				{
				    $v1 = "R";
				}

				if(!exists $orbits_transit_hash{$cpt_color}{$v1.($l-1-$ss_start_hash{$cpt_color}).":0"})
				{
				    $orbits_transit_hash{$cpt_color}{$v1.($l-1-$ss_start_hash{$cpt_color}).":0"}=$v1.($l-1-$ss_start_hash{$cpt_color}).":0"; 
				}
				$stop2 = 1;
				last;
			    }
			}
		    }				
		}
	    }
	    else
	    {
		last;
	    }
	}
	
    }

    foreach my $i (sort keys (%orbits_throws_hash)) { 	   
	$orbits_throws_hash{$i}=&__shrinkOrbs($orbits_throws_hash{$i});
    }

    my %orbits_throws_hash_aggr_tmp=();
    my %orbits_throws_hash_aggr=();

    foreach my $i (sort keys (%orbits_throws_hash)) { 	          
	my $found = -1;
	foreach my $j (sort keys (%orbits_throws_hash_aggr_tmp)) { 	                 
	    if(&__isEquivalentPermut($orbits_throws_hash{$i},$orbits_throws_hash_aggr_tmp{$j})==1)
	    {
		$found = 1;
		$orbits_throws_hash_aggr{$orbits_throws_hash_aggr_tmp{$j}} = $orbits_throws_hash_aggr{$orbits_throws_hash_aggr_tmp{$j}}.$i.";";
		last;
	    }
	}

	if($found == -1)
	{
	    $orbits_throws_hash_aggr_tmp{$i} = $orbits_throws_hash{$i};	   
	    $orbits_throws_hash_aggr{$orbits_throws_hash{$i}} = $orbits_throws_hash_aggr{$orbits_throws_hash{$i}}.$i.";"; 
	}
    }

    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::getOrbits :\n";
    }

    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	open(FILE,">> $conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "==== ORBITS ========================\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "==== ORBITS ========================\n";
	print "\n\t"."== TIMES :\n";
	foreach my $i (sort keys (%orbits_time_hash)) { 	    
	    print "\t".$i." => ".$orbits_time_hash{$i}."\n";
	}
	print "\n";
    }
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\n\t"."== TIMES :\n";
	foreach my $i (sort keys (%orbits_time_hash)) { 	    
	    print FILE "\t".$i." => ".$orbits_time_hash{$i}."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t== THROWS :\n";
	foreach my $i (sort keys (%orbits_throws_hash)) { 	   
	    print "\t".$i." => ".$orbits_throws_hash{$i}."\n";
	}
	print "\n";
    }            
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== THROWS : \n";
	foreach my $i (sort keys (%orbits_throws_hash)) { 	   
	    print FILE "\t".$i." => ".$orbits_throws_hash{$i}."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t== SITESWAPS :\n";
	foreach my $i (sort keys (%orbits_transit_hash)) {
	    $orbits_ss_hash{$i}=&LADDER::__get_ss_from_transitionsMAP(\%{$orbits_transit_hash{$i}});
	    # Remove starting "*" if it happens 
	    if(substr($orbits_ss_hash{$i},0,1) eq "*")
	    {
		my $v = $orbits_ss_hash{$i};
		$orbits_ss_hash{$i} = substr($v,length($v)-1,1).substr($v,1,length($v)-2);
	    }
	    # A bad hack to handle * at the end ;-(
	    if ((&isValid($orbits_ss_hash{$i},-1))==-1)
	    {
		$orbits_ss_hash{$i} = $orbits_ss_hash{$i}."*";
	    }
	    print "\t".$i." => ".$orbits_ss_hash{$i}."\n";

	}
	print "\n";
    }            
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== SITESWAPS : \n";
	foreach my $i (sort keys (%orbits_transit_hash)) { 	   
	    $orbits_ss_hash{$i}=&LADDER::__get_ss_from_transitionsMAP(\%{$orbits_transit_hash{$i}});
	    # Remove starting "*" if it happens 
	    if(substr($orbits_ss_hash{$i},0,1) eq "*")
	    {
		$orbits_ss_hash{$i} = substr($orbits_ss_hash{$i},1);
	    }
	    # A bad hack to handle * at the end ;-(
	    if ((&isValid($orbits_ss_hash{$i},-1))==-1)
	    {
		$orbits_ss_hash{$i} = $orbits_ss_hash{$i}."*";
	    }
	    print FILE "\t".$i." => ".$orbits_ss_hash{$i}."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t== NB OBJECTS :\n";
	foreach my $i (sort keys (%orbits_ss_hash)) {
	    print "\t".$i." => ".&getObjNumber($orbits_ss_hash{$i},-1)."\n";
	}
	print "\n";
    }            
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== NB OBJECTS : \n";
	foreach my $i (sort keys (%orbits_ss_hash)) { 	   
	    print FILE "\t".$i." => ".&getObjNumber($orbits_ss_hash{$i},-1)."\n";
	}
	print FILE "\n";
    }

    if(($SSWAP_DEBUG >= 1) || (scalar @_ <= 2))
    {
	print "\t"."== AGGREGATION - THROWS :\n";
	foreach my $i (sort keys (%orbits_throws_hash_aggr)) { 	   
	    print "\t".$orbits_throws_hash_aggr{$i}." => ".$i."\n";
	}
	print "\n";
	print "====================================\n\n";
    }    
    if (scalar @_ > 2 && $_[2] ne "-1")
    {
	print FILE "\t"."== AGGREGATION - THROWS :\n";
	foreach my $i (sort keys (%orbits_throws_hash_aggr)) { 	   
	    print FILE "\t".$orbits_throws_hash_aggr{$i}." => ".$i."\n";
	}
	print FILE "====================================\n\n";
	close FILE;
    }

    return (\%orbits_time_hash, \%orbits_throws_hash, \%orbits_throws_hash_aggr, \%orbits_ss_hash);

}


sub getHeightMax
{
    my $ss=&LADDER::toMultiSync($_[0],0,-1);
    my $height_max=0;
    my $pattern = uc($ss);
    foreach(my $i=0; $i < length($ss); $i++)
    {
	if(substr($ss,$i,1) ne "X" 
	   && substr($ss,$i,1) ne "!" 
	   && substr($ss,$i,1) ne "*" 
	   && hex(substr($ss,$i,1)) > $height_max)
	{
	    $height_max=hex(substr($ss,$i,1));
	}
    }

    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], $height_max."\n";
    }
    
    return $height_max;
}


sub getHeightMin
{
    my $ss=&LADDER::toMultiSync($_[0],0,-1);
    my $height_min=$MAX_HEIGHT;
    my $pattern = uc($ss);
    foreach(my $i=0; $i < length($ss); $i++)
    {
	if(substr($ss,$i,1) ne "X" 
	   && substr($ss,$i,1) ne "!" 
	   && substr($ss,$i,1) ne "*" 
	   && hex(substr($ss,$i,1)) < $height_min)
	{
	    $height_min=hex(substr($ss,$i,1));
	}
    }

    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], $height_min."\n";
    }
    
    return $height_min;
}



sub getObjNumber
{    
    if (&isValid($_[0],-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }

    my $mod = &isSyntaxValid($_[0],-1);
    my $ss=&LADDER::toMultiSync($_[0],0,-1);
    my $pattern = uc($ss);
    my $sum = 0;
    my $period =0;

    my @st=split('', $pattern);
    
    # Compute Sum, Period and highest throw in first of all
    for (my $i=0; $i<scalar @st; $i++) {	
	if ($st[$i] eq "!") {
	    $period --;
	} elsif ($st[$i] eq "*") {
	    # Will be done later on sync when it will be at the end.
	} else {	    
	    if ($st[$i] eq "0" || $st[$i] eq "1" || $st[$i] eq "2" || $st[$i] eq "3" || $st[$i] eq "4" 
		|| $st[$i] eq "5" || $st[$i] eq "6" || $st[$i] eq "7" || $st[$i] eq "8" || $st[$i] eq "9") {	    
		
		# Compute the sum
		$sum += int($st[$i]);
		
		if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			    
	    } elsif ($st[$i] eq "A" || $st[$i] eq "B" || $st[$i] eq "C" || $st[$i] eq "D" || $st[$i] eq "E"
		     || $st[$i] eq "F") {	
		
		my $hex=ord($st[$i])-ord("A") + 10;	    
		
		#Compute the sum
		$sum += $hex;	  
		
		if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			
	    }
	    
	    $period ++;
	    
	}      
    }
    

    # NOT LOGICAL ... but everyone do likes that. They double the period/sum on Sync Siteswap when it finishes by "*"
    # We will not do it for others ones.
    if((substr($_[0],length($_[0])-1) eq "*") && ($mod == 3 || $mod == 4))
    {
	$sum = $sum * 2;
	$period = $period *2;
    };    

    my $nb = $sum / $period;
    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], $nb."\n";
    }

    return $nb;
}



sub getSSstatus
{
    #$_[1] : if present : 
    #        -1 => as Silent as possible, return the States Status (GROUND/EXCITED/UNKNOWN)  
    #        -2 => as Silent as possible ... but on GROUND states return the involved siteswaps

    my $ss=$_[0];
    my $orig='';

    if (&isValid($ss,-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1" && $_[1] ne "-2")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }
    my $nbObjects=&getObjNumber($ss,-1);
    
    my $mod=&getSSType($_[0],-1);
    if ($mod eq "V" || $mod eq "M") {	
	if ($nbObjects > $MAX_NBOBJ) {
	    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		print colored [$common::COLOR_RESULT], "UNKNOWN\n";
	    }
	    return "UNKNOWN";	  
	} 
	else
	{
	    my $ret = sprintf("%x",$nbObjects) x $nbObjects;
	    $orig=sprintf("%x",$nbObjects);
	    $ret = $ret.$ss.$ss;
	    if (&isValid($ret,-1)==1) {
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "GROUND => ".lc($orig)."\n";
		}
		if($_[1] == -2)
		{
		    return ("GROUND", lc($orig));
		}
		else
		{
		    return "GROUND";
		}
	    } else {
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "EXCITED\n";
		}
		return "EXCITED";
	    }
	}
    } elsif ($mod eq "S" || $mod eq "MS" || $mod eq "SM") {	
	if ($nbObjects > $MAX_NBOBJ) {
	    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		print colored [$common::COLOR_RESULT], "UNKNOWN\n";
	    }
	    return "UNKNOWN";
	} elsif ($nbObjects%2 == 0) {
	    my $v1 = "(".sprintf("%x",$nbObjects).",".sprintf("%x",$nbObjects).")";
	    my $v2 = "(".sprintf("%x",$nbObjects)."X,".sprintf("%x",$nbObjects)."X)";
	    my $ret1 = $v1 x $nbObjects;
	    my $ret2 = $v2 x $nbObjects;
	    $ret1 = $ret1.$ss.$ss;	    
	    $ret2 = $ret2.$ss.$ss;
	    my $valid1 = &isValid($ret1,-1);
	    my $valid2 = &isValid($ret2,-1);	    

	    if ($valid1==1 || $valid2==1) {
		if($valid1==1)
		{
		    $orig = $v1;
		}
		if($valid2==1)
		{
		    if($orig eq "")
		    {
			$orig = $v2;
		    }
		    else
		    {
			$orig = $orig."; ".$v2;
		    }
		}
		
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "GROUND => ".lc($orig)."\n";
		}
		if($_[1] == -2)
		{
		    return ("GROUND", lc($orig));
		}
		else
		{
		    return "GROUND";
		}
	    } else {
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "EXCITED\n";
		}
		return "EXCITED";
	    }
	} else {
	    if ($nbObjects + 1 > $MAX_NBOBJ) {
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "UNKNOWN\n";
		}
		return "UNKNOWN";
	    }

	    my $v1 = "(".sprintf("%x",$nbObjects-1).",".sprintf("%x",$nbObjects+1).")";
	    my $v2 = "(".sprintf("%x",$nbObjects-1)."X,".sprintf("%x",$nbObjects+1)."X)";
	    my $v3 = "(".sprintf("%x",$nbObjects+1).",".sprintf("%x",$nbObjects-1).")";
	    my $v4 = "(".sprintf("%x",$nbObjects+1)."X,".sprintf("%x",$nbObjects-1)."X)";
	    my $ret1 = $v1 x $nbObjects;
	    my $ret2 = $v2 x $nbObjects;
	    my $ret3 = $v3 x $nbObjects;
	    my $ret4 = $v4 x $nbObjects;
	    $ret1 = $ret1.$ss.$ss;
	    $ret2 = $ret2.$ss.$ss;
	    $ret3 = $ret3.$ss.$ss;
	    $ret4 = $ret4.$ss.$ss;
	    my $valid1 = &isValid($ret1,-1);
	    my $valid2 = &isValid($ret2,-1);	    
	    my $valid3 = &isValid($ret3,-1);	    
	    my $valid4 = &isValid($ret4,-1);	    

	    if ($valid1==1 || $valid2==1 || $valid3==1 || $valid4==1) 
	    {	    
		if($valid1==1)
		{
		    $orig = $v1;
		}
		if($valid2==1)
		{
		    if($orig eq "")
		    {
			$orig = $v2;
		    }
		    else
		    {
			$orig = $orig."; ".$v2;
		    }
		}
		if($valid3==1)
		{
		    if($orig eq "")
		    {
			$orig = $v3;
		    }
		    else
		    {
			$orig = $orig."; ".$v3;
		    }
		}
		if($valid4==1)
		{
		    if($orig eq "")
		    {
			$orig = $v4;
		    }
		    else
		    {
			$orig = $orig."; ".$v4;
		    }
		}
		
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) 
		{		    	    
		    print colored [$common::COLOR_RESULT], "GROUND => ".lc($orig)."\n";
		}
		if($_[1] == -2)
		{
		    return ("GROUND", lc($orig));
		}
		else
		{
		    return "GROUND";
		}		
	    } 
	    else 
	    {
		if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		    print colored [$common::COLOR_RESULT], "EXCITED\n";
		}
		return "EXCITED";
	    }	              
	}  
    }
    
    elsif($mod eq "MULTI") {	
	if ($nbObjects > $MAX_NBOBJ) {
	    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
		print colored [$common::COLOR_RESULT], "UNKNOWN\n";
	    }
	    return "UNKNOWN";         
	}
	else
	{
	    my $v1 = sprintf("%x",$nbObjects)."!0";
	    my $v2 = sprintf("%x",$nbObjects)."X"."!0";
	    my $ret1 = $v1 x $nbObjects;
	    my $ret2 = $v2 x $nbObjects;
	    $ret1 = $ret1.$ss.$ss;
	    $ret2 = $ret2.$ss.$ss;

	    my $v1bis = "0!".sprintf("%x",$nbObjects);
	    my $v2bis = "0!".sprintf("%x",$nbObjects)."X";
	    my $ret1bis = $v1bis x $nbObjects;
	    my $ret2bis = $v2bis x $nbObjects;
	    $ret1bis = $ret1bis.$ss.$ss;
	    $ret2bis = $ret2bis.$ss.$ss;
	    
	    if ($nbObjects%2 == 0) {
		my $v3 = sprintf("%x",$nbObjects/2)."!".sprintf("%x",$nbObjects/2);
		my $v4 = sprintf("%x",$nbObjects/2)."X!".sprintf("%x",$nbObjects/2)."X";
		my $ret3 = $v3 x $nbObjects;
		my $ret4 = $v4 x $nbObjects;
		$ret3 = $ret3.$ss.$ss;
		$ret4 = $ret4.$ss.$ss;
		my $valid1 = &isValid($ret1,-1);
		my $valid1bis = &isValid($ret1bis,-1);
		my $valid2 = &isValid($ret2,-1);	    
		my $valid2bis = &isValid($ret2bis,-1);	    
		my $valid3 = &isValid($ret3,-1);
		my $valid4 = &isValid($ret4,-1);	    
		if ($valid1==1 || $valid1bis==1 || $valid2==1 || $valid2bis==1 || $valid3==1 || $valid4==1) 
		{
		    if($valid1==1)
		    {
			$orig = $v1;
		    }
		    if($valid1bis==1)
		    {
			if($orig eq "")
			{
			    $orig = $v1bis;
			}
			else
			{
			    $orig = $orig."; ".$v1bis;
			}
		    }
		    if($valid2==1)
		    {
			if($orig eq "")
			{
			    $orig = $v2;
			}
			else
			{
			    $orig = $orig."; ".$v2;
			}
		    }
		    if($valid2bis==1)
		    {
			if($orig eq "")
			{
			    $orig = $v2bis;
			}
			else
			{
			    $orig = $orig."; ".$v2bis;
			}
		    }
		    if($valid3==1)
		    {
			if($orig eq "")
			{
			    $orig = $v3;
			}
			else
			{
			    $orig = $orig."; ".$v3;
			}
		    }
		    if($valid4==1)
		    {
			if($orig eq "")
			{
			    $orig = $v4;
			}
			else
			{
			    $orig = $orig."; ".$v4;
			}
		    }
		    
		    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
			print colored [$common::COLOR_RESULT], "GROUND => ".lc($orig)."\n";
		    }
		    if($_[1] == -2)
		    {
			return ("GROUND", lc($orig));
		    }
		    else
		    {
			return "GROUND";
		    }
		} 
		else {
		    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
			print colored [$common::COLOR_RESULT], "EXCITED\n";
		    }
		    return "EXCITED";
		}
	    }
	    else
	    {
		my $nbObjectsMin = int(($nbObjects-1)/2);
		my $nbObjectsPlus = int(($nbObjects+1)/2);

		my $v3 = sprintf("%x",$nbObjectsMin)."!".sprintf("%x",$nbObjectsPlus);
		my $v4 = sprintf("%x",$nbObjectsMin)."X!".sprintf("%x",$nbObjectsPlus)."X";
		my $v5 = sprintf("%x",$nbObjectsPlus)."!".sprintf("%x",$nbObjectsMin);
		my $v6 = sprintf("%x",$nbObjectsPlus)."X!".sprintf("%x",$nbObjectsMin)."X";
		my $ret3 = $v3 x $nbObjects;
		my $ret4 = $v4 x $nbObjects;
		my $ret5 = $v5 x $nbObjects;
		my $ret6 = $v6 x $nbObjects;
		$ret3 = $ret3.$ss.$ss;
		$ret4 = $ret4.$ss.$ss;
		$ret5 = $ret5.$ss.$ss;
		$ret6 = $ret6.$ss.$ss;
		my $valid1 = &isValid($ret1,-1);
		my $valid1bis = &isValid($ret1bis,-1);
		my $valid2 = &isValid($ret2,-1);	    
		my $valid2bis = &isValid($ret2bis,-1);	    
		my $valid3 = &isValid($ret3,-1);
		my $valid4 = &isValid($ret4,-1);	    
		my $valid5 = &isValid($ret5,-1);
		my $valid6 = &isValid($ret6,-1);	    
		if ($valid1==1 || $valid1bis==1 || $valid2==1 || $valid2bis==1 || $valid3==1 || $valid4==1 || $valid5==1 || $valid6==1) 
		{
		    if($valid1==1)
		    {
			$orig = $v1;
		    }
		    if($valid1bis==1)
		    {
			if($orig eq "")
			{
			    $orig = $v1bis;
			}
			else
			{
			    $orig = $orig."; ".$v1bis;
			}
		    }
		    if($valid2==1)
		    {
			if($orig eq "")
			{
			    $orig = $v2;
			}
			else
			{
			    $orig = $orig."; ".$v2;
			}
		    }
		    if($valid2bis==1)
		    {
			if($orig eq "")
			{
			    $orig = $v2bis;
			}
			else
			{
			    $orig = $orig."; ".$v2bis;
			}
		    }
		    if($valid3==1)
		    {
			if($orig eq "")
			{
			    $orig = $v3;
			}
			else
			{
			    $orig = $orig."; ".$v3;
			}
		    }
		    if($valid4==1)
		    {
			if($orig eq "")
			{
			    $orig = $v4;
			}
			else
			{
			    $orig = $orig."; ".$v4;
			}
		    }
		    if($valid5==1)
		    {
			if($orig eq "")
			{
			    $orig = $v5;
			}
			else
			{
			    $orig = $orig."; ".$v5;
			}
		    }
		    if($valid6==1)
		    {
			if($orig eq "")
			{
			    $orig = $v6;
			}
			else
			{
			    $orig = $orig."; ".$v6;
			}
		    }
		    
		    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] ne "-2")) {
			print colored [$common::COLOR_RESULT], "GROUND => ".lc($orig)."\n";
		    }
		    if($_[1] == -2)
		    {
			return ("GROUND", lc($orig));
		    }
		    else
		    {
			return "GROUND";
		    }
		    
		} else {
		    if (scalar @_ == 1 || ($_[1] ne "-1" && $_[1] != "-2")) {
			print colored [$common::COLOR_RESULT], "EXCITED\n";
		    }
		    return "EXCITED";
		}
	    }
	}
    }
    
    return -1;
}


sub getPeriod
{
    my $mod = &isSyntaxValid($_[0],-1);
    
    if ($mod < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1;
	}
	return -1;
    }

    if (&isValid($_[0],-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR0;
	}
	return -1;
    }    

    my $ss = &LADDER::toMultiSync($_[0],0,-1);
    my $pattern = uc($ss);
    my $period =0;

    my @st=split('', $pattern);
    
    # Compute Period 
    for (my $i=0; $i<scalar @st; $i++) {	
	if ($st[$i] eq "!") {
	    $period --;
	} elsif ($st[$i] eq "*") {
	    # Will be done later on sync when it will be at the end.
	} else {	    
	    if ($st[$i] eq "0" || $st[$i] eq "1" || $st[$i] eq "2" || $st[$i] eq "3" || $st[$i] eq "4" 
		|| $st[$i] eq "5" || $st[$i] eq "6" || $st[$i] eq "7" || $st[$i] eq "8" || $st[$i] eq "9") {	    
		
		if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			    
	    } elsif ($st[$i] eq "A" || $st[$i] eq "B" || $st[$i] eq "C" || $st[$i] eq "D" || $st[$i] eq "E"
		     || $st[$i] eq "F") {	
		
		my $hex=ord($st[$i])-ord("A") + 10;	    		
		if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			
	    }
	    
	    $period ++;
	    
	}      
    }
    
    # NOT LOGICAL ... but everyone do likes that. They double the period/sum on Sync Siteswap when it finishes by "*"
    # We will not do it for others ones.
    if((substr($_[0],length($_[0])-1) eq "*") && ($mod == 3 || $mod == 4))
    {
	$period = $period *2;
    };    

    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], "$period\n";
    }

    return $period;

}


sub getSSType
{
    # Return is : 
    #    Async : 1
    #    Multiplex : 2
    #    Sync : 3
    #    Multiplex Sync : 4
    #    MultiSync : 5
    #    Error : -1

    my $res=&isSyntaxValid($_[0],-1); 
    
    if ($res < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False : ".$lang::MSG_SSWAP_ISVALID_ERR1."\n";
	}
	return -1;
    }

    if (&isValid($_[0],-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False : ".$lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }    

    if (scalar @_ == 1 || $_[1] ne "-1") 
    {
	if($res==1) {	    
	    print colored [$common::COLOR_RESULT], "V"."\n";
	}
	elsif($res==2) {	    
	    print colored [$common::COLOR_RESULT], "M"."\n";
	}
	elsif($res==3) {	    
	    print colored [$common::COLOR_RESULT], "S"."\n";
	}
	elsif($res==4) {	    
	    print colored [$common::COLOR_RESULT], "MS"."\n";    
	}
	elsif($res==5) {	    
	    print colored [$common::COLOR_RESULT], "MULTI"."\n";    
	}	
	else {	    
	    print colored [$common::COLOR_RESULT], "UNKNOWN"."\n";    
	}	
    }
    
    if($res==1) {	    
	return "V";
    }
    if($res==2) {	    
	return "M";	
    }
    if($res==3) {	    
	return "S";
    }
    if($res==4) {	    
	return "MS";
    }
    elsif($res==5) {	    
	return "MULTI";
    }	
    else {	    
	return "-1";
    }	    
}


sub getStates
{
    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;   

    my $mod=&getSSType($_[0],-1);
    my $ss_in = $ss;
    my @results = ();
    # handle states length
    my $height_max = &getHeightMax($ss,"-1");

    for(my $i=0;$i<$MAX_MULT;$i++)
    {
	$ss_in = $ss_in.$ss;
    }

    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::getStates :\n";
    }
    
    if ($mod eq "V") {		
	my $ss_in_len = length($ss_in);
	my $ss_len = length($ss);
	my @init_states = ();
	
	# Get initial/final state
	for (my $i=0; $i<$MAX_MULT; $i++)
	{
	    $init_states[$i]=0;
	}
	for (my $i=0; $i<$ss_in_len; $i++)
	{
	    if(hex(substr($ss_in,$i,1)) + $i >= $ss_in_len)
	    {
		my $v = (hex(substr($ss_in,$i,1)) + $i) - $ss_in_len;
		$init_states[$v]++;
	    }
	}
	
	my $inv=join('',reverse(@init_states));
	#remove first 0
	$inv =~ s/^0+//g;
	$results[0]=$inv;

	# Get others states	
	for (my $i=0; $i<$ss_len; $i++)
	{
	    if($init_states[0]==1)
	    {
		push(@init_states,"0");
		$init_states[hex(substr($ss,$i,1))]++;
		@init_states=@init_states[1..scalar @init_states];
		$inv=join('',reverse(@init_states));
		#remove first 0
		$inv =~ s/^0+//g;
		$results[$i+1]=$inv;
	    }
	    else
	    {
		push(@init_states,"0");
		@init_states=@init_states[1..scalar @init_states];
		$inv=join('',reverse(@init_states));
		#remove first 0
		$inv =~ s/^0+//g;
		$results[$i+1]=$inv;
	    }
	}	
    }

    elsif ($mod eq "M") {	
	my $ss_in_len = length($ss_in);
	my $period_ss_in = &getPeriod($ss_in,-1);
	my $period_ss = &getPeriod($ss,-1);
	my $ss_len = length($ss);
	my @init_states = ();
	my $mult=-1;
	my $time=0;

	# Get initial/final state
	for (my $i=0; $i<$MAX_MULT*$MAX_MULT; $i++)
	{
	    $init_states[$i]=0;
	}
	
	for (my $i=0; $i<$ss_in_len; $i++)
	{
	    if(substr($ss_in,$i,1) eq '[')
	    {
		$mult=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ']')
	    {
		$mult=-1;
		$time++;
	    }      
	    elsif(hex(substr($ss_in,$i,1)) + $time >= $period_ss_in)
	    {
		my $v = (hex(substr($ss_in,$i,1)) + $time) - $period_ss_in ;
		$init_states[$v]++;
		if($mult != 1)
		{
		    $time++;
		}
	    }
	    else
	    {
		if($mult != 1)
		{
		    $time++;
		}
	    }
	}

	my @init_states2 = ();
	for(my $k=0; $k < scalar @init_states; $k++)
	{
	    @init_states2[$k]=sprintf("%x",$init_states[$k]);
	}
	my $inv=join('',reverse(@init_states2));
	#remove first 0
	$inv =~ s/^0+//g;
	$results[0]=$inv;

	# Get others states	
	my $cpt = 1;	
	for (my $i=0; $i<$ss_len; $i++)
	{
	    if(substr($ss_in,$i,1) eq '[')
	    {
		$mult=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ']')
	    {
		$mult=-1;
		$time++;
	    }      
	    else
	    {	    	
		if($mult==-1 && $init_states[0]==1)
		{		    
		    $init_states[hex(substr($ss_in,$i,1))]++;
		    push(@init_states,"0");
		    @init_states=@init_states[1..scalar @init_states];
		    my @init_states2 = ();
		    for(my $k=0; $k < scalar @init_states; $k++)
		    {
			@init_states2[$k]=sprintf("%x",$init_states[$k]);
		    }
		    $inv=join('',reverse(@init_states2));
		    #remove first 0
		    $inv =~ s/^0+//g;
		    $results[$cpt]=$inv;
		    $cpt++;
		}
		elsif($mult==1)
		{
		    while(substr($ss_in,$i,1) ne ']' && $i<$ss_len)
		    {
			$init_states[hex(substr($ss_in,$i,1))]++;			
			$i++;
		    }

		    $mult=-1;		    
		    push(@init_states,"0");
		    @init_states=@init_states[1..scalar @init_states];
		    my @init_states2 = ();
		    for(my $k=0; $k < scalar @init_states; $k++)
		    {
			@init_states2[$k]=sprintf("%x",$init_states[$k]);
		    }
		    $inv=join('',reverse(@init_states2));
		    #remove first 0
		    $inv =~ s/^0+//g;
		    $results[$cpt]=$inv;
		    $cpt++;
		}
		elsif($mult==-1)
		{
		    push(@init_states,"0");
		    @init_states=@init_states[1..scalar @init_states];
		    my @init_states2 = ();
		    for(my $k=0; $k < scalar @init_states; $k++)
		    {
			@init_states2[$k]=sprintf("%x",$init_states[$k]);
		    }
		    $inv=join('',reverse(@init_states2));
		    #remove first 0
		    $inv =~ s/^0+//g;
		    $results[$cpt]=$inv;
		    $cpt++;
		}
	    }
	}	
    }

    elsif ($mod eq "S") {
	# handle "*" at the end to have a complete view
	$ss=&expandSync($ss,"-1");
	$ss_in = '';
	for(my $i=0;$i<$MAX_MULT;$i++)
	{
	    $ss_in = $ss_in.$ss;
	}

	my $ss_in_len = length($ss_in);
	my $ss_len = length($ss);
	my $time = 0;
	my $period_ss_in = &getPeriod($ss_in,-1);
	my $side = "R";
	my $sync = -1;
	my @init_states_r = ();
	my @init_states_l = ();
	
	# States length has to be reduced
	$height_max = $height_max % 2 + ($height_max/2) ;

	# Get initial/final state
	for (my $i=0; $i<$MAX_MULT*$MAX_MULT; $i++)
	{
	    $init_states_r[$i]=0;
	    $init_states_l[$i]=0;
	}
	for (my $i=0; $i<$ss_in_len; $i++)
	{
	    if(substr($ss_in,$i,1) eq '(')
	    {
		$sync=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ')')
	    {
		$sync=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
		$time+=2;			
	    }      
	    elsif(substr($ss_in,$i,1) eq '*')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
	    }      
	    elsif(substr($ss_in,$i,1) eq ',')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}		
	    }      
	    elsif(hex(substr($ss_in,$i,1)) + $time >= $period_ss_in)
	    {
		my $v = ((hex(substr($ss_in,$i,1)) + $time) - $period_ss_in)/2 ;
		if($side eq "R" && uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    $init_states_r[$v]++;		    
		}
		elsif($side eq "L" && uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    $init_states_l[$v]++;
		}
		elsif($side eq "R" && uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $init_states_l[$v]++;
		    $i++;
		}
		elsif($side eq "L" && uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $init_states_r[$v]++;
		    $i++;
		}
	    }
	}

	my $inv_l=join('',reverse(@init_states_l));
	my $inv_r=join('',reverse(@init_states_r));
	#remove first 0
	$inv_r =~ s/^0+//g;
	$inv_l =~ s/^0+//g;
	$results[0]=$inv_r.",".$inv_l;

	# Get others states		
	$side = "R";
	$sync = -1;
	my $cpt = 1;
	my $num=0;

	for (my $i=0; $i<$ss_len; $i++)
	{
	    if(substr($ss_in,$i,1) eq '(')
	    {
		$num=0;
		$sync=1;
		$inv_l = '';
		$inv_r = '';
	    }
	    elsif(substr($ss_in,$i,1) eq ')')
	    {
		$sync=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}

		$inv_l=join('',reverse(@init_states_l));
		$inv_r=join('',reverse(@init_states_r));
		#remove first 0
		$inv_r =~ s/^0+//g;
		$inv_l =~ s/^0+//g;
		$results[$cpt]=$inv_r.",".$inv_l;		
		$cpt++;	       	    		
	    }      
	    elsif(substr($ss_in,$i,1) eq ',')
	    {
		$num=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}		
	    }   
	    elsif(substr($ss_in,$i,1) eq '*')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
	    }      
	    elsif($side eq "R" && $init_states_r[0]==1)
	    {	    
		if(uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    push(@init_states_r,"0");
		    $init_states_r[hex(substr($ss_in,$i,1))/2]++;
		    @init_states_r=@init_states_r[1..scalar @init_states_r];
		    $inv_r=join('',reverse(@init_states_r));
		}
		else
		{
		    push(@init_states_l,"0");
		    $init_states_l[hex(substr($ss_in,$i,1))/2+$num]++;
		    @init_states_r=@init_states_r[1..scalar @init_states_r];
		    $inv_r=join('',reverse(@init_states_r));
		    $inv_l=join('',reverse(@init_states_l));
		    $i++;
		}
	    }
	    elsif($side eq "R")
	    {	    
		push(@init_states_r,"0");
		@init_states_r=@init_states_r[1..scalar @init_states_r];
		$inv_r=join('',reverse(@init_states_r));
		if(uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $i++;
		}

	    }
	    elsif($side eq "L" && $init_states_l[0]==1)
	    {	    
		if(uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    push(@init_states_l,"0");
		    $init_states_l[hex(substr($ss_in,$i,1))/2]++;
		    @init_states_l=@init_states_l[1..scalar @init_states_l];
		    $inv_l=join('',reverse(@init_states_l));
		}
		else
		{
		    push(@init_states_l,"0");
		    $init_states_r[hex(substr($ss_in,$i,1))/2+$num]++;
		    @init_states_l=@init_states_l[1..scalar @init_states_l];
		    $inv_l=join('',reverse(@init_states_l));
		    $inv_r=join('',reverse(@init_states_r));
		    $i++;
		}
	    }
	    elsif($side eq "L")
	    {	    
		push(@init_states_l,"0");
		@init_states_l=@init_states_l[1..scalar @init_states_l];
		$inv_l=join('',reverse(@init_states_l));
		if(uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $i++;
		}
	    }
	}
    }

    elsif ($mod eq "MS") {
	# handle "*" at the end to have a complete view
	$ss=&expandSync($ss,"-1");
	$ss_in = '';
	for(my $i=0;$i<$MAX_MULT;$i++)
	{
	    $ss_in = $ss_in.$ss;
	}

	my $ss_in_len = length($ss_in);
	my $ss_len = length($ss);
	my $time = 0;
	my $period_ss_in = &getPeriod($ss_in,-1);
	my $side = "R";
	my $sync = -1;
	my $mult = -1;
	my @init_states_r = ();
	my @init_states_l = ();
	
	# Get initial/final state
	for (my $i=0; $i<$MAX_MULT*$MAX_MULT; $i++)
	{
	    $init_states_r[$i]=0;
	    $init_states_l[$i]=0;
	}
	for (my $i=0; $i<$ss_in_len; $i++)
	{
	    if(substr($ss_in,$i,1) eq '[')
	    {
		$mult=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ']')
	    {
		$mult=-1;
	    }      
	    elsif(substr($ss_in,$i,1) eq '(')
	    {
		$sync=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ')')
	    {
		$sync=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
		$time+=2;			
	    }      
	    elsif(substr($ss_in,$i,1) eq '*')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
	    }      
	    elsif(substr($ss_in,$i,1) eq ',')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}		
	    }      
	    elsif(hex(substr($ss_in,$i,1)) + $time >= $period_ss_in)
	    {
		my $v = ((hex(substr($ss_in,$i,1)) + $time) - $period_ss_in)/2 ;
		if($side eq "R" && uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    $init_states_r[$v]++;		    
		}
		elsif($side eq "L" && uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    $init_states_l[$v]++;
		}
		elsif($side eq "R" && uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $init_states_l[$v]++;
		    $i++;
		}
		elsif($side eq "L" && uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $init_states_r[$v]++;
		    $i++;
		}
	    }
	}

	my @init_states_l2 = ();
	for(my $k=0; $k < scalar @init_states_l; $k++)
	{
	    @init_states_l2[$k]=sprintf("%x",$init_states_l[$k]);
	}
	my @init_states_r2 = ();
	for(my $k=0; $k < scalar @init_states_r; $k++)
	{
	    @init_states_r2[$k]=sprintf("%x",$init_states_r[$k]);
	}

	my $inv_l=join('',reverse(@init_states_l2));
	my $inv_r=join('',reverse(@init_states_r2));
	#remove first 0
	$inv_r =~ s/^0+//g;
	$inv_l =~ s/^0+//g;
	$results[0]=$inv_r.",".$inv_l;

	# Get others states		
	$side = "R";
	$sync = -1;
	my $cpt = 1;
	my $mult = -1;
	my $num=0;

	for (my $i=0; $i<$ss_len; $i++)
	{	    
	    if(substr($ss_in,$i,1) eq '[')
	    {
		$mult=1;
	    }
	    elsif(substr($ss_in,$i,1) eq ']')
	    {
		$mult=-1;
	    }      
	    elsif(substr($ss_in,$i,1) eq '(')
	    {
		$num=0;
		$sync=1;
		$inv_l = '';
		$inv_r = '';
	    }
	    elsif(substr($ss_in,$i,1) eq ')')
	    {
		$sync=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}

		my @init_states_l2 = ();
		for(my $k=0; $k < scalar @init_states_l; $k++)
		{
		    @init_states_l2[$k]=sprintf("%x",$init_states_l[$k]);
		}
		my @init_states_r2 = ();
		for(my $k=0; $k < scalar @init_states_r; $k++)
		{
		    @init_states_r2[$k]=sprintf("%x",$init_states_r[$k]);
		}

		$inv_l=join('',reverse(@init_states_l2));
		$inv_r=join('',reverse(@init_states_r2));
		#remove first 0
		$inv_r =~ s/^0+//g;
		$inv_l =~ s/^0+//g;
		$results[$cpt]=$inv_r.",".$inv_l;
		$cpt++;	       	    		
	    }      
	    elsif(substr($ss_in,$i,1) eq ',')
	    {
		$num=-1;
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}		
	    }   
	    elsif(substr($ss_in,$i,1) eq '*')
	    {
		if($side eq "R")
		{
		    $side = "L";
		}
		else
		{
		    $side = "R";
		}
	    }      
	    elsif($side eq "R" && $mult==-1 && $init_states_r[0]==1)
	    {	    
		if(uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    push(@init_states_r,"0");
		    $init_states_r[hex(substr($ss_in,$i,1))/2]++;
		    @init_states_r=@init_states_r[1..scalar @init_states_r];
		    $inv_r=join('',reverse(@init_states_r));
		}
		else
		{
		    push(@init_states_l,"0");
		    $init_states_l[hex(substr($ss_in,$i,1))/2+$num]++;
		    @init_states_r=@init_states_r[1..scalar @init_states_r];
		    $inv_r=join('',reverse(@init_states_r));
		    $inv_l=join('',reverse(@init_states_l));
		    $i++;
		}
	    }
	    elsif($side eq "R" && $mult==1)
	    {	    
		while(substr($ss_in,$i,1) ne ']' && $i<$ss_len)
		{
		    if(uc(substr($ss_in,$i+1,1)) ne "X")
		    {
			$init_states_r[hex(substr($ss_in,$i,1))/2]++;
			$i++;
		    }
		    else
		    {
			$init_states_l[hex(substr($ss_in,$i,1))/2+$num]++;
			$i+=2;
		    }		    
		}
		$mult=-1;
		push(@init_states_r,"0");
		@init_states_r=@init_states_r[1..scalar @init_states_r];
		$inv_r=join('',reverse(@init_states_r));
		$inv_l=join('',reverse(@init_states_l));
	    }	    
	    elsif($side eq "R")
	    {	    
		push(@init_states_r,"0");
		@init_states_r=@init_states_r[1..scalar @init_states_r];
		$inv_r=join('',reverse(@init_states_r));
		if(uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $i++;
		}

	    }
	    elsif($side eq "L" && $mult==-1 && $init_states_l[0]==1)
	    {	    	
		if(uc(substr($ss_in,$i+1,1)) ne "X")
		{
		    push(@init_states_l,"0");
		    $init_states_l[hex(substr($ss_in,$i,1))/2]++;
		    @init_states_l=@init_states_l[1..scalar @init_states_l];
		    $inv_l=join('',reverse(@init_states_l));		 
		}
		else
		{
		    push(@init_states_l,"0");
		    $init_states_r[hex(substr($ss_in,$i,1))/2+$num]++;
		    @init_states_l=@init_states_l[1..scalar @init_states_l];
		    $inv_l=join('',reverse(@init_states_l));
		    $inv_r=join('',reverse(@init_states_r));
		    $i++;
		}
	    }	
	    elsif($side eq "L" && $mult==1)
	    {			
		while(substr($ss_in,$i,1) ne ']' && $i<$ss_len)
		{
		    if(uc(substr($ss_in,$i+1,1)) ne "X")
		    {
			$init_states_l[hex(substr($ss_in,$i,1))/2]++;
			$i++;
		    }
		    else
		    {
			$init_states_r[hex(substr($ss_in,$i,1))/2+$num]++;
			$i+=2;
		    }
		}
		$mult=-1;
		push(@init_states_l,"0");
		@init_states_l=@init_states_l[1..scalar @init_states_l];
		$inv_l=join('',reverse(@init_states_l));
		$inv_r=join('',reverse(@init_states_r));		
	    }
	    
	    elsif($side eq "L")
	    {	    
		push(@init_states_l,"0");
		@init_states_l=@init_states_l[1..scalar @init_states_l];
		$inv_l=join('',reverse(@init_states_l));
		if(uc(substr($ss_in,$i+1,1)) eq "X")
		{
		    $i++;
		}
	    }
	}
    }

    elsif ($mod eq "MULTI") {
	# TO DO : handle Siteswap with ! and *! or *! for Async at the end : Currently not recommended !
	$ss=&LADDER::toMultiSync($ss,2,-1);
	$ss_in = '';
	for(my $i=0;$i<$MAX_MULT;$i++)
	{
	    $ss_in = $ss_in.$ss;
	}

	my $ss_in_len = length($ss_in);
	my $ss_len = length($ss);
	my $period_ss_in = &getPeriod($ss_in,-1);
	my $cur = "R";
	my $beat = 0;

	# Get initial/final state
	my @init_states_r = ();
	my @init_states_l = ();

	for (my $i=0; $i<$MAX_MULT; $i++)
	{
	    $init_states_r[$i]=0;
	    $init_states_l[$i]=0;
	}

	for (my $i=0; $i<$ss_in_len; $i++)
	{
	    my $v = substr($ss_in,$i,1);	   
	    if($v eq "*")
	    {
		if($cur eq "R")
		{		    
		    $cur = "L";
		}
		else
		{
		    $cur = "R";
		}		    		
	    }
	    elsif($v eq "!")
	    {
		# Nothing to do
		$beat --;
	    }
	    else
	    {
		$v = hex($v);
		if($cur eq "R")
		{
		    if($v ne "0")
		    {			
			if(($v % 2 == 0 && uc(substr($ss_in,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($ss_in,$i+1,1)) eq "X"))
			{
			    if($v + $beat >= $period_ss_in)
			    {
				my $vin = $v + $beat - $period_ss_in;
				$init_states_r[$vin]++;
			    }
			}
			elsif(($v % 2 != 0 && uc(substr($ss_in,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($ss_in,$i+1,1)) eq "X"))
			{
			    if($v + $beat >= $period_ss_in)
			    {
				my $vin = $v + $beat - $period_ss_in;
				$init_states_l[$vin]++;
			    }
			}
			if(uc(substr($ss_in,$i+1,1)) eq "X")
			{
			    $i++;
			}
		    }
		    $cur = "L";
		}
		else
		{
		    if($v ne "0")
		    {
			if(($v % 2 == 0 && uc(substr($ss_in,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($ss_in,$i+1,1)) eq "X"))		       
			{
			    if($v + $beat >= $period_ss_in)
			    {
				my $vin = $v + $beat - $period_ss_in;
				$init_states_l[$vin]++;
			    }
			}
			elsif(($v % 2 != 0 && uc(substr($ss_in,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($ss_in,$i+1,1)) eq "X"))			  
			{
			    if($v + $beat >= $period_ss_in)
			    {
				my $vin = $v + $beat - $period_ss_in;
				$init_states_r[$vin]++;
			    }
			}
			if(uc(substr($ss_in,$i+1,1)) eq "X")
			{
			    $i++;
			}
		    }
		    $cur = "R";
		}
		
		$beat ++;
	    }
	}

	my @init_states_l2 = ();
	for(my $k=0; $k < scalar @init_states_l; $k++)
	{
	    @init_states_l2[$k]=sprintf("%x",$init_states_l[$k]);
	}
	my @init_states_r2 = ();
	for(my $k=0; $k < scalar @init_states_r; $k++)
	{
	    @init_states_r2[$k]=sprintf("%x",$init_states_r[$k]);
	}
	my $inv_l=join('',reverse(@init_states_l2));
	my $inv_r=join('',reverse(@init_states_r2));
	#remove first 0
	$inv_r =~ s/^0+//g;
	$inv_l =~ s/^0+//g;
	if(substr($ss,length($ss)-1,1) eq "*" && $cur eq "L")
	{	    
	    my $tmp = $inv_l;
	    $inv_l = $inv_r;
	    $inv_r = $tmp;
	    my @tmpv = @init_states_l;
	    @init_states_l=@init_states_r;
	    @init_states_r=@tmpv;
	}

	$results[0]=$inv_r."|".$inv_l;
	
	# Get others states		
	my $cpt = 1;
	my ($beat,  $src_left_tmp, $src_right_tmp, $queue_hand) = &LADDER::__build_lists($ss, 2, 1);
	my @src_left = @{$src_left_tmp};
	my @src_right = @{$src_right_tmp};

	for (my $i = 0; $i < $beat; $i++)
	{
	    for (my $j = 0; $j < length($src_right[$i]); $j++)
	    {
		my $v = hex(substr($src_right[$i],$j,1));
		if($v ne "0")
		{			
		    if(($v % 2 == 0 && uc(substr($src_right[$i],$j+1,1)) ne "X") 
		       || ($v % 2 != 0 && uc(substr($src_right[$i],$j+1,1)) eq "X"))
		    {
			$init_states_r[hex($v) + $i]++;			
		    }
		    elsif(($v % 2 != 0 && uc(substr($src_right[$i],$j+1,1)) ne "X") 
			  || ($v % 2 == 0 && uc(substr($src_right[$i],$j+1,1)) eq "X"))
		    {
			$init_states_l[hex($v) + $i]++;
		    }
		    if(uc(substr($src_right[$i],$j+1,1)) eq "X")
		    {
			$j++;
		    }
		}
		else
		{			    
		    if(uc(substr($src_right[$i],$j+1,1)) eq "X")
		    {
			$j++;
		    }
		}		
	    }	

	    for (my $j = 0; $j < length($src_left[$i]); $j++)
	    {
		my $v = hex(substr($src_left[$i],$j,1));
		if($v ne "0")
		{			
		    if(($v % 2 == 0 && uc(substr($src_left[$i],$j+1,1)) ne "X") 
		       || ($v % 2 != 0 && uc(substr($src_left[$i],$j+1,1)) eq "X"))
		    {
			$init_states_l[hex($v) + $i]++;			
		    }
		    elsif(($v % 2 != 0 && uc(substr($src_left[$i],$j+1,1)) ne "X") 
			  || ($v % 2 == 0 && uc(substr($src_left[$i],$j+1,1)) eq "X"))
		    {
			$init_states_r[hex($v) + $i]++;
		    }
		    if(uc(substr($src_left[$i],$j+1,1)) eq "X")
		    {
			$j++;
		    }
		}
		else
		{			    
		    if(uc(substr($src_left[$i],$j+1,1)) eq "X")
		    {
			$j++;
		    }
		}		
	    }
	    
	    my @init_states_l2 = ();
	    for(my $k=0; $k < scalar @init_states_l; $k++)
	    {
		@init_states_l2[$k]=sprintf("%x",$init_states_l[$k]);
	    }
	    my @init_states_r2 = ();
	    for(my $k=0; $k < scalar @init_states_r; $k++)
	    {
		@init_states_r2[$k]=sprintf("%x",$init_states_r[$k]);
	    }
	    
	    $inv_r=reverse(substr(join('',@init_states_r2), $i +1, $height_max));
	    $inv_l=reverse(substr(join('',@init_states_l2), $i +1, $height_max));
	    $results[$cpt]=$inv_r."|".$inv_l;		
	    $cpt++;
	}
	
	# Add the eventual queue  
	if(substr($ss,length($ss)-1,1) eq "*")
	{
	    $results[$cpt]=$inv_l."|".$inv_r;		
	    $cpt++;
	}
	
    }    

    else
    {
	if(scalar @_ == 1 || $_[1] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GETSTATES_ERR2."\n";
	}
	return @results;
    }

    
    # Normalize to have : states length == max height
    my @results_last = ();
    foreach my $el (@results) {	
	my $sep="";    
	if(index($el,'|') != -1)
	{
	    $sep = '|';
	}
	elsif(index($el,',') != -1)
	{
	    $sep = ',';
	}
	my @st=();
	if($sep eq ",")
	{
	    @st=split(/,/,$el);
	}
	elsif($sep eq "|")
	{
	    @st=split(/\|/,$el);
	}
	
	my $v='';
	if($sep ne "")
	{
	    my $v1=$st[0];
	    my $v2=$st[1];
	    $v1 = "0" x ($height_max - length($st[0]));
	    $v1 = $v1.$st[0];
	    $v2 = "0" x ($height_max - length($st[1]));
	    $v2 = $v2.$st[1];
	    $v=$v1.$sep.$v2;	    
	}
	else
	{
	    $v = "0" x ($height_max - length($el));
	    $v = $v.$el;
	}
	push(@results_last,$v);
    }
    
    if (scalar @_ == 1) {
	print "==== STATES ========================\n\n";
	print colored [$common::COLOR_RESULT], "[ ".join('; ',@results_last)." ]"."\n\n";
	print "====================================\n";
    }
    
    if ((scalar @_ >= 2) && ($_[1] ne "-1")) {
	open(FILE,">> $conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;     
	print FILE "==== STATES ========================\n\n";
	print FILE "[ ".join('; ',@results_last)." ]"."\n\n";  
	print FILE "====================================\n";
	close FILE;
    }
    return @results_last;
}


# Retun all Anagrammes of a given Siteswap
sub __getAnagrammes_in
{
    my @in = @{$_[0]};
    my @l = @{$_[1]};
    if(scalar @in == 0)
    {
	return \@l;	    
    }

    my $v = shift @in;
    my @res = ();
    
    if (scalar @l == 0)
    {
	my @v_arr = ();
	push(@v_arr,$v); 
	push(@res,\@v_arr);
    }
    else
    {
	for (my $i=0; $i < scalar @l; $i++)
	{
	    &common::displayComputingPrompt();
	    my @l_in = @{$l[$i]};
	    for(my $j=0; $j <= scalar @l_in; $j++)
	    {
		my @l_in_tmp = @l_in;
		my @v_arr = ();
		push(@v_arr,$v);
		splice(@l_in_tmp,$j,0,@v_arr);
		push(@res,\@l_in_tmp);		     
	    }
	}
	&common::hideComputingPrompt();
    }
    
    &__getAnagrammes_in(\@in,\@res);	
}



sub getAnagrammes
{
    my $ss_in = $_[0];    
    $ss_in =~ s/\s+//g;   #Remove white
    my @ss = ();
    my @res_final = ();
    my $remove_redundancy = 'Y';
    my $symetry_keep = 'Y';
    
    if ((scalar @_ >= 2 )) {		 		      
	&GetOptionsFromString(uc($_[1]),    
			      "-R:s" => \$remove_redundancy,
			      "-K:s" => \$symetry_keep,      # Keep Symetry in Sync, Sync-Multiplex (ie when * is used at the end)	     
	    );
    }

    my $mod = &getSSType($ss_in, -1);
    if ( $mod eq 'V')
    {
	@ss = split(//,$ss_in);
	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    my @res_in=@{$res[$i]};
	    my $ss_v = join('',@res_in);
	    if((&isValid($ss_v,-1)!= -1))
	    {
		push(@res_final,$ss_v);
	    }
	}
    }

    elsif ($mod eq 'M')
    {
	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '[')
	    {
		push(@ss,substr($ss_in,$i,1));		
	    }
	    else
	    {
		$i ++;
		my $val = '';
		while(substr($ss_in,$i,1) ne ']')
		{
		    $val = $val.substr($ss_in,$i,1);
		    $i++;
		}
		if($val ne '')
		{
		    push(@ss,$val);
		}
	    }
	}

	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';

	    for(my $j = 0; $j < scalar(@res_in); $j ++)
	    {
		if(length($res_in[$j]) > 1)
		{
		    $ss_v = $ss_v.'['.$res_in[$j].']';
		}
		else
		{
		    $ss_v = $ss_v.$res_in[$j];
		}
	    }
	    if((&isValid($ss_v,-1)!= -1))
	    {
		push(@res_final,$ss_v);
	    }
	}
    }

    elsif ($mod eq 'S')
    {
	my $add_sym = -1;
	if((uc($symetry_keep) eq 'Y') && (substr($ss_in, -1) eq '*'))
	{
	    $ss_in = substr($ss_in,0,len($ss_in)-1);
	    $add_sym = 1;
	}
	else
	{
	    $ss_in = &expandSync($ss_in,-1);
	}
	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '(' && substr($ss_in,$i,1) ne ')' && substr($ss_in,$i,1) ne ',')
	    {
		if (($i+1 < length($ss_in)) && (uc(substr($ss_in,$i+1,1)) eq 'X'))
		{
		    push(@ss,substr($ss_in,$i,1).'X');
		    $i++;
		} 
		else
		{
		    push(@ss,substr($ss_in,$i,1));
		}
	    }
	}
	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';
	    for(my $j = 0; $j +1 < scalar @res_in; $j += 2)
	    {
 		$ss_v = $ss_v.'('.$res_in[$j].','.$res_in[$j+1].')';
	    }
	    
	    if($add_sym == 1)
	    {
		$ss_v = $ss_v.'*';
	    }
	    if((&isValid($ss_v,-1)!= -1))
	    {
		push(@res_final,$ss_v);
	    }
	}
    }

    elsif ($mod eq 'MS' || $mod eq 'SM')
    {	
	my $add_sym = -1;
	if((uc($symetry_keep) eq 'Y') && (substr($ss_in, -1) eq '*'))
	{
	    $ss_in = substr($ss_in,0,length($ss_in)-1);
	    $add_sym = 1;
	}
	else
	{
	    $ss_in = &expandSync($ss_in,-1);
	}
	
	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '(' && substr($ss_in,$i,1) ne ')' && substr($ss_in,$i,1) ne ',')
	    {
		if (substr($ss_in,$i,1) eq '[')
		{
		    $i ++;
		    my $val = '';
		    while(substr($ss_in,$i,1) ne ']')
		    {
			if(uc(substr($ss_in,$i,1)) eq 'X')
			{
			    $val = $val.'X';
			}
			else
			{
			    $val = $val.substr($ss_in,$i,1);
			}
			$i++;
		    }
		    if($val ne '')
		    {
			push(@ss,$val);
		    }
		}
		elsif (($i+1 < length($ss_in)) && (uc(substr($ss_in,$i+1,1)) eq 'X'))
		{
		    push(@ss,substr($ss_in,$i,1).'X');
		    $i++;
		} 
		else
		{
		    push(@ss,substr($ss_in,$i,1));
		}
	    }
	}

	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';
	    for(my $j = 0; $j +1 < scalar @res_in; $j += 2)
	    {
		my $val_r = $res_in[$j];
		my $val_l = $res_in[$j+1];
		
		if (length($val_r) > 2 || (length($val_r) == 2 && uc(substr($val_r,1)) ne 'X'))
		{
		    $val_r = '['.$val_r.']';
		}
		if (length($val_l) > 2 || (length($val_l) == 2 && uc(substr($val_l,1)) ne 'X'))
		{
		    $val_l = '['.$val_l.']';
		}
		
 		$ss_v = $ss_v.'('.$val_r.','.$val_l.')';	
	    }
	    
	    if($add_sym == 1)
	    {
		$ss_v = $ss_v.'*';
	    }

	    if((&isValid($ss_v,-1) != -1))
	    {
		push(@res_final,$ss_v);
	    }
	}
    }
    elsif ($mod eq 'MULTI')
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GETANAGRAMMES_ERR1." : ".$_[0]."\n";
	}
	return \@res_final;	
    }
    
    else
    {
	if (&isValid($_[0],-1) < 0) {
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[0]."\n";
	    }
	    return \@res_final;
	}
    }

    if($remove_redundancy eq 'N')
    {
	if ((scalar @_ >=3 ) || ($_[2] ne "-1")) {
	    for (my $i=0; $i<scalar @res_final; $i++)
	    {
		print $res_final[$i]."\n";
	    }
	}
	
	return \@res_final;
    }
    
    my @res_final_redun = ();     
    for (my $i=0; $i<scalar @res_final; $i++)
    {
	my $drap = -1;
	if(&isEquivalent($_[0],$res_final[$i],'-p y',-1) == 1)
	{
	    $drap = 1;
	}
	else
	{	 
	    for (my $j=0; $j < scalar @res_final_redun; $j ++)
	    {
		if(&isEquivalent($res_final_redun[$j],$res_final[$i],'-p y',-1) == 1)
		{
		    $drap = 1;
		    last;
		}	     
	    }
	}
	if($drap == -1)
	{
	    if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 		 
		print $res_final[$i]."\n";
	    }
	    push(@res_final_redun, $res_final[$i]);
	}
    }          
}


sub isScramblable
{
    my $ss_in = $_[0];    
    $ss_in =~ s/\s+//g;   #Remove white
    my @ss = ();
    my $symetry_keep = 'Y';
    my $limit_period = 'Y';
    my $limit_period_value = 8;
    
    if ((scalar @_ >= 2 )) {		 		      
	&GetOptionsFromString(uc($_[1]),    		
			      "-K:s" => \$symetry_keep,      # Keep Symetry in Sync, Sync-Multiplex (ie when * is used at the end)
			      "-L:s" => \$limit_period,      # Limit Siteswap Period for Searching Scramblable to avoid exhausting memory/CPU
			      "-V:s" => \$limit_period_value, # Limit Siteswap Period Value     
	    );
    }

    my $mod = &getSSType($ss_in, -1);
    if ( $mod eq 'V')
    {
	my $period = &getPeriod($ss_in,-1);
	if(uc($limit_period eq 'Y') && $period > $limit_period_value)
	{
	    if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GETANAGRAMMES_ERR1.$period."[".$limit_period_value."]\n";	
	    }
	    return -2;
	}
	@ss = split(//,$ss_in);
	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    &common::displayComputingPrompt();
	    my @res_in=@{$res[$i]};
	    my $ss_v = join('',@res_in);
	    if((&isValid($ss_v,-1)== -1))
	    {
		if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 
		    print colored [$common::COLOR_RESULT], "False\n";	
		}
		return -1;
	    }
	}
	&common::hideComputingPrompt();
    }

    elsif ($mod eq 'M')
    {
	my $period = &getPeriod($ss_in,-1);
	if(uc($limit_period eq 'Y') && $period > $limit_period_value)
	{
	    if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GETANAGRAMMES_ERR1.$period."[".$limit_period_value."]\n";	
	    }
	    return -2;
	}

	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '[')
	    {
		push(@ss,substr($ss_in,$i,1));		
	    }
	    else
	    {
		$i ++;
		my $val = '';
		while(substr($ss_in,$i,1) ne ']')
		{
		    $val = $val.substr($ss_in,$i,1);
		    $i++;
		}
		if($val ne '')
		{
		    push(@ss,$val);
		}
	    }
	}

	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    &common::displayComputingPrompt();
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';

	    for(my $j = 0; $j < scalar(@res_in); $j ++)
	    {
		if(length($res_in[$j]) > 1)
		{
		    $ss_v = $ss_v.'['.$res_in[$j].']';
		}
		else
		{
		    $ss_v = $ss_v.$res_in[$j];
		}
	    }
	    if((&isValid($ss_v,-1)== -1))
	    {
		if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 
		    print colored [$common::COLOR_RESULT], "False\n";	
		}
		return -1;
	    }
	}
	&common::hideComputingPrompt();
    }

    elsif ($mod eq 'S')
    {
	my $period = &getPeriod($ss_in,-1);
	if(uc($limit_period) eq 'Y' && ((uc($symetry_keep) eq 'Y' && $period > $limit_period_value*2 && substr($ss_in,length($ss_in)-1,1) eq '*') || $period > $limit_period_value))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISSCRAMBLABLE_ERR1.$period."[".$limit_period_value."]\n";		    
	    return -2;
	}

	my $add_sym = -1;
	if((uc($symetry_keep) eq 'Y') && (substr($ss_in, -1) eq '*'))
	{
	    $ss_in = substr($ss_in,0,length($ss_in)-1);
	    $add_sym = 1;
	}
	else
	{
	    $ss_in = &expandSync($ss_in,-1);
	}
	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '(' && substr($ss_in,$i,1) ne ')' && substr($ss_in,$i,1) ne ',')
	    {
		if (($i+1 < length($ss_in)) && (uc(substr($ss_in,$i+1,1)) eq 'X'))
		{
		    push(@ss,substr($ss_in,$i,1).'X');
		    $i++;
		} 
		else
		{
		    push(@ss,substr($ss_in,$i,1));
		}
	    }
	}
	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    &common::displayComputingPrompt();
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';
	    for(my $j = 0; $j +1 < scalar @res_in; $j += 2)
	    {
 		$ss_v = $ss_v.'('.$res_in[$j].','.$res_in[$j+1].')';
	    }
	    
	    if($add_sym == 1)
	    {
		$ss_v = $ss_v.'*';
	    }
	    if((&isValid($ss_v,-1)== -1))
	    {
		if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 
		    print colored [$common::COLOR_RESULT], "False\n";	
		}
		return -1;
	    }
	}
	&common::hideComputingPrompt();
    }

    elsif ($mod eq 'MS' || $mod eq 'SM')
    {
	my $period = &getPeriod($ss_in,-1);
	if(uc($limit_period) eq 'Y' && ((uc($symetry_keep) eq 'Y' && $period > $limit_period_value*2 && substr($ss_in,length($ss_in)-1,1) eq '*') || $period > $limit_period_value))
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISSCRAMBLABLE_ERR1.$period."[".$limit_period_value."]\n";	
	    return -2;
	}

	my $add_sym = -1;
	if((uc($symetry_keep) eq 'Y') && (substr($ss_in, -1) eq '*'))
	{
	    $ss_in = substr($ss_in,0,length($ss_in)-1);
	    $add_sym = 1;
	}
	else
	{
	    $ss_in = &expandSync($ss_in,-1);
	}
	
	for(my $i=0;$i<length($ss_in);$i++)
	{
	    if(substr($ss_in,$i,1) ne '(' && substr($ss_in,$i,1) ne ')' && substr($ss_in,$i,1) ne ',')
	    {
		if (substr($ss_in,$i,1) eq '[')
		{
		    $i ++;
		    my $val = '';
		    while(substr($ss_in,$i,1) ne ']')
		    {
			if(uc(substr($ss_in,$i,1)) eq 'X')
			{
			    $val = $val.'X';
			}
			else
			{
			    $val = $val.substr($ss_in,$i,1);
			}
			$i++;
		    }
		    if($val ne '')
		    {
			push(@ss,$val);
		    }
		}
		elsif (($i+1 < length($ss_in)) && (uc(substr($ss_in,$i+1,1)) eq 'X'))
		{
		    push(@ss,substr($ss_in,$i,1).'X');
		    $i++;
		} 
		else
		{
		    push(@ss,substr($ss_in,$i,1));
		}
	    }
	}

	my @in = ();
	my @res=@{&__getAnagrammes_in(\@ss,\@in)};

	for (my $i=0; $i<scalar @res; $i++)
	{
	    &common::displayComputingPrompt();
	    my @res_in=@{$res[$i]};
	    my $ss_v = '';
	    for(my $j = 0; $j +1 < scalar @res_in; $j += 2)
	    {
		my $val_r = $res_in[$j];
		my $val_l = $res_in[$j+1];
		
		if (length($val_r) > 2 || (length($val_r) == 2 && uc(substr($val_r,1)) ne 'X'))
		{
		    $val_r = '['.$val_r.']';
		}
		if (length($val_l) > 2 || (length($val_l) == 2 && uc(substr($val_l,1)) ne 'X'))
		{
		    $val_l = '['.$val_l.']';
		}
		
 		$ss_v = $ss_v.'('.$val_r.','.$val_l.')';	
	    }	    
	    
	    if($add_sym == 1)
	    {
		$ss_v = $ss_v.'*';
	    }

	    if((&isValid($ss_v,-1) == -1))
	    {
		if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {		 
		    print colored [$common::COLOR_RESULT], "False\n";	
		}
		return -1;
	    }
	}
	&common::hideComputingPrompt();
    }
    elsif ($mod eq 'MULTI')
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GETANAGRAMMES_ERR1." : ".$_[0]."\n";
	}
	return -2;
    }
    
    else
    {
	if (&isValid($_[0],-1) < 0) {
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISVALID_ERR0." : ".$_[0]."\n";
	    }
	    return -1;
	}
    }

    if ((scalar @_ <= 2 ) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True\n";
    }

    return 1;

}


# Check if the siteswap is prime : ie it does not go twice or more through the same state
sub isPrime
{    
    my @states=&getStates($_[0],-1);
    if (scalar @states<=0)
    {
	#Msg already send during the getStates call
	#if (scalar @_ == 1 || $_[1] ne "-1") {
	#print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ISPRIME_MSG1."\n";
	#}
	return -2;
    }
    
    for(my $states_idx_b=0;$states_idx_b<scalar @states-2;$states_idx_b ++ ) {
	for(my $states_idx=$states_idx_b+1;$states_idx<scalar @states-1;$states_idx++ ) {
	    if($states[$states_idx_b] eq $states[$states_idx]) 
	    {
		if (scalar @_ == 1 || $_[1] ne "-1") {
		    print colored [$common::COLOR_RESULT], "False : [".$states[$states_idx]."]\n";
		}
		return -1;
	    }
	}
    }
    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    return 1;
}



# Check if the siteswap is reversible : ie reading from both side gives a valid siteswap
sub isReversible
{
    my $ss = $_[0];
    my $rev = '';

    if (&isValid($ss,-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }
    
    for(my $i=length($ss)-1; $i >= 0; $i --)
    {
	if(uc(substr($ss,$i,1)) eq 'X')
	{
	    $i--;
	    $rev=$rev.substr($ss,$i,1).'X';  
	}
	else
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$rev=$rev.']'  
	    }
	    elsif(substr($ss,$i,1) eq ']')
	    {
		$rev=$rev.'['  
	    }
	    elsif(substr($ss,$i,1) eq '(')
	    {
		$rev=$rev.')'  
	    }
	    elsif(substr($ss,$i,1) eq ')')
	    {
		$rev=$rev.'('  
	    }
	    else
	    {	    
		$rev=$rev.substr($ss,$i,1);
	    }
	}
    }

    if (&isValid($rev,-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False "."\n";
	}
	return -1;
    }
    

    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True "."\n";
    }
    
    return 1;
}


# Return
#   1 => All
#   2 => Even (Pair)
#   3 => Odd (Impair)
#   -1 => Invalid
sub isFullMagic
{
    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;   #Remove white
    my $mod = &getSSType($ss,-1);
    my $period = &getPeriod($ss,-1);
    # $_[0] is either all/every, odd/impair, even/pair; 
    
    my $all = new Set::Scalar();
    my $even = new Set::Scalar();
    my $odd = new Set::Scalar();
    my $check_all = 1;
    my $check_even = 1;
    my $check_odd = 1;
    
    for (my $i = 0; $i < $period; $i ++)
    {
	$all->insert($i);
	$even->insert($i*2);	
	$odd->insert($i*2+1);
    }

    my @ss_in = ();
    if($mod eq "V")
    {       
	@ss_in = split(//,$ss);
    }
    elsif($mod eq "M")
    {
	$ss =~ s/\[//g;   #Remove [
	$ss =~ s/\]//g;   #Remove ]
	@ss_in = split(//,$ss);	
    }
    elsif($mod eq "S")
    {
	$ss =~ s/\(//g;   #Remove (
	$ss =~ s/\)//g;   #Remove )
	$ss =~ s/X//g;    #Remove X
	$ss =~ s/,//g;    #Remove ,
	$ss =~ s/\*//g;    #Remove *
	@ss_in = split(//,$ss);	
    }
    elsif($mod eq "MS" || $mod eq "SM")
    {
	$ss =~ s/\(//g;   #Remove (
	$ss =~ s/\)//g;   #Remove )
	$ss =~ s/X//g;    #Remove X
	$ss =~ s/,//g;    #Remove ,
	$ss =~ s/\[//g;   #Remove [
	$ss =~ s/\]//g;   #Remove ]
	$ss =~ s/\*//g;    #Remove *
	@ss_in = split(//,$ss);	
    }
    elsif($mod eq 'MULTI')
    {
	$ss =~ s/\(//g;   #Remove (
	$ss =~ s/\)//g;   #Remove )
	$ss =~ s/X//g;    #Remove X
	$ss =~ s/,//g;    #Remove ,
	$ss =~ s/\[//g;   #Remove [
	$ss =~ s/\]//g;   #Remove ]
	$ss =~ s/\!//g;   #Remove !
	$ss =~ s/\*//g;    #Remove *
	@ss_in = split(//,$ss);	
    }
    else
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False : Invalid"."\n";
	}
	return -1;
    }
    
    for (my $i=0;$i < scalar (@ss_in); $i++)
    {
	if($check_all == 1)
	{
	    if($all->has($ss_in[$i]))
	    {
		$all->delete($ss_in[$i]);
	    }
	    else
	    {
		$check_all = -1;
	    }
	}
	if($check_odd == 1)
	{
	    if($odd->has($ss_in[$i]))
	    {
		$odd->delete($ss_in[$i]);
	    }
	    else
	    {
		$check_odd = -1;
	    }
	}
	if($check_even == 1)
	{
	    if($even->has($ss_in[$i]))
	    {
		$even->delete($ss_in[$i]);
	    }
	    else
	    {
		$check_even = -1;
	    }
	}

	if($check_even == -1 && $check_odd == -1 && $check_all == -1)
	{
	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
		print colored [$common::COLOR_RESULT], "False "."\n";
	    }
	    return -1;
	}
    }           


    if($check_all == 1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "True : ALL"."\n";
	}
	return 1;	
    }
    if($check_even == 1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "True : EVEN"."\n";
	}
	return 2;
    }
    if($check_odd == 1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "True : ODD"."\n";
	}
	return 3;
    }       
}


# Check if the siteswap is a Palindrome : ie reading from both side gives a valid siteswap and the same one
sub isPalindrome
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
    
    
    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;   #Remove white
    my $rev = '';
    my $inMult = -1;
    my $mult = '';
    
    if (&isValid($ss,-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }

    my $mode = &getSSType($ss,-1);
    if($mode eq 'M' || $mode eq 'MS' || $mode eq 'MULTI')
    {
	my $newss = '';
	for(my $i=0; $i< length ($ss); $i ++)
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$mult = '';
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
		$mult = join('',sort __hex_split_compare_single (@v));
		$newss = $newss.'['.$mult.']';
	    }
	    else
	    {
		$newss .= substr($ss,$i,1);
	    }
	}
	
	$ss = $newss;
    }

    
    for(my $i=length($ss)-1; $i >= 0; $i --)
    {
	if(substr($ss,$i,1) eq '[')
	{
	    my @v = ();
	    for(my $j=0; $j < length ($mult); $j++)
	    {
		if($j+1 < length($mult) && uc(substr($mult,$j+1,1)) eq 'X')
		{
		    push(@v,substr($mult,$j,1).'X');
		    $j++;
		}
		else
		{
		    push(@v,substr($mult,$j,1));
		}
	    }
	    $mult = join('',sort __hex_split_compare_single (@v));
	    $rev = $rev.'['.$mult.']';
	    $inMult = -1;
	}
	elsif(substr($ss,$i,1) eq ']')
	{
	    $inMult = 1;
	    $mult = '';
	}
	elsif(substr($ss,$i,1) eq '(')
	{
	    $rev=$rev.')';  
	}
	elsif(substr($ss,$i,1) eq ')')
	{
	    $rev=$rev.'('; 
	}
	else
	{
	    if($inMult == -1)
	    {
		if(uc(substr($ss,$i,1)) eq 'X')
		{
		    $i--;
		    $rev=$rev.substr($ss,$i,1).'X';  
		}
		else
		{
		    
		    $rev=$rev.substr($ss,$i,1);
		}
	    }
	    else
	    {
		$mult = substr($ss,$i,1).$mult;
	    }
	}	
    }
    
    if ($ss ne $rev) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False "."\n";
	}
	return -1;
    }
    
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True "."\n";
    }
    
    return 1;
}


# Sort number in multiplex
sub normalize
{
    my $ss = $_[0];
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
    
    if (scalar @_ == 1 || $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], $res."\n";
    }
    return $res;    
}



sub getPeriodMin
{
    my $res=&isSyntaxValid($_[0],-1); 
    if ($res < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1."\n";
	}
	return -1;
    }

    if (&isValid($_[0],-1) < 0) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR0."\n";
	}
	return -1;
    }    

    
    my $p=&getPeriod(&shrink($_[0],-1),-1);
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], $p."\n";
    }
    return $p;
    
}

sub shrink
{
    my $res = "";
    
    #    if (&isValid($_[0],-1) < 0) {
    #	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
    #	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR0."\n";
    #	}
    #    	return -1;
    #    }
    
    my $src=$_[0];
    $src =~ s/\s+//g;   
    my $drap = -1;

    for(my $bloc=1; $bloc <= length($src); $bloc ++)
    {
	if($drap == 1) {last;}
	if(length($src) % $bloc != 0)
	{
	    next;
	}
	
	my $cpt = length($src) / $bloc;
	my $min = substr($src, 0, $bloc);
	for(my $i=1; $i < $cpt ; $i++)
	{	    
	    if($min ne substr($src,$i*$bloc,$bloc))
	    {		
		last;
	    }
	    elsif(($i+1)*$bloc == length($src))
	    {
		$drap = 1;
		$res = substr($_[0], 0, $bloc);
	    }	    
	}
    }
    
    if($drap == -1)
    {
	$res = $_[0];
    }
    

    # Handle eventual last *
    my ($beat, $src_left_tmp, $src_right_tmp) = &LADDER::__build_lists($res);
    if($beat%2==0)
    {
	my @src_left = @{$src_left_tmp};
	my @src_right = @{$src_right_tmp};
	for(my $i=0; $i < $beat/2; $i++)
	{	    
	    if($src_right[$i] ne $src_left[$i+$beat/2])
	    {
 		if(($src_right[$i] eq "" || $src_right[$i] eq "0") && ($src_left[$i+$beat/2] eq "" || $src_left[$i+$beat/2] eq "0"))
		{
		    #nothing to do
		}
		else
		{
		    last;
		}
	    }
	    if($src_left[$i] ne $src_right[$i+$beat/2])
	    {
		if(($src_left[$i] eq "" || $src_left[$i] eq "0") && ($src_right[$i+$beat/2] eq "" || $src_right[$i+$beat/2] eq "0"))
		{
		    #nothing to do
		}
		else
		{
		    last;
		}
	    }

	    
	    if($i==$beat/2)
	    {
		if((($beat/2)%2 == 0 && substr($res,length($res)/2-1,1) ne "!") || (($beat/2)%2 != 0 && substr($res,length($res)/2-1,1) eq "!"))
		{
		    $res = substr($res,0,length($res)/2)."*";
		}
	    }
	}
    }

    if ((scalar @_ == 1) || ($_[1] ne "-1")) {    
	print colored [$common::COLOR_RESULT], $res."\n";
    }
    return $res;
}


sub expandSync
{
    # the Syntax is not necessary valid
    my $pattern = uc($_[0]);
    $pattern =~ s/\s+//g;
    if(&getSSType($pattern,-1) ne "S" && &getSSType($pattern,-1) ne "MS")
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $pattern."\n";
	}

	return $pattern;
    }

    # if(&getSSType($pattern,-1) eq "MULTI")
    # {
    # 	my $res = '';
    # 	if(length($pattern) >1 && substr($pattern,length($pattern)-1,1) eq '*')
    # 	{
    # 	    $res = substr($pattern,0,length($pattern)-1).substr($pattern,0,length($pattern)-1);
    # 	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
    # 		print colored [$common::COLOR_RESULT], $res."\n";
    # 	    }
    # 	    return $res;
    # 	}
    
    # 	if(length($pattern) >2 && substr($pattern,length($pattern)-2,2) eq '*!')
    # 	{
    # 	    $res = substr($pattern,0,length($pattern)-2).'!'.substr($pattern,0,length($pattern)-2).'!';
    # 	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
    # 		print colored [$common::COLOR_RESULT], $res."\n";
    # 	    }
    # 	    return $res;
    # 	}
    # }
    
    my @src=split('', $pattern);
    if ($src[scalar @src -1] ne "*") {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
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
		    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
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
			if ((scalar @_ == 1) || ($_[1] ne "-1")) {
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
			if ((scalar @_ == 1) || ($_[1] ne "-1")) {
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
        
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], join('',@src).$resf."\n";
	}
	return join('', @src).$resf;
    }
}


sub __toAsyncWithMultiplex
{
    my $ss = uc($_[0]); 

    # Operations for Synchronous SS   
    $ss =~ s/\s+//g;   
    my $ss_tmp = "";
    my $i =0; 
    while ($i < length($ss)) {
	if (substr($ss,$i,1) eq "(") {
	    $i++;	    
	    my $ss_v1='';
	    my $ss_v2='';
	    while (substr($ss,$i,1) ne "," && $i < length($ss)) {	
		$ss_v1 = $ss_v1.substr($ss,$i,1);
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }
	    $i++;
	    while (substr($ss,$i,1) ne ")" && $i < length($ss)) {		
		$ss_v2 = $ss_v2.substr($ss,$i,1);
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }
	    $i++;

	    $ss_tmp = $ss_tmp.$ss_v2."!".$ss_v1."0*";
	} else {
	    $ss_tmp = $ss_tmp.substr($ss,$i,1);
	    $i++;
	}	
    }
    
    $ss=$ss_tmp;

    # A few simplifications 
    if (substr($ss,length($ss) -2,2) eq "**") {
	$ss = substr($ss,0,length($ss) -2);
    }


    if ((scalar @_ <= 1)) {
	print colored [$common::COLOR_RESULT], $ss."\n";
    }

    if (scalar @_ == 2 && $_[1] ne "-1") {
	print colored [$common::COLOR_RESULT], $ss."\n";
    }
    
    return $ss;        
}


sub isValid
{   
    ##
    ## Called Functions :
    ##           - LADDER::toMultiSync
    ##           - &isSyntaxValid
    ##           - &shrink
    ##           - &getPeriodMin

    # Check the Syntax validity
    my $mod = &isSyntaxValid($_[0],-1);
    # Return is : 
    #    Async : 1
    #    Multiplex : 2
    #    Sync : 3
    #    Multiplex Sync : 4
    #    MultiSync : 5
    #    Error : -1

    if ((scalar @_ >= 2) && ($_[1] ne "-1") && ($_[1] ne "0")) {
	open(FILE,"> $conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;     
    }

    if ( $mod == -1) {
	if ((scalar @_ >= 2) && ($_[1] ne "-1" && $_[1] ne "0")) {
	    print FILE "==> False ".$lang::MSG_SSWAP_ISVALID_ERR1;	    
	    close FILE;
	}
	elsif ((scalar @_ == 1) || ($_[1] ne "-1")) {	    
	    print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR1;	    
	}
	return -1;
    }
    

    ## Gen the MultiSync format 
    my $pattern=&LADDER::toMultiSync($_[0],0,-1);
    # my $patternb=&LADDER::toMultiSync($_[0],2,-1);
    if ((scalar @_ >= 2) && ($_[1] ne "-1" && $_[1] ne "0")) {	    
	print FILE "Siteswap : ".lc($_[0])."\n";
	print FILE $lang::MSG_SSWAP_ISVALID_MSG4." ".lc($pattern)."\n";
        # print FILE $lang::MSG_SSWAP_ISVALID_MSG4b." ".lc($patternb)."\n";
    }
    elsif ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print "Siteswap : ".lc($_[0])."\n";
	print $lang::MSG_SSWAP_ISVALID_MSG4." ".lc($pattern)."\n";
        # print $lang::MSG_SSWAP_ISVALID_MSG4b." ".lc($patternb)."\n";
    }

    $pattern = uc($pattern);
    my @st=split('', $pattern);

    my @squeezeCountMapR = ();	## Map containing all the Squeeze counts in Right Hand     
    my @squeezeCountMapL = ();	## Map containing all the Squeeze counts in Left Hand 
    my @multiplexCountMapR = (); ## Map containing all the Multiplexes counts in Right Hand            
    my @multiplexCountMapL = (); ## Map containing all the Multiplexes counts in Left Hand
    my @catchesMapL = ();	## Map containing all the Catches values in Right Hand          
    my @catchesMapR = ();	## Map containing all the Catches times in Left Hand 
    my @throwsMapR =();		## Map containing all the Throws values in Right Hand          
    my @throwsMapL =();		## Map containing all the Throws values in Left Hand         
    my $contain_multiplex=-1;
    
    my $side="right";    
    my $sum = 0;
    my $period=0;
    my $height=0;
    my $low=15;
    my $i=0;
    my $j=0;    

    # Compute Sum, Period and highest throw in first of all
    for ($i=0; $i<scalar @st; $i++) {	
	if ($st[$i] eq "!") {
	    $period --;	   
	} elsif ($st[$i] eq "*") {
	    # Will be done later on sync when it will be at the end.
	} elsif ($st[$i] ne "X") {	    
	    if ($st[$i] eq "0" || $st[$i] eq "1" || $st[$i] eq "2" || $st[$i] eq "3" || $st[$i] eq "4" 
		|| $st[$i] eq "5" || $st[$i] eq "6" || $st[$i] eq "7" || $st[$i] eq "8" || $st[$i] eq "9") {	    
		
		# Compute the sum
		$sum += int($st[$i]);

		if ($height < $st[$i]) {
		    $height = $st[$i];
		}
		if ($low > $st[$i]) {
		    $low = $st[$i];
		}
		if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			    
	    } elsif ($st[$i] eq "A" || $st[$i] eq "B" || $st[$i] eq "C" || $st[$i] eq "D" || $st[$i] eq "E"
		     || $st[$i] eq "F") {	
		
		my $hex=ord($st[$i])-ord("A") + 10;	    
		
		#Compute the sum
		$sum += $hex;	  

		if ($height < $hex) {
		    $height = $hex;
		}
		if ($low > $hex) {
		    $low = $hex;
		}

		if ($hex+1 < scalar @st && $st[$i+1] eq "X") {		
		    $i++;
		}			
	    }

	    $period ++;
	}
    }
    
    if($period == 0)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
	    if (scalar @_ >= 2 && $_[1] ne "0")
	    {
		print FILE "==> False\n";   
		close FILE;	    		
	    }
	    else
	    {
		print colored [$common::COLOR_RESULT], "False\n";   
	    }
	}	    
	return -1;	
    }


    # Double the period/sum on Sync Siteswap when it finishes by "*"
    # We will not do it for others ones.
    if((substr($_[0],length($_[0])-1) eq "*") && ($mod == 3 || $mod == 4))
    {
	$sum = $sum * 2;
	$period = $period *2;
    };
    
    # Then compute the different Map

    # The Siteswap is repeated. The previous version was checking the ss validity according to the ss type (sync, async, multiplex ...
    # Nevertheless to be more generic I think it is easier to repeat it 
    # 
    my $repeat_ss;
    $repeat_ss = 2*((($height + $period) / $period) +2);
    my $pattern_tmp = $pattern;
    for ($i = 0; $i < $repeat_ss -1; $i++) {
	$pattern_tmp=$pattern.$pattern_tmp;
    }

    $pattern = $pattern_tmp;
    @st=split('', $pattern);
    
    my $period_curr = 0;
    for ($i=0; $i<scalar @st; $i++) {	
	if ($st[$i] eq "!") {
	    if($period_curr != 0)
		# TO DO : Keep the possibility to have !, !* or *! ... at the beginning of the multisync ? Currently Not recommended ! 
	    {
		$period_curr --;
	    }
	    next;
	} elsif ($st[$i] eq "*") {      
	    if ($side eq "left") {
		$side = "right";
	    } else {
		$side = "left";
	    }
	    next;
	} else {
	    if ($st[$i] eq "0" || $st[$i] eq "1" || $st[$i] eq "2" || $st[$i] eq "3" || $st[$i] eq "4" 
		|| $st[$i] eq "5" || $st[$i] eq "6" || $st[$i] eq "7" || $st[$i] eq "8" || $st[$i] eq "9") {	    
		
		# Add the throws to the throwsMap/squeezeCountMap. Not using modulo $period. Perhaps we Must
		if ($side eq "right") {
		    if ($st[$i] ne "0") {
			$multiplexCountMapR[$period_curr]++;
		    };

		    if ($i+1 < scalar @st && $st[$i+1] eq "X") {		
			if ($throwsMapR[$period_curr] eq "") {
			    $throwsMapR[$period_curr] = $st[$i]."X";
			} else {
			    $throwsMapR[$period_curr] = $throwsMapR[$period_curr].";".$st[$i]."X";	
			}

			if (($st[$i])%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapL[$period_curr+$st[$i]] eq "") {
				$catchesMapL[$period_curr+$st[$i]] = $st[$i]."X";
			    } else {
				$catchesMapL[$period_curr+$st[$i]] = $catchesMapL[$period_curr+$st[$i]].";".$st[$i]."X";
			    }
			} else {			
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapR[$period_curr+$st[$i]] eq "") {
				$catchesMapR[$period_curr+$st[$i]] = $st[$i]."X";
			    } else {
				$catchesMapR[$period_curr+$st[$i]] = $catchesMapR[$period_curr+$st[$i]].";".$st[$i]."X";
			    }
			}

			$i++;
		    } else {
			if ($throwsMapR[$period_curr] eq "") {
			    $throwsMapR[$period_curr] = $st[$i];
			} else {
			    $throwsMapR[$period_curr] = $throwsMapR[$period_curr].";".$st[$i];	
			}


			if (($st[$i])%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapR[$period_curr+$st[$i]] eq "") {
				$catchesMapR[$period_curr+$st[$i]] = $st[$i];
			    } else {
				$catchesMapR[$period_curr+$st[$i]] = $catchesMapR[$period_curr+$st[$i]].";".$st[$i];
			    }
			} else {			
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapL[$period_curr+$st[$i]] eq "") {
				$catchesMapL[$period_curr+$st[$i]] = $st[$i];
			    } else {
				$catchesMapL[$period_curr+$st[$i]] = $catchesMapL[$period_curr+$st[$i]].";".$st[$i];
			    }
			}		      
		    }
		} else {
		    if ($st[$i] ne "0") {
			$multiplexCountMapL[$period_curr]++;
		    }
		    
		    if ($i+1 < scalar @st && $st[$i+1] eq "X") {
			if ($throwsMapL[$period_curr] eq "") {
			    $throwsMapL[$period_curr] = $st[$i]."X";
			} else {
			    $throwsMapL[$period_curr] = $throwsMapL[$period_curr].";".$st[$i]."X";	
			}

			if (($st[$i])%2 == 0) {
			    if ($st[$i] ne "0") {				
				$squeezeCountMapR[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapR[$period_curr+$st[$i]] eq "") {
				$catchesMapR[$period_curr+$st[$i]] = $st[$i]."X";
			    } else {
				$catchesMapR[$period_curr+$st[$i]] = $catchesMapR[$period_curr+$st[$i]].";".$st[$i]."X";
			    }
			} else {			
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapL[$period_curr+$st[$i]] eq "") {
				$catchesMapL[$period_curr+$st[$i]] = $st[$i]."X";
			    } else {
				$catchesMapL[$period_curr+$st[$i]] = $catchesMapL[$period_curr+$st[$i]].";".$st[$i]."X";
			    }
			}

			$i++;
		    } else {
			if ($throwsMapL[$period_curr] eq "") {
			    $throwsMapL[$period_curr] = $st[$i];
			} else {
			    $throwsMapL[$period_curr] = $throwsMapL[$period_curr].";".$st[$i];	
			}

			if (($st[$i])%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapL[$period_curr+$st[$i]] eq "") {
				$catchesMapL[$period_curr+$st[$i]] = $st[$i];
			    } else {
				$catchesMapL[$period_curr+$st[$i]] = $catchesMapL[$period_curr+$st[$i]].";".$st[$i];
			    }
			} else {
			    if ($st[$i] ne "0") {				
				$squeezeCountMapR[$period_curr+$st[$i]] ++;
			    }
			    if ($catchesMapR[$period_curr+$st[$i]] eq "") {
				$catchesMapR[$period_curr+$st[$i]] = $st[$i];
			    } else {
				$catchesMapR[$period_curr+$st[$i]] = $catchesMapR[$period_curr+$st[$i]].";".$st[$i];
			    }

			}		      
		    }
		}
	    } elsif ($st[$i] eq "A" || $st[$i] eq "B" || $st[$i] eq "C" || $st[$i] eq "D" || $st[$i] eq "E"
		     || $st[$i] eq "F") {	

		my $hex=ord($st[$i])-ord("A") + 10;	    

		# Add the throws to the throwsMap/squeezeCountMap Not using modulo $period. Perhaps we Must
		if ($side eq "right") {
		    if ($st[$i] ne "0") {
			$multiplexCountMapR[$period_curr]++;
		    }

		    if ($i+1 < scalar @st && $st[$i+1] eq "X") {
			$throwsMapR[$period_curr] = $throwsMapR[$period_curr].$st[$i]."X";		  		  		  		    
			if ($hex%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$hex] ++;
			    }
			} else {
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$hex] ++;
			    }
			}

			$i++;

		    } else {
			$throwsMapR[$period_curr] = $throwsMapR[$period_curr].$st[$i];

			if ($hex%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$hex] ++;
			    }
			} else {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$hex] ++;
			    }
			}
		    }
		} else {
		    if ($st[$i] ne "0") {
			$multiplexCountMapL[$period_curr]++;
		    }

		    if ($i+1 < scalar @st && $st[$i+1] eq "X") {
			$throwsMapL[$period_curr] = $throwsMapL[$period_curr].$st[$i]."X";

			if ($hex%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$hex] ++;
			    }
			} else {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$hex] ++;
			    }
			}
			
			$i++;
		    } else {
			$throwsMapL[$period_curr] = $throwsMapL[$period_curr].$st[$i];

			if ($hex%2 == 0) {
			    if ($st[$i] ne "0") {
				$squeezeCountMapL[$period_curr+$hex] ++;
			    }
			} else {
			    if ($st[$i] ne "0") {
				$squeezeCountMapR[$period_curr+$hex] ++;
			    }
			}		   
		    }
		}		
	    }
	    
	    $period_curr ++;
	    
	    if ($side eq "left") {
		$side = "right";
	    } else {
		$side = "left";
	    }	    
	}      
    }

    if ((scalar @_ >= 2) && ($_[1] ne "-1" && $_[1] ne "0")) {
	print FILE "\n==== MAPS ========================\n\n";
    }
    elsif ((scalar @_ == 1) || ($_[1] ne "-1")) {    	
	print "\n==== MAPS ==========================\n\n";
    }
    
    if ((scalar @_ == 1) || $_[1] ne "-1") {    
	if (scalar @_ >= 2 && $_[1] ne "0") {	    				    
	    print FILE "\tThrows Map - Right Hand : \n\t";
	}
	else
	{
	    print "\tThrows Map - Right Hand : \n\t";
	}
	for ($i = 0; $i < scalar @throwsMapR; $i++) {
	    if ($throwsMapR[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " ".$throwsMapR[$i];
		}
		else
		{
		    print " ".$throwsMapR[$i];
		}
	    }
	}
	
	if (scalar @_ >= 2 && $_[1] ne "0") {	    			
	    print FILE "\n";
	    
	    print FILE "\tThrows Map - Left Hand : \n\t";

	}
	else
	{
	    print "\n";
	    
	    print "\tThrows Map - Left Hand : \n\t";
	}

	for ($i = 0; $i < scalar @throwsMapL; $i++) {
	    if ($throwsMapL[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " ".$throwsMapL[$i];
		}
		else
		{
		    print " ".$throwsMapL[$i];
		}
	    }
	}

	if (scalar @_ >= 2  && $_[1] ne "0") {	    			
	    print FILE "\n";

	    print FILE "\tMultiplex Count Map - Right Hand : \n\t";
	}
	else
	{
	    print "\n";

	    print "\tMultiplex Count Map - Right Hand : \n\t";
	}

	for ($i = 0; $i < scalar @multiplexCountMapR; $i++) {
	    if ($multiplexCountMapR[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " ".$multiplexCountMapR[$i];
		}
		else
		{
		    print " ".$multiplexCountMapR[$i];
		}
		if ($multiplexCountMapR[$i] > 1) {
		    $contain_multiplex=1;
		}
	    }
	}

	if (scalar @_ >= 2 && $_[1] ne "0") {	    			
	    print FILE "\n";
	    
	    print FILE "\tMultiplex Count Map - Left Hand : \n\t";
	}
	else
	{
	    print "\n";
	    
	    print "\tMultiplex Count Map - Left Hand : \n\t";
	}

	for ($i = 0; $i < scalar @multiplexCountMapL; $i++) {
	    if ($multiplexCountMapL[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {	    			
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2  && $_[1] ne "0") {	    			
		    print FILE " ".$multiplexCountMapL[$i];
		}
		else
		{
		    print " ".$multiplexCountMapL[$i];
		}
		if ($multiplexCountMapL[$i] > 1) {
		    $contain_multiplex=1;
		}
	    }
	}

	if (scalar @_ >= 2  && $_[1] ne "0") {	    			
	    print FILE "\n";
	    
	    print FILE "\tCatches Map - Right Hand : \n\t";
	}
	else
	{
	    print "\n";
	    
	    print "\tCatches Map - Right Hand : \n\t";
	}

	for ($i = 0; $i < scalar @catchesMapR; $i++) {
	    if ($catchesMapR[$i] eq "") {
		if (scalar @_ >= 2  && $_[1] ne "0") {	    			
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2  && $_[1] ne "0") {
		    print FILE " ".$catchesMapR[$i];
		}
		else
		{
		    print " ".$catchesMapR[$i];
		}
	    }
	}

	if (scalar @_ >= 2  && $_[1] ne "0") {
	    print FILE "\n";

	    print FILE "\tCatches Map - Left Hand : \n\t";
	}
	else
	{
	    print "\n";

	    print "\tCatches Map - Left Hand : \n\t";
	}

	for ($i = 0; $i < scalar @catchesMapL; $i++) {
	    if ($catchesMapL[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " ".$catchesMapL[$i];
		}
		else
		{
		    print " ".$catchesMapL[$i];
		}
	    }
	}

	if (scalar @_ >= 2 && $_[1] ne "0") {
	    print FILE "\n";

	    print FILE "\tSqueeze Count Map - Right Hand : \n\t";
	}
	else
	{
	    print "\n";

	    print "\tSqueeze Count Map - Right Hand : \n\t";
	}

	for ($i = 0; $i < scalar @squeezeCountMapR; $i++) {
	    if ($squeezeCountMapR[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " ".$squeezeCountMapR[$i];
		}
		else
		{
		    print " ".$squeezeCountMapR[$i];
		}
	    }
	}

	if (scalar @_ >= 2 && $_[1] ne "0") {
	    print FILE "\n";

	    print FILE "\tSqueeze Count Map - Left Hand : \n\t";
	}
	else
	{
	    print "\n";

	    print "\tSqueeze Count Map - Left Hand : \n\t";
	}

	for ($i = 0; $i < scalar @squeezeCountMapL; $i++) {
	    if ($squeezeCountMapL[$i] eq "") {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " -";
		}
		else
		{
		    print " -";
		}
	    } else {
		if (scalar @_ >= 2 && $_[1] ne "0") {
		    print FILE " ".$squeezeCountMapL[$i];
		}
		else
		{
		    print " ".$squeezeCountMapL[$i];
		}
	    }
	}

	if (scalar @_ >= 2 && $_[1] ne "0") {
	    print FILE "\n";
	}
	else
	{
	    print "\n";
	}

	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    if (scalar @_ >= 2 && $_[1] ne "0")
	    {
		print FILE "\n====================================\n\n";
	    }
	    else
	    {
		print "\n====================================\n\n";	    
	    }
	}

    }


    # Check that Squeezes correspond to Multiplexes and the reverse.	
    for ($i = $period + $height; $i < scalar @squeezeCountMapR - ($period + $height); $i++) {
	if ($squeezeCountMapR[$i] != $multiplexCountMapR[$i]) {
	    if ((scalar @_ == 1) || $_[1] ne "-1") {    			    
		if (scalar @_ >= 2 && $_[1] ne "0")
		{
		    print FILE $lang::MSG_SSWAP_ISVALID_MSG5a." (".$multiplexCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5b." (".$squeezeCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5c." Right ".$i."."."\n";
		    print FILE "==> False\n";   
		    close FILE;	    		

		}
		else
		{
		    print $lang::MSG_SSWAP_ISVALID_MSG5a." (".$multiplexCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5b." (".$squeezeCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5c." Right ".$i."."."\n";			    
		    print colored [$common::COLOR_RESULT], "False\n";   
		}
	    }
	    return -1;

	}
    }
    
    for ($i = $period + $height; $i < scalar @squeezeCountMapL - ($period + $height); $i++) {
	if ($squeezeCountMapL[$i] != $multiplexCountMapL[$i]) {
	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
		if (scalar @_ >= 2 && $_[1] ne "0")
		{
		    print FILE $lang::MSG_SSWAP_ISVALID_MSG5a." (".$multiplexCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5b." (".$squeezeCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5c." Left ".$i."."."\n";
		    print FILE "==> False\n";   
		    close FILE;	    		
		}
		else			    
		{
		    print $lang::MSG_SSWAP_ISVALID_MSG5a." (".$multiplexCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5b." (".$squeezeCountMapR[$i].") ".$lang::MSG_SSWAP_ISVALID_MSG5c." Left ".$i."."."\n";			    
		    print colored [$common::COLOR_RESULT], "False\n";   					
		}		
	    }
	    return -1;
	}
    }
    

    if ($contain_multiplex!=-1) {       
	# Check Simultaneous reception. Ie at least 2 receptions from 2 values different of 2        
	my $found = -1;
	for ($i = 0; $i < scalar @squeezeCountMapR; $i++) {
	    if ($squeezeCountMapR[$i] >= 2) {
		@st=split(/;/,$catchesMapR[$i]);
		my $cpt = 0;
		for ($j=0; $j<scalar @st;$j++) {
		    if ($st[$j] ne "0" && $st[$j] ne "2") {
			$cpt ++;
		    }
		    if ($cpt >=2) {
			if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
			    if (scalar @_ >= 2 && $_[1] ne "0")
			    {
				print FILE $lang::MSG_SSWAP_ISVALID_MSG1a;
			    }
			    else
			    {
				print $lang::MSG_SSWAP_ISVALID_MSG1a;
			    }
			}
			$found=0;			
			last;			    
		    }
		}
		
		if ($found==0) {
		    last;
		}
	    }
	}
	
	$found = -1;
	for ($i = 0; $i < scalar @squeezeCountMapL; $i++) {
	    if ($squeezeCountMapL[$i] >= 2) {
		@st=split(/;/,$catchesMapL[$i]);
		my $cpt = 0;
		for ($j=0; $j<scalar @st;$j++) {
		    if ($st[$j] ne "0" && $st[$j] ne "2") {
			$cpt ++;
		    }
		    if ($cpt >=2) {
			if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
			    if (scalar @_ >= 2 && $_[1] ne "0")
			    {
				print FILE $lang::MSG_SSWAP_ISVALID_MSG1b;
			    }
			    else
			    {
				print $lang::MSG_SSWAP_ISVALID_MSG1b;
			    }
			}
			$found=0;			
			last;
		    }
		}

		if ($found==0) {
		    last;
		}
	    }
	}

	
	# Check according to the multiplexes if it is a true Multiplexing only swp and if it contains 
	# at least a clustered multiplex throw. 
	$found = -1;    

	for ($i = 0; $i < scalar @multiplexCountMapR; $i++) {
	    if ($multiplexCountMapR[$i] >= 2) {	
		@st=split(/;/,$throwsMapR[$i]);

		for ($j=0; $j<scalar @st;$j++) {
		    if ($st[$j] eq "2") {
			# One Multiplex contains an held object. It is not a True Multiplexing Only Siteswap		
			$found=0;			
			last;
		    }
		}	    
		
		if ($found==0) {
		    last;
		}
	    }
	}

	if ($found == -1) {
	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
		if (scalar @_ >= 2 && $_[1] ne "0")
		{
		    print FILE $lang::MSG_SSWAP_ISVALID_MSG3;		    
		}
		else
		{
		    print $lang::MSG_SSWAP_ISVALID_MSG3;		    
		}
	    }
	} else {
	    $found = -1;
	    for ($i = 0; $i < scalar @multiplexCountMapL; $i++) {
		if ($multiplexCountMapL[$i] >= 2) {
		    @st=split(/;/,$throwsMapL[$i]);

		    for ($j=0; $j<scalar @st;$j++) {
			if ($st[$j] eq "2") {
			    # One Multiplex contains an held object. It is not a True Multiplexing Only Siteswap
			    $found=0;			
			    last;
			}
		    }	    
		    
		    if ($found==0) {
			last;
		    }
		}
	    }
	    if ($found == -1) {
		if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
		    if (scalar @_ >= 2 && $_[1] ne "0")
		    {
			print FILE $lang::MSG_SSWAP_ISVALID_MSG3;		    
		    }
		    else
		    {
			print $lang::MSG_SSWAP_ISVALID_MSG3;		    
		    }
		}
	    }
	}
	
	# check if it contains at least a clustered multiplex throw. 
	# Ie a Multiplex with at least 2 identical throws different from 2	
	
	$found = -1;    
	for ($i = 0; $i < scalar @multiplexCountMapR; $i++) {
	    if ($multiplexCountMapR[$i] >= 2) {
		@st=split(/;/,$throwsMapR[$i]);
		@st = sort @st;
		my $cpt = 1;
		for ($j=0; $j<scalar @st -1;$j++) {		
		    if ($st[$j] eq $st[$j+1] && $st[$j] ne "2") {
			$cpt ++;
		    }
		    if ($cpt >=2) {
			if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
			    if (scalar @_ >= 2 && $_[1] ne "0")
			    {
				print FILE $lang::MSG_SSWAP_ISVALID_MSG2;		    
			    }
			    else
			    {
				print $lang::MSG_SSWAP_ISVALID_MSG2;		    
			    }
			}	    
			$found=0;			
			last;
		    }
		}

		if ($found==0) {
		    last;
		}
	    }
	}

	if ($found == -1) {
	    for ($i = 0; $i < scalar @multiplexCountMapL; $i++) {
		if ($multiplexCountMapL[$i] >= 2) {
		    @st=split(/;/,$throwsMapL[$i]);
		    @st = sort @st;
		    my $cpt = 1;
		    for ($j=0; $j<scalar @st -1;$j++) {		
			if ($st[$j] eq $st[$j+1] && $st[$j] ne "2") {
			    $cpt ++;
			}
			if ($cpt >=2) {
			    if ((scalar @_ == 1) || ($_[1] ne "-1")) {    			    
				if (scalar @_ >= 2 && $_[1] ne "0")
				{
				    print FILE $lang::MSG_SSWAP_ISVALID_MSG2;		    
				}
				else
				{
				    print $lang::MSG_SSWAP_ISVALID_MSG2;		    
				}
			    }	    
			    $found=0;			
			    last;
			}
		    }

		    if ($found==0) {
			last;
		    }
		}
	    }
	}
    }

    
    # Check the Average and compute the objects number         
    if ($sum % $period ne "0") {		
	my $avg = $sum/$period;

	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    if(scalar @_ >= 2 && $_[1] ne "0")
	    {
		print FILE $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
		print FILE "False ".$lang::MSG_SSWAP_ISVALID_ERR3a.$avg.$lang::MSG_SSWAP_ISVALID_ERR3b;
		close FILE;	    		
	    }
	    else
	    {
		print $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
		print $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
		print colored [$common::COLOR_RESULT], "False ".$lang::MSG_SSWAP_ISVALID_ERR3a.$avg.$lang::MSG_SSWAP_ISVALID_ERR3b;
	    }
	}
	return -1;
    } else {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    if ($mod == 2 || $mod == 4 || $mod == 4) {
		if(scalar @_ >= 2 && $_[1] ne "0")
		{
		    if(&isSqueeze($_[0],-1) == 1)
		    {
			print FILE "Squeeze : True\n";
		    }
		    else
		    {
			print FILE "Squeeze : False\n";
		    }
		}
		else
		{
		    if(&isSqueeze($_[0],-1) == 1)
		    {
			print "Squeeze : True\n";
		    }
		    else
		    {
			print "Squeeze : False\n";
		    }
		}
	    }
	    
	    if ($mod == 3 || $mod == 4) {		
		if(scalar @_ >= 2 && $_[1] ne "0")
		{		    
		    print FILE $lang::MSG_SSWAP_GENERAL1b."\n"; 
		}
		else
		{
		    print $lang::MSG_SSWAP_GENERAL1b."\n"; 
		}
	    } elsif ($mod == 1 || $mod == 2) {
		if(scalar @_ >= 2 && $_[1] ne "0")
		{
		    print FILE $lang::MSG_SSWAP_GENERAL1."\n"; 
		}
		else
		{
		    print $lang::MSG_SSWAP_GENERAL1."\n"; 
		}
		
	    } else {
		if(scalar @_ >= 2 && $_[1] ne "0")
		{
		    print FILE $lang::MSG_SSWAP_GENERAL1c."\n"; 
		}
		else
		{
		    print $lang::MSG_SSWAP_GENERAL1c."\n"; 
		}
	    }
	    

	    if(scalar @_ >= 2 && $_[1] ne "0")
	    {
		print FILE $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$sum / $period."\n"; 	    	
		#print FILE "\n";
	    }
	    else
	    {
		print $lang::MSG_SSWAP_GENERAL5." : ".$sum."\n"; 
		print $lang::MSG_SSWAP_GENERAL6." : ".$period."\n"; 
		print $lang::MSG_SSWAP_GENERAL2." : ".$sum / $period."\n"; 	    	
		#print "\n";
	    }
	}

	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    if(scalar @_ >= 2 && $_[1] ne "0")
	    {
		if((scalar @_ == 2) || (scalar @_ >= 3 && $_[2] ne "-1"))
		{
		    print FILE "==> True\n";
		}
		close FILE;	    		
	    }
	    else
	    {	    
		if(scalar @_ < 2 || ($_[1] ne "-1" && $_[1] ne "0"))
		{
		    print colored [$common::COLOR_RESULT], "True\n";
		}
	    }
	}

	return 1;		
    }
}


sub isSqueeze
{
    my $ss = $_[0]; 
    my $mode = &getSSType($ss,-1);
    if($mode eq 'V' || $mode eq 'S')
    {
	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    elsif($mode eq 'M')
    {
	my $beat = 0;
	my $period = &getPeriod($ss,-1);
	my @squeeze = ();
	for(my $i =0; $i<$period; $i++)
	{	    
	    @{$squeeze[$i]} = ();
	}	
	for(my $i=0 ; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '[')
	    {
		$i++;
		while(substr($ss,$i,1) ne ']')
		{
		    my $catch = (hex(substr($ss,$i,1)) + $beat) % $period;
		    push @{$squeeze[$catch]}, substr($ss,$i,1);
		    $i++;
		}
	    }
	    else
	    {
		my $catch = (hex(substr($ss,$i,1)) + $beat) % $period;
		push @{$squeeze[$catch]}, substr($ss,$i,1);
	    }

	    $beat ++;
	}
	
	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print "==== Catch Map ====\n";
	}
	for(my $i=0; $i<$period; $i++)
	{
	    if(scalar @_ < 2 || $_[1] ne "-1")
	    {
		print $i.": ".join(',', @{$squeeze[$i]})."\n";
	    }
	}
	
	for(my $i=0; $i<$period; $i++)
	{
	    my $cpt = 0;
	    my @unique = uniq(@{$squeeze[$i]});
	    
	    for(my $j=0; $j < scalar @unique; $j++)
	    {
		if($unique[$j] ne '2' && $unique[$j] ne '0')
		{
		    $cpt ++;
		}		

		if($cpt > 1)
		{
		    if(scalar @_ < 2 || $_[1] ne "-1")
		    {
			print colored [$common::COLOR_RESULT], "True\n";
		    }
		    return 1;
		}
	    }
	}	

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    elsif($mode eq 'MS' || $mode eq 'SM' || $mode eq 'MULTI')
    {
	my $beat = 0;
	$ss = &expandSync($ss,-1);
	my $period = &getPeriod($ss,-1);
	my @squeeze_r = ();
	my @squeeze_l = ();
	my $hand = 'R';
	my $hurry = -1;
	my $inSync = -1;
	
	for(my $i=0; $i<$period; $i++)
	{	    
	    @{$squeeze_r[$i]} = ();
	    @{$squeeze_l[$i]} = ();
	}	
	for(my $i=0; $i < length($ss); $i++)
	{
	    if(substr($ss,$i,1) eq '(')
	    {
		$inSync = 1;
	    }
	    elsif(substr($ss,$i,1) eq ')')
	    {
		$beat += 2;
		if($hand eq 'R')
		{
		    $hand = 'L';
		}
		else{
		    $hand = 'R';
		}
		$inSync = -1;
	    }	    
	    elsif(substr($ss,$i,1) eq ',')
	    {
		if($hand eq 'R')
		{
		    $hand = 'L';
		}
		else{
		    $hand = 'R';
		}
	    }	    
	    elsif(substr($ss,$i,1) eq '*')
	    {
		$hurry = 1;
	    }	    
	    elsif(substr($ss,$i,1) eq '!')
	    {
		$beat -= 1;
	    }	    
	    elsif(substr($ss,$i,1) eq '[')
	    {
		$i++;
		while(substr($ss,$i,1) ne ']')
		{
		    my $catch = (hex(substr($ss,$i,1)) + $beat) % $period;
		    if($hand eq 'R' && $i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		    {
			if(hex(substr($ss,$i,1) % 2) == 0)
			{
			    push @{$squeeze_l[$catch]}, substr($ss,$i,2);
			}
			else
			{		
			    push @{$squeeze_r[$catch]}, substr($ss,$i,2);
			}
			$i++;
		    }
		    elsif($hand eq 'L' && $i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		    {
			if(hex(substr($ss,$i,1) % 2) == 0)
			{
			    push @{$squeeze_r[$catch]}, substr($ss,$i,2);
			}
			else
			{
			    push @{$squeeze_l[$catch]}, substr($ss,$i,2);
			}
			$i++;
		    }
		    elsif($hand eq 'R')
		    {
			if(hex(substr($ss,$i,1) % 2) == 0)
			{
			    push @{$squeeze_r[$catch]}, substr($ss,$i,1);
			}
			else
			{
			    push @{$squeeze_l[$catch]}, substr($ss,$i,1);
			}
		    }
		    elsif($hand eq 'L')
		    {
			if(hex(substr($ss,$i,1) % 2) == 0)
			{
			    push @{$squeeze_l[$catch]}, substr($ss,$i,1);
			}
			else
			{
			    push @{$squeeze_r[$catch]}, substr($ss,$i,1);
			}
		    }			

		    $i++;
		}
	    }
	    else
	    {
		my $catch = (hex(substr($ss,$i,1)) + $beat) % $period;
		if($hand eq 'R' && $i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		{
		    if(hex(substr($ss,$i,1)) % 2 == 0)
		    {
			push @{$squeeze_l[$catch]}, substr($ss,$i,2);
		    }
		    else
		    {
			push @{$squeeze_r[$catch]}, substr($ss,$i,2);
		    }
		    $i++;
		}
		elsif($hand eq 'L' && $i+1 < length($ss) && uc(substr($ss,$i+1,1)) eq 'X')
		{
		    if(hex(substr($ss,$i,1)) % 2 == 0)
		    {
			push @{$squeeze_r[$catch]}, substr($ss,$i,2);
		    }
		    else
		    {
			push @{$squeeze_l[$catch]}, substr($ss,$i,2);
		    }
		    $i++;
		}
		elsif($hand eq 'R')
		{
		    if(hex(substr($ss,$i,1)) % 2 == 0)
		    {
			push @{$squeeze_r[$catch]}, substr($ss,$i,1);
		    }
		    else
		    {
			push @{$squeeze_l[$catch]}, substr($ss,$i,1);
		    }
		}
		elsif($hand eq 'L')
		{
		    if(hex(substr($ss,$i,1)) % 2 == 0)
		    {
			push @{$squeeze_l[$catch]}, substr($ss,$i,1);
		    }
		    else
		    {
			push @{$squeeze_r[$catch]}, substr($ss,$i,1);
		    }
		}

		if($hurry == -1 && $inSync == -1)
		{
		    if($hand eq 'R')
		    {
			$hand = 'L';
		    }
		    else{
			$hand = 'R';
		    }
		}
		else
		{
		    $hurry = -1;
		}

		if($inSync == -1)
		{
		    $beat ++;
		}
	    }
	}

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print "==== Catch Map (Right) ====\n";
	}

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    for(my $i=0; $i<$period; $i++)
	    {	    
		print $i.": ".join(',', @{$squeeze_r[$i]})."\n";
	    }
	}

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print "\n==== Catch Map (Left) ====\n";
	}

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    for(my $i=0; $i<$period; $i++)
	    {
		print $i.": ".join(',', @{$squeeze_l[$i]})."\n";
	    }
	}

	for(my $i=0; $i<$period; $i++)
	{
	    my $cpt_r = 0;
	    my $cpt_l = 0;
	    my @unique_r = uniq(@{$squeeze_r[$i]});
	    my @unique_l = uniq(@{$squeeze_l[$i]});
	    for(my $j=0; $j < scalar @unique_r; $j++)
	    {
		if(uc($unique_r[$j]) ne '2' && uc($unique_r[$j]) ne '0' && uc($unique_r[$j]) ne '1X' )
		{
		    $cpt_r ++;
		}		
		
		if($cpt_r > 1)
		{
		    if(scalar @_ < 2 || $_[1] ne "-1")
		    {
			print colored [$common::COLOR_RESULT], "True\n";
		    }
		    return 1;
		}		
	    }

	    for(my $j=0; $j < scalar @unique_l; $j++)
	    {
		if(uc($unique_l[$j]) ne '2' && uc($unique_l[$j]) ne '0' && uc($unique_l[$j]) ne '1X' )
		{
		    $cpt_l ++;
		}		
		
		if($cpt_l > 1)
		{
		    if(scalar @_ < 2 || $_[1] ne "-1")
		    {
			print colored [$common::COLOR_RESULT], "True\n";
		    }
		    return 1;
		}		
	    }
	}	

	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    else
    {
	if(scalar @_ < 2 || $_[1] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -2;
    }	
}


sub getInfo
{
    ##
    ## Called Functions :
    ##           - LADDER::toMultiSync
    ##           - &isSyntaxValid
    ##           - &shrink
    ##           - &getPeriodMin
    ##           ...
    
    # Check the validity
    my $res = '';
    if(scalar @_ >= 2)
    {
	$res=&isValid($_[0],$_[1],-1);
    }
    else
    {
	$res=&isValid($_[0],0,-1);
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::getInfo :\n";
    }

    if(scalar @_ >= 2 && ($_[1] ne "-1"))
    {
	open(FILE,">> $conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;    
	print FILE $lang::MSG_SSWAP_GENERAL13." : ".&shrink($_[0],-1)."    (".&getPeriodMin($_[0],-1).")\n"; 
	print FILE $lang::MSG_SSWAP_GENERAL3b." : ".&getHeightMin($_[0],-1)."\n";
	print FILE $lang::MSG_SSWAP_GENERAL3." : ".&getHeightMax($_[0],-1)."\n";
	print FILE $lang::MSG_SSWAP_GENERAL19." : ".&sym($_[0],-1)."\n"; 	    	
	print FILE $lang::MSG_SSWAP_GENERAL12." : ".&timeRev($_[0],-1)."\n"; 	    	
	print FILE "Status : ".&getSSstatus($_[0],-1)."\n";
	my $prim=&isPrime($_[0],-1);
	if($prim == 1)
	{
	    print FILE "Prime : True\n";
	}
	elsif($prim == -1)
	{
	    print FILE "Prime : False\n";
	}

	my $isreversible=&isReversible($_[0],-1);
	if($isreversible == 1)
	{
	    print FILE "Reversible : True\n";
	}
	elsif($isreversible == -1)
	{
	    print FILE "Reversible : False\n";
	}

	my $isscramblable=&isScramblable($_[0],'',-1);
	if($isscramblable == 1)
	{
	    print FILE "Scramblable : True\n";
	}
	elsif($isscramblable == -1)
	{
	    print FILE "Scramblable : False\n";
	}
	elsif($isscramblable == -1)
	{
	    print FILE "Scramblable : Unknown\n";
	}
	print FILE "\n";
	my $isscramblable=&isScramblable($_[0],'',-1);
	if($isscramblable == 1)
	{
	    print FILE "Scramblable : True\n";
	}
	elsif($isscramblable == -1)
	{
	    print FILE "Scramblable : False\n";
	}
	elsif($isscramblable == -1)
	{
	    print FILE "Scramblable : Unknown\n";
	}
	print FILE "\n";
	close FILE;	    	
	
	&getOrbits($_[0],2,$_[1]);
	&getOrbitsAggr($_[0],2,$_[1]);
	&getStates($_[0],$_[1]);
	open(FILE,">> $conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;    
	print FILE "\n";
	if($res!=-1)
	{
	    print FILE "True\n";
	}
	else
	{
	    print FILE "False\n";
	}
	close FILE;	    		
    }
    elsif(scalar @_ == 1)
    {
	print "Status : ".&getSSstatus($_[0],-1)."\n";
	print $lang::MSG_SSWAP_GENERAL13." : ".&shrink($_[0],-1)."    (".&getPeriodMin($_[0],-1).")\n"; 
	print $lang::MSG_SSWAP_GENERAL3b." : ".&getHeightMin($_[0],-1)."\n";
	print $lang::MSG_SSWAP_GENERAL3." : ".&getHeightMax($_[0],-1)."\n";
	print $lang::MSG_SSWAP_GENERAL19." : ".&sym($_[0],-1)."\n"; 	    	
	print $lang::MSG_SSWAP_GENERAL12." : ".&timeRev($_[0],-1)."\n"; 	    	
	print "Status : ".&getSSstatus($_[0],-1)."\n";
	my $prim=&isPrime($_[0],-1);
	if($prim == 1)
	{
	    print "Prime : True\n";
	}
	elsif($prim == -1)
	{
	    print "Prime : False\n";
	}

	my $isreversible=&isReversible($_[0],-1);
	if($isreversible == 1)
	{
	    print "Reversible : True\n";
	}
	elsif($isreversible == -1)
	{
	    print "Reversible : False\n";
	}

	my $isscramblable=&isScramblable($_[0],'',-1);

	print "\n";
	&getOrbits($_[0],2)."\n";
	&getOrbitsAggr($_[0],2)."\n";
	&getStates($_[0])."\n";
	print "\n";
	
	if($res==1)
	{
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	else
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
    }
    
    return $res;		
}


sub anim
{

    if(scalar @_ == 0)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat start");
	} else {
	    # Unix-like OS
	    system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab start &");
	}
    }
    else
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim \"$_[0]\"");
	} else {
	    # Unix-like OS
	    system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab anim \"$_[0]\" &");
	}
    }
}


sub animAntiSS
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c ${pwd}/data/PowerJuggler/pallette");
	return 0;
    } else {
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_ANIMATE_ANTISS_ERR0."\n";	
	return -1;
    }	
}



sub draw
{
    ##
    ## Called Functions :
    ##           - LADDER::draw
    ##           - &getSSType

    require modules::LADDER;
    my $opts = "";
    if (scalar @_ >= 3 && uc($_[2]) =~ "-M")
    {
	# Specify the format for drawing
	$opts = $_[2];
    }
    else
    {
	if (&getSSType($_[0],-1) eq "V" || &getSSType($_[0],-1) eq "M") {
	    $opts = "-h n ".$_[2]." -m 1";
	} elsif (&getSSType($_[0],-1) eq "S" || &getSSType($_[0],-1) eq "MS") {
	    $opts = $_[2]." -m 2";
	} 
	else {
	    $opts = $_[2]." -m 0";
	} 
    }

    if (!(uc($opts) =~ "-L"))
    {	
	$opts = $opts ." -l s" ;
    }
    
    if(scalar @_ >= 4)
    {
	&LADDER::draw($_[0],$_[1],$opts,$_[3]);
    }
    else
    {
	&LADDER::draw($_[0],$_[1],$opts);
    }
}



sub genTransTeodoro
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/Teodoro/Generator.html");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/Teodoro/Generator.html &");
    }
}

sub realsim
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/Teodoro/realsim/realsim.html");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/Teodoro/realsim/realsim.html &");
    }
}


sub showVanillaDiag
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/VanillaSiteswapStateDiagramGenerator/VanillaSiteswapStateDiagramGenerator.html");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/VanillaSiteswapStateDiagramGenerator/VanillaSiteswapStateDiagramGenerator.html &");
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

    my $useFileOpts=-1;
    my @result = ();
    my $height=hex($_[1]);
    my $f = '';
    my $file_opts = '';
    
    if (scalar @_ > 3) {
	if (index($_[3], "-O") >= 0) {
	    my $opt=substr($_[3],index($_[3],'-O')+2);
	    @result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat gen $_[0] $height $_[2] ${opt}`;

	    if (scalar @_ > 4) {
		$f = $_[4];
		$useFileOpts = 1;
	    }
	    if (scalar @_ > 5) {
		$file_opts = $_[5];
	    }
	} else {
	    @result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat gen $_[0] $height $_[2]`;
	    $f = $_[3];
	    $useFileOpts = 1;
	    if (scalar @_ > 4) {
		$file_opts = $_[4];
	    } 
	}
    } else {
	@result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat gen $_[0] $height $_[2]`;	
    }

    if ($f ne '')
    {
	for(my $i=0; $i < scalar @result; $i++)
	{
	    $result[$i] =~ s/\s+//g;   #Remove white
	    $result[$i] =~ s/\*//g;    #Remove *
	}
    }
    
    
    if ($useFileOpts == 1) {
	if("JML:"=~substr($f,0,4)) {	
	    my $floc = substr($f,4).".jml";    	
	    open(FILE_JML,"> $conf::RESULTS/$floc") || die ("$lang::MSG_GENERAL_ERR1 <$floc> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSS_1.(scalar @result).$lang::MSG_SSWAP_GENSS_2.$lang::MSG_SSWAP_GENSS_3.$_[0].$lang::MSG_SSWAP_GENSS_4.$_[1].$lang::MSG_SSWAP_GENSS_5.$_[2].$lang::MSG_SSWAP_GENSS_6."\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;	    
	    &printSSListWithoutHeaders(\@result,$file_opts,$f);
	}
	elsif ("SSHTML:"=~substr($f,0,7)) {	
	    my $floc = substr($f,7).".html";    
	    open(FILE,">$conf::RESULTS/$floc") || die ("$lang::MSG_GENERAL_ERR1 <$floc> $lang::MSG_GENERAL_ERR1b") ;		 
	    print FILE "<BR/>================================================================<BR/>\n";
	    print FILE $lang::MSG_SSWAP_GENSS_1.(scalar @result).$lang::MSG_SSWAP_GENSS_2.$lang::MSG_SSWAP_GENSS_3.$_[0].$lang::MSG_SSWAP_GENSS_4.$_[1].$lang::MSG_SSWAP_GENSS_5.$_[2].$lang::MSG_SSWAP_GENSS_6."<BR/>\n";		    	
	    print colored [$common::COLOR_RESULT],"[ => ".(scalar @result)." ".$lang::MSG_SSWAP_GENSS_7."]\n\n"; 
	    print FILE "================================================================\n";
	    close(FILE);		    
	    &printSSListInfoHTMLWithoutHeaders(\@result,$file_opts,$f); 
	}
	elsif ($f ne '')
	{
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE "================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENSS_1;
	    print FILE scalar @result;
	    print FILE $lang::MSG_SSWAP_GENSS_2;
	    print FILE $lang::MSG_SSWAP_GENSS_3;
	    print FILE $_[0];
	    print FILE $lang::MSG_SSWAP_GENSS_4;
	    print FILE $_[1];
	    print FILE $lang::MSG_SSWAP_GENSS_5;
	    print FILE $_[2];
	    print FILE $lang::MSG_SSWAP_GENSS_6;	
	    print FILE "================================================================\n";
	    &printSSListWithoutHeaders(\@result,$file_opts,$f);
	    #print FILE @result;
	}
	else
	{
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_1;
	    print colored [$common::COLOR_RESULT], scalar @result;
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_2;
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_3;
	    print colored [$common::COLOR_RESULT], $_[0];
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_4;
	    print colored [$common::COLOR_RESULT], $_[1];
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_5;
	    print colored [$common::COLOR_RESULT], $_[2];
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_6;
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	    &printSSListWithoutHeaders(\@result,$file_opts);
	}
    } else {
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_1;
	print colored [$common::COLOR_RESULT], scalar @result;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_2;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_3;
	print colored [$common::COLOR_RESULT], $_[0];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_4;
	print colored [$common::COLOR_RESULT], $_[1];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_5;
	print colored [$common::COLOR_RESULT], $_[2];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSS_6;
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print @result;    
    }

    if (scalar @_ > 3) {	
	close FILE;
    }		  		  
    
    return \@result;
}

sub genTrans
{
    #Using Juggling Lab
    #Copyright (C) 2002-2020 Jack Boyce and others
    #Ce programme est publiÚes sous licence GPL (GNU General Public License) v2.
    #This is the siteswap transition-finding component of Juggling Lab. It finds
    #transitions between any two siteswap patterns, as long as the number of objects
    #and jugglers are consistent.
    #Transitions are not unique. The program handles this by generating a variety of
    #options for the transition from A to B, but only a single (minimal) transition
    #from B back to A.
    #Usage:   trans <pattern A> <pattern B> [-options]
    #where options include:
    #  -m <number>    multiplexing with at most <number> simultaneous throws
    #  -mf            allow simultaneous nontrivial catches (squeeze patterns)
    #  -mc            disallow multiplex clustered throws (e.g., [33])
    #  -limits        turn off limits on runtime (warning: searches may be long!)
    #
    #Examples:
    #trans 5 771
    #trans 5 771 -m 2
    #trans 645 "(6x,4)*"
    #trans "<33|22>" "<55|00>"

    my $writeFile=-1;
    my @result = ();
    my $ss1=$_[0];
    my $ss2=$_[1];
    my $f = '';

    if (scalar @_ > 2) {
	if (index($_[2], "-O") >= 0) {
	    my $opt=substr($_[2],index($_[2],'-O')+2);
	    @result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat trans \"$_[0]\" \"$_[1]\" ${opt}`;
	    
	    if (scalar @_ > 3) {
		$writeFile = 1;
		$f = $_[3];
	    }		  		  
	} else {
	    @result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat trans \"$_[0]\" \"$_[1]\"`;
	    $writeFile = 1;
	    $f = $_[2];
	}
    } else {
	@result=`start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat trans \"$_[0]\" \"$_[1]\"`;	
    }

    pop @result;
    
    if ($writeFile == 1) {
	if("JML:"=~substr($f,0,4)) {	
	    my $floc =substr($f,4);    	
	    open(FILE_JML,"> $conf::RESULTS/$floc".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$floc.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANS_1.(scalar @result).$lang::MSG_SSWAP_GENTRANS_2.$lang::MSG_SSWAP_GENTRANS_3.$_[0].$lang::MSG_SSWAP_GENTRANS_4.$_[1].$lang::MSG_SSWAP_GENTRANS_5."\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;	    
	    &printSSListWithoutHeaders(\@result,'-V N',$f);
	}
	elsif ("SSHTML:"=~substr($f,0,7)) {	
	    my $floc = substr($f,7).".html";    
	    open(FILE,">$conf::RESULTS/$floc") || die ("$lang::MSG_GENERAL_ERR1 <$floc> $lang::MSG_GENERAL_ERR1b") ;		 
	    print FILE "<BR/>================================================================<BR/>\n";
	    print FILE $lang::MSG_SSWAP_GENTRANS_1.(scalar @result).$lang::MSG_SSWAP_GENTRANS_2.$lang::MSG_SSWAP_GENTRANS_3.$_[0].$lang::MSG_SSWAP_GENTRANS_4.$_[1].$lang::MSG_SSWAP_GENTRANS_5."<BR/>\n";		    	
	    print colored [$common::COLOR_RESULT],"[ => ".(scalar @result)." ".$lang::MSG_SSWAP_GENTRANS_6."]\n\n"; 
	    print FILE "================================================================\n";
	    close(FILE);		    
	    &printSSListInfoHTMLWithoutHeaders(\@result,'-V N',$f); 
	}
	elsif($f ne '')
	{       
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE "================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENTRANS_1;
	    print FILE scalar @result;
	    print FILE $lang::MSG_SSWAP_GENTRANS_2;
	    print FILE $lang::MSG_SSWAP_GENTRANS_3;
	    print FILE $_[0];
	    print FILE $lang::MSG_SSWAP_GENTRANS_4;
	    print FILE $_[1];
	    print FILE $lang::MSG_SSWAP_GENTRANS_5;	
	    print FILE "================================================================\n";
	    &printSSListInfoHTMLWithoutHeaders(\@result,'-V N',$f); 
	}
	else
	{
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_1;
	    print colored [$common::COLOR_RESULT], scalar @result;
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_2;
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_3;
	    print colored [$common::COLOR_RESULT], $_[0];
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_4;
	    print colored [$common::COLOR_RESULT], $_[1];
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_5;
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	    &printSSListInfoHTMLWithoutHeaders(\@result,'-V N'); 
	}
    } else {		
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_1;
	print colored [$common::COLOR_RESULT], scalar @result;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_2;
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_3;
	print colored [$common::COLOR_RESULT], $_[0];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_4;
	print colored [$common::COLOR_RESULT], $_[1];
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANS_5;
	print colored [$common::COLOR_RESULT], "================================================================\n";
	print @result;    
    }

    if (scalar @_ > 3) {	
	close FILE;
    }		  		  
    
    return \@result;
}


sub jdeep
{
    # jdeep version 5.1           by Jack Boyce
    #    (02/17/99)                  jboyce@users.sourceforge.net
    #
    # The purpose of this program is to search for long prime asynch siteswap
    # patterns.  For an explanation of these terms, consult the page:
    #     http://www.juggling.org/help/siteswap/
    #
    # Command-line format is:
    #         jdeep <# objects> <max. throw> [<min. length>] [options]
    #
    # where:
    #     <# objects>   = number of objects in the patterns found
    #     <max. throw>  = largest throw value to use
    #     <min. length> = shortest patterns to find (optional, speeds search)
    #
    # The various command-line options are:
    #     -block <skips>  find patterns in block form, allowing the specified
    #                        number of skips
    #     -super <shifts> find (nearly) superprime patterns, allowing the specified
    #                        number of shift throws
    #     -inverse        print inverse also, in -super mode
    #     -g              find ground-state patterns only
    #     -ng             find excited-state patterns only
    #     -full           print all patterns; otherwise only patterns as long
    #                        currently-longest one found are printed
    #     -noprint        suppress printing of patterns
    #     -exact          prints patterns of exact length specified (no longer)
    #     -x <throw1 throw2 ...>
    #                     exclude listed throws (speeds search)
    #     -trim           force graph trimming algorithm on
    #     -notrim         force graph trimming algorithm off
    #     -file           run in file output mode
    #     -time <secs>    run for specified time before stopping



    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"${pwd}/data/jdeep/jdeep.exe $_[0] &");
	print "\n";
    } else {
	# Unix-like OS
	system("${pwd}/data/jdeep/jdeep $_[0] &");
	print "\n";
    }
}



sub genDiagProbert
{
    my $nb_objs=$_[0];		# number of objects
    my $heightss=$_[1];		# max height for the siteswaps
    if($heightss != -1)
    {
	$heightss= hex($heightss);
    }

    my $p=$_[2];		# siteswaps period
    my $f =$_[3];		# file
    my $marge = 5;
    
    if ($nb_objs < 0 || $nb_objs > $MAX_NBOBJ || $p < 0) {
	return;
    }

    my @diagram=();
    my $marge = 5;
    my $comment = $nb_objs.",".$p;

    for (my $i=0; $i < $p ; $i++) {
	for (my $j=0; $j < $p ; $j++) {
	    if ($nb_objs-$j+$i < 0 || $nb_objs-$j+$i > $MAX_NBOBJ || ($heightss != -1 && $nb_objs-$j+$i > $heightss)) {
		$diagram[$i][$j] = "-";
	    } else {
		$diagram[$i][$j]=sprintf("%x",$nb_objs-$j+$i);
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
	    comments => 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (gen_probert_diag)",
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
	$worksheet->merge_range ('B3:L3', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$nb_objs, $format1b);	
	if ($heightss == -1) {
	    $worksheet->merge_range ('B4:L4', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h, $format1b);    
	} else {
	    $worksheet->merge_range ('B4:L4', $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$_[1], $format1b);    
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
	print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$nb_objs."\n";	
	if ($heightss == -1) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h."\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$_[1]."\n";	
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
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1b.": ".$nb_objs."\n";	
	if ($heightss == -1) {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTDIAG_MSG1h."\n";	
	} else {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$_[1]."\n";	
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
    my $nb_objs=$_[0];		# Objects Number
    my $heightss=$_[1];		# max height for the siteswaps

    if($heightss != -1)
    {
	$heightss= hex($heightss);
    }

    my $p=$_[2];		# Period

    my $title = '-- VANILLA SITESWAP (Probert) --'; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    

    
    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
				    "-B:s" => \$reversible_check,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);

    my $f=$_[4];
    
    sub genSSProbert_in
    {
	##
	## Called Functions :
	##           - &getSSstatus
	##           - &isEquivalent


	my @vect=@{$_[0]};
	my @diagram=@{$_[1]};
	my $cpt = $_[2];
	my $p = $_[3];

	my $color_check = "N";
	my $sym_check = "N";
	my $perm_check = "Y";
	my $remove_redundancy = 0; # 0 : keep redundancy; 1 : prefer ground states; 2 : keep first in the list
	my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
	
	my $ret = &GetOptionsFromString(uc($_[4]),    
					"-R:i" => \$remove_redundancy,
					"-C:s" => \$color_check,
					"-S:s" => \$sym_check,
					"-P:s" => \$perm_check,
					"-B:s" => \$reversible_check,
	    );
	my @res =();	
	for (my $i=0; $i < $_[3]; $i++) {	    
	    &common::displayComputingPrompt();
	    my @vect2=@vect;
	    if ($vect[$i]==1) {	
		$vect2[$i]=0;
		my @subss=&genSSProbert_in(\@vect2,\@diagram, $cpt+1,$p, "$_[4]");

		if (scalar @subss == 0) {		 		   		    		    
		    push(@res,$diagram[$i][$cpt]);		    		    		    
		} else {
		    for (my $j=0; $j < scalar @subss; $j++) {
			my $drap = -1;
			# Will be done again later but anyway it reduces the list ....
			if($remove_redundancy != 0) {
			    for (my $k =0; $k < scalar @res; $k++) {
				&common::displayComputingPrompt();
				my $subopts=" -c $color_check -s $sym_check -p $perm_check -b $reversible_check";
				if ($cpt==0 && (($diagram[$i][$cpt].$subss[$j]) =~ /-/ 
						|| &isEquivalent($res[$k],$diagram[$i][$cpt].$subss[$j],"$subopts",-1)==1)) {	
				    if ($SSWAP_DEBUG>=1) {
					print $lang::MSG_SSWAP_GENPROBERTSS_MSG1f.$diagram[$i][$cpt].$subss[$j]."\n";
				    }
				    
				    if($remove_redundancy == 1 
				       && (&getSSstatus($res[$k],-1) ne "GROUND") 
				       && (&getSSstatus($diagram[$i][$cpt].$subss[$j],-1) eq "GROUND"))
				    {
					$res[$k] = $diagram[$i][$cpt].$subss[$j];
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

    my @diagram=&genDiagProbert($nb_objs,$_[1],$p,-1); #$_[0] = Objects Numbers ; $_[1] = Hight Max Siteswaps; $_[2] = period

    my @vect_ch=();
    for (my $i=0; $i < $p; $i++) {
	$vect_ch[$i]=1;
    }

    my $subopts="-r $remove_redundancy -c $color_check -s $sym_check -p $perm_check -b $reversible_check";
    my @res=&genSSProbert_in(\@vect_ch,\@diagram, 0, $p, "$subopts");

    &common::hideComputingPrompt();
    my $pwd = cwd();
    $f =$_[4];    

    if ($f eq "") {
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT],"\n================================================================\n";
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\n";	    
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$nb_objs."\n";	
	if ($heightss == -1) {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\n";	
	} else {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".sprintf("%x",$heightss)."\n";	
	}
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\n";
	if ($remove_redundancy != 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\n"; 
	}
	print colored [$common::COLOR_RESULT],"\n================================================================\n\n";
	
	@res = &printSSListWithoutHeaders(\@res,$_[3]);
    }
    elsif("JML:"=~substr($f,0,4)) {	
	$f =substr($_[4],4);    
	
	open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	print FILE_JML "<?xml version=\"1.0\"?>\n";
	print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	print FILE_JML "<patternlist>\n";
	print FILE_JML "<title>".$title."</title>\n";
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\"/>\n";	   	
	print FILE_JML "<line display=\"========================================\"/>\n";	   
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$nb_objs."\"/>\n";	   	
	if ($heightss == -1) {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\"/>\n";	   
	} else {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".sprintf("%x",$heightss)."\"/>\n";	   	
	}
	print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\"/>\n";	   
	if ($remove_redundancy != 0) {
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\"/>\n";	   
	}
	print FILE_JML "<line display=\"========================================\"/>\n";	   
	print FILE_JML "<line display=\"\"/>\n";	   
	close FILE_JML;
	
	@res = &printSSListWithoutHeaders(\@res,$_[3],$_[4]);

	#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     
	
	&common::hideComputingPrompt();		
    } 
    elsif ("SSHTML:"=~substr($f,0,7)) {	
	$f =substr($_[4],7).".html";    
	open(FILE,">$conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "$title<BR/>\n";
	print FILE "<BR/>================================================================<BR/>\n";
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1a."<BR/>\n";	
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$nb_objs."<BR/>\n";	
	if ($heightss == -1) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."<BR/>\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".sprintf("%x",$heightss)."<BR/>\n";	
	}
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."<BR/>\n";
	if ($remove_redundancy != 0) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."<BR/>\n"; 
	}
	print FILE "[ =&gt; ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]<BR/>\n";     
	print colored [$common::COLOR_RESULT],"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]\n\n"; 
	print FILE "================================================================\n";
	close(FILE);		

	@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[3],$_[4]);
    }
    elsif($f ne "-1") 
    {	
	open(FILE,">>$conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "$title\n";
	print FILE "\n================================================================\n";
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1a."\n";	
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1b.": ".$nb_objs."\n";	
	if ($heightss == -1) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1h."\n";	
	} else {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1c.": ".sprintf("%x",$heightss)."\n";	
	}
	print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1d.": ".$p."\n";
	if($remove_redundancy != 0) {
	    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."\n"; 
	}
	print FILE "[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]";     
	print colored [$common::COLOR_RESULT],"[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENPROBERTSS_MSG1e."]"."\n\n"; 
	print FILE "\n================================================================\n\n";
	close FILE;
	
	@res = &printSSListWithoutHeaders(\@res,$_[3],$f);
	
	&common::hideComputingPrompt();
    }

    if (scalar @_ >= 5 && $_[4] ne "-1" && "SSHTML:"=~substr($_[4],0,7))
    {
	if ($conf::jtbOptions_r == 1)
	{
	    if ($common::OS eq "MSWin32") {
		system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	    } else {
		# Unix-like OS
		system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	    }
	}
    }


    return \@res;
}


# Retun all possible Throws Arrangement for a given period
sub __genPolyrythmOld_in
{
    my @throws = @{$_[0]};
    my @l = @{$_[1]};
    my $nbthrows = $_[2];
    
    if($nbthrows <= 0)
    {
	return \@l;	    
    }

    my @res = ();
    
    if (scalar @l == 0)
    {
	for(my $i=0; $i < scalar @throws; $i++)
	{	    
	    my @v_arr = ();
	    push(@v_arr,$throws[$i]); 
	    push(@res,\@v_arr);
	}
    }
    else
    {
	for (my $i=0; $i < scalar @l; $i++)
	{
	    &common::displayComputingPrompt();
	    my @l_in = @{$l[$i]};	    	    
	    for(my $j=0; $j < scalar @throws; $j++)
	    {
		my @l_in_tmp = @l_in;	
		push(@l_in_tmp, $throws[$j]);
		push(@res,\@l_in_tmp);
	    }
	}
	&common::hideComputingPrompt();
    }
    
    &__genPolyrythmOld_in(\@throws,\@res, $nbthrows-1);	
}


sub genPolyrythmOld
{
    my $nbObjects = $_[0];
    my $right_ratio = $_[1];
    my $left_ratio = $_[2];    
    my @exclude_throws = ('0');
    if(scalar @_ >= 4)
    {
	if($_[3] eq '')
	{
	    @exclude_throws = ();
	}
	else
	{
	    @exclude_throws = @{$_[3]};
	}
    }
    
    my $title = '-- POLYRYTHMS SITESWAPS --';
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number 
    my $ground_check = "N";     # Get only Ground States (default) or no
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $symetry_add = "N";      # Add Symetry in Sync, Sync-Multiplex (ie double the period using '*')

    
    
    my $ret = &GetOptionsFromString(uc($_[4]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
   				    "-A:s" => \$symetry_add,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);
    

    my $max_height = $MAX_HEIGHT;
    my $f = '';
    my $nb_right_throws = $right_ratio;
    my $nb_left_throws = $left_ratio;
    my $period = $right_ratio * $left_ratio;
    my $expected_sum = $period * $nbObjects;
    my $cpt = 0;    
    my @in = ();
    my @throws = ();
    my @res = ();
    my $run_browser = -1;
    my $pwd = cwd();
    
    for(my $i=0; $i <= $max_height; $i++)
    {
	if(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws)
	{
	    #next;    
	}
	else
	{	    
	    push(@throws, sprintf("%X", $i));
	}

	if(any {uc($_) eq uc(sprintf("%X",$i).'X')} @exclude_throws)
	{
	    next;    
	}
	else
	{
	    if($i != 0)
	    {
		push(@throws, sprintf("%X", $i).'X');
	    }
	}
    }
    
    my @throws_right_l=@{&__genPolyrythmOld_in(\@throws,\@in,$nb_right_throws)};
    @in = ();
    my @throws_left_l=@{&__genPolyrythmOld_in(\@throws,\@in,$nb_left_throws)};  
    for(my $i=0; $i < scalar @throws_right_l; $i++)
    {
	if(scalar @_ >= 5)
	{
	    &common::displayComputingPrompt();
	}
	for(my $j=0; $j < scalar @throws_left_l; $j++)	    
	{
	    if(scalar @_ >= 5)
	    {
		&common::displayComputingPrompt();
	    }
	    my $ss = '';
	    my $v_r = '';
	    my $v_l = '';

	    #this is a brute Force algo but we nevertheless try to cut the tree by checking the sum
	    my $sum_r = 0;
	    my $sum_l = 0;
	    for(my $k=0; $k < scalar @{$throws_right_l[$i]}; $k++)
	    {
		$sum_r += hex(substr($throws_right_l[$i][$k],0,1));
	    }
	    if($sum_r > $expected_sum)
	    {
		next;
	    }
	    for(my $k=0; $k < scalar @{$throws_left_l[$j]}; $k++)
	    {
		$sum_l += hex(substr($throws_left_l[$j][$k],0,1));
	    }
	    if($sum_r + $sum_l != $expected_sum)
	    {
		next;
	    }
	    
	    for(my $beat=0; $beat < $period; $beat++)
	    {
		if($beat%$left_ratio == 0)
		{
		    $v_r = $throws_right_l[$i][$beat/$left_ratio]; 
		}
		else
		{
		    $v_r = '0';
		}
		if($beat%$right_ratio == 0)
		{
		    $v_l = $throws_left_l[$j][$beat/$right_ratio]; 
		}
		else
		{
		    $v_l = '0';
		}

		$ss .= '('.$v_r.','.$v_l.')!';	
	    }

	    if(&isValid($ss,-1) == 1)
	    {
		$cpt ++;
		if(scalar @_ < 5)
		{
		    print lc($ss)."\n";
		}
		else
		{
		    push(@res,lc($ss));
		}
	    }
	}
    }
    
    if(scalar @_ < 5)
    {
	print colored [$common::COLOR_RESULT], "\n[ => ".$cpt." Siteswap(s) ]\n";
    }
    else
    {
	&common::hideComputingPrompt();
    }

    if (scalar @_ >= 6 && $_[5] ne "-1") {	    	    	    	    
	if ("JML:"=~substr(uc($_[5]),0,4)) {
	    $f =substr($_[5],4);

	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"$lang::MSG_SSWAP_POLYRYTHM_MSG1"." : ".$right_ratio.':'.$left_ratio."\"/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
	    }
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    @res = &printSSListWithoutHeaders((\@res,$_[4],$_[5]));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr(uc($_[5]),0,7))
	{
	    $f =substr($_[5],7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."<BR/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";     
	    }
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		

	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[4],$_[5]);				
	    
	    $run_browser=1;		
	}
	else {
	    $f =$_[5];
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print FILE "================================================================\n\n";

	    @res = &printSSListWithoutHeaders((\@res,$_[4],$_[5]));
	}
    } elsif(scalar @_ == 5) {	    
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";
	if ($nbObjects == int($nbObjects)) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	}
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	@res = &printSSListWithoutHeaders((\@res,$_[4]));	    
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return \@res;

}


sub __genPolyrythm
{
    my $max_height = $_[0];
    my $beat = $_[1];
    my $period = $_[2];
    my @map_throw_r = @{$_[3]};
    my @map_throw_l = @{$_[4]};
    my @map_catch_r = @{$_[5]};
    my @map_catch_l = @{$_[6]};
    my $sum = $_[7];
    my $res_ref = $_[8];
    my $direct_print = $_[9];
    my @exclude_throws = @{$_[10]};
    my $double_tempo_enable = $_[11];  
    my @map_throw_r_tmp = ();
    my @map_throw_l_tmp = ();
    my @map_catch_r_tmp = ();
    my @map_catch_l_tmp = ();
    my $css = 1;
    
    if($beat >= $period)
    {	
	my $ss = '';
	my $v_r = 0;
	my $v_l = 0;
	
	for(my $i=0; $i < $period; $i++)
	{
	    if($map_throw_r[$i] eq '-')
	    {
		$v_r = 0;
	    }
	    else
	    {
		$v_r = $map_throw_r[$i];
	    }
	    
	    if($map_throw_l[$i] eq '-')
	    {
		$v_l = 0;
	    }
	    else
	    {
		$v_l = $map_throw_l[$i];
	    }

	    if($double_tempo_enable == 1)
	    {
		if(hex(substr($v_r,0,1)) < 8)
		{
		    my $nv_r = sprintf("%X",hex(substr($v_r,0,1))*2);
		    if((substr($v_r,0,1) %2 == 0 && length($v_r) == 1) || (substr($v_r,0,1) %2 != 0 && length($v_r) > 1))
		    {
			# Nothing
		    }
		    else
		    {
			$nv_r .= 'X';
		    }
		    
		    if(hex(substr($v_l,0,1)) < 8)
		    {
			my $nv_l = sprintf("%X",hex(substr($v_l,0,1))*2);
			if((substr($v_l,0,1) %2 == 0 && length($v_l) == 1) || (substr($v_l,0,1) %2 != 0 && length($v_l) > 1))
			{
			    # Nothing
			}
			else
			{
			    $nv_l .= 'X';
			}
			
			$ss .= '('.$nv_r.','.$nv_l.')';					
		    }
		    else
		    {
			$css = -1;
		    }		    
		}
		else
		{
		    $css = -1;
		}
	    }
	    else
	    {
		$ss .= '('.$v_r.','.$v_l.')!';		
	    }
	}
	
	if($sum == 0 && $css == 1 && &isValid($ss,-1)==1)
	{
	    if($direct_print == 1)
	    {
		print lc($ss)."\n";
	    }
	    
	    push @{$_[8]}, lc($ss);
	}

	if($direct_print == -1)
	{
	    &common::hideComputingPrompt();
	}
	
	return $res_ref;       
    }

    if($map_throw_r[$beat] eq '?' && $map_throw_l[$beat] eq '?')
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{	    
	    for (my $j=0; $j <= $max_height; $j++)
	    {
		if($direct_print == -1)
		{
		    &common::displayComputingPrompt();
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		my $found_r = -1;
		my $found_l = -1;

		# Both go in same Hand
		if($map_catch_r_tmp[($beat+$i)%$period] eq '?')
		{		  
		    if($i %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{			    			
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i);
			    if($i != 0)
			    {
				$map_catch_r_tmp[($beat+$i)%$period] = 1;
			    }
			    $found_r = 1;
			}
			
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
			    $map_catch_r_tmp[($beat+$i)%$period] = 1;
			    $found_r = 1;
			}
		    }
		}
		
		if($found_r==1 && $map_catch_l_tmp[($beat+$j)%$period] eq '?')
		{
		    if($j %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j);
			    if($j != 0)
			    {
				$map_catch_l_tmp[($beat+$j)%$period] = 1;
			    }
			    $found_l = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j).'X';
			    $map_catch_l_tmp[($beat+$j)%$period] = 1;
			    $found_l = 1;
			}
		    }		    		
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			&__genPolyrythm($max_height, $beat+1, $period,
					\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
					$nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		    }
		}

		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# RH crosses and LH go in same Hand
		if($map_catch_l_tmp[($beat+$i)%$period] eq '?')
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i);
			    $map_catch_l_tmp[($beat+$i)%$period] = 1;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if($i != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			    {
				$map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
				$map_catch_l_tmp[($beat+$i)%$period] = 1;
				$found_r = 1;
			    }
			}
		    }
		}
		
		if($found_r==1 && $map_catch_l_tmp[($beat+$j)%$period] eq '?')
		{
		    if($j %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j);
			    if($j != 0)
			    {
				$map_catch_l_tmp[($beat+$j)%$period] = 1;
			    }
			    $found_l = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j).'X';
			    $map_catch_l_tmp[($beat+$j)%$period] = 1;
			    $found_l = 1;
			}
		    }		    		
		}
		
		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			&__genPolyrythm($max_height, $beat+1, $period,
					\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
					$nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		    }
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# RH go in same Hand and LH crosses 
		if($map_catch_r_tmp[($beat+$i)%$period] eq '?')
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
			    $map_catch_r_tmp[($beat+$i)%$period] = 1;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i);
			    if($i != 0)
			    {
				$map_catch_r_tmp[($beat+$i)%$period] = 1;
			    }
			    $found_r = 1;
			}
		    }
		}
		
		if($found_r==1 && $map_catch_r_tmp[($beat+$j)%$period] eq '?')
		{
		    if($j %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j);
			    $map_catch_r_tmp[($beat+$j)%$period] = 1;
			    $found_l = 1;
			}
		    }
		    else
		    {
			if($j != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			    {
				$map_throw_l_tmp[$beat] = sprintf("%X",$j).'X';
				$map_catch_r_tmp[($beat+$j)%$period] = 1;			   
				$found_l = 1;
			    }
			}
		    }		    		
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			&__genPolyrythm($max_height, $beat+1, $period,
					\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
					$nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		    }
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# Both crosses
		if($map_catch_l_tmp[($beat+$i)%$period] eq '?')
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i);
			    $map_catch_l_tmp[($beat+$i)%$period] = 1;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if($i != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			    {
				$map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
				$map_catch_l_tmp[($beat+$i)%$period] = 1;
				$found_r = 1;
			    }
			}
		    }
		}
		
		if($found_r==1 && $map_catch_r_tmp[($beat+$j)%$period] eq '?')
		{
		    if($j %2 != 0)		    
		    {
			
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$j);
			    $map_catch_r_tmp[($beat+$j)%$period] = 1;					    
			    $found_l = 1;
			}
		    }
		    else
		    {
			if($j != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			    {
				$map_throw_l_tmp[$beat] = sprintf("%X",$j).'X';
				$map_catch_r_tmp[($beat+$j)%$period] = 1;					    
				$found_l = 1;
			    }
			}
		    }		    		
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			&__genPolyrythm($max_height, $beat+1, $period,
					\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
					$nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		    }
		}
	    }
	}
    }

    elsif($map_throw_r[$beat] eq '?')
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{
	    if($direct_print == -1)
	    {
		&common::displayComputingPrompt();
	    }

	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;
	    my $found_r = -1;
	    
	    # RH in same Hand
	    if($map_catch_r_tmp[($beat+$i)%$period] eq '?')
	    {
		if($i %2 == 0)
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] = sprintf("%X",$i);
			if($i != 0)
			{
			    $map_catch_r_tmp[($beat+$i)%$period] = 1;
			}
			$found_r = 1;
		    }
		}
		else
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
			$map_catch_r_tmp[($beat+$i)%$period] = 1;
			$found_r = 1;
		    }
		}
	    }

	    if($found_r == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    &__genPolyrythm($max_height, $beat+1, $period,
				    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
				    $nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		}
	    }
	    
	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;	    
	    $found_r = -1;
	    
	    # RH crosses 
	    if($map_catch_l_tmp[($beat+$i)%$period] eq '?')
	    {
		if($i %2 != 0)
		{		    
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] = sprintf("%X",$i);
			$map_catch_l_tmp[($beat+$i)%$period] = 1;
			$found_r = 1;
		    }
		}
		else
		{
		    if($i != 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] = sprintf("%X",$i).'X';
			    $map_catch_l_tmp[($beat+$i)%$period] = 1;
			    $found_r = 1;
			}
		    }
		}
	    }
	    
	    if($found_r == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    &__genPolyrythm($max_height, $beat+1, $period,
				    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
				    $nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		}
	    }
	}
    }

    elsif($map_throw_l[$beat] eq '?')
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{
	    if($direct_print == -1)
	    {
		&common::displayComputingPrompt();
	    }

	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;
	    my $found_l = -1;
	    
	    # LH in same Hand
	    if($map_catch_l_tmp[($beat+$i)%$period] eq '?')
	    {
		if($i %2 == 0)
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] = sprintf("%X",$i);
			if($i != 0)
			{
			    $map_catch_l_tmp[($beat+$i)%$period] = 1;
			}      
			$found_l = 1;
		    }
		}
		else
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] = sprintf("%X",$i).'X';
			$map_catch_l_tmp[($beat+$i)%$period] = 1;
			$found_l = 1;
		    }
		}
	    }

	    if($found_l == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    &__genPolyrythm($max_height, $beat+1, $period,
				    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
				    $nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		}
	    }
	    
	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;	    
	    $found_l = -1;
	    
	    # LH crosses 
	    if($map_catch_r_tmp[($beat+$i)%$period] eq '?')
	    {
		if($i %2 != 0)
		{		    
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] = sprintf("%X",$i);
			$map_catch_r_tmp[($beat+$i)%$period] = 1;
			$found_l = 1;
		    }
		}
		else
		{
		    if($i != 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] = sprintf("%X",$i).'X';
			    $map_catch_r_tmp[($beat+$i)%$period] = 1;
			    $found_l = 1;
			}
		    }
		}
	    }

	    if($found_l == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    &__genPolyrythm($max_height, $beat+1, $period,
				    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_catch_r_tmp, \@map_catch_l_tmp,
				    $nsum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
		}
	    }
	}
    }

    else
    {
	&__genPolyrythm($max_height, $beat+1, $period,
			\@map_throw_r, \@map_throw_l, \@map_catch_r, \@map_catch_l,
			$sum, \@{$_[8]}, $direct_print, \@exclude_throws, $double_tempo_enable);
    }      
}


sub genPolyrythm
{
    my $nbObjects = $_[0];
    my $max_height = $_[1];
    my $right_ratio = $_[2];
    my $left_ratio = $_[3];
    my @exclude_throws = ('0');
    if(scalar @_ >= 5)
    {
	if($_[4] eq '')
	{
	    @exclude_throws = ();
	}
	else
	{
	    @exclude_throws = @{$_[4]};
	}
    }
    
    my $title = '-- POLYRYTHMS SITESWAPS --';
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number 
    my $ground_check = "N";     # Get only Ground States (default) or no
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $symetry_add = "N";      # Add Symetry in Sync, Sync-Multiplex (ie double the period using '*')
    my $doubleTempo = "N";      # Double Tempo for 1:N or N:1
    
    my $ret = &GetOptionsFromString(uc($_[5]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
   				    "-A:s" => \$symetry_add,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
				    "-J:s" => \$doubleTempo,
	);

    my @opts_l = split('-',uc($_[5]));
    my $opts = '';
    for(my $i = 1; $i < scalar @opts_l; $i++)
    {
	if(uc($opts_l[$i]) !~ m/J/)
	{
	    $opts .= '-'.$opts_l[$i];
	}
    }    
    
    my @map_throw_r=();
    my @map_throw_l=();
    my @map_catch_r=();
    my @map_catch_l=();
    my $beat = 0;
    my $f = '';
    my @res = ();
    my $run_browser = -1;
    my $pwd = cwd();    
    my $direct_print = -1;
    my $double_tempo_enable = -1;
    
    if (scalar @_ <= 5)
    {
	$direct_print = 1;
    }
    
    if($max_height eq '' || hex($max_height) > $MAX_HEIGHT)
    {
	$max_height = $MAX_HEIGHT;
    }
    else
    {
	$max_height=hex($max_height);
    }
    
    #if($doubleTempo eq "Y" && ($right_ratio == 1 || $left_ratio == 1))
    #{
    #	$double_tempo_enable = 1;
    #}

    if($doubleTempo eq "Y")
    {
    	$double_tempo_enable = 1;
	my @exclude_throws_tmp = ();
	for(my $i=0;$i<scalar @exclude_throws; $i++)
	{
	    if(length($exclude_throws[$i]) == 1 && hex($exclude_throws[$i]) %2 == 0)
	    {
		if(hex($exclude_throws[$i]) == 0)
		{
		    push @exclude_throws_tmp, '0';
		}
		else {
		    push @exclude_throws_tmp , sprintf("%x",int(hex($exclude_throws[$i])/2)).'X';
		}
	    }
	    elsif(length($exclude_throws[$i]) == 2 && hex(substr($exclude_throws[$i],0,1)) %2 == 0)
	    {
		push @exclude_throws_tmp , sprintf("%x",int(hex(substr($exclude_throws[$i],0,1))/2));
	    }
	}
	@exclude_throws = @exclude_throws_tmp;	    
    }

    my $nb_right_throws = $right_ratio;
    my $nb_left_throws = $left_ratio;
    my $period = $right_ratio * $left_ratio;
    my $expected_sum = $period * $nbObjects;
    
    my $r_v = '';
    my $l_v = '';
    for (my $i = 0; $i < $period; $i++)
    {
	if($i%$left_ratio == 0)
	{
	    push @map_throw_r, '?';
	}
	else
	{
	    push @map_throw_r, '-';
	}
	
	if($i%$right_ratio == 0)
	{
	    push @map_throw_l, '?';
	}
	else
	{
	    push @map_throw_l, '-';
	}	
    }

    @map_catch_r = @map_throw_r;
    @map_catch_l = @map_throw_l;

    &__genPolyrythm($max_height, $beat, $period, \@map_throw_r,\@map_throw_l, \@map_catch_r, \@map_catch_l,
		    $expected_sum, \@res, $direct_print, \@exclude_throws, $double_tempo_enable);        

    if (scalar @_ >= 7 && $_[6] ne "-1") {	    	    	    	    
	if ("JML:"=~substr(uc($_[6]),0,4)) {
	    $f =substr($_[6],4);

	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"$lang::MSG_SSWAP_POLYRYTHM_MSG1"." : ".$right_ratio.':'.$left_ratio."\"/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
	    }
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    @res = &printSSListWithoutHeaders((\@res,$opts,$_[6]));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr(uc($_[6]),0,7))
	{
	    $f =substr($_[6],7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."<BR/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";     
	    }
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		

	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$opts,$_[6]);				
	    
	    $run_browser=1;		
	}
	elsif("HTML:"=~substr(uc($_[6]),0,5))
	{
	    $f =substr($_[6],5);
	    for(my $i=0; $i < scalar @res; $i ++)
	    {
		print $res[$i]."\n";
	    }
	    @res = &printSSListHTML('-1',$f,"$title",'-V y -L y -J y',\@res);

	    $f = $f.".html";
	    $run_browser=1;		
	}
	else {
	    $f =$_[6];
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print FILE "================================================================\n\n";

	    @res = &printSSListWithoutHeaders((\@res,$opts,$_[6]));
	}
    } elsif(scalar @_ == 6) {	    
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";
	if ($nbObjects == int($nbObjects)) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	}
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	@res = &printSSListWithoutHeaders((\@res,$opts));	    
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return \@res;    
}



# Polyrythm Generation taking into account Multiplex. This is a separate function to keep speed for the one without multiplex
sub __genPolyrythmMult
{
    my $max_height = $_[0];
    my $beat = $_[1];
    my $period = $_[2];
    my @map_throw_r = @{$_[3]};
    my @map_throw_l = @{$_[4]};
    my @map_cpt_throw_r = @{$_[5]};
    my @map_cpt_throw_l = @{$_[6]};
    my @map_catch_r = @{$_[7]};
    my @map_catch_l = @{$_[8]};
    my $sum = $_[9];
    my $res_ref = $_[10];
    my $direct_print = $_[11];
    my @exclude_throws = @{$_[12]};
    my @exclude_throws_final = @{$_[13]};
    my $double_tempo_enable = $_[14];
    my $mult = $_[15];
    my @map_throw_r_tmp = ();
    my @map_throw_l_tmp = ();
    my @map_cpt_throw_r_tmp = ();
    my @map_cpt_throw_l_tmp = ();
    my @map_catch_r_tmp = ();
    my @map_catch_l_tmp = ();
    my $css = 1;
    my $gonextbeat = -1;
    
    if($beat >= $period)
    {	
	my $ss = '';
	my $nv_r = '';
	my $nv_l = '';
	
	for(my $i=0; $i < $period; $i++)
	{	
	    if($map_throw_r[$i] eq '-')
	    {
		$nv_r = 0;
	    }
	    else
	    {
		my $v_r = $map_throw_r[$i];
		$v_r =~ s/0+$//;
		$nv_r = '';
		if ($v_r =~ m/0/)
		{
		    $css = -1;
		    last;
		}
		if ($v_r eq '')
		{
		    if(any {uc($_) eq '0'} @exclude_throws_final)
		    {
			$css = -1;
			last;
		    }

		    $nv_r = 0;		    
		}
		else
		{
		    my $cpt = 0;		    
		    for(my $j=0; $j<length($v_r);$j++)
		    {
			if(uc(substr($v_r,$j,1)) ne 'X')
			{
			    $cpt++;
			    if($double_tempo_enable == 1)
			    {
				if(hex(substr($v_r,$j,1)) < 8)
				{
				    $nv_r .= sprintf("%X",hex(substr($v_r,$j,1))*2);
				    if($j < length($v_r) && uc(substr($v_r,$j+1,1)) eq 'X')
				    {
					if(hex(substr($v_r,$j,1)) % 2 == 0)
					{
					    $nv_r .= 'X';
					}
					$j++;
				    }
				    else
				    {
					if(hex(substr($v_r,$j,1)) % 2 != 0)
					{
					    $nv_r .= 'X';
					}
				    }

				}
				else
				{
				    $css = -1;
				    last;
				}
			    }
			    else
			    {
				$nv_r .= substr($v_r,$j,1);
			    }
			}
			else
			{
			    if($double_tempo_enable != 1)
			    {
				$nv_r .= 'X';
			    }
			}
		    }
		    
		    if($cpt != 1)
		    {
			$nv_r = '['.$nv_r.']';
		    }
		}
	    }
	    
	    if($map_throw_l[$i] eq '-')
	    {
		$nv_l = 0;
	    }
	    else
	    {
		my $v_l = $map_throw_l[$i];		
		$v_l =~ s/0+$//;
		$nv_l = '';
		if ($v_l =~ m/0/)
		{
		    $css = -1;
		    last;
		}
		if ($v_l eq '')
		{
		    if(any {uc($_) eq '0'} @exclude_throws_final)
		    {
			$css = -1;
			last;
		    }

		    $nv_l = 0;		    
		}
		else
		{
		    my $cpt = 0;
		    for(my $j=0; $j<length($v_l);$j++)
		    {
			if(uc(substr($v_l,$j,1)) ne 'X')
			{
			    $cpt++;
			    if($double_tempo_enable == 1)
			    {
				if(hex(substr($v_l,$j,1)) < 8)
				{
				    $nv_l .= sprintf("%X",hex(substr($v_l,$j,1))*2);
				    if($j < length($v_l) && uc(substr($v_l,$j+1,1)) eq 'X')
				    {
					if(hex(substr($v_l,$j,1)) % 2 == 0)
					{
					    $nv_l .= 'X';
					}
					$j++;
				    }
				    else
				    {
					if(hex(substr($v_l,$j,1)) % 2 != 0)
					{
					    $nv_l .= 'X';
					}
				    }
				}
				else
				{
				    $css = -1;
				    last;
				}
			    }
			    else
			    {
				$nv_l .= substr($v_l,$j,1);
			    }
			}
			else
			{
			    if($double_tempo_enable != 1)
			    {
				$nv_l .= 'X';
			    }
			}
		    }
		    
		    if($cpt != 1)
		    {
			$nv_l = '['.$nv_l.']';
		    }
		}
	    }

	    if($double_tempo_enable == 1)
	    {
		$ss .= '('.$nv_r.','.$nv_l.')';
	    }
	    else
	    {
		$ss .= '('.$nv_r.','.$nv_l.')!';
	    }
	}

	
	if($sum == 0 && $css == 1 && &isValid($ss,-1)==1)
	{
	    if($direct_print == 1)
	    {
		print lc($ss)."\n";
	    }

	    # push res_ref
	    push @{$_[10]}, lc($ss);
	}

	#else
	#{
	#    print "REJECT ".lc($ss)."\n";
	#}

	if($direct_print == -1)
	{
	    &common::hideComputingPrompt();
	}
	
	return $res_ref;       
    }

    if($map_cpt_throw_r[$beat] < $mult && $map_cpt_throw_l[$beat] < $mult)
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{	    
	    for (my $j=0; $j <= $max_height; $j++)
	    {
		if($direct_print == -1)
		{
		    &common::displayComputingPrompt();
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_cpt_throw_r_tmp = @map_cpt_throw_r;
		@map_cpt_throw_l_tmp = @map_cpt_throw_l;		
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		
		my $found_r = -1;
		my $found_l = -1;
		
		# Both go in same Hand
		if($map_catch_r_tmp[($beat+$i)%$period] < $mult)
		{		  
		    if($i %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{			    			
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			    $map_cpt_throw_r_tmp[$beat] ++;
			    if($i != 0)
			    {
				$map_catch_r_tmp[($beat+$i)%$period] ++;
			    }
			    $found_r = 1;
			}
			
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
			    $map_cpt_throw_r_tmp[$beat] ++;
			    $map_catch_r_tmp[($beat+$i)%$period] ++;
			    $found_r = 1;
			}
		    }
		}
		
		if($found_r==1 && $map_catch_l_tmp[($beat+$j)%$period] < $mult)
		{
		    if($j %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j);
			    $map_cpt_throw_l_tmp[$beat] ++;
			    if($j != 0)
			    {
				$map_catch_l_tmp[($beat+$j)%$period] ++;
			    }
			    $found_l = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j).'X';
			    $map_cpt_throw_l_tmp[$beat] ++;
			    $map_catch_l_tmp[($beat+$j)%$period] ++;
			    $found_l = 1;
			}
		    }

		    if($map_cpt_throw_l_tmp[$beat] == $mult)
		    {
			$gonextbeat = 1;
		    }
		    
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			if($gonextbeat == 1)
			{
			    &__genPolyrythmMult($max_height, $beat+1, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			    $gonextbeat = -1;
			}
			else
			{
			    &__genPolyrythmMult($max_height, $beat, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			}
		    }
		}

		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_cpt_throw_r_tmp = @map_cpt_throw_r;
		@map_cpt_throw_l_tmp = @map_cpt_throw_l;		
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# RH crosses and LH go in same Hand
		if($map_catch_l_tmp[($beat+$i)%$period] < $mult)
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			    $map_cpt_throw_r_tmp[$beat] ++;
			    $map_catch_l_tmp[($beat+$i)%$period] ++;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if($i != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			    {
				$map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
				$map_cpt_throw_r_tmp[$beat] ++;
				$map_catch_l_tmp[($beat+$i)%$period] ++;
				$found_r = 1;
			    }
			}
		    }
		}
		
		if($found_r==1 && $map_catch_l_tmp[($beat+$j)%$period] < $mult)
		{
		    if($j %2 == 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j);
			    $map_cpt_throw_l_tmp[$beat] ++;
			    if($j != 0)
			    {
				$map_catch_l_tmp[($beat+$j)%$period] ++;
			    }
			    $found_l = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j).'X';
			    $map_cpt_throw_l_tmp[$beat] ++;
			    $map_catch_l_tmp[($beat+$j)%$period] ++;
			    $found_l = 1;
			}
		    }

		    if($map_cpt_throw_l_tmp[$beat] == $mult)
		    {
			$gonextbeat = 1;
		    }
		}
		
		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			if($gonextbeat == 1)
			{
			    &__genPolyrythmMult($max_height, $beat+1, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			    $gonextbeat = -1;
			}
			else
			{
			    &__genPolyrythmMult($max_height, $beat, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			}
		    }
		    
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_cpt_throw_r_tmp = @map_cpt_throw_r;
		@map_cpt_throw_l_tmp = @map_cpt_throw_l;		
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# RH go in same Hand and LH crosses 
		if($map_catch_r_tmp[($beat+$i)%$period] < $mult)
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
			    $map_cpt_throw_r_tmp[$beat] ++;
			    $map_catch_r_tmp[($beat+$i)%$period] ++;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			    $map_cpt_throw_r_tmp[$beat] ++;
			    if($i != 0)
			    {
				$map_catch_r_tmp[($beat+$i)%$period] ++;
			    }
			    $found_r = 1;
			}
		    }
		}
		
		if($found_r==1 && $map_catch_r_tmp[($beat+$j)%$period] < $mult)
		{
		    if($j %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j);
			    $map_cpt_throw_l_tmp[$beat] ++;
			    $map_catch_r_tmp[($beat+$j)%$period] ++;
			    $found_l = 1;
			}
		    }
		    else
		    {
			if($j != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			    {
				$map_throw_l_tmp[$beat] .= sprintf("%X",$j).'X';
				$map_cpt_throw_l_tmp[$beat] ++;
				$map_catch_r_tmp[($beat+$j)%$period] ++;
				$found_l = 1;
			    }
			}
		    }

		    if($map_cpt_throw_l_tmp[$beat] == $mult)
		    {
			$gonextbeat = 1;
		    }
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			if($gonextbeat == 1)
			{
			    &__genPolyrythmMult($max_height, $beat+1, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			    $gonextbeat = -1;
			}
			else
			{
			    &__genPolyrythmMult($max_height, $beat, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			}
		    }
		}
		
		@map_throw_r_tmp = @map_throw_r;
		@map_throw_l_tmp = @map_throw_l;
		@map_cpt_throw_r_tmp = @map_cpt_throw_r;
		@map_cpt_throw_l_tmp = @map_cpt_throw_l;		
		@map_catch_r_tmp = @map_catch_r;
		@map_catch_l_tmp = @map_catch_l;
		$found_r = -1;
		$found_l = -1;
		
		# Both crosses
		if($map_catch_l_tmp[($beat+$i)%$period] <$mult)
		{
		    if($i %2 != 0)
		    {			
			if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			    $map_cpt_throw_r_tmp[$beat] ++;
			    $map_catch_l_tmp[($beat+$i)%$period] ++;
			    $found_r = 1;
			}
		    }
		    else
		    {
			if($i != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			    {
				$map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
				$map_cpt_throw_r_tmp[$beat] ++;
				$map_catch_l_tmp[($beat+$i)%$period] ++;
				$found_r = 1;
			    }
			}
		    }
		}
		
		if($found_r==1 && $map_catch_r_tmp[($beat+$j)%$period] < $mult)
		{
		    if($j %2 != 0)		    
		    {
			
			if(not(any {uc($_) eq uc(sprintf("%X",$j))} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$j);
			    $map_cpt_throw_l_tmp[$beat] ++;
			    $map_catch_r_tmp[($beat+$j)%$period] ++;
			    $found_l = 1;
			}
		    }
		    else
		    {
			if($j != 0)
			{
			    if(not(any {uc($_) eq uc(sprintf("%X",$j)).'X'} @exclude_throws))
			    {
				$map_throw_l_tmp[$beat] .= sprintf("%X",$j).'X';
				$map_cpt_throw_l_tmp[$beat] ++;
				$map_catch_r_tmp[($beat+$j)%$period] ++;
				$found_l = 1;
			    }
			}
		    }

		    if($map_cpt_throw_l_tmp[$beat] == $mult)
		    {
			$gonextbeat = 1;
		    }
		}

		if($found_l == 1)
		{
		    my $nsum = $sum -$i -$j;
		    if($nsum >=0)
		    {
			if($gonextbeat == 1)
			{
			    &__genPolyrythmMult($max_height, $beat+1, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			    $gonextbeat = -1;
			}
			else
			{
			    &__genPolyrythmMult($max_height, $beat, $period,
						\@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
						\@map_catch_r_tmp, \@map_catch_l_tmp,
						$nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			}
		    }
		}
	    }
	}
    }

    elsif($map_cpt_throw_r[$beat] < $mult)
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{
	    if($direct_print == -1)
	    {
		&common::displayComputingPrompt();
	    }

	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_cpt_throw_r_tmp = @map_cpt_throw_r;
	    @map_cpt_throw_l_tmp = @map_cpt_throw_l;		
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;
	    my $found_r = -1;
	    
	    # RH in same Hand
	    if($map_catch_r_tmp[($beat+$i)%$period] < $mult)
	    {
		if($i %2 == 0)
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			$map_cpt_throw_r_tmp[$beat] ++;
			if($i != 0)
			{
			    $map_catch_r_tmp[($beat+$i)%$period] ++;
			}
			$found_r = 1;
		    }
		}
		else
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
			$map_cpt_throw_r_tmp[$beat] ++;
			$map_catch_r_tmp[($beat+$i)%$period] ++;
			$found_r = 1;
		    }
		}

		if($map_cpt_throw_r_tmp[$beat] == $mult)
		{
		    $gonextbeat = 1;
		}		
	    }

	    if($found_r == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    if($gonextbeat == 1)
		    {
			&__genPolyrythmMult($max_height, $beat+1, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			$gonextbeat = -1;
		    }
		    else
		    {
			&__genPolyrythmMult($max_height, $beat, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
		    }
		}
	    }
	    
	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_cpt_throw_r_tmp = @map_cpt_throw_r;
	    @map_cpt_throw_l_tmp = @map_cpt_throw_l;		
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;	    
	    $found_r = -1;
	    
	    # RH crosses 
	    if($map_catch_l_tmp[($beat+$i)%$period] < $mult)
	    {
		if($i %2 != 0)
		{		    
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_r_tmp[$beat] .= sprintf("%X",$i);
			$map_cpt_throw_r_tmp[$beat] ++;
			$map_catch_l_tmp[($beat+$i)%$period] ++;
			$found_r = 1;
		    }
		}
		else
		{
		    if($i != 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_r_tmp[$beat] .= sprintf("%X",$i).'X';
			    $map_cpt_throw_r_tmp[$beat] ++;
			    $map_catch_l_tmp[($beat+$i)%$period] ++;
			    $found_r = 1;
			}
		    }
		}

		if($map_cpt_throw_r_tmp[$beat] == $mult)
		{
		    $gonextbeat = 1;
		}		
	    }
	    
	    if($found_r == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    if($gonextbeat == 1)
		    {
			&__genPolyrythmMult($max_height, $beat+1, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			$gonextbeat = -1;
		    }
		    else
		    {
			&__genPolyrythmMult($max_height, $beat, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
		    }
		    
		}
	    }
	}
    }

    elsif($map_cpt_throw_l[$beat] < $mult)
    {	
	for (my $i=0; $i <= $max_height; $i++)
	{
	    if($direct_print == -1)
	    {
		&common::displayComputingPrompt();
	    }

	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_cpt_throw_r_tmp = @map_cpt_throw_r;
	    @map_cpt_throw_l_tmp = @map_cpt_throw_l;		
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;
	    my $found_l = -1;
	    
	    # LH in same Hand
	    if($map_catch_l_tmp[($beat+$i)%$period] < $mult)
	    {
		if($i %2 == 0)
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] .= sprintf("%X",$i);
			$map_cpt_throw_l_tmp[$beat] ++;
			if($i != 0)
			{
			    $map_catch_l_tmp[($beat+$i)%$period] ++;
			}      
			$found_l = 1;
		    }
		}
		else
		{
		    if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] .= sprintf("%X",$i).'X';
			$map_cpt_throw_l_tmp[$beat] ++;
			$map_catch_l_tmp[($beat+$i)%$period] ++;
			$found_l = 1;
		    }
		}

		if($map_cpt_throw_l_tmp[$beat] == $mult)
		{
		    $gonextbeat = 1;
		}		

	    }

	    if($found_l == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    if($gonextbeat == 1)
		    {
			&__genPolyrythmMult($max_height, $beat+1, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			$gonextbeat = -1;
		    }
		    else
		    {
			&__genPolyrythmMult($max_height, $beat, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
		    }
		}
	    }
	    
	    @map_throw_r_tmp = @map_throw_r;
	    @map_throw_l_tmp = @map_throw_l;
	    @map_cpt_throw_r_tmp = @map_cpt_throw_r;
	    @map_cpt_throw_l_tmp = @map_cpt_throw_l;		
	    @map_catch_r_tmp = @map_catch_r;
	    @map_catch_l_tmp = @map_catch_l;	    
	    $found_l = -1;
	    
	    # LH crosses 
	    if($map_catch_r_tmp[($beat+$i)%$period] < $mult)
	    {
		if($i %2 != 0)
		{		    
		    if(not(any {uc($_) eq uc(sprintf("%X",$i))} @exclude_throws))
		    {
			$map_throw_l_tmp[$beat] .= sprintf("%X",$i);
			$map_cpt_throw_l_tmp[$beat] ++;
			$map_catch_r_tmp[($beat+$i)%$period] ++;
			$found_l = 1;
		    }
		}
		else
		{
		    if($i != 0)
		    {
			if(not(any {uc($_) eq uc(sprintf("%X",$i)).'X'} @exclude_throws))
			{
			    $map_throw_l_tmp[$beat] .= sprintf("%X",$i).'X';
			    $map_cpt_throw_l_tmp[$beat] ++;
			    $map_catch_r_tmp[($beat+$i)%$period] ++;
			    $found_l = 1;
			}
		    }
		}

		if($map_cpt_throw_l_tmp[$beat] == $mult)
		{
		    $gonextbeat = 1;
		}		
	    }

	    if($found_l == 1)
	    {
		my $nsum = $sum -$i;
		if($nsum >=0)
		{
		    if($gonextbeat == 1)
		    {
			&__genPolyrythmMult($max_height, $beat+1, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
			$gonextbeat = -1;
		    }
		    else
		    {
			&__genPolyrythmMult($max_height, $beat, $period,
					    \@map_throw_r_tmp, \@map_throw_l_tmp, \@map_cpt_throw_r_tmp, \@map_cpt_throw_l_tmp,
					    \@map_catch_r_tmp, \@map_catch_l_tmp,
					    $nsum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
		    }

		}
	    }
	}
    }

    else
    {
	&__genPolyrythmMult($max_height, $beat+1, $period,
			    \@map_throw_r, \@map_throw_l, \@map_cpt_throw_r, \@map_cpt_throw_l, \@map_catch_r, \@map_catch_l,
			    $sum, \@{$_[10]}, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);
    }      
}


sub genPolyrythmMult
{
    my $nbObjects = $_[0];
    my $max_height = $_[1];
    my $mult = $_[2];
    my $right_ratio = $_[3];
    my $left_ratio = $_[4];
    my @exclude_throws = ();
    my @exclude_throws_final = ();
    if(scalar @_ >= 6)
    {
	if($_[5] eq '')
	{
	    @exclude_throws = ();
	}
	else
	{
	    @exclude_throws = @{$_[5]};
	}
    }
    
    my $title = '-- POLYRYTHMS SITESWAPS WITH MULTIPLEX --';
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number 
    my $ground_check = "N";     # Get only Ground States (default) or no
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $symetry_add = "N";      # Add Symetry in Sync, Sync-Multiplex (ie double the period using '*')
    my $doubleTempo = "N";      # Double Tempo for 1:N or N:1
    
    my $ret = &GetOptionsFromString(uc($_[6]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
   				    "-A:s" => \$symetry_add,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
				    "-J:s" => \$doubleTempo,
	);

    my @opts_l = split('-',uc($_[6]));
    my $opts = '';
    for(my $i = 1; $i < scalar @opts_l; $i++)
    {
	if(uc($opts_l[$i]) !~ m/J/)
	{
	    $opts .= '-'.$opts_l[$i];
	}
    }    
    
    my @map_throw_r=();
    my @map_throw_l=();
    my @map_cpt_throw_r=();
    my @map_cpt_throw_l=();
    my @map_catch_r=();
    my @map_catch_l=();
    my $beat = 0;
    my $f = '';
    my @res = ();
    my $run_browser = -1;
    my $pwd = cwd();    
    my $direct_print = -1;
    my $double_tempo_enable = -1;
    
    if (scalar @_ <= 6)
    {
	$direct_print = 1;
    }
    
    if($max_height eq '' || hex($max_height) > $MAX_HEIGHT)
    {
	$max_height = $MAX_HEIGHT;
    }
    else
    {
	$max_height=hex($max_height);
    }
    
    #if($doubleTempo eq "Y" && ($right_ratio == 1 || $left_ratio == 1))
    #{
    #	$double_tempo_enable = 1;
    #}

    if($doubleTempo eq "Y")
    {
    	$double_tempo_enable = 1;
	my @exclude_throws_tmp = ();
	for(my $i=0;$i<scalar @exclude_throws; $i++)
	{
	    if(length($exclude_throws[$i]) == 1 && hex($exclude_throws[$i]) %2 == 0)
	    {
		if(hex($exclude_throws[$i]) == 0)
		{
		    push @exclude_throws_tmp, '0';
		}
		else {
		    push @exclude_throws_tmp , sprintf("%X",int(hex($exclude_throws[$i])/2)).'X';
		}
	    }
	    elsif(length($exclude_throws[$i]) == 2 && hex(substr($exclude_throws[$i],0,1)) %2 == 0)
	    {
		push @exclude_throws_tmp , sprintf("%X",int(hex(substr($exclude_throws[$i],0,1))/2));
	    }
	}
	@exclude_throws = @exclude_throws_tmp;	    
    }

    @exclude_throws_final = @exclude_throws;

    # We have to temporary add 0 in case of multiplex
    if($mult > 1 && (any {uc($_) eq '0'} @exclude_throws))
    {
	@exclude_throws = grep {!/0/} @exclude_throws;
    }

    my $nb_right_throws = $right_ratio;
    my $nb_left_throws = $left_ratio;
    my $period = $right_ratio * $left_ratio;
    my $expected_sum = $period * $nbObjects;
    
    my $r_v = '';
    my $l_v = '';
    for (my $i = 0; $i < $period; $i++)
    {
	if($i%$left_ratio == 0)
	{
	    push @map_throw_r, '';
	    push @map_catch_r, 0;
	    push @map_cpt_throw_r, 0;
	}
	else
	{
	    push @map_throw_r, '-';
	    push @map_catch_r, $mult;
	    push @map_cpt_throw_r, $mult;	    
	}
	
	if($i%$right_ratio == 0)
	{
	    push @map_throw_l, '';
	    push @map_catch_l, 0;
	    push @map_cpt_throw_l, 0;
	}
	else
	{
	    push @map_throw_l, '-';
	    push @map_catch_l, $mult;
	    push @map_cpt_throw_l, $mult;
	}	
    }
    
    &__genPolyrythmMult($max_height, $beat, $period, \@map_throw_r,\@map_throw_l, \@map_cpt_throw_r, \@map_cpt_throw_l, \@map_catch_r, \@map_catch_l,
			$expected_sum, \@res, $direct_print, \@exclude_throws, \@exclude_throws_final, $double_tempo_enable, $mult);        

    if (scalar @_ >= 8 && $_[7] ne "-1") {	    	    	    	    
	if ("JML:"=~substr(uc($_[7]),0,4)) {
	    $f =substr($_[7],4);

	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"$lang::MSG_SSWAP_POLYRYTHM_MSG1"." : ".$right_ratio.':'.$left_ratio."\"/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
	    }
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    @res = &printSSListWithoutHeaders((\@res,$opts,$_[7]));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr(uc($_[7]),0,7))
	{
	    $f =substr($_[7],7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."<BR/>\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";     
	    }
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		

	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$opts,$_[7]);				
	    
	    $run_browser=1;		
	}
	elsif("HTML:"=~substr(uc($_[7]),0,5))
	{
	    $f =substr($_[7],5);
	    for(my $i=0; $i < scalar @res; $i ++)
	    {
		print $res[$i]."\n";
	    }
	    @res = &printSSListHTML('-1',$f,"$title",'-V y -L y -J y',\@res);

	    $f = $f.".html";
	    $run_browser=1;		
	}
	else {
	    $f =$_[7];
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";     
	    if ($nbObjects == int($nbObjects)) {
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print FILE "================================================================\n\n";

	    @res = &printSSListWithoutHeaders((\@res,$opts,$_[7]));
	}
    } elsif(scalar @_ == 7) {	    
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_POLYRYTHM_MSG1." : ".$right_ratio.':'.$left_ratio."\n";
	if ($nbObjects == int($nbObjects)) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	}
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	@res = &printSSListWithoutHeaders((\@res,$opts));	    
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return \@res;    
}


sub lowerHeightOnTempo
{
    my $hmax = $MAX_HEIGHT;
    my $ss = &expandSync($_[0],-1);
    my $free_beat = 1;
    my $min_heigh_same_hand = 3;
    my $jugglinglab_interop = 'N';
    my $ret = &GetOptionsFromString(uc($_[1]),
				    # Set number of free Beats between Throws on same hand upon lowering height. Default is 1 Since Dwell time is ~1 also
				    "-F:i" => \$free_beat,
				    # Do not lower SS on same hand more than defined throw. Default is 3 to avoid to transform throw in hold 
				    "-M:i" => \$min_heigh_same_hand,
				    # Set to Y to set new holding time as 1x, 2 combination. Useful for viewing in JugglingLab 
				    "-J:s" => \$jugglinglab_interop,  
	);

    my $period_in = &getPeriod($ss,-1);
    my $fact_start = int($hmax / $period_in);
    if($hmax % $period_in != 0)
    {
	$fact_start += 1;
    }
    my $fact = $fact_start *2 + 1;
    my $start_beat = $fact_start * $period_in;
    if($start_beat % 2 !=0)
    {
	$start_beat += $period_in;
	$fact += 1;
    }
    $ss = $ss x $fact;   
    
    #Build Colorization and dicts
    my ($period,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &LADDER::__build_dicts($ss);
    my %transit_hash=%{$transit_hash_tmp};
    my %ss_hash=%{$ss_hash_tmp};
    my %nss_hash=();

    for (my $i = 0; $i < $start_beat+$period_in ; $i++) {
     	for (my $j = 0; $j < $MAX_MULT; $j++) {
    	    if (exists $ss_hash{ "R".$i.":".$j } && $ss_hash{ "R".$i.":".$j } ne '0') {	       
		my $catch = $transit_hash{ "R".$i.":".$j };
		my $hand=substr((split(':',$catch))[0],0,1);
		my $beat=substr((split(':',$catch))[0],1);
		my $mult=(split(':',$catch))[1];
		my $v = uc($ss_hash{ "R".$i.":".$j });
		my $vext = '';
		if($v =~ 'X')
		{
		    $vext = 'X';
		    $v =~s/X//g;
		}
		$v = hex($v);

		my $drap = -1;
		my $cpt = 0;

		for(my $k=$beat-1; $k > 0; $k--) {
		    for (my $l = 0; $l < $MAX_MULT; $l++) {
			if (exists $transit_hash{ $hand.$k.":".$l } && $transit_hash{ $hand.$k.":".$l } ne $hand.$k.":".$l ) {
			    $drap = 1;
			    last;
			}
		    }

		    if($drap == 1)
		    {
			last;
		    }
		    else
		    {
			$cpt++;
		    }
		}

		if($cpt > $v)
		{
		    $cpt = $v -1;
		}

		# Do not lower throw height more than expected
		if($cpt > $free_beat)
		{
		    if(($v%2 ==0 && $vext eq '') || ($v%2 !=0 && $vext eq 'X'))
		    {
			if($v - $cpt + $free_beat < $min_heigh_same_hand)
			{
			    $cpt = $v + $free_beat - $min_heigh_same_hand;
			}
		    }
		}

		if($cpt > $free_beat)
		{		    
		    if((( $v%2 == 0 && ($v - $cpt + $free_beat) %2 ==0) || ($v %2 != 0 && ($v - $cpt + $free_beat) %2 !=0))
		       && ($i -$start_beat >=0) && ($i -$start_beat < $period_in))
		    {
			if((uc(sprintf("%X",$v - $cpt + $free_beat)).$vext) ne '0X')
			{
			    $nss_hash{ "R".($i-$start_beat).":".$j } = sprintf("%X",($v - $cpt + $free_beat)).$vext;
			}
		    }
		    elsif($i -$start_beat >=0 && $i -$start_beat < $period_in)
		    {
			if($vext eq 'X')
			{
			    $nss_hash{ "R".($i-$start_beat).":".$j } = sprintf("%X",$v - $cpt + $free_beat);
			}
			else {
			    if($v - $cpt + $free_beat != 0)
			    {
				$nss_hash{ "R".($i-$start_beat).":".$j } = (sprintf("%X",$v - $cpt + $free_beat)).'X';
			    }			    
			}
		    }			

		    # The new holding times are here
		    if(uc($jugglinglab_interop) eq 'N')
		    {
			if($beat-$cpt + $free_beat -$start_beat >=0 && $beat-$cpt + $free_beat -$start_beat < $period_in)
			{	
			    if(($cpt - $free_beat) % 2 == 0)
			    {			    
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat).":".$mult } = sprintf("%X",$cpt - $free_beat);
			    }
			    else
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat).":".$mult } = (sprintf("%X",$cpt - $free_beat)).'X';
			    }
			}
		    }			
		    else {
			my $rep = int(($cpt - $free_beat)/2);
			for(my $a=0;$a<$rep;$a++)
			{
			    if($beat-$cpt + $free_beat -$start_beat +$a*2 >=0 && $beat-$cpt + $free_beat -$start_beat +$a*2 < $period_in)
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat + $a*2).":".$mult } = '2';
			    }
			}
			if(($cpt - $free_beat)%2 != 0)
			{
			    if($beat-$cpt + $free_beat -$start_beat +$rep*2 >=0 && $beat-$cpt + $free_beat -$start_beat +$rep*2 < $period_in)
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat + $rep*2).":".$mult } = '1X';
			    }
			}			    
		    }
		}		    			
		
		elsif($i -$start_beat >=0 && $i -$start_beat < $period_in)
		{
		    $nss_hash{ "R".($i-$start_beat).":".$j } = $ss_hash{ "R".$i.":".$j };
		}					     
	    }
	}
	
    }
    
    for (my $i = 0; $i < $start_beat + $period_in ; $i++) {
	for (my $j = 0; $j < $MAX_MULT; $j++) {	    
    	    if (exists $ss_hash{ "L".$i.":".$j } && $ss_hash{ "L".$i.":".$j } ne '0') {
		my $catch = $transit_hash{ "L".$i.":".$j };
		my $hand=substr((split(':',$catch))[0],0,1);
		my $beat=substr((split(':',$catch))[0],1);
		my $mult=(split(':',$catch))[1];
		my $v = uc($ss_hash{ "L".$i.":".$j });
		my $vext = '';
		if($v =~ 'X')
		{
		    $vext = 'X';
		    $v =~s/X//g;			
		}
		$v = hex($v);
		
		my $drap = -1;
		my $cpt = 0;
		for(my $k=$beat-1; $k > 0; $k--) {
		    for (my $l = 0; $l < $MAX_MULT; $l++) {
			if (exists $transit_hash{ $hand.$k.":".$l } && $transit_hash{ $hand.$k.":".$l } ne $hand.$k.":".$l) {
			    $drap = 1;
			    last;
			}
		    }
		    
		    if($drap == 1)
		    {
			last;
		    }
		    else
		    {
			$cpt++;
		    }
		}

		if($cpt > $v)
		{
		    $cpt = $v -1;
		}

		# Do not lower throw height more than expected
		if($cpt > $free_beat)
		{
		    if(($v%2 ==0 && $vext eq '') || ($v%2 !=0 && $vext eq 'X'))
		    {
			if($v - $cpt + $free_beat < $min_heigh_same_hand)
			{
			    $cpt = $v + $free_beat - $min_heigh_same_hand;
			}
		    }
		}

		if($cpt > $free_beat)
		{		    		  
		    if((($v%2 == 0 && ($v - $cpt + $free_beat) %2 ==0) || ($v %2 != 0 && ($v - $cpt + $free_beat) %2 !=0))
		       && ($i -$start_beat >=0) && ($i -$start_beat < $period_in))
		    {
			if((uc(sprintf("%X",$v - $cpt + $free_beat)).$vext) ne '0X')
			{
			    $nss_hash{ "L".($i-$start_beat).":".$j } = (sprintf("%X",$v - $cpt + $free_beat)).$vext;
			}
		    }
		    elsif($i -$start_beat >=0 && $i -$start_beat < $period_in)
		    {
			if($vext eq 'X')
			{
			    $nss_hash{ "L".($i-$start_beat).":".$j } = sprintf("%X",$v - $cpt + $free_beat);
			}
			else {
			    if($v - $cpt + $free_beat != 0)
			    {
				$nss_hash{ "L".($i-$start_beat).":".$j } = (sprintf("%X",$v - $cpt + $free_beat)).'X';
			    }
			}			
		    }

		    # The new holding times are here		  	
		    if(uc($jugglinglab_interop) eq 'N')
		    {
			if($beat-$cpt + $free_beat -$start_beat >=0 && $beat-$cpt + $free_beat -$start_beat < $period_in)
			{	
			    if(($cpt - $free_beat) % 2 == 0)
			    {			    
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat).":".$mult } = sprintf("%X",$cpt - $free_beat);
			    }
			    else
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat).":".$mult } = (sprintf("%X",$cpt - $free_beat)).'X';
			    }
			}
		    }
		    else {
			my $rep = int(($cpt - $free_beat)/2);
			for(my $a=0;$a<$rep;$a++)
			{
			    if($beat-$cpt + $free_beat -$start_beat +$a*2 >=0 && $beat-$cpt + $free_beat -$start_beat +$a*2 < $period_in)
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat + $a*2).":".$mult } = '2';
			    }
			}
			if(($cpt - $free_beat)%2 != 0)
			{
			    if($beat-$cpt + $free_beat -$start_beat +$rep*2 >=0 && $beat-$cpt + $free_beat -$start_beat +$rep*2 < $period_in)
			    {
				$nss_hash{ $hand.($beat-$cpt + $free_beat -$start_beat + $rep*2).":".$mult } = '1X';
			    }
			}			    
		    }		    
		    
		}
		elsif($i -$start_beat >=0 && $i -$start_beat < $period_in)
		{
		    $nss_hash{ "L".($i-$start_beat).":".$j } = $ss_hash{ "L".$i.":".$j };
		}
	    }
	}
    }

    # A little hack to add ending of the SS in the hash since filling both hand with 0 will not give a way to the
    # __get_ss_from_ssMAP to end how to continue after the period
    for(my $i=$period_in-1; $i >=0; $i--)
    {
	if(exists($nss_hash{ "R".$i.":0" }) || exists($nss_hash{ "L".$i.":0" }))
	{	
	    last;
	}
	else
	{
	    if($i % 2 == 0)
	    {
		$nss_hash{ "R".$i.":0"} = '0';
	    }
	    else
	    {
		$nss_hash{ "L".$i.":0"} = '0';
	    }
	}
    }    

    if ($SSWAP_DEBUG >= 1) {    
	print "SSWAP::lowerHeightOnTempo : ============ NEW TRANSITIONS =================\n";
	for my $key (sort keys %nss_hash) {
	    print $key." => ".$nss_hash{$key}."\n";
	}	    

	print "=======================================================\n";
    }
    
    my $ss_res = &LADDER::__get_ss_from_ssMAP(\%nss_hash,'R');

    $ss_res = lc(&simplify($ss_res,-1));
    
    if (scalar @_ <= 2 || $_[2] ne "-1")
    {
	print $ss_res."\n";
    }

    return $ss_res;
}


sub genSSFromThrows
{
    my $mod = uc(shift);    
    my $title = '-- SITESWAPS GENERATION FROM THROWS --';
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number 
    my $ground_check = "N";     # Get only Ground States (default) or no
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $symetry_add = "N";      # Add Symetry in Sync, Sync-Multiplex (ie double the period using '*')
    
    my $ret = &GetOptionsFromString(uc($_[1]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
   				    "-A:s" => \$symetry_add,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);

    my $ss = $_[0];
    my @res =();
    my @resF =();
    my $hmax=$MAX_HEIGHT;
    my $nb_throws = 0;
    my @setH = ();
    my $f = "";
    my $pwd = cwd();
    
    for (my $i =0; $i <= $hmax ; $i++) {		
	$setH[$i] =0;	
    }
    
    if (scalar @_ >= 3 && $_[2] ne "-1") {       
	if ("JML:"=~substr($_[2],0,4)) {	
	    $f =substr($_[2],4);    
	    
	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
	    if ($remove_redundancy != 0) {
		print FILE_JML "<line display=\"========================================\"/>\n";	   
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENMAGICSS_MSG1a."\"/>\n";	   
		print FILE_JML "<line display=\"========================================\"/>\n";	   
	    }
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif ("SSHTML:"=~substr($_[2],0,7)) {	
	    $f =substr($_[2],7).".html";    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;		
	    print FILE $title."<BR/>\n";
	    if ($remove_redundancy != 0) {
		print FILE "\n================================================================<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		print FILE "\n================================================================<BR/>\n";     
	    }     
	    close FILE;
	}
	else
	{
	    $f=$_[2];	    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;		
	    print FILE $title."\n";
	    if ($remove_redundancy != 0) {
		print FILE "================================================================\n";     
		print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		print FILE "================================================================\n";     
	    }     
	    close FILE;
	}	
    }
    elsif(scalar @_ < 3)
    {
	print colored [$common::COLOR_RESULT], $title."\n";
	if ($remove_redundancy != 0) {
	    print colored [$common::COLOR_RESULT], "================================================================\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    print colored [$common::COLOR_RESULT], "================================================================\n";     
	}     
    }
    
    if ($mod eq "V") {	
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++) {		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);	

	if (scalar @_ >= 3 && "SSHTML:"=~substr($_[2],0,7)) {       
	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[1],$_[2]);
	}
	elsif(scalar @_ < 3)
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[1]);
	}
	else
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[1],$_[2]);
	}    
    } elsif ($mod eq "S") {	
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++) {		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_sync(\@setH, $nb_throws, $hmax, '-A '.$symetry_add);	
	if (scalar @_ >= 3 && "SSHTML:"=~substr($_[2],0,7)) {       
	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[1],$_[2]);
	}
	elsif(scalar @_ < 3)
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[1]);
	}
	else
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[1],$_[2]);
	}
    } elsif ($mod eq "M") {	
	my $mult = $_[2];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++) {		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_multiplex(\@setH, $nb_throws, $hmax, $mult);
	if (scalar @_ >= 4 && "SSHTML:"=~substr($_[3],0,7)) {       
	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[2],$_[3]);
	}
	elsif(scalar @_ < 4)
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[2]);
	}
	else
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[2],$_[3]);
	}
    } elsif ($mod eq "MS" || $mod eq "SM") {	
	my $mult = $_[2];
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++) {		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_multiplex_sync(\@setH, $nb_throws, $hmax, $mult, '-A '.$symetry_add);
	if (scalar @_ >= 4 && "SSHTML:"=~substr($_[3],0,7)) {       
	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[2],$_[3]);
	}
	elsif(scalar @_ < 4)
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[2]);
	}
	else
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[2],$_[3]);
	}
    } elsif ($mod eq "MULTI") {	
	$nb_throws = length($ss);
	for (my $i = 0; $i < $nb_throws ; $i++) {		
	    $setH[hex(substr($ss,$i,1))] ++;	
	}

	@res=&__genSSFromContain_multisync(\@setH, $nb_throws, $hmax);	

	if (scalar @_ >= 3 && "SSHTML:"=~substr($_[2],0,7)) {       
	    @res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[1],$_[2]);
	}
	elsif(scalar @_ < 3)
	{
	    @res = &printSSListWithoutHeaders(\@res,$_[1]);
	}	
	else
	{	    
	    @res = &printSSListWithoutHeaders(\@res,$_[1],$_[2]);
	}
    }    

    if (scalar @_ >= 3 && $_[2] ne "-1") {       
	if ("JML:"=~substr($_[2],0,4)) {
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
    }
    
    if (scalar @_ >= 3 && $_[2] ne "-1" && "SSHTML:"=~substr($_[2],0,7))
    {
	if ($conf::jtbOptions_r == 1)
	{
	    if ($common::OS eq "MSWin32") {
		system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	    } else {
		# Unix-like OS
		system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	    }
	}
    }

    return \@resF;
}



sub genSSMagic
{   
    my $mod = uc(shift);    
    my @res =();
    # $_[0] is either all/every, odd/impair, even/pair; 
    my $start = $_[1];
    my $nb_throws = $_[2];	#NbThrows
    my $f = '';
    my $opts = "-1";
    my $nbObjects=0;
    my $hmax=0;
    my @setH = ();
    my $pwd = cwd();

    my $title = '-- MAGIC SITESWAPS --'; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)    
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    
    my $run_browser = -1;

    if ($mod eq "V") {	
	$opts = $_[3];
	&GetOptionsFromString(uc($_[3]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );

	if ($nb_throws <= 0) {
	    @res=();
	} elsif (uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL") {    
	    $hmax = $nb_throws -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    $setH[$i] = 1;	
		    $nbObjects += $i;
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);
	    }
	} elsif (uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR") {    
	    my $slide = 0;
	    if($start % 2 == 0)
	    {
		$slide = -2;
	    }
	    else
	    {
		$slide = -1;
	    }

	    $hmax = $nb_throws*2 + $start + $slide;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i = $start; $i <= $hmax ; $i++) {
		    if ($i%2 == 0) {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);    
	    }
	} elsif (uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR") {
	    my $slide = 0;
	    if($start % 2 == 0)
	    {
		$slide = -1;
	    }
	    else
	    {
		$slide = -2;
	    }
	    $hmax = $nb_throws*2 + $start + $slide;
	    if ($hmax <= $MAX_HEIGHT) {	    
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 != 0) {
			$setH[$i] = 1;
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;	
		@res=&__genSSFromContain_async(\@setH, $nb_throws, $hmax);    
	    }
	}

	if (scalar @_ >= 5 && $_[4] ne "-1") {	    	    	    	    
	    if ("JML:"=~substr(uc($_[4]),0,4)) {
		$f =substr($_[4],4);

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1p"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL6"." : ".$nb_throws."\"/>\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
		}
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		@res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	    }
	    elsif("SSHTML:"=~substr(uc($_[4]),0,7))
	    {
		$f =substr($_[4],7).".html";
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."<BR/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."<BR/>\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";     
		}
		print FILE "================================================================<BR/>\n\n";
		close(FILE);		

		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[3],$_[4]);				
		
		$run_browser=1;		
	    }
	    else {
		$f =$_[4];
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE $title."\n";
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
		}
		print FILE "================================================================\n\n";

		@res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
	    }
	} elsif(scalar @_ < 5) {	    
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1p."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if ($remove_redundancy != 0) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
	    if ($nbObjects == int($nbObjects)) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    @res = &printSSListWithoutHeaders((\@res,$_[3]));	    
	}
    } elsif ($mod eq "M") {
	my $mult = $_[3];
	$opts = $_[4];
	&GetOptionsFromString(uc($_[4]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );
	
	if ($nb_throws <= 0) {
	    @res=();
	} elsif (uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL") {    
	    $hmax = $nb_throws -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    $setH[$i] = 1;			
		}
		@res=&__genSSFromContain_multiplex(\@setH, $nb_throws, $hmax,$mult);
	    }
	} elsif (uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR") {    
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 == 0) {
			$setH[$i] = 1;	
		    } else {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_multiplex(\@setH, $nb_throws, $hmax,$mult);    
	    }
	} elsif (uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR") {
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {	    
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 != 0) {
			$setH[$i] = 1;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_multiplex(\@setH, $nb_throws, $hmax, $mult);    
	    }
	}

	if (scalar @_ >= 6 && $_[5] ne "-1") {	    
	    if ("JML:"=~substr(uc($_[5]),0,4)) {
		$f =substr($_[5],4);

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1p"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL15"." : ".$nb_throws."\"/>\n";     				
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL16"." : ".$mult."\"/>\n";     		
		print FILE_JML "<line display=\"========================================\""."/>\n";
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		@res = &printSSListWithoutHeaders((\@res,$_[4],$_[5]));	
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	    }
	    elsif("SSHTML:"=~substr(uc($_[5]),0,7)) {
		$f =substr($_[5],7).".html";
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;		
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."<BR/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."<BR/>\n";        
		print FILE "================================================================<BR/>\n\n";
		close(FILE);

		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[4],$_[5]);				
		
		$run_browser=1;		
	    }
	    else {
		$f =$_[5];
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE $title."\n";	
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1p."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";        
		print FILE "================================================================\n\n";

		@res = &printSSListWithoutHeaders(\@res,$_[4],$_[5]);	
	    }
	} elsif(scalar @_ < 6) {
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1p."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if ($remove_redundancy != 0) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";    
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";

	    @res = &printSSListWithoutHeaders(\@res,$_[4]);	
	}		
    } elsif ($mod eq "S") {
	$opts = $_[3];
	&GetOptionsFromString(uc($_[3]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );

	if ($nb_throws <= 0) {
	    @res=();
	} elsif (uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL") {    
	    # Not possible with synchronous pattern
	    @res=();	    
	} elsif (uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR") {    
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 == 0) {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;
		@res=&__genSSFromContain_sync(\@setH, $nb_throws, $hmax);    	    
	    }
	} elsif (uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR") {
	    # Not possible with synchronous pattern
	    @res=();		    
	}
	
	if (scalar @_ >= 5 && $_[4] ne "-1") {	    
	    if ("JML:"=~substr(uc($_[4]),0,4)) {
		$f =substr($_[4],4);

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1bp"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL6"." : ".$nb_throws."\"/>\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL2"." : ".$nbObjects."\"/>\n";     
		}
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;

		@res = &printSSListWithoutHeaders(\@res,$_[3],$_[4]);	
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	    } 
	    elsif ("SSHTML:"=~substr(uc($_[4]),0,7)) {
		$f =substr($_[4],7).".html";
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."<BR/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."<BR/>\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";     
		}
		print FILE "================================================================<BR/>\n\n";
		close(FILE);		
		
		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[3],$_[4]);				
		
		$run_browser=1;		
	    }

	    else {
		$f =$_[4];
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE $title."\n";
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
		if ($nbObjects == int($nbObjects)) {
		    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
		}
		print FILE "================================================================\n\n";
		close(FILE);		

		@res = &printSSListWithoutHeaders(\@res,$_[3],$_[4]);	
	    }
	} elsif(scalar @_ < 5) {
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";    
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1bp."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if ($remove_redundancy != 0) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$nb_throws."\n";     
	    if ($nbObjects == int($nbObjects)) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."\n";     
	    }
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	    @res = &printSSListWithoutHeaders(\@res,$_[3]);	
	}

    } elsif ($mod eq "MS" || $mod eq "SM") {
	my $mult = $_[3];
	$opts = $_[4];
	&GetOptionsFromString(uc($_[4]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
	    );

	if ($nb_throws <= 0) {
	    @res=();
	} elsif (uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL") {    
	    # Not possible with synchronous pattern
	    @res=();	    
	} elsif (uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR") {    
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 == 0) {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		$nbObjects = $nbObjects / $nb_throws;
		@res=&__genSSFromContain_multiplex_sync(\@setH, $nb_throws, $hmax, $mult);    	    		
	    }
	} elsif (uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR") {
	    # Not possible with synchronous pattern
	    @res=();	    
	    #if((scalar @_ == 6 && $_[4] ne "-1") || (scalar @_ == 5))
	    #{
	    #	print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1bp."]"."\n";     
	    #}
	}
	
	if (scalar @_ >= 6 && $_[5] ne "-1") {
	    if ("JML:"=~substr(uc($_[5]),0,4)) {
		$f =substr($_[5],4);

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1bp"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL15"." : ".$nb_throws."\"/>\n";     				
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL16"." : ".$mult."\"/>\n";     		
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;

		@res = &printSSListWithoutHeaders(\@res,$_[4],$_[5]);	
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	    }
	    elsif("SSHTML:"=~substr(uc($_[5]),0,7)) {
		$f =substr($_[5],7).".html";
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."<BR/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."<BR/>\n";        
		print FILE "================================================================<BR/>\n\n";
		close FILE;

		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[4],$_[5]);				
		
		$run_browser=1;		
	    }
	    else {
		$f =$_[5];
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE $title."\n";
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1bp."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";        
		print FILE "================================================================\n\n";

		@res = &printSSListWithoutHeaders(\@res,$_[4],$_[5]);	
	    }
	} elsif(scalar @_ < 6) {
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";   
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1bp."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if ($remove_redundancy != 0) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL16." : ".$mult."\n";    
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";

	    @res = &printSSListWithoutHeaders(\@res,$_[4]);	
	}	

    } elsif ($mod eq "MULTI") {	
	$opts = $_[3];
	&GetOptionsFromString(uc($_[3]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
	    );

	if ($nb_throws <= 0) {
	    @res=();
	} elsif (uc($_[0]) eq "EVERY" || uc($_[0]) eq "ALL") {    
	    $hmax = $nb_throws -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    $setH[$i] = 1;	
		    $nbObjects += $i;
		}
		@res=&__genSSFromContain_multisync(\@setH, $nb_throws, $hmax);
	    }
	} elsif (uc($_[0]) eq "EVEN" || uc($_[0]) eq "PAIR") {    
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 == 0) {
			$setH[$i] = 1;	
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_multisync(\@setH, $nb_throws, $hmax);    
	    }
	} elsif (uc($_[0]) eq "ODD" || uc($_[0]) eq "IMPAIR") {
	    $hmax = $nb_throws*2 -1 + $start;
	    if ($hmax <= $MAX_HEIGHT) {	    
		for (my $i =$start; $i <= $hmax ; $i++) {
		    if ($i%2 != 0) {
			$setH[$i] = 1;
			$nbObjects += $i;
		    } else {
			$setH[$i] = -1;	
		    }
		}
		@res=&__genSSFromContain_multisync(\@setH, $nb_throws, $hmax);    
	    }
	}

	if (scalar @_ >= 5 && $_[4] ne "-1") {	    	    	    	    
	    if ("JML:"=~substr(uc($_[4]),0,4)) {
		$f =substr($_[4],4);

		open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\'".$title."\'"."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1cp"."\"/>\n";     
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL14"." : ".lc($_[0])."\"/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
		}
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL15"." : ".$nb_throws."\"/>\n";     
		print FILE_JML "<line display=\"========================================\""."/>\n";	   
		print FILE_JML "<line display=\"\"/>\n";	   
		close FILE_JML;
		
		@res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	    } 
	    elsif("SSHTML:"=~substr(uc($_[4]),0,7))
	    {
		$f =substr($_[4],7).".html";
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1cp."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."<BR/>\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."<BR/>\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."<BR/>\n";     
		print FILE "================================================================<BR/>\n\n";
		close(FILE);		

		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[3],$_[4]);				
		
		$run_browser=1;		
	    }
	    else {
		$f =$_[4];
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE $title."\n";
		print FILE "\n================================================================\n";	   
		print FILE $lang::MSG_SSWAP_GENERAL1cp."\n";     
		print FILE $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";     
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
		}
		print FILE $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
		print FILE "================================================================\n\n";

		@res = &printSSListWithoutHeaders((\@res,$_[3],$_[4]));
	    }
	} elsif(scalar @_ < 5) {
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";   
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1cp."\n";     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL14." : ".lc($_[0])."\n";
	    if ($remove_redundancy != 0) {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENMAGICSS_MSG1a."\n";     
	    }     
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL15." : ".$nb_throws."\n";     
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	    @res = &printSSListWithoutHeaders((\@res,$_[3]));
	}	
    }    
    
    
    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return \@res;
}


sub __genSSFromContain_any
{
    # Return all the (asynchronous) combination of $_[0] values. Even Invalid SS are returned
    &common::displayComputingPrompt();	    
    my @tab = @{$_[0]};		# Symbol/SS to use next
    my $p = $_[1];	        # Period
    my $hmax = $_[2];		# Height Max	  
    my @res = ();       

    if ($p <= 0) {
	for (my $i = 0; $i <= $hmax; $i ++) {	
	    &common::displayComputingPrompt();	    	  
	    if ($tab[$i] > 0) {		 
		push(@res,sprintf("%x",$i));
	    }		  
	}
	&common::hideComputingPrompt();	    
	return @res;
    } else {
	for (my $i = 0; $i <= $hmax; $i ++) {
	    &common::displayComputingPrompt();	    
	    my $nbcount = $tab[$i];
	    if ($nbcount > 0) {		
		my @tab2=@tab;
		$nbcount --;
		$tab2[$i]=$nbcount;
		my @subres= &__genSSFromContain_any(\@tab2,$p-1,$hmax);
		if (scalar @subres ==0) {
		    push(@res,sprintf("%x",$i));
		} else {
		    for (my $j =0; $j < scalar @subres; $j++) {			
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
    # Return all the valid (asynchronous) combination of $_[0] values. Even Invalid SS are returned
    &common::displayComputingPrompt();	    
    my @tab = @{$_[0]};		# Symbol/SS to use next
    my $p = $_[1];	        # Period
    my $hmax = $_[2];		# Height Max	  
    my @res = ();       

    if ($p <= 0) {
	for (my $i = 0; $i <= $hmax; $i ++) {	
	    &common::displayComputingPrompt();	    	  
	    if ($tab[$i] > 0) {		 
		if (&isValid(sprintf("%x",$i),-1)==1) {
		    push(@res,sprintf("%x",$i));
		}
		elsif ($SSWAP_DEBUG>=1) {
		    print "== SSWAP::__genSSFromContain_async : ".sprintf("%x",$i)." => Not valid.\n";
		}											 	    		  
	    }		  
	}
	&common::hideComputingPrompt();	    
	return @res;
    } else {
	for (my $i = 0; $i <= $hmax; $i ++) {
	    &common::displayComputingPrompt();	    
	    my $nbcount = $tab[$i];
	    if ($nbcount > 0) {		
		my @tab2=@tab;
		$nbcount --;
		$tab2[$i]=$nbcount;
		my @subres= &__genSSFromContain_any(\@tab2,$p-1,$hmax);
		if (scalar @subres ==0) {
		    if (&isValid(sprintf("%x",$i),-1)==1) {
			push(@res,sprintf("%x",$i));
		    }
		    elsif ($SSWAP_DEBUG>=1) {
			print "== SSWAP::__genSSFromContain_async : ".sprintf("%x",$i)." => Not Valid.\n";
		    }											 	    		  
		} else {
		    for (my $j =0; $j < scalar @subres; $j++) {
			if (&isValid(sprintf("%x",$i).$subres[$j],-1)==1) {
			    push(@res,sprintf("%x",$i).$subres[$j]);			
			}
			elsif ($SSWAP_DEBUG>=1) {
			    print "== SSWAP::__genSSFromContain_async : ".sprintf("%x",$i).$subres[$j]." => Not valid.\n";
			}											 	    		  
		    }
		}		
	    }
	}
	&common::hideComputingPrompt();	    	
	return @res;
    }	
}


sub __genSSFromContain_multiplex
{
    sub __genSSFromContain_multiplex_single
    {    
	my $ss=$_[0];
	my $mult = $_[1];
	my @res = ();
	
	for (my $j =0; $j <= length($ss); $j++) {
	    my $v = substr($ss,0,$j)."[";
	    for (my $k = 2; $k < length($ss) -$j+1; $k++) {	    	    	    	    
		&common::displayComputingPrompt();	    	    
		my $v2 = $v.substr($ss,$j,$k)."]".substr($ss,$j+$k);
		push(@res, $v2);
		if ($mult > 1) {
		    my $v2 = $v.substr($ss,$j,$k)."]";
		    my @resv2= &__genSSFromContain_multiplex_single(substr($ss,$j+$k),$mult-1);
		    for (my $l =0; $l < scalar @resv2; $l ++) {			    
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
    my @resF=();

    for (my $i =0; $i < scalar @res; $i++) {	    	   
	# To incoporate Vanilla also in Multiplex results
	#if (&isValid($res[$i],-1)==1) {
	#	push(@resF, $res[$i]);	
	#}
	for (my $j =0; $j <= length($res[$i]); $j++) {
	    my $v = substr($res[$i],0,$j)."[";
	    for (my $k = 2; $k < length($res[$i]) -$j+1; $k++) {
		my $v2 = $v.substr($res[$i],$j,$k)."]".substr($res[$i],$j+$k);
		if (&isValid($v2,-1)==1) {
		    push(@resF, $v2);		    					    
		} elsif ($SSWAP_DEBUG>=1) {
		    print "== SSWAP::__genSSFromContain_multiplex : ".$v2." => Not valid.\n";
		}						
		
		if ($mult > 1) {
		    my $v2 = $v.substr($res[$i],$j,$k)."]";
		    my @resv2= &__genSSFromContain_multiplex_single(substr($res[$i],$j+$k),$mult-1);
		    for (my $l =0; $l < scalar @resv2; $l ++) {	
			if (&isValid($v2.$resv2[$l],-1)==1) {
			    push(@resF, $v2.$resv2[$l]);			 			    
			} elsif ($SSWAP_DEBUG>=1) {
			    print "== SSWAP::__genSSFromContain_multiplex : ".$v2.$resv2[$l]." => Not valid.\n";
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

	if ((length ($ss))% 2 != 0 || length ($ss) < 2) {
	    return @res;	    
	} elsif (length ($ss) == 2) {
	    my $v1 = substr($ss,0,1);
	    my $v2 = substr($ss,1,1);
	    my $v = '';
	    $v = "(".$v1.",".$v2.")";
	    push (@res, $v);
	    if($v1 ne "0" && $v2 ne "0")
	    {
		$v = "(".$v1."x,".$v2."x)";
		push (@res, $v);
	    }
	    if($v1 ne "0")
	    {
		$v = "(".$v1."x,".$v2.")";
		push (@res, $v);
	    }
	    if($v2 ne "0")
	    {
		$v = "(".$v1.",".$v2."x)";
		push (@res, $v);
	    }		
	    return @res;	    
	} else {
	    my $v1 = substr($ss,0,1);
	    my $v2 = substr($ss,1,1);
	    my $v = '';
	    my @restmp = &__genSSFromContain_sync_single(substr($ss,2));
	    for (my $i = 0; $i < scalar @restmp; $i++) {
		$v = "(".$v1.",".$v2.")".$restmp[$i];
		push (@res, $v);
		if($v1 ne "0" && $v2 ne "0")
		{
		    $v = "(".$v1."x,".$v2."x)".$restmp[$i];
		    push (@res, $v);
		}
		if($v1 ne "0")
		{
		    $v = "(".$v1."x,".$v2.")".$restmp[$i];
		    push (@res, $v);
		}
		if($v2 ne "0")
		{
		    $v = "(".$v1.",".$v2."x)".$restmp[$i];
		    push (@res, $v);		
		}
	    }
	    return @res;
	}	
    }

    # Only valid SS are returned
    my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
    my @resF = ();

    &common::displayComputingPrompt();	    
    my @tab = @{$_[0]};		# Symbol/SS to use next
    my $p = $_[1];		# Period
    my $hmax = $_[2];		# Height Max
    my $symetry_add ='N';       # Add Symetry
    
    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-A:s" => \$symetry_add
	);
    
    for (my $i = 0; $i < scalar @res; $i++) {
	if (length($res[$i])%2 == 0) {
	    my @vext = &__genSSFromContain_sync_single($res[$i]);	    	
	    for (my $j=0; $j < scalar @vext; $j ++) {
		&common::displayComputingPrompt();
		if(uc($symetry_add) eq 'Y')
		{
		    $vext[$j]=$vext[$j].'*';
		}
		if (&isValid($vext[$j],-1)==1) {
		    push(@resF, $vext[$j]);	    		
		} elsif ($SSWAP_DEBUG>=1) {
		    print "== SSWAP::__genSSFromContain_sync : ".$vext[$j]." => Not valid.\n";
		}	
	    }
	}
    }

    &common::hideComputingPrompt();	    	
    return @resF;	
}


sub __genSSFromContain_multiplex_sync
{
    sub __genSSFromContain_multiplex_sync_all_mult
    {
	# Return all possible siteswap (appending x to different values) from a multiplex one
	my $ss = $_[0];
	my @res = ();
	
	if (length($ss) == 0) {
	    return @res;
	}
	
	if (length($ss) == 1) {
	    my $v = substr($ss,0,1);
	    push(@res,$v);
	    if($v ne "0")
	    {
		push(@res,$v."x");
	    }
	    return @res;
	}
	
	if ((substr($ss,0,1) eq '[' && substr($ss,length ($ss) -1,1) ne "]") 
	    || (substr($ss,0,1) ne '[' && substr($ss,length ($ss) -1,1) eq "]")) {
	    return -1;
	}
	
	if ((substr($ss,0,1) eq '[' && substr($ss,length ($ss) -1,1) eq "]")) {
	    my $v = substr($ss,1,1);
	    my @restmp=&__genSSFromContain_multiplex_sync_all_mult(substr($ss,2,length($ss)-3));
	    for (my $j =0; $j < scalar(@restmp); $j++) {
		&common::displayComputingPrompt();	    
		push(@res,"[".$v.$restmp[$j]."]");
		if($v ne "0")
		{		
		    push(@res,"[".$v."x".$restmp[$j]."]");
		}
	    }	    
	} else {
	    my $v = substr($ss,0,1);
	    my @restmp=&__genSSFromContain_multiplex_sync_all_mult(substr($ss,1,length($ss)-1));
	    for (my $j =0; $j < scalar(@restmp); $j++) {
		&common::displayComputingPrompt();	    
		push(@res,$v.$restmp[$j]);
		if($v ne "0")
		{		    
		    push(@res,$v."x".$restmp[$j]);
		}
	    }
	}
	
	&common::hideComputingPrompt();	    
	return @res;
    }

    sub __genSSFromContain_multiplex_sync_a_single()
    {   
	# Return all available Multiplexes from a vanilla ss (valid or not)
	my $ss= $_[0];
	my $mult = $_[1];
	my @res = ();
	
	for (my $j =0; $j <= length($ss); $j++) {
	    my $v = substr($ss,0,$j)."[";
	    for (my $k = 2; $k < length($ss) -$j+1; $k++) {	    	    	    	    
		&common::displayComputingPrompt();	    	    
		my $v2 = $v.substr($ss,$j,$k)."]".substr($ss,$j+$k);
		push(@res, $v2);
		if ($mult > 1) {
		    my $v2 = $v.substr($ss,$j,$k)."]";
		    my @resv2= &__genSSFromContain_multiplex_sync_a_single(substr($ss,$j+$k),$mult-1);
		    for (my $l =0; $l < scalar @resv2; $l ++) {			    
			push(@res, $v2.$resv2[$l]);
		    }
		}		    
	    }		
	}     
	
	&common::hideComputingPrompt();	        
	return @res;		
    }

    sub __genSSFromContain_multiplex_sync_b_single
    {
	# Return all available Synchronous from a Multiplex ss (valid or not)
	
	sub __genSSFromContain_multiplex_sync_b_single_in
	{
	    my @ss=@{$_[0]};
	    my @res = ();
	    if (scalar @ss % 2 != 0 || scalar @ss == 0) {
		return @res;
	    } elsif (scalar @ss == 2) {
		my $v1 = $ss[0];
		my $v2 = $ss[1];
		my @extandv1 = &__genSSFromContain_multiplex_sync_all_mult($v1);
		my @extandv2 = &__genSSFromContain_multiplex_sync_all_mult($v2);
		for (my $i=0; $i < scalar @extandv1; $i++) {
		    for (my $j=0; $j < scalar @extandv2; $j++) {
			push(@res,"(".$extandv1[$i].",".$extandv2[$j].")");		  
		    }
		}
		return @res;
	    } else {
		my @ssn = @ss[2..scalar @ss-1];
		my @restmp = &__genSSFromContain_multiplex_sync_b_single_in(\@ssn);
		for (my $i=0; $i < scalar @restmp; $i++) {
		    my $v1 = $ss[0];
		    my $v2 = $ss[1];
		    my @extandv1 = &__genSSFromContain_multiplex_sync_all_mult($v1);
		    my @extandv2 = &__genSSFromContain_multiplex_sync_all_mult($v2);
		    for (my $j=0; $j < scalar @extandv1; $j++) {
			for (my $k=0; $k < scalar @extandv2; $k++) {
			    push(@res,"(".$extandv1[$j].",".$extandv2[$k].")".$restmp[$i]);
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
	for (my $i =0; $i<length($ss);$i++) {
	    if (substr($ss,$i,1) eq "]") {
		$multiplex=-1;
		$res[$cpt]=$res[$cpt]."]";
		$cpt++;
	    } elsif (substr($ss,$i,1) eq "[") {
		$res[$cpt]="[";
		$multiplex=1;
	    } else {
		if ($multiplex == -1) {
		    $res[$cpt]=substr($ss,$i,1);
		    $cpt ++;
		} else {
		    $res[$cpt]=$res[$cpt].substr($ss,$i,1);
		}
	    }
	}

	my @resF=&__genSSFromContain_multiplex_sync_b_single_in(\@res);

	return @resF;

    }


    # Onlid valid SS are returned
    my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
    my $mult = $_[3]; 
    my $symetry_add ='N';       # Add Symetry

    my $ret = &GetOptionsFromString(uc($_[4]),    
				    "-A:s" => \$symetry_add
	);

    my @resF=();

    for (my $i =0; $i < scalar @res; $i++) 
    {	    	
	my @res_mult= &__genSSFromContain_multiplex_sync_a_single($res[$i],$mult);
	for (my $j =0; $j < scalar @res_mult; $j ++) {	
	    my @res_multiplex_sync= &__genSSFromContain_multiplex_sync_b_single($res_mult[$j]);
	    for (my $k =0; $k < scalar @res_multiplex_sync; $k ++) {
		if(uc($symetry_add) eq 'Y')
		{
		    $res_multiplex_sync[$k] = $res_multiplex_sync[$k].'*';
		}
		if (&isValid($res_multiplex_sync[$k],-1)==1) {
		    push(@resF, $res_multiplex_sync[$k]);			 			    
		} elsif ($SSWAP_DEBUG>=1) {
		    print "== SSWAP::__genSSFromContain_multiplex_sync : ".$res_multiplex_sync[$k]." => Not valid.\n";
		}						
	    }
	}
    }		

    @res = @resF;

    return @res;		
}


sub __genSSFromContain_multisync
{

    sub __genSSFromContain_multisync_in
    {
	# Return all possible siteswap (appending x to different values and siteswaps with !, !* and *)
	&common::displayComputingPrompt();	   

	my $ss = $_[0];
	my @res = ();
	
	if (length($ss) == 0) {
	    return @res;
	}

	my $v = substr($ss,0,1);	
	if (length($ss) == 1) {
	    push(@res,$v);
	    #push(@res,$v."!*");
	    #push(@res,$v."!");
	    push(@res,$v."*");
	    if($v ne "0")
	    {
		push(@res,$v."x");
		#push(@res,$v."x!*");
		#push(@res,$v."x!");
		push(@res,$v."x*");
	    }
	    return @res;
	}
	
	my @restmp=&__genSSFromContain_multisync_in(substr($ss,1));
	for (my $j =0; $j < scalar(@restmp); $j++) {
	    push(@res,$v.$restmp[$j]);
	    push(@res,$v."!*".$restmp[$j]);
	    push(@res,$v."!".$restmp[$j]);
	    push(@res,$v."*".$restmp[$j]);
	    if($v ne "0")
	    {		
		push(@res,$v."x".$restmp[$j]);
		push(@res,$v."x!*".$restmp[$j]);
		push(@res,$v."x!".$restmp[$j]);
		push(@res,$v."x*".$restmp[$j]);
	    }
	}
	
	return @res;	
    }


    #Only valid SS are returned    
    my @resF = ();

    # Onlid valid SS are returned
    my @res=&__genSSFromContain_any($_[0],$_[1],$_[2]);
    
    for (my $i = 0; $i < scalar @res; $i ++) {		  
	&common::displayComputingPrompt();	   
	my $subtest=$res[$i];
	my @resi=&__genSSFromContain_multisync_in($subtest);
	for(my $j=0; $j < scalar @resi; $j++)
	{
	    &common::displayComputingPrompt();
	    if (&isValid($resi[$j],-1)==1) {
		push(@resF,$resi[$j]);			    
	    } elsif ($SSWAP_DEBUG>=1) {
		print "== SSWAP::__genSSFromContain_multisync : ".$resi[$j]." => Not valid.\n";
	    }									 	    		  
	}
    }

    &common::hideComputingPrompt();	    
    return @resF;

}

sub printSSListHTML
{    
    my $flist= $_[0];
    my $flistgen = '';
    my $f = $_[1].".html";    
    my $fjml = $_[1];
    my $fjmlheight = $_[1]."_lowHeight";
    my $fjmlheightJL = $_[1]."_lowHeightJL";
    my $newflist = $_[1].".txt";
    my $newflistheight = $_[1]."_lowHeight.txt";
    my $newflistheightJL = $_[1]."_lowHeightJL.txt";
    my $title = $_[2];
    my $opt = $_[3];   # IF set to -1, simplify the siteswap and add a column without simplification.

    my $simpl_list = 'N';               # Simplification SS List
    my $lower_height_list = 'N';        # Lower Heights in SS, i.e keep tempo but add extra Holding time
    # Lower Heights in SS for Juggling Compatibility,
    # i.e keep tempo but add extra Holding time (only 1x, 2 combinations)
    my $lower_height_list_JL = 'N';
    my $min_heigh_same_hand = 3;
    my $freeBeat = 1;
    
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)  

    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-V:s" => \$simpl_list,
				    "-L:s" => \$lower_height_list,
				    "-J:s" => \$lower_height_list_JL,
				    "-F:i" => \$freeBeat,
				    "-M:i" => \$min_heigh_same_hand,
				    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
				    "-B:s" => \$reversible_check,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,

	);
    

    my $num = 1;
    while (-e "$conf::RESULTS/".$f || -e "$conf::RESULTS/".$fjml.".jml" || -e "$conf::RESULTS/".$newflist
	   || -e "$conf::RESULTS/".$fjmlheight.".jml" || -e "$conf::RESULTS/".$newflistheight
	   || -e "$conf::RESULTS/".$fjmlheightJL.".jml" || -e "$conf::RESULTS/".$newflistheightJL	   
	)
    {
	$f = $_[1]."-".$num.".html";
	$fjml = $_[1]."-".$num;
	$fjmlheight = $_[1]."-".$num."_lowHeight";
	$fjmlheightJL = $_[1]."-".$num."_lowHeightJL";
	$newflist = $_[1]."-".$num.".txt";
	$newflistheight = $_[1]."-".$num."_lowHeight.txt";
	$newflistheightJL = $_[1]."-".$num."_lowHeightJL.txt";
	$num ++;
    }
    
    my $cpt = 1;
    my $pics="pics_png.png";
    my $pics_true="pics_green_tick.png";
    my $pics_false="pics_red_negative.png";
    copy("./data/pics/".$pics,$conf::RESULTS."/".$pics);
    copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);
    copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);

    &common::gen_HTML_head1($f,$title);

    my @opts_l = split('-',uc($_[3]));
    my $opts = '';
    for(my $i = 1; $i < scalar @opts_l; $i++)
    {
	if(uc($opts_l[$i]) !~ m/V/ && uc($opts_l[$i]) !~ m/L/ && uc($opts_l[$i]) !~ m/J/ && uc($opts_l[$i]) !~ m/F/ && uc($opts_l[$i]) !~ m/M/)
	{
	    $opts .= '-'.$opts_l[$i];
	}
    }
    
    # Generate a file with the ss list if no file is provided as input
    if($flist eq '-1' || $flist eq '')
    {
	my $now = strftime('%Y%m%d%H%M%S',localtime);	
	$flistgen = "../".$conf::TMPDIR."/printSSListHTML-".$now.".txt"; 
	&printSSList(\@{$_[4]},$opts, $flistgen);
	$flist = $conf::RESULTS.'/'.$flistgen;
    }

    else
    {
	# Update the input file if options are presents
	if($opts ne '')
	{
	    my $now = strftime('%Y%m%d%H%M%S',localtime);	
	    $flistgen = "../".$conf::TMPDIR."/printSSListHTML-".$now.".txt";
	    &printSSList("",$opts, $flistgen,$flist);
	    $flist = $conf::RESULTS.'/'.$flistgen;
	}
    }
    
    open(FILEIN, '<', $flist) || die ("$lang::MSG_GENERAL_ERR1 <$flist>") ;
    open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
    open(FILELIST, '>', "$conf::RESULTS/$newflist") or die ("$lang::MSG_GENERAL_ERR1 <$newflist> $lang::MSG_GENERAL_ERR1b") ;
    if(uc($lower_height_list) eq 'Y')
    {
	open(FILELISTHEIGHT, '>', "$conf::RESULTS/$newflistheight") or die ("$lang::MSG_GENERAL_ERR1 <$newflistheight> $lang::MSG_GENERAL_ERR1b") ;
    }
    if(uc($lower_height_list_JL) eq 'Y')
    {
	open(FILELISTHEIGHTJL, '>', "$conf::RESULTS/$newflistheightJL") or die ("$lang::MSG_GENERAL_ERR1 <$newflistheightJL> $lang::MSG_GENERAL_ERR1b") ;
    }
    
    print HTML "\n";
    print HTML "<BODY>\n";
    print HTML "<p>&nbsp;</p><h1>".$title."</h1><p>&nbsp;</p>\n";    
    print HTML "\n\n\n";    
    
    print HTML "<p><table border=\"0\" >"."\n";
    print HTML "<tr><td COLSPAN=1></td>"."\n";
    print HTML "<td class=table_header>"."Siteswaps"."</td>"."\n";	    	    
    print HTML "<td class=table_header>"."Ladder Diagrams"."</td>"."\n";
    print HTML "<td class=table_header>"."Valid"."</td>"."\n";
    if(uc($simpl_list) eq 'Y')
    {
	print HTML "<td class=table_header>"."Orig. SS"."</td>"."\n";
    }
    if(uc($lower_height_list) eq 'Y')
    {
	print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Extra Holding Time"."</td>"."\n";
    }    
    if(uc($lower_height_list_JL) eq 'Y')
    {
	print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Split Extra Holding Time for JL"."</td>"."\n";
    }    
    print HTML "</tr>"."\n";

    while ( my $ss = <FILEIN> ) {  	
	$ss =~ s/\s+//g;

	if($ss ne '' && $ss !~ m/=>/)
	{
	    print HTML "<tr>"."\n";	    	    
	    print HTML "<td class=table_header>$cpt</td>"."\n";
	    
	    my $nss = $ss;
	    $nss =~ s/\*/+/g;
	    my $simpl_ss = $ss;
	    if(uc($simpl_list) eq 'Y')
	    {
		$simpl_ss = &simplify($ss,-1);
	    }
	    my $ss_height = '';
	    my $nss_height = '';
	    my $ss_height_JL = '';
	    my $nss_height_JL = '';
	    
	    print "\n\n\n";
	    print colored [$common::COLOR_RESULT], "==== Diagram : ".$ss."\n";
	    &draw($simpl_ss, $nss.".png","-M 0 -E E");
	    print FILELIST $simpl_ss."\n";	 
	    print HTML "<td class=table_content>".$simpl_ss."</td>"."\n";
	    print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	    if(&isValid($ss,-1) > 0)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></a></td>"."\n"; 
	    }
	    if(uc($simpl_list) eq 'Y')
	    {
		print HTML "<td class=table_content>".$ss."</td>"."\n";
	    }
	    if(uc($lower_height_list) eq 'Y')
	    {
		$ss_height = &LADDER::toMultiSync(&lowerHeightOnTempo($ss,"-F $freeBeat -M $min_heigh_same_hand",-1),3,-1);
		$nss_height = $ss_height;
		$nss_height =~ s/\*/+/g;
		my $ss_height_simpl = &simplify($ss_height, -1);
		my $nss_height_simpl = $ss_height_simpl;
		$nss_height_simpl =~ s/\*/+/g;
		print FILELISTHEIGHT $ss_height_simpl."\n";	 
		
		if(&isEquivalent($ss,$ss_height,'','-1') <0)
		{
		    print HTML "<td class=table_content>".$ss_height_simpl."</td>"."\n";		
		    &draw($ss_height_simpl, $nss_height_simpl.".png","-M 0 -E E");
		    print HTML "<td class=table_content><a href=\"".$nss_height_simpl.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss_height_simpl.".png\" width=\"25\"/></a></td>"."\n";
		    if(&isValid($ss_height,-1) > 0)
		    {
			print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
		    }
		    else
		    {
			print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></a></td>"."\n"; 
		    }
		}
		else
		{
		    print HTML "<td class=table_content>&nbsp;</td>";
		    print HTML "<td class=table_content>&nbsp;</td>";
		    print HTML "<td class=table_content>&nbsp;</td>";
		}

	    }
	    
	    if(uc($lower_height_list_JL) eq 'Y')
	    {
		$ss_height_JL = &LADDER::toMultiSync(&lowerHeightOnTempo($ss,"-J Y -F $freeBeat -M $min_heigh_same_hand",-1),3,-1);
		$nss_height_JL = $ss_height_JL;
		$nss_height_JL =~ s/\*/+/g;
		my $ss_height_JL_simpl = &simplify($ss_height_JL, -1);
		my $nss_height_JL_simpl = $ss_height_JL_simpl;
		$nss_height_JL_simpl =~ s/\*/+/g;
		print FILELISTHEIGHTJL $ss_height_JL_simpl."\n";	 
		
		if((uc($lower_height_list) eq 'Y' && &isEquivalent($ss_height,$ss_height_JL,'','-1') <0) || (uc($lower_height_list) eq 'N' && &isEquivalent($ss,$ss_height_JL,'','-1') <0))
		{		
		    print HTML "<td class=table_content>".$ss_height_JL_simpl."</td>"."\n";
		    &draw($ss_height_JL_simpl, $nss_height_JL_simpl.".png","-M 0 -E E");
		    print HTML "<td class=table_content><a href=\"".$nss_height_JL_simpl.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss_height_JL_simpl.".png\" width=\"25\"/></a></td>"."\n";
		    if(&isValid($ss_height_JL,-1) > 0)
		    {
			print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
		    }
		    else
		    {
			print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></a></td>"."\n"; 
		    }
		}
		else
		{
		    print HTML "<td class=table_content>&nbsp;</td>";
		    print HTML "<td class=table_content>&nbsp;</td>";
		    print HTML "<td class=table_content>&nbsp;</td>";
		}
	    }
	    print HTML "</tr>"."\n";
	    $cpt++;
	}
    }
    
    close(FILEIN); 
    if($_[0] eq '-1' && $SSWAP_DEBUG <= 0)
    {
	unlink $flistgen;
    }
    
    close(FILELIST);
    if(uc($lower_height_list) eq 'Y')
    {
	close(FILELISTHEIGHT);
    }
    if(uc($lower_height_list_JL) eq 'Y')
    {
	close(FILELISTHEIGHTJL);
    }
    
    print HTML "<tr>"."\n";
    print HTML "<td class=table_header>JML File</td>";

    $title =~ s/-//g;
    
    &printSSList('',"-t \'".$title."\'","JML:".$fjml,"$conf::RESULTS/$newflist");
    print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjml.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjml.".jml"."\" width=\"25\"/></a>"."</td>\n";    

    if(uc($simpl_list) eq 'Y')
    {
	print HTML "<td class=table_content>&nbsp;</td>";
    }
    
    if(uc($lower_height_list) eq 'Y')
    {
	&printSSList('',"-t \'".$title."\'","JML:".$fjmlheight,"$conf::RESULTS/$newflistheight");
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjmlheight.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjmlheight.".jml"."\" width=\"25\"/></a>"."</td>\n";    
    }

    if(uc($lower_height_list_JL) eq 'Y')
    {
	&printSSList('',"-t \'".$title."\'","JML:".$fjmlheightJL,"$conf::RESULTS/$newflistheightJL");
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjmlheightJL.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjmlheightJL.".jml"."\" width=\"25\"/></a>"."</td>\n";    
    }

    print HTML "</tr>"."\n";

    print HTML "<tr>"."\n";
    print HTML "<td class=table_header>TXT File</td>";

    print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflist."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflist."\" width=\"25\"/></a>"."</td>\n";    

    if(uc($simpl_list) eq 'Y')
    {
	print HTML "<td class=table_content>&nbsp;</td>";
    }

    if(uc($lower_height_list) eq 'Y')
    {
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistheight."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistheight."\" width=\"25\"/></a>"."</td>\n";
    }

    if(uc($lower_height_list_JL) eq 'Y')
    {
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistheightJL."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistheightJL."\" width=\"25\"/></a>"."</td>\n";
    }

    print HTML "</tr>"."\n";
    print HTML "</table></p>"."\n";
    
    print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module SSWAP $SSWAP_VERSION --</p><p>&nbsp;</p>\n";
    print HTML "</BODY>\n";
    close HTML;

    print colored [$common::COLOR_RESULT], "\n\n====> ".($cpt-1)." Siteswaps Generated\n ";

}



sub printSSList
{
    # $_[0] : Ref on SS List 
    # $_[1] : Options
    # $_[2] : Output File
    # $_[3] : Input File if $_[0] is ""; 
    my $f = "";
    my $title = ""; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)  
    
    my $ret = &GetOptionsFromString(uc($_[1]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
				    "-B:s" => \$reversible_check,
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);

    
    my @in = @_;
    my @res = ();

    if($_[0] ne "")
    {
	@res = @{$_[0]};
    }
    else
    {
	# get Siteswaps from input File
	open(my $fd,"< $_[3]") or die ("$lang::MSG_GENERAL_ERR1 <$_[3]>");
	my $line="";
	while( defined( $line = <$fd> ) ) {
	    chomp $line;
	    $line =~ s/\s+//g;	
	    if($line ne "")
	    {
		push(@res,$line);
	    }
	}
	$in[0]=\@res;
	pop @in;
	if(scalar @in == 3 && $_[2] eq "")
	{
	    pop @in;
	}
    }

    my $pwd = cwd();
    if (scalar @in == 3 && $_[2] ne "-1") {
	my $f = $_[2];
	if ("JML:"=~substr(uc($_[2]),0,4)) {	

	    $f = substr($_[2],4);
	    open(FILE_JML,"> $conf::RESULTS/$f.jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;

	    @res = &printSSListWithoutHeaders(@in);
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif ("SSHTML:"=~substr(uc($_[2]),0,7)) {	
	    $f = substr($_[2],7);	    
	    open(FILE,"> $conf::RESULTS/$f.html") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;		
	    close(FILE);

	    &printSSListInfoHTMLWithoutHeaders(@in);
	    if ($conf::jtbOptions_r == 1)
	    {
		if ($common::OS eq "MSWin32") {
		    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f.html");
		} else {
		    # Unix-like OS
		    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f.html &");	    
		}
	    }
	    # We can leave the function now ...
	    return;
	}
	else
	{
	    @res = &printSSListWithoutHeaders(@in);
	}

    }
    else
    {
	@res = &printSSListWithoutHeaders(@in);
    }    

    return \@res;
}


sub printSSListInfoHTMLWithoutHeaders
{
    my @ss_list=@{$_[0]};

    my $f = "";
    my $opts = "";
    my $title = ""; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)    
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    
    my $symetry_add = '';

    my $ret = &GetOptionsFromString(uc($_[1]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
				    "-A:s" => \$symetry_add,          #Not Considered here. For compatiblity with genSSFromThrows
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);
    

    if (scalar @_ > 2 && "SSHTML:"=~substr(uc($_[2]),0,7)) 
    {		
	$f = substr($_[2],7).".html";
	$opts = $_[1];
    }    
    else
    {	
	return;
    }

    my $pics_png="pics_png.png";
    my $pics_info="pics_info.png";
    my $pics_true="pics_green_tick.png";
    my $pics_false="pics_red_negative.png";

    if($order_list != 0)
    {
	@ss_list=sort(@ss_list);
    }
    
    if($remove_redundancy == 1)
    {
	my @ss_list_tmp = ();
	for(my $i=0; $i < scalar @ss_list;$i++)
	{
	    &common::displayComputingPrompt();	    
	    my $drap = -1;
	    my $checking_process = 1;
	    
	    if(uc($ground_check) eq "Y")
	    {
		if (&getSSstatus($ss_list[$i],-1) ne "GROUND")
		{
		    $checking_process = -1;
		}
	    }
	    
	    if($checking_process == 1 && uc($prime_check) eq "Y")
	    {
		if(&isPrime($ss_list[$i],-1) != 1)
		{
		    $checking_process = -1;
		}
	    }
	    
	    if($checking_process == 1 && uc($reversible_check) eq "Y")
	    {
		if(&isReversible($ss_list[$i],-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($scramblable_check) eq "Y")
	    {
		if(&isScramblable($ss_list[$i],'',-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($magic_check) eq "Y")
	    {
		if(&isFullMagic($ss_list[$i],-1) < 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($palindrome_check) eq "Y")
	    {
		if(&isPalindrome($ss_list[$i],-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($squeeze_check) eq "Y")
	    {
		if(&isSqueeze($ss_list[$i],-1) == 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1)
	    {
		for(my $j=0; $j < scalar @ss_list_tmp;$j++)
		{
		    &common::displayComputingPrompt();	    
		    my $subopts=" -c ".$color_check." -s ".$sym_check." -p ".$perm_check." ";
		    if(&isEquivalent($ss_list[$i],$ss_list_tmp[$j],$subopts,"-1")==1)
		    {
			if(&getSSstatus($ss_list_tmp[$j],-1) ne "GROUND" && &getSSstatus($ss_list[$i],-1) eq "GROUND")
			{
			    $ss_list_tmp[$j] = $ss_list[$i];
			}
			$drap = 1;
			last;
		    }
		}

		if($drap == -1)
		{
		    push(@ss_list_tmp,$ss_list[$i]);
		}
	    }	    	    
	}
	
	&common::hideComputingPrompt();	    
	@ss_list=@ss_list_tmp;
	# Again, since there may be some recent disorder
	if($order_list != 0)
	{
	    @ss_list=sort(@ss_list);
	}
    }

    elsif($remove_redundancy == 2)
    {
	my @ss_list_tmp = ();
	for(my $i=0; $i < scalar @ss_list;$i++)
	{
	    my $drap = -1;
	    for(my $j=0; $j < scalar @ss_list_tmp;$j++)
	    {
		&common::displayComputingPrompt();	    
		
		my $subopts=" -c ".$color_check." -s ".$sym_check." -p ".$perm_check." ";
		if(&isEquivalent($ss_list[$i],$ss_list_tmp[$j],$subopts,"-1")==1)
		{
		    $drap = 1;
		    last;
		}
	    }
	    if($drap==-1)
	    {
		my $checking_process = 1;
		if(uc($ground_check) eq "Y")
		{
		    if (&getSSstatus($ss_list[$i],-1) ne "GROUND")
		    {
			$checking_process = -1;
		    }
		}
		
		if($checking_process == 1 && uc($prime_check) eq "Y")
		{
		    if(&isPrime($ss_list[$i],-1) != 1)
		    {
			$checking_process = -1;
		    }
		}

		if($checking_process == 1 && uc($reversible_check) eq "Y")
		{
		    if(&isReversible($ss_list[$i],-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($scramblable_check) eq "Y")
		{
		    if(&isScramblable($ss_list[$i],'',-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($magic_check) eq "Y")
		{
		    if(&isFullMagic($ss_list[$i],-1) < 1)
		    {
			$checking_process = -1;			    
		    }
		}
		
		if($checking_process == 1 && uc($palindrome_check) eq "Y")
		{
		    if(&isPalindrome($ss_list[$i],-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($squeeze_check) eq "Y")
		{
		    if(&isSqueeze($ss_list[$i],-1) == 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1)
		{
		    push(@ss_list_tmp,$ss_list[$i]);
		}	    
		
	    }
	}

	&common::hideComputingPrompt();	    
	@ss_list=@ss_list_tmp;
    }
    
    else
    {
	my @ss_list_tmp = ();
	for(my $j=0; $j < scalar @ss_list;$j++)
	{
	    &common::displayComputingPrompt();	    

	    my $checking_process = 1;
	    if(uc($ground_check) eq "Y")
	    {
		if (&getSSstatus($ss_list[$j],-1) ne "GROUND")
		{
		    $checking_process = -1;
		}
	    }
	    
	    if($checking_process == 1 && uc($prime_check) eq "Y")
	    {
		if(&isPrime($ss_list[$j],-1) != 1)
		{
		    $checking_process = -1;
		}
	    }

	    if($checking_process == 1 && uc($reversible_check) eq "Y")
	    {
		if(&isReversible($ss_list[$j],-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($scramblable_check) eq "Y")
	    {
		if(&isScramblable($ss_list[$j],'',-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($magic_check) eq "Y")
	    {
		if(&isFullMagic($ss_list[$j],-1) < 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($palindrome_check) eq "Y")
	    {
		if(&isPalindrome($ss_list[$j],-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($squeeze_check) eq "Y")
	    {
		if(&isSqueeze($ss_list[$j],-1) == 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1)
	    {
		push(@ss_list_tmp,$ss_list[$j]);
	    }	    
	    
	    
	}   

	&common::hideComputingPrompt();	    
	@ss_list=@ss_list_tmp;	
	
	
    }
    
    if (uc($extra_info) eq "Y") {
	&common::gen_HTML_head1($f,$title);
	open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;	
	print HTML "<BODY>\n";
	print HTML "<p>&nbsp;</p><h1>".$title."</h1><p>&nbsp;</p><p>&nbsp;</p>"."\n";
	print HTML "<p><table border=\"0\" >"."\n";
	print HTML "<tr><td COLSPAN=2>"."</td>"."\n";
	print HTML "<td COLSPAN=21>"."&nbsp;</td>\n";
	print HTML "<td class=table_header COLSPAN=22>Symétrie"."</td>"."\n";    	    
	print HTML "<td class=table_header COLSPAN=22>Time-Reversed"."</td>"."\n";    	    	    
	print HTML "<td class=table_header COLSPAN=16>Multisynchrone"."</td>"."\n";    	    
	print HTML "<td class=table_header COLSPAN=1 ROWSPAN=2>Equivalence"."</td>"."\n";    	    
	print HTML "</tr>"."\n";
	print HTML "<tr><td COLSPAN=2></td>"."\n";	    	   
	print HTML "<td class=table_header>"."Ladder"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Validité"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Type"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Nb Obj."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Période"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Réduction/Période Min."."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Status/Init."."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite"."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite Aggr."."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header>"."Etats (SS Réduit)"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Premier"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Reversible"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Scramblable"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";
	print HTML "<td class=table_header>"."Grille 3-Couches"."</td>"."\n"; 
	print HTML "<td class=table_header>"."Info"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Stack Notation"."</td>"."\n";	    	    

	print HTML "<td class=table_header>"."Symétrie"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Equivalence"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Ladder"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Validité"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Type"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Nb Obj."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Période"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Réduction/Période Min."."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Status/Init."."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite"."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite Aggr."."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header>"."Etats (SS Réduit)"."</td>"."\n";	    	    	    	    	    	    
	print HTML "<td class=table_header>"."Premier"."</td>"."\n";
	print HTML "<td class=table_header>"."Reversible"."</td>"."\n";
	print HTML "<td class=table_header>"."Scramblable"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";
	print HTML "<td class=table_header>"."Info"."</td>"."\n";	    	    

	print HTML "<td class=table_header >"."Time-Reversed"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Equivalence"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Ladder"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Validité"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Type"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Nb Obj."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Période"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Réduction/Période Min."."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Status/Init."."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite"."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite Aggr."."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header>"."Etats (SS Réduit)"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Premier"."</td>"."\n";
	print HTML "<td class=table_header>"."Reversible"."</td>"."\n";
	print HTML "<td class=table_header>"."Scramblable"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Info"."</td>"."\n";	    	    

	print HTML "<td class=table_header >"."Multisync."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Multisync class."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Validité"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Type"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Nb Obj."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Période"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Réduction/Période Min."."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Status/Init."."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite"."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite Aggr."."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Info"."</td>"."\n";	    	    
	print HTML "</tr>"."\n";
	
	copy("./data/pics/".$pics_png,$conf::RESULTS."/".$pics_png);	  	
	copy("./data/pics/".$pics_info,$conf::RESULTS."/".$pics_info);	  	
	copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);	  	
	copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);	  	
    }
    
    else {
	&common::gen_HTML_head1($f,lc($title));
	open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;	
	print HTML "<BODY>\n";
	print HTML "<p>&nbsp;</p><p>&nbsp;</p><h1>".$title."</h1><p>&nbsp;</p><p>&nbsp;</p>"."\n";
	print HTML "<p><table border=\"0\" >"."\n";
	print HTML "<tr><td COLSPAN=2></td>"."\n";	    	    
	print HTML "<td class=table_header>"."Validité"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Type"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Nb Obj."."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Période"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Réduction/Période Min."."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Status/Init."."</td>"."\n";
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite"."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header COLSPAN=2>"."Nb/N° => Orbite Aggr."."</td>"."\n";	    	    	    	    
	print HTML "<td class=table_header>"."Etats"."</td>"."\n";	    	   
	print HTML "<td class=table_header>"."Premier"."</td>"."\n";
	print HTML "<td class=table_header>"."Reversible"."</td>"."\n";
	print HTML "<td class=table_header>"."Scramblable"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Ladder"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Grille 3-Couches"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Info"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=3>"."Symétrie"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=3>"."Time-Reversed"."</td>"."\n";	    	    
	print HTML "<td class=table_header COLSPAN=3>"."Multisync."."</td>"."\n";	    	    
	print HTML "</tr>"."\n";
	
	copy("./data/pics/".$pics_png,$conf::RESULTS."/".$pics_png);	  	
	copy("./data/pics/".$pics_info,$conf::RESULTS."/".$pics_info);	  	
	copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);	  	
	copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);	  	
    }

    my $nb=0;
    my $multisync_ss = '';

    # Sort by number of objects or period if asked
    if($order_list == 2 || $order_list == 3)
    {
	my %hashTableSS =();
	my $nbIter=-1;
	for(my $i = 0; $i < scalar @ss_list; $i++)
	{
	    if($order_list == 2)
	    {
		$nbIter = &getObjNumber($ss_list[$i],-1);
	    }
	    else
	    {
		$nbIter = &getPeriod($ss_list[$i],-1);
	    }

	    if (exists( $hashTableSS{$nbIter} ) ) {
		$hashTableSS{$nbIter} = $hashTableSS{$nbIter}.":".$ss_list[$i];			    
	    } else {
		$hashTableSS{$nbIter} = $ss_list[$i];			    
	    }					
	}
	
	my @ss_list_tmp = ();	
	foreach my $i (sort sort_num keys (%hashTableSS)) 
	{
	    push(@ss_list_tmp,split(/:/,$hashTableSS{$i}));
	}
	
	@ss_list=@ss_list_tmp;
    }
    
    foreach my $ss (@ss_list) {	
	# With some siteswaps we got problem in generating the SS Async Diagram in Graphviz 2.28 and prior.
	# This was because of Multiplexes with the same height. A Hack in LADDER::draw corrects some of them but it is does not work in all cases.
	# Then sometimes just change the label position to have it working ;-( . A few bugs still in Graphviz
	#   if ($ss eq "[222]0")         #  ==> Print in Ladder Mode 
	#    || $ss eq "4[22]0[32]32"      ==> Correct      
	#    || $ss eq "[22]2"             ==> Correct
	#    || $ss eq "[22]2[23]22"       ==> Correct
	#    || $ss eq "[44][22]3"         ==> Correct
	#    || $ss eq "[54][22]2"         ==> Correct
	#    || $ss eq "[64][62]1[22]2"    ==> Correct
	#    || $ss eq "[75][22]2"	   ==> Correct
	#    || $ss eq "[776]20[76]20[76][22]0" ==> Correct
	#{
	#    last;
	#    next;
	#}
	
	$nb++;
	my $nss_orig = lc($ss);
	
	$nss_orig =~ s/\s+//g;	
	$nss_orig =~ s/\*/+/g;
	my $nss = $nss_orig;

	####################### Classical Part	
	print HTML "<tr>"."\n";	    	    
	print HTML "<td class=table_header>$nb</td>"."\n";
	print HTML "<td class=table_header><strong>$ss</strong></td>"."\n";
	
	&LADDER::draw($ss,$nss."-ladder.png");

	if(uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";
	}
	
	if(&isValid($ss,-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	
	print HTML "<td class=table_content>".&getSSType($ss,-1)."</td>\n";
	print HTML "<td class=table_content>".&getObjNumber($ss,-1)."</td>\n";
	print HTML "<td class=table_content>".&getPeriod($ss,-1)."</td>\n";
	
	if(&shrink($ss,-1) ne $ss)
	{
	    print HTML "<td class=table_content> <font color=\"red\">".&shrink($ss,-1)."</font></td>\n";
	}
	else
	{
	    print HTML "<td class=table_content>".&shrink($ss,-1)."</td>\n";
	}
	
	print HTML "<td class=table_content>".&getPeriodMin($ss,-1)."</td>\n";
	
	my($status1, $status2) = &getSSstatus($ss,-2);
	print HTML "<td class=table_content>".$status1."</td>\n";
	print HTML "<td class=table_content>".$status2."</td>\n";
	
	my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbits($ss,2,-1);
	my %orbits_hash = %{$orbits_hash_aggr_tmp};
	print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	print HTML "<td class=table_content><div align=\"left\">";
	foreach my $i (sort keys (%orbits_hash)) {
	    print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	}
	print HTML "</div></td>\n";	

	my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbitsAggr($ss,2,-1);
	my %orbits_hash = %{$orbits_hash_aggr_tmp};
	print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	print HTML "<td class=table_content><div align=\"left\">";
	foreach my $i (sort keys (%orbits_hash)) {
	    print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	}
	print HTML "</div></td>\n";	

	my @states=&getStates(&shrink($ss,-1),-1);
	if (scalar @states>0)
	{
	    print HTML "<td class=table_content><div align=\"left\">".join(';',@states)."</div></td>\n";
	}
	else
	{
	    print HTML "<td class=table_content><div align=\"left\"></div></td>";
	}

	if(&isPrime($ss,-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	elsif(&isPrime($ss,-1)==-1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	else
	{
	    print HTML "<td class=table_content></td>"."\n"; 
	}
	
	if(&isReversible($ss,-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	elsif(&isReversible($ss,-1)==-1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	else
	{
	    print HTML "<td class=table_content></td>"."\n"; 
	}

	if(&isScramblable($ss,'',-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	elsif(&isScramblable($ss,'',-1)==-1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	else
	{
	    print HTML "<td class=table_content></td>"."\n"; 
	}

	if($ss eq "[222]0")
	{
	    &draw($ss,$nss.".png","-m 0 -l n");
	}
	else
	{
	    &draw($ss,$nss.".png");
	}
	print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	
  	if (uc($extra_info) eq "N") {
	    print HTML "<td class=table_content><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";
	}

	&HTN::drawGrid($ss,$nss."-3layersGrid.png");	  
	print HTML "<td class=table_content><a href=\"".$nss."-3layersGrid.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-3layersGrid.png\" width=\"25\"/></a></td>"."\n";	

	&getInfo($ss,$nss."-info.txt");
	print HTML "<td class=table_content><a href=\"".$nss."-info.txt\" target=\"_blank\"><img src=\"".$pics_info."\" alt=\"".$nss."-info.txt\" width=\"25\"/></a></td>"."\n";	

	if (uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header>".&toStack($ss)."</td>\n";	    
	}
	

	####################### Sym Part
	$nss = $nss_orig."-sym";
	my $sym_ss = "";

	if($ss eq "[222]0")
	{
	    $sym_ss = &symDiag($ss,$nss.".png","-m 0");	    
	}
	else
	{
	    $sym_ss = &sym($ss,-1);
	    &symDiag($ss,$nss.".png");
	}
	if (uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header>".$sym_ss."</td>\n";	    
	}
	else {
	    &LADDER::sym($ss,$nss."-ladder.png","-S 1");
	    print HTML "<td class=table_content>".$sym_ss."</td>\n";	    
	    print HTML "<td class=table_content><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";
	}

	if(&isEquivalent($ss,$sym_ss,"",-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	if (uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header>".&LADDER::sym($ss,$nss."-ladder.png")."</td>\n";	    
	    print HTML "<td class=table_header><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";
	    
	    if(&isValid($sym_ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    
	    print HTML "<td class=table_content>".&getSSType($sym_ss,-1)."</td>\n";
	    
	    print HTML "<td class=table_content>".&getObjNumber($sym_ss,-1)."</td>\n";
	    
	    print HTML "<td class=table_content>".&getPeriod($sym_ss,-1)."</td>\n";
	    
	    if(&shrink($sym_ss,-1) ne $sym_ss)
	    {
		print HTML "<td class=table_content> <font color=\"red\">".&shrink($sym_ss,-1)."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content>".&shrink($sym_ss,-1)."</td>\n";
	    }
	    
	    print HTML "<td class=table_content>".&getPeriodMin($sym_ss,-1)."</td>\n";
	    
	    my($status1, $status2) = &getSSstatus($sym_ss,-2);
	    print HTML "<td class=table_content>".$status1."</td>\n";
	    print HTML "<td class=table_content>".$status2."</td>\n";
	    
	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbits($sym_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";	

	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbitsAggr($sym_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";	
	    
	    my @states=&getStates(&shrink($ss,-1),-1);
	    if (scalar @states>0)
	    {
		print HTML "<td class=table_content><div align=\"left\">".join(';',@states)."</div></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content><div align=\"left\"></div></td>";
	    }

	    if(&isPrime($ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isPrime($ss,-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    if(&isReversible($ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isReversible($ss,-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    if(&isScramblable($ss,'',-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isScramblable($ss,'',-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";

	    &getInfo($sym_ss,$nss."-info.txt");
	    print HTML "<td class=table_content><a href=\"".$nss."-info.txt\" target=\"_blank\"><img src=\"".$pics_info."\" alt=\"".$nss."-info.txt\" width=\"25\"/></a></td>"."\n";	

	}	

	####################### Inv Part
	$nss = $nss_orig."-inv";
	my $inv_ss = '';
	if($ss eq "[222]0")
	{
	    $inv_ss = &timeRevDiag($ss,$nss.".png","-m 0");
	}
	else
	{
	    $inv_ss = &timeRev($ss,-1);
	    &timeRevDiag($ss,$nss.".png");
	}
	
	if (uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header>".$inv_ss."</td>\n";	    
	}
	else
	{
	    print HTML "<td class=table_content>".$inv_ss."</td>\n";	    
	    &LADDER::inv($ss,$nss."-ladder.png","-S 1");
	    print HTML "<td class=table_content><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";
	}
	
	if(&isEquivalent($ss,$inv_ss,"",-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}	   	
	
	if (uc($extra_info) eq "Y") {
	    print HTML "<td class=table_header>".&LADDER::inv($ss,$nss."-ladder.png")."</td>\n";	    
	    print HTML "<td class=table_header><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";	
	    
	    
	    if(&isValid($inv_ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    
	    print HTML "<td class=table_content>".&getSSType($inv_ss,-1)."</td>\n";
	    
	    print HTML "<td class=table_content>".&getObjNumber($inv_ss,-1)."</td>\n";
	    
	    print HTML "<td class=table_content>".&getPeriod($inv_ss,-1)."</td>\n";
	    
	    if(&shrink($inv_ss,-1) ne $inv_ss)
	    {
		print HTML "<td class=table_content> <font color=\"red\">".&shrink($inv_ss,-1)."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content>".&shrink($inv_ss,-1)."</td>\n";
	    }
	    
	    print HTML "<td class=table_content>".&getPeriodMin($inv_ss,-1)."</td>\n";
	    
	    my($status1, $status2) = &getSSstatus($inv_ss,-2);
	    print HTML "<td class=table_content>".$status1."</td>\n";
	    print HTML "<td class=table_content>".$status2."</td>\n";
	    
	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbits($inv_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";	

	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbitsAggr($inv_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";	
	    
	    my @states=&getStates(&shrink($ss,-1),-1);
	    if (scalar @states>0)
	    {
		print HTML "<td class=table_content><div align=\"left\">".join(';',@states)."</div></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content><div align=\"left\"></div></td>";
	    }

	    if(&isPrime($ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isPrime($ss,-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    if(&isReversible($ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isReversible($ss,-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    if(&isScramblable($ss,'',-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    elsif(&isScramblable($ss,'',-1)==-1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    else
	    {
		print HTML "<td class=table_content></td>"."\n"; 
	    }

	    if($ss eq "[222]0")
	    {
		&draw($inv_ss,$nss.".png","-m 0 -l n");
	    }
	    print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	    
	    &getInfo($inv_ss,$nss."-info.txt");
	    print HTML "<td class=table_content><a href=\"".$nss."-info.txt\" target=\"_blank\"><img src=\"".$pics_info."\" alt=\"".$nss."-info.txt\" width=\"25\"/></a></td>"."\n";       	
	}	
	
	####################### Multisync Part
	$nss = $nss_orig."-multisync";
	
	my $multisync_ss = &LADDER::toMultiSync($ss, 0, $nss."-ladder.png");
	my $multisync_classical = &LADDER::toMultiSync($ss, 1,"-1");
	
	if (uc($extra_info) eq "Y") {	    
	    if(&isEquivalent($ss,$multisync_ss,"",-1) == -1)
	    {
		print HTML "<td class=table_header> <font color=\"red\">".$multisync_ss."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_header>".$multisync_ss."</td>\n";
	    }
	    
	    if(&isEquivalent($ss,$multisync_classical,"",-1) == -1)
	    {
		print HTML "<td class=table_header> <font color=\"red\">".$multisync_classical."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_header>".$multisync_classical."</td>\n";
	    }
	    
	    if(&isValid($multisync_ss,-1)==1)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	    
	    print HTML "<td class=table_content>".&getSSType($multisync_ss,-1)."</td>\n";
	    
	    print HTML "<td class=table_content>".&getObjNumber($multisync_ss,-1)."</td>\n";

	    print HTML "<td class=table_content>".&getPeriod($multisync_ss,-1)."</td>\n";

	    if(&shrink($multisync_ss,-1) ne $multisync_ss)
	    {
		print HTML "<td class=table_content> <font color=\"red\">".&shrink($multisync_ss,-1)."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content>".&shrink($multisync_ss,-1)."</td>\n";
	    }

	    print HTML "<td class=table_content>".&getPeriodMin($multisync_ss,-1)."</td>\n";

	    my($status1, $status2) = &getSSstatus($multisync_ss,-2);
	    print HTML "<td class=table_content>".$status1."</td>\n";
	    print HTML "<td class=table_content>".$status2."</td>\n";

	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbits($multisync_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";

	    my ($orbits_hash_aggr_tmp,$orbits_hash_tmp,$orbits_time_tmp) = &getOrbitsAggr($multisync_ss,2,-1);
	    my %orbits_hash = %{$orbits_hash_aggr_tmp};
	    print HTML "<td class=table_content>".(scalar keys %orbits_hash)."</td>\n";
	    print HTML "<td class=table_content><div align=\"left\">";
	    foreach my $i (sort keys (%orbits_hash)) {
		print HTML $i." =&gt ".$orbits_hash{$i}."<br/>\n";
	    }
	    print HTML "</div></td>\n";

	    print HTML "<td class=table_content><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";

	    &getInfo($multisync_ss,$nss."-info.txt");
	    print HTML "<td class=table_content><a href=\"".$nss."-info.txt\" target=\"_blank\"><img src=\"".$pics_info."\" alt=\"".$nss."-info.txt\" width=\"25\"/></a></td>"."\n";	
	}
	else
	{
	    if(&isEquivalent($ss,$multisync_ss,"",-1) == -1)
	    {
		print HTML "<td class=table_content> <font color=\"red\">".$multisync_ss."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content>".$multisync_ss."</td>\n";
	    }
	    
	    if(&isEquivalent($ss,$multisync_classical,"",-1) == -1)
	    {
		print HTML "<td class=table_content> <font color=\"red\">".$multisync_classical."</font></td>\n";
	    }
	    else
	    {
		print HTML "<td class=table_content>".$multisync_classical."</td>\n";
	    }
	    
	    print HTML "<td class=table_content><a href=\"".$nss."-ladder.png\" target=\"_blank\"><img src=\"".$pics_png."\" alt=\"".$nss."-ladder.png\" width=\"25\"/></a></td>"."\n";	  
	}


	####################### Comparaison Part
	
	if (uc($extra_info) eq "Y") {
	    if(&isEquivalent($ss,$sym_ss,"",-1)==1 && &isEquivalent($ss,$inv_ss,"",-1)==1 && &isEquivalent($ss,$multisync_ss,"",-1)==1)
	    {
		print HTML "<td class=table_header><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_header><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	    }	   	
	}		


    }

    print HTML "</tr>"."\n";	    	    
    
    print HTML "</table></p>"."\n";
    print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module SSWAP $SSWAP_VERSION --</p><p>&nbsp;</p>\n";
    print HTML "</BODY>\n";
    close HTML;    
}


sub printSSListWithoutHeaders
{
    my @res = @{$_[0]};
    my $nbres=scalar @res;
    my $title = ""; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $validity_check = "Y";   # Consider Only Valid siteswap. If N all others parameters are left aside.
    my $symetry_add = '';
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)    
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    
    my $ret = &GetOptionsFromString(uc($_[1]),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
				    "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-B:s" => \$reversible_check,
    				    "-D:s" => \$scramblable_check,
				    "-N:s" => \$palindrome_check,
				    "-V:s" => \$validity_check,
      				    "-A:s" => \$symetry_add,          #Not Considered here. For compatiblity with genSSFromThrows
				    "-Z:s" => \$magic_check,
				    "-Q:s" => \$squeeze_check,
	);    
    
    my $nbObjects = 0;
    my @resF = ();
    my %hashTableSS = ();

    my $xmarge = 30;
    
    if (scalar @_ == 3 && $_[2] ne "-1") {
	my $f = $_[2];
	if ("JML:"=~substr(uc($_[2]),0,4)) {
	    $f=substr($_[2],4).".jml";
	}       
	open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
    }	

    if (uc($validity_check) eq 'N') {
	if (scalar @_ == 3 && $_[2] ne "-1") {	    
	    if ("JML:"=~substr(uc($_[2]),0,4)) {		
		for (my $i = 0; $i < scalar @res; $i++) {
		    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
		    {		
			print FILE "<line display=\'".$res[$i]."\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
			print FILE ";colors=$balls_colors\" />\n";
		    }
		    else
		    {
			print FILE "<line display=\'".$res[$i]."\' notation=\"siteswap\">\n";
			print FILE "pattern=$res[$i]";
			print FILE ";colors=$balls_colors\n"; 
			print FILE "</line>\n";				
		    }
		}

		print FILE "<line display=\"\" />\n";
		print FILE "<line display=\"   [ => ".(scalar @res)." Siteswap(s) ]"."\"/>\n";     
		print FILE "<line display=\"\" />\n";
		print FILE "<line display=\"----------- Creation : JugglingTB (Module SSWAP $SSWAP_VERSION)\" />\n";		
		print FILE "</patternlist>\n";
		print FILE "</jml>\n";
	    }
	    else
	    {
		for (my $i = 0; $i < scalar @res; $i++) {
		    print FILE $res[$i]."\n";
		}
		print FILE " [ => ".(scalar @res)." Siteswap(s) ]\n";
		print FILE "----------- Creation : JugglingTB (Module SSWAP $SSWAP_VERSION)\n";		
		close FILE;
	    }
	}
	else
	{
	    for (my $i = 0; $i < scalar @res; $i++) {
		print $res[$i]."\n";		
	    }
	    print " [ => ".(scalar @res)." Siteswap(s) ]\n";     
	}
	
	return @res;
    }

    
    
    if($order_list != 0)
    {
	@res=sort(@res);
    }

    if ($remove_redundancy == 1) {	
	for (my $i = 0; $i < scalar @res; $i++) {
	    if (&isValid($res[$i],-1)==1) {
		# remove redundancies
		my $drap = -1;
		my $checking_process = 1;
		
		if(uc($ground_check) eq "Y")
		{
		    if (&getSSstatus($res[$i],-1) ne "GROUND")
		    {
			$checking_process = -1;
		    }
		}
		
		if($checking_process == 1 && uc($prime_check) eq "Y")
		{
		    if(&isPrime($res[$i],-1) != 1)
		    {
			$checking_process = -1;
		    }
		}

		if($checking_process == 1 && uc($reversible_check) eq "Y")
		{
		    if(&isReversible($res[$i],-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($scramblable_check) eq "Y")
		{
		    if(&isScramblable($res[$i],'',-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($magic_check) eq "Y")
		{
		    if(&isFullMagic($res[$i],-1) < 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($palindrome_check) eq "Y")
		{
		    if(&isPalindrome($res[$i],-1) != 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1 && uc($squeeze_check) eq "Y")
		{
		    if(&isSqueeze($res[$i],-1) == 1)
		    {
			$checking_process = -1;			    
		    }
		}

		if($checking_process == 1)
		{
		    for (my $j =0; $j < scalar @resF; $j++) {
			&common::displayComputingPrompt();	    
			if ($resF[$j] eq "-1") {
			    next;
			}
			
			if (&isEquivalent($resF[$j],$res[$i],"",-1)==1) {
			    if (&getSSstatus($resF[$j],-1) eq "GROUND") {
				#do nothing
			    } elsif (&getSSstatus($res[$i],-1) eq "GROUND") {
				if ($SSWAP_DEBUG>=1) {
				    if (scalar @_ == 3 && $_[2] ne "-1" || scalar @_ == 2) {					
					print "== SSWAP::printSSListWithoutHeaders : ".$resF[$j]." => Shift Equivalence\n";
				    }
				}
				$resF[$j] = $res[$i];			    
			    } else {
				#do nothing
			    }
			    $drap = 1;			    
			    last;
			}		    		    
		    }
		    
		    if($drap == -1)
		    {
			push(@resF, $res[$i]);
		    }
		}		
	    }
	}

	# Again because there may be some recent disorder
	if($order_list != 0)
	{
	    @resF=sort(@resF);
	}
	
	&common::hideComputingPrompt();	    
	my @resF2 =();
	for (my $i = 0; $i < scalar @resF; $i++) {
	    if (scalar @_ == 3 && $_[2] ne "-1") {
		&common::displayComputingPrompt();	    
	    }

	    if ($resF[$i] ne "-1") {		
		$nbObjects = &getObjNumber($resF[$i],-1);
		my $period = &getPeriod($resF[$i],-1);
		if (uc($extra_info) eq "Y") {	
		    if ($order_list == 2) {	
			if ( exists( $hashTableSS{$nbObjects} ) ) {
			    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$resF[$i];			    
			} else {
			    $hashTableSS{$nbObjects} = $resF[$i];			    
			}					
		    } elsif ($order_list == 3) {	
			if ( exists( $hashTableSS{$period} ) ) {
			    $hashTableSS{$period} = $hashTableSS{$period}.":".$resF[$i];			    
			} else {
			    $hashTableSS{$period} = $resF[$i];			    
			}					
		    } else {	
			if (scalar @_ == 3 && $_[2] ne "-1") {
			    if ("JML:"=~ substr(uc($_[2]),0,4)) {
				if (&getSSstatus($resF[$i],-1) eq "GROUND") {
				    print FILE "<line display=\'  $resF[$i]".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				    {
					print FILE "\' notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";
				    }
				    else
				    {
					print FILE "\' notation=\"siteswap\">\n";
					print FILE "pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\n"; 
					print FILE "</line>\n";				
				    }
				} elsif (&getSSstatus($resF[$i],-1) eq "EXCITED") {
				    print FILE "<line display=\'* $resF[$i] *".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				    {
					print FILE "\' notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    else
				    {
					print FILE "\' notation=\"siteswap\">\n";
					print FILE "pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\n";
					print FILE "</line>\n";				
				    }


				} else {
				    print FILE "<line display=\'? $resF[$i] ?".(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				    {
					print FILE "\' notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\" />\n";				    
				    }
				    else
				    {
					print FILE "\' notation=\"siteswap\">\n";
					print FILE "pattern=$resF[$i]";
					print FILE ";colors=$balls_colors\n";
					print FILE "</line>\n";				
				    }
				}
			    } else {
				my $squeeze_info = '';
				if (&isSqueeze($resF[$i],-1) == 1)
				{
				    $squeeze_info = ' [Squeeze]';
				}
				
				if (&getSSstatus($resF[$i],-1) eq "GROUND") {			
				    print FILE "  ".$resF[$i].(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
				} elsif (&getSSstatus($resF[$i],-1) eq "EXCITED") {
				    print FILE "* ".$resF[$i]." *".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";		
				} else {
				    print FILE "? ".$resF[$i]." ?".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";		
				}
			    }
			} elsif (scalar @_ == 2) {
			    my $squeeze_info = '';
			    if (&isSqueeze($resF[$i],-1) == 1)
			    {
				$squeeze_info = ' [Squeeze]';
			    }

			    if (&getSSstatus($resF[$i],-1) eq "GROUND") {
				print "  ".$resF[$i].(' ' x ($xmarge - length($resF[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
			    } elsif (&getSSstatus($resF[$i],-1) eq "EXCITED") {
				print "* ".$resF[$i]." *".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
			    } else {
				print "? ".$resF[$i]." ?".(' ' x ($xmarge - length($resF[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
			    }
			}			
		    }
		} else {						    
		    if ($order_list == 2) {	
			if ( exists( $hashTableSS{$nbObjects} ) ) {
			    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$resF[$i];			    
			} else {
			    $hashTableSS{$nbObjects} = $resF[$i];			    
			}					
		    }
		    elsif ($order_list == 3) {	
			if ( exists( $hashTableSS{$period} ) ) {
			    $hashTableSS{$period} = $hashTableSS{$period}.":".$resF[$i];			    
			} else {
			    $hashTableSS{$period} = $resF[$i];			    
			}	    		
		    }
		    else {
			if (scalar @_ == 3 && $_[2] ne "-1") {
			    if ("JML:"=~substr(uc($_[2]),0,4)) {
				print FILE "<line display=\'  $resF[$i]".(' ' x ($xmarge - length($resF[$i])));
				if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				{
				    print FILE "\' notation=\"siteswap\" pattern=\"pattern=$resF[$i]";
				    print FILE ";colors=$balls_colors\" />\n";				    
				}
				else
				{
				    print FILE "\' notation=\"siteswap\">\n";
				    print FILE "pattern=$resF[$i]";
				    print FILE ";colors=$balls_colors\n";
				    print FILE "</line>\n";				
				}				
			    } else {
				print FILE $resF[$i]."\n";
			    }
			} elsif (scalar @_ == 2) {
			    print $resF[$i]."\n";
			}			
		    }
		}
		
		push(@resF2,$resF[$i]);
	    }
	}
	@resF=@resF2;
    }
    else {
	for (my $i = 0; $i < scalar @res; $i++) {
	    if (scalar @_ == 3 && $_[2] ne "-1") {
		&common::displayComputingPrompt();	    
	    }
	    
	    if (&isValid($res[$i],-1)==1) {			    
		if ($remove_redundancy == 2) {
		    # remove redundancies (First entry is the good one)
		    my $drap = -1;
		    for (my $j =0; $j < scalar @resF; $j++) {
			if (scalar @_ == 3 && $_[2] ne "-1") {
			    &common::displayComputingPrompt();	    
			}

			my $subopts=" -c ".$color_check." -s ".$sym_check." -p ".$perm_check." ";
			if (&isEquivalent($resF[$j],$res[$i],$subopts,-1)==1) {
			    if ($SSWAP_DEBUG>=1) {
				if (scalar @_ == 3 && $_[2] ne "-1" || scalar @_ == 2) {
				    print "== SSWAP::printSSListWithoutHeaders : ".$res[$i]." => Shift Equivalence\n";
				} 
			    }		
			    $drap = 1;			
			    last;
			}
		    }
		    if ($drap == -1) {
			
			my $checking_process = 1;
			if(uc($ground_check) eq "Y")
			{
			    if (&getSSstatus($res[$i],-1) ne "GROUND")
			    {
				$checking_process = -1;
			    }
			}
			
			if($checking_process == 1 && uc($prime_check) eq "Y")
			{
			    if(&isPrime($res[$i],-1) != 1)
			    {
				$checking_process = -1;
			    }
			}

			if($checking_process == 1 && uc($reversible_check) eq "Y")
			{
			    if(&isReversible($res[$i],-1) != 1)
			    {
				$checking_process = -1;			    
			    }
			}

			if($checking_process == 1 && uc($scramblable_check) eq "Y")
			{
			    if(&isScramblable($res[$i],'',-1) != 1)
			    {
				$checking_process = -1;			    
			    }
			}

			if($checking_process == 1 && uc($magic_check) eq "Y")
			{
			    if(&isFullMagic($res[$i],-1) < 1)
			    {
				$checking_process = -1;			    
			    }
			}

			if($checking_process == 1 && uc($palindrome_check) eq "Y")
			{
			    if(&isPalindrome($res[$i],-1) != 1)
			    {
				$checking_process = -1;			    
			    }
			}

			if($checking_process == 1 && uc($squeeze_check) eq "Y")
			{
			    if(&isSqueeze($res[$i],-1) == 1)
			    {
				$checking_process = -1;			    
			    }
			}

			if($checking_process == 1)
			{
			    push(@resF, $res[$i]);
			    $drap=1;
			}
			
			# Entry Added then go on
			if($drap==1)
			{
			    $nbObjects = &getObjNumber($res[$i],-1);
			    my $period = &getPeriod($res[$i],-1);
			    if (uc($extra_info) eq "Y") {
				if ($order_list == 2) {	
				    if ( exists( $hashTableSS{$nbObjects} ) ) {
					$hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				    } else {
					$hashTableSS{$nbObjects} = $res[$i];			    
				    }					
				}
				elsif ($order_list == 3) {	
				    if ( exists( $hashTableSS{$period} ) ) {
					$hashTableSS{$period} = $hashTableSS{$period}.":".$res[$i];			    
				    } else {
					$hashTableSS{$period} = $res[$i];			    
				    }					
				}
				else {		       	    
				    if (scalar @_ == 3 && $_[2] ne "-1") {
					if ("JML:"=~substr(uc($_[2]),0,4)) {
					    if (&getSSstatus($res[$i],-1) eq "GROUND") {
						print FILE "<line display=\'  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
						if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
						{
						    print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						    print FILE ";colors=$balls_colors\" />\n";				   
						}
						else
						{
						    print FILE "\' notation=\"siteswap\">\n";
						    print FILE "pattern=$res[$i]";
						    print FILE ";colors=$balls_colors\n";
						    print FILE "</line>\n";				
						}									    
					    } else {
						print FILE "<line display=\'* $res[$i] *".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
						if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
						{
						    print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						    print FILE ";colors=$balls_colors\" />\n";				   
						}
						else
						{
						    print FILE "\' notation=\"siteswap\">\n";
						    print FILE "pattern=$res[$i]";
						    print FILE ";colors=$balls_colors\n";
						    print FILE "</line>\n";				
						}									    
					    }
					} else {
					    my $squeeze_info = '';
					    if (&isSqueeze($res[$i],-1) == 1)
					    {
						$squeeze_info = ' [Squeeze]';
					    }
					    
					    if (&getSSstatus($res[$i],-1) eq "GROUND") {
						print FILE "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
					    } else {
						print FILE "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
					    }
					}
				    } elsif (scalar @_ == 2) {
					my $squeeze_info = '';
					if (&isSqueeze($res[$i],-1) == 1)
					{
					    $squeeze_info = ' [Squeeze]';
					}

					if (&getSSstatus($res[$i],-1) eq "GROUND") {
					    print "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
					} else {
					    print "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
					}
				    }									
				}
			    } else {
				if ($order_list == 2) {	
				    if ( exists( $hashTableSS{$nbObjects} ) ) {
					$hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				    } else {
					$hashTableSS{$nbObjects} = $res[$i];			    
				    }					
				}
				elsif ($order_list == 3) {	
				    if ( exists( $hashTableSS{$period} ) ) {
					$hashTableSS{$period} = $hashTableSS{$period}.":".$res[$i];			    
				    } else {
					$hashTableSS{$period} = $res[$i];			    
				    }					
				}
				else {
				    if (scalar @_ == 3 && $_[2] ne "-1") {
					if ("JML:"=~substr(uc($_[2]),0,4)) {
					    print FILE "<line display=\'$res[$i]";
					    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
					    {
						print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   
					    }
					    else
					    {
						print FILE "\' notation=\"siteswap\">\n";
						print FILE "pattern=$res[$i]";
						print FILE ";colors=$balls_colors\n";
						print FILE "</line>\n";				
					    }									    
					} else {
					    print FILE $res[$i]."\n";
					}
				    } elsif (scalar @_ == 2) {
					print $res[$i]."\n";  
				    }				 
				}
			    }
			    
			}
		    }
		} else {
		    my $drap = -1;

		    my $checking_process = 1;
		    if(uc($ground_check) eq "Y")
		    {
			if (&getSSstatus($res[$i],-1) ne "GROUND")
			{
			    $checking_process = -1;
			}
		    }
		    
		    if($checking_process == 1 && uc($prime_check) eq "Y")
		    {
			if(&isPrime($res[$i],-1) != 1)
			{
			    $checking_process = -1;
			}
		    }

		    if($checking_process == 1 && uc($reversible_check) eq "Y")
		    {
			if(&isReversible($res[$i],-1) != 1)
			{
			    $checking_process = -1;			    
			}
		    }

		    if($checking_process == 1 && uc($scramblable_check) eq "Y")
		    {
			if(&isScramblable($res[$i],'',-1) != 1)
			{
			    $checking_process = -1;			    
			}
		    }

		    if($checking_process == 1 && uc($magic_check) eq "Y")
		    {
			if(&isFullMagic($res[$i],-1) < 1)
			{
			    $checking_process = -1;			    
			}
		    }

		    if($checking_process == 1 && uc($palindrome_check) eq "Y")
		    {
			if(&isPalindrome($res[$i],-1) != 1)
			{
			    $checking_process = -1;			    
			}
		    }

		    if($checking_process == 1 && uc($squeeze_check) eq "Y")
		    {
			if(&isSqueeze($res[$i],-1) == 1)
			{
			    $checking_process = -1;			    
			}
		    }

		    if($checking_process == 1)
		    {
			push(@resF, $res[$i]);
			$drap=1;
		    }
		    
		    if($drap == 1)
		    {
			$nbObjects = &getObjNumber($res[$i],-1);
			my $period = &getPeriod($res[$i],-1);
			if (uc($extra_info) eq "Y") {			
			    if ($order_list == 2) {	
				if ( exists( $hashTableSS{$nbObjects} ) ) {
				    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				} else {
				    $hashTableSS{$nbObjects} = $res[$i];			    
				}								   
			    }
			    elsif ($order_list == 3) {	
				if ( exists( $hashTableSS{$period} ) ) {
				    $hashTableSS{$period} = $hashTableSS{$period}.":".$res[$i];			    
				} else {
				    $hashTableSS{$period} = $res[$i];			    
				}								   
			    }
			    else {
				if (scalar @_ == 3 && $_[2] ne "-1") {
				    if ("JML:"=~substr(uc($_[2]),0,4)) {
					if (&getSSstatus($res[$i],-1) eq "GROUND") {
					    print FILE "<line display=\'  $res[$i]".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
					    {
						print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n";				   
					    }
					    else
					    {
						print FILE "\' notation=\"siteswap\">\n";
						print FILE "pattern=$res[$i]";
						print FILE ";colors=$balls_colors\n";
						print FILE "</line>\n";				
					    }									    
					} else {				
					    print FILE "<line display=\'* $res[$i] *".(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
					    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
					    {
						print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
						print FILE ";colors=$balls_colors\" />\n"; 		
					    }
					    else
					    {
						print FILE "\' notation=\"siteswap\">\n";
						print FILE "pattern=$res[$i]";
						print FILE ";colors=$balls_colors\n";
						print FILE "</line>\n";				
					    }									    
					}
				    } else {
					my $squeeze_info = '';
					if (&isSqueeze($res[$i],-1) == 1)
					{
					    $squeeze_info = ' [Squeeze]';
					}				

					if (&getSSstatus($res[$i],-1) eq "GROUND") {
					    print FILE "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
					} else {
					    print FILE "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";		   
					}
				    }
				} elsif (scalar @_ == 2) {
				    my $squeeze_info = '';
				    if (&isSqueeze($res[$i],-1) == 1)
				    {
					$squeeze_info = ' [Squeeze]';
				    }												
				    
				    if (&getSSstatus($res[$i],-1) eq "GROUND") {
					print "  ".$res[$i].(' ' x ($xmarge - length($res[$i])))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";  
				    } else {
					print "* ".$res[$i]." *".(' ' x ($xmarge - length($res[$i])-2))."(".$nbObjects." ".$lang::MSG_SSWAP_GENERAL17.", ".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";  
				    }
				}
			    }
			} else {
			    if ($order_list == 2) {		
				if ( exists( $hashTableSS{$nbObjects} ) ) {
				    $hashTableSS{$nbObjects} = $hashTableSS{$nbObjects}.":".$res[$i];			    
				} else {
				    $hashTableSS{$nbObjects} = $res[$i];			    
				}      
			    } 
			    elsif ($order_list == 3) {		
				if ( exists( $hashTableSS{$period} ) ) {
				    $hashTableSS{$period} = $hashTableSS{$period}.":".$res[$i];			    
				} else {
				    $hashTableSS{$period} = $res[$i];			    
				}    
			    }
			    else {
				if (scalar @_ == 3 && $_[2] ne "-1") {
				    if ("JML:"=~substr(uc($_[2]),0,4)) {
					print FILE "<line display=\'$res[$i]";
					if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
					{
					    print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$i]";
					    print FILE ";colors=$balls_colors\" />\n";				   
					}
					else
					{
					    print FILE "\' notation=\"siteswap\">\n";
					    print FILE "pattern=$res[$i]";
					    print FILE ";colors=$balls_colors\n";
					    print FILE "</line>\n";				
					}									    
				    } else {					
					print FILE $res[$i]."\n";
				    }
				} elsif (scalar @_ == 2) {
				    print $res[$i]."\n";  
				}
			    }
			}
		    }
		}	
	    } else {
		if ($SSWAP_DEBUG>=1) {
		    if (scalar @_ == 3 && $_[2] ne "-1"  || scalar @_ == 2) {
			print "  ".$res[$i]." => Invalid\n";			    
		    }

		}
		
	    }	
	}
    }

    if ($order_list == 2 || $order_list == 3) {
	for my $nbIter (sort sort_num keys(%hashTableSS)) {
	    if (scalar @_ == 3 && $_[2] ne "-1") {
		&common::displayComputingPrompt();
		if ($order_list == 2)
		{
		    if ("JML:"=~substr(uc($_[2]),0,4)) {		    
			print FILE "<line display=\"============== ".$nbIter." ".$lang::MSG_SSWAP_GENERAL17." ==============\"/>\n";
		    } else {
			print FILE "============== ".$nbIter." ".$lang::MSG_SSWAP_GENERAL17." ==============\n";
		    }
		}
		elsif ($order_list == 3)
		{
		    if ("JML:"=~substr(uc($_[2]),0,4)) {		    
			print FILE "<line display=\"============== ".$lang::MSG_SSWAP_GENERAL6." = ".$nbIter." ==============\"/>\n";
		    } else {
			print FILE "============== ".$lang::MSG_SSWAP_GENERAL6." = ".$nbIter." ==============\n";
		    }
		}
		
	    } elsif (scalar @_ == 2) {
		if ($order_list == 2)
		{
		    print "============== ".$nbIter." ".$lang::MSG_SSWAP_GENERAL17." ==============\n";
		}
		elsif ($order_list == 3)
		{
		    print "============== ".$lang::MSG_SSWAP_GENERAL6." = ".$nbIter." ==============\n";
		}
	    }
	    
	    my $val = $hashTableSS{ $nbIter };
	    @res = split(/:/,$val);
	    for (my $j =0; $j < scalar @res; $j++) {
		if (scalar @_ == 3 && $_[2] ne "-1") {
		    &common::displayComputingPrompt();	    
		}

		if (uc($extra_info) eq "Y") {
		    my $period = &getPeriod($res[$j],-1);
		    if (&getSSstatus($res[$j],-1) eq "GROUND") {
			if (scalar @_ == 3 && $_[2] ne "-1") {
			    if ("JML:"=~substr(uc($_[2]),0,4)) {
				print FILE "<line display=\"  $res[$j]".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				{
				    print FILE "\" notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "\" notation=\"siteswap\">\n";
				    print FILE "pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\n";
				    print FILE "</line>\n";				
				}									    
			    } 
			    else {
				if ($order_list == 3) {			    
				    print FILE "  ".$res[$j]."\n";
				}
				else
				{			
				    print FILE "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
				}
			    }
			} elsif (scalar @_ == 2) {
			    if ($order_list == 3) {      
				print "  ".$res[$j]."\n";
			    }
			    else
			    {
				print "  ".$res[$j].(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")\n";
			    }
			}				
		    } else {
			if (scalar @_ == 3 && $_[2] ne "-1") {
			    if ("JML:"=~substr(uc($_[2]),0,4)) {
				print FILE "<line display=\'* $res[$j] *".(' ' x ($xmarge - length($res[$j])))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")";
				if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
				{
				    print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\" />\n";				   
				}
				else
				{
				    print FILE "\' notation=\"siteswap\">\n";
				    print FILE "pattern=$res[$j]";
				    print FILE ";colors=$balls_colors\n";
				    print FILE "</line>\n";				
				}									    
			    } else {
				if ($order_list == 3) {
				    print FILE "* ".$res[$j]." *\n";
				}
				else
				{
				    my $squeeze_info = '';
				    if (&isSqueeze($res[$j],-1) == 1)
				    {
					$squeeze_info = ' [Squeeze]';
				    }												

				    print FILE "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
				}
			    }
			} elsif (scalar @_ == 2) {
			    if ($order_list == 3) {
				print "* ".$res[$j]." *\n";
			    }
			    else
			    {
				my $squeeze_info = '';
				if (&isSqueeze($res[$j],-1) == 1)
				{
				    $squeeze_info = ' [Squeeze]';
				}												

				print "* ".$res[$j]." *".(' ' x ($xmarge - length($res[$j])-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$period.")".$squeeze_info."\n";
			    }
			}			    
		    }		    
		}
		
		else {
		    if (scalar @_ == 3 && $_[2] ne "-1") {
			if ("JML:"=~substr(uc($_[2]),0,4)) {
			    print FILE "<line display=\'$res[$j]";
			    if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
			    {
				print FILE "\' notation=\"siteswap\" pattern=\"pattern=$res[$j]";
				print FILE ";colors=$balls_colors\" />\n";				   
			    }
			    else
			    {
				print FILE "\' notation=\"siteswap\">\n";
				print FILE "pattern=$res[$j]";
				print FILE ";colors=$balls_colors\n";
				print FILE "</line>\n";				
			    }									    
			} else {
			    print FILE $res[$j]."\n";
			}
		    } elsif (scalar @_ == 2) {
			print $res[$j]."\n";
		    }			    	
		}
	    }
	    
	    if (scalar @_ == 3 && $_[2] ne "-1") {
		if ("JML:"=~substr(uc($_[2]),0,4)) {				 
		} else {
		    print FILE "\n";
		}
	    } elsif (scalar @_ == 2) {
		print "\n";
	    }
	}	    
    }

    if (scalar @_ == 3 && $_[2] ne "-1") {
	&common::hideComputingPrompt();	    
	if ("JML:"=~substr(uc($_[2]),0,4)) {				 
	    print FILE "<line display=\"\" />\n";
	    if(scalar @res == scalar @resF)
	    {
		print FILE "<line display=\"   [ => ".(scalar @resF)." Siteswap(s) ]"."\"/>\n";     
	    }
	    else
	    {
		if ($order_list == 2) 
		{
		    print FILE "<line display=\"   [ => ".(scalar @resF)." Siteswap(s) ]"." [/".$nbres."]\"/>\n";     
		}
		else {
		    print FILE "<line display=\"   [ => ".(scalar @resF)." Siteswap(s) ]"." [/".$nbres."]\"/>\n";     
		}
		
	    }
	    print FILE "<line display=\"\" />\n";
	    print FILE "<line display=\"----------- Creation : JugglingTB (Module SSWAP $SSWAP_VERSION)\" />\n";		
	    print FILE "</patternlist>\n";
	    print FILE "</jml>\n";
	} else {
	    print FILE "\n[ => ".(scalar @resF)." Siteswap(s) ]"."\n";     
	}
	close FILE;

    } elsif (scalar @_ == 2) {
	print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @resF)." Siteswap(s) ]"."\n";     
    }            
    
    return @resF;    
}


sub genScramblablePolster
{
    my $p = $_[0];		# Period Maximum
    my $a = $_[1];
    my $c = $_[2];

    my $title = '-- SCRAMBLABLE SITESWAPS --';
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0; # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number 
    my $ground_check = "N";     # Get only Ground States (default) or no
    my $prime_check = "N";      # Get only prime States or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    
    my $run_browser = -1;
    my $opts = $_[3];
    my $f = $_[4];
    my $ret = &GetOptionsFromString(uc($opts),    
				    "-O:i" => \$order_list,
				    "-R:i" => \$remove_redundancy,
				    "-C:s" => \$color_check,
				    "-S:s" => \$sym_check,
				    "-P:s" => \$perm_check,
				    "-T:s" => \$title,
				    "-I:s" => \$extra_info,
   			            "-G:s" => \$ground_check,
				    "-U:s" => \$prime_check,
				    "-N:s" => \$palindrome_check,
				    "-B:s" => \$reversible_check,
	);
    

    sub _scramblable_in
    {
	my $p = $_[0];
	my $a = $_[1];
	my $c = $_[2];
	my $count=$_[3];
	my $res = new Set::Scalar();    
	
	if($count == 0) 
	{
	    return $res;
	}
	
	if($count == 1)
	{
	    for (my $i=0; $i <= $a; $i++)
	    {
		my $v=$i*$p + $c;
		if($v<=$MAX_HEIGHT)
		{
		    $res->insert(sprintf("%x",$v));
		}
	    }
	}
	else
	{
	    my $res_tmp=&_scramblable_in($p, $a, $c, $count-1);
	    while(defined(my $e = $res_tmp->each))
	    {
		for (my $j=0; $j <= $a; $j++)
		{
		    my $v=$j*$p + $c;
		    if($v<=$MAX_HEIGHT)
		    {
			my $l = "";
			my $k = 0;
			my $ss = "";
			my $f = 0;
			while($k < length($e))
			{
			    if($v <= hex(substr($e,$k,1)))
			    {				
				$ss = $l.sprintf("%x",$v).substr($e,$k);
				$k = length($e);
				$f = 1;
				last;
			    }
			    else
			    {
				$l = $l.substr($e,$k,1);
				$k++;
			    }
			}
			if($f==0)
			{
			    $ss = $e.sprintf("%x",$v);
			}

			$res->insert($ss);
		    }
		}
	    }
	}
	
	return $res;	
    }


    my $res = new Set::Scalar();
    for (my $i=0; $i<=$c; $i++)
    { 
	my $res_in = new Set::Scalar();    
	$res_in=&_scramblable_in($p,$a,$i,$p);
	
	while(defined(my $e = $res_in->each))
	{
	    $res->insert($e);
	}    
    }

    my @result = ();
    while(defined(my $e = $res->each))
    {
	push(@result,$e);
    }


    if (scalar @_ >= 5 && $_[4] ne "-1") {	    	    	    	    
	if ("JML:"=~substr(uc($_[4]),0,4)) {
	    $f =substr($_[4],4);

	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\"".$title."\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL1p"."\"/>\n";     
	    print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENERAL6 : ".$p."\"/>\n";	    
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    @result = &printSSListWithoutHeaders((\@result,$_[3],$_[4]));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr(uc($_[4]),0,7))
	{
	    $f =substr($_[4],7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_GENERAL1p."<BR/>\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL6." : ".$p."<BR/>\n";	    
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		
	    
	    @result = &printSSListInfoHTMLWithoutHeaders(\@result,$_[3],$_[4]);				
	    
	    $run_browser=1;		
	}
	else {
	    $f =$_[4];
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_SSWAP_GENERAL1p."\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";	    
	    print FILE "================================================================\n\n";
	    
	    @result = &printSSListWithoutHeaders((\@result,$_[3],$_[4]));
	}
    } elsif(scalar @_ < 5) {	    
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1p."\n";     
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";	    
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	@result = &printSSListWithoutHeaders((\@result,$_[3]));	    
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	my $pwd = cwd();
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }


    return @result;

}


sub genSSMagicStadler
{
    ##
    ## Called Functions :
    ##           - &getObjNumber
    ##           - &getSSstatus
    ##           - &__prime
    ##           - &printSSListInfoHTMLWithoutHeaders
    ##           - &printSSListWithoutHeaders

    my $p_max = $_[0];		# Period Maximum

    if($p_max > 16)
    {
	$p_max = 16;
    }

    my $title='-- MAGIC SITESWAPS (Stadler Algorithm) --';
    my @res =();
    my $f = "";
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";     # Get only Ground States or no (Default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)    
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)
    
    my $run_browser = -1;

    &GetOptionsFromString(uc($_[1]),    
			  "-O:i" => \$order_list,
			  "-R:i" => \$remove_redundancy,
			  "-C:s" => \$color_check,
			  "-S:s" => \$sym_check,
			  "-P:s" => \$perm_check,
			  "-T:s" => \$title,
			  "-I:s" => \$extra_info,
			  "-G:s" => \$ground_check,
			  "-U:s" => \$prime_check,
			  "-D:s" => \$scramblable_check,
			  "-N:s" => \$palindrome_check,
			  "-B:s" => \$reversible_check,
			  "-Z:s" => \$magic_check,
			  "-Q:s" => \$squeeze_check,
	);
    
    if (scalar @_ == 3 && $_[2] ne "-1") {
	if ("JML:"=~substr(uc($_[2]),0,4)) {
	    $f =substr($_[2],4);
	    
	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\"".$title."\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    open(FILE_JML,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENERAL6." : ".$_[0]."\"/>\n";     
	    if ($remove_redundancy != 0) {
		print FILE_JML "<line display=\"$lang::MSG_SSWAP_GENMAGICSS_MSG1a"."\"/>\n";     
	    }
	    print FILE_JML "<line display=\"========================================\""."/>\n";	   
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif ("SSHTML:"=~substr(uc($_[2]),0,7)) {		      
	    $f =substr($_[2],7).".html";    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE $title."<BR/>\n";
	    print FILE "========================================<BR/>\n";	   
	    close FILE;
	    $run_browser=1;			    
	}
	else
	{
	    $f =$_[2];    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE $title."\n";	   
	    print FILE "\n";
	    close FILE;
	}

    }
    elsif(scalar @_ < 2  || (scalar @_  == 2 && $_[1] ne "-1")) 
    {
	print colored [$common::COLOR_RESULT], $title."\n";	   
	print "\n";
    }
    
    # Partial But Quick Generation. Some Magic SS are not given by this algo
    for (my $p = 1; $p <= $p_max; $p +=2) {
	if (scalar @_ != 3 || "JML:"!~substr(uc($_[2]),0,4)) {
	    @res =();	
	}

	my $nbObjects=(($p-1)*($p)/2)/$p;
	if (scalar @_ == 3 && $_[2] ne "-1" && "SSHTML:"!~substr(uc($_[2]),0,7) && "JML:"!~substr(uc($_[2]),0,4)) 
	{		      
	    my $f = $_[2];
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";	    
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects;
	    print FILE "\n================================================================\n";	    
	} elsif (scalar @_ < 2  || (scalar @_  == 2 && $_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";  
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL6." : ".$p."\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects;
	    print colored [$common::COLOR_RESULT], "\n================================================================\n"; 
	}
	
	for (my $q = 2; $q < $p;$q++) {
	    my $ss = "";
	    for (my $k =0; $k < $p ; $k++) {
		if((($q-1)*$k)% $p > $MAX_HEIGHT)
		{
		    next;
		}
		
		
		$ss = $ss.sprintf("%x",(($q-1)*$k )% $p);
	    }	    	 	    
	    if (scalar @_ == 3 && $_[2] ne "-1") {
		if($q==2 || ( &__prime($p,$q) == 1 && &__prime($p,$q-1)== 1))
		{
		    print FILE $ss."\n";
		}
		else
		{	
		    if ($SSWAP_DEBUG>=1) 
		    {				    
			print "== SSWAP::genSSMagicStadler : Rejected State : ".$ss."\n";		    
		    }
		}		
	    } elsif (scalar @_ < 2  || $_[1] ne "-1") {		   
		if($q==2 || ( &__prime($p,$q) == 1 && &__prime($p,$q-1)== 1))
		{			
		    if(uc($extra_info) eq "Y")
		    {
			my $xmarge = 30;
			my $nbObjects=&getObjNumber($ss,"-1");
			if (&getSSstatus($ss,-1) eq "GROUND")
			{
			    print "  ".$ss.(' ' x ($xmarge - length($ss)))."(".$lang::MSG_SSWAP_GENERAL6." : ".$p.")\n";
			} elsif (&getSSstatus($ss,-1) eq "EXCITED") {
			    print "* ".$ss." *".(' ' x ($xmarge - length($ss)-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$p.")\n";
			} else {
			    print "? ".$ss." ?".(' ' x ($xmarge - length($ss)-2))."(".$lang::MSG_SSWAP_GENERAL6." : ".$p.")\n";

			}
		    }
		    else
		    {
			print $ss."\n";		
		    }
		}
		elsif ($SSWAP_DEBUG>=1) 
		{			
		    print "== SSWAP::genSSMagicStadler : Rejected State : ".$ss."\n";		
		}
	    }	    
	    
	    if($q==2 || ( &__prime($p,$q) == 1 && &__prime($p,$q-1)== 1))
	    {	    
		push(@res,$ss);
	    }
	}
	
	if (scalar @_ == 3 && $_[2] ne "-1") {	    
	    if ("SSHTML:"=~substr(uc($_[2]),0,7)) {
		open(FILE,">>$conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE "<BR/>================================================================<BR/>\n";
		print FILE $lang::MSG_SSWAP_GENERAL6." : ".$p."<BR/>\n";	
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nbObjects."<BR/>\n";
		if ($remove_redundancy != 0) {
		    print FILE $lang::MSG_SSWAP_GENPROBERTSS_MSG1g."<BR/>\n"; 
		}
		print FILE "================================================================\n";
		close(FILE);		
		
		@res = &printSSListInfoHTMLWithoutHeaders(\@res,$_[1],$_[2]);				
	    }
	    elsif ("JML:"=~substr(uc($_[2]),0,4)) {
	    }
	    if("SSHTML:"!~substr(uc($_[2]),0,7) && "JML:"!~substr(uc($_[2]),0,4))
	    {
		print FILE "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\n";     
		close FILE;
	    }
	} elsif (scalar @_ < 2  || (scalar @_  == 2 && $_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "\n[ => ".(scalar @res)." ".$lang::MSG_SSWAP_GENERAL1p."]"."\n";     
	}
    }
    
    if (scalar @_ == 3 && $_[2] ne "-1") {	    
	if ("JML:"=~substr(uc($_[2]),0,4)) {	    
	    @res = &printSSListWithoutHeaders((\@res,$_[1],$_[2]));
	}
    }
    
    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	my $pwd = cwd();
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
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
	my $nb_objs=$_[0];
	my $period=$_[1];    

	my @res=();
	my @restmp =();
	
	for (my $i=0; $i < $period; $i++) {
	    &common::displayComputingPrompt();
	    @restmp =();
	    for (my $j=0; $j <= $nb_objs; $j++) {
		&common::displayComputingPrompt();
		if (@res == 0) {
		    push(@restmp, sprintf("%x",$j));	       
		} else {
		    foreach my $el (@res) {
			my $sum = 0;
			for (my $k =0; $k < length $el; $k++) {
			    $sum += hex(substr($el,$k,1));			 
			}
			if ($sum <= $nb_objs) {			 
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
	    if ($sum == $nb_objs) {
		#push(@resF,sprintf("%x",$el));
		push(@resF,$el);
	    }
	}
	
	&common::hideComputingPrompt();	      
	return @resF;
    }


    my $nb_objs = $_[0];
    my $p =$_[1];
    my @resSS=();

    # Gen the all possible permutations vectors P
    my @permut = &__genPerm($p);

    if ($SSWAP_DEBUG>=2) {
	print "=== Permutations\n";
	for (my $i = 0; $i < scalar @permut; $i++) {
	    print $permut[$i]."\n";
	}
	print "\n";
    }

    # Gen P' = P - (0, 1, 2, ...) % PERIOD
    my @vect_Pprim = ();
    for (my $i =0; $i < scalar(@permut); $i++) {	  
	push(@vect_Pprim,(__compute_new_vector_init($permut[$i],$p)));
    }

    if ($SSWAP_DEBUG>=2) {
	print "=== P' = P -(0,1,...) % Period \n";
	for (my $i = 0; $i < scalar @vect_Pprim; $i++) {
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
	if ($average % $p == 0) {
	    $average=$average/$p;
	    # Compute the vectors Q related to P' 
	    my @vect_Q=&__compute_vector_Q($nb_objs - $average,$p);	
	    if ($SSWAP_DEBUG>=2) {
		print "=== Q \n";
	    }
	    for (my $k =0; $k < scalar(@vect_Q); $k++) {
		if ($SSWAP_DEBUG>=2) {
		    print "Q=".$vect_Q[$k]."\n";
		}
		my $v ="";
		for (my $l =0; $l < length ($vect_Q[$k]); $l++) {
		    $v=$v.sprintf("%x",(hex(substr($vect_Pprim[$i],$l,1))+$p*hex(substr($vect_Q[$k],$l,1))));
		}	    
		push(@resSS,$v);
	    }
	    if ($SSWAP_DEBUG>=2) {
		print "\n";
	    }
	}
    }
    if ($SSWAP_DEBUG>=2) {
	print "=== RES = P'+pQ  \n";
	for (my $i = 0; $i < scalar @resSS; $i++) {
	    print $resSS[$i]."\n";
	}
	print "\n";
    }

    shift;
    shift;

    # This is not the optimum way to do it. It would be better to cut before but at least it is simple to implement 
    # just be more patient ;-)
    if (scalar @_ > 0)
    {
	my @resF = &printSSList((\@resSS,@_));
	return @resF;	
    }
    else
    {
	my @resF = &printSSList((\@resSS,''));
	return @resF;	
    }
    
}      



sub genStates
{
    my $mod = uc(shift);    
    
    if ($mod eq "V") {
	return &__gen_states_async(@_);
    } elsif ($mod eq "M") {
	return &__gen_states_multiplex(@_);
    } elsif ($mod eq "S") {
	return &__gen_states_sync(@_);
    } elsif ($mod eq "SM" || $mod eq "MS") {
	return &__gen_states_multiplex_sync(@_);
    } elsif ($mod eq "MULTI") {
	return &__gen_states_multisync(@_);
    }    
}


sub genStatesAggr
{    
    my ($res1,$res2)= ();
    my $mod = uc(shift);    
    my $nbparams = scalar @_;
    my $nb_objs = $_[0];
    my $highMaxss = $_[1];
    my $multiplex = $_[2]; # Only for M, MS and MULTI

    # Get the States/Transitions Matrix
    # XLS File with States/Transitions Matrix is provided to speed up the computation
    if (($mod eq "V" || $mod eq "S") && scalar @_ > 3) {
	&__check_xls_matrix_file($_[3],$mod,$nb_objs,$highMaxss,"-1" ,"-1");
	($res1, $res2) = &__getStates_from_xls($_[3]);
    }
    elsif(scalar @_ > 4)
    {
	&__check_xls_matrix_file($_[4],$mod,$nb_objs,$highMaxss,$multiplex,"-1");
	($res1, $res2) = &__getStates_from_xls($_[4]);
    }
    else
    {
	if ($mod eq "V") {
	    ($res1, $res2) = &genStates('V',$_[0],$_[1],-1);	    
	} elsif ($mod eq "M") {
	    ($res1, $res2)= &genStates('M', $_[0],$_[1],$_[2],-1);
	} elsif ($mod eq "S") {
	    ($res1, $res2)= &genStates('S',$_[0],$_[1],-1);	    
	} elsif ($mod eq "SM" || $mod eq "MS") {
	    ($res1, $res2)= &genStates('MS', $_[0],$_[1],$_[2],-1);	    	
	} elsif ($mod eq "MULTI") {
	    ($res1, $res2)= &genStates('MULTI', $_[0],$_[1],$_[2],-1);	    	
	} else {
	    return -1;
	}
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
	    my $idx_el1 = &__get_idx_state(\@states,$el1);
	    &common::displayComputingPrompt();
	    my $f = 0;
	    my $res = "";
	    my $elres = "";

	    foreach my $el2 (@states) {	
		my $idx_el2 = &__get_idx_state(\@states,$el2);
		&common::displayComputingPrompt();
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
		    my $idx_el3 = &__get_idx_state(\@states,$el3);
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

		    my $idx_elres=&__get_idx_state(\@states,$elres);
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
	    my ($param1,$param2) = &__del_state(\@matrix,\@states, $s);
	    @matrix=@{$param1};
	    @states=@{$param2};
	}    
	
	#Check Column by Column if only one source exists for a state
	@states_to_remove = ();
	foreach my $el2 (@states) {
	    my $idx_el2=&__get_idx_state(\@states,$el2);
	    &common::displayComputingPrompt();
	    my $f = 0;
	    my $res = "";
	    my $elres = "";
	    
	    foreach my $el1 (@states) {	    
		my $idx_el1=&__get_idx_state(\@states,$el1);
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
		    my $idx_el3=&__get_idx_state(\@states,$el3);
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
			
			
			my $idx_elres=&__get_idx_state(\@states,$elres);
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
	    ($res1,$res2) = &__del_state(\@matrix,\@states, $s);
	    @matrix=@{$res1};
	    @states=@{$res2};
	}    	
    }    
    
    &common::hideComputingPrompt();
    # Do the Printing/Writing of the results
    if (($mod eq "V" || $mod eq "S") && $nbparams >= 3 && $_[2]!=-1 && $_[2] ne "") {
	if ("XLS:"=~substr(uc($_[2]),0,4)) {
	    if ($mod eq "V") {
		&__genStates_toXLS(\@matrix,\@states,substr($_[2],4),"A,".$nb_objs.",".$highMaxss.","."-1,R");  
	    } else {
		&__genStates_toXLS(\@matrix,\@states,substr($_[2],4),"S,".$nb_objs.",".$highMaxss.","."-1,R");  
	    }
	} else {	  	
	    if ($mod eq "V") {
		&__genStates_toSTDOUT(\@matrix,\@states,$_[2],"A,".$nb_objs.",".$highMaxss.","."-1,R");
	    } else {
		&__genStates_toSTDOUT(\@matrix,\@states,$_[2],"S,".$nb_objs.",".$highMaxss.","."-1,R");
	    }
	}
    } elsif (($mod eq "M" || $mod eq "MS" || $mod eq "SM" || $mod eq "MULTI") && $nbparams >= 4 && $_[3]!=-1 && $_[3] ne "") {
	if ("XLS:"=~substr(uc($_[3]),0,4)) {
	    if ($mod eq "M") {
		&__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"A,".$nb_objs.",".$highMaxss.",".$multiplex.",R");  
	    } elsif ($mod eq "MULTI") {
		&__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"MULTI,".$nb_objs.",".$highMaxss.",".$multiplex.",R");  
	    }
	    else {
		&__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"S,".$nb_objs.",".$highMaxss.",-1,R");  
	    }
	} else {
	    if ($mod eq "M") {
		&__genStates_toSTDOUT(\@matrix,\@states,$_[3],"A,".$nb_objs.",".$highMaxss.",".$multiplex.",R");
	    } elsif ($mod eq "MULTI") {
		&__genStates_toSTDOUT(\@matrix,\@states,$_[3],"MULTI,".$nb_objs.",".$highMaxss.",".$multiplex.",R");
	    } 
	    else {
		&__genStates_toSTDOUT(\@matrix,\@states,$_[3],"S,".$nb_objs.",".$highMaxss.",-1,R");
	    }
	}
    } elsif (($mod eq "V" && $nbparams ==  2) || ($mod eq "V" && $nbparams ==  4 && $_[2] eq "")) {
	&__genStates_toSTDOUT(\@matrix,\@states,"A,".$nb_objs.",".$highMaxss.",-1,R");
    } elsif (($mod eq "S" && $nbparams ==  2) || ($mod eq "S" && $nbparams ==  4 && $_[2] eq "")) {
	&__genStates_toSTDOUT(\@matrix,\@states,"S,".$nb_objs.",".$highMaxss.",-1,R");	    
    } elsif (($mod eq "M" && $nbparams ==  3) || ($mod eq "M" && $nbparams ==  5 && $_[3] eq "")) {
	&__genStates_toSTDOUT(\@matrix,\@states,"A,".$nb_objs.",".$highMaxss.",".$multiplex.",R");
    } elsif ((($mod eq "MS" || $mod eq "SM") && $nbparams ==  3) || (($mod eq "MS" || $mod eq "SM") && $nbparams ==  5 && $_[3] eq "")) {
	&__genStates_toSTDOUT(\@matrix,\@states,"S,".$nb_objs.",".$highMaxss.",".$multiplex.",R");
    } elsif (($mod eq "MULTI" && $nbparams ==  3) || ($mod eq "MULTI" && $nbparams ==  5 && $nbparams ==  5 && $_[3] eq "")) {
	&__genStates_toSTDOUT(\@matrix,\@states,"MULTI,".$nb_objs.",".$highMaxss.",".$multiplex.",R");
    }
    
    return (\@matrix, \@states);    
}


sub __get_idx_state
{
    my @states=@{$_[0]};
    my $el_to_find='';
    # handle synchronous/multisynchronous siteswap and states equivalent with a different height
    my $sep="";    
    if(index($_[1],'|') != -1)
    {
	$sep = '|';
    }
    elsif(index($_[1],',') != -1)
    {
	$sep = ',';
    }
    my @st=();
    if($sep eq ",")
    {
	@st=split(/,/,$_[1]);
    }
    elsif($sep eq "|")
    {
	@st=split(/\|/,$_[1]);
    }
    if($sep ne "")
    {
     	my $v1=$st[0];
     	my $v2=$st[1];
     	$v1 =~ s/^0+//g;
     	$v2 =~ s/^0+//g;
     	$el_to_find=$v1.$sep.$v2;
    }
    else
    {
     	$el_to_find = $_[1];
     	$el_to_find =~ s/^0+//g;
    }
    
    my $cpt = 0;
    foreach my $el (@states) {
	my $el_tmp = $el;
	if($sep eq ",")
	{
	    @st=split(/,/,$el_tmp);
	}
	elsif($sep eq "|")
	{
	    @st=split(/\|/,$el_tmp);
	}

	if($sep ne "")
	{
	    my $v1=$st[0];
	    my $v2=$st[1];
	    $v1 =~ s/^0+//g;
	    $v2 =~ s/^0+//g;
	    $el_tmp=$v1.$sep.$v2;
	}
	else
	{
	    $el_tmp =~ s/^0+//g;
	}

	if ($el_tmp eq $el_to_find) {
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
    my $el_to_remove_idx=&__get_idx_state(\@states,$el_to_remove);

    # Remove the column in the matrix
    for (my $i=0 ; $i<$nbstates; $i++) {		
	for (my $j=$el_to_remove_idx; $j<$nbstates-1 ; $j++) {
	    &common::displayComputingPrompt();
	    $matrix[$i][$j]=$matrix[$i][$j+1];
	}		
    }

    # Remove the row in the matrix
    for (my $j=0 ; $j<$nbstates; $j++) {	
	for (my $i=$el_to_remove_idx; $i<$nbstates-1 ; $i++) {
	    &common::displayComputingPrompt();	
	    $matrix[$i][$j]=$matrix[$i+1][$j];
	}		
    }

    # remove the state from its list
    my @res = ();  
    foreach my $el (@states) {
	&common::displayComputingPrompt();
	my $el_to_remove_tmp = $el_to_remove; 
	# handle synchronous/multisynchronous siteswap and states equivalent with a different height
	my $sep="";    
	my @st=();
	if(index($el_to_remove_tmp,'|') != -1)
	{
	    $sep = '|';
	    @st=split(/\|/,$el_to_remove_tmp);
	}
	elsif(index($el_to_remove_tmp,',') != -1)
	{
	    $sep = ',';
	    @st=split(/,/,$el_to_remove_tmp);	   
	}
	if($sep ne "")
	{
	    my $v1=$st[0];
	    my $v2=$st[1];
	    $v1 =~ s/^0+//g;
	    $v2 =~ s/^0+//g;
	    $el_to_remove_tmp=$v1.$sep.$v2;
	}
	else
	{
	    $el_to_remove_tmp=~ s/^0+//g;
	}

	my $el_tmp = $el;
	$sep="";    
	@st=();
	if(index($el_tmp,'|') != -1)
	{
	    $sep = '|';
	    @st=split(/\|/,$el_tmp);
	}
	elsif(index($el_tmp,',') != -1)
	{
	    $sep = ',';
	    @st=split(/,/,$el_tmp);	   
	}
	if($sep ne "")
	{
	    my $v1=$st[0];
	    my $v2=$st[1];
	    $v1 =~ s/^0+//g;
	    $v2 =~ s/^0+//g;
	    $el_tmp=$v1.$sep.$v2;
	}
	else
	{
	    $el_tmp=~ s/^0+//g;
	}

	if ($el_tmp ne $el_to_remove_tmp) {
	    push(@res,$el);  	
	}
    }
    
    &common::hideComputingPrompt();
    return (\@matrix, \@res);
}



sub __genStates_toSTDOUT
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
	my $idx_i=&__get_idx_state(\@states,$i);
	if (length($i) > $matrix_marge) { 
	    $matrix_marge = length($i);
	}
	foreach my $j (@states) {
	    my $idx_j=&__get_idx_state(\@states,$j);
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
	if ($col[4] eq "R") {
	    print FILE $lang::MSG_SSWAP_GENAGGRSTATES_MSG1a."\n";
	} else {
	    print FILE $lang::MSG_SSWAP_GENSTATES_MSG1a."\n";
	}
	if ($col[0] eq "A") {
	    print FILE $lang::MSG_SSWAP_GENERAL1."\n";	
	} elsif ($col[0] eq "S") {
	    print FILE $lang::MSG_SSWAP_GENERAL1b."\n";		    
	} elsif ($col[0] eq "MULTI") {
	    print FILE $lang::MSG_SSWAP_GENERAL1cp."\n";		    
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
	if ($col[4] eq "R") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENAGGRSTATES_MSG1a."\n";
	} else {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSTATES_MSG1a."\n";
	}
	if ($col[0] eq "A") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1."\n";	
	} elsif ($col[0] eq "S") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1b."\n";		    
	} elsif ($col[0] eq "MULTI") {
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENERAL1cp."\n";		    
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
		    my $idx_i=&__get_idx_state(\@states,$i);
		    my $idx_j=&__get_idx_state(\@states,$j);
		    print FILE ' ' x ($matrix_marge - length($matrix[$idx_i][$idx_j])).$matrix[$idx_i][$idx_j];
		} elsif (scalar @_ == 3) {
		    my $idx_i=&__get_idx_state(\@states,$i);
		    my $idx_j=&__get_idx_state(\@states,$j);
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


sub __genStates_toXLS
{
    my @matrix = @{$_[0]};
    my @states = @{$_[1]};
    my $file = $_[2];
    my $comment = $_[3];
    my $MAXSTATES = 16500 ;	# Number max of states for setting the columns size in Excel
    # Printing Alignement
    my $starti = $EXCEL_ROW_START -1;
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
	comments => 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (genStates)",
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
    $format1c->set_align( 'left' );	        
    
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
	    my $idx_j=&__get_idx_state(\@states,$j);
	    my $matrix_marge =  6;	#Marge min
	    foreach my $i (@states) {	
		my $idx_i=&__get_idx_state(\@states,$i);

		if ($matrix[$idx_i][$idx_j] ne "") {
		    if ($SSWAP_DEBUG>=1) {
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
    if ($col[4] eq "R") {
	$worksheet->merge_range ('B2:P2', $lang::MSG_SSWAP_GENAGGRSTATES_MSG1a, $format1c);	
    }
    else
    {
	$worksheet->merge_range ('B2:P2', $lang::MSG_SSWAP_GENSTATES_MSG1a, $format1c);	
    }
    
    if ($col[0] eq "A") {
	$worksheet->merge_range ('B3:P3', $lang::MSG_SSWAP_GENERAL1, $format1c);	
    } elsif ($col[0] eq "S") {
	$worksheet->merge_range ('B3:P3', $lang::MSG_SSWAP_GENERAL1b, $format1c);	
    } elsif ($col[0] eq "MULTI") {
	$worksheet->merge_range ('B3:P3', $lang::MSG_SSWAP_GENERAL1cp, $format1c);	
    }
    if ($col[1] ne "-1") {
	$worksheet->merge_range ('B4:P4', $lang::MSG_SSWAP_GENERAL2." : ".$col[1], $format1c);	
    } else {
	$worksheet->merge_range ('B4:P4', $lang::MSG_SSWAP_GENERAL2b, $format1c);	
    }
    if ($col[2] ne "-1") {
	$worksheet->merge_range ('B5:P5', $lang::MSG_SSWAP_GENERAL3." : ".$col[2], $format1c);
    }
    if ($col[3] ne "-1") {
	$worksheet->merge_range ('B6:P6', $lang::MSG_SSWAP_GENERAL4." : ".$col[3], $format1c);	
    }
    

    # Let's go for the printing ...    
    my $cptj = -1;

    foreach my $i (@states) {	  
	my $idx_i=&__get_idx_state(\@states,$i);
	$worksheet->write_string( $idx_i+$starti+1, $startj, $i, $format1b);	  	  	  	
	
	foreach my $j (@states) { 	    
	    my $idx_j=&__get_idx_state(\@states,$j);
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
	#my $idx_i=&__get_idx_state(\@states,$i); 
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
	    my $idx_j=&__get_idx_state(\@states,$nstate); 
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
	} 
	elsif ($i =~ '\|') {
	    my @res=split(/\|/,$i);
	    my $nstate=$res[1]."|".$res[0];
	    my $idx_j=&__get_idx_state(\@states,$nstate); 
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
	} 
	else {
	    last;
	}

	$idx_i ++;
	&common::displayComputingPrompt();
    }	
    
    # print the number of states and transitions    
    $worksheet->merge_range ('B7:P7', "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n", $format1c);	
    &common::hideComputingPrompt();
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]\n";	
    #$worksheet->close();    
}


sub __get_states_async
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $matrix_size=2**$highMaxss;    
    my @res = ();
    my $b="";

    # Generate all the possibles states using the Height of the SS
    for (my $i=0; $i < $matrix_size; $i++) {
	&common::displayComputingPrompt();
	my $b = substr(reverse(dec2binwith0($i)),0,$highMaxss);
	
	# Filter by checking the number of balls
	if (($_[0] == -1 || int($b =~ tr/1//) == $nb_objs)  && $b ne "") {  
	    push(@res, $b);
	}	    			
    }
    
    &common::hideComputingPrompt();
    return sort(@res);
}


sub __get_states_multiplex
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];

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
	    
	    if ($nb_objs != -1) {
		my $c=0;
		for (my $j =0; $j < length($v); $j++) {
		    $c += hex(substr($v,$j,1));
		}

		if ($c == $nb_objs) {
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
    &__get_states_multiplex($_[0], $_[1], $_[2], \@res, $currentHigh+1);
}

# Give all possible Multiplex according to a Max SS high and the multiplex size.
sub __get_throws_multiplex
{
    my $nb_objs = -1;
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];    
    my $nbthrows = 0;

    if ($_[0] == -1) {
	$nbthrows = $multiplex;
    } else {
	$nb_objs = $_[0];
	if ($nb_objs < $multiplex) {
	    $nbthrows = $nb_objs;
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

# Give all possible Multisync according to a Max SS high.
# ie : 
#   A                               ; A in [0..F] => V 
#   A ! B                           ; A,B in [0..F] => S 
#   A !* B |  C!A !* B | A !* B!C   ; Any Possible combination of !* and *, except for first and last, A,B in [0..F] => M and MS
#   *A means hurry : it will not be considered here. * will be considered in the states generation as a transition itself. We nevetheless get 0!A as equivalent
#   The sync form of multisync is mandatory for States/transitions Diagramms and will be considered later  
sub __get_throws_multisync
{
    sub __is_equivalent_throws_multisync
    {
	my $th1 = $_[0];
	my $th2 = $_[1];
	my $cur ="R";
	my @th1_rh = ();
	my @th1_lh = ();

	for (my $i = 0; $i < length($th1); $i++)
	{
	    my $v = substr($th1,$i,1);
	    
	    if($v eq "*")
	    {
		if($cur eq "R")
		{		    
		    $cur = "L";
		}
		else
		{
		    $cur = "R";
		}		    		
	    }
	    elsif($v eq "!")
	    {
		# Nothing to do
	    }
	    else
	    {
		if($cur eq "R")
		{
		    if($v ne "0")
		    {
			if(uc(substr($th1,$i+1,1)) ne "X")
			{
			    push(@th1_rh, $v);
			}
			else
			{
			    push(@th1_rh, $v."X");
			    $i++;
			}
		    }
		    $cur = "L";
		}
		else
		{
		    if($v ne "0")
		    {
			if(uc(substr($th1,$i+1,1)) ne "X")
			{
			    push(@th1_lh, $v);
			}
			else
			{
			    push(@th1_lh, $v."X");
			    $i++;
			}
		    }
		    $cur = "R";
		}
	    }	    
	}

	$cur ="R";
	my @th2_rh = ();
	my @th2_lh = ();
	
	for (my $i = 0; $i < length($th2); $i++)
	{
	    my $v = substr($th2,$i,1);
	    
	    if($v eq "*")
	    {
		if($cur eq "R")
		{		    
		    $cur = "L";
		}
		else
		{
		    $cur = "R";
		}		    		
	    }
	    elsif($v eq "!")
	    {
		# Nothing to do		
	    }
	    else
	    {
		if($cur eq "R")
		{
		    if($v ne "0")
		    {
			if(uc(substr($th2,$i+1,1)) ne "X")
			{
			    push(@th2_rh, $v);
			}
			else
			{
			    push(@th2_rh, $v."X");
			    $i++;
			}
		    }
		    $cur = "L";
		}
		else
		{
		    if($v ne "0")
		    {
			if(uc(substr($th2,$i+1,1)) ne "X")
			{
			    push(@th2_lh, $v);
			}
			else
			{
			    push(@th2_lh, $v."X");
			    $i++;
			}
		    }
		    $cur = "R";
		}	    
	    }
	}
	
	@th1_rh = sort(@th1_rh);
	@th1_lh = sort(@th1_lh);
	@th2_rh = sort(@th2_rh);
	@th2_lh = sort(@th2_lh);
	
	if(join('',@th1_rh) eq join('',@th2_rh) && join('',@th1_lh) eq join('',@th2_lh))
	{
	    return 1;
	}
	else
	{
	    return -1;
	}
    }


    sub __get_throws_multisync_nb_multiplex
    {    
	my $nb_multiplex_rh = 0;
	my $nb_multiplex_lh = 0;
	my $cur ="R";
	
	for (my $i = 0; $i < length($_[0]); $i++)
	{
	    my $v = substr($_[0],$i,1);
	    {
		if($v eq "*")
		{
		    if($cur eq "R")
		    {		    
			$cur = "L";
		    }
		    else
		    {
			$cur = "R";
		    }		    		
		}
		elsif($v eq "!")
		{
		    # Nothing to do				
		}
		else
		{
		    if($cur eq "R")
		    {
			if($v ne "0")
			{
			    $nb_multiplex_rh ++;
			}
			if(uc(substr($_[0],$i+1,1) eq "X"))
			{
			    $i++;
			}
			$cur = "L";
		    }
		    else
		    {
			if($v ne "0")
			{
			    $nb_multiplex_lh ++;
			}
			if(uc(substr($_[0],$i+1,1) eq "X"))
			{
			    $i++;
			}
			$cur = "R";
		    }
		}
	    }
	}
	
	return ($nb_multiplex_rh, $nb_multiplex_lh);
    }

    sub __is_sync_throws_multisync
    {
	my $th1 = $_[0];
	my $cur ="R";
	my $start = '';
	my @th1_rh = ();
	my @th1_lh = ();

	for (my $i = 0; $i < length($th1); $i++)
	{
	    my $v = substr($th1,$i,1);
	    
	    if($v eq "*")
	    {
		if($cur eq "R")
		{		    
		    $cur = "L";
		}
		else
		{
		    $cur = "R";
		}		    		
	    }
	    elsif($v eq "!")
	    {
		# Nothing to do
	    }
	    else
	    {
		if($start eq "")
		{
		    $start = $cur;
		}
		else
		{
		    return 1;
		}
		if($cur eq "R")
		{
		    if(uc(substr($th1,$i+1,1)) eq "X")
		    {
			$i++;
		    }		    
		    $cur = "L";
		}
		else
		{
		    if(uc(substr($th1,$i+1,1)) eq "X")
		    {
			$i++;
		    }		
		    $cur = "R";
		}
	    }	    
	}
	
	return -1;	
    }

    my $nb_objs = $_[0];
    my $nbthrows = $nb_objs;
    my $highMaxss=hex($_[1]);
    my $multiplex_rh=$_[2];
    my $multiplex_lh=$_[3];

    if ($_[0] eq "-1") {
	$nbthrows = $MAX_MULT;
    } 

    my @res=();
    my @restmp =();
    my @restmp2 =();

    for (my $i=0; $i <= $highMaxss; $i++) {
	&common::displayComputingPrompt();
	my $v = sprintf("%x",$i);
	my ($mult_rh,$mult_lh)= &__get_throws_multisync_nb_multiplex($v);
	if( $mult_rh <= $multiplex_rh && $mult_lh <= $multiplex_lh)
	{
	    push(@restmp, sprintf("%x",$i));	        # Vanilla 
	    if($i != 0)
	    {
		push(@restmp, sprintf("%x",$i)."X");
	    }
	}
    }

    #  Here we consider the sync form of multisync for vanilla  
    foreach my $el (@restmp) {   
	push(@res,$el."!0")
    }

    # Multiplex, Synchronous and Synchronous Multiplex    
    for (my $i=0; $i < $nbthrows ; $i++) {
	&common::displayComputingPrompt();
	my $drap = -1;
	for (my $j=1; $j <= $highMaxss; $j++) {
	    foreach my $el (@restmp) {   
		&common::displayComputingPrompt();	    
		my $v = $el."!".sprintf("%x",$j);
		my ($mult_rh,$mult_lh)= &__get_throws_multisync_nb_multiplex($v);
		if( $mult_rh <= $multiplex_rh && $mult_lh <= $multiplex_lh)
		{	    
		    $drap = 1;
		    push(@restmp2, $v );
		    if($j != 0)
		    {
			push(@restmp2, $v."X" );
		    }
		}
		if ($el ne "0")                   # Simplification : Avoid some equivalent swap : 0!*A <=> A
		{
		    my $v = $el."!*".sprintf("%x",$j);
		    my ($mult_rh,$mult_lh)= &__get_throws_multisync_nb_multiplex($v);
		    if( $mult_rh <= $multiplex_rh && $mult_lh <= $multiplex_lh)
		    {
			$drap = 1;
			push(@restmp2, $v );		   
			if($j != 0)
			{
			    push(@restmp2, $v."X" );		   
			}
		    }		 
		}   
	    }
	}
	
	foreach my $el (@restmp2) {
	    if(&__is_sync_throws_multisync($el) == 1)
	    {
		push(@res, $el);		   
	    }
	    else
	    {
		#  Here we consider the sync form of multisync for Multiplex  
		push(@res, $el."!0");		   
	    }
	}
	@restmp=@restmp2;
	@restmp2=();
	
	if($drap == -1)
	{		    
	    last;
	}    
    }

    &common::hideComputingPrompt();
    @restmp = @res;
    @res = ();
    foreach my $el (@restmp)
    {
	&common::displayComputingPrompt();
	my ($mult_rh,$mult_lh)= &__get_throws_multisync_nb_multiplex($el);
	if( $mult_rh == $multiplex_rh && $mult_lh == $multiplex_lh)
	{
	    my $drap = -1;
	    foreach my $el2 (@res)
	    {
		&common::displayComputingPrompt();
		if(&__is_equivalent_throws_multisync($el,$el2) == 1)
		{
		    $drap = 1;
		}
	    }
	    if ($drap == -1)
	    {
		push(@res, $el);
	    }
	}
    }
    &common::hideComputingPrompt();

    @res = array_del_duplicate(@res);

    #foreach my $el (@res)
    #{
    #    print $el."\n";
    #}

    return @res;
}


sub __get_states_sync
{
    my $nb_objs=$_[0];
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
	    if (($nb_objs == -1 || int($b =~ tr/1//) == $nb_objs) && ($b1 ne "" && $b2 ne "")) {		
		push(@res, $b1.",".$b2);	
	    }	    
	}		
    }
    
    &common::hideComputingPrompt();
    return sort(@res);
}


# Give all possible Multiplex for Sync siteswap according to a Max SS high and the multiplex size.
sub __get_throws_multiplex_sync_single
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


    my $nb_objs = $_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
    my @res=();
    my @ret=();
    my @restmp =();
    my $nbthrows = 0;

    if ($_[0] == -1) {
	$nbthrows = $multiplex;
    } else {
	if ($nb_objs < $multiplex) {
	    $nbthrows = $nb_objs;
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
    my $nb_objs=$_[0];
    my $highMaxss=int(hex($_[1])/2);
    my $multiplex=$_[2];
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
	    
	    if ($nb_objs != -1) {
		#Last and third Pruning : Final states must not exceed the max number of objects 
		my $c=0;
		for (my $j =0; $j < length($v); $j++) {		    
		    if (substr($v,$j,1) ne ',') {
			$c += hex(substr($v,$j,1))
		    }
		}
		if ($c == $nb_objs) {		    
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
		if ($nb_objs == -1 || (($i + $j) <= $nb_objs)) {
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
		    if ($nb_objs != -1) {
			my $c=0;
			for (my $l =0; $l < length(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand); $l++) {
			    if (substr(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand,$l,1) ne '.') {
				$c += hex(substr(sprintf("%x",$i).$rhand.",".sprintf("%x",$j).$lhand,$l,1));
			    }
			}

			if ($c <= $nb_objs) {
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
    &__get_states_multiplex_sync($_[0], $_[1], $_[2], \@res, $currentHigh+1);
}


sub __get_states_multisync
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
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
	    
	    if ($nb_objs != -1) {
		#Last and third Pruning : Final states must not exceed the max number of objects 
		my $c=0;
		for (my $j =0; $j < length($v); $j++) {		    
		    if (substr($v,$j,1) ne ',') {
			$c += hex(substr($v,$j,1))
		    }
		}
		if ($c == $nb_objs) {		    
		    push(@res,$v);	
		}		
	    } else {
		push(@res,$v);	
	    }
	}		

	&common::hideComputingPrompt();
	@res = sort(@res);
	#for (my $i=0; $i < scalar @res; $i++)
	#{
	#print $res[$i]."\n";
	#}

	return @res;
    }
    
    if ($s == 0) {
	for (my $i=0; $i <= $multiplex; $i++) {	    	        	 
	    for (my $j=0; $j <= $multiplex; $j++) {
		&common::displayComputingPrompt();		
		#First Pruning : new states must not exceed the max number of objects
		if ($nb_objs == -1 || (($i + $j) <= $nb_objs)) {
		    push(@res,sprintf("%x",$i)."|".sprintf("%x",$j));	
		}
	    }		
	}
    } else {    
	for (my $k = 0; $k < $s; $k++) {	
	    my $v = pop(@prev_states); 	
	    for (my $i=0; $i <= $multiplex; $i++) {	    	
		&common::displayComputingPrompt();		
		my $idx = rindex($v,'|');		
		my $rhand=substr($v,0,$idx);
		my $lhand=substr($v,$idx+1);

		for (my $j=0; $j <= $multiplex; $j++) {	    
		    if ($nb_objs != -1) {
			my $c=0;
			for (my $l =0; $l < length(sprintf("%x",$i).$rhand."|".sprintf("%x",$j).$lhand); $l++) {
			    if (substr(sprintf("%x",$i).$rhand."|".sprintf("%x",$j).$lhand,$l,1) ne '.') {
				$c += hex(substr(sprintf("%x",$i).$rhand."|".sprintf("%x",$j).$lhand,$l,1));
			    }
			}

			if ($c <= $nb_objs) {
			    #Second Pruning : new enhanced states must not exceed the max number of objects			    
			    push(@res,sprintf("%x",$i).$rhand."|".sprintf("%x",$j).$lhand); 			    
			}		
		    } else {
			push(@res,sprintf("%x",$i).$rhand."|".sprintf("%x",$j).$lhand); 
		    }
		}		
	    }		
	}
    }
    
    &common::hideComputingPrompt();
    &__get_states_multisync($_[0], $_[1], $_[2], \@res, $currentHigh+1);
}


sub __gen_states_async
{       
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    
    my @matrix=();
    
    # Get all the possible states
    my @states=&__get_states_async($_[0],$_[1]);        

    #build the Matrix    
    foreach my $el (@states) {
	&common::displayComputingPrompt();		
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $b = substr(reverse($el),0,$highMaxss);
	if (substr($b, 0, 1) == 0) {
	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";	    
	    my $bn3=reverse($bn);	    
	    my $idx_bn3 = &__get_idx_state(\@states,$bn3);
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
	    
	    if ($nb_objs==-1) {
		#Adding of an object
		$bn=substr($b, 1, length($b) -1);
		$bn="1".${bn};	
		$bn3=reverse($bn);
		my $idx_bn3 = &__get_idx_state(\@states,$bn3);
		if ( $idx_bn3 >= 0) {
		    $matrix[$idx_state_el][$idx_bn3]="+";
		} elsif (scalar @_ == 2 || (scalar @_ == 3 && $_[2]!=-1)) {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}	    
	    }
	} else {	 
	    if ($nb_objs==-1) {
		#Removing of an object
		my $bn=substr($b, 1, length($b) -1);
		$bn="0".${bn};
		my $bn3=reverse($bn);	    
		my $idx_bn3 = &__get_idx_state(\@states,$bn3);
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
		if (substr($bn, $k, 1) == 0 && $k+1 <= $MAX_HEIGHT) {
		    my $bn2=substr($bn, 0, $k)."1".substr($bn, $k+1, length($bn)-$k);		    
		    my $bn3=reverse($bn2);		   
		    my $idx_bn3 = &__get_idx_state(\@states,$bn3);
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
	    &__genStates_toXLS(\@matrix,\@states,substr($_[2],4),"A,".$_[0].",".$_[1].","."-1,-1");   
	} else {	    	    
	    &__genStates_toSTDOUT(\@matrix,\@states,$_[2], "A,".$_[0].",".$_[1].","."-1,-1");
	}
       	
    } elsif (scalar @_ == 2) {	
	&__genStates_toSTDOUT(\@matrix,\@states, "A,".$_[0].",".$_[1].","."-1,-1");
    }
    
    return (\@matrix, \@states);
}


sub __gen_states_multiplex
{   
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
    
    my @matrix=();
    
    my @states=&__get_states_multiplex($_[0], $_[1], $_[2]);	
    
    #build the Matrix    
    foreach my $el (@states) {
	&common::displayComputingPrompt();		
	my $mult=0;
	my $sum=0;
	my $nstate=-1;	    	
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	$mult = hex(substr($el,length($el)-1));
	
	if ($mult != 0) {
	    # Here the computing is slightly different.
	    # All the possible multiplexes are selected first, and according to them the new states are established.
	    my @mult_list=&__get_throws_multiplex($_[0],$_[1],hex(substr($el,length($el)-1)));
	    
	  LOOP1: foreach my $el_mult (@mult_list) {		  
	      my @nstate_tmp = reverse(split(//, "0".substr($el,0,length($el)-1)));
	      for (my $i=0; $i<length($el_mult); $i++) {
		  &common::displayComputingPrompt();
		  {
		      my $v=hex(substr($el_mult,$i,1));
		      if (hex($nstate_tmp[$v -1]) + 1 > $MAX_HEIGHT) {
			  next LOOP1;
		      }			    
		      $nstate_tmp[$v -1] = sprintf("%x", (hex($nstate_tmp[$v -1]) + 1));  
		  }
	      }

	      $nstate = join('',reverse(@nstate_tmp));
	      
	      my $idx_nstate=&__get_idx_state(\@states,$nstate);
	      if ($idx_nstate >= 0) {		    
		  if (length($el_mult)>=2) {
		      
		      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
			  $matrix[$idx_state_el][$idx_nstate]=
			      "[".$el_mult."]; ".$matrix[$idx_state_el][$idx_nstate];			 
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

	    if ($nb_objs == -1) {
		# Removing of one or several objects
		for (my $r = 1; $r <= $mult; $r ++) {
		    my $nm = $mult - $r;
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=&__get_idx_state(\@states,$nstate);
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
	    my $idx_nstate=&__get_idx_state(\@states,"0".substr($el,0,length($el)-1));
	    if ($idx_nstate >= 0) {		    
		$matrix[$idx_state_el][$idx_nstate]="0";		    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1."0".substr($el,0,length($el)-1)."\n";		    
	    }	    

	    if ($nb_objs == -1) {
		# Adding of one or several objects
		for (my $nm = 1; $nm <= $multiplex; $nm ++) {
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=&__get_idx_state(\@states,$nstate);
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
	    &__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"A,".$_[0].",".$_[1].",".$_[2].",-1");  
	} else {	    
	    &__genStates_toSTDOUT(\@matrix,\@states,$_[3],"A,".$_[0].",".$_[1].",".$_[2].",-1");		  
	}
    } elsif (scalar @_ == 3) {	
	&__genStates_toSTDOUT(\@matrix,\@states,"A,".$_[0].",".$_[1].",".$_[2].",-1");		  
    }

    return (\@matrix, \@states);
}


sub __gen_states_sync
{    
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my @matrix=();    
    my $nstate=();
    
    # Get all the possible states
    my @states=&__get_states_sync($_[0], $_[1]);    

    #build the Matrix    
    foreach my $el (@states) {       
	&common::displayComputingPrompt();		
	my $idx = rindex($el,',');
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $rhand=substr($el,0,$idx);
	my $rhandth=hex(substr($rhand,length($rhand)-1));
	my $lhand=substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));

	if ($rhandth eq "0" && $lhandth eq "0") {		
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    	 	    
	    my $idx_nstates = &__get_idx_state(\@states,$nstate);
	    if ($idx_nstates >=0) {
		$matrix[$idx_state_el][$idx_nstates]="(0,0)";		  	 
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
	    }

	    if ($nb_objs == -1) {
		# Adding of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(+,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Right Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";	    	 	    
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Left Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
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
				my $idx_bn = &__get_idx_state(\@states,substr($bnstate, 0, $l)."1".substr($bnstate, $l+1));
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

	    if ($nb_objs == -1) {
		# Removing of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(-,-)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
		if ($idx_nstates >=0) {
		    $matrix[$idx_state_el][$idx_nstates]="(-,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstates = &__get_idx_state(\@states,$nstate);
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
		    my $idx_bnstate = &__get_idx_state(\@states,$bnstate);
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
	    
	    if ($nb_objs == -1) {
		# Adding of one object (in Left Hand)
		# => Keep object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(,+)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
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
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
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
		    my $idx_bnstate = &__get_idx_state(\@states,$bnstate);
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

	    if ($nb_objs == -1) {
		# Adding of one object (in Right Hand)
		# => Keep object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    $matrix[$idx_state_el][$idx_nstate]="(+,)";		  	 
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
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
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
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
	    &__genStates_toXLS(\@matrix,\@states,substr($_[2],4),"S,".$_[0].",".$_[1].","."-1,-1");		  
	} else {	   
	    &__genStates_toSTDOUT(\@matrix,\@states,$_[2], "S,".$_[0].",".$_[1].","."-1,-1");
	}
	
    } elsif (scalar @_ == 2) {
	&__genStates_toSTDOUT(\@matrix,\@states, "S,".$_[0].",".$_[1].","."-1,-1");
    }
    
    return (\@matrix, \@states);
    
}


sub __gen_states_multiplex_sync
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
    
    my @matrix=();
    
    my @states=&__get_states_multiplex_sync($_[0], $_[1], $_[2]);	
    
    #build the Matrix    
  LOOP_MAIN: foreach my $el (@states) {
      my $idx = rindex($el,',');
      my $idx_state_el=&__get_idx_state(\@states, $el);
      
      my $rhand   =substr($el,0,$idx);
      my $rhandth =hex(substr($rhand,length($rhand)-1));
      my $lhand   =substr($el,$idx+1);
      my $lhandth =hex(substr($lhand,length($lhand)-1));		

      if ($rhandth != 0 && $lhandth != 0) {
	  my @mult_list_right=&__get_throws_multiplex_sync_single($_[0],$_[1],$rhandth);

	LOOP1: foreach my $el_multiplex_right (@mult_list_right) {		
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);
	    
	    for (my $i=0; $i<length($el_multiplex_right); $i++) {
		# Handle x on multiplex from right hand		    
		if (length($el_multiplex_right)>1 && hex(substr($el_multiplex_right, $i, 1)) > 0 && substr($el_multiplex_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> $MAX_HEIGHT) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_multiplex_right, $i, 1)) > 0) {    
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";
		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> $MAX_HEIGHT) {
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
		if ( $r> $MAX_HEIGHT) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
	    }
	    $nlhand = $mult_to_add_loc_tmp;					    
	    $nlhand_sav = $nlhand;

	    my @mult_list_left=&__get_throws_multiplex_sync_single($_[0],$_[1],$lhandth);
	  LOOP2: foreach my $el_multiplex_left (@mult_list_left) {
	      $nrhand = $nrhand_sav;
	      # Handle x on multiplex from right hand on left Hand				
	      $nlhand=$nlhand_sav;	      
	      
	      my $mult_to_add_nrhand='0' x length($nrhand);
	      for (my $i=0; $i<length($el_multiplex_left); $i++) {
		  # Handle x on multiplex from left hand
		  if (length($el_multiplex_left)>1 && hex(substr($el_multiplex_left, $i, 1)) > 0 && substr($el_multiplex_left, $i +1, 1) eq "x") {
		      $mult_to_add_nrhand = ('0' x (length($nrhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      for (my $j=0;$j<length($nrhand);$j++) {
			  my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nrhand = $mult_to_add_loc_tmp;	
		      $i++;
		      #last;
		  } elsif (hex(substr($el_multiplex_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";	
		      for (my $j=0;$j<length($mult_to_add_loc);$j++) {
			  my $r = hex(substr($mult_to_add_loc, $j, 1)) + hex(substr($nlhand, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nlhand = $mult_to_add_loc_tmp;					    
		  }
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=&__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    
		  my $res="(";
		  if (length($el_multiplex_right) > 1 && !(length($el_multiplex_right) == 2 && substr($el_multiplex_right,1,1) eq 'x')) {	
		      $res = $res."[".$el_multiplex_right."],";
		  } else {
		      $res = $res.$el_multiplex_right.",";
		  }
		  
		  if (length($el_multiplex_left) > 1 && !(length($el_multiplex_left) == 2 && substr($el_multiplex_left,1,1) eq 'x')) {
		      $res = $res."[".$el_multiplex_left."])";
		  } else {
		      $res = $res.$el_multiplex_left.")";
		  }
		  if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		      $matrix[$idx_state_el][$idx_nstate]=$res."; ".$matrix[$idx_state_el][$idx_nstate];				
		  } else {
		      $matrix[$idx_state_el][$idx_nstate]=$res;
		  }
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }		
	}

	  if ($nb_objs == -1) {
	      # Removing of one or several objects in Both Hand
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).$nmrhand.",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);

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
	  my @mult_list_right=&__get_throws_multiplex_sync_single($_[0],$_[1],$rhandth);
	  
	LOOP1: foreach my $el_multiplex_right (@mult_list_right) {		
	    &common::displayComputingPrompt();
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);

	    for (my $i=0; $i<length($el_multiplex_right); $i++) {
		# Handle x on multiplex from right hand
		if (length($el_multiplex_right)>1 && hex(substr($el_multiplex_right, $i, 1)) > 0 && substr($el_multiplex_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> $MAX_HEIGHT) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_multiplex_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";

		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> $MAX_HEIGHT) {
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
		if ( $r> $MAX_HEIGHT) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
	    }
	    $nlhand=$mult_to_add_loc_tmp;
	    
	    my $nstate=$nrhand.",".$nlhand;
	    my $idx_nstate=&__get_idx_state(\@states, $nstate);

	    if ($idx_nstate >= 0) {		    
		my $res="(";
		if (length($el_multiplex_right) > 1 && !(length($el_multiplex_right) == 2 && substr($el_multiplex_right,1,1) eq 'x')) {			  
		    $res = $res."[".$el_multiplex_right."],0)";
		} else {
		    $res = $res.$el_multiplex_right.",0)";
		}
		
		if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		    $matrix[$idx_state_el][$idx_nstate]=$res."; ".$matrix[$idx_state_el][$idx_nstate];				
		} else {
		    $matrix[$idx_state_el][$idx_nstate]=$res;				
		}	    
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	    }	    	       		
	}

	  if ($nb_objs == -1) {
	      # Adding of one or several objects (in Left Hand) and Removing of one or several objects (in Right Hand)
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $multiplex; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);
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

	  my @mult_list_left=&__get_throws_multiplex_sync_single($_[0],$_[1],$lhandth);
	  LOOP1 : foreach my $el_multiplex_left (@mult_list_left) {		
	      $nrhand = $nrhand_sav;
	      my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	      my $mult_to_add_nrhand='0' x length($nrhand);

	      for (my $i=0; $i<length($el_multiplex_left); $i++) {
		  # Handle x on multiplex from left hand
		  my $mult_to_add_nrhand = '0' x length($nrhand);
		  if (length($el_multiplex_left)>1 && hex(substr($el_multiplex_left, $i, 1)) > 0 && substr($el_multiplex_left, $i +1, 1) eq "x") {
		      my $mult_to_add_nrhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1)); 
		      my $mult_to_add_nrhand_tmp = "";
		      for (my $j =0; $j < length($mult_to_add_nrhand); $j++) {
			  my $r = hex(substr($mult_to_add_nrhand,$j,1)) + hex(substr($mult_to_add_nrhand2,$j,1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP1;
			  }
			  $mult_to_add_nrhand_tmp = $mult_to_add_nrhand_tmp.(sprintf("%x",$r));			
		      }
		      $mult_to_add_nrhand = $mult_to_add_nrhand_tmp;
		      $i++;
		      #last;
		  } elsif (hex(substr($el_multiplex_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      
		      for (my $j=0;$j<length($nlhand);$j++) {
			  my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
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
		      if ( $r> $MAX_HEIGHT) {
			  next LOOP1;
		      }
		      $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		  }
		  $nrhand = $mult_to_add_loc_tmp;
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=&__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    
		  my $res="(0,";

		  if (length($el_multiplex_left) > 1 && !(length($el_multiplex_left) == 2 && substr($el_multiplex_left,1,1) eq 'x')) {
		      $res = $res."[".$el_multiplex_left."])";
		  } else {
		      $res = $res.$el_multiplex_left.")";
		  }
		  
		  if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		      $matrix[$idx_state_el][$idx_nstate]=$res."; ".$matrix[$idx_state_el][$idx_nstate];      
		  } else {
		      $matrix[$idx_state_el][$idx_nstate]=$res;				
		  }	    
		  
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }

	  if ($nb_objs == -1) {
	      # Adding of one or several objects (in Right Hand) and Removing of one or several objects (in Left Hand)
	      for (my $nmrhand = 0; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);

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
	  my $idx_nstate=&__get_idx_state(\@states, $nstate);

	  if ($idx_nstate >= 0) {		    
	      my $res="(0,0)";
	      if ($matrix[$idx_state_el][$idx_nstate] ne "") {
		  $matrix[$idx_state_el][$idx_nstate]=$res."; ".$matrix[$idx_state_el][$idx_nstate];				
	      } else {
		  $matrix[$idx_state_el][$idx_nstate]=$res;				
	      }				  
	  } else {
	      &common::hideComputingPrompt();
	      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	  }	

	  if ($nb_objs == -1) {
	      #Adding of one or several objects (in each hand)
	      # ==> Both Hands
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		      $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);
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
		  my $idx_nstate=&__get_idx_state(\@states, $nstate);
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
		  my $idx_nstate=&__get_idx_state(\@states, $nstate);

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
	    &__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"S,".$_[0].",".$_[1].",".$_[2].",-1");	
	} else {	    
	    &__genStates_toSTDOUT(\@matrix,\@states,$_[3],"S,".$_[0].",".$_[1].",".$_[2].",-1");
	}
    } elsif (scalar @_ == 3) {
	&__genStates_toSTDOUT(\@matrix,\@states,"S,".$_[0].",".$_[1].",".$_[2].",-1");
    }
    
    return (\@matrix, \@states);
}


sub __gen_states_multisync
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
    
    my @matrix=();    
    my @states=&__get_states_multisync($_[0], $_[1], $_[2]);	
    
    #build the Matrix    
    foreach my $el (@states) {
	&common::displayComputingPrompt();
	my $idx = rindex($el,'|');
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $rhand   =substr($el,0,$idx);
	my $rhandth =hex(substr($rhand,length($rhand)-1));
	my $lhand   =substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));		
	
	my @multisync_list=&__get_throws_multisync($_[0],$_[1],$rhandth,$lhandth);

	foreach my $elmult (@multisync_list) {		
	    &common::displayComputingPrompt();
	    my $elmult_final = $elmult;
	    my $nrhand=reverse('0'.substr($rhand,0,length($rhand)-1));
	    my $nlhand=reverse('0'.substr($lhand,0,length($lhand)-1));
	    my $nrhand_tmp = '';
	    my $nlhand_tmp = '';

	    my $cur = "R";
	    my $beat = 0;

	    for (my $i=0; $i<length($elmult); $i++) {
		&common::displayComputingPrompt();
		my $v = substr($elmult,$i,1);		
		if($v eq "*")
		{
		    if($cur eq "R")
		    {
			$cur = "L";
		    }
		    else
		    {
			$cur = "R";
		    }		    		
		}
		elsif($v eq "!")
		{
		    # Nothing to do
		}
		else
		{
		    $v = hex($v);
		    if($cur eq "R")
		    {
			if($v ne "0")
			{
			    if(($v % 2 == 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($elmult,$i+1,1)) eq "X"))
			    {
				$nrhand_tmp = $nrhand;
				$nrhand_tmp = substr($nrhand,0,$v-1).sprintf("%x",(1+hex(substr($nrhand,$v-1,1)))).substr($nrhand,$v);
				$nrhand = $nrhand_tmp;
			    }
			    elsif(($v % 2 != 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($elmult,$i+1,1)) eq "X"))
			    {
				$nlhand_tmp = $nlhand;
				$nlhand_tmp = substr($nlhand,0,$v-1).sprintf("%x",(1+hex(substr($nlhand,$v-1,1)))).substr($nlhand,$v); 
				$nlhand = $nlhand_tmp;
			    }
			    if(uc(substr($elmult,$i+1,1)) eq "X")
			    {
				$i++;
			    }
			}
			$cur = "L";
		    }
		    else
		    {
			if($v ne "0")
			{
			    if(($v % 2 == 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($elmult,$i+1,1)) eq "X"))		       
			    {
				$nlhand_tmp = $nlhand;
				$nlhand_tmp = substr($nlhand,0,$v-1).sprintf("%x",(1+hex(substr($nlhand,$v-1,1)))).substr($nlhand,$v); 
				$nlhand = $nlhand_tmp;
			    }
			    elsif(($v % 2 != 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($elmult,$i+1,1)) eq "X"))			  
			    {
				$nrhand_tmp = $nrhand;
				$nrhand_tmp = substr($nrhand,0,$v-1).sprintf("%x",(1+hex(substr($nrhand,$v-1,1)))).substr($nrhand,$v);			
				$nrhand = $nrhand_tmp;
			    }
			    if(uc(substr($elmult,$i+1,1)) eq "X")
			    {
				$i++;
			    }
			}
			$cur = "R";
		    }
		}
	    }
	    
	    my $idx_nstate=&__get_idx_state(\@states, reverse($nrhand)."|".reverse($nlhand));
	    if($idx_nstate == -1)
	    {
		if ($SSWAP_DEBUG>=1) 
		{			
		    print "== SSWAP::__gen_states_multisync : Rejected State : ".reverse($nrhand)."|".reverse($nlhand)."\n";
		}
	    }
	    else
	    {
		if($matrix[$idx_state_el][$idx_nstate] eq "")
		{
		    $matrix[$idx_state_el][$idx_nstate] = $elmult_final;
		}
		else
		{
		    $matrix[$idx_state_el][$idx_nstate] = $elmult_final."; ".$matrix[$idx_state_el][$idx_nstate];
		}
	    }
	}

	if($nb_objs == -1)
	{
	    # Handle Objects Lost or Added
	    my $nrhand=substr($rhand,0,length($rhand)-1);
	    my $nlhand=substr($lhand,0,length($lhand)-1);
	    my $rhandth=hex(substr($rhand,length($rhand)-1));
	    my $lhandth=hex(substr($lhand,length($lhand)-1));		

	    if($rhandth >=1 || $lhandth >= 1)
	    {
		for(my $i=0; $i<=$rhandth; $i++)
		{
		    for(my $j=0;$j<=$lhandth; $j++)
		    {		  
			my $idx_nstate=&__get_idx_state(\@states, $nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j));
			my $tr = '';
			if($rhandth-$i > 0)
			{
			    $tr="-".sprintf("%x",$rhandth-$i)."|";
			}
			else
			{
			    $tr = "|";
			}
			if($lhandth-$j > 0)
			{
			    $tr=$tr."-".sprintf("%x",$lhandth-$j);
			}
			
			if($tr ne "|")
			{
			    if($matrix[$idx_state_el][$idx_nstate] eq "")
			    {		      
				$matrix[$idx_state_el][$idx_nstate] = $tr;
			    }
			    else
			    {
				$matrix[$idx_state_el][$idx_nstate] = $tr."; ".$matrix[$idx_state_el][$idx_nstate];
			    }	
			}	      
		    }
		}
	    }
	    elsif($rhandth == 0 && $lhandth == 0)
	    {
		for(my $i=0; $i<=$multiplex; $i++)
		{
		    for(my $j=0;$j<=$multiplex; $j++)
		    {		  
			my $idx_nstate=&__get_idx_state(\@states, $nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j));		      
			my $tr='';
			if($i > 0)
			{
			    $tr = "+".sprintf("%x",$i)."|"; 
			}
			else
			{
			    $tr="|",
			}
			if($j > 0)
			{
			    $tr = $tr."+".sprintf("%x",$j); 
			}
			if($tr ne "|")
			{
			    if($matrix[$idx_state_el][$idx_nstate] eq "")
			    {		      
				$matrix[$idx_state_el][$idx_nstate] = $tr;
			    }
			    else
			    {
				$matrix[$idx_state_el][$idx_nstate] = $tr."; ".$matrix[$idx_state_el][$idx_nstate];
			    }	
			}		          
		    }
		}	      
	    }

	    if($rhandth == 0 && $lhandth != 0)
	    {
		for(my $i=1; $i<=$multiplex; $i++)
		{
		    for(my $j=0;$j<=$lhandth; $j++)
		    {
			my $idx_nstate=&__get_idx_state(\@states, $nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j));
			my $tr = "+".sprintf("%x",$i)."|";
			if($lhandth-$j > 0)
			{
			    $tr=$tr."-".sprintf("%x",$lhandth-$j);
			}		      
			if($matrix[$idx_state_el][$idx_nstate] eq "")
			{		      
			    $matrix[$idx_state_el][$idx_nstate] = $tr;
			}
			else
			{
			    $matrix[$idx_state_el][$idx_nstate] = $tr."; ".$matrix[$idx_state_el][$idx_nstate];
			}
		    }
		}
	    }		 
	    elsif($lhandth == 0 && $rhandth != 0)
	    {
		for(my $i=0; $i<=$rhandth; $i++)
		{
		    for(my $j=1;$j<=$multiplex; $j++)
		    {
			my $idx_nstate=&__get_idx_state(\@states, $nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j));
			my $tr = '';
			if($rhandth-$i > 0)
			{
			    $tr="-".sprintf("%x",$rhandth-$i)."|";
			}
			else
			{
			    $tr = "|";
			}
			$tr=$tr."+".sprintf("%x",$j);
			if($matrix[$idx_state_el][$idx_nstate] eq "")
			{		      
			    $matrix[$idx_state_el][$idx_nstate] = $tr;
			}
			else
			{
			    $matrix[$idx_state_el][$idx_nstate] = $tr."; ".$matrix[$idx_state_el][$idx_nstate];
			}
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
	    &__genStates_toXLS(\@matrix,\@states,substr($_[3],4),"MULTI,".$_[0].",".$_[1].",".$_[2].",-1");	
	} else {	    
	    &__genStates_toSTDOUT(\@matrix,\@states,$_[3],"MULTI,".$_[0].",".$_[1].",".$_[2].",-1");
	}
    } elsif (scalar @_ == 3) {
	&__genStates_toSTDOUT(\@matrix,\@states,"MULTI,".$_[0].",".$_[1].",".$_[2].",-1");
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
    my $genFilter="dot";

    if (scalar @_ > 3 && $_[3] ne "") {
	$fileOutputType=$_[3];
    }
    if (scalar @_ > 4 && $_[4] ne "") {
	$genFilter=$_[4];
    }


    open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
    print GRAPHVIZ "digraph Transition_States_Matrix{\n";    
    
    print GRAPHVIZ "node [color=blue]\n";
    foreach my $i (@states) {		
	print GRAPHVIZ "\"".${i}."\""." [label=\"".${i}."\"] // node ".${i}."\n";
    }
    
    foreach my $i (@states) {	
	foreach my $j (@states) {
	    my $idx_state_i=&__get_idx_state(\@states, $i);
	    my $idx_state_j=&__get_idx_state(\@states, $j);
	    if ($matrix[$idx_state_i][$idx_state_j] ne "") {
		print GRAPHVIZ "\"".${i}."\""."->"."\"".${j}."\""." [taillabel=\"".$matrix[$idx_state_i][$idx_state_j]."\", fontcolor=red, fontname=\"Times-Bold\"]\n";	
	    }
	}	
    }
    
    print GRAPHVIZ "}";
    close GRAPHVIZ;        
    print $lang::MSG_GENERAL_GRAPHVIZ;
    system("\"".$conf::GRAPHVIZ_BIN."\\".$genFilter.".exe\" -T".$fileOutputType." -Nfontsize=\"12\" -Efontsize=\"12\" -v -o"."$conf::RESULTS/$fileOutput"." $conf::TMPDIR\\${fileOutput}.graphviz");   

    if ($SSWAP_DEBUG <= 0) {	
	unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
    }    
}


sub drawStates
{
    my $mod = uc(shift);
    my $res1 = "";
    my $stat1 = "";

    # Get the States/Transitions Matrix
    # XLS File with States/Transitions Matrix is provided to speed up the computation
    if(($mod eq "V" || $mod eq "S") && scalar @_ > 5)
    {
	&__check_xls_matrix_file($_[5],$mod,$_[0],$_[1],-1,-1);
	($res1, $stat1) = &__getStates_from_xls($_[5]);
	shift; shift;
    }
    elsif (($mod eq "M" || $mod eq "MS" || $mod eq "SM" || $mod eq "MULTI") && scalar @_ > 6)
    {
	&__check_xls_matrix_file($_[6],$mod,$_[0],$_[1],$_[2],-1);
	($res1, $stat1) = &__getStates_from_xls($_[6]);	    
	shift; shift; shift;
    }
    else
    {	
	if ($mod eq "V") {
	    ($res1, $stat1) =&__gen_states_async($_[0],$_[1],-1);	    
	    shift; shift;
	} elsif ($mod eq "M") {
	    ($res1, $stat1)=&__gen_states_multiplex($_[0],$_[1],$_[2],-1);
	    shift; shift; shift;
	} elsif ($mod eq "S") {
	    ($res1, $stat1)=&__gen_states_sync($_[0],$_[1],-1);	    
	    shift; shift;
	} elsif ($mod eq "SM" || $mod eq "MS") {
	    ($res1, $stat1)=&__gen_states_multiplex_sync($_[0],$_[1],$_[2],-1);	    
	    shift; shift; shift;
	} elsif ($mod eq "MULTI") {
	    ($res1, $stat1)=&__gen_states_multisync($_[0],$_[1],$_[2],-1);
	    shift; shift; shift;
	} else {
	    return -1;
	}
    }
    
    my @res=@{$res1};
    my @states=@{$stat1};

    &__drawStates(\@res,\@states,@_);
}


sub drawStatesAggr
{
    my $mod = uc(shift);
    my $res1 = "";
    my $stat1 = "";

    # Get the States/Transitions Matrix
    # XLS File with States/Transitions Matrix is provided to speed up the computation
    if(($mod eq "V" || $mod eq "S") && scalar @_ > 5)
    {
	&__check_xls_matrix_file($_[5],$mod,$_[0],$_[1],-1,"R");
	($res1, $stat1) = &__getStates_from_xls($_[5]);
	shift; shift;
    }
    elsif (($mod eq "M" || $mod eq "MS" || $mod eq "SM" || $mod eq "MULTI") && scalar @_ > 6)
    {
	&__check_xls_matrix_file($_[6],$mod,$_[0],$_[1],$_[2],"R");
	($res1, $stat1) = &__getStates_from_xls($_[6]);	    
	shift; shift; shift;
    }
    else
    {	
	if ($mod eq "V") {
	    ($res1, $stat1) = &genStatesAggr('V',$_[0],$_[1],-1);	    
	    shift; shift;
	} elsif ($mod eq "M") {
	    ($res1, $stat1)= &genStatesAggr('M',$_[0],$_[1],$_[2],-1);
	    shift; shift; shift;
	} elsif ($mod eq "S") {
	    ($res1, $stat1)= &genStatesAggr('S',$_[0],$_[1],-1);	    
	    shift; shift;
	} elsif ($mod eq "SM" || $mod eq "MS") {
	    ($res1, $stat1)= &genStatesAggr('MS',$_[0],$_[1],$_[2],-1);	    	
	    shift; shift; shift;
	} elsif ($mod eq "MULTI") {
	    ($res1, $stat1)= &genStatesAggr('MULTI',$_[0],$_[1],$_[2],-1);	    	
	    shift; shift; shift;
	} else {
	    return -1;
	}
    }
    
    my @res=@{$res1};
    my @states=@{$stat1};
    
    &__drawStates(\@res,\@states,@_);
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


sub genSSFromStates
{    
    my $mod = $_[0];
    my $nb_objs = $_[1];
    my $height = hex($_[2]);
    my $depth = '';
    my $opts = '';
    my $mult = '';
    my @result_last = ();    
    
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the lit
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $title = '-- SITESWAPS GENERATION FROM STATES/TRANSITIONS DIAGRAMS --'; 
    my $extra_info = "N";
    my $ground_check = "N";     # Get only Ground States or no (default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)    
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    
    my $f = "";
    my $run_browser = -1;

    if(uc($mod) eq "V" || uc($mod) eq "S")
    {
	$depth=$_[3];
	$opts=$_[4];
	&GetOptionsFromString(uc($_[4]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );	
	$f = $_[5];
    }
    elsif(uc($mod) eq "M" || uc($mod) eq "MS" || uc($mod) eq "SM" || uc($mod) eq "MULTI")
    {
	$mult = $_[3];
	$depth=$_[4];
	$opts=$_[5];
	&GetOptionsFromString(uc($_[5]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );
	$f = $_[6];
    }
    else
    {
	if(scalar @_ == 1 || $_[1] ne "-1")
	{
	    if((scalar @_ < 5 || $_[5] ne "-1") && (scalar @_ < 6 || $_[6] ne "-1"))
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSFROMSTATES_ERR1."\n";
	    }
	}
	return -1;
    }

    # build the Matrix    
    my $matrix_tmp ='';
    my $states_tmp ='';
    if(uc($mod) eq "V" || uc($mod) eq "S")
    {
	# Get the States/Transitions Matrix
	if(scalar @_ > 6)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[6],$mod,$nb_objs,sprintf("%x",$height),-1,-1);
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[6]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,"-1");	    
	}
    }
    else
    {
	# Get the States/Transitions Matrix
	if(scalar @_ > 7)
	{	    
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[7],$mod,$nb_objs,sprintf("%x",$height),$mult,-1);
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[7]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,$mult,"-1");	    
	}
    }
    my @matrix=@{$matrix_tmp};
    my @states=@{$states_tmp};   
    my $result = new Set::Scalar();    
    
    foreach my $el (@states) 
    {	
	&common::displayComputingPrompt();
	if(uc($mod) eq "MS" || uc($mod) eq "SM" || uc($mod) eq "S")
	{
	    $result = &__gen_transit_btwn_states(\@matrix,\@states,int($depth/2),$el,$el,"-1");
	}
	else
	{
	    $result = &__gen_transit_btwn_states(\@matrix,\@states,$depth,$el,$el,"-1");
	}

	while (defined(my $e = $result->each)) 
	{
	    &common::displayComputingPrompt();	    
	    my $checking_process = 1;
	    if(uc($ground_check) eq "Y")
	    {
	     	if (&getSSstatus($e,-1) ne "GROUND")
	     	{
	     	    $checking_process = -1;
	     	}
	    }
	    
	    if($checking_process == 1 && uc($prime_check) eq "Y")
	    {
		if(&isPrime($e,-1) != 1)
		{
		    $checking_process = -1;
		}
	    }

	    if($checking_process == 1 && uc($reversible_check) eq "Y")
	    {
		if(&isReversible($e,-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($scramblable_check) eq "Y")
	    {
		if(&isScramblable($e,'',-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($magic_check) eq "Y")
	    {
		if(&isFullMagic($e,-1) < 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($palindrome_check) eq "Y")
	    {
		if(&isPalindrome($e,-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($squeeze_check) eq "Y")
	    {
		if(&isSqueeze($e,-1) == 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1)
	    {
		push(@result_last,$e);
	    }
	}
    }

    &common::hideComputingPrompt();

    if ($f ne "" && $f ne "-1") {	    	    	    	    
	if ("JML:"=~substr($f,0,4)) {	
	    my $f_tmp=$f;
	    $f =substr($f,4);    
	    
	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\"".$title."\""."/>\n";	   
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\"/>\n";     
	    if ($remove_redundancy != 0) {
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\"/>\n";    
	    }
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\"/>\n";	    
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\"/>\n";	
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\"/>\n";			
	    print FILE_JML "<line display=\"========================================\"/>\n";	   	    
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;

	    @result_last = &printSSListWithoutHeaders((\@result_last,$opts,$f_tmp));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr($f,0,7))
	{
	    my $f_tmp=$f;
	    $f =substr($f,7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."<BR/>\n";     
	    if ($remove_redundancy != 0) {
	    	print $lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."<BR/>\n";     
	    }
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."<BR/>\n";     	    
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."<BR/>\n";	
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."<BR/>\n";	
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		
	    
	    @result_last = &printSSListInfoHTMLWithoutHeaders(\@result_last,$opts,$f_tmp);					
	    $run_browser = 1;
	}

	else {
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n\n";
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\n";     
	    if ($remove_redundancy != 0) {
	    	print $lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\n";     
	    }
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    close(FILE);		
	    
	    @result_last = &printSSListWithoutHeaders((\@result_last,$opts,$f));
	}
    }
    elsif ($f eq "") {
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\n";     
	if ($remove_redundancy != 0) {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\n";     
	}
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\n";	
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\n";		
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	@result_last = &printSSListWithoutHeaders((\@result_last,$opts));
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	my $pwd = cwd();
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return @result_last;
}



sub genSSFromStatesAggr
{    
    my $mod = $_[0];
    my $nb_objs = $_[1];
    my $height = hex($_[2]);
    my $depth = '';
    my $opts = '';
    my $mult = '';
    my @result_last = ();    
    
    my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the lit
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $title = '-- SITESWAPS GENERATION FROM REDUCED STATES/TRANSITIONS DIAGRAMS --'; 
    my $extra_info = "N";
    my $ground_check = "N";     # Get only Ground States or no (default)
    my $prime_check = "N";      # Get only prime States or no (default)
    my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $reversible_check = "N"; # Get only Reversible Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)    
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    
    my $f = "";
    my $run_browser = -1;

    if(uc($mod) eq "V" || uc($mod) eq "S")
    {
	$depth=$_[3];
	$opts=$_[4];
	&GetOptionsFromString(uc($_[4]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );
	$f = $_[5];
	
    }
    elsif(uc($mod) eq "M" || uc($mod) eq "MS" || uc($mod) eq "SM" || uc($mod) eq "MULTI")
    {
	$mult = $_[3];
	$depth=$_[4];
	$opts=$_[5];
	&GetOptionsFromString(uc($_[5]),    
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
	    );
	$f = $_[6];
    }
    else
    {
	if(scalar @_ == 1 || $_[1] ne "-1")
	{
	    if((scalar @_ < 5 || $_[5] ne "-1") && (scalar @_ < 6 || $_[6] ne "-1"))
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSFROMSTATES_ERR1."\n";
	    }
	}
	return -1;
    }

    # build the Matrix    
    my $matrix_tmp ='';
    my $states_tmp ='';
    if(uc($mod) eq "V" || uc($mod) eq "S")
    {
	# Get the States/Transitions Matrix
	if(scalar @_ > 6)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[6],$mod,$nb_objs,sprintf("%x",$height),-1,"R");
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[6]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$nb_objs,$height,"-1");	    
	}
    }
    else
    {
	# Get the States/Transitions Matrix
	if(scalar @_ > 7)
	{	    
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[7],$mod,$nb_objs,sprintf("%x",$height),$mult,-1);
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[7]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$nb_objs,$height,$mult,"R");	    
	}
    }
    my @matrix=@{$matrix_tmp};
    my @states=@{$states_tmp};   
    my $result = new Set::Scalar();    

    foreach my $el (@states) 
    {	
	&common::displayComputingPrompt();
	if(uc($mod) eq "MS" || uc($mod) eq "SM" || uc($mod) eq "S")
	{
	    $result = &__gen_transit_btwn_states_aggr(\@matrix,\@states,int($depth/2),$el,$el,"-1");
	}
	else
	{
	    $result = &__gen_transit_btwn_states_aggr(\@matrix,\@states,$depth,$el,$el,"-1");
	}
	while (defined(my $e = $result->each)) 
	{
	    my $checking_process = 1;
	    if(uc($ground_check) eq "Y")
	    {
		if (&getSSstatus($e,-1) ne "GROUND")
		{
		    $checking_process = -1;
		}
	    }
	    
	    if($checking_process == 1 && uc($prime_check) eq "Y")
	    {
		if(&isPrime($e,-1) != 1)
		{
		    $checking_process = -1;
		}
	    }

	    if($checking_process == 1 && uc($reversible_check) eq "Y")
	    {
		if(&isReversible($e,-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($scramblable_check) eq "Y")
	    {
		if(&isScramblable($e,'',-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($magic_check) eq "Y")
	    {
		if(&isFullMagic($e,-1) < 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($palindrome_check) eq "Y")
	    {
		if(&isPalindrome($e,-1) != 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1 && uc($squeeze_check) eq "Y")
	    {
		if(&isSqueeze($e,-1) == 1)
		{
		    $checking_process = -1;			    
		}
	    }

	    if($checking_process == 1)
	    {
		push(@result_last,$e);
	    }

	}
    }
    
    &common::hideComputingPrompt();

    if ($f ne "" && $f ne "-1") {	    	    	    	    
	if ("JML:"=~substr($f,0,4)) {	
	    my $f_tmp=$f;
	    $f =substr($f,4);    
	    
	    open(FILE_JML,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE_JML "<?xml version=\"1.0\"?>\n";
	    print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML "<patternlist>\n";
	    print FILE_JML "<title>".$title."</title>\n";
	    print FILE_JML "<line display=\"".$title."\""."/>\n";	   
	    print FILE_JML "<line display=\"========================================\"/>\n";	   
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\"/>\n";     
	    if ($remove_redundancy != 0) {
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\"/>\n";    
	    }
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\"/>\n";	    
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\"/>\n";	
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\"/>\n";			
	    print FILE_JML "<line display=\"========================================\"/>\n";	   	    
	    print FILE_JML "<line display=\"\"/>\n";	   
	    close FILE_JML;

	    @result_last = &printSSListWithoutHeaders((\@result_last,$opts,$f_tmp));
	    
	    #system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f.jml");
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f.jml\n";     

	}
	elsif("SSHTML:"=~substr($f,0,7))
	{
	    my $f_tmp=$f;
	    $f =substr($f,7).".html";
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE $title."<BR/>\n";
	    print FILE "\n================================================================<BR/>\n";	   
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."<BR/>\n";     
	    if ($remove_redundancy != 0) {
	    	print $lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."<BR/>\n";     
	    }
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."<BR/>\n";     	    
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."<BR/>\n";	
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."<BR/>\n";	
	    print FILE "================================================================<BR/>\n\n";
	    close(FILE);		
	    
	    @result_last = &printSSListInfoHTMLWithoutHeaders(\@result_last,$opts,$f_tmp);					
	    $run_browser = 1;
	}

	else {
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n\n";
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\n";     
	    if ($remove_redundancy != 0) {
	    	print $lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\n";     
	    }
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    close(FILE);		
	    
	    @result_last = &printSSListWithoutHeaders((\@result_last,$opts,$f));
	}
    }
    elsif ($f eq "") {
	print colored [$common::COLOR_RESULT], $title."\n";
	print colored [$common::COLOR_RESULT], "\n================================================================\n";     
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG1." : ".uc($_[0])."\n";     
	if ($remove_redundancy != 0) {
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG2."\n";     
	}
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG3.": ".$height."\n";	
	print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENSSFROMSTATES_MSG4.": ".$depth."\n";		
	print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	@result_last = &printSSListWithoutHeaders((\@result_last,$opts));
    }

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	my $pwd = cwd();
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }
    
    return @result_last;
}



sub genTransBtwnStates
{
    sub genTransBtwnStates_in
    {    
	my $mod = '';
	my $nb_objs = '';
	my $height = '';
	my $start_state = $_[0];
	my $end_state = $_[1];
	my $depth = $_[2];
	my $opts = $_[3];
	my $f = $_[4];
	# $_[5] : XLS File with States/Transitions Matrix is provided to speed up the computation
	my $mult = 1;
	my $heightMax = -1;
	my @result_last1 = ();    
	my @result_last2 = ();    
	
	my $title = '-- TRANSITIONS BETWEEN STATES FROM STATES/TRANSITIONS DIAGRAMS --'; 

	&GetOptionsFromString(uc($_[3]),    
			      "-M:s" => \$mult,		
			      "-H:i" => \$heightMax,			  
	    );
	
	if($heightMax != -1)
	{
	    $heightMax = hex($heightMax);
	}

	my $nb_objs1=0;
	my $nb_objs2=0;
	my $v = '';
	my $mod1a = "V";
	my $mod2a = "V";
	my $mod1b = "";
	my $mod2b = "";

	for(my $i=0; $i < length $start_state;$i++)
	{
	    $v = substr($start_state,$i, 1);
	    if($v eq '(' || $v eq ')')
	    {
		$i++;
	    }
	    elsif($v eq ",")
	    {
		$mod1a = "S";
	    }
	    elsif($v eq "|")
	    {
		$mod1a = "MULTI";
	    }
	    else
	    {
		if($v > 1)
		{
		    $mod1b = "M";
		    if($v > $mult)
		    {
			$mult = $v;
		    }
		}	
		$nb_objs1 += $v;
	    }
	}

	for(my $i=0; $i < length $end_state;$i++)
	{
	    $v = substr($end_state,$i, 1);
	    if($v eq '(' || $v eq ')')
	    {
		$i++;
	    }
	    elsif($v eq ",")
	    {
		$mod2a = "S";	   
	    }
	    elsif($v eq "|")
	    {
		$mod2a = "MULTI";
	    }
	    else
	    {
		if($v > 1)
		{
		    $mod2b = "M";
		    if($v > $mult)
		    {
			$mult = $v;
		    }
		}	
		$nb_objs2 += $v;
	    }
	}
	
	if($mod1a != $mod2a)
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSTATES_ERR1." : ".$mod1a." != ".$mod2a."\n";
	    }
	    return -1;
	}

	if($mult > 1)
	{
	    if($mod1a eq "S")
	    {
		$mod = "MS";
	    }
	    elsif($mod1a eq "MULTI")
	    {
		$mod = "MULTI";
	    }
	    else
	    {
		$mod ="M";
	    }
	}
	else
	{
	    $mod = $mod1a;
	}

	if($nb_objs1 != $nb_objs2)
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSTATES_ERR2." : ".$nb_objs1." != ".$nb_objs2."\n";
	    }
	    return -1;
	}
	else
	{
	    $nb_objs = $nb_objs1; 
	}
	
	if($heightMax != -1)
	{
	    $height = $heightMax;
	}
	else
	{
	    $height = length($start_state);
	    if(length($end_state) > $height)
	    {
		$height = length($end_state);
	    }
	}

	if ($mod eq "S" ||$mod eq "MS" ||$mod eq "SM")
	{
	    $depth = int($depth / 2);
	}

	# build the Matrix    
	my @matrix=();
	my @states=();   
	my $result = new Set::Scalar();    
	my $matrix_tmp ='';
	my $states_tmp ='';
	
	if(scalar @_ > 5)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		&__check_xls_matrix_file($_[5],$mod,$nb_objs,sprintf("%x",$height),-1,-1);
	    }
	    else
	    {
		&__check_xls_matrix_file($_[5],$mod,$nb_objs,sprintf("%x",$height),$mult,-1);
	    }
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[5]); 
	}
	else
	{
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,"-1");	    
	    }
	    else
	    {
		($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,$mult,"-1");	    
	    }
	}
	@matrix=@{$matrix_tmp};
	@states=@{$states_tmp};   

        # From Initial To Final
	$result = &__gen_transit_btwn_states(\@matrix,\@states,$depth,$start_state,$end_state,"-1");
	while (defined(my $e = $result->each)) 
	{
	    push(@result_last1,$e);
	}
	
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$start_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$end_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    
	    while (defined(my $e = $result->each)) 
	    {		   	    
		print FILE $e."\n";
	    }
	    print FILE "\n[ => ".scalar @result_last1." Transition(s) ]\n";     	        
	    close(FILE);		 
	}	
	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$start_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$end_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result->each)) 
	    {	       
		print $e."\n";		    
	    }		

	    print colored [$common::COLOR_RESULT],"\n[ => ".scalar @result_last1." Transition(s) ]\n";     	        
	}
	
        # From Final To Initial
	$result = &__gen_transit_btwn_states(\@matrix,\@states,$depth,$end_state,$start_state,"-1");
	while (defined(my $e = $result->each)) 
	{
	    push(@result_last2,$e);
	}
	
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE "\n\n\n================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$end_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$start_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    
	    while (defined(my $e = $result->each)) 
	    {		   	    
		print FILE $e."\n";
	    }
	    print FILE "\n[ => ".scalar @result_last2." Transition(s) ]\n";     	        
	    close(FILE);		 
	}	
	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], "\n\n\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$end_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$start_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result->each)) 
	    {	       
		print $e."\n";		    
	    }		

	    print colored [$common::COLOR_RESULT],"\n[ => ".scalar @result_last2." Transition(s) ]\n";     	        
	}
	
	return (\@result_last1, \@result_last2) ;
    }


    return &genTransBtwnStates_in(@_);

}


sub genTransBtwnStatesAggr
{
    sub genTransBtwnStatesAggr_in
    {    
	my $mod = '';
	my $nb_objs = '';
	my $height = '';
	my $start_state = $_[0];
	my $end_state = $_[1];
	my $depth = $_[2];
	my $opts = $_[3];
	my $f = $_[4];
	# $_[5] : XLS File with States/Transitions Matrix is provided to speed up the computation
	my $mult = 1;
	my $heightMax = -1;
	my @result_last1 = ();    
	my @result_last2 = ();    

	my $title = '-- TRANSITIONS BETWEEN STATES FROM REDUCED STATES/TRANSITIONS DIAGRAMS --'; 

	&GetOptionsFromString(uc($_[3]),    
			      "-M:s" => \$mult,		
			      "-H:i" => \$heightMax,			  
	    );
	
	if($heightMax != -1)
	{
	    $heightMax = hex($heightMax);
	}

	my $nb_objs1=0;
	my $nb_objs2=0;
	my $v = '';
	my $mod1a = "V";
	my $mod2a = "V";
	my $mod1b = "";
	my $mod2b = "";

	for(my $i=0; $i < length $start_state;$i++)
	{
	    $v = substr($start_state,$i, 1);
	    if($v eq '(' || $v eq ')')
	    {
		$i++;
	    }
	    elsif($v eq ",")
	    {
		$mod1a = "S";
	    }
	    elsif($v eq "|")
	    {
		$mod1a = "MULTI";
	    }
	    else
	    {
		if($v > 1)
		{
		    $mod1b = "M";
		    if($v > $mult)
		    {
			$mult = $v;
		    }
		}	
		$nb_objs1 += $v;
	    }
	}

	for(my $i=0; $i < length $end_state;$i++)
	{
	    $v = substr($end_state,$i, 1);
	    if($v eq '(' || $v eq ')')
	    {
		$i++;
	    }
	    elsif($v eq ",")
	    {
		$mod2a = "S";	   
	    }
	    elsif($v eq "|")
	    {
		$mod2a = "MULTI";
	    }
	    else
	    {
		if($v > 1)
		{
		    $mod2b = "M";
		    if($v > $mult)
		    {
			$mult = $v;
		    }
		}	
		$nb_objs2 += $v;
	    }
	}
	
	if($mod1a != $mod2a)
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSTATES_ERR1." : ".$mod1a." != ".$mod2a."\n";
	    }
	    return -1;
	}

	if($mult > 1)
	{
	    if($mod1a eq "S")
	    {
		$mod = "MS";
	    }
	    elsif($mod1a eq "MULTI")
	    {
		$mod = "MULTI";
	    }
	    else
	    {
		$mod ="M";
	    }
	}
	else
	{
	    $mod = $mod1a;
	}

	if($nb_objs1 != $nb_objs2)
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSTATES_ERR2." : ".$nb_objs1." != ".$nb_objs2."\n";
	    }
	    return -1;
	}
	else
	{
	    $nb_objs = $nb_objs1; 
	}
	
	if($heightMax != -1)
	{
	    $height = $heightMax;
	}
	else
	{
	    $height = length($start_state);
	    if(length($end_state) > $height)
	    {
		$height = length($end_state);
	    }
	}

	if ($mod eq "S" ||$mod eq "MS" ||$mod eq "SM")
	{
	    $depth = int($depth / 2);
	}

	# build the Matrix    
	my @matrix=();
	my @states=();   
	my $result = new Set::Scalar();    
	my $matrix_tmp ='';
	my $states_tmp ='';
	
	if(scalar @_ > 5)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		&__check_xls_matrix_file($_[5],$mod,$nb_objs,sprintf("%x",$height),-1,"R");
	    }
	    else
	    {
		&__check_xls_matrix_file($_[5],$mod,$nb_objs,sprintf("%x",$height),$mult,"R");
	    }
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[5]); 
	}
	else
	{
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$nb_objs,$height,"-1");	    
	    }
	    else
	    {
		($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$nb_objs,$height,$mult,"-1");	    
	    }
	}

	@matrix=@{$matrix_tmp};
	@states=@{$states_tmp};   

        # From Initial To Final
	$result = &__gen_transit_btwn_states_aggr(\@matrix,\@states,$depth,$start_state,$end_state,"-1");
	while (defined(my $e = $result->each)) 
	{
	    push(@result_last1,$e);
	}
	
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$start_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$end_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    
	    while (defined(my $e = $result->each)) 
	    {		   	    
		print FILE $e."\n";
	    }
	    print FILE "\n[ => ".scalar @result_last1." Transition(s) ]\n";     	        
	    close(FILE);		 
	}	
	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$start_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$end_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result->each)) 
	    {	       
		print $e."\n";		    
	    }		

	    print colored [$common::COLOR_RESULT],"\n[ => ".scalar @result_last1." Transition(s) ]\n";     	        
	}
	
        # From Final To Initial
	$result = &__gen_transit_btwn_states_aggr(\@matrix,\@states,$depth,$end_state,$start_state,"-1");
	while (defined(my $e = $result->each)) 
	{
	    push(@result_last2,$e);
	}
	
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE "\n\n\n================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$end_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$start_state."\n";     
	    print FILE $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print FILE $lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";	
	    print FILE "================================================================\n\n";	
	    
	    while (defined(my $e = $result->each)) 
	    {		   	    
		print FILE $e."\n";
	    }
	    print FILE "\n[ => ".scalar @result_last2." Transition(s) ]\n";     	        
	    close(FILE);		 
	}	
	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], "\n\n\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG1." : ".$mod."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2a." : ".$end_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG2b." : ".$start_state."\n";     
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$nb_objs."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG3.": ".$height."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSTATES_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result->each)) 
	    {	       
		print $e."\n";		    
	    }		

	    print colored [$common::COLOR_RESULT],"\n[ => ".scalar @result_last2." Transition(s) ]\n";     	        
	}
	
	return (\@result_last1, \@result_last2) ;
    }


    return &genTransBtwnStatesAggr_in(@_);

}


sub genTransBtwnSS
{
    sub genTransBtwnSS_in
    {    
	my $start_ss = $_[0];
	my $end_ss = $_[1];
	my $depth = $_[2];     
	my $opts = $_[3];
	my $f = $_[4];    
	# $_[5] : XLS File with States/Transitions Matrix is provided to speed up the computation
	my $mult = 1;
	my @result1 = ();
	my @result_ss1 = ();
	my @result2 = ();
	my @result_ss2 = ();
	
	my $heightMax = -1;
	my $title = '-- SITESWAPS TRANSITIONS FROM STATES/TRANSITIONS DIAGRAMS --'; 
	my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
	my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the lit
	my $color_check = "N";
	my $sym_check = "N";
	my $perm_check = "Y";
	my $extra_info = "N";
	my $ground_check = "N";     # Get only Ground States or no (default)
	my $prime_check = "N";      # Get only prime States or no (default)
	my $reversible_check = "N";          # Get only Reversible Siteswap or no (default)
	my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
	my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
	my $magic_check = "N";      # Get only Magic Siteswap or no (default)
	my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
	my $run_browser = -1;
	
	&GetOptionsFromString(uc($_[3]),    			 
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,		
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
			      
			      "-M:i" => \$mult,			  
			      "-H:i" => \$heightMax,
			      
	    );
	
	if($heightMax != -1)
	{
	    $heightMax = hex($heightMax);
	}

	my $mod = &getSSType($start_ss,"-1"); 
	my $mod2 = &getSSType($end_ss,"-1"); 	
	if(($mod eq "V" && $mod2 eq "M") || ($mod2 eq "V" && $mod eq "M"))
	{
	    $mod = "M";
	}
	elsif(($mod eq "MS" && $mod2 eq "S") || ($mod2 eq "MS" && $mod eq "S"))
	{
	    $mod = "MS";
	}
	elsif ($mod ne $mod2) {
	    $start_ss = &LADDER::toMultiSync($start_ss,2,-1);
	    $end_ss = &LADDER::toMultiSync($end_ss,2,-1);
	    $mod = "MULTI";	   
	}
	
	my @start_state_tmp = &getStates($start_ss,-1);
	my $start_state = $start_state_tmp[0]; 
	my @end_state_tmp = &getStates($end_ss,-1);
	my $end_state = $end_state_tmp[0];
	
	if ($start_state eq "" || $end_state eq "")
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSS_ERR0."\n";
	    }
	    return -1;
	}
	
	my $ss_nb_objects = &getObjNumber($start_ss,"-1");
	if (&getObjNumber($end_ss,"-1") != $ss_nb_objects) {
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSS_ERR2." : ".$ss_nb_objects." != ".&getObjNumber($end_ss,"-1")."\n";
	    }

	    return -1;
	}

	my $ss_height_max = 0;
	my $ss_height_max2 = 0;
	if($heightMax != -1)
	{
	    $ss_height_max = $heightMax;
	}
	else
	{
	    $ss_height_max = &getHeightMax($start_ss,"-1");
	    $ss_height_max2 = &getHeightMax($end_ss,"-1");

	    if($ss_height_max < $ss_height_max2)
	    {
		$ss_height_max = $ss_height_max2;
	    }
	}	    

	# build the Matrix
	if($mult > 1)
	{
	    if($mod eq "V")
	    {
		$mod = "M";
	    }
	    elsif($mod eq "S")
	    {
		$mod = "MS";
	    }	
	}

	if ($mod eq "S" ||$mod eq "MS" ||$mod eq "SM")
	{
	    $depth = int($depth / 2);
	}

	my $v = 0;
	for(my $i=0; $i < length($start_state); $i++)
	{
	    $v=substr($start_state, $i, 1);
	    if($v > $mult)
	    {
		$mult = $v;
	    }
	}
	for(my $i=0; $i < length($end_state); $i++)
	{
	    $v=substr($end_state, $i, 1);
	    if($v > $mult)
	    {
		$mult = $v;
	    }
	}

	my $matrix_tmp = ();
	my $states_tmp = (); 	   
	if(scalar @_ > 5)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		&__check_xls_matrix_file($_[5],$mod,$ss_nb_objects,sprintf("%x",$ss_height_max),-1,-1);
	    }
	    else
	    {
		&__check_xls_matrix_file($_[5],$mod,$ss_nb_objects,sprintf("%x",$ss_height_max),$mult,-1);
	    }
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[5]); 
	}
	else
	{
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		($matrix_tmp, $states_tmp) = &genStates($mod,$ss_nb_objects,$ss_height_max,"-1");	    
	    }
	    else
	    {
		($matrix_tmp, $states_tmp) = &genStates($mod,$ss_nb_objects,$ss_height_max,$mult,"-1");	    
	    }
	}

	my @matrix=@{$matrix_tmp};
	my @states=@{$states_tmp};   

	# From Initial To Final
	my $result1 = new Set::Scalar();    
	$result1 = &__gen_transit_btwn_states(\@matrix,\@states,$depth,$start_state,$end_state);	
	my $transit1 = '';
	while (defined(my $e = $result1 -> each))
	{
	    $transit1 = $e;
	    last;
	}
	$result1 -> unique;
	
	# From Final To Initial
	my $result2 = new Set::Scalar();    
	$result2 = &__gen_transit_btwn_states(\@matrix,\@states,$depth,$end_state,$start_state);
	my $transit2 = '';
	while (defined(my $e = $result2 -> each))
	{
	    $transit2 = $e;
	    last;
	}
	$result2 -> unique;

	while (defined(my $e = $result1->each)) 
	{
	    push(@result_ss1,&LADDER::toMultiSync((($start_ss) x$ss_nb_objects).$e.(($end_ss) x$ss_nb_objects).$transit2,1,-1));	    
	}
	
	while (defined(my $e = $result2->each)) 
	{
	    push(@result_ss2,&LADDER::toMultiSync((($end_ss) x$ss_nb_objects).$e.(($start_ss) x$ss_nb_objects).$transit1,1,-1));
	}
	
	my $f_tmp = "";
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    if ("JML:"=~substr($f,0,4)) {			
		$f_tmp=substr($f,4);    
		
		open(FILE_JML,"> $conf::RESULTS/$f_tmp".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\"".$title."\""."/>\n";	   
		print FILE_JML "<line display=\"========================================\"/>\n";	   
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\"/>\n";
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)"."\"/>\n";
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)"."\"/>\n";     
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\"/>\n";     	    
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\"/>\n";	
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\"/>\n";			
		print FILE_JML "<line display=\"========================================\"/>\n";	   
		close(FILE_JML);

		my @result_jml = ();
		push @result_jml, @result_ss1;
		push @result_jml, @result_ss2;
		@result_jml = &printSSListWithoutHeaders(\@result_jml,$opts,$f);
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f_tmp.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f_tmp.jml\n";     

	    }
	    elsif("SSHTML:"=~substr($f,0,7))
	    {
		$f_tmp =substr($f,7).".html";
		open(FILE,"> $conf::RESULTS/$f_tmp") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."<BR/>\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."<BR/>\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."<BR/>\n";	
		print FILE "================================================================<BR/>\n\n";
		close(FILE);				

		@result_ss1 = &printSSListInfoHTMLWithoutHeaders(\@result_ss1,$opts,$f);	
		$run_browser = 1;
	    }
	    else {
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE $title."\n";
		print FILE "\n================================================================\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";	
		print FILE "================================================================\n\n";	
		
		while (defined(my $e = $result1->each)) 
		{
		    print FILE $e."\n";
		}
		print FILE "\n[ => ".$result1->size." Transition(s) ]\n";     	        
		close(FILE);		 
	    }
	}

	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	    while (defined(my $e = $result1->each)) 
	    {
		print $e."\n";
	    }

	    print colored [$common::COLOR_RESULT],"\n[ => ".$result1->size." Transition(s) ]\n";     	        
	}
	

	# From Final To Initial
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    if ("JML:"=~substr($f,0,4)) {	
		$run_browser = 0;
	    }
	    elsif("SSHTML:"=~substr($f,0,7))
	    {
		$f_tmp =substr($f,7).".html";
		open(FILE,">> $conf::RESULTS/$f_tmp") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE "\n\n\n================================================================<BR/>\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."<BR/>\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."<BR/>\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."<BR/>\n";	
		print FILE "================================================================<BR/>\n\n";
		close(FILE);		
		
		@result_ss2 = &printSSListInfoHTMLWithoutHeaders(\@result_ss2,$opts,$f);					
		$run_browser = 1;
	    }
	    else {
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE "\n\n\n================================================================\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";	
		print FILE "================================================================\n\n";	

		while (defined(my $e = $result2->each)) 
		{
		    print FILE $e."\n";
		}
		print FILE "\n[ => ".$result2->size." Transition(s) ]\n";     	        
		close(FILE);		 
	    }
	}

	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], "\n\n\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result2->each)) 
	    {
		print $e."\n";
	    }

	    print colored [$common::COLOR_RESULT],"\n[ => ".$result2->size." Transition(s) ]\n";     	        
	}
	

	if ($run_browser == 1 && $conf::jtbOptions_r == 1)
	{
	    my $pwd = cwd();
	    if ($common::OS eq "MSWin32") {
		system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f_tmp");
	    } else {
		# Unix-like OS
		system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f_tmp &");
	    }		
	}
	
	return (\@result1, \@result2);
    }


    return &genTransBtwnSS_in(@_);
}


sub genTransBtwnSSAggr
{
    sub genTransBtwnSSAggr_in
    {    
	my $start_ss = $_[0];
	my $end_ss = $_[1];
	my $depth = $_[2];     
	my $opts = $_[3];
	my $f = $_[4];    
	# $_[5] : XLS File with States/Transitions Matrix is provided to speed up the computation
	my $mult = 1;
	my @result1 = ();
	my @result_ss1 = ();
	my @result2 = ();
	my @result_ss2 = ();
	
	my $heightMax = -1;
	my $title = '-- SITESWAPS TRANSITION FROM REDUCED STATES/TRANSITIONS DIAGRAMS --'; 
	my $order_list = 1;         # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
	my $remove_redundancy = 0;  # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the lit
	my $color_check = "N";
	my $sym_check = "N";
	my $perm_check = "Y";
	my $extra_info = "N";
	my $ground_check = "N";     # Get only Ground States or no (default)
	my $prime_check = "N";      # Get only prime States or no (default)
	my $reversible_check = "N";          # Get only Reversible Siteswap or no (default)
	my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
	my $scramblable_check = "N"; # Get only Scramblable Siteswap or no (default)
	my $magic_check = "N";      # Get only Magic Siteswap or no (default)
	my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
	my $run_browser = -1;
	
	&GetOptionsFromString(uc($_[3]),    			 
			      "-O:i" => \$order_list,
			      "-R:i" => \$remove_redundancy,
			      "-C:s" => \$color_check,
			      "-S:s" => \$sym_check,		
			      "-P:s" => \$perm_check,
			      "-T:s" => \$title,
			      "-I:s" => \$extra_info,
			      "-G:s" => \$ground_check,
			      "-U:s" => \$prime_check,
			      "-D:s" => \$scramblable_check,
			      "-N:s" => \$palindrome_check,
			      "-B:s" => \$reversible_check,
			      "-Z:s" => \$magic_check,
			      "-Q:s" => \$squeeze_check,
			      
			      "-M:i" => \$mult,			  
			      "-H:i" => \$heightMax,			  
	    );
	
	if($heightMax != -1)
	{
	    $heightMax = hex($heightMax);
	}

	my $mod = &getSSType($start_ss,"-1"); 
	my $mod2 = &getSSType($end_ss,"-1"); 	
	if(($mod eq "V" && $mod2 eq "M") || ($mod2 eq "V" && $mod eq "M"))
	{
	    $mod = "M";
	}
	elsif(($mod eq "MS" && $mod2 eq "S") || ($mod2 eq "MS" && $mod eq "S"))
	{
	    $mod = "MS";
	}
	elsif ($mod ne $mod2) {
	    $start_ss = &LADDER::toMultiSync($start_ss,2,-1);
	    $end_ss = &LADDER::toMultiSync($end_ss,2,-1);
	    $mod = "MULTI";	   
	}
	
	my @start_state_tmp = &getStates($start_ss,-1);
	my $start_state = $start_state_tmp[0]; 
	my @end_state_tmp = &getStates($end_ss,-1);
	my $end_state = $end_state_tmp[0];
	
	if ($start_state eq "" || $end_state eq "")
	{
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSS_ERR0."\n";
	    }
	    return -1;
	}
	
	my $ss_nb_objects = &getObjNumber($start_ss,"-1");
	if (&getObjNumber($end_ss,"-1") != $ss_nb_objects) {
	    if ($f ne "-1") {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENTRANSBTWNSS_ERR2." : ".$ss_nb_objects." != ".&getObjNumber($end_ss,"-1")."\n";
	    }

	    return -1;
	}

	my $ss_height_max = 0;
	my $ss_height_max2 = 0;
	if($heightMax != -1)
	{
	    $ss_height_max = $heightMax;
	}
	else
	{
	    $ss_height_max = &getHeightMax($start_ss,"-1");
	    $ss_height_max2 = &getHeightMax($end_ss,"-1");

	    if($ss_height_max < $ss_height_max2)
	    {
		$ss_height_max = $ss_height_max2;
	    }
	}	    

	# build the Matrix
	if($mult > 1)
	{
	    if($mod eq "V")
	    {
		$mod = "M";
	    }
	    elsif($mod eq "S")
	    {
		$mod = "MS";
	    }	
	}

	if ($mod eq "S" ||$mod eq "MS" ||$mod eq "SM")
	{
	    $depth = int($depth / 2);
	}

	my $v = 0;
	for(my $i=0; $i < length($start_state); $i++)
	{
	    $v=substr($start_state, $i, 1);
	    if($v > $mult)
	    {
		$mult = $v;
	    }
	}
	for(my $i=0; $i < length($end_state); $i++)
	{
	    $v=substr($end_state, $i, 1);
	    if($v > $mult)
	    {
		$mult = $v;
	    }
	}

	my $matrix_tmp = ();
	my $states_tmp = (); 	   
	if(scalar @_ > 5)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		&__check_xls_matrix_file($_[5],$mod,$ss_nb_objects,sprintf("%x",$ss_height_max),-1,"R");
	    }
	    else
	    {
		&__check_xls_matrix_file($_[5],$mod,$ss_nb_objects,sprintf("%x",$ss_height_max),$mult,"R");
	    }
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[5]); 
	}
	else
	{
	    if(uc($mod) eq "V" || uc($mod) eq "S")
	    {
		($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$ss_nb_objects,$ss_height_max,"-1");	    
	    }
	    else
	    {
		($matrix_tmp, $states_tmp) = &genStatesAggr($mod,$ss_nb_objects,$ss_height_max,$mult,"-1");	    
	    }
	}

	my @matrix=@{$matrix_tmp};
	my @states=@{$states_tmp};   

	# From Initial To Final
	my $result1 = new Set::Scalar();    
	$result1 = &__gen_transit_btwn_states_aggr(\@matrix,\@states,$depth,$start_state,$end_state);	
	my $transit1 = '';
	while (defined(my $e = $result1 -> each))
	{
	    $transit1 = $e;
	    last;
	}
	$result1 -> unique;
	
	# From Final To Initial
	my $result2 = new Set::Scalar();    
	$result2 = &__gen_transit_btwn_states_aggr(\@matrix,\@states,$depth,$end_state,$start_state);
	my $transit2 = '';
	while (defined(my $e = $result2 -> each))
	{
	    $transit2 = $e;
	    last;
	}
	$result2 -> unique;

	while (defined(my $e = $result1->each)) 
	{
	    push(@result_ss1,&LADDER::toMultiSync((($start_ss) x$ss_nb_objects).$e.(($end_ss) x$ss_nb_objects).$transit2,1,-1));	    
	}
	
	while (defined(my $e = $result2->each)) 
	{
	    push(@result_ss2,&LADDER::toMultiSync((($end_ss) x$ss_nb_objects).$e.(($start_ss) x$ss_nb_objects).$transit1,1,-1));
	}
	
	my $f_tmp = "";
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    if ("JML:"=~substr($f,0,4)) {			
		$f_tmp=substr($f,4);    
		
		open(FILE_JML,"> $conf::RESULTS/$f_tmp".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp.jml> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE_JML "<?xml version=\"1.0\"?>\n";
		print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
		print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
		print FILE_JML "<patternlist>\n";
		print FILE_JML "<title>".$title."</title>\n";
		print FILE_JML "<line display=\"".$title."\""."/>\n";	   
		print FILE_JML "<line display=\"========================================\"/>\n";	   
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\"/>\n";
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)"."\"/>\n";
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)"."\"/>\n";     
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\"/>\n";     	    
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\"/>\n";	
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\"/>\n";			
		print FILE_JML "<line display=\"========================================\"/>\n";	   
		close(FILE_JML);

		my @result_jml = ();
		push @result_jml, @result_ss1;
		push @result_jml, @result_ss2;
		@result_jml = &printSSListWithoutHeaders(\@result_jml,$opts,$f);
		
		#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/$f_tmp.jml");
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/$f_tmp.jml\n";     

	    }
	    elsif("SSHTML:"=~substr($f,0,7))
	    {
		$f_tmp =substr($f,7).".html";
		open(FILE,"> $conf::RESULTS/$f_tmp") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE $title."<BR/>\n";
		print FILE "\n================================================================<BR/>\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."<BR/>\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."<BR/>\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."<BR/>\n";	
		print FILE "================================================================<BR/>\n\n";
		close(FILE);				

		@result_ss1 = &printSSListInfoHTMLWithoutHeaders(\@result_ss1,$opts,$f);	
		$run_browser = 1;
	    }
	    else {
		open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE $title."\n";
		print FILE "\n================================================================\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";	
		print FILE "================================================================\n\n";	
		
		while (defined(my $e = $result1->each)) 
		{
		    print FILE $e."\n";
		}
		print FILE "\n[ => ".$result1->size." Transition(s) ]\n";     	        
		close(FILE);		 
	    }
	}

	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], $title."\n";
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$start_ss." ($start_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$end_ss." ($end_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    

	    while (defined(my $e = $result1->each)) 
	    {
		print $e."\n";
	    }

	    print colored [$common::COLOR_RESULT],"\n[ => ".$result1->size." Transition(s) ]\n";     	        
	}
	

	# From Final To Initial
	if ($f ne "" && $f ne "-1") {	    	    	    	    
	    if ("JML:"=~substr($f,0,4)) {	
		$run_browser = 0;
	    }
	    elsif("SSHTML:"=~substr($f,0,7))
	    {
		$f_tmp =substr($f,7).".html";
		open(FILE,">> $conf::RESULTS/$f_tmp") || die ("$lang::MSG_GENERAL_ERR1 <$f_tmp> $lang::MSG_GENERAL_ERR1b") ; 
		print FILE "\n\n\n================================================================<BR/>\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)<BR/>\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."<BR/>\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."<BR/>\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."<BR/>\n";	
		print FILE "================================================================<BR/>\n\n";
		close(FILE);		
		
		@result_ss2 = &printSSListInfoHTMLWithoutHeaders(\@result_ss2,$opts,$f);					
		$run_browser = 1;
	    }
	    else {
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f.html> $lang::MSG_GENERAL_ERR1b") ;   
		print FILE "\n\n\n================================================================\n";
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)\n";     
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)\n";     
		print FILE $lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
		print FILE $lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";	
		print FILE "================================================================\n\n";	

		while (defined(my $e = $result2->each)) 
		{
		    print FILE $e."\n";
		}
		print FILE "\n[ => ".$result2->size." Transition(s) ]\n";     	        
		close(FILE);		 
	    }
	}

	elsif($f ne "-1")  
	{
	    print colored [$common::COLOR_RESULT], "\n\n\n================================================================\n";    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG1." : ".$mod."\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2a." : ".$end_ss." ($end_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG2b." : ".$start_ss." ($start_state)\n";
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENERAL2." : ".$ss_nb_objects."\n";     	    
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG3.": ".$ss_height_max."\n";	
	    print colored [$common::COLOR_RESULT],$lang::MSG_SSWAP_GENTRANSBTWNSS_MSG4.": ".$depth."\n";		
	    print colored [$common::COLOR_RESULT], "================================================================\n\n";    
	    
	    while (defined(my $e = $result2->each)) 
	    {
		print $e."\n";
	    }

	    print colored [$common::COLOR_RESULT],"\n[ => ".$result2->size." Transition(s) ]\n";     	        
	}
	

	if ($run_browser == 1 && $conf::jtbOptions_r == 1)
	{
	    my $pwd = cwd();
	    if ($common::OS eq "MSWin32") {
		system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f_tmp");
	    } else {
		# Unix-like OS
		system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f_tmp &");
	    }		
	}
	
	return (\@result1, \@result2);
    }


    return &genTransBtwnSSAggr_in(@_);
}



sub __gen_transit_btwn_states
{
    sub __gen_transit_btwn_states_in
    {    
	my @matrix=@{$_[0]};
	my @states=@{$_[1]};
	my $depth = $_[2];
	
	my $final_state = $_[4];
	my $cur_state = $_[3];
	my $result = new Set::Scalar();    
	
	if($depth > 1) {
	    my $idx_state_i=&__get_idx_state(\@states, $cur_state);
	    foreach my $el (@states) 
	    {       	  
		&common::displayComputingPrompt();		
		my $result_tmp = new Set::Scalar();    
		
		my $idx_state_j=&__get_idx_state(\@states, $el);
		if($matrix[$idx_state_i][$idx_state_j] ne "")
		{
		    $result_tmp = &__gen_transit_btwn_states_in(\@matrix,\@states,$depth-1,$el,$final_state);
		    if($result_tmp->size > 0)
		    {
			while (defined(my $e = $result_tmp->each))
			{
			    my @st=split(/;/,$matrix[$idx_state_i][$idx_state_j]);
			    for (my $j=0; $j<scalar @st;$j++) {
				my $v=$st[$j];	
				$v =~ s/\s+//g;	
				$result->insert("$v$e");
			    }
			}
		    }
		}	 
		&common::hideComputingPrompt();		
	    }
	}
	
	elsif($depth==1)
	{
	    my $idx_state_i=&__get_idx_state(\@states, $cur_state);	
	    my $idx_state_j=&__get_idx_state(\@states, $final_state);	
	    if($matrix[$idx_state_i][$idx_state_j] ne "")
	    {
		my @st=split(/;/,$matrix[$idx_state_i][$idx_state_j]);
		for (my $j=0; $j<scalar @st;$j++) {			    
		    my $v=$st[$j];	
		    $v =~ s/\s+//g;	
		    $result->insert("$v");		
		}
	    }
	    
	}
	
	return $result;     
    }


    my $result = new Set::Scalar();    
    $result=&__gen_transit_btwn_states_in(@_);
    my $result_simplify = new Set::Scalar();
    while (defined(my $e = $result->each)) 
    {
	#$result_simplify->insert(lc(&simplify($e)));	  
	$result_simplify->insert(lc(&LADDER::toMultiSync($e,1,"-1")));		    
    }

    return $result_simplify;

}


sub __gen_transit_btwn_states_aggr
{
    sub __gen_transit_btwn_states_aggr_in
    {    
	my @matrix=@{$_[0]};
	my @states=@{$_[1]};
	my $depth = $_[2];
	
	my $final_state = $_[4];
	my $cur_state = $_[3];
	my $result = new Set::Scalar();    
	
	if($depth > 1) {
	    my $idx_state_i=&__get_idx_state(\@states, $cur_state);
	    foreach my $el (@states) 
	    {       	  
		&common::displayComputingPrompt();		
		my $result_tmp = new Set::Scalar();    
		
		my $idx_state_j=&__get_idx_state(\@states, $el);
		if($matrix[$idx_state_i][$idx_state_j] ne "")
		{
		    # With Reduced Matrix , there is no more one beat per entry, we then must issue results prior. 
		    # The period checking must be done outside !  
		    if($el eq $final_state)
		    {
			my @st=split(/;/,$matrix[$idx_state_i][$idx_state_j]);
			for (my $j=0; $j<scalar @st;$j++) {
			    my $v=$st[$j];	
			    $v =~ s/\s+//g;	
			    $result->insert("$v");
			}
		    }

		    $result_tmp = &__gen_transit_btwn_states_aggr_in(\@matrix,\@states,$depth-1,$el,$final_state);
		    if($result_tmp->size > 0)
		    {
			while (defined(my $e = $result_tmp->each))
			{
			    my @st=split(/;/,$matrix[$idx_state_i][$idx_state_j]);
			    for (my $j=0; $j<scalar @st;$j++) {
				my $v=$st[$j];	
				$v =~ s/\s+//g;	
				$result->insert("$v$e");
			    }
			}
		    }
		}	 
		&common::hideComputingPrompt();		
	    }
	}
	
	elsif($depth==1)
	{
	    my $idx_state_i=&__get_idx_state(\@states, $cur_state);	
	    my $idx_state_j=&__get_idx_state(\@states, $final_state);	
	    if($matrix[$idx_state_i][$idx_state_j] ne "")
	    {
		my @st=split(/;/,$matrix[$idx_state_i][$idx_state_j]);
		for (my $j=0; $j<scalar @st;$j++) {			    
		    my $v=$st[$j];	
		    $v =~ s/\s+//g;	
		    $result->insert("$v");		
		}
	    }
	    
	}
	
	return $result;     
    }


    my $result = new Set::Scalar();    
    $result=&__gen_transit_btwn_states_aggr_in(@_);
    my $result_simplify = new Set::Scalar();
    while (defined(my $e = $result->each)) 
    {
	# Check the Period 
	my $p = 0;
	# Use the Reduced Multisync to simplify the computation
	my $multisync=&LADDER::toMultiSync($e,0,"-1");
	for (my $i = 0; $i< length ($multisync); $i++)
	{
	    if(substr($multisync,$i,1) eq "!")
	    {
		$p--;
	    }
	    elsif(substr($multisync,$i,1) eq "*" || uc(substr($multisync,$i,1)) eq "X")
	    {
		# Nothing to do
	    }
	    else
	    {
		$p++;
	    }
	}
	if($_[2] == $p)
	{
	    #$result_simplify->insert(lc(&simplify($e)));	  
	    $result_simplify->insert(lc(&LADDER::toMultiSync($e,1,"-1")));		    
	}
	else
	{
	    if ($SSWAP_DEBUG >= 1) {
		print "== SSWAP::__gen_transit_btwn_states_aggr : Reject Transition <$e> => Bad length \n";
	    }
	}
    }

    return $result_simplify;

}


sub toStack 
{
    my $ss = $_[0];
    my $mod = &getSSType($ss,-1);
    if ($mod eq "V")
    {
	&__toStack_async(@_);	
    }	
    elsif ($mod eq "M")
    {
	&__toStack_multiplex(@_);	
    }	
    elsif ($mod eq "S")
    {
	&__toStack_sync(@_);	
    }	
    elsif ($mod eq "MS" || $mod eq "SM")
    {
	&__toStack_multiplex_sync(@_);	
    }	
    else
    {
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_TOSTACK_MSG1."\n";
    }
}


sub __toStack_async
{
    my $ss = $_[0];
    my $period = &getPeriod($ss,-1);
    my $height = &getHeightMax($ss,-1);
    my @stack = ();
    my $stack_notation = "";

    my $stack_inv = reverse((&getStates($ss, -1))[0]); 
    @stack = split(//,$stack_inv);
    
    for(my $i = 0; $i < $period + $height; $i++)
    {
	push(@stack, '0');
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::__toStack_async : STACK evolution for $ss \n";
	print join('',@stack)."\n";
    }
    
    for (my $i=0; $i<length($ss); $i++)
    {
	my $v = substr($ss,$i,1);
	@stack = @stack[1..scalar @stack];
	push(@stack,'0');
	my $cpt = 0;
	if(hex($v) != 0)
	{
	    $cpt=1;	    
	    $stack[hex($v)-1] = '1';	
	    for(my $j=0; $j < hex($v)-1; $j++)
	    {
		if($stack[$j] eq "1")
		{
		    $cpt ++;
		}
	    }
	}
	
	$stack_notation = $stack_notation.sprintf("%x",$cpt);
	
	if ($SSWAP_DEBUG >= 1) {
	    print $v." : ".join('',@stack)."\n";
	}
    }
    
    if(scalar @_ <= 2 || $_[2] ne "-1")
    {
	print colored [$common::COLOR_RESULT], $stack_notation."\n";
    }
    
    return $stack_notation;
}


sub __toStack_multiplex
{
    my $ss = $_[0];

    # The way to handle holes in Multiplex
    #0 : Do not consider hole between Multiplex
    #1 : Consider Hole between Multiplex and Increasing Order (Default)
    #2 : Consider Hole between Multiplex and Decreasing Order  
    my $holeMult=1;

    &GetOptionsFromString(uc($_[1]),    			 			  
			  "-M:i" => \$holeMult,			  		
	);
    
    my $period = &getPeriod($ss,-1);
    my $height = &getHeightMax($ss,-1);
    my @stack = ();
    my $stack_notation = "";

    my $stack_inv = reverse((&getStates($ss, -1))[0]); 
    @stack = split(//,$stack_inv);
    
    for(my $i = 0; $i < $period + $height; $i++)
    {
	push(@stack, '0');
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::__toStack_multiplex : STACK evolution for $ss \n";
	print join('',@stack)."\n";
    }
    
    for (my $i=0; $i<length($ss); $i++)
    {
	my $v = substr($ss,$i,1);
	if($v eq "[")
	{
	    $stack_notation = $stack_notation."[";
	}
	elsif($v eq "]")
	{
	    $stack_notation = $stack_notation."]";
	}
	elsif($v eq "0")
	{
	    @stack = @stack[1..scalar @stack];
	    push(@stack,'0');
	    $stack_notation = $stack_notation."0";
	    if(uc(substr($ss,$i+1,1)) eq "X")
	    {
		$i++;
	    }
	}
	else
	{
	    my $it = hex($stack[0]);
	    for(my $k=0; $k < $it; $k++)
	    {
		if($k == 0)
		{
		    @stack = @stack[1..scalar @stack];
		    push(@stack,'0');
		}
		else
		{
		    $i++;
		}
		$v = substr($ss,$i,1);
		my $cpt = 0;
		if(hex($v) != 0)
		{
		    if($holeMult>=1)
		    {
			$cpt=$it-$k;
		    }
		    else
		    {
			$cpt=1;
		    }
		    for(my $j=0; $j < hex($v)-1; $j++)
		    {
			if($stack[$j] >= 1)
			{
			    if($holeMult>=1)
			    {
				$cpt += $stack[$j];
			    }
			    else
			    {
				$cpt ++;
			    }
			}
		    }
		    
		    if($holeMult==1)
		    {
			$cpt += $stack[hex($v)-1];
		    }
		    
		    $stack[hex($v)-1]++;	
		}
		
		$stack_notation = $stack_notation.sprintf("%x",$cpt);
		
		if ($SSWAP_DEBUG >= 1) {
		    print $v." : ".join('',@stack)."\n";
		}		
	    }		    	   
	}
    }
    
    if(scalar @_ <= 2 || $_[2] ne "-1")
    {
	print colored [$common::COLOR_RESULT], $stack_notation."\n";
    }

    return $stack_notation;
}


sub __toStack_sync
{
    my $ss = &expandSync($_[0],-1);

    # The way to handle holes in Sync
    #N : Consider 2 distinct stacks
    #R : Consider Right Throw First (Default)
    #L : Consider Left throw First  
    my $holeSync="R";

    &GetOptionsFromString(uc($_[1]),    			 			  
			  "-S:s" => \$holeSync,			  		
	);
    
    my $period = &getPeriod($ss,-1);
    my $height = &getHeightMax($ss,-1);
    my @stackr = ();
    my @stackl = ();
    my $stack_notation = "";
    my @state=split(/,/,(&getStates($ss, -1))[0]);
    
    my $stackr_inv = reverse(@state[0]); 
    my $stackl_inv = reverse(@state[1]); 
    @stackr = split(//,$stackr_inv);
    @stackl = split(//,$stackl_inv);
    
    for(my $i = 0; $i < $period + $height; $i++)
    {
	push(@stackr, '0');
	push(@stackl, '0');
    }
    
    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::__toStack_sync : STACK evolution for $ss \n";
	print join('',@stackr).','.join('',@stackl)."\n";
    }
    
    my $hand = "R";
    my $throwr = "";
    my $throwl = "";

    for (my $i=0; $i<length($ss); $i++)
    {
	my $v = substr($ss,$i,1);
	if($v eq "(")
	{
	    $throwr='';
	    $throwl='';	    
	}
	elsif($v eq ")")
	{
	    @stackr = @stackr[1..scalar @stackr];
	    push(@stackr,'0');
	    @stackl = @stackl[1..scalar @stackl];
	    push(@stackl,'0');
	    my $cptr = 1;
	    my $cptl = 1;	    
	    
	    if(uc($holeSync) eq "N")
	    {
		my @stackr_tmp=@stackr;		
		my @stackl_tmp=@stackl;
		
		if($throwr eq "0" || uc($throwr) eq "0X")
		{
		    $cptr = "0";
		}
		else
		{
		    if(length($throwr) == 1)
		    {
			$stackr_tmp[hex($throwr)/2-1] = '1';		  	    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptr ++;
			    }
			}			    
			$cptr = sprintf("%x",$cptr);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwr,0,1));
			$stackl_tmp[$th/2-1] = '1';		    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptr ++;
			    }
			}			    
			$cptr = sprintf("%x",$cptr)."X";
		    }
		}
		
		if($throwl eq "0" || uc($throwl) eq "0X")
		{
		    $cptl = "0";
		}
		else
		{		
		    if(length($throwl) == 1)
		    {
			$stackl_tmp[hex($throwl)/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwl,0,1));
			$stackr_tmp[$th/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl)."X";
		    }		
		}
		
		@stackr=@stackr_tmp;
		@stackl=@stackl_tmp;
	    }

	    elsif($holeSync eq "R")
	    {
		if($throwr eq "0" || uc($throwr) eq "0X")
		{
		    $cptr = "0";
		}
		else
		{
		    if(length($throwr) == 1)
		    {
			$stackr[hex($throwr)/2-1] = '1';		  	    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptr ++;
			    }
			}			    
			$cptr = sprintf("%x",$cptr);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwr,0,1));
			$stackl[$th/2-1] = '1';		    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptr ++;
			    }
			}
			$cptr = sprintf("%x",$cptr)."X";
		    }
		}
		
		if($throwl eq "0" || uc($throwl) eq "0X")
		{
		    $cptl = "0";
		}
		else
		{		
		    if(length($throwl) == 1)
		    {
			$stackl[hex($throwl)/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwl,0,1));
			$stackr[$th/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl)."X";
		    }		
		}		
	    }

	    elsif($holeSync eq "L")
	    {		
		if($throwl eq "0" || uc($throwl) eq "0X")
		{
		    $cptl = "0";
		}
		else
		{		
		    if(length($throwl) == 1)
		    {
			$stackl[hex($throwl)/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwl,0,1));
			$stackr[$th/2-1] = '1';
			for(my $j=0; $j < hex($throwl)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptl ++;
			    }
			}	
			$cptl = sprintf("%x",$cptl)."X";
		    }		
		}
		if($throwr eq "0" || uc($throwr) eq "0X")
		{
		    $cptr = "0";
		}
		else
		{
		    if(length($throwr) == 1)
		    {
			$stackr[hex($throwr)/2-1] = '1';		  	    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackr[$j] eq "1")
			    {
				$cptr ++;
			    }
			}			    
			$cptr = sprintf("%x",$cptr);
		    }
		    else # Means this is an X throw
		    {
			my $th=hex(substr($throwr,0,1));
			$stackl[$th/2-1] = '1';		    
			for(my $j=0; $j < hex($throwr)/2-1; $j++)
			{
			    if($stackl[$j] eq "1")
			    {
				$cptr ++;
			    }
			}			    
			$cptr = sprintf("%x",$cptr)."X";
		    }
		}		
	    }



	    if($hand eq "R")
	    {
		$stack_notation = $stack_notation.'('.$cptl.",".$cptr.')';
		if ($SSWAP_DEBUG >= 1) {
		    print "(".$throwl.",".$throwr.") : (".join('',@stackl).",".join('',@stackr).")\n";
		}
		$hand = "L";
	    }
	    else
	    {
		$stack_notation = $stack_notation.'('.$cptr.",".$cptl.')';
		if ($SSWAP_DEBUG >= 1) {
		    print "(".$throwr.",".$throwl.") : (".join('',@stackr).",".join('',@stackl).")\n";
		}
		$hand = "R";
	    }
	}
	elsif($v eq ",")
	{
	    if($hand eq "R")
	    {
		$hand = "L";
	    }
	    else
	    {
		$hand = "R";
	    }
	}
	else
	{	    
	    if($hand eq "R")
	    {
		$throwr=$throwr.$v;
	    }
	    else
	    {
		$throwl=$throwl.$v;
	    }
	}
    }
    
    
    if(scalar @_ <= 2 || $_[2] ne "-1")
    {
	print colored [$common::COLOR_RESULT], $stack_notation."\n";
    }
    
    return $stack_notation;
}


sub __toStack_multiplex_sync
{
    my $ss = &expandSync($_[0],-1);

    # The way to handle holes in Multiplex
    #0 : Do not consider hole between Multiplex
    #1 : Consider Hole between Multiplex and Increasing Order (Default)
    #2 : Consider Hole between Multiplex and Decreasing Order  
    my $holeMult=1;

    # The way to handle holes in Sync
    #N : Consider 2 distinct stacks
    #R : Consider Right Throw First (Default)
    #L : Consider Left throw First  
    my $holeSync="R";

    &GetOptionsFromString(uc($_[1]),    			 			  
			  "-M:i" => \$holeMult,			  		
			  "-S:s" => \$holeSync,			  		
	);

    my $period = &getPeriod($ss,-1);
    my $height = &getHeightMax($ss,-1);
    my @stackr = ();
    my @stackl = ();
    my $stack_notation = "";
    my @state=split(/,/,(&getStates($ss, -1))[0]);
    
    my $stackr_inv = reverse(@state[0]); 
    my $stackl_inv = reverse(@state[1]); 
    @stackr = split(//,$stackr_inv);
    @stackl = split(//,$stackl_inv);
    
    for(my $i = 0; $i < $period + $height; $i++)
    {
	push(@stackr, '0');
	push(@stackl, '0');
    }
    
    if ($SSWAP_DEBUG >= -1) {
	print "== SSWAP::__toStack_multiplex_sync : STACK evolution for $ss \n";
	print join('',@stackr).','.join('',@stackl)."\n";
    }
    
    my $hand = "R";
    my $throwr = "";
    my $throwl = "";

    for (my $i=0; $i<length($ss); $i++)
    {
	my $v = substr($ss,$i,1);
	if($v eq "[" || $v eq "]") 
	{
	    # will be handled later
	}
	elsif($v eq "(")
	{
	    $throwr='';
	    $throwl='';	    
	}
	elsif($v eq ")")
	{
	    my $itr = hex($stackr[0]);
	    @stackr = @stackr[1..scalar @stackr];
	    push(@stackr,'0');
	    my $itl = hex($stackl[0]);
	    @stackl = @stackl[1..scalar @stackl];
	    push(@stackl,'0');
	    
	    my $cptr_e = '';
	    my $cptl_e = '';	    
	    my $cptr = 0;
	    my $cptl = 0;	    	    	    
	    my $cpt = 0;

	    if(uc($holeSync) eq "N" || uc($holeSync) eq "R")
	    {
		# Not necessary for "R" but reduces code however
		my @stackr_tmp=@stackr;
		my @stackl_tmp=@stackl;
		
		for(my $j=0; $j<length($throwr);$j++)
		{
		    $v = substr($throwr,$j,1);
		    $cptr = 0;
		    
		    if(hex($v) != 0)
		    {
			if(uc(substr($throwr,$j+1,1)) ne "X")
			{
			    if($holeMult>=1)
			    {
				$cptr=$itr-$cpt;
			    }
			    else
			    {
				$cptr=1;
			    }
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {
				if($stackr[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptr += $stackr[$k];
				    }
				    else
				    {
					$cptr ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptr += $stackr[hex($v)/2-1];
			    }
			    
			    if(uc($holeSync) eq "N")
			    {
				$stackr_tmp[hex($v)/2-1]++;
			    }
			    else
			    {
				$stackr[hex($v)/2-1]++;
			    }
			    
			    $cptr=sprintf("%x",$cptr);
			    $cpt ++;
			}
			
			else
			{
			    $cptr=1;
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {
				if($stackl[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptr += $stackl[$k];
				    }
				    else
				    {
					$cptr ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptr += $stackl[hex($v)/2-1];
			    }
			    
			    if(uc($holeSync) eq "N")
			    {			
				$stackl_tmp[hex($v)/2-1]++;	
			    }
			    else
			    {
				$stackl[hex($v)/2-1]++;	
			    }
			    
			    $cptr=sprintf("%x",$cptr)."X";
			    $cpt ++;
			    $j++;
			}
			
		    }
		    
		    $cptr_e = $cptr_e.$cptr;
		}
		
		$cpt = 0;
		for(my $j=0; $j<length($throwl);$j++)
		{
		    $v = substr($throwl,$j,1);
		    $cptl = 0;
		    
		    if(hex($v) != 0)
		    {
			if(uc(substr($throwl,$j+1,1)) ne "X")
			{
			    if($holeMult>=1)
			    {
				$cptl=$itl-$cpt;
			    }
			    else
			    {
				$cptl=1;
			    }

			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {			
				if($stackl[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptl += $stackl[$k];
				    }
				    else
				    {
					$cptl ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptl += $stackl[hex($v)/2-1];
			    }
			    
			    if(uc($holeSync) eq "N")
			    {			
				$stackl_tmp[hex($v)/2-1]++;
			    }
			    else
			    {
				$stackl[hex($v)/2-1]++;
			    }
			    
			    $cptl=sprintf("%x",$cptl);
			    $cpt ++;
			}
			else
			{
			    $cptl=1;
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {			
				if($stackr[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptl += $stackr[$k];
				    }
				    else
				    {
					$cptl ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptl += $stackr[hex($v)/2-1];
			    }
			    
			    if(uc($holeSync) eq "N")
			    {			
				$stackr_tmp[hex($v)/2-1]++;
			    }
			    else
			    {
				$stackr[hex($v)/2-1]++;
			    }
			    
			    $cptl=sprintf("%x",$cptl)."X";
			    $j++;
			    $cpt ++;
			}
		    }
		    
		    $cptl_e = $cptl_e.$cptl;
		}
		if(uc($holeSync) eq "N")
		{
		    # In N Sync Holes computation we consider independant stacks
		    @stackr=@stackr_tmp;
		    @stackl=@stackl_tmp;
		}
	    }	    
	    
	    elsif($holeSync eq "L")
	    {
		for(my $j=0; $j<length($throwl);$j++)
		{
		    $v = substr($throwl,$j,1);
		    $cptl = 0;
		    
		    if(hex($v) != 0)
		    {
			if(uc(substr($throwl,$j+1,1)) ne "X")
			{
			    if($holeMult>=1)
			    {
				$cptl=$itl-$cpt;
			    }
			    else
			    {
				$cptl=1;
			    }

			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {			
				if($stackl[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptl += $stackl[$k];
				    }
				    else
				    {
					$cptl ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptl += $stackl[hex($v)/2-1];
			    }
			    
			    $stackl[hex($v)/2-1]++;			    
			    
			    $cptl=sprintf("%x",$cptl);
			    $cpt ++;
			}
			else
			{
			    $cptl=1;
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {			
				if($stackr[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptl += $stackr[$k];
				    }
				    else
				    {
					$cptl ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptl += $stackr[hex($v)/2-1];
			    }
			    
			    $stackr[hex($v)/2-1]++;			    
			    
			    $cptl=sprintf("%x",$cptl)."X";
			    $j++;
			    $cpt ++;
			}
		    }
		    
		    $cptl_e = $cptl_e.$cptl;
		}

		$cpt = 0;
		for(my $j=0; $j<length($throwr);$j++)
		{
		    $v = substr($throwr,$j,1);
		    $cptr = 0;
		    
		    if(hex($v) != 0)
		    {
			if(uc(substr($throwr,$j+1,1)) ne "X")
			{
			    if($holeMult>=1)
			    {
				$cptr=$itr-$cpt;
			    }
			    else
			    {
				$cptr=1;
			    }
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {
				if($stackr[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptr += $stackr[$k];
				    }
				    else
				    {
					$cptr ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptr += $stackr[hex($v)/2-1];
			    }
			    $stackr[hex($v)/2-1]++;			    			    
			    $cptr=sprintf("%x",$cptr);
			    $cpt ++;
			}
			
			else
			{
			    $cptr=1;
			    
			    for(my $k=0; $k < hex($v)/2-1; $k++)
			    {
				if($stackl[$k] >= 1)
				{
				    if($holeMult>=1)
				    {
					$cptr += $stackl[$k];
				    }
				    else
				    {
					$cptr ++;
				    }
				}
			    }
			    
			    if($holeMult==1)
			    {
				$cptr += $stackl[hex($v)/2-1];
			    }
			    
			    $stackl[hex($v)/2-1]++;				    			    
			    $cptr=sprintf("%x",$cptr)."X";
			    $cpt ++;
			    $j++;
			}
			
		    }
		    
		    $cptr_e = $cptr_e.$cptr;
		}
		
	    }	    



	    if($itr > 1)
	    {
		$cptr_e='['.$cptr_e.']';
	    }
	    if($itl > 1)
	    {
		$cptl_e='['.$cptl_e.']';
	    }

	    
	    if($hand eq "R")
	    {
		$stack_notation = $stack_notation.'('.$cptl_e.",".$cptr_e.')';
		if ($SSWAP_DEBUG >= -1) {
		    print "(".$throwl.",".$throwr.") : (".join('',@stackl).",".join('',@stackr).")\n";
		}
		$hand = "L";
	    }
	    else
	    {
		$stack_notation = $stack_notation.'('.$cptr_e.",".$cptl_e.')';
		if ($SSWAP_DEBUG >= -1) {
		    print "(".$throwr.",".$throwl.") : (".join('',@stackr).",".join('',@stackl).")\n";
		}
		$hand = "R";
	    }
	}
	elsif($v eq ",")
	{
	    if($hand eq "R")
	    {
		$hand = "L";
	    }
	    else
	    {
		$hand = "R";
	    }
	}
	else
	{	    
	    if($hand eq "R")
	    {
		$throwr=$throwr.$v;
	    }
	    else
	    {
		$throwl=$throwl.$v;
	    }
	}
    }
    
    if(scalar @_ <= 2 || $_[2] ne "-1")
    {
	print colored [$common::COLOR_RESULT], $stack_notation."\n";
    }
    
    return $stack_notation;
}



######################################################################
#
# The Followings procedure uses OLE and thus are dedicated to Windows (With Excel License set)
#
######################################################################

my $OS=$^O;
if ($OS eq "MSWin32") {
    use Win32::OLE;
    use Win32::OLE qw(in with);
    # not only use Win32::OLE::Const 'Microsoft Excel'
    use Win32::OLE::Const;

    if(! Win32::OLE->new('Excel.Application', 'Quit'))
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_SSWAP_GENERAL18\n";
    }
}
else
{
    print colored [$common::COLOR_RESULT], "$lang::MSG_SSWAP_GENERAL18\n";
}


sub writeStates_xls
{
    my $mod = uc(shift);    

    if ($mod eq "V") {
	return &__write_states_async_xls(@_);
    } elsif ($mod eq "M") {
	return &__write_states_multiplex_xls(@_);
    } elsif ($mod eq "S") {
	return &__write_states_sync_xls(@_);
    } elsif ($mod eq "SM" || $mod eq "MS") {
	return &__write_states_multiplex_sync_xls(@_);
    } elsif ($mod eq "MULTI") {
	return &__write_states_multisync_xls(@_);
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
    return &__get_nb_xls_sheets_for_col($_[0]) * &__get_nb_xls_sheets_for_row($_[0]);
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
    
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $pwd = cwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[2].".xlsx";    
    my $nbtransitions = 0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    #foreach my $key (keys %$Excel_symb) {
    #    printf "$key = %s\n", $Excel_symb->{$key};
    #}

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=&__get_states_async($_[0],$_[1]);        

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = &__get_nb_xls_sheets (scalar @states);

    # Generation of needed sheets
    my $comment ="V,".$nb_objs.",".sprintf("%x",$highMaxss).",-1,-1";
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
    $Sheet->Range('B2:B7')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B7')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B7')-> Font -> {'size'} = 11;
    $Sheet->Range('B2:B7')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};    
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();
    $Sheet->Range('B7:P7')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENSTATES_MSG1a;	

    $Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL1;	
    if ($nb_objs != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs;	
    } else {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }   

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {		
		$Sheet->Columns($cellj)-> AutoFit();
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Rows($celli)-> AutoFit(); 	
	    # Hack for bug with the AutoFit parameter on Columns
	    $Sheet->Rows($celli)-> {'RowHeight'} = length($states[0]) * 8;
	    $Sheet->Cells($celli, $cellj)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < &__get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = &__get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
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
    foreach my $el (@states) {       	
	&common::displayComputingPrompt();		
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $b = substr(reverse($el),0,$highMaxss);
	if (substr($b, 0, 1) == 0) {
	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";	    
	    my $bn3=reverse($bn);	    
	    my $idx_bn3 = &__get_idx_state(\@states,$bn3);
	    if ($idx_bn3 >= 0) {
		my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states)); 
		my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {		    
		    $Sheet->Cells($celli,$cellj)->{'Value'}="0; ".($Sheet->Cells($celli, $cellj)->{'Value'});
		} else {
		    $Sheet->Cells($celli,$cellj)->{'Value'}="0";
		}
		$nbtransitions++;
		if ($SSWAP_DEBUG >=1) {
		    print $el." ===0"."===> ".$bn3."\n";		   
		    
		}

	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
	    }
	    
	    if ($nb_objs==-1) {
		#Adding of an object
		$bn=substr($b, 1, length($b) -1);
		$bn="1".${bn};	
		$bn3=reverse($bn);
		my $idx_bn3 = &__get_idx_state(\@states,$bn3);
		if ( $idx_bn3 >= 0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bn3 +1,scalar @states));	     
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="+";		    
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {
			print $el." ===+"."===> ".$bn3."\n";		   
			
		    }

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}	    
	    }
	} else {	 
	    if ($nb_objs==-1) {
		#Removing of an object
		my $bn=substr($b, 1, length($b) -1);
		$bn="0".${bn};
		my $bn3=reverse($bn);	    
		my $idx_bn3 = &__get_idx_state(\@states,$bn3);
		if ($idx_bn3 >= 0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states));
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bn3 +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="-";	 	    
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {
			print $el." ===-"."===> ".$bn3."\n";		   
			
		    }

		} else {	       
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$bn3."\n";
		}
	    }

	    my $bn=substr($b, 1, length($b) -1);
	    $bn=${bn}."0";
	    for (my $k=0; $k<length($bn); $k++) {		
		if (substr($bn, $k, 1) == 0 && $k+1 <= $MAX_HEIGHT) {
		    my $bn2=substr($bn, 0, $k)."1".substr($bn, $k+1, length($bn)-$k);		    
		    my $bn3=reverse($bn2);		   
		    my $idx_bn3 = &__get_idx_state(\@states,$bn3);	
		    if ($idx_bn3 >= 0) {
			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bn3 +1, scalar @states));
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bn3 +1);
			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}=sprintf("%x",($k+1))."; ".($Sheet->Cells($celli, $cellj)->{'Value'}); 
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}=sprintf("%x",($k+1));	 
			}
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {
			    print $el." ===".sprintf("%x",($k+1))."===> ".$bn3."\n";		   
			    
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
	my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }
    
    #$last_row = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByRows})    -> {Row};
    #$last_col = $sheet -> UsedRange -> Find({What => "*", SearchDirection => xlPrevious, SearchOrder => xlByColumns}) -> {Column};

    &common::hideComputingPrompt();
    $Sheet->Range('B7')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);				
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
    
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[3].".xlsx";    
    my $nbtransitions=0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');
    my $Excel_symb = Win32::OLE::Const->Load($Excel);  

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=&__get_states_multiplex($_[0], $_[1], $_[2]);	

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = &__get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="M,".$nb_objs.",".sprintf("%x",$highMaxss).",".$multiplex.",-1";
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
    $Sheet->Range('B2:B7')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B7')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B7')-> Font -> {'size'} = 11;    
    $Sheet->Range('B2:B7')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();
    $Sheet->Range('B7:P7')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENSTATES_MSG1a;	

    $Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL1;	
    if ($nb_objs != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs;	
    } else {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }
    if ($multiplex != -1) {
	$Sheet->Range('B6')->{'Value'} = $lang::MSG_SSWAP_GENERAL4." : ".$multiplex;
    }    

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);
	    
	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		# Will be done at the end
		$Sheet->Columns($cellj)-> AutoFit(); 		
	    } else {	
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Rows($celli)-> AutoFit(); 	
	    # Hack for bug with the AutoFit parameter on Columns
	    $Sheet->Rows($celli)-> {'RowHeight'} = length($states[0]) * 8;
	    $Sheet->Cells($celli, $cellj)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < &__get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = &__get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
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
    foreach my $el (@states) {
	&common::displayComputingPrompt();		
	my $mult=0;
	my $sum=0;
	my $nstate=-1;	    	
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	$mult = hex(substr($el,length($el)-1));
	
	if ($mult != 0) {
	    # Here the computing is slightly different.
	    # All the possible multiplexes are selected first, and according to them the new states are established.
	    my @mult_list=&__get_throws_multiplex($_[0],$_[1],hex(substr($el,length($el)-1)));
	    
	  LOOP1: foreach my $el_mult (@mult_list) {		  
	      my @nstate_tmp = reverse(split(//, "0".substr($el,0,length($el)-1)));
	      for (my $i=0; $i<length($el_mult); $i++) {
		  &common::displayComputingPrompt();
		  {
		      my $v=hex(substr($el_mult,$i,1));
		      if (hex($nstate_tmp[$v -1]) + 1 > $MAX_HEIGHT) {
			  next LOOP1;
		      }			    
		      $nstate_tmp[$v -1] = sprintf("%x", (hex($nstate_tmp[$v -1]) + 1));  
		  }
	      }
	      
	      $nstate = join('',reverse(@nstate_tmp));
	      
	      my $idx_nstate=&__get_idx_state(\@states,$nstate);
	      if ($idx_nstate >= 0) {		    
		  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  my $res ='';
		  if (length($el_mult)>=2) {		      
		      $res = "[".$el_mult."]";
		      if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $res."; ".($Sheet->Cells($celli,$cellj)->{'Value'}) ;    
		      } else {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $res;			 
		      }
		  } else {
		      $res = $el_mult;
		      if ($Sheet->Cells($celli,$cellj)->{'Value'} ne "") {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $res."; ".($Sheet->Cells($celli,$cellj)->{'Value'});			 
		      } else {
			  $Sheet->Cells($celli,$cellj)->{'Value'} = $res;			 
		      }
		  }

		  $nbtransitions++;
		  if ($SSWAP_DEBUG >=1) {
		      print $el." ===".$res."===> ".$nstate."\n";		   		      
		  }

	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }
	  }

	    if ($nb_objs == -1) {
		# Removing of one or several objects
		for (my $r = 1; $r <= $mult; $r ++) {
		    my $nm = $mult - $r;
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=&__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {
			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			$Sheet->Cells($celli,$cellj)->{'Value'}="-".sprintf("%x",$r);		
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {
			    print $el." ===[".sprintf("%x",$r)."]===> ".$nstate."\n";		   			    
			}
			
		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
		    }
		}
	  }	    
	} else {
	    &common::displayComputingPrompt();
	    $nstate = "0".substr($el,0,length($el)-1);
	    my $idx_nstate=&__get_idx_state(\@states,$nstate);
	    if ($idx_nstate >= 0) {		    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		$Sheet->Cells($celli,$cellj)->{'Value'}="0";		    
		$nbtransitions++;
		if ($SSWAP_DEBUG >=1) {
		    print $el." ===0"."===> ".$nstate."\n";		   		      
		}

	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1."0".substr($el,0,length($el)-1)."\n";		    
	    }	    

	    if ($nb_objs == -1) {
		# Adding of one or several objects
		for (my $nm = 1; $nm <= $multiplex; $nm ++) {
		    $nstate = substr($el,0,length($el)-1).sprintf("%x",$nm);
		    my $idx_nstate=&__get_idx_state(\@states,$nstate);
		    if ($idx_nstate >= 0) {		    
			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			$Sheet->Cells($celli,$cellj)->{'Value'}="+".sprintf("%x",$nm);		
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {
			    print $el." ===+".sprintf("%x",$nm)."===> ".$nstate."\n";		   		      
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
	my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		#$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }

    &common::hideComputingPrompt();        
    $Sheet->Range('B7')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";
    
    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);				
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
    
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[2].".xlsx";        
    my $nbtransitions=0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    #	|| Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=&__get_states_sync($_[0], $_[1]);    

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = &__get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="S,".$nb_objs.",".sprintf("%x",$highMaxss).",-1,-1";
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
    $Sheet->Range('B2:B7')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B7')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B7')-> Font -> {'size'} = 11;
    $Sheet->Range('B2:B7')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();
    $Sheet->Range('B7:P7')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENSTATES_MSG1a;	

    $Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL1b;	
    if ($nb_objs != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs;	
    } else {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }

    
    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Rows($celli)-> AutoFit(); 	
	    # Hack for bug with the AutoFit parameter on Columns
	    $Sheet->Rows($celli)-> {'RowHeight'} = length($states[0]) * 8;
	    $Sheet->Cells($celli, $cellj)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < &__get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = &__get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
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
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $rhand=substr($el,0,$idx);
	my $rhandth=hex(substr($rhand,length($rhand)-1));
	my $lhand=substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));

	if ($rhandth eq "0" && $lhandth eq "0") {		
	    $nstate="0".substr($rhand,0,length($rhand)-1).",0".substr($lhand,0,length($lhand)-1);	    	 	    
	    my $idx_nstate = &__get_idx_state(\@states,$nstate);
	    if ($idx_nstate >=0) {
		my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		$Sheet->Cells($celli, $cellj)->{'Value'}="(0,0)";		  	 
		$nbtransitions++;
		if ($SSWAP_DEBUG >=1) {		   
		    print $rhand.",".$lhand." ===(0,0)===> ".$nstate."\n";		   
		}		

	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
	    }

	    if ($nb_objs == -1) {
		# Adding of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,+)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,+)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Right Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";	    	 	    
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Left Hand only
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";	    	 	    
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,+)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
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
				my $idx_bn = &__get_idx_state(\@states,substr($bnstate, 0, $l)."1".substr($bnstate, $l+1));
				if ($idx_bn >=0) {	
				    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bn +1, scalar @states)); 
				    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bn +1);
				    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
					$Sheet->Cells($celli, $cellj)->{'Value'}= "(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
				    } else {
					$Sheet->Cells($celli, $cellj)->{'Value'}= "(".$x.",".$y.")";  
				    }
				    $nbtransitions++;
				    if ($SSWAP_DEBUG >=1) {		   
					print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
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

	    if ($nb_objs == -1) {
		# Removing of one or two objects (one in each hand)
		# ==> Both Hands
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);		
		if ($idx_nstate >=0) {		    
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,-)";		  	
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,-)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);		
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# ==> Only Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,-)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,-)===> ".$nstate."\n";		   
		    }		

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
		    my $idx_bnstate = &__get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {
			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bnstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bnstate +1);
			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y.")";		    			   			
			}
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {		   
			    print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
			}		

		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    		
	    }
	    
	    if ($nb_objs == -1) {
		# Adding of one object (in Left Hand)
		# => Keep object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,+)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,+)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(-,+)"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
		    } else {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(-,+)";
		    }			    		  				
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,+)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		
		# Remove only object in Right Hand and do not add object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(-,)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(-,)===> ".$nstate."\n";		   
		    }		

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
		    my $idx_bnstate = &__get_idx_state(\@states,$bnstate);
		    if ($idx_bnstate>=0) {		    
			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_bnstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_bnstate +1);
			if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y."); ".$Sheet->Cells($celli, $cellj)->{'Value'};
			} else {
			    $Sheet->Cells($celli, $cellj)->{'Value'}="(".$x.",".$y.")";
			}
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {		   
			    print $rhand.",".$lhand." ===(".$x.",".$y.")===> ".$bnstate."\n";		   
			}		

		    } else {
			&common::hideComputingPrompt();
			#print $lang::MSG_SSWAP_GENSTATES_MSG1.$bnstate."\n";
		    }
		}	    	    
	    }

	    if ($nb_objs == -1) {
		# Adding of one object (in Right Hand)
		# => Keep object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."1";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(+,)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,)===> ".$nstate."\n";		   
		    }		

		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}
		# => Remove object in Left Hand
		$nstate=substr($rhand,0,length($rhand)-1)."1,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    # A collapse could occur there
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(+,-)"."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
		    } else {
			$Sheet->Cells($celli, $cellj)->{'Value'}="(+,-)";
		    }			    		  				
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(+,-)===> ".$nstate."\n";		   
		    }		
		    
		} else {
		    &common::hideComputingPrompt();
		    #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		}	    
		
		# Remove only object in Left Hand and do not add object in Right Hand
		$nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1)."0";
		my $idx_nstate = &__get_idx_state(\@states,$nstate);
		if ($idx_nstate >=0) {
		    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		    $Sheet->Cells($celli, $cellj)->{'Value'}="(,-)";		  	 
		    $nbtransitions++;
		    if ($SSWAP_DEBUG >=1) {		   
			print $rhand.",".$lhand." ===(,-)===> ".$nstate."\n";		   
		    }		

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
	my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	# Coloring Symetrics states 	
	if ($i =~ ",") {
	    my @res=split(/,/,$i);
	    my $nstate=$res[1].",".$res[0];
	    my $idx_nj=&__get_idx_state(\@states,$nstate); 
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_nj +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_nj + 1);
	    $Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 15;
	}
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }

    &common::hideComputingPrompt();        
    $Sheet->Range('B7')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);				
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
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];        
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[3].".xlsx";        
    my $nbtransitions = 0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=&__get_states_multiplex_sync($_[0], $_[1], $_[2]);	

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = &__get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="MS,".$nb_objs.",".sprintf("%x",$highMaxss).",".$multiplex.",-1";
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
    $Sheet->Range('B2:B7')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B7')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B7')-> Font -> {'size'} = 11;
    $Sheet->Range('B2:B7')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();
    $Sheet->Range('B7:P7')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENSTATES_MSG1a;	

    $Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL1b;	
    if ($nb_objs != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs;	
    } else {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }
    if ($multiplex != -1) {
	$Sheet->Range('B6')->{'Value'} = $lang::MSG_SSWAP_GENERAL4." : ".$multiplex;
    }
    

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Rows($celli)-> AutoFit(); 	
	    # Hack for bug with the AutoFit parameter on Columns
	    $Sheet->Rows($celli)-> {'RowHeight'} = length($states[0]) * 8;
	    $Sheet->Cells($celli, $cellj)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < &__get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = &__get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
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
      my $idx_state_el=&__get_idx_state(\@states, $el);
      
      my $rhand   =substr($el,0,$idx);
      my $rhandth =hex(substr($rhand,length($rhand)-1));
      my $lhand   =substr($el,$idx+1);
      my $lhandth =hex(substr($lhand,length($lhand)-1));		

      if ($rhandth != 0 && $lhandth != 0) {
	  my @mult_list_right=&__get_throws_multiplex_sync_single($_[0],$_[1],$rhandth);

	LOOP1: foreach my $el_multiplex_right (@mult_list_right) {		    
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $nlhand='0'.substr($lhand,0,length($lhand)-1);		    		 
	    my $mult_to_add_nlhand='0' x length($nrhand);
	    
	    for (my $i=0; $i<length($el_multiplex_right); $i++) {	
		# Handle x on multiplex from right hand		    
		if (length($el_multiplex_right)>1 && hex(substr($el_multiplex_right, $i, 1)) > 0 && substr($el_multiplex_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> $MAX_HEIGHT) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.sprintf("%x",$r);			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;
		    #last;
		} elsif (hex(substr($el_multiplex_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";
		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> $MAX_HEIGHT) {
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
		if ( $r> $MAX_HEIGHT) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
	    }
	    
	    $nlhand = $mult_to_add_loc_tmp;					  
	    $nlhand_sav = $nlhand;

	    my @mult_list_left=&__get_throws_multiplex_sync_single($_[0],$_[1],$lhandth);
	  LOOP2: foreach my $el_multiplex_left (@mult_list_left) {	      
	      $nrhand = $nrhand_sav;	      
	      $nlhand = $nlhand_sav;
	      # Handle x on multiplex from right hand on left Hand					            	      
	      my $mult_to_add_nrhand='0' x length($nrhand);
	      for (my $i=0; $i<length($el_multiplex_left); $i++) {
		  # Handle x on multiplex from left hand
		  if (length($el_multiplex_left)>1 && hex(substr($el_multiplex_left, $i, 1)) > 0 && substr($el_multiplex_left, $i +1, 1) eq "x") {
		      $mult_to_add_nrhand = ('0' x (length($nrhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      for (my $j=0;$j<length($nrhand);$j++) {
			  my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_nrhand, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      
		      $nrhand = $mult_to_add_loc_tmp;			    
		      $i++;
		      #last;
		  } elsif (hex(substr($el_multiplex_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";	
		      for (my $j=0;$j<length($mult_to_add_loc);$j++) {
			  my $r = hex(substr($mult_to_add_loc, $j, 1)) + hex(substr($nlhand, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP2;
			  }
			  $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.sprintf("%x",$r);
		      }
		      $nlhand = $mult_to_add_loc_tmp;					    
		  }
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=&__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {	
		  my $res="(";
		  if (length($el_multiplex_right) > 1 && !(length($el_multiplex_right) == 2 && substr($el_multiplex_right,1,1) eq 'x')) { 
		      $res = $res."[".$el_multiplex_right."],";
		  } else {
		      $res = $res.$el_multiplex_right.",";
		  }
		  
		  if (length($el_multiplex_left) > 1 && !(length($el_multiplex_left) == 2 && substr($el_multiplex_left,1,1) eq 'x')) {
		      $res = $res."[".$el_multiplex_left."])";
		  } else {
		      $res = $res.$el_multiplex_left.")";
		  }
		  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		      $Sheet->Cells($celli, $cellj)->{'Value'} = $res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};			  
		  } else {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
		  }
		  
		  $nbtransitions++;		  		 
		  if ($SSWAP_DEBUG >=1) {		   
		      print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
		  }		  

	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }	
	}

	  if ($nb_objs == -1) {
	      # Removing of one or several objects in Both Hand
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).$nmrhand.",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($rhandth - $nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } else
			  {
			      my $res = '';
			      if ($lhandth - $nmlhand == 0) {
				  $res="(-".sprintf("%x",$rhandth - $nmrhand).",)";	  			  		   } 
			      elsif ($rhandth - $nmrhand == 0) {
				  $res="(,-".sprintf("%x",$lhandth - $nmlhand).")";	
			      } else {
				  $res="(-".sprintf("%x",$rhandth - $nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";    
			      }
			      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
			      $nbtransitions++;		  		 
			      if ($SSWAP_DEBUG >=1) {		   
				  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
			      }		  
			  }
		      } else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }	    
	}
	  
      } elsif ($rhandth != 0 && $lhandth == 0) {	 
	  my @mult_list_right=&__get_throws_multiplex_sync_single($_[0],$_[1],$rhandth);
	  
	LOOP1: foreach my $el_multiplex_right (@mult_list_right) {		
	    &common::displayComputingPrompt();
	    my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	    my $mult_to_add_nlhand='0' x length($nrhand);

	    for (my $i=0; $i<length($el_multiplex_right); $i++) {
		# Handle x on multiplex from right hand
		if (length($el_multiplex_right)>1 && hex(substr($el_multiplex_right, $i, 1)) > 0 && substr($el_multiplex_right, $i +1, 1) eq "x") {
		    my $mult_to_add_nlhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1)); 
		    my $mult_to_add_nlhand_tmp = "";
		    for (my $j =0; $j < length($mult_to_add_nlhand); $j++) {
			my $r = hex(substr($mult_to_add_nlhand,$j,1)) + hex(substr($mult_to_add_nlhand2,$j,1));
			if ( $r> $MAX_HEIGHT) {
			    next LOOP1;
			}
			$mult_to_add_nlhand_tmp = $mult_to_add_nlhand_tmp.(sprintf("%x",$r));			
		    }
		    $mult_to_add_nlhand = $mult_to_add_nlhand_tmp;
		    $i++;			
		    #last;
		} elsif (hex(substr($el_multiplex_right, $i, 1)) > 0) {  				
		    my $mult_to_add_loc = ('0' x (length($nrhand) - hex(substr($el_multiplex_right, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_right, $i, 1))/2 - 1));
		    my $mult_to_add_loc_tmp = "";

		    for (my $j=0;$j<length($nrhand);$j++) {
			my $r = hex(substr($nrhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			if ( $r> $MAX_HEIGHT) {
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
		if ( $r> $MAX_HEIGHT) {
		    next LOOP1;
		}
		$mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));
	    }
	    $nlhand=$mult_to_add_loc_tmp;
	    
	    my $nstate=$nrhand.",".$nlhand;
	    
	    my $idx_nstate=&__get_idx_state(\@states, $nstate);

	    if ($idx_nstate >= 0) {		    
		my $res="(";
		if (length($el_multiplex_right) > 1 && !(length($el_multiplex_right) == 2 && substr($el_multiplex_right,1,1) eq 'x')) {		  
		    $res = $res."[".$el_multiplex_right."],0)";
		} else {
		    $res = $res.$el_multiplex_right.",0)";
		}
		
		my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		    $Sheet->Cells($celli, $cellj)->{'Value'}= $res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};				
		} else {
		    $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
		}
		
		$nbtransitions++;		  		 
		if ($SSWAP_DEBUG >=1) {		   
		    print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
		}		  
	    } else {
		&common::hideComputingPrompt();
		#print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	    }	    	       		
	}

	  if ($nb_objs == -1) {
	      # Adding of one or several objects (in Left Hand) and Removing of one or several objects (in Right Hand)
	      for (my $nmrhand = 0; $nmrhand <= $rhandth; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $multiplex; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);
		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($rhandth - $nmrhand == 0 && $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } 
			  else
			  {
			      my $res = '';
			      if ($nmlhand == 0) {
				  $res = "(-".sprintf("%x",$rhandth - $nmrhand).",)";	
				  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
			      } 
			      elsif ($rhandth - $nmrhand == 0) {		
				  $res = "(,+".sprintf("%x",$nmlhand).")";
				  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
			      } else {
				  $res = "(-".sprintf("%x",$rhandth - $nmrhand).",+".sprintf("%x",$nmlhand).")";
				  # A collapse could occur there
				  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
				      $Sheet->Cells($celli, $cellj)->{'Value'}=$res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
				  } else {
				      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
				  }
			      }
			      $nbtransitions++;		  		 
			      if ($SSWAP_DEBUG >=1) {		   
				  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
			      }		  
			  }
		      } 
		      else {
			  &common::hideComputingPrompt();
			  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		      }
		  }
	      }
	}	    

      } elsif ($rhandth == 0 && $lhandth != 0) {	    		
	  my $nrhand='0'.substr($rhand,0,length($rhand)-1);
	  my $nrhand_sav = $nrhand;
	  
	  my @mult_list_left=&__get_throws_multiplex_sync_single($_[0],$_[1],$lhandth);
	  LOOP1 : foreach my $el_multiplex_left (@mult_list_left) {		
	      $nrhand = $nrhand_sav;
	      my $nlhand='0'.substr($lhand,0,length($lhand)-1);
	      my $mult_to_add_nrhand='0' x length($nrhand);

	      for (my $i=0; $i<length($el_multiplex_left); $i++) {
		  # Handle x on multiplex from left hand
		  my $mult_to_add_nrhand = '0' x length($nrhand);
		  if (length($el_multiplex_left)>1 && hex(substr($el_multiplex_left, $i, 1)) > 0 && substr($el_multiplex_left, $i +1, 1) eq "x") {
		      my $mult_to_add_nrhand2 = ('0' x (length($nrhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1)); 
		      my $mult_to_add_nrhand_tmp = "";
		      for (my $j =0; $j < length($mult_to_add_nrhand); $j++) {
			  my $r = hex(substr($mult_to_add_nrhand,$j,1)) + hex(substr($mult_to_add_nrhand2,$j,1));
			  if ( $r> $MAX_HEIGHT) {
			      next LOOP1;
			  }
			  $mult_to_add_nrhand_tmp = $mult_to_add_nrhand_tmp.(sprintf("%x",$r));			
		      }
		      $mult_to_add_nrhand = $mult_to_add_nrhand_tmp;
		      $i++;
		      #last;
		  } elsif (hex(substr($el_multiplex_left, $i, 1)) > 0) {  				
		      my $mult_to_add_loc = ('0' x (length($nlhand) - hex(substr($el_multiplex_left, $i, 1))/2)).'1'.('0' x (hex(substr($el_multiplex_left, $i, 1))/2 - 1));
		      my $mult_to_add_loc_tmp = "";
		      
		      for (my $j=0;$j<length($nlhand);$j++) {
			  my $r = hex(substr($nlhand, $j, 1))+hex(substr($mult_to_add_loc, $j, 1));
			  if ( $r> $MAX_HEIGHT) {
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
		      if ( $r> $MAX_HEIGHT) {
			  next LOOP1;
		      }
		      $mult_to_add_loc_tmp=$mult_to_add_loc_tmp.(sprintf("%x",$r));	
		  }
		  $nrhand = $mult_to_add_loc_tmp;
	      }

	      &common::displayComputingPrompt();
	      my $nstate=$nrhand.",".$nlhand;
	      my $idx_nstate=&__get_idx_state(\@states, $nstate);

	      if ($idx_nstate >= 0) {		    		  
		  my $res="(0,";

		  if (length($el_multiplex_left) > 1 && !(length($el_multiplex_left) == 2 && substr($el_multiplex_left,1,1) eq 'x')) {
		      $res = $res."[".$el_multiplex_left."])";
		  } else {
		      $res = $res.$el_multiplex_left.")";
		  }
		  
		  $nbtransitions++;		  		 
		  if ($SSWAP_DEBUG >=1) {		   
		      print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
		  }		  
		  
		  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};      
		  } else {
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
		  }	    
		  
	      } else {
		  &common::hideComputingPrompt();
		  #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	      }	    
	  }

	  if ($nb_objs == -1) {
	      # Adding of one or several objects (in Right Hand) and Removing of one or several objects (in Left Hand)
	      for (my $nmrhand = 0; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 0; $nmlhand <= $lhandth; $nmlhand ++) {
		      my $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  if ($nmrhand == 0 && $lhandth - $nmlhand == 0) {
			      #No modification, thus no entry concerned
			  } 
			  else
			  {
			      my $res = '';
			      if ($nmrhand == 0) {
				  $res = "(,-".sprintf("%x",$lhandth - $nmlhand).")";
				  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;		  
			      } elsif ($lhandth - $nmlhand == 0) {
				  $res = "(+".sprintf("%x",$nmrhand).",)";
				  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;		  
			      } else {
				  $res = "(+".sprintf("%x",$nmrhand).",-".sprintf("%x",$lhandth - $nmlhand).")";
				  # A collapse could occur there
				  if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
				      $Sheet->Cells($celli, $cellj)->{'Value'}=$res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
				  } else {
				      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;
				  }			    		  
			      }
			      $nbtransitions++;		  		 
			      if ($SSWAP_DEBUG >=1) {		   
				  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
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
	  my $idx_nstate=&__get_idx_state(\@states, $nstate);

	  if ($idx_nstate >= 0) {		    
	      my $res="(0,0)";
	      my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
	      my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
	      if ($Sheet->Cells($celli, $cellj)->{'Value'} ne "") {
		  $Sheet->Cells($celli, $cellj)->{'Value'}=$res."; ".$Sheet->Cells($celli, $cellj)->{'Value'};				
	      } else {
		  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;				
	      }	

	      $nbtransitions++;		  		 
	      if ($SSWAP_DEBUG >=1) {		   
		  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
	      }		  
	      
	  } else {
	      &common::hideComputingPrompt();
	      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";		    
	  }	

	  if ($nb_objs == -1) {
	      #Adding of one or several objects (in each hand)
	      # ==> Both Hands
	      for (my $nmrhand = 1; $nmrhand <= $multiplex; $nmrhand ++) {
		  for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		      $nstate=substr($rhand,0,length($rhand)-1).sprintf("%x",$nmrhand).",".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);   
		      my $idx_nstate=&__get_idx_state(\@states, $nstate);		      

		      if ($idx_nstate >=0) {
			  my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			  my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
			  my $res="(+".sprintf("%x",$nmrhand).",+".sprintf("%x",$nmlhand).")";
			  $Sheet->Cells($celli, $cellj)->{'Value'}=$res;		  

			  $nbtransitions++;		  		 
			  if ($SSWAP_DEBUG >=1) {		   
			      print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
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
		  my $idx_nstate=&__get_idx_state(\@states, $nstate);

		  if ($idx_nstate >=0) {
		      my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		      my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		      my $res = "(+".sprintf("%x",$nmrhand).",)";
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;		  	 

		      $nbtransitions++;		  		 
		      if ($SSWAP_DEBUG >=1) {		   
			  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
		      }		  

		  } else {
		      &common::hideComputingPrompt();
		      #print $lang::MSG_SSWAP_GENSTATES_MSG1.$nstate."\n";
		  }
	      }
	      # ==> Left Hand only
	      for (my $nmlhand = 1; $nmlhand <= $multiplex; $nmlhand ++) {
		  $nstate=substr($rhand,0,length($rhand)-1)."0,".substr($lhand,0,length($lhand)-1).sprintf("%x",$nmlhand);	    	 	
		  my $idx_nstate=&__get_idx_state(\@states, $nstate);

		  if ($idx_nstate >=0) {
		      my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		      my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		      my $res = "(,+".sprintf("%x",$nmlhand).")";		  	 
		      $Sheet->Cells($celli, $cellj)->{'Value'}=$res;

		      $nbtransitions++;		  		 
		      if ($SSWAP_DEBUG >=1) {		   
			  print $rhand.",".$lhand." ===".$res."===> ".$nstate."\n";		   
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
	my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	# Coloring Symetrics states 	
	if ($i =~ ",") {
	    my @res=split(/,/,$i);
	    my $nstate=$res[1].",".$res[0];
	    my $idx_nj=&__get_idx_state(\@states,$nstate); 
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_nj +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_nj + 1);
	    $Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 15;
	}
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }
    
    &common::hideComputingPrompt();        
    $Sheet->Range('B7')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";
    
    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);				
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


sub __write_states_multisync_xls
{
    my $nb_objs=$_[0];
    my $highMaxss=hex($_[1]);
    my $multiplex=$_[2];        
    my $pwd = getdcwd();   
    my $file = $pwd."\\$conf::RESULTS\\".$_[3].".xlsx";        
    my $nbtransitions = 0;
    
    #use Win32::OLE qw(in with);
    #use Win32::OLE::Const 'Microsoft Excel';
    
    $Win32::OLE::Warn = 3;	# die on errors...
    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application')
    # || Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');  
    my $Excel_symb = Win32::OLE::Const->Load($Excel);

    # open Excel file and write infos
    my $Book = $Excel->Workbooks->Add;
    $Book->BuiltinDocumentProperties -> {'title'} = 'States/Transition Matrix';
    $Book->BuiltinDocumentProperties -> {'author'} = "$common::AUTHOR";
    $Book->BuiltinDocumentProperties -> {'comments'} = 'Creation : JugglingTB, Module SSWAP '.$SSWAP_VERSION." (writeStates_xls)";    

    # Get all the possible states
    my @states=&__get_states_multisync($_[0], $_[1], $_[2]);	

    print $lang::MSG_SSWAP_WRITE_EXCEL_FROM_STATES2;
    print colored [$common::COLOR_RESULT], "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10." ]\n";
    
    my $nbsheets = &__get_nb_xls_sheets (scalar @states);


    # Generation of needed sheets
    my $comment ="MULTI,".$nb_objs.",".sprintf("%x",$highMaxss).",".$multiplex.",-1";
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
    $Sheet->Range('B2:B7')-> Font -> {'ColorIndex'} = 3;
    $Sheet->Range('B2:B7')-> Font -> {'FontStyle'} = "Bold";
    $Sheet->Range('B2:B7')-> Font -> {'size'} = 11;
    $Sheet->Range('B2:B7')-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignLeft'};
    $Sheet->Range('B2:P2')-> Merge();
    $Sheet->Range('B3:P3')-> Merge();
    $Sheet->Range('B4:P4')-> Merge();
    $Sheet->Range('B5:P5')-> Merge();
    $Sheet->Range('B6:P6')-> Merge();
    $Sheet->Range('B7:P7')-> Merge();

    $Sheet->Range('B2')->{'Value'} = $lang::MSG_SSWAP_GENSTATES_MSG1a;	

    $Sheet->Range('B3')->{'Value'} = $lang::MSG_SSWAP_GENERAL1c;	
    if ($nb_objs != -1) {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2." : ".$nb_objs;	
    } else {
	$Sheet->Range('B4')->{'Value'} = $lang::MSG_SSWAP_GENERAL2b;	
    }       
    if ($highMaxss != -1) {
	$Sheet->Range('B5')->{'Value'} = $lang::MSG_SSWAP_GENERAL3." : ".sprintf("%x",$highMaxss);
    }
    if ($multiplex != -1) {
	$Sheet->Range('B6')->{'Value'} = $lang::MSG_SSWAP_GENERAL4." : ".$multiplex;
    }
    

    # Writes the States in the Excel file
    # Start by the Columns headers ...
    my $idx_sheet = 0;
    while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
	    &common::displayComputingPrompt();	    
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					  + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
	    my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);

	    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
		$Sheet->Columns($cellj)-> AutoFit(); 
	    } else {
		$Sheet->Columns($cellj)-> {'ColumnWidth'} = $conf::EXCELCOLSIZE; 
	    }

	    $Sheet->Columns($cellj)-> {'NumberFormat'} = "\@"; # Text
	    $Sheet->Columns($cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignRight'};

	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    $Sheet->Cells($celli, $cellj)-> Font -> {'ColorIndex'} = 3;
	    $Sheet->Cells($celli, $cellj)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'};
	    $Sheet->Cells($celli, $cellj)-> {'Orientation'} = -90;
	    $Sheet->Rows($celli)-> AutoFit(); 	
	    # Hack for bug with the AutoFit parameter on Columns
	    $Sheet->Rows($celli)-> {'RowHeight'} = length($states[0]) * 8;
	    $Sheet->Cells($celli, $cellj)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	    $Sheet->Cells($celli, $cellj)->Interior->{'ColorIndex'} = 6;	    
	    $Sheet->Cells($celli, $cellj)->{'Value'} = $states[$jdx];
	}

	$idx_sheet++;
    }


    # ... and then the Rows headers
    my $jdx_sheet = 0;
    while ($jdx_sheet < &__get_nb_xls_sheets_for_col(scalar @states)) {
	foreach my $idx (0 .. scalar(@states) -1) {    	 
	    &common::displayComputingPrompt();
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx +1, 0, scalar @states) + $jdx_sheet); 
	    my ($celli, $cellj) = &__get_xls_cell($idx +1, 0);
	    
	    $Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
	    $Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
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
    foreach my $el (@states) {
	&common::displayComputingPrompt();
	my $idx = rindex($el,'|');
	my $idx_state_el=&__get_idx_state(\@states, $el);
	
	my $rhand   =substr($el,0,$idx);
	my $rhandth =hex(substr($rhand,length($rhand)-1));
	my $lhand   =substr($el,$idx+1);
	my $lhandth =hex(substr($lhand,length($lhand)-1));		
	
	my @multisync_list=&__get_throws_multisync($_[0],$_[1],$rhandth,$lhandth);

	foreach my $elmult (@multisync_list) {		
	    &common::displayComputingPrompt();
	    my $elmult_final = $elmult;
	    my $nrhand=reverse('0'.substr($rhand,0,length($rhand)-1));
	    my $nlhand=reverse('0'.substr($lhand,0,length($lhand)-1));
	    my $nrhand_tmp = '';
	    my $nlhand_tmp = '';

	    my $cur = "R";
	    my $beat = 0;

	    for (my $i=0; $i<length($elmult); $i++) {
		&common::displayComputingPrompt();
		my $v = substr($elmult,$i,1);		
		if($v eq "*")
		{
		    if($cur eq "R")
		    {
			$cur = "L";
		    }
		    else
		    {
			$cur = "R";
		    }		    		
		}
		elsif($v eq "!")
		{
		    # Nothing to do
		}
		else
		{
		    $v = hex($v);
		    if($cur eq "R")
		    {
			if($v ne "0")
			{
			    if(($v % 2 == 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($elmult,$i+1,1)) eq "X"))
			    {
				$nrhand_tmp = $nrhand;
				$nrhand_tmp = substr($nrhand,0,$v-1).sprintf("%x",(1+hex(substr($nrhand,$v-1,1)))).substr($nrhand,$v);
				$nrhand = $nrhand_tmp;
			    }
			    elsif(($v % 2 != 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($elmult,$i+1,1)) eq "X"))
			    {
				$nlhand_tmp = $nlhand;
				$nlhand_tmp = substr($nlhand,0,$v-1).sprintf("%x",(1+hex(substr($nlhand,$v-1,1)))).substr($nlhand,$v); 
				$nlhand = $nlhand_tmp;
			    }
			    if(uc(substr($elmult,$i+1,1)) eq "X")
			    {
				$i++;
			    }
			}
			$cur = "L";
		    }
		    else
		    {
			if($v ne "0")
			{
			    if(($v % 2 == 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 != 0 && uc(substr($elmult,$i+1,1)) eq "X"))		       
			    {
				$nlhand_tmp = $nlhand;
				$nlhand_tmp = substr($nlhand,0,$v-1).sprintf("%x",(1+hex(substr($nlhand,$v-1,1)))).substr($nlhand,$v); 
				$nlhand = $nlhand_tmp;
			    }
			    elsif(($v % 2 != 0 && uc(substr($elmult,$i+1,1)) ne "X") || ($v % 2 == 0 && uc(substr($elmult,$i+1,1)) eq "X"))			  
			    {
				$nrhand_tmp = $nrhand;
				$nrhand_tmp = substr($nrhand,0,$v-1).sprintf("%x",(1+hex(substr($nrhand,$v-1,1)))).substr($nrhand,$v);			
				$nrhand = $nrhand_tmp;
			    }
			    if(uc(substr($elmult,$i+1,1)) eq "X")
			    {
				$i++;
			    }
			}
			$cur = "R";
		    }
		}
	    }

	    my $nstate=reverse($nrhand)."|".reverse($nlhand);	    
	    my $idx_nstate=&__get_idx_state(\@states, $nstate);
	    if($idx_nstate == -1)
	    {
		if ($SSWAP_DEBUG>=1) 
		{			
		    print "== SSWAP::__gen_states_multisync : Rejected State : ".$nstate."\n";
		}
	    }
	    else
	    {
		my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
		my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);
		if($Sheet->Cells($celli, $cellj)->{'Value'} eq "")
		{
		    $Sheet->Cells($celli, $cellj)->{'Value'}=$elmult_final;		  	 
		}
		else
		{
		    $Sheet->Cells($celli, $cellj)->{'Value'}=$elmult_final."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
		}
		$nbtransitions++;
		if ($SSWAP_DEBUG >=1) {		   
		    print $rhand."|".$lhand." ===".$elmult_final."===> ".$nstate."\n";		   
		}	       

	    }
	}

	if($nb_objs == -1)
	{
	    # Handle Objects Lost or Added
	    my $nrhand=substr($rhand,0,length($rhand)-1);
	    my $nlhand=substr($lhand,0,length($lhand)-1);
	    my $rhandth =hex(substr($rhand,length($rhand)-1));
	    my $lhandth =hex(substr($lhand,length($lhand)-1));		

	    if($rhandth >=1 || $lhandth >= 1)
	    {
		for(my $i=0; $i<=$rhandth; $i++)
		{
		    for(my $j=0;$j<=$lhandth; $j++)
		    {		  
			my $nstate=$nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j);
			my $idx_nstate=&__get_idx_state(\@states, $nstate);
			my $tr = '';
			if($rhandth-$i > 0)
			{
			    $tr="-".sprintf("%x",$rhandth-$i)."|";
			}
			else
			{
			    $tr = "|";
			}
			if($lhandth-$j > 0)
			{
			    $tr=$tr."-".sprintf("%x",$lhandth-$j);
			}
			
			if($tr ne "|")
			{
			    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);			    
			    if($Sheet->Cells($celli, $cellj)->{'Value'} eq "")
			    {
				$Sheet->Cells($celli, $cellj)->{'Value'}=$tr;		  	 
			    }
			    else
			    {
				$Sheet->Cells($celli, $cellj)->{'Value'}=$tr."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			    }
			    $nbtransitions++;
			    if ($SSWAP_DEBUG >=1) {		   
				print $rhand."|".$lhand." ===".$tr."===> ".$nstate."\n";		   
			    }	       

			}				      
		    }
		}
	    }
	    elsif($rhandth == 0 && $lhandth == 0)
	    {
		for(my $i=0; $i<=$multiplex; $i++)
		{
		    for(my $j=0;$j<=$multiplex; $j++)
		    {		  
			my $nstate=$nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j);
			my $idx_nstate=&__get_idx_state(\@states, $nstate);		      
			my $tr='';
			if($i > 0)
			{
			    $tr = "+".sprintf("%x",$i)."|"; 
			}
			else
			{
			    $tr="|",
			}
			if($j > 0)
			{
			    $tr = $tr."+".sprintf("%x",$j); 
			}
			if($tr ne "|")
			{
			    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			    my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);			    
			    if($Sheet->Cells($celli, $cellj)->{'Value'} eq "")
			    {
				$Sheet->Cells($celli, $cellj)->{'Value'}=$tr;		  	 
			    }
			    else
			    {
				$Sheet->Cells($celli, $cellj)->{'Value'}=$tr."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			    }
			    $nbtransitions++;
			    if ($SSWAP_DEBUG >=1) {		   
				print $rhand."|".$lhand." ===".$tr."===> ".$nstate."\n";		   
			    }	       

			}		          
		    }
		}	      
	    }

	    if($rhandth == 0 && $lhandth != 0)
	    {
		for(my $i=1; $i<=$multiplex; $i++)
		{
		    for(my $j=0;$j<=$lhandth; $j++)
		    {
			my $nstate=$nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j);
			my $idx_nstate=&__get_idx_state(\@states, $nstate);			
			my $tr = "+".sprintf("%x",$i)."|";
			if($lhandth-$j > 0)
			{
			    $tr=$tr."-".sprintf("%x",$lhandth-$j);
			}

			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);			
			if($Sheet->Cells($celli, $cellj)->{'Value'} eq "")
			{
			    $Sheet->Cells($celli, $cellj)->{'Value'}=$tr;		  	 
			}
			else
			{
			    $Sheet->Cells($celli, $cellj)->{'Value'}=$tr."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			}
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {		   
			    print $rhand."|".$lhand." ===".$tr."===> ".$nstate."\n";		   
			}	       

		    }
		}
	    }		 
	    elsif($lhandth == 0 && $rhandth != 0)
	    {
		for(my $i=0; $i<=$rhandth; $i++)
		{
		    for(my $j=1;$j<=$multiplex; $j++)
		    {
			my $nstate=$nrhand.sprintf("%x",$i)."|".$nlhand.sprintf("%x",$j);
			my $idx_nstate=&__get_idx_state(\@states, $nstate);
			my $tr = '';
			if($rhandth-$i > 0)
			{
			    $tr="-".sprintf("%x",$rhandth-$i)."|";
			}
			else
			{
			    $tr = "|";
			}
			$tr=$tr."+".sprintf("%x",$j);

			my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_state_el +1, $idx_nstate +1, scalar @states)); 
			my ($celli, $cellj) = &__get_xls_cell($idx_state_el +1, $idx_nstate +1);			
			if($Sheet->Cells($celli, $cellj)->{'Value'} eq "")
			{
			    $Sheet->Cells($celli, $cellj)->{'Value'}=$tr;		  	 
			}
			else
			{
			    $Sheet->Cells($celli, $cellj)->{'Value'}=$tr."; ".$Sheet->Cells($celli, $cellj)->{'Value'};
			}
			$nbtransitions++;
			if ($SSWAP_DEBUG >=1) {		   
			    print $rhand."|".$lhand." ===".$tr."===> ".$nstate."\n";		   
			}	       

		    }
		}
	    }		 
	}
    }

    my $idx_i =0;
    my $idx_j =0;
    foreach my $i (@states) {    	 
	
	# Coloring Median States
	my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_i +1, scalar @states));	
	my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_i + 1);
	$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 6;

	# Coloring Symetrics states 	
	if ($i =~ "\|") {
	    my @res=split(/\|/,$i);
	    my $nstate=$res[1]."|".$res[0];
	    my $idx_nj=&__get_idx_state(\@states,$nstate); 
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_nj +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_nj + 1);
	    $Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 15;
	}
	
	$idx_j =0;
	foreach my $j (@states) {    	 
	    &common::displayComputingPrompt();	
	    my $Sheet = $Book->Worksheets(&__get_xls_sheet($idx_i +1, $idx_j +1, scalar @states));	
	    my ($celli, $cellj) = &__get_xls_cell($idx_i +1, $idx_j + 1);
	    my $w = $Sheet->Cells($celli, $cellj) -> {'Value'};
	    # Coloring Adding/Removing Objects 
	    if ($w =~ /\+/ && $w =~ /-/ ) {		 		
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 4;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w  =~ /\+/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 8;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    } elsif ($w =~ /-/) {		 
		$Sheet->Cells($celli, $cellj)-> Interior->{'ColorIndex'} = 7;
		$Sheet->Cells($celli, $cellj)-> Font -> {'FontStyle'} = "Bold";
		$Sheet->Cells($celli, $cellj)-> Font -> {'size'} = 11;
	    }
	    
	    $idx_j++;
	}
	$idx_i++;
    }
    
    &common::hideComputingPrompt();        
    $Sheet->Range('B7')->{'Value'} = "[ => ".(scalar @states)." ".$lang::MSG_SSWAP_GENERAL10.", ".$nbtransitions." ".$lang::MSG_SSWAP_GENERAL11." ]";

    # Do Autofit
    if (uc($conf::EXCELCOLSIZE) eq "AUTO") {
	my $idx_sheet = 0;
	while ($idx_sheet < &__get_nb_xls_sheets_for_row(scalar @states)) {
	    foreach my $jdx (0 .. scalar(@states) -1 ) {    	 	 
		&common::displayComputingPrompt();	    
		my $Sheet = $Book->Worksheets(&__get_xls_sheet(0, $jdx + 1, scalar @states) 
					      + $idx_sheet * &__get_nb_xls_sheets_for_col(scalar @states));
		my ($celli, $cellj) = &__get_xls_cell(0, $jdx +1);				
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


# Get Matrix and States from an XLS file
sub __getStates_from_xls
{
    my $excelfile = $_[0];
    my @states = ();
    my @matrix = ();
    
    $Win32::OLE::Warn = 3;	# die on errors...    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application') 
    # || Win32::OLE->new('Excel.Application', 'Quit');
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');
    my $Book = $Excel->Workbooks->Open($excelfile);
    my $Sheet = $Book->Worksheets(1);
    my $celli = $EXCEL_ROW_START;
    my $cellj = $EXCEL_COL_START+1;

    my $nbstates=0;

    if ($SSWAP_DEBUG >= 1) {
	print "== SSWAP::__getStates_from_xls : $_[0] \n";
    }

    # Get States
    for(my $j = 0; $j < $EXCEL_MAX_ROWS; $j++)
    {
	&common::displayComputingPrompt();	    
	my $v = $Sheet->Cells($celli, $cellj + $j)->{'Value'};
	if ($v eq "")
	{
	    last;
	}

	$nbstates++;
	push(@states, $v);
	if ($SSWAP_DEBUG >=1) {
	    print "Found State ($celli,".($cellj+$j).") :".$v."\n";
	}
    }
    &common::hideComputingPrompt();	    

    my $celli = $EXCEL_ROW_START+1;
    my $cellj = $EXCEL_COL_START+1;

    # Fill Matrix
    for(my $i = 0; $i < $nbstates; $i++)
    {
	&common::displayComputingPrompt();	    
	my $el1 = $Sheet->Cells($EXCEL_ROW_START + 1 + $i, $EXCEL_COL_START)->{'Value'};
	my $idx_state_i=&__get_idx_state(\@states, $el1);

	for(my $j = 0; $j < $nbstates; $j++)
	{	    
	    &common::displayComputingPrompt();	    
	    my $el2 = $Sheet->Cells($EXCEL_ROW_START, $EXCEL_COL_START + 1 + $j)->{'Value'};
	    my $idx_state_j=&__get_idx_state(\@states, $el2);
	    my $v = $Sheet->Cells($celli + $i, $cellj + $j)->{'Value'};
	    if ($v ne "")
	    {      	    
		$matrix[$idx_state_i][$idx_state_j]= $v;	
		if ($SSWAP_DEBUG >=1) {		    
		    print "($el1, $el2)===> ".$v."\n";       
		}
	    }
	}
    }
    &common::hideComputingPrompt();	    
    $Book -> Close;

    print $lang::MSG_SSWAP_GETSTATES_FROM_XLS_MSG1."\n";
    return (\@matrix, \@states) ;
}


## Check if the XLS file is valid and the one awaited
#  The first Sheet name is one of :
#   - Matrix__MOD1,NbOjects,Height,Mult,Type : If generated using writeStates_xls
#              MOD1 is V, M, S, MS, MULTI
#              NbObjects may be -1 if undefined 
#              Mult may be -1 if no relevant  
#              Type is -1 for Regular Matrix (R for Reduced but not possible currently)
#
#   - Matrix:MOD2,NbOjects,Height,Mult,Type : If generated using genStates
#              MOD2 is A, S, MULTI
#              NbObjects may be -1 if undefined 
#              Mult may be -1 if no relevant  
#              Type is -1 for Regular Matrix and R for Reduced
#             
sub __check_xls_matrix_file
{
    my $excelfile = $_[0];
    my $mod = $_[1];
    my $NbObjects = $_[2];
    my $height = $_[3];
    my $mult = $_[4];
    my $type = $_[5];

    $Win32::OLE::Warn = 3;	# die on errors...    
    # get already active Excel application or open new
    # my $Excel = Win32::OLE->GetActiveObject('Excel.Application') 
    # || Win32::OLE->new('Excel.Application', 'Quit');
    my $Excel = Win32::OLE->new('Excel.Application', 'Quit');
    my $Book = $Excel->Workbooks->Open($excelfile);
    my $Sheet = $Book->Worksheets(1);   
    my $propal1 = "Matrix__";                # writeStates_xls   
    my $propal2 = "Matrix=";                 # genStates

    if($type eq '?')
    {
	# Nevermind if it is a Regular or a Reduced Matrix
	my $propal1b = "Matrix__";           # writeStates_xls   
	my $propal2b = "Matrix=";            # genStates

	$propal1 = $propal1.$mod.",".$NbObjects.",".$height.",".$mult.","."-1"; # writeStates_xls   
	$propal1b = $propal1b.$mod.",".$NbObjects.",".$height.",".$mult.","."-R"; # writeStates_xls   

	if($mod eq "V" || $mod eq "M")
	{
	    $propal2=$propal2."A,".$NbObjects.",".$height.",".$mult.","."-1";    
	    $propal2b=$propal2b."A,".$NbObjects.",".$height.",".$mult.","."R";    
	}
	elsif($mod eq "MULTI")
	{
	    $propal2=$propal2."MULTI,".$NbObjects.",".$height.",".$mult.",".$type;    
	    $propal2b=$propal2b."MULTI,".$NbObjects.",".$height.",".$mult.","."R";    
	}
	else {
	    $propal2=$propal2."S,".$NbObjects.",".$height.",".$mult.","."-1";    
	    $propal2b=$propal2b."S,".$NbObjects.",".$height.",".$mult.","."R";    
	}
	
	if($Sheet->{Name} ne $propal1 && 
	   $Sheet->{Name} ne $propal1b && 
	   $Sheet->{Name} ne $propal2 && 
	   $Sheet->{Name} ne $propal2b)
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_CHECK_XLS_FILE_1."[".$Sheet->{Name}." != $propal1 || $propal2]"."\n".$lang::MSG_SSWAP_CHECK_XLS_FILE_2."\n";
	    $Book -> Close;
	    return -1;
	}
	
	$Book -> Close;
    }
    else
    {
	$propal1 = $propal1.$mod.",".$NbObjects.",".$height.",".$mult.",".$type; # writeStates_xls   

	if($mod eq "V" || $mod eq "M")
	{
	    $propal2=$propal2."A,".$NbObjects.",".$height.",".$mult.",".$type;    
	}
	elsif($mod eq "MULTI")
	{
	    $propal2=$propal2."MULTI,".$NbObjects.",".$height.",".$mult.",".$type;    
	}
	else {
	    $propal2=$propal2."S,".$NbObjects.",".$height.",".$mult.",".$type;    
	}
	
	if($Sheet->{Name} ne $propal1 && $Sheet->{Name} ne $propal2)
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_CHECK_XLS_FILE_1."[".$Sheet->{Name}." != $propal1 || $propal2]"."\n".$lang::MSG_SSWAP_CHECK_XLS_FILE_2."\n";
	    $Book -> Close;
	    return -1;
	}
	
	$Book -> Close;
    }

    return 1;
}


sub __get_elementary_circuits
{

    # /*
    #  * Algorithm Adaptation from : K.A. Hawick and H.A. James
    #  *  "Enumerating Circuits and Loops in Graphs with Self-Arcs and Multiple-Arcs"
    #  *                   Computer Science, Institute for Information and Mathematical Sciences,
    #  *                   Massey University, North Shore 102-904, Auckland, New Zealand
    #  *                   Technical Report CSTN-013
    #  * Implementation : Frederic Roudaut
    #  */

    my $longestMode = 1;          # longest Definition : 0 : in term of state, 1 : in term of siteswap Period 
    
    sub __stacksPrint {
	my $i;
	my @statesStack=@{$_[0]};
	my @matrix = @{$_[1]};
	my @states = @{$_[2]};
	my @ssStack = @{$_[3]};
	my $resRef = $_[4];
	my $opts = uc($_[5]); 
	my $f = $_[6]; 
	my $diagram_results = "N";          # Get the States Path Results or no (default)
	my $longest_results = "Y";          # Get Computation Synthesis (default) or no
	&GetOptionsFromString($opts,    				    
			      "-L:s" => \$longest_results,
			      "-H:s" => \$diagram_results,
	    );

	my $v="";

	if($f ne "" && $f ne "-2" && "JML:"=~substr($f,0,4))
	{
	    my $f_in = substr($f,4).".jml";		      		
	    open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
	    print FILE_JML "<line display=\"";
	    close(FILE_JML);	    
	}

	for ($i = 0; $i < scalar @ssStack; $i++) {
	    if(uc($diagram_results) eq "Y")
	    {
		if($f eq "" || $f eq "-2") 
		{
		    print $ssStack[$i];
		}	      
		elsif ("JML:"=~substr($f,0,4)) 
		{
		    my $f_in = substr($f,4).".jml";		      		
		    open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		    print FILE_JML $ssStack[$i];
		    close(FILE_JML);
		}  	
		elsif ("SSHTML:"=~substr($f,0,7)) 
		{		    
		    my $f_in = substr($f,7).".html";	
		    open(FILE,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		    print FILE $ssStack[$i];		    
		    close(FILE);		
		}
		elsif($f ne "-1")
		{		    
		    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		    print FILE $ssStack[$i];		    
		    close(FILE);
		}
	    }

	    $v=$v.$ssStack[$i]	   
	}

	if(uc($diagram_results) eq "Y")
	{
	    if($f eq "" || $f eq "-2") 
	    {
		print " {";
		for ($i = 0; $i < scalar @statesStack; $i++) 
		{
		    print $states[$statesStack[$i]]." ";
		}
		print $states[$statesStack[0]];
		print "}\n";
	    }	      
	    elsif ("JML:"=~substr($f,0,4)) 
	    {				
		my $f_in = substr($f,4).".jml";	
		open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		print FILE_JML " {";
		for ($i = 0; $i < scalar @statesStack; $i++) 
		{
		    print FILE_JML $states[$statesStack[$i]]." ";
		}
		print FILE_JML $states[$statesStack[0]];
		print FILE_JML "}\"/>\n";
		close(FILE_JML);
	    }  	
	    elsif ("SSHTML:"=~substr($f,0,7)) 
	    {		    
		my $f_in = substr($f,7).".html";	
		open(FILE,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		print FILE " {";
		for ($i = 0; $i < scalar @statesStack; $i++) 
		{
		    print FILE $states[$statesStack[$i]]." ";
		}
		print FILE $states[$statesStack[0]];
		print FILE "}<BR/>\n";
		close(FILE);		
	    }
	    elsif($f ne "-1")
	    {
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE " {";
		for ($i = 0; $i < scalar @statesStack; $i++) 
		{
		    print FILE $states[$statesStack[$i]]." ";
		}
		print FILE $states[$statesStack[0]];
		print FILE "}\n";
		close(FILE);
	    }
	}

	push( @{$resRef}, $v);  	    	  
    }
    

    sub __unblock {
	my $u=$_[0];
	my @B=@{$_[1]};
	my @blocked=@{$_[2]};

	$blocked[$u] = 0;
	for (my $wPos = 1; $wPos <= $B[$u][0]; $wPos++) {
	    # for each w in B[u]
	    my $w = $B[$u][$wPos];
	    my $nOccurrences = 0;
	    for (my $i = 1; $i <= $B[$u][0]; $i++) {
		if ($B[$u][$i] == $w) {
		    $nOccurrences++;
		    for (my $j = $i; $j < $B[$u][0]; $j++) {
			$B[$u][$j] = $B[$u][$j+1];
		    }
		    $B[$u][0]--; # should be safe as list is re-evaluated each time around the i-loop
		    $i--;
		}
	    }
	    
	    $wPos -= $nOccurrences;
	    
	    if ($blocked[$w] == 1)
	    {
		&__unblock($w, \@B, \@blocked);
	    }
	}
    }
    
    sub __circuit { # Ideas based on Johnson 's logical procedure CIRCUIT
	my $start = $_[0];                # Start state index
	my $v = $_[1];                    # Current state index
	my @Ak = @{$_[2]};                # Graph to analyse : integer array size n of lists, 
	# ie the transitions from the states
	#  Ak[i][0] : Number of transitions from state index i
	#  Ak[i][1..j] : transitions index from state index i   
	my @statesStack = @{$_[4]};       # Current Stack result of states
	my @blocked = @{$_[5]};           # logical array indexed by states index
	my $nCircuits = $_[6];            # total number of circuits found;
	my $longestCircuitRef = $_[7];    # the longest circuits found	 
	my $lenLongest = $_[8];           # the longest circuits length
	my $lengthHistogramRef = $_[9];   # histogram of circuit lengths
	my @vertexPopularity = @{$_[10]}; # adjacency table of occurrences of vertices in circuits of each length
	my @matrix = @{$_[11]};           # Transitions/States Matrix
	my @states = @{$_[12]};           # States 
	my @B = ();                       # integer array size n of lists
	my @Ck = @{$_[13]};               # Transition Matrix 
	# (Ck[i] : Transitions from state i.
	#  Ck[i][0] : Number of transitions
	#  Ck[i][1..j] : transitions from state i   
	my @ssStack = @{$_[14]};          # Current Stack result of siteswaps
	my $tr = $_[15];                  # Current transition
	my $resRef = $_[16];
	my $opts = uc($_[17]); 
	my $f = $_[18]; 
	my $histogram_results = "N";          # Get the States Path Results or no (default)
	my $longest_results = "Y";          # Get Computation Synthesis (default) or no
	&GetOptionsFromString($opts,    				    
			      "-L:s" => \$longest_results,
			      "-H:s" => \$histogram_results,
	    );
	
	my $b = 0;
	
	push(@statesStack, $v);
	if($tr ne "")
	{
	    push(@ssStack, $tr);	
	}
	$blocked[$v] = 1;
	for (my $wPos = 1; $wPos <= $Ak[$v][0]; $wPos++) 
	{  
	    &common::displayComputingPrompt();

            # for each w in list Ak[v]:	
	    my $w = $Ak[$v][$wPos];

	    if ($w < $start) 
	    {
		next;   # ignore relevant parts of Ak
	    }
	    &common::hideComputingPrompt();
	    if ($w == $start) { # we have a circuit,
		$tr = $Ck[$v][$wPos];
		push(@ssStack, $tr);

		# print out the stack to record the circuit
		&__stacksPrint(\@statesStack, \@matrix, \@states, \@ssStack, \@{$resRef}, $opts, $f); 
		
		#@{$lengthHistogramRef}[scalar @statesStack]++; # add this circuit 's length to the length histogram
		my $period=&getPeriod(join("",@statesStack),-1);
		@{$lengthHistogramRef}[$period]++; # add this circuit 's length to the length histogram
		$nCircuits++; # and increment count of circuits found
		if ($longestMode == 0)
		{
		    my $period=&getPeriod(join("",@statesStack),-1);
		    if ($period > $lenLongest) { # keep a copy of the longest circuits found
			$lenLongest = $period;
			@{$longestCircuitRef}[0] = 1;
			@{$longestCircuitRef}[1] = join("",@ssStack);
		    }
		    elsif($period == $lenLongest) { 
			$lenLongest = $period;
			@{$longestCircuitRef}[0]++;
			@{$longestCircuitRef}[@{$longestCircuitRef}[0]] = join("",@ssStack);
		    }
		}
		else
		{
		    my $l = join("",@ssStack);
		    my $period=&getPeriod($l,-1);
		    if ($period > $lenLongest) { # keep a copy of the longest Siteswap found
			$lenLongest = $period;
			@{$longestCircuitRef}[0] = 1;
			@{$longestCircuitRef}[1] = $l;
		    }
		    elsif($period == $lenLongest) { 
			$lenLongest = $period;
			@{$longestCircuitRef}[0]++;
			@{$longestCircuitRef}[@{$longestCircuitRef}[0]] = $l;
		    }
		}

                # increment [circuit-length][vertex] for all vertices in this circuit
		for (my $i = 0; $i < scalar @statesStack; $i ++) 
		{
		    $vertexPopularity[scalar @statesStack][$statesStack[$i]]++;
		}
		pop(@ssStack);
		$b = 1;
	    } elsif ($blocked[$w] == 0) {		
		$tr = $Ck[$v][$wPos];
		($nCircuits, $lenLongest, $b) = &__circuit($start, $w, \@Ak, \@B, \@statesStack, \@blocked, $nCircuits, $longestCircuitRef, $lenLongest, \@{$lengthHistogramRef}, \@vertexPopularity, \@matrix, \@states, \@Ck, \@ssStack, $tr, \@{$resRef}, $opts, $f);    
	    }
	}

	if ($b == 1) {
	    &__unblock ($v, \@B, \@blocked);
	} else {
	    for (my $wPos = 1; $wPos <= $Ak[$v][0]; $wPos++) { # for each w in list Ak[v]:
		&common::displayComputingPrompt();
		my $w = $Ak[$v][$wPos];
		if ($w < $start) 
		{
		    next; # ignore relevant parts of Ak
		}
		my @Btmp=$B[$w];
		if(!(grep {$_ == $v} @Btmp))
		{
		    $B[$w][0]++;
		    $B[$w][$B[$w][0]] = $v;
		}
	    }
	}
	$v = pop(@statesStack);
	my $h=pop(@ssStack);
	return ($nCircuits, $lenLongest, $b);
    }


    my @Ak = @{$_[0]};            # Graph to analyse : integer array size n of lists, ie the transitions from the states
    #  Ak[i][0] : Number of transitions from state index i
    #  Ak[i][1..j] : transitions index from state index i   
    my $nStates = $_[1];          # number of states
    my @matrix = @{$_[2]};        # Transitions/States Matrix
    my @states = @{$_[3]};        # States 
    my @Ck = @{$_[4]};            # Transition Matrix 
    # (Ck[i] : Transitions from state i.
    #  Ck[i][0] : Number of transitions
    #  Ck[i][1..j] : transitions from state i   
    my $opts = uc($_[5]); 
    my $f = $_[6]; 
    my $histogram_results = "N";          # Get the States Path Results or no (default)
    my $longest_results = "Y";          # Get Computation Synthesis (default) or no
    &GetOptionsFromString($opts,    				    
			  "-L:s" => \$longest_results,
			  "-H:s" => \$histogram_results,
	);
    
    my @res = ();

    my $start = 0;                # Start state index
    my @B = ();                   # integer array size n of lists
    my @blocked = ();             # logical array indexed by states index
    my @statesStack = ();         # Current Stack result of states
    my $tr = "";                  # Current transition 
    my @ssStack = ();             # Current Stack result of siteswaps

    my $nCircuits = 0;            # total number of circuits found;
    my @longestCircuit = ();      # the longest circuits found
    $longestCircuit[0] = 0;       # longestCircuit[0] : Number of longest circuits.
    # longestCircuit[1..j] : longest circuits 
    my $lenLongest = 0;           # the longest circuits length
    my @lengthHistogram = ();     # histogram of circuit lengths
    my @vertexPopularity = ();    # adjacency table of occurrences of vertices in circuits of each length
    
    my $b = 0;                    # 0 : no circuit found; 1 : at least 1 circuit found 
    
    # will use as [1]...[n] to histogram circuits by length
    # [0] for zero length circuits, which are impossible
    # initialise histogram bins to empty 
    for (my $len = 0; $len < $nStates+1; $len++) 
    {
        $lengthHistogram[$len] = 0;
    }

    # max elementary circuit length is exactly nStates 
    for (my $len = 0; $len <= $nStates; $len++) 
    {	
        for (my $j = 0; $j < $nStates; $j++) 
	{
            $vertexPopularity[$len][$j] = 0;
        }
    }

    for (my $i = 0; $i < $nStates; $i++) {
	$B[$i][0]=0;
        $blocked[$i] = 0;
    }

    while ($start < $nStates) 
    {
        if (uc($histogram_results) eq "Y") 
	{	    
	    if($f eq "" || $f eq "-2") 
	    {
		&common::hideComputingPrompt();
		print colored [$common::COLOR_RESULT], "=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG11." : $states[$start] === \n";
	    }	      
	    elsif ("JML:"=~substr($f,0,4)) 
	    {	
		my $f_in = substr($f,4).".jml";
		&common::hideComputingPrompt();		      		
		open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		print FILE_JML "<line display=\""."=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG11." : $states[$start] === "."\"/>\n";
		close(FILE_JML);
	    }  	
	    elsif ("SSHTML:"=~substr($f,0,7)) 
	    {		    
		my $f_in = substr($f,7).".html";		      		
		&common::hideComputingPrompt();
		open(FILE,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
		print FILE "=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG11." : $states[$start] === <BR/>\n";
		close(FILE);		
	    }
	    elsif($f ne "-1")
	    {
		&common::hideComputingPrompt();
		open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
		print FILE "=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG11." : $states[$start] === \n";
		close(FILE);
	    }       
	}

        for (my $i = 0; $i < $nStates; $i++) { # for all i in Vk
            $blocked[$i] = 0;
	    my @Btmp=$B[$i];
	    @Btmp = ();
	    $B[$i][0]=0;
        }
	
	($nCircuits, $lenLongest, $b) = &__circuit($start, $start, \@Ak, \@B, \@statesStack, \@blocked, $nCircuits, \@longestCircuit, $lenLongest, \@lengthHistogram, \@vertexPopularity, \@matrix, \@states, \@Ck, \@ssStack, $tr, \@res, $opts, $f );
        $start ++;	
    }
    
    if($f eq "" || $f eq "-2") 
    {
	&common::hideComputingPrompt();
	if (uc($longest_results) eq "Y") 
	{
	    print colored [$common::COLOR_RESULT], "\n================================================================\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG1.$nCircuits."\n\n";
	    if ($longestMode == 0)
	    {		
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{		    
		    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." [=> Hamiltonien] : \n";
		}
		else
		{
		    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." :\n";
		}	
	    }
	    else
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." ".&getPeriod($longestCircuit[1],-1)." [=> Hamiltonien] : \n";
		}
		else
		{
		    print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." ".&getPeriod($longestCircuit[1],-1)." :\n";		
		}
	    }

	    for (my $i=1; $i <= $longestCircuit[0]; $i++)
	    {
		print "   ".$longestCircuit[$i]."\n";
	    }
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	}
	
	if (uc($histogram_results) eq "Y") 
	{
	    print colored [$common::COLOR_RESULT], "\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG6." ===\n";
	    if ($longestMode == 0)
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG7."\n\n";
	    }
	    else
	    {
		print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_GENSSPRIME_MSG8."\n\n";
	    }

	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print "   $i : $lengthHistogram[$i]\n";
	    }
	    
	    print colored [$common::COLOR_RESULT], "\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG9." ===\n";
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print colored [$common::COLOR_RESULT], "\n   === ".$lang::MSG_SSWAP_GENSSPRIME_MSG10." : $i ===\n";
		for (my $j=0; $j < $nStates; $j++)
		{
		    print "   $states[$j] : $vertexPopularity[$i][$j]\n";
		}
	    }
	    print "\n";
	    print colored [$common::COLOR_RESULT], "================================================================\n";
	}
    }

    elsif ("JML:"=~substr($f,0,4)) 
    {
	&common::hideComputingPrompt();
	my $f_in = substr($f,4).".jml";		      		
	open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
	
	if (uc($longest_results) eq "Y") 
	{
	    print FILE_JML "<line display=\"\"/>\n";
	    print FILE_JML "<line display=\""."================================================================"."\"/>\n";
	    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG1.$nCircuits."\"/>\n";
	    print FILE_JML "<line display=\"\"/>\n";
	    if ($longestMode == 0)
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." [=> Hamiltonien] : "."\"/>\n";
		}
		else
		{
		    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." : "."\"/>\n";
		}	
	    }
	    else
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest"." [=> Hamiltonien] : "."\"/>\n";
		}
		else
		{
		    print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest : "."\"/>\n";		
		}
	    }
	    
	    for (my $i=1; $i <= $longestCircuit[0]; $i++)
	    {
		print FILE_JML "<line display=\""."   ".$longestCircuit[$i]."\"/>\n"
	    }
	    print FILE_JML "<line display=\""."================================================================"."\"/>\n";
	}

	if (uc($histogram_results) eq "Y") 
	{
	    print FILE_JML "<line display=\"\"/>\n";
	    print FILE_JML "<line display=\""."=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG6." ==="."\"/>\n";
	    if ($longestMode == 0)
	    {
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG7."\"/>\n";
		print FILE_JML "<line display=\"\"/>\n";
	    }
	    else
	    {
		print FILE_JML "<line display=\"".$lang::MSG_SSWAP_GENSSPRIME_MSG8."\"/>\n";
		print FILE_JML "<line display=\"\"/>\n";
	    }
	    
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE_JML "<line display=\""."   $i : $lengthHistogram[$i]"."\"/>\n";
	    }
	    
	    print FILE_JML "<line display=\"\"/>\n";
	    print FILE_JML "<line display=\""."=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG9." ==="."\"/>\n";
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE_JML "<line display=\"\"/>\n";
		print FILE_JML "<line display=\""."   === ".$lang::MSG_SSWAP_GENSSPRIME_MSG10." : $i ==="."\"/>\n";
		for (my $j=0; $j < $nStates; $j++)
		{
		    print FILE_JML "<line display=\""."   $states[$j] : $vertexPopularity[$i][$j]"."\"/>\n";
		}
	    }

	    print FILE_JML "<line display=\"\"/>\n";
	    print FILE_JML "<line display=\""."================================================================"."\"/>\n";
	}

	close(FILE_JML);
    }  	
    
    elsif ("SSHTML:"=~substr($f,0,7)) 
    {		    
	&common::hideComputingPrompt();
	my $f_in = substr($f,7).".html";	
	open(FILE,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;

	if (uc($longest_results) eq "Y") 
	{
	    print FILE "<BR/>\n================================================================<BR/>\n";
	    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG1.$nCircuits."<BR/><BR/>\n\n";
	    if ($longestMode == 0)
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." [=> Hamiltonien] : <BR/>\n";
		}
		else
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." :<BR/>\n";
		}	
	    }
	    else
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest"." [=> Hamiltonien] : <BR/>\n";
		}
		else
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest"." : <BR/>\n";		
		}
	    }
	    
	    for (my $i=1; $i <= $longestCircuit[0]; $i++)
	    {
		print FILE "   ".$longestCircuit[$i]."<BR/>\n";
	    }
	    print FILE "================================================================<BR/>\n";
	}

	if (uc($histogram_results) eq "Y") 
	{
	    print FILE "<BR/>\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG6." ===<BR/>\n";
	    if ($longestMode == 0)
	    {
		print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG7."<BR/><BR/>\n\n";
	    }
	    else
	    {
		print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG8."<BR/><BR/>\n\n";
	    }
	    
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE "   $i : $lengthHistogram[$i]<BR/>\n";
	    }
	    
	    print FILE "<BR/>\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG9." ===<BR/>\n";
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE "<BR/>\n   === ".$lang::MSG_SSWAP_GENSSPRIME_MSG10." : $i ===<BR/>\n";
		for (my $j=0; $j < $nStates; $j++)
		{
		    print FILE "   $states[$j] : $vertexPopularity[$i][$j]<BR/>\n";
		}
	    }
	    print FILE "<BR/>\n";
	    print FILE "================================================================<BR/>\n\n";
	}

	close(FILE);		    
    }
    
    elsif($f ne "-1")
    {
	&common::hideComputingPrompt();	   
	open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;

	if (uc($longest_results) eq "Y") 
	{
	    print FILE "\n================================================================\n";
	    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG1.$nCircuits."\n\n";
	    if ($longestMode == 0)
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." [=> Hamiltonien] : \n";
		}
		else
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG2." ($longestCircuit[0]) : $lenLongest ".$lang::MSG_SSWAP_GENSSPRIME_MSG3." :\n";
		}	
	    }
	    else
	    {
		if($lenLongest == $nStates || $lenLongest == $nStates*2)
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest"." [=> Hamiltonien] : \n";
		}
		else
		{
		    print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG4." ($longestCircuit[0]) : ".$lang::MSG_SSWAP_GENSSPRIME_MSG5." $lenLongest"." :\n"; 
		}
	    }
	    
	    for (my $i=1; $i <= $longestCircuit[0]; $i++)
	    {
		print FILE "   ".$longestCircuit[$i]."\n";
	    }
	    print FILE "================================================================\n";
	}

	if (uc($histogram_results) eq "Y") 
	{
	    print FILE "\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG6." ===\n";
	    if ($longestMode == 0)
	    {
		print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG7."\n\n";
	    }
	    else
	    {
		print FILE $lang::MSG_SSWAP_GENSSPRIME_MSG8."\n\n";
	    }
	    
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE "   $i : $lengthHistogram[$i]\n";
	    }
	    
	    print FILE "\n=== ".$lang::MSG_SSWAP_GENSSPRIME_MSG9." ===\n";
	    for (my $i=0; $i <= $nStates; $i++)
	    {
		print FILE "\n   === ".$lang::MSG_SSWAP_GENSSPRIME_MSG10." : $i ===\n";
		for (my $j=0; $j < $nStates; $j++)
		{
		    print FILE "   $states[$j] : $vertexPopularity[$i][$j]\n";
		}
	    }
	    print FILE "\n";
	    print FILE "================================================================\n";
	}

	close(FILE);
    }
    
    
    return \@res;
}


sub genSSPrime
{
    my $mod = $_[0];
    my $nb_objs = $_[1];
    my $height = hex($_[2]);
    my $mult = '';
    my $f = "";
    my $pwd = getcwd();   
    my $run_browser = -1;
    
    my @Ak = ();              # Graph to analyse : integer array size n of lists, ie the transitions from the states
    #  Ak[i][0] : Number of transitions from state index i
    #  Ak[i][1..j] : transitions index from state index i   
    my @Ck = ();              # Transition Matrix 
    # (Ck[i] : Transitions from state i.
    #  Ck[i][0] : Number of transitions
    #  Ck[i][1..j] : transitions from state i
    my $nStates = 0;    
    my $opts;
    
    my $title = '-- '.$lang::MSG_SSWAP_GENSSPRIME_MSG0.' --'; 
    my $color_check = "N";
    my $sym_check = "N";
    my $perm_check = "Y";
    my $remove_redundancy = 0;           # 0 : keep redundancy (default); 1 : prefer ground states; 2 : keep first in the list
    my $extra_info = "N";
    my $order_list = 1;                  # 0 : do not sort; 1 : numerical sort (default); 2 : sort by objects number ; 3 : sort by period
    my $ground_check = "N";              # Get only Ground States or no (default) 
    my $prime_check = "N";               # For sure this is the case, but keep for testing purpose
    my $reversible_check = "N";          # Get only Reversible Siteswap or no (default)
    my $scramblable_check = "N";         # Get only Scramblable Siteswap or no (default)
    my $palindrome_check = "N"; # Get only Palindrome Siteswap or no (default)
    my $magic_check = "N";      # Get only Magic Siteswap or no (default)
    my $squeeze_check = "N";    # Get only No Squeeze Siteswap or any (default)    
    my $histogram_results = "N";         # Get the States Path Results or no (default)
    my $longest_results = "Y";           # Get Computation Synthesis (default) or no

    # build the Matrix    
    my $matrix_tmp ='';
    my $states_tmp ='';

    if(uc($mod) eq "V" || uc($mod) eq "S")
    {
	$opts = uc($_[3]); 
	my $ret = &GetOptionsFromString($opts,    
					"-O:i" => \$order_list,
					"-R:i" => \$remove_redundancy,
					"-C:s" => \$color_check,
					"-S:s" => \$sym_check,
					"-P:s" => \$perm_check,
					"-T:s" => \$title,
					"-I:s" => \$extra_info,
					"-G:s" => \$ground_check,    	
					"-L:s" => \$longest_results,
					"-H:s" => \$histogram_results,
					"-U:s" => \$prime_check,       # For sure this is always the case, but keep for testing purpose
		       			"-D:s" => \$scramblable_check,
					"-N:s" => \$palindrome_check,
		       			"-B:s" => \$reversible_check,
					"-Z:s" => \$magic_check,
					"-Q:s" => \$squeeze_check,
	    );
	$f = $_[4];	

	# Get the States/Transitions Matrix
	if(scalar @_ > 5)
	{
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[5],$mod,$nb_objs,sprintf("%x",$height),-1,"?");
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[5]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,"-1");	    
	}
    }
    elsif(uc($mod) eq "M" || uc($mod) eq "MS" || uc($mod) eq "SM" || uc($mod) eq "MULTI")
    {
	$mult = $_[3];
	$opts = uc($_[4]); 	
	my $ret = &GetOptionsFromString($opts,    
					"-O:i" => \$order_list,
					"-R:i" => \$remove_redundancy,
					"-C:s" => \$color_check,
					"-S:s" => \$sym_check,
					"-P:s" => \$perm_check,
					"-T:s" => \$title,
					"-I:s" => \$extra_info,
					"-G:s" => \$ground_check,    	
					"-L:s" => \$longest_results,
					"-U:s" => \$prime_check,       # For sure this is always the case, but keep for testing purpose
					"-H:s" => \$histogram_results,
					"-D:s" => \$scramblable_check,
					"-N:s" => \$palindrome_check,
       		       			"-B:s" => \$reversible_check,
					"-Z:s" => \$magic_check,
					"-Q:s" => \$squeeze_check,
	    );
	$f = $_[5];

	# Get the States/Transitions Matrix
	if(scalar @_ > 6)
	{	    
	    # XLS File with States/Transitions Matrix is provided to speed up the computation
	    &__check_xls_matrix_file($_[6],$mod,$nb_objs,sprintf("%x",$height),$mult,-1);
	    ($matrix_tmp, $states_tmp) = &__getStates_from_xls($_[6]); 
	}
	else
	{	
	    ($matrix_tmp, $states_tmp) = &genStates($mod,$nb_objs,$height,$mult,"-1");	    
	}
    }
    
    my @matrix=@{$matrix_tmp};
    my @states=@{$states_tmp};   
    my @res = ();    
    
    $nStates = scalar @states;
    foreach my $el1 (@states) 
    {	
	foreach my $el2 (@states) 
	{
	    my $idx_el1 = &__get_idx_state(\@states,$el1);
	    my $idx_el2 = &__get_idx_state(\@states,$el2);	    
	    my $el = $matrix[$idx_el1][$idx_el2];
	    if($el ne "")
	    {
		if(index($el,';') != -1)
		{		    
		    my @st=();
		    @st=split(/;/,$el);
		    for(my $i = 0; $i < scalar @st; $i++)
		    {
			$Ak[$idx_el1][0]++;
			$Ak[$idx_el1][$Ak[$idx_el1][0]] = $idx_el2;
			$Ck[$idx_el1][0]++;
			$st[$i] =~ s/\s+//g;
			$Ck[$idx_el1][$Ck[$idx_el1][0]] = $st[$i];			
		    }
		}
		else
		{
		    $Ak[$idx_el1][0]++;
		    $Ak[$idx_el1][$Ak[$idx_el1][0]] = $idx_el2;
		    $Ck[$idx_el1][0]++;
		    $Ck[$idx_el1][$Ck[$idx_el1][0]] = $el;
		}
	    }
	}
    }

    if($f eq "" || $f eq "-2")
    {
	### Issue the results on stdout 
	print colored [$common::COLOR_RESULT], "$title\n\n";	
    }    
    elsif ("JML:"=~substr($f,0,4)) 
    {
	$run_browser=0;
	my $f_in = substr($f,4).".jml";    

	open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ; 
	print FILE_JML "<?xml version=\"1.0\"?>\n";
	print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	print FILE_JML "<patternlist>\n";
	print FILE_JML "<title>".$title."</title>\n";
	print FILE_JML "<line display=\"\"/>\n";
	close(FILE_JML);
    }  	
    elsif ("SSHTML:"=~substr($f,0,7)) 
    {		    
	### Code to issue an HTML file with extension .html with some information on the Siteswaps.";   
	$run_browser=1;
	my $f_in = substr($f,7).".html";	
	open(FILE,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "$title <BR/><BR/>\n";
	close(FILE);		
    }
    elsif($f ne "-1")
    {
	### Issue the results into a given file 
	open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "$title\n\n";
	close(FILE);
    }
    
    $opts = "-L=$longest_results -H=$histogram_results";
    @res=@{&__get_elementary_circuits(\@Ak, $nStates, \@matrix, \@states, \@Ck, $opts, $f)};

    #Do not consider options -L & -H anymore
    $opts = "-O=$order_list -R=$remove_redundancy -C=$color_check -S=$sym_check -P=$perm_check -B=$reversible_check -T=\"$title\" -I=$extra_info -G=$ground_check";

    if(uc($prime_check) eq "Y")
    {
	$opts = $opts." -U=$prime_check";
    }

    if ($f eq "") 
    {
	### results on stdout 
	print colored [$common::COLOR_RESULT], "\n=== Prime Siteswaps ===\n\n";
	@res = &printSSListWithoutHeaders(\@res,$opts);	    	    
    }    
    elsif ("JML:"=~substr($f,0,4)) 
    {
	### Code for the HTML file with extension .html for JugglingLab view
	my $f_in = substr($f,4).".jml";    
	open(FILE_JML,">> $conf::RESULTS/$f_in") || die ("$lang::MSG_GENERAL_ERR1 <$f_in> $lang::MSG_GENERAL_ERR1b") ; 
	print FILE_JML "<line display=\"\"/>\n";
	print FILE_JML "<line display=\""."=== Prime Siteswaps ==="."\"/>\n";
	print FILE_JML "<line display=\"\"/>\n";
	close(FILE_JML);
	@res = &printSSListWithoutHeaders(\@res,$opts,$f);
	
	#system("start /b cmd /c ${JUGGLING_LAB_PATH}/jlab.bat anim -jml $conf::RESULTS/".substr($f,7).".jml\n");
	print colored [$common::COLOR_RESULT], $lang::MSG_SSWAP_JML."$conf::RESULTS/".substr($f,7).".jml\n";     

    }  	
    elsif ("SSHTML:"=~substr($f,0,7)) 
    {		    
	### Code for the HTML file with extension .html with some information on the Siteswaps.";   
	@res = &printSSListInfoHTMLWithoutHeaders(\@res,$opts,$f);
    }
    elsif ($f ne "-1" && $f ne "-2")
    {
	### results into a given file 
	open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	print FILE "=== Prime Siteswaps ===\n\n";
	close(FILE);
	@res = &printSSListWithoutHeaders(\@res,$opts,$f);
    }    

    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	my $f_in = substr($f,7).".html";	
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f_in");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f_in &");
	}		
    }
    
    return \@res;
}


sub polyrythmFountain
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/polyrhythmic-fountain/polyrhythmic-fountain.html");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/polyrhythmic-fountain/polyrhythmic-fountain.html &");
    }
}



######################################################################
#
#                              TESTS
#
######################################################################


#################################################
#  Test function to generate States/Transitions diagrams in Excel
#################################################
sub __test_gen_all_states
{    
    if (uc($_[0]) eq "V") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {
		print "============== Matrix_V_-1_".sprintf("%x",$i)."==============\n";
		&writeStates_xls("V","-1", sprintf("%x",$i), "Matrix_V_any_".sprintf("%x",$i));		
	    }
	} else {
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Matrix_V_".$i."_".sprintf("%x",$j)."==============\n";
		    &writeStates_xls("V",$i, sprintf("%x",$j), "Matrix_V_".$i."_".sprintf("%x",$j));
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
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Matrix_S_".$i."_".sprintf("%x",$j)."==============\n";
		    &writeStates_xls("S",$i, sprintf("%x",$j), "Matrix_S_".$i."_".sprintf("%x",$j));	   
		}
	    }
	}
    } elsif (uc($_[0]) eq "M") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Matrix_M_any_".sprintf("%x",$i)."_".$m."==============\n";
		    &writeStates_xls("M",-1, sprintf("%x",$i), $m, "Matrix_M_any_".sprintf("%x",$i)."_".$m);	
		}
	    }
	} else {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Matrix_M_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			&writeStates_xls("M",$i, sprintf("%x",$j), $m, "Matrix_M_".$i."_".sprintf("%x",$j)."_".$m);			
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MS" || uc($_[0]) eq "SM") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Matrix_MS_any_".sprintf("%x",$i)."_".$m."==============\n";
		    &writeStates_xls("MS",-1, sprintf("%x",$i), $m, "Matrix_MS_any_".sprintf("%x",$i)."_".$m);			    
		}
	    }
	} else {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			&writeStates_xls("MS",$i, sprintf("%x",$j), $m, "Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m);			
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MULTI") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];
	
	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Matrix_MULTI_any_".sprintf("%x",$i)."_".$m."==============\n";
		    &writeStates_xls("MULTI",-1, sprintf("%x",$i), $m, "Matrix_MULTI_any_".sprintf("%x",$i)."_".$m);			    
		}
	    }
	} else {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			&writeStates_xls("MULTI",$i, sprintf("%x",$j), $m, "Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m);			
		    }
		}
	    }
	}
    }
}


#################################################
#  Test function to generate Reduced States/Transitions diagrams in Excel
#################################################
sub __test_gen_all_aggr_states
{    
    if (uc($_[0]) eq "V") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {
		print "============== Aggr_Matrix_V_-1_".sprintf("%x",$i)."==============\n";
		if(scalar @_ > 3)
		{
		    my $in = $_[3]."/Matrix_-_V_any_".sprintf("%x",$i).".xlsx";
		    if(-e $in)
		    {			    
			&genStatesAggr("V","-1", sprintf("%x",$i), "XLS:Aggr_Matrix_V_any_".sprintf("%x",$i),$in);		
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }
		}
		else
		{
		    &genStatesAggr("V","-1", sprintf("%x",$i), "XLS:Aggr_Matrix_V_any_".sprintf("%x",$i));		
		}
	    }
	} else {
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Aggr_Matrix_V_".$i."_".sprintf("%x",$j)."==============\n";
		    if(scalar @_ > 3)
		    {
			my $in = $_[3]."/Matrix_V_".$i."_".sprintf("%x",$j).".xlsx";
			if(-e $in)
			{			    
			    &genStatesAggr("V",$i, sprintf("%x",$j), "XLS:Aggr_Matrix_V_".$i."_".sprintf("%x",$j),$in);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    else
		    {
			&genStatesAggr("V",$i, sprintf("%x",$j), "XLS:Aggr_Matrix_V_".$i."_".sprintf("%x",$j));
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "S") {
	my $starti = $_[1];
	my $startj = hex($_[2]);

	if ($starti == -1) {
	    for (my $i=$startj; $i < 16; $i ++) {		
		print "============== Aggr_Matrix_S_any_".sprintf("%x",$i)."==============\n";
		if(scalar @_ > 3)
		{
		    my $in = $_[3]."/Matrix_S_any_".sprintf("%x",$i).".xlsx";
		    if(-e $in)
		    {			    
			&genStatesAggr("S",-1, sprintf("%x",$i), "XLS:Aggr_Matrix_S_any_".sprintf("%x",$i),$in);	   
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }
		}
		else
		{
		    &genStatesAggr("S",-1, sprintf("%x",$i), "XLS:Aggr_Matrix_S_any_".sprintf("%x",$i));	   
		}
	    }
	} else {
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {	    	    
		    print "============== Aggr_Matrix_S_".$i."_".sprintf("%x",$j)."==============\n";
		    if(scalar @_ > 3)
		    {
			my $in = $_[3]."/Matrix_S_".$i."_".sprintf("%x",$j).".xlsx";
			if(-e $in)
			{			    
			    &genStatesAggr("S",$i, sprintf("%x",$j), "XLS:Aggr_Matrix_S_".$i."_".sprintf("%x",$j),$in);	   
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    else
		    {
			&genStatesAggr("S",$i, sprintf("%x",$j), "XLS:Aggr_Matrix_S_".$i."_".sprintf("%x",$j));	   
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "M") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Aggr_Matrix_M_any_".sprintf("%x",$i)."_".$m."==============\n";
		    if(scalar @_ > 4)
		    {
			my $in = $_[4]."/Matrix_M_any_".sprintf("%x",$i)."_".$m.".xlsx";
			if(-e $in)
			{
			    &genStatesAggr("M",-1, sprintf("%x",$i), $m, "XLS:Aggr_Matrix_M_any_".sprintf("%x",$i)."_".$m,$in);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    else
		    {
			&genStatesAggr("M",-1, sprintf("%x",$i), $m, "XLS:Aggr_Matrix_M_any_".sprintf("%x",$i)."_".$m);	
		    }
		}
	    }
	} else {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Aggr_Matrix_M_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			if(scalar @_ > 4)
			{
			    my $in = $_[4]."/Matrix_M_".$i."_".sprintf("%x",$j)."_".$m.".xlsx";
			    if(-e $in)
			    {			    
				&genStatesAggr("M",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_M_".$i."_".sprintf("%x",$j)."_".$m,$in);   
			    }
			    else
			    {
				print "==> Generation Aborted : Corresponding Input File does not exist\n";
			    }
			}
			else
			{
			    &genStatesAggr("M",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_M_".$i."_".sprintf("%x",$j)."_".$m);			
			}
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MS" || uc($_[0]) eq "SM") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Aggr_Matrix_MS_any_".sprintf("%x",$i)."_".$m."==============\n";
		    if(scalar @_ > 4)
		    {
			my $in = $_[4]."/Matrix_MS_any_".sprintf("%x",$i)."_".$m.".xlsx";
			if(-e $in)
			{			    
			    &genStatesAggr("MS",-1, sprintf("%x",$i), $m, "XLS:Matrix_MS_any_".sprintf("%x",$i)."_".$m,$in);			    
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    else
		    {
			&genStatesAggr("MS",-1, sprintf("%x",$i), $m, "XLS:Matrix_MS_any_".sprintf("%x",$i)."_".$m);			    
		    }
		}
	    }
	} else {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Aggr_Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			if(scalar @_ > 4)
			{
			    my $in = $_[4]."/Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m.".xlsx";
			    if(-e $in)
			    {			    
				&genStatesAggr("MS",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m,$in);	 
			    }
			    else
			    {
				print "==> Generation Aborted : Corresponding Input File does not exist\n";
			    }
			}
			else
			{
			    &genStatesAggr("MS",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_MS_".$i."_".sprintf("%x",$j)."_".$m);	 
			}
		    }
		}
	    }
	}
    } elsif (uc($_[0]) eq "MULTI") {
	my $starti = $_[1];
	my $startj = hex($_[2]);
	my $startm = $_[3];

	if ($starti == -1) {
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$startj; $i < 16; $i ++) {		    
		    print "============== Aggr_Matrix_MULTI_any_".sprintf("%x",$i)."_".$m."==============\n";
		    if(scalar @_ > 4)
		    {
			my $in = $_[4]."/Matrix_MULTI_any_".sprintf("%x",$i)."_".$m.".xlsx";
			if(-e $in)
			{			    
			    &genStatesAggr("MULTI",-1, sprintf("%x",$i), $m, "XLS:Matrix_MULTI_any_".sprintf("%x",$i)."_".$m,$in);			    
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    else
		    {
			&genStatesAggr("MULTI",-1, sprintf("%x",$i), $m, "XLS:Matrix_MULTI_any_".sprintf("%x",$i)."_".$m);			    
		    }
		}
	    }
	} else {	   
	    for (my $m=$startm; $m < 16; $m ++) {
		for (my $i=$starti; $i < 16; $i ++) {
		    for (my $j=$startj; $j < 16; $j ++) {		
			print "============== Aggr_Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m."==============\n";
			if(scalar @_ > 4)
			{
			    my $in = $_[4]."/Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m.".xlsx";
			    if(-e $in)
			    {			    
				&genStatesAggr("MULTI",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m,$in);  
			    }
			    else
			    {
				print "==> Generation Aborted : Corresponding Input File does not exist\n";
			    }
			}
			else
			{
			    &genStatesAggr("MULTI",$i, sprintf("%x",$j), $m, "XLS:Aggr_Matrix_MULTI_".$i."_".sprintf("%x",$j)."_".$m);	      
			}
		    }
		}
	    }
	}
    }
}


#################################################
#  Test function to generate Primes Siteswaps
#################################################
sub __test_gen_all_ss_primes
{   
    my $mod = "SSHTML"; # SSHTML or JML, TEXT, TEXTSUM (a single file), STDOUT, nothing (Only Synthesis)
    my $inputin = "";
    my $input = "";
    my $type = $_[0];
    my $starti = $_[1];
    my $startj = hex($_[2]);
    my $startMult = "";
    my $opts = "";


    if($type eq "M" || $type eq "MS" || $type eq "SM" || $type eq "MULTI")
    {
	$startMult = $_[3];
	$opts=$_[4];
	if(scalar @_ > 5)
	{
	    $mod = uc($_[5]);
	}
	if(scalar @_ > 6)
	{	   
	    $inputin = uc($_[6])."/";	    
	}	
    }
    else
    {
	$opts = $_[3];
	if(scalar @_ > 4)
	{
	    $mod = uc($_[4]);
	}
	if(scalar @_ > 5)
	{	   
	    $inputin = uc($_[5])."/";	    
	}
    }

    if($type eq "M" || $type eq "MS" || $type eq "SM" || $type eq "MULTI")
    {
	for (my $k=$startMult; $k < 16; $k ++) {
	    for (my $i=$starti; $i < 16; $i ++) {
		for (my $j=$startj; $j < 16; $j ++) {
		    $input = "";
		    $input = $inputin."/Matrix_".$type."_${i}_".sprintf("%x",$j)."_${k}".".xlsx";
		    
		    if(uc($mod) eq "SSHTML")
		    {
			print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."==============\n";
			if($inputin eq "" || -e $input)
			{			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "SSHTML:ssPrime_".$type."_${i}_".sprintf("%x",$j)."_${k}",$input);		    
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    elsif(uc($mod) eq "JML")
		    {
			print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."==============\n";
			if($inputin eq "" || -e $input)
			{			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "JML:ssPrime_".$type."_${i}_".sprintf("%x",$j)."_${k}",$input);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}		    
		    }
		    elsif(uc($mod) eq "TEXT")
		    {
			print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."==============\n";
			if($inputin eq "" || -e $input)
			{			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "ssPrime_".$type."_${i}_".sprintf("%x",$j)."_${k}".".txt",$input);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
			
		    }
		    elsif(uc($mod) eq "TEXTSUM")
		    {
			open(FILE,">> $conf::RESULTS/ssPrime.txt") || die ("$lang::MSG_GENERAL_ERR1 <$conf::RESULTS/$input> $lang::MSG_GENERAL_ERR1b") ; 
			print FILE "\n\n\n=============================================================================================\n";
			print FILE "========================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."========================================\n";
			print FILE "=============================================================================================\n";
			close(FILE);
			
			print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."==============\n";
			
			if($inputin eq "" || -e $input)
			{			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "ssPrime.txt",$input);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}
		    }
		    elsif(uc($mod) eq "STDOUT")
		    {
			if($inputin eq "" || -e $input)
			{			    
			    print "\n\n==============================================================================\n";
			    print "=================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."================================\n";
			    print "==============================================================================\n";
			    
			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "", $input);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}		    
		    }
		    else
		    {
			if($inputin eq "" || -e $input)
			{			    
			    print "\n\n==============================================================================\n";
			    print "=================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."_${k}"."================================\n";
			    print "==============================================================================\n";
			    
			    
			    &genSSPrime($type,$i, sprintf("%x",$j), $k, $opts, "-2", $input);
			}
			else
			{
			    print "==> Generation Aborted : Corresponding Input File does not exist\n";
			}		    
		    }
		    &common::displayComputingPrompt();	   		
		}	    
	    }
	    &common::hideComputingPrompt();	   
	}
    }



    else
    {
	for (my $i=$starti; $i < 16; $i ++) {
	    for (my $j=$startj; $j < 16; $j ++) {
		$input = "";
		$input = $inputin."/Matrix_".$type."_${i}_".sprintf("%x",$j).".xlsx";
		
		if(uc($mod) eq "SSHTML")
		{
		    print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."==============\n";
		    if($inputin eq "" || -e $input)
		    {			    
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "SSHTML:ssPrime_".$type."_${i}_".sprintf("%x",$j),$input);		    
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }
		}
		elsif(uc($mod) eq "JML")
		{
		    print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."==============\n";
		    if($inputin eq "" || -e $input)
		    {			    
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "JML:ssPrime_".$type."_${i}_".sprintf("%x",$j),$input);
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }		    
		}
		elsif(uc($mod) eq "TEXT")
		{
		    print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."==============\n";
		    if($inputin eq "" || -e $input)
		    {			    
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "ssPrime_".$type."_${i}_".sprintf("%x",$j).".txt",$input);
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }
		    
		}
		elsif(uc($mod) eq "TEXTSUM")
		{
		    open(FILE,">> $conf::RESULTS/ssPrime.txt") || die ("$lang::MSG_GENERAL_ERR1 <$conf::RESULTS/$input> $lang::MSG_GENERAL_ERR1b") ; 
		    print FILE "\n\n\n=============================================================================================\n";
		    print FILE "========================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."========================================\n";
		    print FILE "=============================================================================================\n";
		    close(FILE);
		    
		    print "==============ssPrime_".$type."_".$i."_".sprintf("%x",$j)."==============\n";
		    
		    if($inputin eq "" || -e $input)
		    {			    
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "ssPrime.txt",$input);
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }
		}
		elsif(uc($mod) eq "STDOUT")
		{
		    if($inputin eq "" || -e $input)
		    {			    
			print "\n\n==============================================================================\n";
			print "=================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."================================\n";
			print "==============================================================================\n";
			
			
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "", $input);
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }		    
		}
		else
		{
		    if($inputin eq "" || -e $input)
		    {			    
			print "\n\n==============================================================================\n";
			print "=================================ssPrime_".$type."_".$i."_".sprintf("%x",$j)."================================\n";
			print "==============================================================================\n";
			
			
			&genSSPrime($type,$i, sprintf("%x",$j), $opts, "-2", $input);
		    }
		    else
		    {
			print "==> Generation Aborted : Corresponding Input File does not exist\n";
		    }		    
		}
		&common::displayComputingPrompt();	   		
	    }	    
	}
	&common::hideComputingPrompt();	   
    }
}


######################################################################
#  Test functions to generate Vanilla Siteswaps from Probert's Diagram
######################################################################
sub __test_gen_all_ss_probert
{
    my $start_period = 0;
    my $end_period = 15;
    my $start_number = 0;
    my $end_number = $MAX_NBOBJ;
    my $state = "SSHTML";
    my $start_f ="";
    my $end_f =".txt";
    
    if (scalar @_ == 2) {
	$start_period = $_[1];
	$start_number = $_[0];
    }

    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    for (my $i=$start_number; $i<=$end_number;$i++) {
	for (my $j=$start_period;$j<=$end_period;$j++) {
	    print "============== Gen : Period=".$j."; Objects=".$i." ==============\n";
	    &genSSProbert($i,"-1",$j,'-t',$start_f."SSProbert_".$i."_p".$j.$end_f);
	}
    }
}


#################################################
#  Test functions to generate Vanilla Siteswaps from Probert's Diagram
#################################################
sub __test_gen_all_ss_reduced_probert
{
    my $start_period = 0;
    my $end_period = 15;
    my $start_number = 1;
    my $end_number = $MAX_NBOBJ;
    my $state = "JML";
    my $start_f ="";
    my $end_f =".txt";
    
    if (scalar @_ == 2) {
	$start_period = $_[1];
	$start_number = $_[0];
    }

    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    for (my $i=$start_number; $i<=$end_number;$i++) {
	for (my $j=$start_period;$j<=$end_period;$j++) {
	    print "============== Gen : Period=".$j."; Objects=".$i." ==============\n";
	    &genSSProbert($i,"-1",$j,'-r 1',$start_f."SSProbert_reduced_".$i."_p".$j.$end_f);
	}
    }
}


######################################################################
#  Test functions to generate Magic Siteswaps 
######################################################################
sub __test_gen_ss_magic
{    
    
    my $start = 0;
    my $start_period = $start;
    if (scalar @_ > 1) {
	$start = $_[1];
    }
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }


    my $end_period = 15;   
    my $nbmax_mult = 8;

    my $mod = $_[0];
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";
	    if($start==0)
	    {
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,'-i=y -o=3',$start_f."MagicSS-V_all_".$i.$end_f);
		print "== ALL REDUCED ==  "."\n";
		&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-V_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=3',$start_f."MagicSS-V_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-V_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,'-i=y -o=3',$start_f."MagicSS-V_odd_".$i.$end_f);
	        print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-V_odd_reduced_".$i.$end_f);
	    }
	    else
	    {	
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-V-${start}_all_".$i.$end_f);
		print "== ALL REDUCED ==  "."\n";
		&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-V-${start}_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-V-${start}_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-V-${start}_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-V-${start}_odd_".$i.$end_f);
	        print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-V-${start}_odd_reduced_".$i.$end_f);
	    }	
	}   
    } elsif ($mod eq "M") {	
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";

	    if($start==0)
	    {
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-M_all_".$i.$end_f);
		print "== ALL REDUCED == \n ";
		&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-M_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-M_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-M_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-M_odd_".$i.$end_f);
		print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-M_odd_reduced_".$i.$end_f);
	    }
	    else
	    {
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-M-${start}_all_".$i.$end_f);
		print "== ALL REDUCED == \n ";
		&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-M-${start}_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-M-${start}_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-M-${start}_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-M-${start}_odd_".$i.$end_f);
		print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-M-${start}_odd_reduced_".$i.$end_f);
	    }
	}   
    } elsif ($mod eq "S") {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";

	    if($start==0)
	    {
		#print "== ALL == "."\n";
		#&genSSMagic($mod,"all",$start,$i,'-i=y -o=3',$start_f."MagicSS-S_all_".$i.$end_f);
		#print "== ALL REDUCED ==  "."\n";
		#&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-S_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=3',$start_f."MagicSS-S_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-S_even_reduced_".$i.$end_f);
		#print "== ODD == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,'-i=y -o=3',$start_f."MagicSS-S_odd_".$i.$end_f);
		#print "== ODD REDUCED == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSS-S_odd_reduced_".$i.$end_f);
	    }
	    else
	    {
		#print "== ALL == "."\n";
		#&genSSMagic($mod,"all",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-S-${start}_all_".$i.$end_f);
		#print "== ALL REDUCED ==  "."\n";
		#&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-S-${start}_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-S-${start}_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-S-${start}_even_reduced_".$i.$end_f);
		#print "== ODD == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,'-i=y -o=3',$start_f."MagicSSPartial-S-${start}_odd_".$i.$end_f);
		#print "== ODD REDUCED == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=3',$start_f."MagicSSPartial-S-${start}_odd_reduced_".$i.$end_f);
	    }

	}   
    } elsif ($mod eq "MS" || $mod eq "SM") {
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";

	    if($start==0)
	    {
		#print "== ALL == "."\n";
		#&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-MS_all_".$i.$end_f);
		#print "== ALL REDUCED ==  "."\n";
		#&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MS_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-MS_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MS_even_reduced_".$i.$end_f);
		#print "== ODD == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSS-MS_odd_".$i.$end_f);
		#print "== ODD REDUCED == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MS_odd_reduced_".$i.$end_f);
	    }
	    else
	    {
		#print "== ALL == "."\n";
		#&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-MS-${start}_all_".$i.$end_f);
		#print "== ALL REDUCED ==  "."\n";
		#&genSSMagic($mod,"all",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MS-${start}_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-MS-${start}_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MS-${start}_even_reduced_".$i.$end_f);
		#print "== ODD == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-i=y -o=2',$start_f."MagicSSPartial-MS-${start}_odd_".$i.$end_f);
		#print "== ODD REDUCED == "."\n";
		#&genSSMagic($mod,"Impair",$start,$i,$nbmax_mult,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MS-${start}_odd_reduced_".$i.$end_f);
	    }
	}   
    } elsif ($mod eq "MULTI") {	
	for (my $i=$start_period;$i<$end_period;$i++) {
	    print "============== Gen : Period=".$i." ==============\n";

	    if($start==0)
	    {
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,'-i=y -o=2',$start_f."MagicSS-MULTI_all_".$i.$end_f);
		print "== ALL REDUCED == \n ";
		&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MULTI_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=2',$start_f."MagicSS-MULTI_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MULTI_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,'-i=y -o=2',$start_f."MagicSS-MULTI_odd_".$i.$end_f);
		print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSS-MULTI_odd_reduced_".$i.$end_f);
	    }
	    else
	    {
		print "== ALL == "."\n";
		##	        &genSSMagic($mod,"all",$start,$i,'-i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_all_".$i.$end_f);
		print "== ALL REDUCED == \n ";
		&genSSMagic($mod,"all",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_all_reduced_".$i.$end_f);
		print "== EVEN == "."\n";
		##	        &genSSMagic($mod,"Pair",$start,$i,'-i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_even_".$i.$end_f);
		print "== EVEN REDUCED ==  "."\n";
		&genSSMagic($mod,"Pair",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_even_reduced_".$i.$end_f);
		print "== ODD == "."\n";
		##	        &genSSMagic($mod,"Impair",$start,$i,'-i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_odd_".$i.$end_f);
		print "== ODD REDUCED == "."\n";
		&genSSMagic($mod,"Impair",$start,$i,'-r 1 -p=y -i=y -o=2',$start_f."MagicSSPartial-MULTI-${start}_odd_reduced_".$i.$end_f);
	    }
	}   
    }    
}


######################################################################
#  Test functions to generate Magic Siteswaps Using JugglingLab 
######################################################################
sub __test_gen_ss_magic_JL
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;    
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";		
		&genSS($nbobj,$height,$period,'-O -se -f',$start_f."MagicSSFromJL-V_".$nbobj.'_'.$period.$end_f,'-r 0 -z=y -i=y');		
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -f -s',$start_f."MagicSSFromJL-S_".$nbobj.'_'.$period.$end_f,'-r 0 -z=y -i=y');		
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -m '.$mult,$start_f."MagicSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -z=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -mt -m '.$mult,$start_f."MagicSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -z=y -i=y');
		}
	    }	
	}  
    }

    elsif ($mod eq "MS" || $mod eq "SM") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -s -mf -m '.$mult,$start_f."MagicSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -z=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -s -mf -mt -m '.$mult,$start_f."MagicSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -z=y -i=y');
		}
	    }	
	}  
    }
}


#################################################
#  Test function to generate Scramblable Vanilla Siteswaps
#################################################
sub __test_gen_ss_scramblablePolster
{    
    my $start = 0;
    if (scalar @_ > 0) {
	$start = $_[0];
    }
    my $start_period = $start;
    my $end_period = 15;
    my $mod = "V";
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    my $a = 500;
    my $c = 500;

    if ($mod eq "V") {
	for (my $i=$start_period;$i<=$end_period;$i++) 
	{
	    print "============== Gen : Period=".$i." ==============\n";
	    &genScramblablePolster($i,$a,$c,"-o=2 -i=y",$start_f."ScramblableSS-V_".$i.$end_f);
	}
    }
}

######################################################################
#  Test functions to generate Reversible Vanilla Siteswaps  
######################################################################
sub __test_gen_ss_reversible_perm
{    
    
    my $start_nbobj = 1;
    if (scalar @_ > 0) {
	$start_nbobj = $_[0];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 1) {
	$start_period = $_[1];
    }
    my $end_period = 15;    
    my $height='f';
    my $mod = "V";
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		#&genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -b=y',$start_f."ReversibleSS-V_".$nbobj.'_'.$period.$end_f);
		&genSSPerm($nbobj,$period,'-r 1 -b=y',$start_f."ReversibleSSFromPerm-V_".$nbobj.'_'.$period.$end_f);
	    }	
	}  
    } 	
}


######################################################################
#  Test functions to generate Reversible Siteswaps Using States 
######################################################################
sub __test_gen_ss_reversible_states
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;    
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";		
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_V_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-V_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-V_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_S_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-S_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-S_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_M_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-M_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-M_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "MS" || $mod eq "SM") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_MS_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-MS_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -b=y -p=y -i=y',$start_f."ReversibleSSFromStates-MS_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }
}


######################################################################
#  Test functions to generate Reversible Siteswaps Using JugglingLab 
######################################################################
sub __test_gen_ss_reversible_JL
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;    
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";		
		&genSS($nbobj,$height,$period,'-O -se -f',$start_f."ReversibleSSFromJL-V_".$nbobj.'_'.$period.$end_f,'-r 0 -b=y -i=y');		
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -f -s',$start_f."ReversibleSSFromJL-S_".$nbobj.'_'.$period.$end_f,'-r 0 -b=y -i=y');		
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -m '.$mult,$start_f."ReversibleSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -b=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -mt -m '.$mult,$start_f."ReversibleSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -b=y -i=y');
		}
	    }	
	}  
    }

    elsif ($mod eq "MS" || $mod eq "SM") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -s -mf -m '.$mult,$start_f."ReversibleSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -b=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -s -mf -mt -m '.$mult,$start_f."ReversibleSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -b=y -i=y');
		}
	    }	
	}  
    }
}


######################################################################
#  Test functions to generate Palindromes Siteswaps Using States 
######################################################################
sub __test_gen_ss_palindrome_states
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;    
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_V_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-V_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-V_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_S_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-S_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-S_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_M_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-M_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-M_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "MS" || $mod eq "SM") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_MS_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-MS_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -n=y -p=y -i=y',$start_f."PalindromeSSFromStates-MS_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }
}


######################################################################
#  Test functions to generate Palindromes Siteswaps Using JugglingLab 
######################################################################
sub __test_gen_ss_palindrome_JL
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;    
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -rot -f',$start_f."PalindromeSSFromJL-V_".$nbobj.'_'.$period.$end_f,'-r 1 -n=y -i=y -p=y');		
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -rot -f -s',$start_f."PalindromeSSFromJL-S_".$nbobj.'_'.$period.$end_f,'-r 1 -n=y -i=y -p=y');  
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -rot -f -mf -m '.$mult,$start_f."PalindromeSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 1 -n=y -i=y -p=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -rot -f -mf -mt -m '.$mult,$start_f."PalindromeSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 1 -n=y -i=y -p=y');
		}
	    }	
	}  
    }

    elsif ($mod eq "MS" || $mod eq "SM") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj < 2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -rot -f -s -mf -m '.$mult,$start_f."PalindromeSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 1 -n=y -i=y -p=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -rot -f -s -mf -mt -m '.$mult,$start_f."PalindromeSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 1 -n=y -i=y -p=y');
		}

	    }	
	}  
    }
}



######################################################################
#  Test functions to generate Scramblable Siteswaps Using States 
######################################################################
sub __test_gen_ss_scramblable_states
{    

    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 15;   
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_V_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-V_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-V_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		if (scalar @_ > 3)
		{
		    my $path=$_[3];
		    my $file = $path.'/'.'Matrix_S_'.$nbobj.'_'.$height.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-S_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-S_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_M_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-M_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-M_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

    elsif ($mod eq "SM" || $mod eq "MS") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if (scalar @_ > 4)
		{
		    my $path=$_[4];
		    my $file = $path.'/'.'Matrix_SM_'.$nbobj.'_'.$height.'_'.$mult.'.xlsx';
		    print "Use Matrix <$file> for generation\n";
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-SM_".$nbobj.'_'.$period.$end_f,$file);
		}
		else
		{
		    &genSSFromStates($mod,$nbobj,$height,$period,$mult,'-r 1 -d=y -p=y -i=y',$start_f."ScramblableSSFromStates-SM_".$nbobj.'_'.$period.$end_f);
		}
	    }	
	}  
    }

}


######################################################################
#  Test functions to generate Scramblable Siteswaps Using JugglingLab 
######################################################################
sub __test_gen_ss_scramblable_JL
{    
    my $mod = $_[0];

    my $start_nbobj = 1;
    if (scalar @_ > 1) {
	$start_nbobj = $_[1];
    }
    my $end_nbobj = $MAX_NBOBJ;
    
    my $start_period = 0;
    if (scalar @_ > 2) {
	$start_period = $_[2];
    }
    my $end_period = 8;   
    my $height='f';
    #my $state = "JML";    #"JML";
    my $state= "";
    my $start_f ="";
    my $end_f =".txt";
    my $mult = "";
    
    if ($state eq "JML") {
	$start_f="JML:";
	$end_f="";
    }
    if ($state eq "SSHTML") {
	$start_f="SSHTML:";
	$end_f="";
    }

    if ($mod eq "V") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -f',$start_f."ScramblableSSFromJL-V_".$nbobj.'_'.$period.$end_f,'-r 0 -d=y -i=y');			    }	
	}  
    }

    if ($mod eq "S") {
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period." ==============\n";
		&genSS($nbobj,$height,$period,'-O -se -s -f',$start_f."ScramblableSSFromJL-S_".$nbobj.'_'.$period.$end_f,'-r 0 -d=y -i=y');	
	    }	
	}  
    }

    elsif ($mod eq "M") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj <2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -m '.$mult,$start_f."ScramblableSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -d=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -f -mf -mt -m '.$mult,$start_f."ScramblableSSFromJL-M_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -d=y -i=y');
		}
	    }	
	}  
    }

    elsif ($mod eq "SM" || $mod eq "MS") {
	$mult = $_[3];
	for (my $nbobj=$start_nbobj;$nbobj<=$end_nbobj;$nbobj++) {
	    for (my $period=$start_period;$period<=$end_period;$period++) {
		if($period %2 !=0)
		{
		    next;
		}
		print "============== Gen : NbObjects=".$nbobj.", Period=".$period.", Multiplex Max Number=".$mult." ==============\n";
		if($nbobj <2)
		{
		    &genSS($nbobj,$height,$period,'-O -se -s -f -mf -m '.$mult,$start_f."ScramblableSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -d=y -i=y');
		}
		else
		{
		    &genSS($nbobj,$height,$period,'-O -se -s -f -mf -mt -m '.$mult,$start_f."ScramblableSSFromJL-MS_".$nbobj.'_'.$period.'_'.$mult.$end_f,'-r 0 -d=y -i=y');
		}
	    }	
	}  
    }
}



######################################################################
#  Tests on jonglage.net List and HTML Results Generation 
######################################################################


sub __test_jonglage_net_list
{
    my @ss_list = @common::SS_list_jonglage_net;
    push (@ss_list, @common::SS_experimental);  
    my $f="test_jonglage_net_list_sswap";    

    print scalar @ss_list;

    my $title='Notation Siteswap : Exemples';
    my $opts="-o 2 -c y -t \"$title\"";
    if(scalar @_ == 1 && $_[0] == -2)
    {
	$opts="$opts -i y ";
    }
    
    &printSSList(\@ss_list,$opts,"SSHTML:$f");
}


sub __fix
{
    for(my $i=0; $i<=15; $i++) {
	for(my $j=0; $j<=15; $j++)
	{
	    my $f = "ReversibleSSFromJL-S_".$i."_".$j."-reduced.txt";
	    my $f_in="D:/PALINDROME/reversible/S/".$f;
	    eval {
		print "===== ".$f_in." =====\n";
		&printSSList('','-i y',$f,$f_in);
	    }
	}
    }
}

#################################################
#  Tests functions to generate Sliding on jonglage.net List and HTML Results Generation
#################################################
sub __test_jonglage_net_list_slide
{
    
    my $f="test_jonglage_net_list_sswap_sliding.html";
    my $pics="pics_png.png";
    my $pics_true="pics_green_tick.png";
    my $pics_false="pics_red_negative.png";

    my $cpt = 1;
    &common::gen_HTML_head1($f,"SSWAP Notation : Sliding Exemples : Async&lt;=&gt;Sync");
    open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;	
    print HTML "\n";
    print HTML "<BODY>\n";
    print HTML "<p>&nbsp;</p><p>&nbsp;</p><h1>Siteswap Notation : Sliding Exemples Async &lt;=&gt; Sync</h1><p>&nbsp;</p>\n";
    print HTML "<p>Vous trouverez ci-dessous de nombreux exemples de Sliding Synchrones &lt;=&gt; Asynchrones. <br/>Les Siteswaps obtenus par décalage sont indiqués lorsque ceux-ci sont possibles:\n";    
    print HTML "<ul>\n";
    print HTML "<li>R+1 : Décalage de la main droite d'1 Beat dans le futur;</li><li>R+1 : Décalage de la main droite d'1 Beat dans le passé;</li><li>L+1 : Décalage de la main gauche d'1 Beat dans le futur;</li><li>L-1 : Décalage de la main gauche d'1 Beat dans le passé.</li></ul></p>\n";

    print HTML "\n\n\n";
    print HTML "<p>&nbsp;</p>"."\n";
    print HTML "<p><table border=\"0\" >"."\n";
    print HTML "<tr><td COLSPAN=2></td>"."\n";	    	    
    print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";	    	    
    print HTML "<td class=table_header>"."R+1"."</td>"."\n";	    	    
    print HTML "<td class=table_header>"."L+1"."</td>"."\n";	    	    
    print HTML "<td class=table_header>"."R-1"."</td>"."\n";	    	    
    print HTML "<td class=table_header>"."L-1"."</td>"."\n";
    print HTML "<td class=table_header>"."R+1 &lt;=&gt; L-1"."</td>"."\n";
    print HTML "<td class=table_header>"."R-1 &lt;=&gt; L+1"."</td>"."\n";    
    print HTML "</tr>"."\n";
    
    copy("./data/pics/".$pics,$conf::RESULTS."/".$pics);
    copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);
    copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);
    
    
    my @ss_list = @common::SS_list_jonglage_net;
    push (@ss_list, @common::SS_experimental);
    
    @ss_list=sort(@ss_list);

    for(my $nb=0; $nb < scalar @ss_list; $nb++)
    {
	my $ss = $ss_list[$nb];
	my $mod = &getSSType($ss,-1);
	if ($mod ne 'V' && $mod ne 'M' && $mod ne 'S' && $mod ne 'MS' && $mod ne 'SM' && $mod ne 'MULTI')
	{
	    print "Siteswap not Considered : ".$ss."\n";	    
	    next;
	}
	
	my $nss = lc($ss);

	$nss =~ s/\s+//g;	
	$nss =~ s/\*/+/g;

	print HTML "<tr>"."\n";	    	    
	print HTML "<td class=table_header>$cpt</td>"."\n";
	print HTML "<td class=table_header><strong>$ss</strong></td>"."\n";
	
	print "\n\n\n";
	print colored [$common::COLOR_RESULT], "==== Diagram : ".$ss."\n";
	&draw($ss, $nss.".png","-E=E");	    		   
	$cpt++;
	print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	my($res1,$res2,$res3,$res4)=&slideSwitchSync($ss, -1);
	if ($res1 != -1)
	{
	    print HTML "<td class=table_content>".$res1."</td>"."\n";
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}
	if ($res2 != -1)
	{
	    print HTML "<td class=table_content>$res2</td>"."\n";
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}

	if ($res3 != -1)	    
	{
	    print HTML "<td class=table_content>$res3</td>"."\n";
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}

	if ($res4 != -1)
	{
	    print HTML "<td class=table_content>$res4</td>"."\n";
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}

	if($res1 != -1 && $res4 != -1 && &isEquivalent($res1,$res4,'',-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	elsif($res1 == -1 && $res4 == -1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"30\"/></a></td>"."\n"; 
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}
	if($res2 != -1 && $res3 != -1 && &isEquivalent($res2,$res3,'',-1)==1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	}
	elsif($res3 == -1 && $res2 == -1)
	{
	    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"30\"/></a></td>"."\n"; 
	}
	else
	{
	    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"30\"/></a></td>"."\n"; 
	}

	print HTML "</tr>"."\n";	    	    
	
    }

    print HTML "</table></p>"."\n";
    print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module SSWAP $SSWAP_VERSION --</p><p>&nbsp;</p>\n";
    print HTML "</BODY>\n";
    close HTML;

    print colored [$common::COLOR_RESULT], "\n\n====> ".($cpt-1)." Siteswaps Generated\n ";

}


#################################################
#  Tests functions to generate Polyrythm from 3:2 Lists for 4 Objects of Sylvain Garnavault and HTML Results Generation
#################################################
sub __test_polyrythm_list_3_2
{    
    my $f="test_polyrythm_list_3-2.html";
    my $cpt = 1;
    my $pics="pics_png.png";
    my $pics_true="pics_green_tick.png";
    my $pics_false="pics_red_negative.png";
    copy("./data/pics/".$pics,$conf::RESULTS."/".$pics);
    copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);
    copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);

    &common::gen_HTML_head1($f,"Polyrythms Lists 3:2 for 4 Objects - Exemples");
    open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;	
    print HTML "\n";
    print HTML "<BODY>\n";
    print HTML "<p>&nbsp;</p><p>&nbsp;</p><h1>Polyrythms Lists 3:2 for 4 Objects - Exemples</h1><p>&nbsp;</p>\n";
    print HTML "<p>Here are a few Lists for 3:2 Polyrythms with 4 objects, generated by Sylvain Garnavault in MHN Notation and corresponding MultiSync Notation.<br/>\n";
    print HTML "Ladder Diagrams and JML files for JugglingLab have been generated by a few scripts I developed for my own needs. You just have to load JML in JugglingLab to view Patterns Lists.</p>";
    
    print HTML "\n\n\n";    
    
    for(my $l=7;$l <= 7; $l++)
    {
	my $flist="test_polyrythm_list_3-2_list".$l.".txt";
	my $fjml="test_polyrythm_list_3-2_list".$l;
	open(FH, '>', "$conf::TMPDIR/$flist") or die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR/$flist> $lang::MSG_GENERAL_ERR1b") ;

	print HTML "<p>&nbsp;</p><p>&nbsp;</p><h2>== List $l ==</h2><p>&nbsp;</p>\n";
	print HTML "<p><table border=\"0\" >"."\n";
	print HTML "<tr><td COLSPAN=1></td>"."\n";
	print HTML "<td class=table_header>"."MHN"."</td>"."\n";
	print HTML "<td class=table_header>"."MultiSync Siteswap"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagrams"."</td>"."\n";
	print HTML "<td class=table_header>"."Valid"."</td>"."\n";
	print HTML "</tr>"."\n";

	my $list = 'common::MHN_list_3_2_list'.$l;
	my @MHN_list = eval '@'.$list;
	@MHN_list=sort(@MHN_list);
	my $prev_mhn = '';

	for(my $nb=0; $nb < scalar @MHN_list; $nb++)
	{
	    my $mhn = $MHN_list[$nb];
	    if($mhn eq $prev_mhn)
	    {		
		next;
	    }
	    $prev_mhn = $mhn;
	    my $ss = '';
	    my $nss = '';
	    $mhn = lc($mhn);		
	    $mhn =~ s/\s+//g;
	    my $nmhn = $mhn;
	    $nmhn =~ s/-/0/g;
	    
	    print HTML "<tr>"."\n";	    	    
	    print HTML "<td class=table_header>$cpt</td>"."\n";

	    for(my $i=0; $i < length($nmhn); $i++)
	    {
		if(substr($nmhn,$i,1) eq ')')
		{
		    $ss .= ')!';
		}
		else
		{
		    $ss .= substr($nmhn,$i,1);
		}
	    }

	    $nss = $ss;
	    $nss =~ s/\*/+/g;
	    
	    print "\n\n\n";
	    print colored [$common::COLOR_RESULT], "==== Diagram : ".$ss."\n";
	    &draw($ss, $nss.".png","-M 0 -E E");
	    print FH $ss."\n";	
	    print HTML "<td class=table_content>".$mhn."</td>"."\n";
	    print HTML "<td class=table_content>".$ss."</td>"."\n";
	    print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	    if(&isValid($ss,-1) > 0)
	    {
		print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></a></td>"."\n"; 
	    }
	    else
	    {
		print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></a></td>"."\n"; 
	    }
	    
	    print HTML "</tr>"."\n";
	    $cpt++;
	}
	
	print HTML "</table></p>"."\n";
	close(FH); 
	&printSSList('',"-t \"Polyrythms 3:2 with 4 Objects - List $l\"","JML:".$fjml,"$conf::TMPDIR/$flist");
	print HTML "<p>&nbsp;</p><p>&nbsp;&nbsp;<strong>JML File :</strong> <a href=\"".$fjml.".jml\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjml.".jml\" width=\"25\"/></a></p>"."\n";
	if ($SSWAP_DEBUG <= 0) {
	    unlink "$conf::TMPDIR\\$flist";
	}

    }
    
    print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module SSWAP $SSWAP_VERSION (Frederic Roudaut) --</p><p>&nbsp;</p>\n";
    print HTML "</BODY>\n";
    close HTML;

    print colored [$common::COLOR_RESULT], "\n\n====> ".($cpt-1)." Siteswaps Generated\n ";

}


#################################################
#  Test function to generate extended info from Polyrythms Lists
#################################################
sub __test_polyrythm_info_gen
{
    my $dir = $_[0];
    
    for(my $i=1; $i <= 5; $i++) {
	for(my $j=1; $j <= 5; $j++) {
	    for(my $k=1; $k <= 5; $k++) {

		my $filenameIn = $dir.'/polyrythms-'.$i.'objects_'.$j.'!'.$k.'.txt';
		if(-e $filenameIn)
		{
		    my $filenameOut = $conf::RESULTS.'/polyrythms-'.$i.'objects_'.$j.'!'.$k.'.txt';
		
		    open(my $fhin, '<:encoding(UTF-8)', $filenameIn)
			or die "Could not open file $filenameIn $!";
		    print "==== polyrythms-".$i.'objects_'.$j.'!'.$k.".txt ===="."\n";
		    
		    open(my $fhout, '>:encoding(UTF-8)', $filenameOut)
			or die "Could not open file $filenameOut $!";

		    while (my $ss = <$fhin>) {
			chomp $ss;
			$ss =~ s/\s+//g;	
			
			if($ss eq '')
			{
			    next;
			}
			
			my $ss_orig = &LADDER::toMultiSync($ss,3,-1);
			$ss = &simplify($ss,-1);
			my $ss_lowheight = &simplify(&LADDER::toMultiSync(&lowerHeightOnTempo($ss,'',-1),3,-1),-1);
			my $ss_lowheightJL = &simplify(&LADDER::toMultiSync(&lowerHeightOnTempo($ss,'-J Y',-1),3,-1),-1);
			
			print $fhout $ss_orig.';'.$ss.';'.$ss_lowheight.';'.$ss_lowheightJL."\n";
		    }

		    close($fhin);
		    close($fhout);
		}
	    }
	}
    }
}



#################################################
#  Test function to generate Polyrythms Lists 
#################################################
sub __test_polyrythm_list_gen
{
    for(my $i=1; $i <= 5; $i++) {
	for(my $d=1; $d <= 5; $d++) {
	    for(my $g=1; $g <= 5; $g++) {
		my $filename = 'polyrythms-'.$i.'objects_'.$d.'!'.$g.'.txt';
		print "==== ".$filename.' ===='."\n";
		if($d == 1 || $g == 1)
		{
		    &genPolyrythm($i,'f',$d,$g,'','-J Y',$filename);
		}
		else {
		    &genPolyrythm($i,'f',$d,$g,'','',$filename);
		}		
	    }
	}
    }
}


#################################################
#  Test function to generate Multiplexes Polyrythms Lists 
#################################################
sub __test_polyrythm_mult_list_gen
{
    for(my $i=2; $i <= 5; $i++) {
	for(my $j=2; $j <= 2; $j++) {
	    for(my $d=1; $d <= 5; $d++) {
		for(my $g=1; $g <= 5; $g++) {
		    my $filename = 'polyrythms-'.$i.'objects_mult'.$j.'_'.$d.'!'.$g.'.txt';
		    print "==== ".$filename.' ===='."\n";
		    if($d == 1 || $g == 1)
		    {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','-J Y',$filename);
		    }
		    else {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','',$filename);
		    }		
		}
	    }
	}
    }
}

sub __test_polyrythm_mult_list_gen2
{
    for(my $i=2; $i <= 2; $i++) {
	for(my $j=2; $j <= 2; $j++) {
	    for(my $d=4; $d <= 4; $d++) {
		for(my $g=4; $g <= 5; $g++) {
		    my $filename = 'polyrythms-'.$i.'objects_mult'.$j.'_'.$d.'!'.$g.'.txt';
		    print "==== ".$filename.' ===='."\n";
		    if($d == 1 || $g == 1)
		    {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','-J Y',$filename);
		    }
		    else {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','',$filename);
		    }		
		}
	    }
	    for(my $d=5; $d <= 5; $d++) {
		for(my $g=1; $g <= 5; $g++) {
		    my $filename = 'polyrythms-'.$i.'objects_mult'.$j.'_'.$d.'!'.$g.'.txt';
		    print "==== ".$filename.' ===='."\n";
		    if($d == 1 || $g == 1)
		    {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','-J Y',$filename);
		    }
		    else {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','',$filename);
		    }		
		}
	    }
	}
    }


    for(my $i=3; $i <= 3; $i++) {
	for(my $j=2; $j <= 2; $j++) {
	    for(my $d=3; $d <= 5; $d++) {
		for(my $g=4; $g <= 5; $g++) {
		    my $filename = 'polyrythms-'.$i.'objects_mult'.$j.'_'.$d.'!'.$g.'.txt';
		    print "==== ".$filename.' ===='."\n";
		    if($d == 1 || $g == 1)
		    {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','-J Y',$filename);
		    }
		    else {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','',$filename);
		    }		
		}
	    }
	}
    }


    for(my $i=4; $i <= 4; $i++) {
	for(my $j=2; $j <= 2; $j++) {
	    for(my $d=2; $d <= 5; $d++) {
		for(my $g=4; $g <= 5; $g++) {
		    my $filename = 'polyrythms-'.$i.'objects_mult'.$j.'_'.$d.'!'.$g.'.txt';
		    print "==== ".$filename.' ===='."\n";
		    if($d == 1 || $g == 1)
		    {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','-J Y',$filename);
		    }
		    else {
			&genPolyrythmMult($i,'f',$j,$d,$g,'','',$filename);
		    }		
		}
	    }
	}
    }


}

    

#################################################
#  Generic Test functions 
#################################################
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
    print "\t\tTest Validity : SSWAP::isValid(\"(0x,2)(4,6)\");\n\t\t==> True\n";
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
    print "\t\tGet Info : SSWAP::getInfo(\"[01]2345\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[01]2345');        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet Info : SSWAP::getInfo(\"[01]2354\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getInfo('[01]2354');        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGen States/Transitions Matrix : SSWAP::genStates(\"V\",3,5);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &genStates('V',3,5);        

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence : SSWAP::isEquivalent(SSWAP::timeRev('714',-1),'741');\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent(SSWAP::timeRev('714',-1),'741');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tCheck Equivalence : SSWAP::isEquivalent(SSWAP::timeRev('714',-1),'714');\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isEquivalent(SSWAP::timeRev('714',-1),'714');

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
    print "\t\tTime reversed SS :  SSWAP::timeRev('3[31]2');\n\t\t==> 1[23]3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('3[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6,4)(2,4)*');\n\t\t==> (4,6)(4,2)* \n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6,4)(2,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6,4)(4x,2x)*');\n\t\t==> (4x,6)(4,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6,4)(4x,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6,4x)(4x,2)*');\n\t\t==> (4x,6)(2,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6,4x)(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6,4x)(2x,4)*');\n\t\t==> (4,6)(2x,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6,4x)(2x,4)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6x,4)(2,4x)*');\n\t\t==> (6x,4x)(4,2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6x,4)(2,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6x,4)(4,2x)*');\n\t\t==> (6x,4)(4,2x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6x,4x)(2x,4x)*');\n\t\t==> (6x,4x)(2x,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6x,4x)(2x,4x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(6x,4x)(4,2)*');\n\t\t==> (6x,4)(2,4x)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(6x,4x)(4,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('([4x4],2)(0,2)(2,[22])*');\n\t\t==> ([24x],4)20(2,[22])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('([4x4],2)(0,2)(2,[22])*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('[64][62]1[22]2');\n\t\t==> 4[12]6[26][22]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('[64][62]1[22]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('([22x],2)*');\n\t\t==> ([22x],2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('([22x],2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTime reversed SS :  SSWAP::timeRev('(2x,[22x])(2,[22])(2,[22x])*');\n\t\t==> ([22],2)([22x],2x)([22x],2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &timeRev('(2x,[22x])(2,[22])(2,[22x])*');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('3[13]2');\n\t\t==> 3[31]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('3[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('9753197531');\n\t\t==> 9753197531\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('9753197531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('9753197531*');\n\t\t==> 9753197531*\n";
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
    print "\t\tShrink :  SSWAP::shrink('[64][62]1[22]2[64][62]1[22]2');\n\t\t==> [64][62]1[22]2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('[64][62]1[22]2[64][62]1[22]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('([22x],2)(2,[22x])');\n\t\t==> ([22x],2)*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('([22x],2)(2,[22x])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tShrink :  SSWAP::shrink('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');\n\t\t==> (2x,[22x])(2,[22])(2,[22x])*\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &shrink('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('3[13]2');\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('3[31]2');   

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('3[13]2*');\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('3[31]2*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('3[13]23[13]2');\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('3[31]23[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('3[13]23[13]23[31]2');\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('3[31]23[31]23[31]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('97531975319753197531');\n\t\t==> 5\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('97531975319753197531');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('9753197531*');\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('9753197531*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6,4)(2,4)(4,6)(4,2)(6,4)(2,4)(4,6)(4,2)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6,4)(2,4)(4,6)(4,2)(6,4)(2,4)(4,6)(4,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6,4)(4x,2x)(4,6)(2x,4x)(6,4)(4x,2x)(4,6)(2x,4x)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6,4)(4x,2x)(4,6)(2x,4x)(6,4)(4x,2x)(4,6)(2x,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6,4x)(4x,2)(4x,6)(2,4x)(6,4x)(4x,2)(4x,6)(2,4x)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6,4x)(4x,2)(4x,6)(2,4x)(6,4x)(4x,2)(4x,6)(2,4x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)(6,4x)(2x,4)(4x,6)(4,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6x,4)(2,4x)(4,6x)(4x,2)(6x,4)(2,4x)(4,6x)(4x,2)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6x,4)(2,4x)(4,6x)(4x,2)(6x,4)(2,4x)(4,6x)(4x,2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6x,4)(4,2x)*');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6x,4)(4,2x)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6x,4x)(2x,4x)(4x,6x)(4x,2x)(6x,4x)(2x,4x)(4x,6x)(4x,2x)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6x,4x)(2x,4x)(4x,6x)(4x,2x)(6x,4x)(2x,4x)(4x,6x)(4x,2x)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)');\n\t\t==> 8\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)(6x,4x)(4,2)(4x,6x)(2,4)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('([4x4],2)(0,2)(2,[22])(2,[4x4])(2,0)([22],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('([4x4],2)(0,2)(2,[22])*');\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('([4x4],2)(0,2)(2,[22])*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('[64][62]1[22]2[64][62]1[22]2');\n\t\t==> 5\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('[64][62]1[22]2[64][62]1[22]2');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('([22x],2)(2,[22x])');\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('([22x],2)(2,[22x])');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(2x,[22x])(2,[22])(2,[22x])([22x],2x)([22],2)([22x],2)');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tPeriodMin :  SSWAP::getPeriodMin('(2x,[22x])(2,[22])(2,[22x])*');\n\t\t==> 12\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getPeriodMin('(2x,[22x])(2,[22])(2,[22x])*');

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
    print "\t\tGet Period : SSWAP::getPeriod(\"( 2x , [22x] ) ( 2 , [22] )( 2,[22x] ) *\");\n\t\t==> 12\n";
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
    print "\t\tGet Siteswap Status : SSWAP::getSSstatus(\"([604],2)\");\n\t\t==> EXCITED\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getSSstatus('([604],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"51\");\n\t\t==> [ 01011; 10101; 01011 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('51');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"24[54]\");\n\t\t==> [ 11111; 01121; 01112; 11111 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('24[54]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"24[45]\");\n\t\t==> [ 11111; 01121; 01112; 11111 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('24[45]');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"[45]24\");\n\t\t==> [ 01112; 11111; 01121; 01112 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('[45]24');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"(4x,2)*\");\n\t\t==> [ 11,01; 01,11; 11,01 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('(4x,2)*');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"(4x,2)(2,4x)\");\n\t\t==> [ 11,01; 01,11; 11,01 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('(4x,2)(2,4x)');
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tGet States : SSWAP::getStates(\"([604],2)\");\n\t\t==> [ 000122,000001 ]\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &getStates('([604],2)');

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTo Stack : SSWAP::toStack(\"97531\");\n\t\t==> 54321\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &toStack('97531');

    
}


1;

