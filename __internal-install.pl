#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## install.pl   -  jugglingTB installation                                  ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2022 Frederic Roudaut  <frederic.roudaut@free.fr>     ##
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

my @modulesToCompile=("Devel-Symdump-2.18", "Set-Scalar-1.29", "Parse-Yapp-1.21", "Excel-Writer-XLSX-1.07", "Perl4-CoreLibs-0.004", "File-Grep-0.02", "File-Copy-Recursive-0.45", "TermReadKey-2.38", "Win32-Console-ANSI-1.11", "Chart-Gnuplot-0.23", "HTTP-Server-Simple-0.52", "List-MoreUtils-0.430", "Exporter-Tiny-1.002002");
#"PAR-Packer-1.052", "Module-ScanDeps-1.30");

#my @modulesCompiled=();


my ($jugglingTBMkFile, $jugglingTBcwd) = fileparse($0);
my $perlCall = $Config{perlpath};
#my $makeCall = "dmake";
my $makeCall = "gmake";
#my $ppmCall = "ppm";
my $cwd = getcwd();


sub usage
{
    print "\n USAGE :  perl $0\n\n" ;
    #print "      Empty : ";
    print "Install JugglingTB, its Modules ...\n";
    #print "         -r : ";
    #print "Remove Modules Installed for JugglingTB\n";
    print "\n";
}

#my %opts={};
#getopts( 'r', \%opts ) || die(&usage());

if(@ARGV == 0)
{
    # Either linux or MSWin32
    my $OS=$^O;

    print "\n=========================================================\n";
    print "==    Install JugglingTB, its Perl modules needed ...  == \n";
    print "=========================================================\n";

    print "\n - Perl command to Run [$perlCall] : ";
    my $answer = <STDIN>;
    chomp($answer);
    if (!($answer eq ""))
    {
	$perlCall = $answer;
    }

    
 

    if($OS eq "MSWin32") 
    {
	#$makeCall = '../../../bin/win32/nmake/nmake.exe';
	#$makeCall = '../../../bin/win32/dmake/dmake.exe';
    }

    print "\n - Make command to Run [$makeCall] : ";
    my $answer = <STDIN>;
    chomp($answer);
    if (!($answer eq ""))
    {	
	$makeCall = $answer;
    }

    # if($OS eq "MSWin32") 
    # {
    # 	print "\n - PPM (Perl Package Manager (PPM) given with Activestate) command to Run [$ppmCall] : ";
    # 	my $answer = <STDIN>;
    # 	chomp($answer);
    # 	if (!($answer eq ""))
    # 	{	
    # 	    $ppmCall = $answer;
    # 	}
    # }


    print "\n==    This is now the part for Modules Installation from source  == \n";
    
    foreach my $mod (@modulesToCompile)
    {
	$answer ="";
	while(!((uc($answer) eq "Y") || (uc($answer) eq "N"))) 
	{
	    print "\n - Proceed with installation - ${mod} [Y/N] : ";
	    $answer = <STDIN>;
	    chomp($answer);
	    
	    if(uc($answer) eq "Y")
	    {	
		chdir("$jugglingTBcwd/plus/lib/src/${mod}");
                #$Config{make} = $makeCall;		
		my $run = "$makeCall clean";
		system ($run); 
		$run = "$perlCall Makefile.PL";
		system ($run); 		
		$run = "$makeCall";
		system ($run); 
		$run = "$makeCall test";
		system ($run); 
		$run = "$makeCall install";
		system ($run); 
		$run = "$makeCall clean";
		system ($run); 
		chdir("$cwd");        
	    }
	}
    }
    
    # if($OS eq "MSWin32") 
    # {
    # 	print "\n==    This is now the part for Modules Installation from binary on Windows  == \n";

    # 	foreach my $mod (@modulesCompiled)
    # 	{
    # 	    $answer ="";
    # 	    while(!((uc($answer) eq "Y") || (uc($answer) eq "N"))) 
    # 	    {
    # 		print "\n - Proceed with PPM installation - ${mod} [Y/N] : ";
    # 		$answer = <STDIN>;
    # 		chomp($answer);
		
    # 		if(uc($answer) eq "Y")
    # 		{	
    # 		    chdir("$jugglingTBcwd/plus/lib/bin/win32/${mod}");
    # 		    my $run = "$ppmCall install ${mod}.ppd --force";
    # 		    system ($run); 
    # 		    chdir("$cwd");        
    # 		}
    # 	    }
    # 	}
    # }

    
    

    print "\n=========================================================\n";
    print "==         You are now ready to run jugglingTB         == \n";
    print "=========================================================\n";

}


else
{
    die(&usage());
}
