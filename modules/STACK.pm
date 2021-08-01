#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## STACK.pm   - Stack Notation for jugglingTB                               ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015-2020  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package STACK;
use common;
use strict;
use lang;
use Term::ANSIColor;        

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $STACK_INFO = "STACK juggling Notation";
our $STACK_HELP = "";
our $STACK_VERSION = "v0.0";

our %STACK_CMDS = 
    (    
	# 'cmd1'                  => ["cmd1hlp1","cmd1hlp2"], 		        
    );

print "STACK $STACK::STACK_VERSION loaded\n";

# To add debug behaviour 
our $STACK_DEBUG=-1;


# sub cmd1
# {
#     print colored [$common::COLOR_RESULT], "This is the Cmd1 Result\n";
# }




1;
