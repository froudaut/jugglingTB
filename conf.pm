#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## conf.pm   - configuration Manager for jugglingTB                         ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2022  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package conf;
use strict;
use common;

##############################################################################
#
# Here are the default configurations values if no conf.ini file is specified
# Do not edit it : use instead conf.ini or define a conf file and indicates it
# starting JTB
#
#############################################################################


# Language
our $LANG="FRENCH";
#our $LANG="ENGLISH";

# Command to start HTML Browser
# Unix-Like OS
our $HTTP_BROWSER='mozilla-firefox';
if($common::OS eq "MSWin32")
{
    $HTTP_BROWSER='C:/Program Files/Internet Explorer/iexplore.exe';
}

# JugglingLab Path (Start with [CWD] for a relative Path)
our $JUGGLING_LAB_PATH="[CWD]/data/JugglingLab/v1.6.2";

# JugglingLab JL Version
our $JUGGLING_LAB_JML_VERSION="2";

#Columns Size for display
our $XSIZE = 60;


# Default behaviour when starting JugglingToolbox. 0 is for not set, 1 is for set
# Usage when calling jugglingTb :
our $jtbOptions_u=0;
# JugglingTB version 
our $jtbOptions_v=0;
# JugglingTB Colorisation 
our $jtbOptions_c=0;
# JugglingTB Help
our $jtbOptions_h=0;
# JugglingTB Extended Help
our $jtbOptions_H=0;
# JugglingTB Autocompletion
our $jtbOptions_a=0;
# Unicode handling in lang.pm
our $jtbOptions_s=0;
# Run Command at startup
our $jtbOptions_e;# Run Command at startup
# Debug Mode
our $jtbOptions_d=-1;
# Launch Tierce Appli for results
our $jtbOptions_r="1";


# GRAPHVIZ Path for binary (needed to draw graphs such as Siteswap States-Transitions Diagram) (Mod LADDER/SSWAP)
our $GRAPHVIZ_BIN = 'C:/Program Files/Graphviz/bin/';

# GNUPLOT binary (needed to draw graphs such as HTN Grids) (Mod HTN)
our $GNUPLOT_BIN = 'C:/Program Files/Gnuplot/bin/gnuplot.exe';

# Java binary (Mod SPYRO)
our $JAVA_CMD="java";


##  MODULES PARAMETERS                                                   
########################

# All results will be set in this directory
our $RESULTS = "results";
# Local Temp Directory
our $TMPDIR="tmp";


###### SSWAP
# Columns Size for display in Excel (Mod SSWAP)
our $EXCELCOLSIZE = "auto"; # 4, 6, 12, "auto";


sub init
{
    my $conf="";

    if(scalar @_ == 0)
    {
	open(FILE,"conf.ini") 
	    || die ("$lang::MSG_GENERAL_ERR1 <conf.ini> $lang::MSG_GENERAL_ERR1b") ;	
	$conf = "conf.ini";
    }
    else
    {
	open(FILE,"$_[0]") 
	    || die ("$lang::MSG_GENERAL_ERR1 <$_[0]> $lang::MSG_GENERAL_ERR1b") ;
	$conf = $_[0];
    }

    while (<FILE>) {
	my $lign=$_;
	my $lignc=$lign;
	$lignc =~ s/\s+//g;
	if($lignc eq "" || substr($lignc,0,1) eq "#")
	{
	    next;
	}

	my @ligns=split(/=/,$lign);
	if(scalar @ligns != 2)
	{
	    print "Bad Parameter <".substr($lign,0,length($lign)-1)."> in \"".$conf."\"\n";
	}
	else
	{
	    my $i = 0;
	    while(substr($ligns[1],$i,1) ne '"' && $i < length($ligns[1]))
	    {		
		$i++;
	    }

	    my $v = substr($ligns[1],$i,1);$i++;
	    while(substr($ligns[1],$i,1) ne '"' && $i < length($ligns[1]))
	    {		
		$v = $v.substr($ligns[1],$i,1);
		$i++;
	    }
	    $v = $v.substr($ligns[1],$i,1);

	    #$v =~ s/\s+//g;
	    $v =~ s/"//g;
	    if($v eq "")
	    {
		print "Warning : Parameter <".$ligns[0]."> is set to null.\n";
	    }

	    if($ligns[0] =~ "LANG")
	    {
		$LANG=$v;	
	    }
	    elsif($ligns[0] =~ "HTTP_BROWSER")
	    {
		$HTTP_BROWSER=$v;	
	    }
	    elsif($ligns[0] =~ "JUGGLING_LAB_PATH")
	    {
		$JUGGLING_LAB_PATH=$v;	
	    }
	    elsif($ligns[0] =~ "JUGGLING_LAB_JML_VERSION")
	    {
		$JUGGLING_LAB_JML_VERSION=$v;	
	    }	    
	    elsif($ligns[0] =~ "XSIZE")
	    {
		$XSIZE=$v;	
	    }
	    elsif($ligns[0] =~ "GRAPHVIZ_BIN")
	    {
		$GRAPHVIZ_BIN=$v;
	    }	   
	    elsif($ligns[0] =~ "GNUPLOT_BIN")
	    {
		$GNUPLOT_BIN=$v;
	    }
	    elsif($ligns[0] =~ "JAVA_CMD")
	    {
		$JAVA_CMD=$v;
	    }
	    elsif($ligns[0] =~ "RESULTS")
	    {
		$RESULTS=$v;	
	    }	    
	    elsif($ligns[0] =~ "TMPDIR")
	    {
		$TMPDIR=$v;	
	    }	    
	    elsif($ligns[0] =~ "EXCELCOLSIZE")
	    {		
		$EXCELCOLSIZE=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_d")
	    {		
		$jtbOptions_d=$v;			
	    }	    
	    elsif($ligns[0] =~ "jtbOptions_u")
	    {		
		$jtbOptions_u=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_v")
	    {		
		$jtbOptions_v=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_c")
	    {		
		$jtbOptions_c=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_h")
	    {		
		$jtbOptions_h=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_H")
	    {		
		$jtbOptions_H=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_a")
	    {		
		$jtbOptions_H=$v;			
	    }
	    elsif($ligns[0] =~ "jtbOptions_s")
	    {		
		$jtbOptions_s=$v;			
	    }	 
	    elsif($ligns[0] =~ "jtbOptions_r")
	    {		
		$jtbOptions_r=$v;			
	    }	 
	    elsif($ligns[0] ne "")
	    {
		print "Bad Parameter <".$ligns[0]."> in \"".$conf."\"\n";
	    }

	}
	
    }
    
    close(FILE);


}


1;
