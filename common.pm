#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## common.pm   -  common package for jugglingTB                             ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2021  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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


package common;
use Term::ANSIColor;
use strict;

our $AUTHOR = "Frederic Roudaut";
our $AUTHOR_MAIL = "frederic.roudaut\@free.fr";

our $COLOR_PROMPT   = "bold blue";
our $COLOR_WAIT     = "bold red";
our $COLOR_ERR      = "bold red";
our $COLOR_RESULT   = "bold red";
our $COLOR_HELPCMD  = "bold magenta";
our $COLOR_HELPPARAMCMD  = "bold yellow";
our $COLOR_HELPMENU = "bold green";   

# Color Table used by Graphviz in Modules LADDER/SSWAP
our @GRAPHVIZ_COLOR_TABLE = ("dodgerblue", "red", "springgreen", "darkviolet", "magenta", "goldenrod", 
			     "saddlebrown", "azure4", "khaki4", "darkorange", "olivedrab1", "turquoise4",
			     "black", "peru", "mediumslateblue");  

# Either linux or MSWin32
our $OS=$^O;

# Set to 0 if Unicode Char are used in lang.pm
$common::NoSpecialChar = 1;        

# Set to 1 if Autocompletion is set
$common::Autocompletion = 0;

our %HASH_SPECIAL_UNICODE_CHAR =
    (
     '\x{e8}' => 'e',
     '\x{e9}' => 'e',
     '\x{ea}' => 'e',
     '\x{eb}' => 'e',
     '\x{e0}' => 'a',
     '\x{f9}' => 'u'
    );

#Prompt used when computing
my $currentComputingPrompt="-";

#Force flush after printing
$| = 1;

sub displayComputingPrompt {
    
    if ($currentComputingPrompt eq "|")
    {
	$| = 1;
	print (chr(8));
	print colored [$COLOR_WAIT], "\\";       
	$currentComputingPrompt="\\";
    }
    
    elsif ($currentComputingPrompt eq "\\")
    {
	$| = 1;
	print (chr(8));
	print colored [$COLOR_WAIT], "-";
	$currentComputingPrompt="-";
    }

    elsif($currentComputingPrompt eq "-")
    {
	$| = 1;
	print (chr(8));
	print colored [$COLOR_WAIT], "/";
	$currentComputingPrompt="/";
    }

    elsif($currentComputingPrompt eq "/")
    {
	$| = 1;
	print (chr(8));
	print colored [$COLOR_WAIT], "|";
	$currentComputingPrompt="|";
    }
}

sub hideComputingPrompt {
    $| = 1;
    print (chr(8));
    print (chr(32));
    print (chr(8));
}


sub displayInfo
{
    my $info = $_[0];
    
    my @containGlob = split(/\n/, $info);
    
    for(my $lign=0;$lign < scalar @containGlob; $lign ++)
    {
	my $disp = "";
	my $nlign = 0;
	
	if($_[2] > 0)
	{
	    my @contain = split(/ /, $containGlob[$lign]);
	    my $nbcar = 0;
	    my $word = 0;
	    
	    while ($word <= (scalar @contain) )
	    {	   
		if(($nbcar + length($contain[$word])) <= $_[2])
		{
		    $nbcar += length ($contain[$word]);
		    $disp = "${disp} $contain[$word]";
		    $word ++;
		}
		
		else
		{
		    if(($nlign == 0) && ($lign == 0))  
		    {
			if($_[3]) 
			{
			    print colored [$_[3]], $disp."\n";
			}
			else
			{
			    print $disp."\n";
			}
		    }
		    else
		    {
			if($_[3]) 
			{
			    print colored [$_[3]], ' ' x ($_[1]).$disp."\n";			    			
			}
			else
			{
			    print ' ' x ($_[1]).$disp."\n";			    
			}
		    }
		    
		    $nlign ++;
		    $nbcar = 0;
		    $disp = "";
		}			
	    }
	}
	
	else
	{
	    $disp = $containGlob[$lign];
	}
	
	if(($nlign == 0)  && ($lign == 0))
	{
	    if($_[3])
	    {
		print colored [$_[3]],$disp."\n";
	    }
	    else
	    {
		print $disp."\n";
	    }
	}
	else
	{		    
	    if($_[3])
	    {
		print colored [$_[3]], ' ' x ($_[1]).$disp."\n";		    
	    }
	    else
	    {
		print ' ' x ($_[1]).$disp."\n";		    
	    }
	}
    }
}


our @SS_list_jonglage_net = (
    '441',
    '531',
    '3',
    '423',
    '4242423',
    '(4,4)(4x,0)*',
    '(6,6)(2x,0)(0,4)*',
    '44133',
    '(4,2x)*',
    '(4x,2x)(4,2x)(2x,4x)*',
    '(4x,2x)(4,2x)*',
    '(4,2)(4x,2)(4,2x)',
    '52233',
    '534',
    '5',
    '4',
    '6',
    '522',
    '633',
    '52512',
    '63141',
    '711',
    '46302',
    '630',
    '31',
    '51',
    '7131',
    '(6x,4)*',
    '(6x,4x)(8x,4x)(4,4)',
    '7445',
    '(6x,4x)',
    '7445555',
    '53',
    '(4,4)',
    '(6x,2x)*',
    '63551',
    '7333444',
    '71',
    '74414',
    '9151',
    '744',
    '741',
    '(6x,4)(2,4x)*',
    '7333',
    '(6,4)',
    '(6,6)',
    '(4x,4x)',
    '40',
    '3[31]332',
    '(4,4)(4x,4x)',
    '552',
    '60',
    '42',
    '522333',
    '335223',
    '3[43]23[32]',
    '3[31]2',
    '[62]25',
    '(4x,2x)',
    '(6x,2x)',
    '(8x,2x)(4x,2x)',
    '3[41]2424232',
    '3[41]24232',
    '42333',
    '3[43]0424232',
    '55500',
    '(4,2x)(4x,2)',
    '(6x,4)(0,2x)',
    '(4,2)(2x,4x)',
    '4233',
    '4242342',
    '(4x,2x)(4,2x)(4,2)*',
    '(6,2x)(6,2x)*',
    '(2x,4x)(4x,2)*',
    '424233',
    '312',
    '4[22]0[32]32',
    '501',
    '530031',
    '8441841481441',
    '401440041',
    '5551',
    '561',
    '(6x,4)(4,2x)*',
    '(4x,2x)(2,4)(2,4x)*',
    '(6,4x)(2x,4)*',
    '(4x,2x)(2,4)(2,4x)(2x,4)',
    '714',
    '(6x,2x)(2,2)(4x,2x)',
    '[54][22]2',
    '([44],[44])(4,0)',
    '[44][22]3',
    '[33][33]3',
    '55550',
    '(2x,[22x])(2,[22])(2,[22x])*',
    '(4x,2x)(2,4)(2,4x)(2x,4)(4,2x)*',
    '55050',
    '42423',
    '(6,4)(2,4)*',
    '(6,4x)(4x,2)*',
    '(6x,4x)(2x,4x)*',
    '(6x,4x)(2x,6)(2,4x)',
    '(6x,4x)(2x,6)(4,2x)',
    '(6,4)(4x,2x)*',
    '(6x,4x)(4,2)*',
    '(4x,2)*',
    '(6,4)(0,2x)*',
    '(8,2x)(4,2x)(2x,0)*',
    '61314',
    '(6,4x)*',
    '645',
    '45123',
    '5671234',
    '45141',
    '8040',
    '75314',
    '(8x,4)(4,4)*',
    '(8x,4x)(4,4)',
    '9344',
    '5744',   
    '56414',
    '801',
    '45623',
    '(8,2x)(4,2x)*',
    '(8,4)(4,2x)(2x,4)*',
    '(8,2)(4x,2x)*',
    '73334',
    '73451',
    '(8,2)(2,4)*',
    '(8,2x)(2,4x)*',
    '(8x,2)(4x,2)*',
    '(8x,2)(2x,4)*',
    '(8x,2x)(4,2)*',
    '(8x,2x)(2x,4x)*',
    '(6x,4)(4,2x)(4,6x)(2x,4)(4x,4x)*',
    '(6x,4)(4,2x)(4,6x)(2x,4)(4,4)*',
    '2',
    '91',
    '(8x,4x)(2x,4)(4,2x)*',
    '678912345',
    '67345',
    '(4,4)(4,0)',
    '45501',
    '(6,4x)(0,2)*',
    '(6x,4)(2,0)*',
    '(6x,4x)(2x,0)*',
    '(4,2)(4x,2)*',
    '[64][62]1[22]2',
    '34512',
    '02233',
    '33022',
    '77722',
    '5511',
    '63123',
    '66661',
    '(6x,4)(6,4x)',
    '(6x,4x)(6,4x)*',
    '61611',
    '5226222',
    '[75][22]2',
    '(6,6)(6x,2) *',
    '(6x,6x)',
    '450',
    '55514',
    '(6,2x)(6,2x)(6,2)(2x,6x)*',
    '24[54]',
    '(6x,4)(4,6)*',
    '(6x,4x)(4,6x)*',
    '7',
    '75751',
    '0123456',
    '3334242',
    '3342342',
    '33342',
    '53633',
    '63641',
    '1',
    '852',
    '642',
    '7441',
    '7531',
    '75',
    '[21]',
    '[22]2',
    '64',
    '663',
    '753',
    '756',
    '7571',
    '771',
    '834',
    '855',
    '864',
    '88441',
    '933',
    '97531',
    'b97531',
    '7733',
    '774',
    '300',
    '330',
    '4000',
    '20',
    '([4x4],2)(0,2)(2,[22])*',
    '([4x2],2)(2,4)(2,2)*',
    '[22]2[23]22',
    '([22x],2)*',
    '([22x],2x)',
    '95551',
    '[55]5244',
    '[222]0',
    '3[54]2442',
    '[64][64]0022',
    '([64],[64])(0,0)(2,2)',
    '24[54]003',
    '8444',
    '3[54]22',
    '522[74]242',
    '[776]20[76]20[76][22]0',    
    "[543]",
    "24[45]",
    "24[54]24[45]",    
    "24[45]24[54]",    
    "01234",
    "4560141",
    "012345678",
    "6782345",
    "567801234",
    "4560123",
    "34012",
    "7893456",
    "78456",
    "6161601",
    "[54]21",
    "(6x,2)(2,2)*",
    "(8x,2)(2,2)(2,2)*",
    "72222",
    "9222222",
    "[32]322",
    "[32]22",
    "3[32]",
    "[32]42322",
    "[32]4222",
    "[32]31",
    "[32]3322",
    "[32]342322",
    "[32]522322",
    "[32]421[32]31",
    "[32]42322[32]4222",
    "[32]42322[32]42322[42]2322",
    "[32]421",
    "[32]522322",
    "[42]21",
    "[42]222",
    "[42]2322",
    "[42]242322",
    "[42]222[42]222[42]2322",
    "[52]2222",
    "[52]2222[42]222",
    "515157",
    "(6x,2)(6,2x)*",
    "6626134",
    "6626152",
    "7362613",
    "5716261",
    "63641",
    "5363641", 
    );


our @SS_experimental = 
    (
     #"432", # Invalid Siteswap, just to check the behaviour
     "333342342",
     "4*26",
     "51x*",
     "6x0*",
     "(6x,0)*",
     "5x3x1x*",
     "4!40",
     "5!*4!*3",
     "(1x,3)!11x*",
     "(4,4)!",
     "(2!*2,4!*4)",
     "(2!*2,4*!4)",
     "[22][33][11]",
     "(2,4)!*",
     "(2,4)!",
     "(2,4)", 
     "8 6 4 2 0",
     "(6,4x)(4x,2)(4x,6)(2,4x)",
     "(8,4x)(0,4x)*",
     "84x4x80*4x4x0*",
     "(a,2)(2,4x)(4x,2)*"
     #"5354x1x(4,4)(4x,5)(4x,5)*5354x54x0(4,4)(5,4x)(5,4x)535354x1x*(4,4)(4x,5)(1x,5)!353"	
    );
     
# MHN Lists 3:2 From Sylvain Garnavault
our @MHN_list_3_2_list1 = 
    (
     "(4,8x)(-,-)(4,-)(-,6)(2x,-)(-,-)", "(6,9x)(-,-)(4x,-)(-,1)(4,-)(-,-)", "(6x,4x)(-,-)(6,-)(-,3)(5,-)(-,-)", "(8,6x)(-,-)(7,-)(-,3x)(0,-)(-,-)", "(9,6)(-,-)(2,-)(-,5)(2,-)(-,-)", "(4,9x)(-,-)(4,-)(-,5)(2x,-)(-,-)", "(6,8x)(-,-)(4x,-)(-,1)(5,-)(-,-)", "(6x,4x)(-,-)(7,-)(-,3)(4,-)(-,-)", "(9,6x)(-,-)(6,-)(-,3x)(0,-)(-,-)", "(8,6)(-,-)(2,-)(-,6)(2,-)(-,-)", "(6,8x)(-,-)(4x,-)(-,6)(0,-)(-,-)", "(6x,9x)(-,-)(2,-)(-,3)(4,-)(-,-)", "(4,6x)(-,-)(6,-)(-,3x)(5,-)(-,-)", "(8,6)(-,-)(7,-)(-,1)(2,-)(-,-)", "(9,4x)(-,-)(4,-)(-,5)(2x,-)(-,-)", "(6,9x)(-,-)(4x,-)(-,5)(0,-)(-,-)", "(6x,8x)(-,-)(2,-)(-,3)(5,-)(-,-)", "(4,6x)(-,-)(7,-)(-,3x)(4,-)(-,-)", "(9,6)(-,-)(6,-)(-,1)(2,-)(-,-)", "(8,4x)(-,-)(4,-)(-,6)(2x,-)(-,-)", "(6x,8x)(-,-)(2,-)(-,6)(2,-)(-,-)", "(4,9x)(-,-)(4,-)(-,3x)(4,-)(-,-)", "(6,6)(-,-)(6,-)(-,1)(5,-)(-,-)", "(8,4x)(-,-)(7,-)(-,3)(2x,-)(-,-)", "(9,6x)(-,-)(4x,-)(-,5)(0,-)(-,-)", "(6x,9x)(-,-)(2,-)(-,5)(2,-)(-,-)", "(4,8x)(-,-)(4,-)(-,3x)(5,-)(-,-)", "(6,6)(-,-)(7,-)(-,1)(4,-)(-,-)", "(9,4x)(-,-)(6,-)(-,3)(2x,-)(-,-)", "(8,6x)(-,-)(4x,-)(-,6)(0,-)(-,-)", "(4,8x)(-,-)(4x,-)(-,6)(2,-)(-,-)", "(6x,9x)(-,-)(4,-)(-,1)(4,-)(-,-)", "(6,4x)(-,-)(6,-)(-,3x)(5,-)(-,-)", "(8,6)(-,-)(7,-)(-,3)(0,-)(-,-)", "(4,9x)(-,-)(4x,-)(-,5)(2,-)(-,-)", "(6x,8x)(-,-)(4,-)(-,1)(5,-)(-,-)", "(6,4x)(-,-)(7,-)(-,3x)(4,-)(-,-)", "(9,6)(-,-)(6,-)(-,3)(0,-)(-,-)", "(8,6x)(-,-)(2,-)(-,6)(2x,-)(-,-)", "(6x,8x)(-,-)(4,-)(-,6)(0,-)(-,-)", "(6,9x)(-,-)(2,-)(-,3x)(4,-)(-,-)", "(4,6)(-,-)(6,-)(-,3)(5,-)(-,-)", "(8,6x)(-,-)(7,-)(-,1)(2x,-)(-,-)", "(9,4x)(-,-)(4x,-)(-,5)(2,-)(-,-)", "(6x,9x)(-,-)(4,-)(-,5)(0,-)(-,-)", "(6,8x)(-,-)(2,-)(-,3x)(5,-)(-,-)", "(4,6)(-,-)(7,-)(-,3)(4,-)(-,-)", "(9,6x)(-,-)(6,-)(-,1)(2x,-)(-,-)", "(8,4x)(-,-)(4x,-)(-,6)(2,-)(-,-)", "(6,8x)(-,-)(2,-)(-,6)(2x,-)(-,-)", "(4,9x)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(6x,6x)(-,-)(6,-)(-,1)(5,-)(-,-)", "(8,4x)(-,-)(7,-)(-,3x)(2,-)(-,-)", "(9,6)(-,-)(4,-)(-,5)(0,-)(-,-)", "(6,9x)(-,-)(2,-)(-,5)(2x,-)(-,-)", "(4,8x)(-,-)(4x,-)(-,3)(5,-)(-,-)", "(6x,6x)(-,-)(7,-)(-,1)(4,-)(-,-)", "(9,4x)(-,-)(6,-)(-,3x)(2,-)(-,-)", "(8,6)(-,-)(4,-)(-,6)(0,-)(-,-)", "(4,6)(-,-)(4,-)(-,6)(4,-)(-,-)", "(6,9x)(-,-)(6,-)(-,1)(2x,-)(-,-)", "(8,4x)(-,-)(4x,-)(-,3)(5,-)(-,-)", "(6x,6x)(-,-)(7,-)(-,5)(0,-)(-,-)", "(9,8x)(-,-)(2,-)(-,3x)(2,-)(-,-)", "(4,6)(-,-)(4,-)(-,5)(5,-)(-,-)", "(6,8x)(-,-)(7,-)(-,1)(2x,-)(-,-)", "(9,4x)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(6x,6x)(-,-)(6,-)(-,6)(0,-)(-,-)", "(8,9x)(-,-)(2,-)(-,3x)(2,-)(-,-)", "(6,4x)(-,-)(4x,-)(-,6)(4,-)(-,-)", "(6x,9x)(-,-)(6,-)(-,3)(0,-)(-,-)", "(8,6x)(-,-)(2,-)(-,3x)(5,-)(-,-)", "(4,6)(-,-)(7,-)(-,5)(2,-)(-,-)", "(9,8x)(-,-)(4,-)(-,1)(2x,-)(-,-)", "(6,4x)(-,-)(4x,-)(-,5)(5,-)(-,-)", "(6x,8x)(-,-)(7,-)(-,3)(0,-)(-,-)", "(9,6x)(-,-)(2,-)(-,3x)(4,-)(-,-)", "(4,6)(-,-)(6,-)(-,6)(2,-)(-,-)", "(8,9x)(-,-)(4,-)(-,1)(2x,-)(-,-)", "(6x,6x)(-,-)(2,-)(-,6)(4,-)(-,-)", "(4,9x)(-,-)(6,-)(-,3x)(2,-)(-,-)", "(8,6)(-,-)(4,-)(-,1)(5,-)(-,-)", "(6,4x)(-,-)(7,-)(-,5)(2x,-)(-,-)", "(9,8x)(-,-)(4x,-)(-,3)(0,-)(-,-)", "(6x,6x)(-,-)(2,-)(-,5)(5,-)(-,-)", "(4,8x)(-,-)(7,-)(-,3x)(2,-)(-,-)", "(9,6)(-,-)(4,-)(-,1)(4,-)(-,-)", "(6,4x)(-,-)(6,-)(-,6)(2x,-)(-,-)", "(8,9x)(-,-)(4x,-)(-,3)(0,-)(-,-)", "(4,9x)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(6x,6x)(-,-)(6,-)(-,1)(5,-)(-,-)", "(8,4x)(-,-)(7,-)(-,3x)(2,-)(-,-)", "(9,6)(-,-)(4,-)(-,5)(0,-)(-,-)", "(6,8x)(-,-)(2,-)(-,6)(2x,-)(-,-)", "(4,6x)(-,-)(4x,-)(-,5)(5,-)(-,-)", "(6x,8x)(-,-)(7,-)(-,1)(2,-)(-,-)", "(9,4x)(-,-)(4,-)(-,3x)(4,-)(-,-)", "(6,6)(-,-)(6,-)(-,6)(0,-)(-,-)", "(8,9x)(-,-)(2,-)(-,3)(2x,-)(-,-)", "(6x,4x)(-,-)(4,-)(-,6)(4,-)(-,-)", "(6,9x)(-,-)(6,-)(-,3x)(0,-)(-,-)", "(8,6)(-,-)(2,-)(-,3)(5,-)(-,-)", "(4,6x)(-,-)(7,-)(-,5)(2x,-)(-,-)", "(9,8x)(-,-)(4x,-)(-,1)(2,-)(-,-)", "(6x,4x)(-,-)(4,-)(-,5)(5,-)(-,-)", "(6,8x)(-,-)(7,-)(-,3x)(0,-)(-,-)", "(9,6)(-,-)(2,-)(-,3)(4,-)(-,-)", "(4,6x)(-,-)(6,-)(-,6)(2x,-)(-,-)", "(8,9x)(-,-)(4x,-)(-,1)(2,-)(-,-)", "(6,6)(-,-)(2,-)(-,6)(4,-)(-,-)", "(4,9x)(-,-)(6,-)(-,3)(2x,-)(-,-)", "(8,6x)(-,-)(4x,-)(-,1)(5,-)(-,-)", "(6x,4x)(-,-)(7,-)(-,5)(2,-)(-,-)", "(9,8x)(-,-)(4,-)(-,3x)(0,-)(-,-)", "(6,6)(-,-)(2,-)(-,5)(5,-)(-,-)", "(4,8x)(-,-)(7,-)(-,3)(2x,-)(-,-)", "(9,6x)(-,-)(4x,-)(-,1)(4,-)(-,-)", "(6x,4x)(-,-)(6,-)(-,6)(2,-)(-,-)", "(8,9x)(-,-)(4,-)(-,3x)(0,-)(-,-)");
# Invalid : "(4,6x)(-,-)(2,-)(-,5)(2x,-)(-,-)"

our @MHN_list_3_2_list2 = 
    (
     "(2,6x)(-,-)(1,-)(-,9x)(6,-)(-,-)", "(3,6)(-,-)(2,-)(-,5)(8,-)(-,-)", "(4,2x)(-,-)(4,-)(-,6)(8x,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,7)(4,-)(-,-)", "(6x,4x)(-,-)(0,-)(-,9)(5,-)(-,-)", "(2,6)(-,-)(1,-)(-,9)(6,-)(-,-)", "(3,6x)(-,-)(2,-)(-,5)(8x,-)(-,-)", "(4,2x)(-,-)(4x,-)(-,6)(8,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,7)(4,-)(-,-)", "(6,4x)(-,-)(0,-)(-,9x)(5,-)(-,-)", "(3,6x)(-,-)(2,-)(-,9x)(4,-)(-,-)", "(4,6)(-,-)(0,-)(-,6)(8,-)(-,-)", "(2,3x)(-,-)(4,-)(-,7)(8x,-)(-,-)", "(6,4x)(-,-)(4x,-)(-,5)(5,-)(-,-)", "(6x,2x)(-,-)(1,-)(-,9)(6,-)(-,-)", "(3,6)(-,-)(2,-)(-,9)(4,-)(-,-)", "(4,6x)(-,-)(0,-)(-,6)(8x,-)(-,-)", "(2,3x)(-,-)(4x,-)(-,7)(8,-)(-,-)", "(6x,4x)(-,-)(4,-)(-,5)(5,-)(-,-)", "(6,2x)(-,-)(1,-)(-,9x)(6,-)(-,-)", "(4,6x)(-,-)(0,-)(-,9x)(5,-)(-,-)", "(2,6)(-,-)(1,-)(-,7)(8,-)(-,-)", "(3,4x)(-,-)(4,-)(-,5)(8x,-)(-,-)", "(6,2x)(-,-)(4x,-)(-,6)(6,-)(-,-)", "(6x,3x)(-,-)(2,-)(-,9)(4,-)(-,-)", "(4,6)(-,-)(0,-)(-,9)(5,-)(-,-)", "(2,6x)(-,-)(1,-)(-,7)(8x,-)(-,-)", "(3,4x)(-,-)(4x,-)(-,5)(8,-)(-,-)", "(6x,2x)(-,-)(4,-)(-,6)(6,-)(-,-)", "(6,3x)(-,-)(2,-)(-,9x)(4,-)(-,-)", "(2,6x)(-,-)(2,-)(-,9x)(5,-)(-,-)", "(4,6)(-,-)(1,-)(-,5)(8,-)(-,-)", "(3,2x)(-,-)(4,-)(-,7)(8x,-)(-,-)", "(6,4x)(-,-)(4x,-)(-,6)(4,-)(-,-)", "(2,6)(-,-)(2,-)(-,9)(5,-)(-,-)", "(4,6x)(-,-)(1,-)(-,5)(8x,-)(-,-)", "(3,2x)(-,-)(4x,-)(-,7)(8,-)(-,-)", "(6x,4x)(-,-)(4,-)(-,6)(4,-)(-,-)", "(6,3x)(-,-)(0,-)(-,9x)(6,-)(-,-)", "(4,6x)(-,-)(1,-)(-,9x)(4,-)(-,-)", "(3,6)(-,-)(0,-)(-,7)(8,-)(-,-)", "(2,4x)(-,-)(4,-)(-,6)(8x,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(6x,2x)(-,-)(2,-)(-,9)(5,-)(-,-)", "(4,6)(-,-)(1,-)(-,9)(4,-)(-,-)", "(3,6x)(-,-)(0,-)(-,7)(8x,-)(-,-)", "(2,4x)(-,-)(4x,-)(-,6)(8,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,5)(6,-)(-,-)", "(6,2x)(-,-)(2,-)(-,9x)(5,-)(-,-)", "(3,6x)(-,-)(0,-)(-,9x)(6,-)(-,-)", "(2,6)(-,-)(2,-)(-,6)(8,-)(-,-)", "(4,3x)(-,-)(4,-)(-,5)(8x,-)(-,-)", "(6,2x)(-,-)(4x,-)(-,7)(5,-)(-,-)", "(6x,4x)(-,-)(1,-)(-,9)(4,-)(-,-)", "(3,6)(-,-)(0,-)(-,9)(6,-)(-,-)", "(2,6x)(-,-)(2,-)(-,6)(8x,-)(-,-)", "(4,3x)(-,-)(4x,-)(-,5)(8,-)(-,-)", "(6x,2x)(-,-)(4,-)(-,7)(5,-)(-,-)", "(6,4x)(-,-)(1,-)(-,9x)(4,-)(-,-)", "(2,4x)(-,-)(1,-)(-,9x)(8,-)(-,-)", "(3,6)(-,-)(4,-)(-,5)(6,-)(-,-)", "(6,2x)(-,-)(2,-)(-,6)(8x,-)(-,-)", "(4,3x)(-,-)(4x,-)(-,9)(4,-)(-,-)", "(6x,6x)(-,-)(0,-)(-,7)(5,-)(-,-)", "(2,4x)(-,-)(1,-)(-,9)(8x,-)(-,-)", "(3,6x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(6x,2x)(-,-)(2,-)(-,6)(8,-)(-,-)", "(4,3x)(-,-)(4,-)(-,9x)(4,-)(-,-)", "(6,6)(-,-)(0,-)(-,7)(5,-)(-,-)", "(3,2x)(-,-)(2,-)(-,9x)(8,-)(-,-)", "(4,6)(-,-)(4,-)(-,6)(4,-)(-,-)", "(6,3x)(-,-)(0,-)(-,7)(8x,-)(-,-)", "(2,4x)(-,-)(4x,-)(-,9)(5,-)(-,-)", "(6x,6x)(-,-)(1,-)(-,5)(6,-)(-,-)", "(3,2x)(-,-)(2,-)(-,9)(8x,-)(-,-)", "(4,6x)(-,-)(4x,-)(-,6)(4,-)(-,-)", "(6x,3x)(-,-)(0,-)(-,7)(8,-)(-,-)", "(2,4x)(-,-)(4,-)(-,9x)(5,-)(-,-)", "(6,6)(-,-)(1,-)(-,5)(6,-)(-,-)", "(4,3x)(-,-)(0,-)(-,9x)(8,-)(-,-)", "(2,6)(-,-)(4,-)(-,7)(5,-)(-,-)", "(6,4x)(-,-)(1,-)(-,5)(8x,-)(-,-)", "(3,2x)(-,-)(4x,-)(-,9)(6,-)(-,-)", "(6x,6x)(-,-)(2,-)(-,6)(4,-)(-,-)", "(4,3x)(-,-)(0,-)(-,9)(8x,-)(-,-)", "(2,6x)(-,-)(4x,-)(-,7)(5,-)(-,-)", "(6x,4x)(-,-)(1,-)(-,5)(8,-)(-,-)", "(3,2x)(-,-)(4,-)(-,9x)(6,-)(-,-)", "(6,6)(-,-)(2,-)(-,6)(4,-)(-,-)", "(2,6)(-,-)(2,-)(-,6)(8,-)(-,-)", "(4,3x)(-,-)(4,-)(-,5)(8x,-)(-,-)", "(6,2x)(-,-)(4x,-)(-,7)(5,-)(-,-)", "(6x,4x)(-,-)(1,-)(-,9)(4,-)(-,-)", "(3,6x)(-,-)(0,-)(-,9x)(6,-)(-,-)", "(2,3x)(-,-)(2,-)(-,9)(8x,-)(-,-)", "(4,6x)(-,-)(4x,-)(-,5)(5,-)(-,-)", "(6x,2x)(-,-)(1,-)(-,7)(8,-)(-,-)", "(3,4x)(-,-)(4,-)(-,9x)(4,-)(-,-)", "(6,6)(-,-)(0,-)(-,6)(6,-)(-,-)", "(4,2x)(-,-)(1,-)(-,9x)(8,-)(-,-)", "(3,6)(-,-)(4,-)(-,7)(4,-)(-,-)", "(6,4x)(-,-)(0,-)(-,6)(8x,-)(-,-)", "(2,3x)(-,-)(4x,-)(-,9)(6,-)(-,-)", "(6x,6x)(-,-)(2,-)(-,5)(5,-)(-,-)", "(4,2x)(-,-)(1,-)(-,9)(8x,-)(-,-)", "(3,6x)(-,-)(4x,-)(-,7)(4,-)(-,-)", "(6x,4x)(-,-)(0,-)(-,6)(8,-)(-,-)", "(2,3x)(-,-)(4,-)(-,9x)(6,-)(-,-)", "(6,6)(-,-)(2,-)(-,5)(5,-)(-,-)", "(3,4x)(-,-)(0,-)(-,9x)(8,-)(-,-)", "(2,6)(-,-)(4,-)(-,6)(6,-)(-,-)", "(6,3x)(-,-)(2,-)(-,5)(8x,-)(-,-)", "(4,2x)(-,-)(4x,-)(-,9)(5,-)(-,-)", "(6x,6x)(-,-)(1,-)(-,7)(4,-)(-,-)", "(3,4x)(-,-)(0,-)(-,9)(8x,-)(-,-)", "(2,6x)(-,-)(4x,-)(-,6)(6,-)(-,-)", "(6x,3x)(-,-)(2,-)(-,5)(8,-)(-,-)", "(4,2x)(-,-)(4,-)(-,9x)(5,-)(-,-)", "(6,6)(-,-)(1,-)(-,7)(4,-)(-,-)");
# "(2,3x)(-,-)(0,-)(-,9)(6,-)(-,-)"

our @MHN_list_3_2_list3 = 
    ("(3,8x)(-,-)(4,-)(-,7)(2x,-)(-,-)", "(6,Ax)(-,-)(4x,-)(-,0)(4,-)(-,-)", "(6x,3x)(-,-)(6,-)(-,3)(6,-)(-,-)", "(A,6)(-,-)(1,-)(-,5)(2,-)(-,-)", "(3,Ax)(-,-)(4,-)(-,5)(2x,-)(-,-)", "(6,8x)(-,-)(4x,-)(-,0)(6,-)(-,-)", "(6x,3x)(-,-)(8,-)(-,3)(4,-)(-,-)", "(8,6)(-,-)(1,-)(-,7)(2,-)(-,-)", "(6x,Ax)(-,-)(1,-)(-,3)(4,-)(-,-)", "(3,6x)(-,-)(6,-)(-,3x)(6,-)(-,-)", "(8,6)(-,-)(8,-)(-,0)(2,-)(-,-)", "(A,3x)(-,-)(4,-)(-,5)(2x,-)(-,-)", "(6x,8x)(-,-)(1,-)(-,3)(6,-)(-,-)", "(3,6x)(-,-)(8,-)(-,3x)(4,-)(-,-)", "(A,6)(-,-)(6,-)(-,0)(2,-)(-,-)", "(8,3x)(-,-)(4,-)(-,7)(2x,-)(-,-)", "(6x,8x)(-,-)(1,-)(-,7)(2,-)(-,-)", "(3,Ax)(-,-)(4,-)(-,3x)(4,-)(-,-)", "(6,6)(-,-)(6,-)(-,0)(6,-)(-,-)", "(8,3x)(-,-)(8,-)(-,3)(2x,-)(-,-)", "(6x,Ax)(-,-)(1,-)(-,5)(2,-)(-,-)", "(3,8x)(-,-)(4,-)(-,3x)(6,-)(-,-)", "(6,6)(-,-)(8,-)(-,0)(4,-)(-,-)", "(A,3x)(-,-)(6,-)(-,3)(2x,-)(-,-)", "(3,8x)(-,-)(4x,-)(-,7)(2,-)(-,-)", "(6x,Ax)(-,-)(4,-)(-,0)(4,-)(-,-)", "(6,3x)(-,-)(6,-)(-,3x)(6,-)(-,-)", "(3,Ax)(-,-)(4x,-)(-,5)(2,-)(-,-)", "(6x,8x)(-,-)(4,-)(-,0)(6,-)(-,-)", "(6,3x)(-,-)(8,-)(-,3x)(4,-)(-,-)", "(8,6x)(-,-)(1,-)(-,7)(2x,-)(-,-)", "(6,Ax)(-,-)(1,-)(-,3x)(4,-)(-,-)", "(3,6)(-,-)(6,-)(-,3)(6,-)(-,-)", "(8,6x)(-,-)(8,-)(-,0)(2x,-)(-,-)", "(A,3x)(-,-)(4x,-)(-,5)(2,-)(-,-)", "(6,8x)(-,-)(1,-)(-,3x)(6,-)(-,-)", "(3,6)(-,-)(8,-)(-,3)(4,-)(-,-)", "(A,6x)(-,-)(6,-)(-,0)(2x,-)(-,-)", "(8,3x)(-,-)(4x,-)(-,7)(2,-)(-,-)", "(6,8x)(-,-)(1,-)(-,7)(2x,-)(-,-)", "(3,Ax)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(6x,6x)(-,-)(6,-)(-,0)(6,-)(-,-)", "(8,3x)(-,-)(8,-)(-,3x)(2,-)(-,-)", "(6,Ax)(-,-)(1,-)(-,5)(2x,-)(-,-)", "(3,8x)(-,-)(4x,-)(-,3)(6,-)(-,-)", "(6x,6x)(-,-)(8,-)(-,0)(4,-)(-,-)", "(A,3x)(-,-)(6,-)(-,3x)(2,-)(-,-)", "(3,6)(-,-)(4,-)(-,7)(4,-)(-,-)", "(6,Ax)(-,-)(6,-)(-,0)(2x,-)(-,-)", "(8,3x)(-,-)(4x,-)(-,3)(6,-)(-,-)", "(A,8x)(-,-)(1,-)(-,3x)(2,-)(-,-)", "(3,6)(-,-)(4,-)(-,5)(6,-)(-,-)", "(6,8x)(-,-)(8,-)(-,0)(2x,-)(-,-)", "(A,3x)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(8,Ax)(-,-)(1,-)(-,3x)(2,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,7)(4,-)(-,-)", "(8,6x)(-,-)(1,-)(-,3x)(6,-)(-,-)", "(3,6)(-,-)(8,-)(-,5)(2,-)(-,-)", "(A,8x)(-,-)(4,-)(-,0)(2x,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(A,6x)(-,-)(1,-)(-,3x)(4,-)(-,-)", "(3,6)(-,-)(6,-)(-,7)(2,-)(-,-)", "(8,Ax)(-,-)(4,-)(-,0)(2x,-)(-,-)", "(6x,6x)(-,-)(1,-)(-,7)(4,-)(-,-)", "(3,Ax)(-,-)(6,-)(-,3x)(2,-)(-,-)", "(8,6)(-,-)(4,-)(-,0)(6,-)(-,-)", "(6,3x)(-,-)(8,-)(-,5)(2x,-)(-,-)", "(6x,6x)(-,-)(1,-)(-,5)(6,-)(-,-)", "(3,8x)(-,-)(8,-)(-,3x)(2,-)(-,-)", "(A,6)(-,-)(4,-)(-,0)(4,-)(-,-)", "(6,3x)(-,-)(6,-)(-,7)(2x,-)(-,-)", "(3,Ax)(-,-)(4x,-)(-,3)(4,-)(-,-)", "(6x,6x)(-,-)(6,-)(-,0)(6,-)(-,-)", "(8,3x)(-,-)(8,-)(-,3x)(2,-)(-,-)", "(6,8x)(-,-)(1,-)(-,7)(2x,-)(-,-)", "(3,6x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(6x,8x)(-,-)(8,-)(-,0)(2,-)(-,-)", "(A,3x)(-,-)(4,-)(-,3x)(4,-)(-,-)", "(8,Ax)(-,-)(1,-)(-,3)(2x,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,7)(4,-)(-,-)", "(8,6)(-,-)(1,-)(-,3)(6,-)(-,-)", "(3,6x)(-,-)(8,-)(-,5)(2x,-)(-,-)", "(A,8x)(-,-)(4x,-)(-,0)(2,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,5)(6,-)(-,-)", "(A,6)(-,-)(1,-)(-,3)(4,-)(-,-)", "(3,6x)(-,-)(6,-)(-,7)(2x,-)(-,-)", "(8,Ax)(-,-)(4x,-)(-,0)(2,-)(-,-)", "(6,6)(-,-)(1,-)(-,7)(4,-)(-,-)", "(3,Ax)(-,-)(6,-)(-,3)(2x,-)(-,-)", "(8,6x)(-,-)(4x,-)(-,0)(6,-)(-,-)", "(6x,3x)(-,-)(8,-)(-,5)(2,-)(-,-)", "(6,6)(-,-)(1,-)(-,5)(6,-)(-,-)", "(3,8x)(-,-)(8,-)(-,3)(2x,-)(-,-)", "(A,6x)(-,-)(4x,-)(-,0)(4,-)(-,-)", "(6x,3x)(-,-)(6,-)(-,7)(2,-)(-,-)");
# "(3,6x)(-,-)(1,-)(-,5)(2x,-)(-,-)"

our @MHN_list_3_2_list4 = 
    ("(2,6x)(-,-)(7,-)(-,3x)(6,-)(-,-)", "(3,0)(-,-)(8,-)(-,5)(8,-)(-,-)", "(4,2x)(-,-)(A,-)(-,6)(2x,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,7)(4,-)(-,-)", "(2,4x)(-,-)(7,-)(-,3x)(8,-)(-,-)", "(3,0)(-,-)(A,-)(-,5)(6,-)(-,-)", "(6,2x)(-,-)(8,-)(-,6)(2x,-)(-,-)", "(4,3x)(-,-)(4x,-)(-,9)(4,-)(-,-)", "(2,4x)(-,-)(7,-)(-,9)(2x,-)(-,-)", "(3,6x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(4,3x)(-,-)(A,-)(-,3x)(4,-)(-,-)", "(6,0)(-,-)(6,-)(-,7)(5,-)(-,-)", "(2,6x)(-,-)(7,-)(-,7)(2x,-)(-,-)", "(3,4x)(-,-)(4x,-)(-,5)(8,-)(-,-)", "(6,3x)(-,-)(8,-)(-,3x)(4,-)(-,-)", "(4,0)(-,-)(6,-)(-,9)(5,-)(-,-)", "(3,4x)(-,-)(4x,-)(-,9)(4,-)(-,-)", "(2,3x)(-,-)(8,-)(-,3x)(8,-)(-,-)", "(4,0)(-,-)(A,-)(-,5)(5,-)(-,-)", "(6,2x)(-,-)(7,-)(-,7)(2x,-)(-,-)", "(3,6x)(-,-)(4x,-)(-,7)(4,-)(-,-)", "(2,3x)(-,-)(A,-)(-,3x)(6,-)(-,-)", "(6,0)(-,-)(8,-)(-,5)(5,-)(-,-)", "(4,2x)(-,-)(7,-)(-,9)(2x,-)(-,-)", "(3,6x)(-,-)(6,-)(-,3x)(6,-)(-,-)", "(2,0)(-,-)(8,-)(-,6)(8,-)(-,-)", "(4,3x)(-,-)(A,-)(-,5)(2x,-)(-,-)", "(3,4x)(-,-)(6,-)(-,3x)(8,-)(-,-)", "(2,0)(-,-)(A,-)(-,6)(6,-)(-,-)", "(6,3x)(-,-)(8,-)(-,5)(2x,-)(-,-)", "(4,2x)(-,-)(4x,-)(-,9)(5,-)(-,-)", "(3,4x)(-,-)(6,-)(-,9)(2x,-)(-,-)", "(2,6x)(-,-)(4x,-)(-,6)(6,-)(-,-)", "(4,2x)(-,-)(A,-)(-,3x)(5,-)(-,-)", "(6,0)(-,-)(7,-)(-,7)(4,-)(-,-)", "(3,6x)(-,-)(6,-)(-,7)(2x,-)(-,-)", "(2,4x)(-,-)(4x,-)(-,6)(8,-)(-,-)", "(6,2x)(-,-)(8,-)(-,3x)(5,-)(-,-)", "(4,0)(-,-)(7,-)(-,9)(4,-)(-,-)", "(2,4x)(-,-)(4x,-)(-,9)(5,-)(-,-)", "(3,2x)(-,-)(8,-)(-,3x)(8,-)(-,-)", "(4,0)(-,-)(A,-)(-,6)(4,-)(-,-)", "(6,3x)(-,-)(6,-)(-,7)(2x,-)(-,-)", "(2,6x)(-,-)(4x,-)(-,7)(5,-)(-,-)", "(3,2x)(-,-)(A,-)(-,3x)(6,-)(-,-)", "(6,0)(-,-)(8,-)(-,6)(4,-)(-,-)", "(4,3x)(-,-)(6,-)(-,9)(2x,-)(-,-)", "(2,6x)(-,-)(8,-)(-,3x)(5,-)(-,-)", "(4,0)(-,-)(7,-)(-,5)(8,-)(-,-)", "(3,2x)(-,-)(A,-)(-,7)(2x,-)(-,-)", "(6,4x)(-,-)(4x,-)(-,6)(4,-)(-,-)", "(2,4x)(-,-)(A,-)(-,3x)(5,-)(-,-)", "(6,0)(-,-)(7,-)(-,5)(6,-)(-,-)", "(3,2x)(-,-)(8,-)(-,9)(2x,-)(-,-)", "(4,6x)(-,-)(4x,-)(-,6)(4,-)(-,-)", "(2,0)(-,-)(7,-)(-,9)(6,-)(-,-)", "(3,6x)(-,-)(8,-)(-,5)(2x,-)(-,-)", "(4,2x)(-,-)(4x,-)(-,6)(8,-)(-,-)", "(6,4x)(-,-)(6,-)(-,3x)(5,-)(-,-)", "(2,0)(-,-)(7,-)(-,7)(8,-)(-,-)", "(3,4x)(-,-)(A,-)(-,5)(2x,-)(-,-)", "(6,2x)(-,-)(4x,-)(-,6)(6,-)(-,-)", "(4,6x)(-,-)(6,-)(-,3x)(5,-)(-,-)", "(3,2x)(-,-)(4x,-)(-,9)(6,-)(-,-)", "(4,3x)(-,-)(6,-)(-,3x)(8,-)(-,-)", "(2,0)(-,-)(A,-)(-,7)(5,-)(-,-)", "(6,4x)(-,-)(7,-)(-,5)(2x,-)(-,-)", "(3,2x)(-,-)(4x,-)(-,7)(8,-)(-,-)", "(6,3x)(-,-)(6,-)(-,3x)(6,-)(-,-)", "(2,0)(-,-)(8,-)(-,9)(5,-)(-,-)", "(4,6x)(-,-)(7,-)(-,5)(2x,-)(-,-)", "(3,2x)(-,-)(8,-)(-,3x)(8,-)(-,-)", "(4,0)(-,-)(A,-)(-,6)(4,-)(-,-)", "(6,3x)(-,-)(6,-)(-,7)(2x,-)(-,-)", "(2,4x)(-,-)(4x,-)(-,9)(5,-)(-,-)", "(3,4x)(-,-)(A,-)(-,3x)(4,-)(-,-)", "(6,0)(-,-)(6,-)(-,6)(6,-)(-,-)", "(2,3x)(-,-)(8,-)(-,9)(2x,-)(-,-)", "(4,6x)(-,-)(4x,-)(-,5)(5,-)(-,-)", "(3,0)(-,-)(6,-)(-,9)(6,-)(-,-)", "(2,6x)(-,-)(8,-)(-,6)(2x,-)(-,-)", "(4,3x)(-,-)(4x,-)(-,5)(8,-)(-,-)", "(6,4x)(-,-)(7,-)(-,3x)(4,-)(-,-)", "(3,0)(-,-)(6,-)(-,7)(8,-)(-,-)", "(2,4x)(-,-)(A,-)(-,6)(2x,-)(-,-)", "(6,3x)(-,-)(4x,-)(-,5)(6,-)(-,-)", "(4,6x)(-,-)(7,-)(-,3x)(4,-)(-,-)", "(2,3x)(-,-)(4x,-)(-,9)(6,-)(-,-)", "(4,2x)(-,-)(7,-)(-,3x)(8,-)(-,-)", "(3,0)(-,-)(A,-)(-,7)(4,-)(-,-)", "(6,4x)(-,-)(6,-)(-,6)(2x,-)(-,-)", "(2,3x)(-,-)(4x,-)(-,7)(8,-)(-,-)", "(6,2x)(-,-)(7,-)(-,3x)(6,-)(-,-)", "(3,0)(-,-)(8,-)(-,9)(4,-)(-,-)", "(4,6x)(-,-)(6,-)(-,6)(2x,-)(-,-)");

our @MHN_list_3_2_list5 =
    ("(0,4x)(-,-)(6,-)(-,9x)(5,-)(-,-)", "(2,6)(-,-)(7,-)(-,3)(6,-)(-,-)", "(4,2x)(-,-)(Ax,-)(-,6)(2,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,7)(4,-)(-,-)", "(0,6)(-,-)(6,-)(-,7)(5,-)(-,-)", "(2,4x)(-,-)(7,-)(-,3)(8x,-)(-,-)", "(6x,2x)(-,-)(8,-)(-,6)(2,-)(-,-)", "(4,3x)(-,-)(4,-)(-,9x)(4,-)(-,-)", "(2,4x)(-,-)(7,-)(-,9x)(2,-)(-,-)", "(3,6)(-,-)(4,-)(-,5)(6,-)(-,-)", "(0,2x)(-,-)(8,-)(-,6)(8x,-)(-,-)", "(4,3x)(-,-)(Ax,-)(-,3)(4,-)(-,-)", "(2,6)(-,-)(7,-)(-,7)(2,-)(-,-)", "(3,4x)(-,-)(4,-)(-,5)(8x,-)(-,-)", "(0,2x)(-,-)(Ax,-)(-,6)(6,-)(-,-)", "(6x,3x)(-,-)(8,-)(-,3)(4,-)(-,-)", "(3,4x)(-,-)(4,-)(-,9x)(4,-)(-,-)", "(0,6)(-,-)(6,-)(-,6)(6,-)(-,-)", "(2,3x)(-,-)(8,-)(-,3)(8x,-)(-,-)", "(6x,2x)(-,-)(7,-)(-,7)(2,-)(-,-)", "(3,6)(-,-)(4,-)(-,7)(4,-)(-,-)", "(0,4x)(-,-)(6,-)(-,6)(8x,-)(-,-)", "(2,3x)(-,-)(Ax,-)(-,3)(6,-)(-,-)", "(4,2x)(-,-)(7,-)(-,9x)(2,-)(-,-)", "(0,4x)(-,-)(7,-)(-,9x)(4,-)(-,-)", "(3,6)(-,-)(6,-)(-,3)(6,-)(-,-)", "(4,3x)(-,-)(Ax,-)(-,5)(2,-)(-,-)", "(0,6)(-,-)(7,-)(-,7)(4,-)(-,-)", "(3,4x)(-,-)(6,-)(-,3)(8x,-)(-,-)", "(6x,3x)(-,-)(8,-)(-,5)(2,-)(-,-)", "(4,2x)(-,-)(4,-)(-,9x)(5,-)(-,-)", "(3,4x)(-,-)(6,-)(-,9x)(2,-)(-,-)", "(2,6)(-,-)(4,-)(-,6)(6,-)(-,-)", "(0,3x)(-,-)(8,-)(-,5)(8x,-)(-,-)", "(4,2x)(-,-)(Ax,-)(-,3)(5,-)(-,-)", "(3,6)(-,-)(6,-)(-,7)(2,-)(-,-)", "(2,4x)(-,-)(4,-)(-,6)(8x,-)(-,-)", "(0,3x)(-,-)(Ax,-)(-,5)(6,-)(-,-)", "(6x,2x)(-,-)(8,-)(-,3)(5,-)(-,-)", "(2,4x)(-,-)(4,-)(-,9x)(5,-)(-,-)", "(0,6)(-,-)(7,-)(-,5)(6,-)(-,-)", "(3,2x)(-,-)(8,-)(-,3)(8x,-)(-,-)", "(6x,3x)(-,-)(6,-)(-,7)(2,-)(-,-)", "(2,6)(-,-)(4,-)(-,7)(5,-)(-,-)", "(0,4x)(-,-)(7,-)(-,5)(8x,-)(-,-)", "(3,2x)(-,-)(Ax,-)(-,3)(6,-)(-,-)", "(4,3x)(-,-)(6,-)(-,9x)(2,-)(-,-)", "(0,3x)(-,-)(6,-)(-,9x)(6,-)(-,-)", "(2,6)(-,-)(8,-)(-,3)(5,-)(-,-)", "(3,2x)(-,-)(Ax,-)(-,7)(2,-)(-,-)", "(6x,4x)(-,-)(4,-)(-,6)(4,-)(-,-)", "(0,3x)(-,-)(6,-)(-,7)(8x,-)(-,-)", "(2,4x)(-,-)(Ax,-)(-,3)(5,-)(-,-)", "(3,2x)(-,-)(8,-)(-,9x)(2,-)(-,-)", "(4,6)(-,-)(4,-)(-,6)(4,-)(-,-)", "(3,6)(-,-)(8,-)(-,5)(2,-)(-,-)", "(4,2x)(-,-)(4,-)(-,6)(8x,-)(-,-)", "(0,3x)(-,-)(Ax,-)(-,7)(4,-)(-,-)", "(6x,4x)(-,-)(6,-)(-,3)(5,-)(-,-)", "(3,4x)(-,-)(Ax,-)(-,5)(2,-)(-,-)", "(6x,2x)(-,-)(4,-)(-,6)(6,-)(-,-)", "(0,3x)(-,-)(8,-)(-,9x)(4,-)(-,-)", "(4,6)(-,-)(6,-)(-,3)(5,-)(-,-)", "(3,2x)(-,-)(4,-)(-,9x)(6,-)(-,-)", "(0,6)(-,-)(8,-)(-,6)(4,-)(-,-)", "(4,3x)(-,-)(6,-)(-,3)(8x,-)(-,-)", "(6x,4x)(-,-)(7,-)(-,5)(2,-)(-,-)", "(3,2x)(-,-)(4,-)(-,7)(8x,-)(-,-)", "(0,4x)(-,-)(Ax,-)(-,6)(4,-)(-,-)", "(6x,3x)(-,-)(6,-)(-,3)(6,-)(-,-)", "(4,6)(-,-)(7,-)(-,5)(2,-)(-,-)", "(0,6)(-,-)(7,-)(-,5)(6,-)(-,-)", "(3,2x)(-,-)(8,-)(-,3)(8x,-)(-,-)", "(6x,3x)(-,-)(6,-)(-,7)(2,-)(-,-)", "(2,4x)(-,-)(4,-)(-,9x)(5,-)(-,-)", "(0,2x)(-,-)(7,-)(-,7)(8x,-)(-,-)", "(3,4x)(-,-)(Ax,-)(-,3)(4,-)(-,-)", "(2,3x)(-,-)(8,-)(-,9x)(2,-)(-,-)", "(4,6)(-,-)(4,-)(-,5)(5,-)(-,-)", "(2,6)(-,-)(8,-)(-,6)(2,-)(-,-)", "(4,3x)(-,-)(4,-)(-,5)(8x,-)(-,-)", "(0,2x)(-,-)(Ax,-)(-,7)(5,-)(-,-)", "(6x,4x)(-,-)(7,-)(-,3)(4,-)(-,-)", "(2,4x)(-,-)(Ax,-)(-,6)(2,-)(-,-)", "(6x,3x)(-,-)(4,-)(-,5)(6,-)(-,-)", "(0,2x)(-,-)(8,-)(-,9x)(5,-)(-,-)", "(4,6)(-,-)(7,-)(-,3)(4,-)(-,-)", "(2,3x)(-,-)(4,-)(-,9x)(6,-)(-,-)", "(0,6)(-,-)(8,-)(-,5)(5,-)(-,-)", "(4,2x)(-,-)(7,-)(-,3)(8x,-)(-,-)", "(6x,4x)(-,-)(6,-)(-,6)(2,-)(-,-)", "(2,3x)(-,-)(4,-)(-,7)(8x,-)(-,-)", "(0,4x)(-,-)(Ax,-)(-,5)(5,-)(-,-)", "(6x,2x)(-,-)(7,-)(-,3)(6,-)(-,-)", "(4,6)(-,-)(6,-)(-,6)(2,-)(-,-)");
# "(0,2x)(-,-)(4,-)(-,7)(5,-)(-,-)"

our @MHN_list_3_2_list6 =
    ("(2,Cx)(-,-)(1,-)(-,9x)(0,-)(-,-)", "(4,2x)(-,-)(A,-)(-,0)(8x,-)(-,-)", "(2,C)(-,-)(1,-)(-,9)(0,-)(-,-)", "(4,2x)(-,-)(Ax,-)(-,0)(8,-)(-,-)", "(4,C)(-,-)(0,-)(-,0)(8,-)(-,-)", "(2,3x)(-,-)(A,-)(-,1)(8x,-)(-,-)", "(Cx,2x)(-,-)(1,-)(-,9)(0,-)(-,-)", "(4,Cx)(-,-)(0,-)(-,0)(8x,-)(-,-)", "(2,3x)(-,-)(Ax,-)(-,1)(8,-)(-,-)", "(C,2x)(-,-)(1,-)(-,9x)(0,-)(-,-)", "(2,C)(-,-)(1,-)(-,1)(8,-)(-,-)", "(C,2x)(-,-)(Ax,-)(-,0)(0,-)(-,-)", "(2,Cx)(-,-)(1,-)(-,1)(8x,-)(-,-)", "(Cx,2x)(-,-)(A,-)(-,0)(0,-)(-,-)", "(3,2x)(-,-)(A,-)(-,1)(8x,-)(-,-)", "(3,2x)(-,-)(Ax,-)(-,1)(8,-)(-,-)", "(C,3x)(-,-)(0,-)(-,9x)(0,-)(-,-)", "(3,C)(-,-)(0,-)(-,1)(8,-)(-,-)", "(2,4x)(-,-)(A,-)(-,0)(8x,-)(-,-)", "(3,Cx)(-,-)(0,-)(-,1)(8x,-)(-,-)", "(2,4x)(-,-)(Ax,-)(-,0)(8,-)(-,-)", "(3,Cx)(-,-)(0,-)(-,9x)(0,-)(-,-)", "(2,C)(-,-)(2,-)(-,0)(8,-)(-,-)", "(3,C)(-,-)(0,-)(-,9)(0,-)(-,-)", "(2,Cx)(-,-)(2,-)(-,0)(8x,-)(-,-)", "(2,4x)(-,-)(1,-)(-,9x)(8,-)(-,-)", "(C,2x)(-,-)(2,-)(-,0)(8x,-)(-,-)", "(2,4x)(-,-)(1,-)(-,9)(8x,-)(-,-)", "(Cx,2x)(-,-)(2,-)(-,0)(8,-)(-,-)", "(3,2x)(-,-)(2,-)(-,9x)(8,-)(-,-)", "(C,3x)(-,-)(0,-)(-,1)(8x,-)(-,-)", "(3,2x)(-,-)(2,-)(-,9)(8x,-)(-,-)", "(Cx,3x)(-,-)(0,-)(-,1)(8,-)(-,-)", "(4,3x)(-,-)(0,-)(-,9x)(8,-)(-,-)", "(3,2x)(-,-)(Ax,-)(-,9)(0,-)(-,-)", "(4,3x)(-,-)(0,-)(-,9)(8x,-)(-,-)", "(3,2x)(-,-)(A,-)(-,9x)(0,-)(-,-)", "(2,C)(-,-)(2,-)(-,0)(8,-)(-,-)", "(3,Cx)(-,-)(0,-)(-,9x)(0,-)(-,-)", "(2,3x)(-,-)(2,-)(-,9)(8x,-)(-,-)", "(Cx,2x)(-,-)(1,-)(-,1)(8,-)(-,-)", "(C,C)(-,-)(0,-)(-,0)(0,-)(-,-)", "(4,2x)(-,-)(1,-)(-,9x)(8,-)(-,-)", "(C,4x)(-,-)(0,-)(-,0)(8x,-)(-,-)", "(2,3x)(-,-)(Ax,-)(-,9)(0,-)(-,-)", "(4,2x)(-,-)(1,-)(-,9)(8x,-)(-,-)", "(Cx,4x)(-,-)(0,-)(-,0)(8,-)(-,-)", "(2,3x)(-,-)(A,-)(-,9x)(0,-)(-,-)", "(3,4x)(-,-)(0,-)(-,9x)(8,-)(-,-)", "(2,C)(-,-)(A,-)(-,0)(0,-)(-,-)", "(3,4x)(-,-)(0,-)(-,9)(8x,-)(-,-)", "(2,Cx)(-,-)(Ax,-)(-,0)(0,-)(-,-)");
# "(2,3x)(-,-)(0,-)(-,9)(0,-)(-,-)"


our @MHN_list_3_2_list7 = ();
push @MHN_list_3_2_list7, @MHN_list_3_2_list1;
push @MHN_list_3_2_list7, @MHN_list_3_2_list2;
push @MHN_list_3_2_list7, @MHN_list_3_2_list3;
push @MHN_list_3_2_list7, @MHN_list_3_2_list4;
push @MHN_list_3_2_list7, @MHN_list_3_2_list5;
push @MHN_list_3_2_list7, @MHN_list_3_2_list6;



#
# gen an HTML header with defined styles", "#
# $_[0] : HTML File
# $_[1] : Title
sub gen_HTML_head1
{
    my $f=$_[0];
    
    open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;	
    print HTML "<HEAD>\n";
    print HTML "<TITLE>".$_[1]."</TITLE>\n";
    print HTML "<STYLE type=\"text/css\">\n";	
    print HTML ".table_header\n";
    print HTML "{padding-top:1px;\n";
    print HTML "padding-right:1px;\n";
    print HTML "padding-left:1px;\n";
    print HTML "mso-ignore:padding;\n";
    print HTML "color:windowtext;\n";
    print HTML "font-size:11.0pt;\n";
    print HTML "font-weight:700;\n";
    print HTML "font-style:normal;\n";
    print HTML "text-decoration:none;\n";
    print HTML "font-family:Calibri, sans-serif;\n";
    print HTML "mso-font-charset:0;\n";
    print HTML "mso-number-format:General;\n";
    print HTML "text-align:center;\n";
    print HTML "vertical-align:middle;\n";
    print HTML "border:.5pt solid windowtext;\n";
    print HTML "background:#00B0F0;\n";
    print HTML "mso-pattern:black none;\n";
    print HTML "white-space:nowrap;}\n";
    print HTML "\n";
    print HTML ".table_content\n";
    print HTML "{padding-top:1px;\n";
    print HTML "padding-right:1px;\n";
    print HTML "padding-left:1px;\n";
    print HTML "mso-ignore:padding;\n";
    print HTML "color:windowtext;\n";
    print HTML "font-size:11.0pt;\n";
    print HTML "font-weight:700;\n";
    print HTML "font-style:normal;\n";
    print HTML "text-decoration:none;\n";
    print HTML "font-family:Calibri, sans-serif;\n";
    print HTML "mso-font-charset:0;\n";
    print HTML "mso-number-format:General;\n";
    print HTML "text-align:center;\n";
    print HTML "vertical-align:middle;\n";
    print HTML "border:.5pt solid windowtext;\n";
    print HTML "background:yellow;\n";
    print HTML "mso-pattern:black none;\n";
    print HTML "white-space:nowrap;}\n";
    print HTML "</STYLE>\n";
    print HTML "</HEAD>\n";
    print HTML "\n";
    close HTML;
}

1;