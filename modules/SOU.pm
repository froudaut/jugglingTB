#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## SOU.pm   -  Perl Implementation of the Extended S,O,U juggling Notation  ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2008-2020  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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

package SOU;
use Set::Scalar;
use common;
use strict;
use lang;
use Term::ANSIColor;        
#use modules::SOU_GRAMMAR;


$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

our $SOU_INFO = "Extended S,O,U juggling Notation";
our $SOU_HELP = $lang::MSG_SOU_MENU_HELP;
our $SOU_VERSION = "v1.4";

our %SOU_CMDS = 
    (    
	 'isEquivalent'          => [$lang::MSG_SOU_MENU_ISEQUIVALENT_1, $lang::MSG_SOU_MENU_ISEQUIVALENT_2], 			 
	 'isSymetric'            => [$lang::MSG_SOU_MENU_ISSYMETRIC_1, $lang::MSG_SOU_MENU_ISSYMETRIC_2], 			 
	 'isValid'               => [$lang::MSG_SOU_MENU_ISVALID_1, $lang::MSG_SOU_MENU_ISVALID_2], 			 
	 'sym'                   => [$lang::MSG_SOU_MENU_SYM_1, $lang::MSG_SOU_MENU_SYM_2], 			 
	 'inv'                   => [$lang::MSG_SOU_MENU_INV_1, $lang::MSG_SOU_MENU_INV_2], 			 
	 'size'                  => [$lang::MSG_SOU_MENU_SIZE_1, $lang::MSG_SOU_MENU_SIZE_2], 			 
	 'genByState' => [$lang::MSG_SOU_MENU_GENALLPATTERNSBYSTATE_1, $lang::MSG_SOU_MENU_GENALLPATTERNSBYSTATE_2],
	 'gen'        => [$lang::MSG_SOU_MENU_GENALLPATTERNS_1, $lang::MSG_SOU_MENU_GENALLPATTERNS_2],
	 'graph'                 => [$lang::MSG_SOU_MENU_GRAPH_1, $lang::MSG_SOU_MENU_GRAPH_2],
	 'toMMSTD'               => [$lang::MSG_SOU_MENU_TOMMSTD_1, $lang::MSG_SOU_MENU_TOMMSTD_2],
    );

print "SOU $SOU::SOU_VERSION loaded\n";

# To add debug behaviour 
our $SOU_DEBUG=-1;


#SOU Graph as defined in the MMSTD Notation
my %graph_sou = (    
    'O'  => [['Ub', '<in>'],['Ub', '<out>'],['Sb', '<in>']],
    'S'  => [['Sb', '<in>'],['Sb', '<out>'],['Ub', '<out>'],['Ob', '<out>']],
    'U'  => [['Sb', '<in>'],['Ob', '<in>'],['Ob', '<out>']],
    'Ob' => [['U', '<in>'],['U', '<out>'],['S', '<in>']],
    'Sb' => [['O', '<out>'],['S', '<out>'],['S', '<in>'],['U', '<out>']],
    'Ub' => [['S', '<in>'],['O', '<in>'],['O', '<out>']]
    );



#sub tst
#{
#    my $res= SOU_GRAMMAR::parse($_[0]);
    #print @$res;
    #print "\n";
#}

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
    
    foreach my $edge (@{$graph_sou{$init_state}})
    {	
	if($end_state eq @{$edge}[0])
	{
	    $result=$result->insert("${init_state}@{$edge}[1]${end_state}");
	}
	
	if($cpt_states{@{$edge}[0]} < $cpt) 
	{
	    
	    my $path_len_tmp = $path_len + 1;
	    if ($path_len_max < 0 || ($path_len_max > 0 && $path_len_tmp < $path_len_max))
	    {		
		my $result_tmp = new Set::Scalar();
		
		my $result_tmp = &__genPatternsFromState(@{$edge}[0],$end_state, $cpt, \%cpt_states, $path_len_max, $path_len_tmp);
		
		if($result_tmp->size > 0)
		{
		    while (defined(my $el = $result_tmp->each))
		    {
			$result = $result->insert("${init_state}@{$edge}[1]${el}");
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
	my @liste = $el =~ /<*>/ig; 
	if(defined ($res{scalar @liste}))
	{
	    $res{scalar @liste}->insert($el);
	}
	else 
	{
	    $res{scalar @liste} = new Set::Scalar();
	    $res{scalar @liste}->insert($el);
	}
    }

    while ( my ($key, $value) = each(%res) ) 
    {
	my $size = ${value}->size;

	if(scalar @_ == 2)
	{
	    open(FILE,">>$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
	    print FILE "\n\n$key ";
	    print FILE $lang::MSG_SOU_GENPATTERN_4; 
	    print FILE " : ($size) \n\n\t";
	    $value->as_string_callback(sub{join("\n\t",sort $_[0]->elements)});
	    print FILE "${value}";
	    close FILE;
	}

	else
	{
	    print colored [$common::COLOR_RESULT], "\n\n$key ";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_4; 
	    print colored [$common::COLOR_RESULT], " : ($size) \n\n\t";
	    $value->as_string_callback(sub{join("\n\t",sort $_[0]->elements)});
	    print "${value}";
	}
    }    
}


sub __display
{
    my $results = ${$_[0]};

    if(scalar @_ == 2)
    {
	open(FILE,">>$conf::RESULTS/$_[1]") || die ("$lang::MSG_GENERAL_ERR1 <$_[1]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "\n==========================================================================\n";
	print FILE $lang::MSG_SOU_GENPATTERN_1;
	print FILE $results->size;
	print FILE $lang::MSG_SOU_GENPATTERN_3;    
	print FILE "==========================================================================\n";
	
	print FILE join("\n",sort $results->elements);
    }
    
    else
    {
	print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_1;
	print colored [$common::COLOR_RESULT], $results->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_3;    
	print colored [$common::COLOR_RESULT], "==========================================================================\n";

	print join("\n",sort $results->elements);
	print "\n\n";
    }
}



sub isEquivalent 
{
    my $pattern1 = uc($_[0]);
    my $pattern2 = uc($_[1]);

    my @tab1 = split(/<|>/, $pattern1);
    my @tab2 = split(/<|>/, $pattern2);

    if((((scalar @tab1) %2) == 0) && ($tab1[$#tab1] eq "IN" || $tab1[$#tab1] eq "OUT"))
    {
	push(@tab1, $tab1[0]);
    }

    if((((scalar @tab2) %2) == 0) && ($tab2[$#tab2] eq "IN" || $tab2[$#tab2] eq "OUT"))
    {
	push(@tab2, $tab2[0]);
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
    my %graph_sou_tmp = ();
    while (my ($key, $val) = each(%graph_sou))
    {
	$graph_sou_tmp{uc($key)} = $val;
    }

    my $pattern = uc($_[0]);
    my @tab = split(/<|>/, $pattern);
    my $lastState="";
    my $curExch="";

    if((((scalar @tab) % 2)  != 0) && (@tab[0] ne @tab[$#tab]))
    {
	if((scalar @_ == 1) || ($_[1] != -1))
	{
	    print colored [$common::COLOR_RESULT], "False ";
	    print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR1}\n";
	}
	return -1;	
    }
    
    for my $i (0..$#tab)
    {
	if($i % 2 == 0)
	{
	    if($tab[$i] ne "O" && $tab[$i] ne "OB" && $tab[$i] ne "U" && $tab[$i] ne "UB" && $tab[$i] ne "S" && $tab[$i] ne "SB") 
	    {
		if((scalar @_ == 1) || ($_[1] != -1))
		{
		    print colored [$common::COLOR_RESULT], "False ";
		    print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR2} ";
		    print colored [$common::COLOR_RESULT], "<${tab[$i]}>)\n";

		}		
		return -1;
	    }
	    
	    else
	    {
		if($lastState ne "")
		{
		    my $found = -1;		
		    
		    foreach my $edge (@{$graph_sou_tmp{$lastState}})
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
			    print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR3} ";
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
	    if($tab[$i] ne "IN" && $tab[$i] ne "OUT")
	    {
		if((scalar @_ == 1) || ($_[1] != -1))
		{
		    print colored [$common::COLOR_RESULT], "False ";
		    print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR4} ";
		    print colored [$common::COLOR_RESULT], "<${tab[$i]}>)\n";
		}
		
		return -1;
	    }

	    else
	    {
		$curExch="<$tab[$i]>";

		if($lastState ne "")
		{
		    my $found = -1;

		    #to treat patterns ending with an exchange
		    if($i==$#tab)
		    {		    		    		    
			foreach my $edge (@{$graph_sou_tmp{$lastState}})
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
				print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR3} ";
				print colored [$common::COLOR_RESULT], ": [${lastState},${curExch}] => $tab[0])\n";
			    }
			    
			    return -1;
			}   			
		    }
		    
		    else
		    {
			foreach my $edge (@{$graph_sou_tmp{$lastState}})
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
				print colored [$common::COLOR_RESULT], "${lang::MSG_SOU_ISVALID_ERR3} ";
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
    my $inv_pattern1 = "";
    
    my @tab1 = split(/<|>/, $pattern1);
    
    for my $i (0..$#tab1)
    {
	if($tab1[$i] eq "IN" )
	{
	    $inv_pattern1 = "${inv_pattern1}<out>";
	}
	elsif($tab1[$i] eq "OUT")
	{
	    $inv_pattern1 = "${inv_pattern1}<in>";
	}
	elsif($tab1[$i] eq "O") 
	{
	    $inv_pattern1 = "${inv_pattern1}Ob";
	}
	elsif($tab1[$i] eq "OB") 
	{
	    $inv_pattern1 = "${inv_pattern1}O";
	}
	elsif($tab1[$i] eq "U") 
	{
	    $inv_pattern1 = "${inv_pattern1}Ub";
	}
	elsif($tab1[$i] eq "UB") 
	{
	    $inv_pattern1 = "${inv_pattern1}U";
	}
	elsif($tab1[$i] eq "S") 
	{
	    $inv_pattern1 = "${inv_pattern1}Sb";
	}
	elsif($tab1[$i] eq "SB") 
	{
	    $inv_pattern1 = "${inv_pattern1}S";
	}    	
	else
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_SOU_INV_ERR1} $_[0] ${lang::MSG_SOU_INV_ERR1b}${tab1[$i]}${lang::MSG_SOU_INV_ERR1c}";
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
    my $sym_pattern1 = "";

    my @tab1 = split(/<|>/, $pattern1);
    
    for my $i (0..$#tab1)
    {
	if( $tab1[$i] eq "IN" || $tab1[$i] eq "OUT")
	{
	    $sym_pattern1 = "${sym_pattern1}<$tab1[$i]>";
	}
	elsif($tab1[$i] eq "O") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ob";
	}
	elsif($tab1[$i] eq "OB") 
	{
	    $sym_pattern1 = "${sym_pattern1}O";
	}
	elsif($tab1[$i] eq "U") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ub";
	}
	elsif($tab1[$i] eq "UB") 
	{
	    $sym_pattern1 = "${sym_pattern1}U";
	}
	elsif($tab1[$i] eq "S") 
	{
	    $sym_pattern1 = "${sym_pattern1}Sb";
	}
	elsif($tab1[$i] eq "SB") 
	{
	    $sym_pattern1 = "${sym_pattern1}S";
	}
	else
	{
	    if((scalar @_ == 2) || ($_[2] != -1))
	    {
		print colored [$common::COLOR_RESULT], "False\n";
	    }

	    print colored [$common::COLOR_ERR], "${lang::MSG_SOU_ISSYMETRIC_ERR1} $_[0] ${lang::MSG_SOU_ISSYMETRIC_ERR1b}${tab1[$i]}${lang::MSG_SOU_ISSYMETRIC_ERR1c}";
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
    my $sym_pattern1 = "";

    my @tab1 = split(/<|>/, $pattern1);
    
    for my $i (0..$#tab1)
    {
	if( $tab1[$i] eq "IN")
	{
	    $sym_pattern1 = "${sym_pattern1}<in>";
	}
	elsif($tab1[$i] eq "OUT")
	{
	    $sym_pattern1 = "${sym_pattern1}<out>";
	}
	elsif($tab1[$i] eq "O") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ob";
	}
	elsif($tab1[$i] eq "OB") 
	{
	    $sym_pattern1 = "${sym_pattern1}O";
	}
	elsif($tab1[$i] eq "U") 
	{
	    $sym_pattern1 = "${sym_pattern1}Ub";
	}
	elsif($tab1[$i] eq "UB") 
	{
	    $sym_pattern1 = "${sym_pattern1}U";
	}
	elsif($tab1[$i] eq "S") 
	{
	    $sym_pattern1 = "${sym_pattern1}Sb";
	}
	elsif($tab1[$i] eq "SB") 
	{
	    $sym_pattern1 = "${sym_pattern1}S";
	}
	else
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_SOU_SYM_ERR1} $_[0] ${lang::MSG_SOU_SYM_ERR1b}${tab1[$i]}${lang::MSG_SOU_SYM_ERR1c}";
	    return -1;
	}
    }

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$sym_pattern1\n";
    }    

    return $sym_pattern1;
}


sub toMMSTD
{
    my $pattern = uc($_[0]);
    my $MMSTDpattern = "";

    my @tab1 = split(/<|>/, $pattern);
    
    for my $i (0..$#tab1)
    {
	if($tab1[$i] eq "IN" )
	{
	    $MMSTDpattern = "${MMSTDpattern} -+-> ";
	}
	elsif($tab1[$i] eq "OUT")
	{
	    $MMSTDpattern = "${MMSTDpattern} -o-> ";
	}	    
	elsif($tab1[$i] eq "O") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Rr";
	}
	elsif($tab1[$i] eq "OB") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Ll";
	}
	elsif($tab1[$i] eq "U") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Lr";
	}
	elsif($tab1[$i] eq "UB") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Rl";
	}
	elsif($tab1[$i] eq "S") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Ur";
	}
	elsif($tab1[$i] eq "SB") 
	{
	    $MMSTDpattern = "${MMSTDpattern}Ul";
	}
	else 
	{
	    print colored [$common::COLOR_ERR], "${lang::MSG_SOU_TOMMSTD_ERR1} $_[0] ${lang::MSG_SOU_TOMMSTD_ERR1b}${tab1[$i]}${lang::MSG_SOU_TOMMSTD_ERR1c}";
	    return -1;
	}
    }

    if((scalar @_ == 1) || ($_[1] != -1))
    {
	print colored [$common::COLOR_RESULT], "$MMSTDpattern\n";
    }    

    return $MMSTDpattern;
}


sub size
{
    
    my $pattern=uc($_[0]);
    my $nb = 0;
    my @liste= $pattern =~ /O</ig;
    $nb += @liste;
    @liste= $pattern =~ /OB</ig;
    $nb += @liste;
    @liste= $pattern =~ /S</ig;
    $nb += @liste;
    @liste= $pattern =~ /SB</ig;
    $nb += @liste;
    @liste= $pattern =~ /U</ig;
    $nb += @liste;
    @liste= $pattern =~ /UB</ig;
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

    while ( my ($key) = each(%graph_sou) ) {
	my %cpt_states=(
	    'O' => 0,
	    'Ob' => 0,
	    'S' => 0,
	    'Sb' => 0,
	    'U' => 0,
	    'Ub' => 0
	    );

	my $results = new Set::Scalar();
	my $results = &__genPatternsFromState($key,$key,$cpt,\%cpt_states,$path_len_max,0);
	&common::hideComputingPrompt();

	if(scalar @_ == 3)
	{
	    open(FILE,">$conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	    print FILE "\n==========================================================================\n";
	    print FILE $lang::MSG_SOU_GENPATTERN_1;
	    print FILE $results->size;
	    print FILE $lang::MSG_SOU_GENPATTERN_2;
	    print FILE "$key :\n";
	    print FILE "==========================================================================\n";
	    close FILE;	    
	    __displayByPatternLength(\$results, $_[2]);	    
	}
	
	else
	{
	    print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	    print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_1;
	    print colored [$common::COLOR_RESULT], $results->size;
	    print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_2;
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
	'O' => 0,
	'Ob' => 0,
	'S' => 0,
	'Sb' => 0,
	'U' => 0,
	'Ub' => 0
	);
    

    while ( my ($key) = each(%graph_sou) ) {
	$results = $results->union(&__genPatternsFromState($key,$key,$cpt,\%cpt_states,$path_len_max,0));   	
	$cpt_states{$key}=$cpt + 1; 
    }

    &common::hideComputingPrompt();

    if(scalar @_ == 3)
    {
	open(FILE,">$conf::RESULTS/$_[2]") || die ("$lang::MSG_GENERAL_ERR1 <$_[2]> $lang::MSG_GENERAL_ERR1b") ;	    
	print FILE "\n==========================================================================\n";
	print FILE $lang::MSG_SOU_GENPATTERN_1;
	print FILE $results->size;
	print FILE $lang::MSG_SOU_GENPATTERN_3;    
	print FILE "==========================================================================\n";
	close FILE;	    
	__displayByPatternLength(\$results, $_[2]);
    }
    
    else
    {
	print colored [$common::COLOR_RESULT], "\n==========================================================================\n";
	print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_1;
	print colored [$common::COLOR_RESULT], $results->size;
	print colored [$common::COLOR_RESULT], $lang::MSG_SOU_GENPATTERN_3;    
	print colored [$common::COLOR_RESULT], "==========================================================================\n";
	
	__displayByPatternLength(\$results);
    }

    print "\n\n";
}


sub graph
{
    
    foreach my $state (sort keys %graph_sou)
    {
	my $edgeLength=0;
	print colored [$common::COLOR_RESULT], "$state ";
	print (' ' x (3 - length($state))); 
	print  colored [$common::COLOR_RESULT], "=>     ";
	foreach my $edge (@{$graph_sou{$state}})
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


sub __test 
{

    my %cpt_states_tmp=(
	'O' => 0,
	'Ob' => 0,
	'S' => 0,
	'Sb' => 0,
	'U' => 0,
	'Ub' => 0
	);

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tTest Gen Pattern From State : (\'O\',\'O\',1,%pt_states_tmp,-1,0);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";

    my $result = new Set::Scalar();
    my $result = &__genPatternsFromState('O','O',1,\%cpt_states_tmp,-1,0);
    $result->as_string_callback(sub{join("\n",sort $_[0]->elements)});
    print "\n\n";
    print $result;
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::__display(\$result);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &__display(\$result);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::__displayByPatternLength(\$result);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &__displayByPatternLength(\$result);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::genByState(1,-1);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &genByState(1,-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::gen(1,-1);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &gen(1,-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::gen(1,12);\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &gen(1,12);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"S<in>O<out>\",\"O<out>S<in>\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<in>O<out>","O<out>S<in>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"S<in>O<out>S\",\"O<out>S<in>O\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<in>O<out>S","O<out>S<in>O");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"S<in>O<out>S\",\"O<out>S<in>\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<in>O<out>S","O<out>S<in>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"S<in>O<out>\",\"O<out>S<in>\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<in>O<out>","O<out>S<in>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"O<out>Ub<in>O\",\"Ub<in>O<in>Ub\",-1);\n\t\t==> -1\n"; 
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("O<out>Ub<in>O","Ub<in>O<in>Ub",-1); 
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"O<out>Ub<in>O\",\"Sb<in>S<in>Sb\");\n\t\t==> False, -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("O<out>Ub<in>O","Sb<in>S<in>Sb");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isEquivalent(\"S<out>Ob<in>S\",\"Ob<in>S<out>Ob\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isEquivalent("S<out>Ob<in>S","Ob<in>S<out>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isSymetric(\"S<in>O<out>\",\"O<out>S<in>\",-1);\n\t\t==> -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isSymetric("S<in>O<out>","O<out>S<in>",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isSymetric(\"S<in>O<out>S\",\"Ob<out>Sb<in>Ob\");\n\t\t==> True, 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isSymetric("S<in>O<out>S","Ob<out>Sb<in>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isSymetric(\"S<in>O<out>S\",\"Ob<out>Sb<in>OF\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isSymetric("S<in>O<out>S","Ob<out>Sb<in>OF");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isSymetric(\"Ob<out>Sb<in>OF\",\"S<in>O<out>S\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isSymetric("Ob<out>Sb<in>OF","S<in>O<out>S");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::sym(\"S<out>Ob<in>S\",-1);\n\t\t==> Sb<out>O<in>Sb\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &sym("S<out>Ob<in>S",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::sym(\"Ob<in>S<out>Ob\");\n\t\t==> O<in>Sb<out>O\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &sym("Ob<in>S<out>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::sym(\"O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub\");\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &sym("O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::sym(\"Ob<in>S<out>OR\");\n\t\t==>Error\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &sym("Ob<in>S<out>OR");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isValid(\"S<out>Ob<in>S\",-1);\n\t\t==> 1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("S<out>Ob<in>S",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isValid(\"S<out>Ob<in>O\",-1);\n\t\t==> -1\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &isValid("S<out>Ob<in>O",-1);
    print "\n\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"Ob<in>O<out>Ob\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Ob<in>O<out>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::isValid(\"S<out>Ob\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("S<out>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<out>Sb<out>O\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<out>Sb<out>O");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<in>Sb<out>Ub<in>O\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<in>Sb<out>Ub<in>O");
    print "\n\n";
    
    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<in>SB<IN>\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<in>SB<IN>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<an>S<out>U<in>Ob<in>S<out>Ub<in>S<out>OB<in>U<in>Ob<in>S<out>sB<out>\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<an>S<out>U<in>Ob<in>S<out>Ub<in>S<out>OB<in>U<in>Ob<in>S<out>sB<out>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<in>SC<out>U<in>Ob<in>Sc<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>\");\n\t\t==> False\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<in>SC<out>U<in>Ob<in>Sc<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"Ob<in>S<out>Ob\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Ob<in>S<out>Ob");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"Ob<in>S<out>\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("Ob<in>S<out>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::isValid(\"O<in>SB<out>U<in>Ob<in>S<out>Ub<in>O<out>Ub<in>\");\n\t\t==> True\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &isValid("O<in>SB<out>U<in>Ob<in>S<out>Ub<in>O<out>Ub<in>");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::inv(\"Ob<in>S<out>Ob\",-1);\n\t\t==> O<out>Sb<in>O\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &inv("Ob<in>S<out>Ob",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::inv(\"O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub\");\n\t\t==> Ob<out>Sb<in>Ub<out>O<out>S<in>U<out>S<in>Ub<out>O<out>S<in>U\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &inv("O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::inv(\"O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>UR\");\n\t\t==> Ob<out>Sb<in>Ub<out>O<out>S<in>U<out>S<in>Ub<out>O<out>S<in>U\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &inv("O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::size(\"O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub\");\n\t\t==> 10\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &size("O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::size(\"Ob<in>S<out>Ob\",-1);\n\t\t==> 2\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &size("Ob<in>S<out>Ob",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::toMMSTD(\"O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub\");\n\t\t==> Rr -+-> Ur -o-> Lr -+-> Ll -+-> Ul -o-> Rl -+-> Ul -o-> Lr -+-> Ll -+-> Ul -o-> Rl\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &toMMSTD("O<in>S<out>U<in>Ob<in>Sb<out>Ub<in>Sb<out>U<in>Ob<in>Sb<out>Ub");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tprint SOU::toMMSTD(\"Ob<in>S<out>Ob\",-1);\n\t\t==> Ll -+-> Ur -o-> Ll\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &toMMSTD("Ob<in>S<out>Ob",-1);
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::toMMSTD(\"Ob<in>S<out>Od\");\n\t\t==> Error\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    &toMMSTD("Ob<in>S<out>Od");
    print "\n\n";

    print "----------------------------------------------------------------------------------------------------------------\n";
    print "\t\tSOU::graph();\n";
    print "----------------------------------------------------------------------------------------------------------------\n";
    print &graph();
    print "\n\n";

}

1;
