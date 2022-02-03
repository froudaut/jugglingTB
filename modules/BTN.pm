#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## BTN.pm   -   Perl Implementation of the BTN juggling Notation            ##
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

package BTN;
use common;
use lang;
use Set::Scalar;
use strict;
use Term::ANSIColor;        

$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

our $BTN_INFO = "BTN juggling Notation";
our $BTN_HELP = $lang::MSG_BTN_MENU_HELP;
our $BTN_VERSION = "v1.2.2";

our %BTN_CMDS = 
    (    
	 'gen' => [$lang::MSG_BTN_MENU_GENTHROWS_1, $lang::MSG_BTN_MENU_GENTHROWS_2],
	 'gen2' => [$lang::MSG_BTN_MENU_GENTHROWS2_1, $lang::MSG_BTN_MENU_GENTHROWS_2],
	 'size' => [$lang::MSG_BTN_MENU_SIZE_1, $lang::MSG_BTN_MENU_SIZE_2],
	 'inv' => [$lang::MSG_BTN_MENU_TIMEREVERSED_1, $lang::MSG_BTN_MENU_TIMEREVERSED_2],
	 'isValid' => [$lang::MSG_BTN_MENU_ISVALID_1, $lang::MSG_BTN_MENU_ISVALID_2],
	 'BTNParity' => [$lang::MSG_BTN_MENU_BTNPARITY_1, $lang::MSG_BTN_MENU_BTNPARITY_2],
    );

print "BTN $BTN::BTN_VERSION loaded\n";

# To add debug behaviour 
our $BTN_DEBUG=-1;


my @plane = ("Front", "Back");
my @globHoles = ("rHoles", "lHoles", "oHoles");
my @rHoles = ("AC", "AL");
my @lHoles = ("AC", "AL");
my @oHoles = ("BOL");
my @operator = ("OP");
my $spaceResult = 30;



sub __genBTNThrows {

    my $nbLoops = $_[0];
    my $side = $_[1];
    my $path = $_[2];
    my $pathsize = $_[3];
    my $result = new Set::Scalar();

    &common::displayComputingPrompt();

    if( $nbLoops > 0)
    {
	$nbLoops --;
	if($path eq "")
	{
	    foreach my $h (@rHoles)
	    {
		if($side eq "left")
		{
		    $result=$result->union(__genBTNThrows($nbLoops,"right","OP${h}",1));
		}
		
		else
		{		 
		    $result=$result->union(__genBTNThrows($nbLoops,"right","$h",1));
		}
		
	    }
	    
	    foreach my $h (@lHoles)
	    {
		if($side eq "right")
		{		 
		    $result=$result->union(__genBTNThrows($nbLoops,"left","OP${h}",1));
		}
		else
		{		 
		    $result=$result->union(__genBTNThrows($nbLoops,"left","$h",1));
		}
	    }


	    foreach my $h (@oHoles)
	    {
		$result=$result->union(__genBTNThrows($nbLoops,$side,"${h}",1));		
	    }
	}

	else
	{

	    foreach my $h (@rHoles)
	    {
		if($side eq "left")
		{		 
		    if(($pathsize +1) % 2 == 0) {$result->insert("${path}OP${h}");}
		    $result=$result->union(__genBTNThrows($nbLoops,"right","${path}OP${h}",1 + $pathsize));
		}
		
		else
		{		
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		    $result=$result->union(__genBTNThrows($nbLoops,"right","${path}${h}",1 + $pathsize));
		}
		
	    }
	    
	    foreach my $h (@lHoles)
	    {
		if($side eq "right")
		{		       
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}OP${h}");}
		    $result=$result->union(__genBTNThrows($nbLoops,"left","${path}OP${h}", 1 + $pathsize));
		}
		else
		{	  
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		    $result=$result->union(__genBTNThrows($nbLoops,"left","${path}${h}", 1 + $pathsize));
		}
	    }

	    foreach my $h (@oHoles)
	    {
		if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		$result=$result->union(__genBTNThrows($nbLoops,$side,"${path}${h}",1 + $pathsize));		
	    }
	    
	}
    }
    
    return $result;
}


sub __genBTNThrows2 
{
    my $nbLoops = $_[0];
    my $side = $_[1];
    my $path = $_[2];
    my $pathsize = $_[3];
    my $previousHole = $_[4];
    my $result = new Set::Scalar();

    &common::displayComputingPrompt();

    if( $nbLoops > 0)
    {
	$nbLoops --;
	if($path eq "")
	{
	    foreach my $h (@rHoles)
	    {
		if($side eq "left")
		{
		    $result=$result->union(__genBTNThrows2($nbLoops,"right","OP${h}",1,""));
		}
		
		else
		{		 
		    $result=$result->union(__genBTNThrows2($nbLoops,"right","$h",1,""));
		}
		
	    }
	    
	    foreach my $h (@lHoles)
	    {
		if($side eq "right")
		{		 
		    $result=$result->union(__genBTNThrows2($nbLoops,"left","OP${h}",1,""));
		}
		
		else
		{		 
		    $result=$result->union(__genBTNThrows2($nbLoops,"left","$h",1,""));
		}
	    }
	    
	    
	    foreach my $h (@oHoles)
	    {
		$result=$result->union(__genBTNThrows2($nbLoops,$side,"${h}",1,""));		
	    }
	}
	
	else
	{
	    
	    foreach my $h (@rHoles)
	    {
		if($side eq "left")
		{	
		    if(($pathsize +1) % 2 == 0) {$result->insert("${path}OP${h}");}
		    $result=$result->union(__genBTNThrows2($nbLoops,"right","${path}OP${h}",1 + $pathsize,$h));		
		}
		
		else
		{		
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		    
		    if ($h ne $previousHole)
		    {
			$result=$result->union(__genBTNThrows2($nbLoops,"right","${path}${h}",1 + $pathsize,$h));
		    }
		}		
		
	    }
	    
	    foreach my $h (@lHoles)
	    {
		if($side eq "right")
		{		       
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}OP${h}");}
		    $result=$result->union(__genBTNThrows2($nbLoops,"left","${path}OP${h}", 1 + $pathsize,$h));
		}
		
		else
		{	  		
		    if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		    if ($h ne $previousHole)
		    {
			$result=$result->union(__genBTNThrows2($nbLoops,"left","${path}${h}", 1 + $pathsize,$h));
		    }
		    
		}
	    }
	    
	    foreach my $h (@oHoles)
	    {
		if(($pathsize  +1) % 2 == 0) {$result->insert("${path}${h}");}
		if ($h ne $previousHole)
		{
		    $result=$result->union(__genBTNThrows2($nbLoops,$side,"${path}${h}",1 + $pathsize,$h));	 
		}
	    }		
	    
	    
	}
    }
    
    return $result;
}


#sub gen
#{
#    my $nbHoles=$_[0];
#    if(scalar @_ == 2)
#    {
#	open(FILE,">$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
#    }
#
#    
#    my $result = &__genBTNThrows($nbHoles, "right", "", 0 );
#
#    if(scalar @_ == 2)
#    {
#	&common::hideComputingPrompt();
#	print FILE "==========================================================================\n";
#	print FILE $lang::MSG_BTN_GENTHROWS_1; 
#	print FILE $result->size;
#	print FILE $lang::MSG_BTN_GENTHROWS_2;
#	print FILE $nbHoles;
#	print FILE $lang::MSG_BTN_GENTHROWS_3;
#	print FILE "==========================================================================\n";
#	
#	$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
#	print FILE $result;
#	close (FILE);	
#    }
#    
#    else
#    {
#	&common::hideComputingPrompt();
#	print colored [$common::COLOR_RESULT], "==========================================================================\n";
#	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_1;
#	print colored [$common::COLOR_RESULT], $result->size;
#	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_2;
#	print colored [$common::COLOR_RESULT], $nbHoles;
#	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_3;
#	print colored [$common::COLOR_RESULT], "==========================================================================\n";
#	
#	$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
#	print $result;
#	print "\n\n";    
#    }            
#}

sub gen
{
    my $nbHoles=$_[0];
    if(scalar @_ == 2)
    {
	open(FILE,">$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
    }
    
    my $result = &__genBTNThrows($nbHoles, "right", "", 0 );
    
    if(scalar @_ == 2)
    {
	&common::hideComputingPrompt();
	print FILE "==========================================================================\n";
	print FILE $lang::MSG_BTN_GENTHROWS_1; 
	print FILE $result->size;
	print FILE $lang::MSG_BTN_GENTHROWS_2;
	print FILE $nbHoles;
	print FILE $lang::MSG_BTN_GENTHROWS_3;
	print FILE "==========================================================================\n";
	
	#$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
	$result->as_string_callback(sub{join(":",sort $_[0]->elements)});
	my @resultTab = split(/:/, $result);
	
	print FILE "\n";
	print FILE "Throw";
	print FILE (' ' x ($spaceResult - length("Throw"))); 
	print FILE "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)";
	print FILE (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)"))); 
	print FILE "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)";
	print FILE (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)"))); 
	print FILE "BTN Parity (0:$lang::MSG_BTN_GENTHROWS_EVEN, 1:$lang::MSG_BTN_GENTHROWS_ODD)";
	print FILE "\n\n";
	
	foreach my $i (@resultTab)
	{
	    print FILE "$i";
	    print FILE (' ' x ($spaceResult - length($i))); 
	    my $iTr = inv($i,0,-1); 
	    print FILE $iTr;
	    print FILE (' ' x ($spaceResult - length($iTr))); 
	    $iTr = inv($i,1,-1); 
	    print FILE $iTr;
	    print FILE (' ' x ($spaceResult - length($iTr))); 
	    $iTr = BTNParity($i,-1); 
	    print FILE $iTr;
	    print FILE "\n";
	}    	
	close (FILE);		
    }
    
    else
    {
	&common::hideComputingPrompt();
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_1;
	print colored [$common::COLOR_RESULT], $result->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_2;
	print colored [$common::COLOR_RESULT], $nbHoles;
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWSEXT_3;
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	
	#$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
	$result->as_string_callback(sub{join(":",sort $_[0]->elements)});
	my @resultTab = split(/:/, $result);

	print "\n";
	print "Throw";
	print (' ' x ($spaceResult - length("Throw"))); 
	print "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)";
	print (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)"))); 
	print "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)";
	print (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)"))); 
	print "BTN Parity (0:$lang::MSG_BTN_GENTHROWS_EVEN, 1:$lang::MSG_BTN_GENTHROWS_ODD)";
	print "\n\n";
	
	foreach my $i (@resultTab)
	{
	    print "$i";
	    print (' ' x ($spaceResult - length($i))); 
	    my $iTr = inv($i,0,-1); 
	    print $iTr;
	    print (' ' x ($spaceResult - length($iTr))); 
	    $iTr = inv($i,1,-1); 
	    print $iTr;
	    print (' ' x ($spaceResult - length($iTr))); 
	    $iTr = BTNParity($i,-1); 
	    print $iTr;
	    print "\n";
	}    
    }
}

# sub gen2
# {
#     my $nbHoles=$_[0];
#     if(scalar @_ == 2)
#     {
# 	open(FILE,">$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
#     }
    
    
#     my $result = &__genBTNThrows2($nbHoles, "right", "", 0, "T" );
    
#     if(scalar @_ == 2)
#     {
# 	&common::hideComputingPrompt();
# 	print FILE "==========================================================================\n";
# 	print FILE $lang::MSG_BTN_GENTHROWS_1; 
# 	print FILE $result->size;
# 	print FILE $lang::MSG_BTN_GENTHROWS_2;
# 	print FILE $nbHoles;
# 	print FILE $lang::MSG_BTN_GENTHROWS_3;
# 	print FILE "==========================================================================\n";
	
# 	$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
# 	print FILE $result;
# 	close (FILE);		
#     }    
    
#     else
#     {
# 	&common::hideComputingPrompt();
# 	print colored [$common::COLOR_RESULT], "==========================================================================\n";
# 	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_1; 
# 	print colored [$common::COLOR_RESULT], $result->size;
# 	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_2;
# 	print colored [$common::COLOR_RESULT], $nbHoles;
# 	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_3;
# 	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	
# 	$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
# 	print $result;
# 	print "\n\n";    
#     }
    
# }

sub gen2
{
    my $nbHoles=$_[0];
    if(scalar @_ == 2)
    {
	open(FILE,">$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
    }
    
    my $result = &__genBTNThrows2($nbHoles, "right", "", 0, "T" );

    if(scalar @_ == 2)
    {
	&common::hideComputingPrompt();
	print FILE "==========================================================================\n";
	print FILE $lang::MSG_BTN_GENTHROWS_1; 
	print FILE $result->size;
	print FILE $lang::MSG_BTN_GENTHROWS_2;
	print FILE $nbHoles;
	print FILE $lang::MSG_BTN_GENTHROWSEXT_3;
	print FILE "==========================================================================\n";
	
	#$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
	$result->as_string_callback(sub{join(":",sort $_[0]->elements)});
	my @resultTab = split(/:/, $result);
	
	print FILE "\n";
	print FILE "Throw";
	print FILE (' ' x ($spaceResult - length("Throw"))); 
	print FILE "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)";
	print FILE (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)"))); 
	print FILE "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)";
	print FILE (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)"))); 
	print FILE "BTN Parity (0:$lang::MSG_BTN_GENTHROWS_EVEN, 1:$lang::MSG_BTN_GENTHROWS_ODD)";
	print FILE "\n\n";
	
	foreach my $i (@resultTab)
	{
	    print FILE "$i";
	    print FILE (' ' x ($spaceResult - length($i))); 
	    my $iTr = inv($i,0,-1); 
	    print FILE $iTr;
	    print FILE (' ' x ($spaceResult - length($iTr))); 
	    $iTr = inv($i,1,-1); 
	    print FILE $iTr;
	    print FILE (' ' x ($spaceResult - length($iTr))); 
	    $iTr = BTNParity($i,-1); 
	    print FILE $iTr;
	    print FILE "\n";
	}    	
	close (FILE);		
    }
    
    
    else
    {
	&common::hideComputingPrompt();
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_1; 
	print colored [$common::COLOR_RESULT], $result->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWS_2;
	print colored [$common::COLOR_RESULT], $nbHoles;
	print colored [$common::COLOR_RESULT], $lang::MSG_BTN_GENTHROWSEXT_3;
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	
	#$result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
	$result->as_string_callback(sub{join(":",sort $_[0]->elements)});
	my @resultTab = split(/:/, $result);

	print "\n";
	print "Throw";
	print (' ' x ($spaceResult - length("Throw"))); 
	print "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)";
	print (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_EVEN)"))); 
	print "Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)";
	print (' ' x ($spaceResult - length("Time Reversed (SS $lang::MSG_BTN_GENTHROWS_ODD)"))); 
	print "BTN Parity (0:$lang::MSG_BTN_GENTHROWS_EVEN, 1:$lang::MSG_BTN_GENTHROWS_ODD)";
	print "\n\n";
	
	foreach my $i (@resultTab)
	{
	    print "$i";
	    print (' ' x ($spaceResult - length($i))); 
	    my $iTr = inv($i,0,-1); 
	    print $iTr;
	    print (' ' x ($spaceResult - length($iTr))); 
	    $iTr = inv($i,1,-1); 
	    print $iTr;
	    print (' ' x ($spaceResult - length($iTr))); 
	    $iTr = BTNParity($i,-1); 
	    print $iTr;
	    print "\n";
	}    
    }
}


sub size
{    
    my $nb = 0;
    my @liste= $_[0] =~ /BOL/ig;
    $nb += @liste;
    @liste= $_[0] =~ /AL/ig;
    $nb += @liste;
    @liste= $_[0] =~ /AC/ig;
    $nb += @liste;

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$nb\n";
    }

    return $nb;    
}

# Return 0 if Even, 1 if Odd, -1 if any
sub BTNParity
{    
    if(scalar @_ < 1)
    {
	die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
    }

    my $res = -1;    
    if(substr($_[0],length($_[0])-3,3) eq "BOL")
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "$res $lang::MSG_BTN_BTNPARITY_0\n";
	}
	return $res;    
    }
    my @nbOP= $_[0] =~ /OP/ig;
    my $nb=scalar @nbOP;
    
    if ( $nb % 2 == 0)
    {
	$res = 0;
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "$res $lang::MSG_BTN_BTNPARITY_1\n";
	}
    }
    else
    {
	$res = 1;
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "$res $lang::MSG_BTN_BTNPARITY_2\n";
	}
    }

    return $res;    
}

# Return 0 if Even, 1 if Odd
sub fakeBTNParity
{    
    my $res = -1;    
    my @nbOP= $_[0] =~ /OP/ig;
    my $nb=scalar @nbOP;
    if ( $nb % 2 == 0)
    {
	$res = 0;
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "$res $lang::MSG_BTN_BTNPARITY_1\n";
	}
    }
    else
    {
	$res = 1;
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "$res $lang::MSG_BTN_BTNPARITY_2\n";
	}
    }

    return $res;    
}


sub inv
{    
    my $chaine = uc($_[0]);
    my $parity = uc($_[1]);
    my $tail = "";
    my $head = "";
    my $body = "";
    
    if($chaine eq "") 
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "\n";
	}
	
	return "";
    }

    if ($parity != 0 && $parity != 1)
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_TIMEREVERSED_ERR1";
	}
	return -1;
    }
    
    if (isValid($chaine,-1) == -1)		
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_TIMEREVERSED_ERR2";
	}
	return -1;
    }

    #Get the first Hole   	
    if((substr($chaine,0,2) eq "AL") || (substr($chaine,0,2) eq "AC"))
    {
	$tail = substr($chaine,0,2);
    }
    
    elsif(substr($chaine,0,3) eq "BOL")
    {
	$tail = substr($chaine,0,3);
    }
    
    elsif((substr($chaine,0,4) eq "OPAL") || (substr($chaine,0,4) eq "OPAC"))
    {
	$tail = substr($chaine,0,4);
    }
    
    else
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_TIMEREVERSED_ERR3";
	}
	return -1;
    }
    
    #Get the Last Hole without possible op
    if((substr($chaine,length($chaine)-2,2) eq "AL") || (substr($chaine,length($chaine)-2,2) eq "AC"))
    {
	$head = substr($chaine,length($chaine)-2,2);
    }
    
    elsif(substr($chaine,length($chaine)-3,3) eq "BOL")
    {
	$head = substr($chaine,length($chaine)-3,3);
    }
    
    else
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_TIMEREVERSED_ERR4";
	}
	return -1;
    }
    
    #Get the body
    my $body = substr($chaine,	length($tail),length($chaine) - length($tail) - length($head));

    #reverse the body
    my $bodyInvert = "";
    while (length($body) > 0)
    {
	if((substr($body,length($body)-2,2) eq "AL") 
	   || (substr($body,length($body)-2,2) eq "AC") 
	   || (substr($body,length($body)-2,2) eq "OP"))
	{
	    $bodyInvert = "$bodyInvert".substr($body,length($body)-2,2);
	    $body = substr($body,0,length($body)-2);
	}
	
	elsif(substr($body,length($body)-3,3) eq "BOL")
	{
	    $bodyInvert = "$bodyInvert".substr($body,length($body)-3,3);
	    $body = substr($body,0,length($body)-3);
	}
	
	else
	{
	    if((scalar @_ == 2) || ($_[1] != -1))
	    {
		print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_TIMEREVERSED_ERR5 : $body $lang::MSG_BTN_TIMEREVERSED_ERR5b";
	    }
	    return -1;
	}
    }
    
    #Remove potential OP in the tail
    if(substr($tail,0,2) eq "OP")
    {
	$tail = substr($tail,2,length($tail) -2);
    }

    #Check according to the parity if a first OP is needed. 
    my @nbOP= $_[0] =~ /OP/ig;
    if (scalar @nbOP % 2 != $parity)
    {
	$head = "OP${head}";
    }

    my $result = "${head}${bodyInvert}${tail}";
    
    #Shift OP to right when OPBOL is found
    while(rindex($result,"OPBOL") >= 0)
    {
	$result =~ s/OPBOL/BOLOP/ig;
    }
    
    #Remove OP if found in last position
    if(substr($result,length($result)-2,2) eq "OP") 
    {
	$result = substr($result, 0 , length($result)-2);
    }
    
    if((scalar @_ == 2) || ($_[2] != -1))
    {
	print colored [$common::COLOR_RESULT], "$result\n";
    }
    
    return $result;			
    
}



sub isValid
{        
    my $chaine = uc($_[0]);
    my $start = 0;
    my $end = length $chaine;
    my $size_chaine=size($chaine,-1);

    if( $size_chaine % 2 != 0)
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_ISVALID_ERR1";
	}
	return -1;
    }
    

    #remove the first and the last hole
    my $i =0;

    if((substr($chaine,0,2) eq "AL") || (substr($chaine,0,2) eq "AC"))
    {
	$chaine = substr($chaine, 2, length($chaine) - 2)
    }
    elsif(substr($chaine,0,3) eq "BOL")
    {
	$chaine = substr($chaine, 3, length($chaine) - 3)
    }
    elsif((substr($chaine,0,4) eq "OPAC") || (substr($chaine,0,4) eq "OPAL"))
    {
	$chaine = substr($chaine, 4, length($chaine) - 4)
    }
    else
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_ISVALID_ERR2";
	}
	return -1;
    }
    
    
    if((substr($chaine,length($chaine) - 4,4) eq "OPAL") || (substr($chaine,length($chaine) - 4,4) eq "OPAC"))
    {
	$chaine = substr($chaine, 0, length($chaine) - 4)
    }
    elsif(substr($chaine,length($chaine) - 3,3) eq "BOL")
    {
	$chaine = substr($chaine, 0, length($chaine) - 3)
    }
    elsif((substr($chaine,length($chaine) - 2,2) eq "AC") || (substr($chaine,length($chaine) - 2,2) eq "AL"))
    {
	$chaine = substr($chaine, 0, length($chaine) - 2)
    }
    else
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_ISVALID_ERR3";
	}
	return -1;
    }
    
    my $previousHole = "";
    my $lastHole = "";
    
    while ($chaine ne "")
    {
	if((substr($chaine,0,2) eq "AL") || (substr($chaine,0,2) eq "AC"))
	{
	    $lastHole=substr($chaine,0,2);
	    $chaine = substr($chaine, 2, length($chaine) - 2)
	}
	elsif(substr($chaine,0,3) eq "BOL")
	{
	    $lastHole=substr($chaine,0,3);
	    $chaine = substr($chaine, 3, length($chaine) - 3)
	}
	elsif((substr($chaine,0,4) eq "OPAC") || (substr($chaine,0,4) eq "OPAL"))
	{
	    $lastHole=substr($chaine,0,4);
	    $chaine = substr($chaine, 4, length($chaine) - 4)
	}
	else
	{
	    if((scalar @_ == 1) || ($_[1] != -1))
	    {
		print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_ISVALID_ERR4${chaine}$lang::MSG_BTN_ISVALID_ERR4b";
	    }
	    return -1;
	}
    	
	if ($lastHole eq $previousHole)
	{
	    if((scalar @_ == 1) || ($_[1] != -1))
	    {		
		print colored [$common::COLOR_RESULT], "Warning $lang::MSG_BTN_ISVALID_ERR5${previousHole}${lang::MSG_BTN_ISVALID_ERR5b}${previousHole}${lastHole}${chaine}$lang::MSG_BTN_ISVALID_ERR5c";
	    }
	    #return -1;
	}
	
	if ($lastHole eq "OPAL" || $lastHole eq "OPAC") 
	{
	    $previousHole = substr($lastHole,2,2);
	}
	else 
	{
	    $previousHole = $lastHole;
	}
    }
    
    if ($chaine eq "")
    {
	if($size_chaine >= 6)
	{
	    if((scalar @_ == 1) || ($_[1] != -1))
	    {
		print colored [$common::COLOR_RESULT], "False $lang::MSG_BTN_ISVALID_WARN1";
	    }
	    return 1;
	}

	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return 1;
    }
}


sub __test 
{
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Gen Throws : BTN::gen(2);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &gen(2);

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"ALBOLACOPACOPALBOLAL\");\n\t\t==> 7\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("ALBOLACOPACOPALBOLAL");

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::size(\"BOLALALACALBOLACOPACOPALBOLAL\",-1);\n\t\t==> 11\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &size("BOLALALACALBOLACOPACOPALBOLAL",-1);
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"\");\n\t\t==> 0\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"OP\");\n\t\t==> 0\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("OP");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"OPAC\");\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("OPAC");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"OPACOPAL\");\n\t\t==> 2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("OPACOPAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"OPACOPBOL\");\n\t\t==> 2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("OPACOPBOL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::size(\"OPACOPGGGAL\");\n\t\t==> 2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("OPACOPGGGAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLALALACALBOLACOPACOPALBOLALBOL\");\n\t\t==> True (but Warning)\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLALALACALBOLACOPACOPALBOLALBOL");
    print "\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOLALACALBOLACOPACOPALBOLALBOLOPAL\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOLALACALBOLACOPACOPALBOLALBOLOPAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOLOPALALAL\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOLOPALALAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLACOPBOLAL\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLACOPBOLAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLACOPBOLALG\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("GBOLACOPBOLAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"GBOLACOPBOLAL\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLACOPBOLALG");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLALACALBOLACOPACOPALBOLALBOLOPAL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLALACALBOLACOPACOPALBOLALBOLOPAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOLALACALBOLACOPACOPALBOLALBOLALOPAL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOLALACALBOLACOPACOPALBOLALBOLALOPAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOLACALOPALAL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOLACALOPALAL");
    print "\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOLALACALBOLACOPACOPACOPALBOLALBOLOPAL\");\n\t\t==> True (but Warning)\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOLALACALBOLACOPACOPACOPALBOLALBOLOPAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLAL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLAL");
    print "\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"BOLBOL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("BOLBOL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"ACAC\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("ACAC");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tBTN::isValid(\"OPACALOPACAL\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("OPACALOPACAL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::isValid(\"OPACALOPACAC\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("OPACALOPACAC",-1);
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::isValid(\"OPACOPACOPACAC\",-1);\n\t\t==> -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("OPACOPACOPACAC",-1);
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::isValid(\"OPACOPACACAC\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("OPACOPACACAC",-1);
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::BTNParity(\"OPACOPACACAC\",-1);\n\t\t==> 0\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &BTNParity("OPACOPACACAC",-1);
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::BTNParity(\"OPACOPACACOPAC\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &BTNParity("OPACOPACACOPAC",-1);
    print "\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::BTNParity(\"OPACAC\");\n\t\t==> 1 (Odd)\n\t\t    1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &BTNParity("OPACAC");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::BTNParity(\"OPACBOL\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &BTNParity("OPACBOL");
    print "\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint BTN::inv(ALLBTNTHROWS,-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    my $result = new Set::Scalar();
    $result = &__genBTNThrows(2, "right", "", 0);
    $result->as_string_callback(sub{join(":",sort $_[0]->elements)});
    my @resultTab = split(/:/, $result);

    print "\n";
    print "Throw";
    print (' ' x ($spaceResult - length("Throw"))); 
    print "Time Reversed (Even)";
    print (' ' x ($spaceResult - length("Time Reversed (Even)"))); 
    print "Time Reversed (Odd)";
    print "\n\n";


    foreach my $i (@resultTab)
    {
	print "$i";
	print (' ' x ($spaceResult - length($i))); 
	my $iTr = inv($i,0,-1); 
	print $iTr;
	print (' ' x ($spaceResult - length($iTr))); 
	print inv($i,1,-1); 
	print "\n";
    }
    print "\n";

}



1;


