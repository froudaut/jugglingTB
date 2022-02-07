#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## HSS.pm   - Hand Siteswap Notation for jugglingTB                         ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2021-2022  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package HSS;
use common;
use strict;
use lang;
use Term::ANSIColor;        
use modules::SSWAP;    


$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $HSS_INFO = "HSS juggling Notation";
our $HSS_HELP = $lang::MSG_HSS_MENU_HELP;
our $HSS_VERSION = "v0.1";

our %HSS_CMDS = 
    (
     'basicMap'           => ["$lang::MSG_HSS_MENU_BASICMAP_1","$lang::MSG_HSS_MENU_BASICMAP_2"],
     'changeHSS'          => ["$lang::MSG_HSS_MENU_CHANGEHSS_1","$lang::MSG_HSS_MENU_CHANGEHSS_2"],
     'getHandsSeq'        => ["$lang::MSG_HSS_MENU_GETHANDSSEQ_1","$lang::MSG_HSS_MENU_GETHANDSSEQ_2"],
    );

print "HSS $HSS::HSS_VERSION loaded\n";

# To add debug behaviour 
our $HSS_DEBUG=-1;


sub changeHSS
{
    my $ss = $_[0];
    my $hss = $_[1];
    my $nhss = $_[2];
    my $nss = '';

    if(&SSWAP::isValid($ss,-1) <= 0)
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR1\n";
	return -1;
    }

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR2 => $hss\n";
	return -1;
    }

    if(&SSWAP::isValid($nhss,-1) <= 0)
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR2 => $nhss\n";
	return -1;
    }

    
    my $hand_period = 40;  # Must be multiple of hands and greater than SS period
    my @hss_map = '' x $hand_period;
    my @nhss_map = '' x $hand_period;
    my @ss_map_r = '' x $hand_period;
    my @ss_map_l = '' x $hand_period;
    my $cur_hand = 'R';
    my $cpt_r = 0;
    my $cpt_l = 0;
    
    for(my $i=0; $i<$hand_period;$i++)
    {
	my $th=substr($hss,$i%length($hss),1);
	if($hss_map[$i] eq '')
	{	   
	    if($cur_hand eq 'R')
	    {
		$hss_map[$i] = $cur_hand.$cpt_r;
		$cur_hand = 'L';
	    }
	    else
	    {
		$hss_map[$i] = $cur_hand.$cpt_l;
		$cur_hand = 'R';
	    }	    
	}

	if(($hss_map[($i+int($th))%$hand_period]) eq '')
	{
	    if(substr($hss_map[$i],0,1) eq 'R')
	    {
		$cpt_r++;
		$hss_map[($i+int($th))%$hand_period] = substr($hss_map[$i],0,1).$cpt_r;
	    }
	    else
	    {
		$cpt_l++;
		$hss_map[($i+int($th))%$hand_period] = substr($hss_map[$i],0,1).$cpt_l;
	    }
	}		    
    }

    print "=== HSS MAP ===\n";
    for(my $i=0; $i < scalar(@hss_map);$i ++)
    {
	print $hss_map[$i]." ";
    }
    print "\n\n";

    $cpt_r = 0;
    $cpt_l = 0;
    for(my $i = 0; $i < $hand_period; $i++)
    {
	my $val=int(substr($ss,$i%length($ss),1));
	if(substr($hss_map[$i],0,1) eq 'R')
	{	    
	    $ss_map_r[$cpt_r] = $hss_map[($i+$val)%$hand_period];
	    $cpt_r++;
	}
	else
	{	    
	    $ss_map_l[$cpt_l] = $hss_map[($i+$val)%$hand_period];
	    $cpt_l++;
	}
	
    }

    print "=== OSS MAP (Right) ===\n";
    for(my $i = 0; $i < $hand_period; $i++)
    {
	if ($ss_map_r[$i] eq '')
	{
	    print " _ ";
	}
	else
	{
	    print $ss_map_r[$i]." ";
	}
    }
    print "\n\n";

    print "=== OSS MAP (Left) ===\n";
    for(my $i = 0; $i < $hand_period; $i++)
    {
	if ($ss_map_l[$i] eq '')
	{
	    print " _ ";
	}
	else
	{
	    print $ss_map_l[$i]." ";
	}
    }
    print "\n\n";


    $cur_hand = 'R';
    $cpt_r = 0;
    $cpt_l = 0;
    for(my $i=0; $i<$hand_period;$i++)
    {
	my $th=substr($nhss,$i%length($nhss),1);
	if($nhss_map[$i] eq '')
	{	   
	    if($cur_hand eq 'R')
	    {
		$nhss_map[$i] = $cur_hand.$cpt_r;
		$cur_hand = 'L';
	    }
	    else
	    {
		$nhss_map[$i] = $cur_hand.$cpt_l;
		$cur_hand = 'R';
	    }	    
	}

	if(($nhss_map[($i+int($th))%$hand_period]) eq '')
	{
	    if(substr($nhss_map[$i],0,1) eq 'R')
	    {
		$cpt_r++;
		$nhss_map[($i+int($th))%$hand_period] = substr($nhss_map[$i],0,1).$cpt_r;
	    }
	    else
	    {
		$cpt_l++;
		$nhss_map[($i+int($th))%$hand_period] = substr($nhss_map[$i],0,1).$cpt_l;
	    }
	}		    
    }

    print "=== NEW HSS MAP ===\n";
    for(my $i=0; $i < scalar(@nhss_map);$i ++)
    {
	print $nhss_map[$i]." ";
    }
    print "\n\n";


    for(my $i=0; $i<$hand_period;$i++)
    {
	my $dest = '';
	if(substr($nhss_map[$i],0,1) eq 'R')
	{
	    $dest = $ss_map_r[substr($nhss_map[$i],1)];
	}
	else
	{
	    $dest = $ss_map_l[substr($nhss_map[$i],1)];
	}

	my $found = -1;
	for(my $j=0; $j < scalar(@nhss_map); $j++)
	{
	    if($nhss_map[$j] eq $dest)
	    {		
		my $val = $j - $i;
		if($j < $i)
		{
		    $val = scalar(@nhss_map) + $val;
		}
		if($val > 16)
		{
		    $val = '_';		    
		}
		else
		{
		    $val = sprintf("%X", $val);
		}
		$nss = $nss.''.$val;
		$found = 1;
		last;
	    }
	}
	if($found == -1)
	{
	    $nss = $nss.'_';
	}       	

    }

    print $nss." ...\n";

}




sub basicMap
{
    my $max_objs=15;
    my $max_hands=15;
    
    if(scalar @_ >= 1)
    {
	$max_hands = $_[0];
	if(scalar @_ >= 2)
	{
	    $max_objs = $_[1];
	}
    }
    
    print "\n\n\t row : nb Hands\n\t column: nb Objects\n\n";
    print "\t Cn : Cascade Next-Hand\n";
    print "\t Cp : Cascade Previous-Hand\n";
    print "\t Fs : Fountain Same-Hand\n";
    print "\t C : Other Cascade\n";
    print "\t F : Fountain Crossed\n\n\n";    
    
    print '    |';    
    for(my $n=1; $n <= $max_objs; $n ++)
    {       
	if($n<10)
	{
	    print "  $n |";
	}
	else
	{
	    print " $n |";
	}		    
    }
    print "\n ";
    print "-----" x $max_objs ;
    print "----\n";

    for(my $h=1; $h <= $max_hands; $h ++)
    {
	for(my $n=1; $n <= $max_objs; $n++)
	{
	    if ($n == 1)
	    {
		if($h<10)
		{
		    print "  $h |";
		}
		else
		{
		    print " $h |";
		}		    
	    }
	    
	    if($n%$h == 0)
	    {
		print ' Fs |';      		
	    }
	    elsif($n%$h == 1)
	    {
		print ' Cn |';
	    }
	    elsif($n%$h == $h-1)
	    {
		print ' Cp |';
	    }
	    else
	    {
		if(&__pgcd($n,$h) == 1)
		{
		    print '  C |';
		}
		else
		{
		    print '  F |';
		}
		
	    }		
	}

	print "\n ";
	print "-----" x $max_objs ;
	print "----\n";
    }
    print "\n";
}



sub getHandsSeq
{
    my $hss = $_[0];
    my $hands_in = $_[1];

    my @hands=split(/,/,$hands_in);
    

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ERROR1\n";
	return -1;
    }

    if(&SSWAP::getSSType($hss,-1) ne 'V')
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ERROR2\n";
	return -1;
    }

    my $hss_period = &SSWAP::getObjNumber($hss,-1);
    if($hss_period != scalar(@hands))
    {
	print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ERROR3 => $hss_period\n";
	return -1;
    }
    
    my @hands_map = '' x (15+$hss_period);        
    my $cpt=0;
    
    for(my $i=0; $i < length($hss); $i ++)
    {
	if($hands_map[$i] eq '')
	{
	    $hands_map[$i] = $hands[$cpt];
	    $cpt++;
	}
	$hands_map[$i+hex(substr($hss,$i,1))]=$hands_map[$i];	
    }

    for(my $i=0; $i < scalar @hands_map; $i++)
    {
	print $hands_map[$i]." ";
    }

    print "\n\n";
}





1;
