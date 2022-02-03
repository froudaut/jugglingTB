#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## MODTEST.pm   - Module Example for jugglingTB                             ##
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

package MODTEST;
use common;
use strict;
use lang;
use Term::ANSIColor;        

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $MODTEST_INFO = "MODTEST juggling Notation";
our $MODTEST_HELP = "Test Module";
our $MODTEST_VERSION = "v1.2";

our %MODTEST_CMDS = 
    (    
	 'cmd1'                  => ["cmd1hlp1","cmd1hlp2"], 			 
	 'cmd2'                  => ["cmd1hlp1","cmd1hlp2"],
    );

print "MODTEST $MODTEST::MODTEST_VERSION loaded\n";

# To add debug behaviour 
our $MODTEST_DEBUG=-1;


sub cmd1
{
    print colored [$common::COLOR_RESULT], "This is the Cmd1 Result\n";
}


sub cmd2
{
    print colored [$common::COLOR_RESULT], "This is the Cmd2 Result\n";
}





1;
