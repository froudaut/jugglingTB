#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## config.pl   -  jugglingTB default config file generation                 ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2020 Frederic Roudaut  <frederic.roudaut@free.fr>     ##
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

use strict;
use File::Basename;
use Cwd;
use Config;
#use Getopt::Std;


my ($jugglingTBMkFile, $jugglingTBcwd) = fileparse($0);
my $cwd = getcwd();
my $answer = "";
 

sub usage
{
    print "\n USAGE :  perl $0\n\n" ;
    print "Install JugglingTB ...\n";
    print "\n";
}

#my %opts={};
#getopts( 'r', \%opts ) || die(&usage());

if(@ARGV == 0)
{
    # Either linux or MSWin32
    my $OS=$^O;

    
    print "\n=========================================================\n";
    print "==             Configure JugglingTB (conf.ini)           == \n";
    print "===========================================================\n";
    open(FILE,"> ${jugglingTBcwd}/conf.ini") || die ("Error : Cannot open file <conf.ini> for writing configuration\n") ;
    
    $answer ="";
    while(!((uc($answer) eq "F") || (uc($answer) eq "E"))) 
    {
	print "\n - Choose You langage French/English [F/E] : ";
	$answer = <STDIN>;
	chomp($answer);	
	if(uc($answer) eq "F")
	{			
	    print FILE '# Langage'."\n";
	    print FILE 'LANG="FRENCH"'."\n";
	}

	elsif(uc($answer) eq "E")
	{			
	    print FILE '# Langage'."\n";
	    print FILE 'LANG="ENGLISH"'."\n";
	} 
    }

    print "\n - Command to start HTML Browser";
    
    my $browser = "";
    if($OS eq "MSWin32") 
    {
	print ' [C:/Program Files/Internet Explorer/iexplore.exe] : ';
	$browser = 'C:/Program Files/Internet Explorer/iexplore.exe';    
    }

    else
    {
	print " [mozilla-firefox] : ";
	$browser = "mozilla-firefox";
    }

    $answer = "";
    $answer = <STDIN>;
    chomp($answer);	
    print FILE '# Command to start HTML Browser'."\n";
    if(!($answer eq ""))
    {	
	$browser = $answer;
    }

    print FILE 'HTTP_BROWSER="'.${browser}.'"'."\n";	


    $answer ="";
    #while((uc($answer) eq "")) 
    #{
    print "\n - Command to run java Environment [java] : ";
    $answer = <STDIN>;
    chomp($answer);	
    if(!(uc($answer) eq ""))
    {	                 
	print FILE '# Command to run java Environment'."\n";
	print FILE 'JAVA_CMD="'.$answer.'"'."\n";
    }
    
    else
    {
	print FILE '# Command to run java Environment'."\n";
	print FILE 'JAVA_CMD="java"'."\n";
    }
    #}

    $answer ="";  
    print "\n - JugglingLab Jar [data/JugglingLab/bin/JugglingLabSigned.jar] : ";
    $answer = <STDIN>;
    chomp($answer);	
    if(!(uc($answer) eq ""))
    {	                 
	print FILE '# JugglingLab Jar'."\n";
	print FILE 'JUGGLING_LAB_JAR="'.$answer.'"'."\n";
    }
    
    else
    {
	print FILE '# JugglingLab Jar'."\n";
	print FILE 'JUGGLING_LAB_JAR="data/JugglingLab/bin/JugglingLabSigned.jar"'."\n";
    }

    $answer ="";  
    print "\n - JugglingLab JML Version [1.2] : ";
    $answer = <STDIN>;
    chomp($answer);	
    if(!(uc($answer) eq ""))
    {	                 
	print FILE '# JugglingLab JML Version'."\n";
	print FILE 'JUGGLING_LAB_JML_VERSION="'.$answer.'"'."\n";
    }
    
    else
    {
	print FILE '# JugglingLab JML Version'."\n";
	print FILE 'JUGGLING_LAB_JML_VERSION="1.2"'."\n";
    }

    $answer ="";
    print "\n - Column Size for Display [60] : ";
    $answer = <STDIN>;
    chomp($answer);	
    if(!(uc($answer) eq ""))
    {	                 
	print FILE '# Columns Size for display'."\n";
	print FILE 'XSIZE="'.$answer.'"'."\n";
    }
    
    else
    {
	print FILE '# Columns Size for display'."\n";
	print FILE 'XSIZE="60"'."\n";
    }
    
    print FILE "\n\n";
    print FILE '### Options when calling jugglingTb (1 is for set) ###'."\n";
    print FILE '# Usage '."\n";
    print FILE 'jtbOptions_u="0"'."\n";
    print FILE '# JugglingTB version '."\n";
    print FILE 'jtbOptions_v="0"'."\n";
    print FILE '# JugglingTB Colorisation '."\n";
    print FILE 'jtbOptions_c="0"'."\n";
    print FILE '# JugglingTB Help'."\n";
    print FILE 'jtbOptions_h="0"'."\n";
    print FILE '# JugglingTB Extended Help'."\n";
    print FILE 'jtbOptions_H="0"'."\n";
    print FILE '# JugglingTB Autocompletion'."\n";
    print FILE 'jtbOptions_a="0"'."\n";
    print FILE '# Unicode handling in lang.pm'."\n";
    print FILE 'jtbOptions_s="0"'."\n";
    print FILE '# Debug Mode'."\n";
    print FILE 'jtbOptions_d="-1"'."\n";
    print FILE '# Launch Tierce Appli for results'."\n";
    print FILE 'jtbOptions_r="1"'."\n";


    ##                                                                         
    ##  MODULES PARAMETERS                                                     
    #######################
    print FILE "\n\n";
    print FILE "###  MODULES PARAMETERS ###\n";
    print FILE '# All results will be set in this directory'."\n";
    print FILE 'RESULTS="results"'."\n";
    print FILE '# Local Temp Directory'."\n";
    print FILE 'TMPDIR="tmp"'."\n";

    $answer ="";
    print FILE '# GRAPHVIZ Path for binary (needed to draw graphs such as Siteswap States-Transitions Diagram)'."\n";
    print "\n - GRAPHVIZ Path for binary (needed to draw graphs such as Siteswap States-Transitions Diagram) [c:/Program Files/Graphviz/bin/] : ";
    $answer = <STDIN>;
    chomp($answer);	
    if(!(uc($answer) eq ""))
    {	                 
	print FILE 'GRAPHVIZ_BIN="'.$answer.'"'."\n";
    }
    
    else
    {    
	print FILE 'GRAPHVIZ_BIN="C:/Program Files/Graphviz/bin/'.'"'."\n";
    }


    print FILE '# Columns Size for display in Excel (Mod SSWAP)'."\n";
    print FILE 'EXCELCOLSIZE="auto"'."\n";

    print FILE "\n\n";	
    close FILE;
        

    print "\n=========================================================\n";
    print "==         You are now ready to run jugglingTB         == \n";
    print "=========================================================\n";

}


else
{
    die(&usage());
}
