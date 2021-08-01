#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## MMSTD.pm  -  Perl Implementation of the Extended S,O,U juggling Notation ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2020 Frederic Roudaut  <frederic.roudaut@free.fr>     ##
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

package MMSTD;
use Set::Scalar;
use common;
use strict;
use lang;
use Term::ANSIColor;        

$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

our $MMSTD_INFO = "MMSTD (Mills Mess State Transition) juggling Notation";
our $MMSTD_HELP = $lang::MSG_MMSTD_MENU_HELP;
our $MMSTD_VERSION = "v1.4";

our %MMSTD_CMDS = 
    (    
	 'isEquivalent'          => [$lang::MSG_MMSTD_MENU_ISEQUIVALENT_1, $lang::MSG_MMSTD_MENU_ISEQUIVALENT_2], 			 
	 'isSymetric'            => [$lang::MSG_MMSTD_MENU_ISSYMETRIC_1, $lang::MSG_MMSTD_MENU_ISSYMETRIC_2], 			 
	 'isValid'               => [$lang::MSG_MMSTD_MENU_ISVALID_1, $lang::MSG_MMSTD_MENU_ISVALID_2], 			 
	 'sym'                   => [$lang::MSG_MMSTD_MENU_SYM_1, $lang::MSG_MMSTD_MENU_SYM_2], 			 
	 'inv'                   => [$lang::MSG_MMSTD_MENU_INV_1, $lang::MSG_MMSTD_MENU_INV_2], 			 
	 'size'                  => [$lang::MSG_MMSTD_MENU_SIZE_1, $lang::MSG_MMSTD_MENU_SIZE_2], 			 
	 'genByState'            => [$lang::MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_1, $lang::MSG_MMSTD_MENU_GENALLPATTERNSBYSTATE_2],
	 'gen'                   => [$lang::MSG_MMSTD_MENU_GENALLPATTERNS_1, $lang::MSG_MMSTD_MENU_GENALLPATTERNS_2],
	 'graph'                 => [$lang::MSG_MMSTD_MENU_GRAPH_1, $lang::MSG_MMSTD_MENU_GRAPH_2],
	 'toSOU'                 => [$lang::MSG_MMSTD_MENU_TOSOU_1, $lang::MSG_MMSTD_MENU_TOSOU_2],
    );

print "MMSTD $MMSTD::MMSTD_VERSION loaded\n";

# To add debug behaviour 
our $MMSTD_DEBUG=-1;

#MMSTD Graph as defined in the MMSTD Notation 
my %graph_mmstd = (    
    'Rl'  => [['Rr', '+'],['Rr', 'o'],['Ur', '+']],
    'Rr'  => [['Rl', '+'],['Rl', 'o'],['Ul', '+']],
    'Ul'  => [['Rr', 'o'],['Ur', 'o'],['Ur', '+'],['Lr', 'o']],
    'Ur'  => [['Ul', '+'],['Ul', 'o'],['Rl', 'o'],['Ll', 'o']],
    'Ll'  => [['Ur', '+'],['Lr', 'o'],['Lr', '+']],
    'Lr'  => [['Ul', '+'],['Ll', 'o'],['Ll', '+']]
    );



sub __genPatternsFromState {
    
    my $init_state = $_[0];
    my $end_state = $_[1];
    my $cpt = $_[2];
    my %cpt_states = %{$_[3]};
    my $path_len_max = $_[4];
    my $path_len = $_[5];
    
    &common::displayComputingPrompt();
    
    my $result = new Set::Scalar();    
    $cpt_states{${init_state}} +=  1;
    
    foreach my $edge (@{$graph_mmstd{$init_state}})
    {	
	if($end_state eq @{$edge}[0])
	{
	    $result=$result->insert("${init_state}-@{$edge}[1]-\>${end_state}");
	}
	
	if($cpt_states{@{$edge}[0]} < $cpt) 
	{	    
	    my $path_len_tmp = $path_len + 1;
	    if ($path_len_max < 0 || ($path_len_max > 0 && $path_len_tmp < $path_len_max))
	    {		
		my $result_tmp = new Set::Scalar();		
		$result_tmp = &__genPatternsFromState(@{$edge}[0],$end_state, $cpt, \%cpt_states, $path_len_max, $path_len_tmp);
		
		if($result_tmp->size > 0)
		{
		    while (defined(my $el = $result_tmp->each))
		    {
			$result = $result->insert("${init_state}-@{$edge}[1]-\>${el}");
		    }
		}
		
	    }
	}
    }

    return $result;
}


sub __displayByPatternLength 
{
    my %res = ();   
    my $results = ${$_[0]};

    while (defined(my $el = $results->each)) {
	my $size = &size($el,-1);

	if(defined ($res{$size}))
	{
	    $res{$size}->insert($el);
	}
	else 
	{
	    $res{$size} = new Set::Scalar();
	    $res{$size}->insert($el);
	}
    }
    
    while ( my ($key, $value) = each(%res) ) 
    {
	my $size = ${value}->size;

	if(scalar @_ == 2)
	{
	    open(FILE,">>$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
	    print FILE "\n\n$key ";
	    print FILE $lang::MSG_MMSTD_GENPATTERN_4; 
	    print FILE " : ($size) \n\n\t";
	    $value->as_string_callback(sub{join("\n\t",sort $_[0]->elements)});
	    print FILE "${value}";
	    close FILE;
	}

	else
	{
	    print colored [$common::COLOR_RESULT], "\n\n$key ";
	    print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_4; 
	    print colored [$common::COLOR_RESULT], " : ($size) \n\n\t";
	    $value->as_string_callback(sub{join("\n\t",sort $_[0]->elements)});
	    print "${value}";
	}
    }
    #print "\n\n";
}


sub __display
{
    my $results = ${$_[0]};

    if(scalar @_ == 2)
    {
	open(FILE,">>$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "\n==========================================================================\n";
	print FILE $lang::MSG_MMSTD_GENPATTERN_1;
	print FILE $results->size;
	print FILE $lang::MSG_MMSTD_GENPATTERN_3;    
	print FILE "==========================================================================\n";
	
	print FILE join("\n",sort $results->elements);
    }
    
    else
    {
	print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_1;
	print colored [$common::COLOR_RESULT], $results->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_3;    
	print colored [$common::COLOR_RESULT], "==========================================================================\n";

	print join("\n",sort $results->elements);
	print "\n\n";
    }
}



sub isEquivalent 
{
    my $pattern1 = uc($_[0]);
    $pattern1 =~ s/\s+//g;
    my $pattern2 = uc($_[1]);
    $pattern2 =~ s/\s+//g;    

    my @tabTmp = split(/-|>/, $pattern1);
    my @tab1 = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab1, $tabTmp[$i]);
	}
    }

    if((((scalar @tab1) %2) == 0) && ($tabTmp[$#tabTmp] eq "+" || $tabTmp[$#tabTmp] eq "O"))
    {
	push(@tab1, $tabTmp[0]);
    }

    @tabTmp = split(/-|>/, $pattern2);
    my @tab2 = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab2, $tabTmp[$i]);
	}
    }

    if((((scalar @tab2) %2) == 0) && ($tabTmp[$#tabTmp] eq "+" || $tabTmp[$#tabTmp] eq "-"))
    {
	push(@tab2, $tabTmp[0]);
    }

    my $i = 0;
    my $j = 0;
    my $jRest=scalar @tab1;
    my $firstIdx=0;
    my $idx = 0;

    while(($i < (scalar @tab1)) && ($jRest > 0)) 
    {
	if($tab1[$i] eq $tab2[$j])
	{
	    if($firstIdx==0)
	    {
		$idx = $j;
		$firstIdx=1;		
	    }

	    $i ++;

	    if($j == ($#tab1))
	    {
		#the pattern is a loop
		if($tab1[0] eq $tab1[$#tab1]) 
		{
		    $j=1;
		}
		else 
		{
		    $j=0;
		}
	    }

	    else
	    {		
		$j ++;
	    }
	}
	
	else
	{
	    $i = 0;
	    if($firstIdx==1)
	    {
		$firstIdx=0;		
		$j = $idx + 1;
	    }
	    else
	    {
		$j ++;
	    }

	    $jRest --;
	}		
    }
    
    if($i == (scalar @tab1))
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	return 1;	
    }
    else 
    {
	if((scalar @_ == 2) || ($_[2] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
}


sub isValid
{
    my %graph_mmstd_tmp = ();
    while (my ($key, $val) = each(%graph_mmstd))
    {
	$graph_mmstd_tmp{uc($key)} = $val;
    }

    my $pattern = uc($_[0]);
    $pattern =~ s/\s+//g;
    my $lastState="";
    my $curExch="";
    
    my @tabTmp = split(/-|>/, $pattern);
    my @tab = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab, $tabTmp[$i]);
	}
    }
    
    if((((scalar @tab) % 2)  != 0) && (@tab[0] ne @tab[$#tab]))
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False ";
	    print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR1}\n";
	}
	return -1;	
    }
    
    for my $i (0..$#tab)
    {
	if($i % 2 == 0)
	{
	    if($tab[$i] ne "LL" && $tab[$i] ne "LR" && $tab[$i] ne "UL" && $tab[$i] ne "UR" && $tab[$i] ne "RL" && $tab[$i] ne "RR") 
	    {
		if((scalar @_ == 1) || ($_[1] != -1))
		{
		    print colored [$common::COLOR_RESULT], "False ";
		    print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR2} ";
		    print colored [$common::COLOR_RESULT], "<${tab[$i]}>)\n";
		}		
		return -1;
	    }	 

	    else
	    {
		if($lastState ne "")
		{
		    my $found = -1;		
		    
		    foreach my $edge (@{$graph_mmstd_tmp{$lastState}})
		    {	
			if(($curExch eq uc(@{$edge}[1])) && ($tab[$i]) eq uc(@{$edge}[0]))
			{
			    $found = 1;			    
			    last;
			}
		    }
		    
		    if ($found == -1)
		    {
			if((scalar @_ == 1) || ($_[1] != -1))
			{
			    print colored [$common::COLOR_RESULT], "False ";
			    print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR3} ";
			    print colored [$common::COLOR_RESULT], ": [${lastState},${curExch}] => $tab[$i])\n";
			}
			
			return -1;
		    }
		}
		
		$lastState=$tab[$i];
	    }
	}
	
	else
	{
	    if($tab[$i] ne "+" && $tab[$i] ne "O")
	    {
		if((scalar @_ == 1) || ($_[1] != -1))
		{
		    print colored [$common::COLOR_RESULT], "False ";
		    print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR4} ";
		    print colored [$common::COLOR_RESULT], "<${tab[$i]}>)\n";
		}
		
		return -1;
	    }

	    else
	    {
		$curExch="$tab[$i]";

		if($lastState ne "")
		{
		    my $found = -1;

		    #to treat patterns ending with an exchange
		    if($i==$#tab)
		    {		    		    		    
			foreach my $edge (@{$graph_mmstd_tmp{$lastState}})
			{	
			    if(($curExch eq uc(@{$edge}[1])) && ($tab[0]) eq uc(@{$edge}[0]))
			    {
				$found = 1;			    
				last;
			    }
			}	      	
			
			if ($found == -1)
			{
			    if((scalar @_ == 1) || ($_[1] != -1))
			    {
				print colored [$common::COLOR_RESULT], "False ";
				print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR3} ";
				print colored [$common::COLOR_RESULT], ": [${lastState},${curExch}] => $tab[0])\n";
			    }
			    
			    return -1;
			}		    
			
		    }
		    
		    else
		    {
			foreach my $edge (@{$graph_mmstd_tmp{$lastState}})
			{	
			    if($curExch eq uc(@{$edge}[1]))
			    {
				$found = 1;			   
				last;
			    }
			}
			
			if ($found == -1)
			{
			    if((scalar @_ == 1) || ($_[1] != -1))
			    {
				print colored [$common::COLOR_RESULT], "False ";
				print colored [$common::COLOR_RESULT], "${lang::MSG_MMSTD_ISVALID_ERR3} ";
				print colored [$common::COLOR_RESULT], ": [${lastState},${curExch}])\n";
			    }
			    
			    return -1;
			}		    

		    }

		}
	    }

	}
    }

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    
    return 1;
}



sub inv
{
    my $pattern1 = uc($_[0]);
    $pattern1 =~ s/\s+//g;

    my $inv_pattern1 = "";
    
    my @tabTmp = split(/-|>/, $pattern1);
    my @tab1 = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab1, $tabTmp[$i]);
	}
    }
    
    for my $i (0..$#tab1)
    {
	if($tab1[$i] eq "+" )
	{
	    $inv_pattern1 = "${inv_pattern1}-o->";
	}
	elsif($tab1[$i] eq "O")
	{
	    $inv_pattern1 = "${inv_pattern1}-+->";
	}
	elsif($tab1[$i] eq "LL") 
	{
	    $inv_pattern1 = "${inv_pattern1}Lr";
	}
	elsif($tab1[$i] eq "LR") 
	{
	    $inv_pattern1 = "${inv_pattern1}Ll";
	}
	elsif($tab1[$i] eq "RR") 
	{
	    $inv_pattern1 = "${inv_pattern1}Rl";
	}
	elsif($tab1[$i] eq "RL") 
	{
	    $inv_pattern1 = "${inv_pattern1}Rr";
	}
	elsif($tab1[$i] eq "UL") 
	{
	    $inv_pattern1 = "${inv_pattern1}Ur";
	}
	elsif($tab1[$i] eq "UR") 
	{
	    $inv_pattern1 = "${inv_pattern1}Ul";
	}    	
	else
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_MMSTD_INV_ERR1} $_[0] ${lang::MSG_MMSTD_INV_ERR1b}${tab1[$i]}${lang::MSG_MMSTD_INV_ERR1c}";
	    return -1;
	}

    }
    
    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$inv_pattern1\n";
    }
    return $inv_pattern1;
}


sub isSymetric 
{
    my $pattern1 = uc($_[0]);
    $pattern1 =~ s/\s+//g;
    
    my $sym_pattern1 = "";

    my @tabTmp = split(/-|>/, $pattern1);
    my @tab1 = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab1, $tabTmp[$i]);
	}
    }

    
    for my $i (0..$#tab1)
    {
	if( $tab1[$i] eq "+" || $tab1[$i] eq "O")
	{
	    $sym_pattern1 = "${sym_pattern1}-$tab1[$i]\->";
	}
	elsif($tab1[$i] eq "RL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Lr";
	}
	elsif($tab1[$i] eq "RR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ll";
	}
	elsif($tab1[$i] eq "LR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Rl";
	}
	elsif($tab1[$i] eq "LL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Rr";
	}
	elsif($tab1[$i] eq "UR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ul";
	}
	elsif($tab1[$i] eq "UL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ur";
	}
	else
	{
	    if((scalar @_ == 2) || ($_[2] != -1))
	    {
		print colored [$common::COLOR_RESULT], "False\n";
	    }

	    print colored [$common::COLOR_ERR], "${lang::MSG_MMSTD_ISSYMETRIC_ERR1} $_[0] ${lang::MSG_MMSTD_ISSYMETRIC_ERR1b}${tab1[$i]}${lang::MSG_MMSTD_ISSYMETRIC_ERR1c}";	
	    return -1;
	}
    }
    
    if((scalar @_ == 2) || ($_[2] != -1))
    {
	return &isEquivalent($sym_pattern1,$_[1]);
    }

    else
    {
	return &isEquivalent($sym_pattern1,$_[1],$_[2]);
    }
}

sub sym 
{
    my $pattern1 = uc($_[0]);
    $pattern1 =~ s/\s+//g;

    my $sym_pattern1 = "";
    
    my @tabTmp = split(/-|>/, $pattern1);
    my @tab1 = ();

    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab1, $tabTmp[$i]);
	}
    }
    
    for my $i (0..$#tab1)
    {
	if( $tab1[$i] eq "+")
	{
	    $sym_pattern1 = "${sym_pattern1}-+->";
	}
	elsif($tab1[$i] eq "O")
	{
	    $sym_pattern1 = "${sym_pattern1}-o->";
	}
	elsif($tab1[$i] eq "RR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ll";
	}
	elsif($tab1[$i] eq "LL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Rr";
	}
	elsif($tab1[$i] eq "RL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Lr";
	}
	elsif($tab1[$i] eq "LR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Rl";
	}
	elsif($tab1[$i] eq "UR") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ul";
	}
	elsif($tab1[$i] eq "UL") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ur";
	}
	else
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_MMSTD_SYM_ERR1} $_[0] ${lang::MSG_MMSTD_SYM_ERR1b}${tab1[$i]}${lang::MSG_MMSTD_SYM_ERR1c}";	
	    return -1;
	}
    }

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$sym_pattern1\n";
    }    

    return $sym_pattern1;
}


sub toSOU
{
    my $pattern = uc($_[0]);
    $pattern =~ s/\s+//g;

    my $SOUpattern = "";    
    
    my @tabTmp = split(/-|>/, $pattern);
    my @tab1 = ();
    
    for my $i (0..$#tabTmp)
    {
	if($tabTmp[$i] ne "")
	{
	    push(@tab1, $tabTmp[$i]);
	}
    }
    
    for my $i (0..$#tab1)
    {
	if($tab1[$i] eq "O" )
	{
	    $SOUpattern = "${SOUpattern}<out>";
	}
	elsif($tab1[$i] eq "+")
	{
	    $SOUpattern = "${SOUpattern}<in>";
	}	    
	elsif($tab1[$i] eq "RR") 
	{
	    $SOUpattern = "${SOUpattern}O";
	}
	elsif($tab1[$i] eq "LL") 
	{
	    $SOUpattern = "${SOUpattern}Ob";
	}
	elsif($tab1[$i] eq "LR") 
	{
	    $SOUpattern = "${SOUpattern}U";
	}
	elsif($tab1[$i] eq "RL") 
	{
	    $SOUpattern = "${SOUpattern}Ub";
	}
	elsif($tab1[$i] eq "UR") 
	{
	    $SOUpattern = "${SOUpattern}S";
	}
	elsif($tab1[$i] eq "UL") 
	{
	    $SOUpattern = "${SOUpattern}Sb";
	}	
	else 
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_MMSTD_TOSOU_ERR1} $_[0] ${lang::MSG_MMSTD_TOSOU_ERR1b}${tab1[$i]}${lang::MSG_MMSTD_TOSOU_ERR1c}";
	    return -1;
	}
    }

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$SOUpattern\n";
    }    

    return $SOUpattern;
}


sub size
{
    my $pattern = uc($_[0]);
    $pattern =~ s/\s+//g;
    
    my $nb = 0;
    my @liste = $pattern =~ /UL-/ig;
    $nb += @liste;
    @liste = $pattern =~ /UR-/ig;
    $nb += @liste;
    @liste = $pattern =~ /LL-/ig;
    $nb += @liste;
    @liste =  $pattern =~ /LR-/ig;
    $nb += @liste;
    @liste = $pattern =~ /RL-/ig;
    $nb += @liste;
    @liste =  $pattern =~ /RR-/ig;
    $nb += @liste;

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$nb\n";
    }

    return $nb;    
}


sub genByState
{
    my $cpt = $_[0];
    my $path_len_max = $_[1];

    while ( my ($key) = each(%graph_mmstd) ) {
	my %cpt_states=(
	    'Ul' => 0,
	    'Ur' => 0,
	    'Rl' => 0,
	    'Rr' => 0,
	    'Lr' => 0,
	    'Ll' => 0
	    );

	my $results = new Set::Scalar();
	my $results = &__genPatternsFromState($key,$key,$cpt,\%cpt_states,$path_len_max,0);
	&common::hideComputingPrompt();

	if(scalar @_ == 3)
	{
	    open(FILE,">$conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	    print FILE "\n==========================================================================\n";
	    print FILE $lang::MSG_MMSTD_GENPATTERN_1;
	    print FILE $results->size;
	    print FILE $lang::MSG_MMSTD_GENPATTERN_2;
	    print FILE "$key :\n";
	    print FILE "==========================================================================\n";
	    close FILE;	    
	    __displayByPatternLength(\$results, $_[2]);	    
	}
	
	else
	{
	    print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_1;
	    print colored [$common::COLOR_RESULT], $results->size;
	    print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_2;
	    print colored [$common::COLOR_RESULT], "$key :\n";
	    print colored [$common::COLOR_RESULT], "==========================================================================\n";
	    __displayByPatternLength(\$results);
	}
    }
    
    print "\n\n";

}

sub gen
{
    my $cpt = $_[0];
    my $path_len_max = $_[1];
    my $res = new Set::Scalar();
    my $results = new Set::Scalar();
    
    my %cpt_states=(
	'Ul' => 0,
	'Ur' => 0,
	'Rl' => 0,
	'Rr' => 0,
	'Ll' => 0,
	'Lr' => 0
	);
    
    
    while ( my ($key) = each(%graph_mmstd) ) {
	$results = $results->union(&__genPatternsFromState($key,$key,$cpt,\%cpt_states,$path_len_max,0));   	
	$cpt_states{$key}=$cpt + 1; 
    }
    
    &common::hideComputingPrompt();
    
    if(scalar @_ == 3)
    {
	open(FILE,">$conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "\n==========================================================================\n";
	print FILE $lang::MSG_MMSTD_GENPATTERN_1;
	print FILE $results->size;
	print FILE $lang::MSG_MMSTD_GENPATTERN_3;    
	print FILE "==========================================================================\n";
	close FILE;	    
	__displayByPatternLength(\$results, $_[2]);
    }
    
    else
    {
	print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_1;
	print colored [$common::COLOR_RESULT], $results->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_MMSTD_GENPATTERN_3;    
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	
	__displayByPatternLength(\$results);
    }

    print "\n\n";
}


sub graph
{    
    sub __get_idx_state
    {
	my @states=@{$_[0]};
	my $el_to_find=$_[1];
	my $cpt = 0;
	
	foreach my $el (@states) {
	    if ($el eq $el_to_find) {
		return $cpt;
	    }
	    $cpt ++;
	}
	
	return -1;
    }

if (scalar @_ >= 1 && $_[0] ne "-1")
{
    # Graphviz must be installed prior
    
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

    # Generation Filters are the following :
    #     - circo : filter for circular layout of graphs // Default one
    #     - dot : filter for drawing directed graphs
    #     - neato : filter for drawing undirected graphs
    #     - twopi : filter for radial layouts of graphs    
    #     - fdp : filter for drawing undirected graphs
    #     - sfdp : filter for drawing large undirected graphs    
    #     - osage : filter for drawing clustered graphs

    # Generation Filters are the following :
    #     - circo : filter for circular layout of graphs // Default one
    #     - dot : filter for drawing directed graphs
    #     - neato : filter for drawing undirected graphs
    #     - twopi : filter for radial layouts of graphs    
    #     - fdp : filter for drawing undirected graphs
    #     - sfdp : filter for drawing large undirected graphs    
    #     - osage : filter for drawing clustered graphs

    my $fileOutput=$_[0];
    my $fileOutputType="png";
    my $genFilter="circo";
    if (scalar @_ > 1) {
	$fileOutputType=$_[1];
    }
    if (scalar @_ > 2) {
	$genFilter=$_[2];
    }

    open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	|| die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
    print GRAPHVIZ "digraph MMSTD_Graph{\n";    	
    print GRAPHVIZ "node [color=blue]\n";

    my @graph_mmstd2 = ();
    my @states_list = sort keys %graph_mmstd;

    foreach my $state (@states_list)
    {
	my $idx = __get_idx_state(\@states_list,$state);
	my @edges = @{$graph_mmstd{$state}};
	foreach my $edge (@edges)
	{       
	    my $nstate = @{$edge}[0];
	    my $idx_nstate = __get_idx_state(\@states_list,$nstate);
	    my $v=@{$edge}[1];
	    
	    if ($graph_mmstd2[$idx][$idx_nstate] eq "")
	    { 
		$graph_mmstd2[$idx][$idx_nstate] = $v;
	    }
	    else
	    {
		$graph_mmstd2[$idx][$idx_nstate] = $v.";".($graph_mmstd2[$idx][$idx_nstate]); 
	    }	    
	}
    }

    foreach my $state (sort keys %graph_mmstd)
    {
	print GRAPHVIZ ${state}." [label=\"".${state}."\"] // node ".${state}."\n";	    
	foreach my $state2 (sort keys %graph_mmstd)
	{
	    if($graph_mmstd2[__get_idx_state(\@states_list,${state})][__get_idx_state(\@states_list,${state2})] ne "")
	    {
		print GRAPHVIZ ${state}."->".${state2}." [label=\"".$graph_mmstd2[__get_idx_state(\@states_list,${state})][__get_idx_state(\@states_list,${state2})]."\", fontcolor=red]\n";	
	    }
	}
    }
    
    print GRAPHVIZ "}";
    close GRAPHVIZ;        
    print $lang::MSG_GENERAL_GRAPHVIZ;
    system("\"".$conf::GRAPHVIZ_BIN."\\".$genFilter.".exe\" -T".$fileOutputType." -Nfontsize=\"12\" -Efontsize=\"12\" -v -o"."$conf::RESULTS/$fileOutput"." $conf::TMPDIR\\${fileOutput}.graphviz");      

    if ($MMSTD_DEBUG <= 0)
    {
	unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
    }

}
else
{
    foreach my $state (sort keys %graph_mmstd)
    {
	my $edgeLength=0;
	print colored [$common::COLOR_RESULT], "$state ";
	print (' ' x (3 - length($state))); 
	print  colored [$common::COLOR_RESULT], "=>     ";
	foreach my $edge (@{$graph_mmstd{$state}})
	{
	    print "\[";
	    print @{$edge}[1];
	    print ",";
	    print @{$edge}[0];
	    print "\]";
	    $edgeLength=length(@{$edge}[1]) + length(@{$edge}[0]) + 5;
	    print (' ' x (10 - $edgeLength + 5)); 
	}
	print "\n";
    }
}
}



sub __test 
{

    my %cpt_states_tmp=(
	'Rr' => 0,
	'Rl' => 0,
	'Lr' => 0,
	'Ll' => 0,
	'UR' => 0,
	'Ul' => 0
	);

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Gen Pattern From State : (\'O\',\'O\',1,%pt_states_tmp,-1,0);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";

    my $result = new Set::Scalar();
    my $result = &__genPatternsFromState('Rr','Rr',1,\%cpt_states_tmp,-1,0);
    $result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
    print "\n\n";
    print $result;
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::__display(\$result);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &__display(\$result);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::__displayByPatternLength(\$result);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &__displayByPatternLength(\$result);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::genByState(1,-1);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &genByState(1,-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::gen(1,-1);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &gen(1,-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::gen(1,12);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &gen(1,12);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"Ur -o-> Ll -+-> Ur\",\"Ur -o-> Ll -o-> Ur\");\n\t\t==> False, -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("Ur -o-> Ll -+-> Ur","Ur -o-> Ll -o-> Ur");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"Ur -o-> Ll -+-> \",\"Ur -o-> Ll -+-> Ur\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("Ur -o-> Ll -+->","Ur -o-> Ll -+-> Ur");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"S<in>O<out>S\",\"O<out>S<in>O\");\n\t\t==> False, -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<in>O<out>S","O<out>S<in>O");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"Ur -o-> Ll -+-> Ur\",\"Ur -o-> Ll -+->\",-1);\n\t\t==> 1\n"; 
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("Ur -o-> Ll -+-> Ur","Ur -o-> Ll -+->",-1); 
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"Ur -o-> Ll -+-> Ur\",\"Ll -+-> Ur -o-> Ll\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("Ur -o-> Ll -+-> Ur","Ll -+-> Ur -o-> Ll");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isEquivalent(\"Ur -o-> Ll -+-> Ur\",\"Ur -o-> Ll\");\n\t\t==> False, -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("Ur -o-> Ll -+-> Ur","Ur -o-> Ll");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isSymetric(\"Ur -o-> Ll -+-> Ur\",\"Ur -o-> Ll -+-> Ur\",-1);\n\t\t==> -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isSymetric("Ur -o-> Ll -+-> Ur","Ur -o-> Ll -+-> Ur",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isSymetric(\"Ur -o-> Ll -+-> Ur\",\"Ul -o-> Rr -+-> Ul\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isSymetric("Ur -o-> Ll -+-> Ur","Ul -o-> Rr -+-> Ul");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::sym(\"Ur -o-> Ll -+-> Ur\",-1);\n\t\t==> Ul-o->Rr-+->Ul\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &sym("Ur -o-> Ll -+-> Ur",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::sym(\"Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL\",-1);\n\t\t==> Ul-o->Ur-+->Ll-o->Lr-+->Rl-o->Rr\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &sym("Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::sym(\"Ur -o-> Ll -+->\");\n\t\t==> Ul-o->Rr-+->\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &sym("Ur -o-> Ll -+->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::sym(\"Ur -o-> Ll\");\n\t\t==> Ul-o->Rr\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &sym("Ur -o-> Ll");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isValid(\"Rr -+-> Ul -o-> Rr\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("Rr -+-> Ul -o-> Rr",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ul -o->\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ul -o->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ul\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ul");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> UY -o->\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> UY -o->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -Rr-> Ul -o->\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -Rr-> Ul -o->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ul -+->\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ul -+->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::isValid(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -U-> Lr -+-> Ll -+-> Ul -o-> Rr\",-1);\n\t\t==> -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -U-> Lr -+-> Ll -+-> Ul -o-> Rr",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ug -o-> Lr -+-> Ll -+-> Ul -o-> Rr\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ug -o-> Lr -+-> Ll -+-> Ul -o-> Rr");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul -o->\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul -o->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::isValid(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -UR-> Ul -o-> Rr\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -UR-> Ul -o-> Rr");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::inv(\"Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL\",-1);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &inv("Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::inv(\"Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL -+->\");\n\t\t==> Ul-+->Ur-o->Rl-+->Rr-o->Ll-+->Lr-o->\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &inv("Ur -o-> Ul -+-> Rr  -o-> Rl -+-> Lr -o->     LL -+->");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::size(\"Ur-+->Ul-o->Rl-+-> Rl -o-> Ur\");\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("Ur-+->Ul-o->Rl-+-> Rl -o-> Ur");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::size(\"Ur-+->Ul-o->Rl-+-> Rl -o-> Ur\",-1);\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &size("Ur-+->Ul-o->Rl-+-> Rl -o-> Ur",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::size(\"Ur-+->Ul-o->Rl-+-> Rl -o->\",-1);\n\t\t==> 4\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &size("Ur-+->Ul-o->Rl-+-> Rl -o->",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::size(\"Ur-+->Ul-o->Rl-+-> Rl\",-1);\n\t\t==> 3\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &size("Ur-+->Ul-o->Rl-+-> Rl",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::toSOU(\"Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul -o-> Rl\"); \n\t\t ===> O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &toSOU("Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul -o-> Rl");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint MMSTD::toMMSTD(\"Ll -+-> Ur -o-> Ll\",-1); \n\t\t ===> Ob<in>S<out>Ob\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &toSOU("Ll -+-> Ur -o-> Ll",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tMMSTD::graph();\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &graph();
    print "\n\n";

}

1;
