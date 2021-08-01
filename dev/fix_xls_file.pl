#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## fix_xls_file.pl  -  script for fixing States headers in XLS transitions  ##
##                     Diagrams for old versions of the SSWAP Module        ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015  Frederic Roudaut  <frederic.roudaut@free.fr>         ##
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

use strict;
use warnings;
#use File::Grep qw( fgrep fmap fdo );
use Win32::OLE;
use Win32::OLE qw(in with);
use Win32::OLE::Const;
use File::Basename;


my $EXCEL_ROW_START = 9;	# raw pad for writing

$Win32::OLE::Warn = 3;	# die on errors...    
# get already active Excel application or open new
my $Excel = Win32::OLE->GetActiveObject('Excel.Application') || Win32::OLE->new('Excel.Application', 'Quit');
my $Excel_symb = Win32::OLE::Const->Load($Excel);

if(scalar @ARGV != 1)
{
    print "Error : Directory has to be defined.\n";
    exit -1;
}

foreach my $excelfile (glob "$ARGV[0]/*.xlsx")
{
    print "==> File : $excelfile\n";

    my $reg="$ARGV[0]/Matrix";
    if($excelfile =~ "Aggr" || !($excelfile =~ /^$reg/) || !($excelfile =~ /xlsx$/))
    {
	print "\t Not Considered\n";
    }
    else
    {
	my @file1 = split(/_/,basename $excelfile);
	my @file2 = split(/\./,$file1[3]);
	my $height=hex($file2[0]);
	if($file1[1] eq "V" || $file1[1] eq "M")
	{
	}
	elsif($file1[1] eq "MS" || $file1[1] eq "S")
	{
	    $height = $height +1;
	}
	elsif($file1[1] eq "MULTI")
	{
	    $height = $height * 2 +1;
	}
	else
	{
	    print "\t Not Considered\n";
	}

	my $Book = $Excel->Workbooks->Open($excelfile);
	my $Sheet = $Book->Worksheets(1);   
	
	#Hack for bug with the AutoFit parameter on Columns
	$Sheet->Rows($EXCEL_ROW_START)-> {'RowHeight'} = $height * 8;
	$Sheet->Rows($EXCEL_ROW_START)-> {'VerticalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	
	$Sheet->Rows($EXCEL_ROW_START)-> {'HorizontalAlignment'} = $Excel_symb->{'xlHAlignCenter'}; 	

	$Excel -> {'DisplayAlerts'} = 0; # This turns off the "This file already exists" message.
	$Book -> Save or die $!;
	$Book -> Close;    
	print "\t Done\n";
    }
}

exit 1;

