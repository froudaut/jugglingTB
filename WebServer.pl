#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## WebServer.pl   - WebServer for jugglingTB                                ##
##                  used by Module SPYRO                                    ##
##                                                                          ##
## Copyright (C) 2020  Frederic Roudaut  <frederic.roudaut@free.fr>         ##
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

package WebServer;
use strict;
use lang;
use Term::ANSIColor;        

use HTTP::Server::Simple::CGI;
use base qw[HTTP::Server::Simple::CGI];
use File::Slurp; # import read_file

if ($#ARGV != 1)
{
    exit -1;
}

my $PATH_BASE = $ARGV[0];
my $HTTP_PORT = $ARGV[1];

my $WebServerPid = -1;

sub serve_file { 

    my $path_relative = shift;
    $path_relative = "${PATH_BASE}${path_relative}";
    my $content_type  = shift;
    my $nl = "\x0d\x0a";
    
    print "HTTP/1.0 200 OK$nl";
    print "Content-Type: $content_type; charset=utf-8$nl$nl";

    print STDERR "WebServer : Serve File: $path_relative\n";

    if (-e $path_relative) {
	#	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_1;
	print read_file($path_relative, binmode => ":raw");
    }
    else {
	print STDERR "WebServer : $path_relative not found\n"; 
    }
}


sub handle_request {

    my $self = shift;
    my $cgi  = shift;
    my $path = $cgi->path_info();
    
    if ($path eq '/') {
	serve_file ("index.html", 'text/html');
	return;
    }
    
    if ($path =~ /\.htm$/  or $path =~ /\.html$/) {
	serve_file (".$path", 'text/html');
	return;
    }
    if ($path =~ /\.txt$/) {
	serve_file (".$path", 'text/plain');
	return;
    }
    if ($path =~ /\.js$/ ) {
	serve_file (".$path", 'application/javascript');
	return;
    }
    if ($path =~ /\.js$/ ) {
	serve_file (".$path", 'application/javascript');
	return;
    }
    if ($path =~ /\.png$/) {
	serve_file (".$path", 'image/png');
	return;
    }
    if ($path =~ /\.jpg$/ or $path =~ /\.jpeg/) {
	serve_file (".$path", 'image/jpeg');
	return;
    }
    if ($path =~ /\.gif/) {
	serve_file (".$path", 'image/gif');
	return;
    }
    if ($path =~ /\.xml/) {
	serve_file (".$path", 'application/xml');
	return;
    }
    if ($path =~ /\.ico$/) {
	serve_file (".$path", 'image/x-icon');
	return;
    }
    
    print STDERR "Unknown Mime type for $path\n";
    serve_file( ".$path", 'text/plain');		
    # print join "\n", glob('*');    
}    


$WebServerPid = WebServer->new($HTTP_PORT)->background();


1;
