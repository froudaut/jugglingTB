#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## SPYRO.pm   - Module SPYRO for jugglingTB                                 ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015-2021  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package SPYRO;
use common;
use strict;
use lang;
use Term::ANSIColor;        
use Cwd;
use File::Copy::Recursive qw(fcopy rcopy dircopy fmove rmove dirmove);


$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $SPYRO_INFO = "Juggling SPYROGRAPH";
our $SPYRO_HELP = $lang::MSG_SPYRO_MENU_HELP;
our $SPYRO_VERSION = "v0.3";

our %SPYRO_CMDS = 
    (    
	 'anim'                  => ["$lang::MSG_SPYRO_MENU_ANIMATE_1","$lang::MSG_SPYRO_MENU_ANIMATE_2"],
	 'staffSimMCP'           => ["$lang::MSG_SPYRO_MENU_STAFFSIMMCP_1","$lang::MSG_SPYRO_MENU_STAFFSIMMCP_2"],  
    );

print "SPYRO $SPYRO::SPYRO_VERSION loaded\n";

# To add debug behaviour 
our $SPYRO_DEBUG=-1;


my $JSPYRO_PATH="./data/jugglespyro-v1.3";


# sub anim_flash
# {
#     my $pwd = cwd();
    
#     my $default_scene="demo.xml";
#     rcopy("${JSPYRO_PATH}/flash/*",$conf::TMPDIR);	    	   
#     rcopy("${JSPYRO_PATH}/flash/sample/*",$conf::TMPDIR);	    	   
    
#     my $SPYRO_HTTPD_PORT = 8181;
#     if(scalar @_ >= 1)
#     {
# 	$SPYRO_HTTPD_PORT = $_[0];
#     }

#     if(scalar @_ >= 2)
#     {
# 	$default_scene = $_[1];
# 	open(FILE,"> $conf::TMPDIR/juggleSpyro.html") || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR/juggleSpyro.html> $lang::MSG_GENERAL_ERR1b"); 
	
# 	print FILE "<embed src=\"jugglespyro-v1.3.swf\" quality=\"high\" bgcolor=\"#000000\" width=\"800\" height=\"600\" name=\"jugglespyro-v1.3.swf\" align=\"middle\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" allowfullscreen=\"true\" FlashVars=\"&scenario=".$default_scene."&help=__help/__help.html&background=0x99ff66&go=two_sync\" style=\"position:absolute\"/>";
	
# 	close(FILE);
#     }

#     my $PATH_BASE = "$conf::TMPDIR/";
	    
#     # start the server	
#     if ($common::OS eq "MSWin32") {	    
# 	system("start /b cmd /c perl -I . WebServer.pl $PATH_BASE $SPYRO_HTTPD_PORT");	  	    
# 	sleep(2);
# 	system("start /b cmd /c \"$conf::HTTP_BROWSER\" http://localhost:${SPYRO_HTTPD_PORT}/juggleSpyro.html");
#     } else {
# 	# Unix-like OS
# 	system("start /b cmd /c perl -I . WebServer.pl $PATH_BASE $SPYRO_HTTPD_PORT");	  	    
# 	sleep(2);
# 	system("$conf::HTTP_BROWSER http://localhost:${SPYRO_HTTPD_PORT}/juggleSpyro.html &");
#     }
	
# }



sub anim
{
    my $pwd = cwd();
  	    
    my $PATH_BASE = "$JSPYRO_PATH/html5/";
    my $SPYRO_HTTPD_PORT = 8182;
    if(scalar @_ >= 1)
    {
	$SPYRO_HTTPD_PORT = $_[0];
    }
    
    # start the server	
    if ($common::OS eq "MSWin32") {	    
	system("start /b cmd /c perl -I . WebServer.pl $PATH_BASE $SPYRO_HTTPD_PORT");	  	    
	sleep(2);
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" http://localhost:${SPYRO_HTTPD_PORT}/");
    } else {
	# Unix-like OS
	system("start /b cmd /c perl -I . WebServer.pl $PATH_BASE $SPYRO_HTTPD_PORT");	  	    
	sleep(2);
	system("$conf::HTTP_BROWSER http://localhost:${SPYRO_HTTPD_PORT}/ &");
    }

}    


sub staffSimMCP
    #Run LAB INFINITE by MCP / Andrey
{
    my $pwd = cwd();

    rcopy("data//LABinfinite/*",$conf::TMPDIR);	    	   
    if ($common::OS eq "MSWin32") {
	chdir $conf::TMPDIR;
	system("$conf::JAVA_CMD -jar LABinfinite.jar &");
	chdir "..";	
    } else {
	# Unix-like OS
	chdir $conf::TMPDIR;
	system("$conf::JAVA_CMD -jar LABinfinite.jar &");
	chdir "..";
    }
}



1;
