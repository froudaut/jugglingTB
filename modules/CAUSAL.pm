#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## CAUSAL.pm   - Causal Diagram for jugglingTB                              ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015-2022  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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


package CAUSAL;
use common;
use strict;
use lang;
use Cwd;
use Term::ANSIColor;        
use Chart::Gnuplot;
use Getopt::Long qw(GetOptionsFromString);

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $CAUSAL_INFO = "Causal Diagram";
our $CAUSAL_HELP = $lang::MSG_CAUSAL_MENU_HELP;
our $CAUSAL_VERSION = "v0.1";

our %CAUSAL_CMDS = 
    (    
	 'causalEditor'              => ["$lang::MSG_CAUSAL_MENU_CAUSALEDITOR_1", "$lang::MSG_CAUSAL_MENU_CAUSALEDITOR_2"],
    );

print "CAUSAL $CAUSAL::CAUSAL_VERSION loaded\n";

# To add debug behaviour 
our $CAUSAL_DEBUG=-1;


sub causalEditor
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/CausalDiagramEditor/CausalDiagramEditor.htm");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/CausalDiagramEditor/CausalDiagramEditor.htm &");
    }
}

1;
