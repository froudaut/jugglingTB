#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## MJN.pm   - Multi-Juggler Notation for jugglingTB                         ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2021-2022  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package MJN;
use common;
use strict;
use lang;
use Term::ANSIColor;
use modules::MHN;
use modules::MJN_GRAMMAR;    
use Getopt::Long qw(GetOptionsFromString);


$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $MJN_INFO = "Multi-Juggler Notation";
our $MJN_HELP = $lang::MSG_MJN_MENU_HELP;
our $MJN_VERSION = "v0.3";

our %MJN_CMDS = 
    (
     'toMHN'               => ["$lang::MSG_MJN_MENU_TOMHN_1","$lang::MSG_MJN_MENU_TOMHN_2"], 
     'getJugglersNumber'   => ["$lang::MSG_MJN_MENU_GETJUGGLERSNUMBER_1","$lang::MSG_MJN_MENU_GETJUGGLERSNUMBER_2"],
     'getObjNumber'        => ["$lang::MSG_MJN_MENU_GETOBJNUMBER_1","$lang::MSG_MJN_MENU_GETOBJNUMBER_2"],
     'getPeriod'           => ["$lang::MSG_MJN_MENU_GETPERIOD_1","$lang::MSG_MJN_MENU_GETPERIOD_2"],
     'isSyntaxValid'       => ["$lang::MSG_MJN_MENU_ISSYNTAXVALID_1","$lang::MSG_MJN_MENU_ISSYNTAXVALID_2"],
     'isValid'             => ["$lang::MSG_MJN_MENU_ISVALID_1","$lang::MSG_MJN_MENU_ISVALID_2"],
     'isAsync'             => ["$lang::MSG_MJN_MENU_ISASYNC_1","$lang::MSG_MJN_MENU_ISASYNC_2"],
     'draw'                => ["$lang::MSG_MJN_MENU_DRAW_1","$lang::MSG_MJN_MENU_DRAW_2"],
    );

print "MJN $MJN::MJN_VERSION loaded\n";


# To add debug behaviour 
our $MJN_DEBUG=-1;

my $NODESEP = .3;


sub __toMJNMatrixAsync
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my @jug = ();
    my @res_jug = ();
    
    my @period_split= split(/</,$mjn);    
    for(my $i=1; $i<scalar @period_split; $i++)
    {
	my @jl_split = split(/\|/, $period_split[$i]);
	for(my $j=0; $j<scalar @jl_split; $j++)
	{
	    if(uc(substr($jug[$j], length($jug[$j])-1, 1)) eq 'P' && substr($jl_split[$j],0,1) ne '[')
	    {
		$jug[$j] .= '/';
	    }
	    $jug[$j] .= $jl_split[$j];
	    $jug[$j] =~ s/>//g;
	}
    }

    for(my $i=0; $i<scalar @jug; $i++)
    {
	my $beat = 0;
	my $val = '';
	
	for(my $j=0; $j< length($jug[$i]); $j++)
	{	    
	    if(substr($jug[$i],$j,1) eq '(')
	    {
		$val = '(';
		$j++;
		while($j < length($jug[$i]) && substr($jug[$i],$j,1) ne ')')
		{
		    $val .= substr($jug[$i],$j,1);
		    $j++;
		}
		$val .= ')';
	    }

	    elsif(substr($jug[$i],$j,1) eq '[')
	    {
		$val = '[';
		$j++;
		while($j < length($jug[$i]) && substr($jug[$i],$j,1) ne ']')
		{
		    $val .= substr($jug[$i],$j,1);
		    $j++;
		}
	    }
	    
	    else
	    {
		if($j+1 <  length($jug[$i]) && uc(substr($jug[$i],$j+1,1)) eq 'X')
		{
		    # xp
		    if($j+2 <  length($jug[$i]) && uc(substr($jug[$i],$j+2,1)) eq 'P')
		    {
			if($j+3 >=  length($jug[$i]) || uc(substr($jug[$i],$j+3,1)) eq '/') 
			{
			    $val .= substr($jug[$i],$j,3).(($i+1)%(scalar @jug)+1);
			}
			else
			{
			    $val .= substr($jug[$i],$j,4);
			}
			$j+=3;			
		    }

		    # Only x 
		    else {
			$val .= substr($jug[$i],$j,2);
			$j+=1;			
		    }
		}					

		# Only p
		elsif($j+1 <  length($jug[$i]) && uc(substr($jug[$i],$j+1,1)) eq 'P')
		{
		    if($j+2 >=  length($jug[$i]) || uc(substr($jug[$i],$j+2,1)) eq '/') 
		    {
			$val .= substr($jug[$i],$j,2).(($i+1)%(scalar @jug)+1);		
		    }
		    else {
			$val .= substr($jug[$i],$j,3);
		    }
		    $j+=2;		    
		}
		else {
		    $val .= substr($jug[$i],$j,1);
		}
	    }

	    $res_jug[$i][$beat] = $val;
	    $val = '';
	    $beat ++;
	}
    }

    # for (my $i=0; $i < scalar @res_jug; $i++)
    # {
    # 	for (my $j=0; $j < scalar @{$res_jug[$i]}; $j++)
    # 	{
    # 	    print $res_jug[$i][$j]."   ";
    # 	}
    # 	print "\n";
    # }

    return \@res_jug;
    
}



sub __emptyMatrix
{    
    my @res=();
    for(my $i = 0; $i < $_[0]; $i++)
    {
	my @lin = (0) x $_[1];	 
	$res[$i] = \@lin;
    }

    return \@res;
}


sub __printMatrix
{
    my @matrix = @{$_[0]};   

    print "\n";
    for(my $i=0; $i<scalar @matrix; $i++)
    {
	my @lin = @{$matrix[$i]};
	for(my $j=0; $j<scalar @lin; $j++)
	{
	    print $matrix[$i][$j]." ";
	}
	print "\n";
    }
    print "\n";    
}


sub __matrixToStr
{
    my @matrix = @{$_[0]};   
    my $res = '';
    
    for(my $i=0; $i<scalar @matrix; $i++)
    {
	$res .= '<';
	my @lin = @{$matrix[$i]};
	if (scalar @lin >= 1)
	{
	    $res .= $matrix[$i][0];	
	    for(my $j=1; $j<scalar @lin; $j++)
	    {
		$res .= '|'.$matrix[$i][$j];
	    }
	}
	$res .= '>';
    }

    return $res;
}


sub isSyntaxValid
{
    
    # res is -1 if a lexical/syntaxic error is found, 1 otherwise
    my $res=MJN_GRAMMAR::parse($_[0],$_[1]);
    
    if ($res==-1) {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    } else {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return $res;
    }
}


sub isValid
{
    my $mjn = $_[0];
    my $start_asyncHands = $_[2];
    $start_asyncHands =~ s/\s+//g; 
    $mjn =~ s/\s+//g;
    shift @_;
    return &MHN::isValid(&toMHN($mjn,-1,$start_asyncHands),@_);
}


sub isAsync
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    if(&isValid($mjn,-1,$_[2]) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }

    if ($mjn =~ m/\(/ || $mjn =~ m/\)/ || $mjn =~ m/,/)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    return 1;
}



sub getJugglersNumber
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $res = '';
    
    my @period_split= split(/</,$mjn);
    my @jl_split = split(/\|/, $period_split[1]);
    $res = scalar @jl_split;

    if(&isValid($mjn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MJN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }

    if ((scalar @_ <= 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$res\n";
    }
    
    return $res;
}


sub getPeriod
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $res = '';
    
    if(&isValid($mjn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MJN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }

    $res = &toMHN(&getPeriod($mjn,-1),-1);
    
    if ((scalar @_ <= 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$res\n";
    }
    
    return $res;
}


sub getObjNumber
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $res = '';
    
    if (&isValid($mjn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MJN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }

    $res = &MHN::getObjNumber(&toMHN($mjn,-1), -1);

    if ((scalar @_ <= 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$res\n";
    }
    
    return $res;
}


sub __isMixed
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my @jug = ();
    my $mod = -1;

    my @period_split= split(/</,$mjn);    
    for(my $i=1; $i<scalar @period_split; $i++)
    {
	my @jl_split = split(/\|/, $period_split[$i]);
	for(my $j=0; $j<scalar @jl_split; $j++)
	{
	    $jug[$j] .= $jl_split[$j];
	    $jug[$j] =~ s/>//g;
	}
    }

    for(my $i=0; $i < scalar @jug; $i++)
    {
	if ($jug[$i] =~ m/,/ )
	{
	    if($mod == 0)
	    {
		return 1;
	    }
	    else
	    {
		$mod = 1;
	    }
	}
	else {
	    if($mod == 1)
	    {
		return 1;
	    }
	    else
	    {
		$mod = 0;
	    }
	}	
    }

    return -1;

}

sub __toSync
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my @jug = ();
    my @res_jug = ();
    my $res = '';
    
    my @period_split= split(/</,$mjn);    
    for(my $i=1; $i<scalar @period_split; $i++)
    {
	my @jl_split = split(/\|/, $period_split[$i]);
	for(my $j=0; $j<scalar @jl_split; $j++)
	{
	    $jug[$j] .= $jl_split[$j];
	    $jug[$j] =~ s/>//g;
	}
    }

    for(my $i=0; $i<scalar @jug; $i++)
    {
	my $side = 'R';
	for(my $j=0; $j< length($jug[$i]); $j++)
	{
	    if(substr($jug[$i],$j,1) eq '(')
	    {
		$res_jug[$i] .= '(';
		$j++;
		while($j < length($jug[$i]) && substr($jug[$i],$j,1) ne ')')
		{
		    $res_jug[$i] .= substr($jug[$i],$j,1);
		    $j++;
		}
		$res_jug[$i] .= ')';
	    }
	    elsif(substr($jug[$i],$j,1) eq '[')
	    {
		my $val = '[';
		$j++;
		while($j < length($jug[$i]) && substr($jug[$i],$j,1) ne ']')
		{
		    $val .= substr($jug[$i],$j,1);
		    $j++;
		}
		
		if($side eq 'R')
		{
		    $res_jug[$i] .= '('.$val.'],0)!';
		    $side = 'L';		
		}
		else
		{
		    $res_jug[$i] .= '(0,'.$val.'])!';
		    $side = 'R';		
		}	    
	    }
	    else
	    {
		if($j+1 <  length($jug[$i]) && uc(substr($jug[$i],$j+1,1)) eq 'X')
		{
		    # xp
		    if($j+2 <  length($jug[$i]) && uc(substr($jug[$i],$j+2,1)) eq 'P')
		    {
			if($j+3 >=  length($jug[$i]) || uc(substr($jug[$i],$j+3,1)) eq '/') 
			{
			    if($side eq 'R')
			    {
				$res_jug[$i] .= '('.substr($jug[$i],$j,3).',0)!';
			    }
			    else
			    {
				$res_jug[$i] .= '(0,'.substr($jug[$i],$j,3).')!';
			    }
			    $j+=3;
			}
			else {
			    if($side eq 'R')
			    {
				$res_jug[$i] .= '('.substr($jug[$i],$j,4).',0)!';
			    }
			    else
			    {
				$res_jug[$i] .= '(0,'.substr($jug[$i],$j,4).')!';
			    }
			    $j+=3;
			}			    
		    }

		    # Only x 
		    else {
			
			if($side eq 'R')
			{
			    $res_jug[$i] .= '('.substr($jug[$i],$j,2).',0)!';
			}
			else
			{
			    $res_jug[$i] .= '(0,'.substr($jug[$i],$j,2).')!';
			}
			$j+=1;			
		    }			
		}

		# Only p
		elsif($j+1 <  length($jug[$i]) && uc(substr($jug[$i],$j+1,1)) eq 'P')
		{
		    if($j+2 >=  length($jug[$i]) || uc(substr($jug[$i],$j+2,1)) eq '/') 
		    {
			if($side eq 'R')
			{
			    $res_jug[$i] .= '('.substr($jug[$i],$j,2).',0)!';
			}
			else
			{
			    $res_jug[$i] .= '(0,'.substr($jug[$i],$j,2).')!';
			}
			$j+=2;
		    }
		    else {
			if($side eq 'R')
			{
			    $res_jug[$i] .= '('.substr($jug[$i],$j,3).',0)!';
			}
			else
			{
			    $res_jug[$i] .= '(0,'.substr($jug[$i],$j,3).')!';
			}
			$j+=2;
		    }
		}
		else {
		    if($side eq 'R')
		    {
			$res_jug[$i] .= '('.substr($jug[$i],$j,1).',0)!';
		    }
		    else
		    {
			$res_jug[$i] .= '(0,'.substr($jug[$i],$j,1).')!';
		    }
		}


		if($side eq 'R')
		{
		    $side = 'L';		
		}
		else
		{
		    $side = 'R';		
		}	    		
	    }
	    
	}
    }

    $res .= '<'.$res_jug[0];
    for (my $i=1; $i < scalar @res_jug; $i++)
    {
	$res .= '|'.$res_jug[$i];
    }
    $res .= '>';

    print colored [$common::COLOR_RESULT], 'Transform ==> '.$res."\n";
    return $res;
}


sub toMHN
{
    my $mjn = $_[0];
    my $start_asyncHands = $_[2]; 
    $mjn =~ s/\s+//g;
    my $res = '';

    # Transfor MJN in Sync if both Async/Sync are there
    if(&__isMixed($mjn) == 1)
    {
	$mjn = &__toSync($mjn);
    }
    
    my @period_split= split(/</,$mjn);
    my @jl_split = split(/\|/, $period_split[1]);
    my $jugglernum = scalar @jl_split;
    my @start_asyncHands_l = split(/,/,$start_asyncHands);

    
    my $period = scalar @period_split -1;
    if ($mjn =~ m/,/)
    {
	$period = $period * 2;
	# Be careful if ! is used.	
	my $nb = 0;
	for (my $j=1; $j< scalar @period_split; $j++)
	{
	    my @jl_split_in = split(/\|/, $period_split[$j]);
	    my @occur = $jl_split_in[0] =~ /!/g;
	    $nb += scalar(@occur);
	}	
	$period -= $nb;
    }
    
    if ($period %2 != 0)
    {
	$mjn .= $mjn;
	$period = $period * 2;

	if ($mjn =~ m/,/)
	{
	    $period = $period * 2;
	    # Be careful if ! is used.	
	    my $nb = 0;
	    for (my $j=1; $j< scalar @period_split; $j++)
	    {
		my @jl_split_in = split(/\|/, $period_split[$j]);
		my @occur = $jl_split_in[0] =~ /!/g;
		$nb += scalar(@occur);
	    }	
	    $period -= $nb;
	}
    }

    @period_split= split(/</,$mjn);    
    
    my @res_t = ();
    my @side_jl = ();
    
    my $sync_mode = '-1';
    my $mult = '-1';
    my $multval = '-1';
    
    for (my $i=1; $i<scalar @period_split; $i++)
    {
	my @jl_split = split(/\|/, substr($period_split[$i],0, length($period_split[$i]) -1));
	for (my $j=0; $j< scalar @jl_split; $j++)
	{
	    if($i == 1)
	    {
		if(scalar(@_) > 2 && $_[2] ne '')
		{
		    $side_jl[$j] = uc($start_asyncHands_l[$j]);
		}
		else
		{
		    $side_jl[$j] = 'R';
		}
	    }
	    
	    my $val = $jl_split[$j];
	    my $beat = 0;
	    for(my $k=0;$k<length($val); $k++)
	    {
		my $th = '';
		
		if(uc(substr($val,$k,1)) eq '/'
		   || substr($val,$k,1) eq '!'	
		    )
		{
		    # Do nothing
		}
		elsif(substr($val,$k,1) eq '[')
		{
		    $mult = 1;
		    $multval = $k+1;
		}
		elsif(substr($val,$k,1) eq ']')
		{
		    $mult = -1;
		    if($side_jl[$j] eq 'R')
		    {
			$side_jl[$j] = 'L';
		    }
		    elsif($side_jl[$j] eq 'L')
		    {
			$side_jl[$j] = 'R';
		    }
		}
		elsif(uc(substr($val,$k,1)) eq '(')
		{
		    $sync_mode = 1;
		    $side_jl[$j] = 'R';
		}
		elsif(uc(substr($val,$k,1)) eq ')')
		{
		    $sync_mode = -1;
		    if($k+1<=length($val) && substr($val,$k+1,1) ne '!')
		    {
			$res_t[2*$j] .= ',0';
			$res_t[2*$j+1] .= ',0';
		    }
		}
		elsif(uc(substr($val,$k,1)) eq ',')
		{
		    $side_jl[$j] = 'L';
		    $beat --;
		}
		
		else
		{
		    if($k+1 < length($val) && uc(substr($val,$k+1,1)) eq 'X')
		    {
			$th = hex(substr($val,$k,1));
			my $add = '';
			if($beat > 0 && ($mult == -1 || $multval==$k))
			{
			    $add = ',';
			}

			# X and P
			if($k+2 < length($val) && uc(substr($val,$k+2,1)) eq 'P')
			{
			    if($k+3 < length($val) && substr($val,$k+3,1) ne '/'
			       && substr($val,$k+3,1) ne ')'
			       && substr($val,$k+3,1) ne ','
			       && substr($val,$k+3,1) ne '[')
			    {
				if($th%2 == 0)
				{
				    if($side_jl[$j] eq 'R')
				    {				
					$res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+3,1)-1) + 1);
					if($sync_mode == -1)
					{
					    $res_t[2*$j+1] .= $add.'0';
					}
				    }
				    else {				
					$res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+3,1)-1));
					if($sync_mode == -1)
					{
					    $res_t[2*$j] .= $add.'0';
					}
				    }
				}
				else {
				    if($side_jl[$j] eq 'R')
				    {				
					$res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*substr($val,$k+3,1)-1);
					if($sync_mode == -1)
					{
					    $res_t[2*$j+1] .= $add.'0';
					}
				    }
				    else {				
					$res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+3,1)-1)+1);
					if($sync_mode == -1)
					{
					    $res_t[2*$j] .= $add.'0';
					}
				    }
				}
				$k+=3;
				if($mult != 1) {
				    $beat ++;
				}
			    }
			    else
			    { 
				if($th%2 == 0)
				{
				    if($side_jl[$j] eq 'R')
				    {				
					$res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1)+1)%($jugglernum*2));
					if($sync_mode == -1)
					{
					    $res_t[2*$j+1] .= $add.'0';
					}
				    }
				    else {				
					$res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1))%($jugglernum*2));
					if($sync_mode == -1)
					{
					    $res_t[2*$j] .= $add.'0';
					}
				    }
				}
				else {
				    if($side_jl[$j] eq 'R')
				    {				
					$res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1))%($jugglernum*2));
					if($sync_mode == -1)
					{
					    $res_t[2*$j+1] .= $add.'0';
					}
				    }
				    else {				
					$res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1)+1)%($jugglernum*2));
					if($sync_mode == -1)
					{
					    $res_t[2*$j] .= $add.'0';
					}
				    }
				}
				
				$k+=2;
				if($mult != 1) {
				    $beat ++;
				}
			    }
			}
			
			# No P after X
			else
			{
			    if($th%2 == 0)
			    {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*$j+1);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {				
				    $res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*$j);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }
			    else {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {
				    $res_t[2*$j+1] .= $add.substr($val,$k,1);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }
			    $k+=1;
			    if($mult != 1) {
				$beat ++;
			    }
			}		    				

		    }		    		

		    # P Only
		    elsif($k+1 < length($val) && uc(substr($val,$k+1,1)) eq 'P')
		    {
			$th = hex(substr($val,$k,1));
			my $add = '';
			if($beat > 0 && ($mult == -1 || $multval==$k))
			{
			    $add = ',';
			}

			if($k+2 < length($val) && substr($val,$k+2,1) ne '/'
			   && substr($val,$k+2,1) ne ')'
			   && substr($val,$k+2,1) ne ','
			   && substr($val,$k+2,1) ne '[')
			{
			    if($th%2 == 0)
			    {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+2,1)-1));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {				
				    $res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+2,1)-1)+1);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }
			    else {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+2,1)-1)+1);
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {				
				    $res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*(substr($val,$k+2,1)-1));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }
			    $k+=2;
			    if($mult != 1) {
				$beat ++;
			    }
			}
			
			else
			{
			    if($th%2 == 0)
			    {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1))%($jugglernum*2));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {				
				    $res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1)+1)%($jugglernum*2));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }
			    else {
				if($side_jl[$j] eq 'R')
				{				
				    $res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1)+1)%($jugglernum*2));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j+1] .= $add.'0';
				    }
				}
				else {				
				    $res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',(2*($j+1))%($jugglernum*2));
				    if($sync_mode == -1)
				    {
					$res_t[2*$j] .= $add.'0';
				    }
				}
			    }

			    $k+=1;
			    if($mult != 1) {
				$beat ++;
			    }
			}		    
		    }

		    # No X, no P 
		    else
		    {
			$th = hex(substr($val,$k,1));
			my $add = '';
			if($beat > 0 && ($mult == -1 || $multval==$k))
			{
			    $add = ',';
			}
			
			if($th%2 == 0)
			{
			    if($side_jl[$j] eq 'R')
			    {				
				$res_t[2*$j] .= $add.substr($val,$k,1);
				if($sync_mode == -1)
				{
				    $res_t[2*$j+1] .= $add.'0';
				}
			    }
			    else {				
				$res_t[2*$j+1] .= $add.substr($val,$k,1);
				if($sync_mode == -1)
				{
				    $res_t[2*$j] .= $add.'0';
				}
			    }
			}
			else {
			    if($side_jl[$j] eq 'R')
			    {				
				$res_t[2*$j] .= $add.substr($val,$k,1).':'.sprintf('%X',2*$j+1);
				if($sync_mode == -1)
				{
				    $res_t[2*$j+1] .= $add.'0';
				}
			    }
			    else {				
				$res_t[2*$j+1] .= $add.substr($val,$k,1).':'.sprintf('%X',2*$j);
				if($sync_mode == -1)
				{
				    $res_t[2*$j] .= $add.'0';
				}
			    }
			}
			if($mult != 1) {
			    $beat ++;
			}
		    }

		    if($mult == -1)
		    {	
			if($side_jl[$j] eq 'R')
			{
			    $side_jl[$j] = 'L';
			}
			elsif($side_jl[$j] eq 'L')
			{
			    $side_jl[$j] = 'R';
			}
		    }
		}
	    }
	    
	    if($i+1 < scalar @period_split)
	    {
		$res_t[2*$j] .= ',';
		$res_t[2*$j+1] .= ',';
	    }

	}
	
    }

    for (my $i=0; $i<scalar @res_t; $i++)
    {
	$res .= '('.$res_t[$i].')';
    }

    # Replace 00 by 0 since Multiplex may have generated it
    $res =~ s/00/0/g;

    if ((scalar @_ <= 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$res\n";
    }

    return $res;
    
}


sub draw
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $fileOutput=$_[1];
    
    # Drawing supports are the following :     
    #     - bmp (Windows Bitmap Format),
    #     - cmapx (client-side imagemap for use in html and xhtml),
    #     - dia (GTK+ based diagrams), 
    #     - eps (Encapsulated PostScript),
    #     - fig (XFIG graphics), 
    #     - gd, gd2 (GD/GD2 formats),
    #     - gif (bitmap graphics), 
    #     - gtk (GTK canvas)
    #     - hpgl (HP pen plotters) and pcl (Laserjet printers), 
    #     - imap (imagemap files for httpd servers for each node or edge that has a non-null "href" attribute.), 
    #     - jpg, jpeg, jpe (JPEG)
    #     - mif (FrameMaker graphics), 
    #     - pdf (Portable Document Format),
    #     - png (Portable Network Graphics format), // Default one 
    #     - ps (PostScript), 
    #     - ps2 (PostScript for PDF),
    #     - svg, svgz (Structured Vector Graphics),
    #     - tif, tiff (Tag Image File Format),
    #     - vml, vmlz (Vector Markup Language),
    #     - vrml (VRML),
    #     - wbmp (Wireless BitMap format),
    #     - xlib (Xlib canvas),
    #     - canon, dot, xdot : Output in DOT langage, 
    #     - plain , plain-ext : Output in plain text
    my $fileOutputType="png";
    
    # Generation Filters are the following :
    #     - circo : filter for circular layout of graphs // Default one
    #     - dot : filter for drawing directed graphs
    #     - neato : filter for drawing undirected graphs
    #     - twopi : filter for radial layouts of graphs    
    #     - fdp : filter for drawing undirected graphs
    #     - sfdp : filter for drawing large undirected graphs    
    #     - osage : filter for drawing clustered graphs
    my $genFilter="dot";    

    my $period = 25;
    my $color_mode = 2;		# Colorization Mode for Multiplexes
    my $dot_mode = 0;		# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $label_pos = "x";	# Label Position (t: tail, h : head, m : middle, null/none : no label)
    my $title = "Y";
    my $nullSS = "N";
    my $silence = 0;
    my $model=0;		# Drawing Model : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)  
    my $jugglers = "Y";            # Print Jugglers 
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $label_color="E";
    my $graphviz_output="N";
    my $jugglers_base="J";
    my $async_mode="N";
    my $splines_mode=2;          # 0: default, 1: curved, 2: line 
    my $zero_hand="Y";           # Y to have eventual 0 in HSS
    my $quick="N";
    my $hands_seq_undef='R,L';
    my $hands_seq_undef2='L,R';
    my $hands_seq = '';
    my $hands = 'N';
    my $start_asyncHands = '';
    my $mhn_force = 'N';
    
    my $ret = &GetOptionsFromString(uc($_[2]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,	
				    "-D:i" => \$dot_mode,	
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,				   
				    "-N:s" => \$nullSS,
				    "-S:i" => \$silence,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$jugglers,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
				    "-B:s" => \$jugglers_base,
				    "-A:s" => \$async_mode,
				    "-F:i" => \$splines_mode,
				    "-Z:s" => \$zero_hand,
				    "-Q:s" => \$quick,
				    "-J:s" => \$hands,
				    "-K:s" => \$hands_seq,
				    "-U:s" => \$start_asyncHands,
				    "-W:s" => \$mhn_force,
	);
    
    if (&isAsync($mjn,-1,$start_asyncHands) == -1 || $mhn_force eq 'Y')
    {
	my $nbjugglers = &getJugglersNumber($mjn,-1);
	# Draw as SSWAP
	my $opts = "-v \"$mjn\" ";
	if($nbjugglers == 1)
	{	    
	    $mjn =~ s/<//g;
	    $mjn =~ s/>//g;
	    &SSWAP::draw($mjn, $_[1], $opts);
	}

	else
	{
	    # Draw as MHN
	    $opts = "-v \"$mjn\" -I 1 -B H -J N ";
	    
	    # Remove Useless options
	    for (my $i=0; $i < length($_[2]); $i++)
	    {
		if(substr($_[2],$i,1) eq '-' && $i < length($_[2])
		   && (uc(substr($_[2],$i+1,1)) eq 'K'
		       || (uc(substr($_[2],$i+1,1)) eq 'J')
		       || (uc(substr($_[2],$i+1,1)) eq 'U')
		       || (uc(substr($_[2],$i+1,1)) eq 'W')
		   ))
		{
		    $i++;
		    while($i+1 < length($_[2]) && substr($_[2],$i+1,1) ne '-')
		    {
			$i++;
		    }
		}
		else {		
		    $opts .= substr($_[2],$i,1);
		}	    	
	    }

	    &MHN::draw(&toMHN($mjn,-1,$start_asyncHands), $_[1], $opts);
	}
    }

    else
    {
	my @matrix=@{&__toMJNMatrixAsync($mjn)};
	
	# Compute Period & Nb Jugglers even if MJN is invalid, to be able to draw even invalid Matrix 
	my $mjnPeriod = 0;
	for(my $i=0;$i<scalar @matrix;$i++)
	{
	    my @res_lin = @{$matrix[$i]};
	    if($mjnPeriod < scalar @res_lin)
	    {
		$mjnPeriod = scalar @res_lin;
	    }
	}	
	my $mjnJugglers = scalar @matrix;
	
	my @hands_seq_l = ();	
	if(uc($hands) eq 'Y')
	{
	    if($hands_seq eq '')
	    {
		if($start_asyncHands eq '')
		{		    
		    my @in = split(/,/,$hands_seq_undef);
		    for(my $i=0; $i < $mjnJugglers; $i++)
		    {
			$hands_seq_l[$i] = \@in;
		    }
		}
		else
		{
		    my @in = split(/,/,$hands_seq_undef);
		    my @in2 = split(/,/,$hands_seq_undef2);
		    my @in3 = split(/,/,$start_asyncHands);
		    {
			for(my $i=0; $i < $mjnJugglers; $i++)
			{
			    if($in3[$i] eq 'R')
			    {
				$hands_seq_l[$i] = \@in;
			    }
			    else
			    {
				$hands_seq_l[$i] = \@in2;
			    }
			}
		    }
		}
	    }
	    else
	    {
		my @in = split(/\(/,$hands_seq);
		for(my $i=0; $i < $mjnJugglers; $i++)
		{	
		    $in[$i+1]=substr($in[$i+1],0,length($in[$i+1]) -1);
		    my @in_l = split(/,/,$in[$i+1]);
		    $hands_seq_l[$i] = \@in_l; 
		}		
	    }
	}

	my @color_table = @common::GRAPHVIZ_COLOR_TABLE;
	my @color_map = @{&__emptyMatrix($mjnJugglers,$period)};	
	my $default_color = $common::GRAPHVIZ_COLOR_TABLE[0];
	my $cpt_color = 0;
	my $color = $default_color;
	
	open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	    || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
	print GRAPHVIZ "digraph MJN_DIAGRAM{\n";    
	
	my $distance_label_slide = 2.2;
	my $angle_label_slide_orig = 180;
	my $angle_label_slide = 25;
	# Dictionnary to draw Edge Label in S mode
	my %label_hash = {};
	
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	
	foreach my $i (0..($mjnJugglers-1)) {
	    if (uc($jugglers) eq 'Y')
	    {
		print GRAPHVIZ "J$i [label=\"${jugglers_base}${i}\", shape=none]\n";
	    }
	    else {
		print GRAPHVIZ "J$i [label=\"\", shape=none]\n";
	    }
	}
	
	if (uc($title) ne "N" && uc($title) ne "NO") {
	    if($title_content eq "")
	    {
		print GRAPHVIZ "label=\"".lc($_[0])."\"\n"; 
	    }
	    else
	    {
		print GRAPHVIZ "label=\"".lc($title_content)."\"\n"; 
	    }
	}

	print GRAPHVIZ "nodesep=".$NODESEP."\n"; 
	if($splines_mode == 1) {
	    print GRAPHVIZ "splines=curved\n";
	}
	
	elsif($splines_mode == 2) {
	    print GRAPHVIZ "splines=line\n";
	}

	if(uc($quick eq "Y"))
	{
	    print GRAPHVIZ "nslimit=0.1\n nslimit1=0.1\n mclimit=0.1\n maxiter=0.1\n";
	}
	print GRAPHVIZ "\n\n";

	
	# Subgraphs
	foreach my $i (0..($mjnJugglers-1)) {	    
	    print GRAPHVIZ "subgraph diag_J${i} {\n";
	    print GRAPHVIZ "rank=same;\n";

	    foreach my $j (0..($period-1)) {	    	 		

		if (uc($hands) eq 'Y')
		{
		    my $side = $hands_seq_l[$i][$j%scalar @{$hands_seq_l[$i]}];
		    print GRAPHVIZ "\""."J${i}_".${j}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node J${i}_".${j}."\n";
		}	
		else
		{
		    if($matrix[$i][$j%$mjnPeriod] ne '0')
		    {
			print GRAPHVIZ "\""."J${i}_".${j}."\""." [label=\"\",  shape=circle, width=.2] // node J${i}_".${j}."\n";  
		    } else {	 
			print GRAPHVIZ "\""."J${i}_".${j}."\""." [label=\"\",  shape=point, width=.1] // node J${i}_".${j}."\n";
		    }
		}

	    }
	    
	    print GRAPHVIZ " J${i} -> J${i}_0 [style=invis]\n"; 
	    my $rtmp = "J${i}_0";
	    for (my $j = 1; $j < $period; $j++) {
		$rtmp = $rtmp." -> J${i}_".$j;
	    }
	    
	    print GRAPHVIZ $rtmp." [style=invis]\n";
	    print GRAPHVIZ "}\n";
	    print GRAPHVIZ "\n\n";   
	}
	
	# Connect subgraphs     
	foreach my $i (0..($mjnJugglers-2)) {
	    print GRAPHVIZ "J${i} -> J".(${i}+1)." [style=invis]\n";
	}
	foreach my $j (0..($period-1)) {
	    foreach my $i (0..($mjnJugglers-2)) {
		print GRAPHVIZ "\"J${i}_".${j}."\""."->"."\"J".(${i}+1)."_".${j}."\""." "." [style=invis]\n";
	    }
	}
	print GRAPHVIZ "\n\n";
	
	foreach my $j (0..($period-1)) {
	    foreach my $i (0..($mjnJugglers-1)) {
		if($matrix[$i][$j%$mjnPeriod] ne '0')
		{
		    my $src = "J${i}_${j}";
		    my $num_throw = 0;
		    
		    for(my $k=0; $k < length($matrix[$i][$j%$mjnPeriod]); $k++)
		    {
			my $dest = "J";
			my $throw = substr($matrix[$i][$j%$mjnPeriod],$k,1);
			my $destp = $j+hex($throw);
			my $destj = '';
			if($k+1 < length($matrix[$i][$j%$mjnPeriod]) && uc(substr($matrix[$i][$j%$mjnPeriod],$k+1,1)) eq "P")
			{
			    $destj = hex(substr($matrix[$i][$j%$mjnPeriod],$k+2,1)-1);
			    $k+=2;
			}
			elsif($k+1 < length($matrix[$i][$j%$mjnPeriod]) && uc(substr($matrix[$i][$j%$mjnPeriod],$k+1,1)) eq "X")
			{
			    if($k+2 < length($matrix[$i][$j%$mjnPeriod]) && uc(substr($matrix[$i][$j%$mjnPeriod],$k+2,1)) eq "P")
			    {
				$destj = hex(substr($matrix[$i][$j%$mjnPeriod],$k+3,1)-1);
				$k+=3;
			    }
			    else {
				$destj = ${i};
				$k+=2;
			    }				    				
			}
			else
			{
			    $destj = ${i};
			}
			$dest .= $destj.'_'.$destp;

			if($color_map[$i][$j] eq '0')
			{
			    $color = $color_table[$cpt_color];
			    $cpt_color = ($cpt_color+1)%(scalar @color_table);
			    my @color_throws = ();
			    push(@color_throws, $color);
			    $color_map[$i][$j] = \@color_throws;
			}
			else {
			    my @color_throws = @{$color_map[$i][$j]};
			    if($num_throw >= (scalar(@color_throws)))
			    {
				$color = $color_table[$cpt_color];
				$cpt_color = ($cpt_color+1)%(scalar @color_table);
				push(@color_throws, $color);
				$color_map[$i][$j] = \@color_throws;
			    }
			    else
			    {
				$color = $color_throws[$num_throw];
			    }
			}
			
			if($destp < $period && $color_map[$destj][$destp] eq '0')
			{
			    my @color_throws = ();
			    push(@color_throws, $color);
			    $color_map[$destj][$destp] = \@color_throws;
			}
			elsif($destp < $period)
			{
			    my @color_throws = @{$color_map[$destj][$destp]};
			    push(@color_throws, $color);
			    $color_map[$destj][$destp] = \@color_throws;
			}
			
			if($label_edge_colorization eq "E")
			{
			    $label_color=$color;
			}

			if($destp < $period)
			{
			    if($i == $destj && $i > ($mjnJugglers/2 -1) )
			    {
				if (uc($label_pos) eq "NONE"
				    || uc($label_pos) eq "NULL"
				    || uc($label_pos) eq "N"
				    || uc($label_pos) eq "NO" ) {
				    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "X") {
				    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", xlabel=\"".$throw."\"".", forcelabels=true, constraint=false]\n";
				}
				elsif (uc($label_pos) eq "M") {
				    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", label=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "H") {
				    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", headlabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "T") {
				    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", taillabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "S") {
				    if(exists $label_hash{ $src })
				    {	
					my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
					print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n";  
					$label_hash{ $src } ++;
				    }
				    else
				    {		
					my $angle = $angle_label_slide_orig;		       
					print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n"; 			
					$label_hash{ $src } = 1;
				    }				
				}

			    }
			    elsif($i == $destj)
			    {
				if (uc($label_pos) eq "NONE"
				    || uc($label_pos) eq "NULL"
				    || uc($label_pos) eq "N"
				    || uc($label_pos) eq "NO" ) {
				    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "X") {
				    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", xlabel=\"".$throw."\"".", forcelabels=true, constraint=false]\n";
				}
				elsif (uc($label_pos) eq "M") {
				    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", label=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "H") {
				    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", headlabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "T") {
				    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", taillabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "S") {
				    if(exists $label_hash{ $src })
				    {	
					my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
					print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n";  
					$label_hash{ $src } ++;
				    }
				    else
				    {		
					my $angle = $angle_label_slide_orig;		       
					print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n"; 			
					$label_hash{ $src } = 1;
				    }				
				}

			    }

			    else
			    {
				# Hack for a bug in direction type for edge in Graphviz with curved mode
				my $dir_type = "forward";
				if($splines_mode == 1)
				{
				    if($i > $destj)
				    {
					$dir_type="back";
				    }
				}				    				
				
				if (uc($label_pos) eq "NONE"
				    || uc($label_pos) eq "NULL"
				    || uc($label_pos) eq "N"
				    || uc($label_pos) eq "NO" ) {
				    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "X") {
				    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", xlabel=\"".$throw."\"".", forcelabels=true, constraint=false]\n";
				}
				elsif (uc($label_pos) eq "M") {
				    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", label=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "H") {
				    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", headlabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "T") {
				    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", color=\"".$color."\", taillabel=\"".$throw."\"".", constraint=false]\n";
				}
				elsif (uc($label_pos) eq "S") {
				    if(exists $label_hash{ $src })
				    {	
					my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
					print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n";  
					$label_hash{ $src } ++;
				    }
				    else
				    {		
					my $angle = $angle_label_slide_orig;		       
					print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=$dir_type,  fontcolor=".$label_color.", fontname=\"Times-Bold\", taillabel=\"".$throw."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", constraint=false]\n"; 			
					$label_hash{ $src } = 1;
				    }				
				}								
			    }

			    $num_throw ++;
			}
		    }
		    
		}
		
	    }
	}

	print GRAPHVIZ "}";
	close GRAPHVIZ;        
	
	if ($silence == 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_GENERAL_GRAPHVIZ;
	}
	
	system("\"".$conf::GRAPHVIZ_BIN."\\".$genFilter.".exe\" -T".$fileOutputType." -Nfontsize=\"12\" -Efontsize=\"12\" -v -o"."$conf::RESULTS/$fileOutput"." $conf::TMPDIR\\${fileOutput}.graphviz");   
	
	if (uc($graphviz_output) eq "Y")
	{
	    use File::Copy;
	    copy("$conf::TMPDIR\\${fileOutput}.graphviz","$conf::RESULTS/");
	}
	
	if ($MJN_DEBUG <= 0) {
	    unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
	}
	
	print "\n";
	if ($silence == 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_DRAW_1." : "."$conf::RESULTS/$fileOutput"."\n\n";    
	}

    }




    

    
}



1;
