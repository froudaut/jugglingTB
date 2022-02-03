#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## LADDER.pm   - LADDER Module for jugglingTB                               ##
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

package LADDER;
use common;
use strict;
use lang;
use Term::ANSIColor;        
use Getopt::Long qw(GetOptionsFromString);

#
# __test_jonglage_net_list uses SSWAP::isEquivalent
#

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $LADDER_INFO = "LADDER juggling Notation";
our $LADDER_HELP = $lang::MSG_LADDER_MENU_HELP;
our $LADDER_VERSION = "v2.1";

our %LADDER_CMDS = 
    (    
	 'draw'                 => ["$lang::MSG_LADDER_MENU_DRAW_1", "$lang::MSG_LADDER_MENU_DRAW_2"], 			 
	 'removeObj'            => ["$lang::MSG_LADDER_MENU_REMOVE_OBJ_1", "$lang::MSG_LADDER_MENU_REMOVE_OBJ_2"], 
	 'sym'                  => ["$lang::MSG_LADDER_MENU_SYM_1", "$lang::MSG_LADDER_MENU_SYM_2"], 			 
	 'inv'                  => ["$lang::MSG_LADDER_MENU_INV_1", "$lang::MSG_LADDER_MENU_INV_2"], 			 
	 'slide'                => ["$lang::MSG_LADDER_MENU_SLIDE_1", "$lang::MSG_LADDER_MENU_SLIDE_2"],   
	 'toMultiSync'          => ["$lang::MSG_LADDER_MENU_TO_MULTISYNC_1", "$lang::MSG_LADDER_MENU_TO_MULTISYNC_2"], 
	 'merge'                => ["$lang::MSG_LADDER_MENU_MERGE_1", "$lang::MSG_LADDER_MENU_MERGE_2"], 
    );

print "LADDER $LADDER::LADDER_VERSION loaded\n";

# To add debug behaviour 
our $LADDER_DEBUG=1;

my $LINK_GUNSWAP='N'; # To add Gunswap Link for jonglage.net in generation
my $LINK_JUGGLINGLAB_GIF='N'; # To add JugglingLab GIF Server Link for jonglage.net in generation

my $PERIOD_MAX = 25;
my $MAX_MULT = 15;
my $NODESEP = .2;


# Internal Usage : Check if it is a real Synchronous Siteswap 
sub __is_true_sync
{
    
    ##  $_[0] : ss
    

    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;
    my $sync = -1;

    for (my $i = 0; $i < length($ss); $i++)
    {
	my $v = substr($ss,$i,1);
	if(($sync!=1 && $v ne "("))
	{
	    if($v ne "*")
	    { return -1; }
	}
	elsif($v eq "!")
	{ return -1; }
	elsif ($v eq "(")  
	{
	    if($sync ==1)
	    { return -1; }
	    $sync=1;
	}
	elsif ($v eq ")")  
	{
	    if($sync !=1)
	    { return -1; }
	    $sync=-1;
	}		   	
    }

    return 1;
}


# Internal Usage :  Take a Siteswap and cut it into slices (2 lists) according to the beats and hands
sub __build_lists
{

    ## $0 : siteswap to build
    ## $1 : if present with value 0, hack is used to remove ss 0 after a sync one. If absent also. (Except at the end since it means *)
    ##        Otherwise with value 1, ss is kept identical also in the lists.

    sub __switch_hand
    {
	my $hand = uc($_[0]);
	if ($hand eq "R") {
	    return "L";
	} else {
	    return "R";
	}
    }

    #############
    ## Similar to toMultiSync($[0],0)
    # Accept all the Siteswaps Formats now ... 

    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;
    my $queue_hand = "";

    # First do Operations for Synchronous SS      
    my $ss_tmp = "";
    my $ss_b = "L";
    my $ss_b_map = "";
    my $i = 0; 
    my $mult = -1;

    while ($i < length($ss)) {
	# Go through the whole sync throw
	if (substr($ss,$i,1) eq "(") {
	    my $j=$i;
	    $i++;	    
	    my $ss_v1='';
	    my $ss_v2='';
	    
	    if ($ss_b eq "L") { $ss_b = "R";}
	    else {$ss_b = "L";}	    
	    while (substr($ss,$i,1) ne "," && $i < length($ss)) {	
		$ss_v1 = $ss_v1.substr($ss,$i,1);
		if(substr($ss,$i,1) ne "X" && substr($ss,$i,1) ne "," && substr($ss,$i,1) ne "!" && substr($ss,$i,1) ne "[")
		{
		    $ss_b_map = $ss_b_map.$ss_b." ";
		}
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }
	    
	    $i++;
	    if ($ss_b eq "L") { $ss_b = "R";}
	    else {$ss_b = "L";}
	    
	    while (substr($ss,$i,1) ne ")" && $i < length($ss)) {		
		$ss_v2 = $ss_v2.substr($ss,$i,1);
		if(substr($ss,$i,1) ne "X" && substr($ss,$i,1) ne "," && substr($ss,$i,1) ne "!" && substr($ss,$i,1) ne "]")
		{
		    $ss_b_map = $ss_b_map.$ss_b." ";
		}
		
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }
	    $i++;
	    $ss_tmp = $ss_tmp.$ss_v1."!".$ss_v2."*0";
	}
	
	else {
	    if (substr($ss,$i,1) eq "[") {
		$mult=1;
		if ($ss_b eq "L") { $ss_b = "R";}
		else {$ss_b = "L";}
	    } elsif (substr($ss,$i,1) eq "]") {
		$mult=-1;		
		#if ($ss_b eq "L") { $ss_b = "R";}
		#else {$ss_b = "L";}
		
	    } elsif (substr($ss,$i,1) eq "*") {
		if ($ss_b eq "L") {
		    $ss_b = "R";		 
		} else {
		    $ss_b = "L";
		}			
	    } else {
		if ($mult==1) {				    
		    $ss_b_map = $ss_b_map.$ss_b." ";		    
		} else {
		    if ($ss_b eq "L") {
			$ss_b = "R";
			$ss_b_map = $ss_b_map."R ";
		    } else {
			$ss_b = "L";
			$ss_b_map = $ss_b_map."L ";
		    }
		}
	    }
	    
	    $ss_tmp = $ss_tmp.substr($ss,$i,1);	    	    
	    $i++;
	}	
    }

    $ss=$ss_tmp;
    $ss_tmp="";

    # Then do Operations for Multiplexes SS
    my $mult = -1;
    my $idx = 0;
    for (my $i = 0; $i < length($ss); $i++) {
	my $val = substr($ss,$i,1);
	if ($i+1 <length($ss) && uc(substr($ss,$i+1,1)) eq "X") {
	    $val = $val."X";
	    $i++;
	}
	if ($val eq "[") {
	    $mult = 1;	
	    $idx = 0;
	} elsif ($val eq "]") {
	    $mult = -1;
	} elsif ($mult == 1) {
	    if ($idx == 0) {
		$ss_tmp = $ss_tmp.$val;
	    } else {
		$ss_tmp = $ss_tmp."!*".$val;
	    }
	    $idx ++;
	} else {
	    $ss_tmp = $ss_tmp.$val;
	}
    }

    $ss = $ss_tmp;
    # To be able to redraw the siteswap it is better to remove the last 0 when followed by "!" 
    # (in order To avoid a last 0 after last sync when followed by "!")
    $ss =~ s/\*0!//g;
    $ss =~ s/0\*!//g;

    ##################################

    if ($LADDER_DEBUG >= 1) {    
	print "== LADDER::__build_lists : $ss \n";
    }
    my @res_left = ();
    my @res_right = ();
    my $beat=0;
    my $ss_b_map = "";
    my $multiplex = -1;
    my $sync = -1;
    my $curr_hand ="R";

    for (my $i =0; $i< length($ss); $i++) {
	if (substr($ss,$i,1) eq "(") {	
	    $curr_hand = &__switch_hand($curr_hand);		
	    $sync = 1;
	} elsif (substr($ss,$i,1) eq ")") {
	    $beat +=2;
	    $sync = -1;
	    $curr_hand = &__switch_hand($curr_hand);	    
	} elsif (substr($ss,$i,1) eq "[") {
	    $multiplex = 1;
	} elsif (substr($ss,$i,1) eq "]") {
	    $multiplex = -1;
	    if ($sync == -1) {
		$curr_hand = &__switch_hand($curr_hand);	    
		$beat ++;
	    }
	} elsif (substr($ss,$i,1) eq "*") {
	    $curr_hand = &__switch_hand($curr_hand);
	} elsif (substr($ss,$i,1) eq ",") {
	    $curr_hand = &__switch_hand($curr_hand);	    
	} elsif (substr($ss,$i,1) eq "!") {
	    if($beat != 0)
		# TO DO : Keep the possibility to have !, !* or *! ... at the beginning of the multisync ??? Currently Not recommended !
	    {
		$beat --;
	    }

	} else {
	    my $v = substr($ss,$i,1);
	    if ($i + 1 <= length($ss) && uc(substr($ss,$i +1,1)) eq "X") {
		$v = $v."x";
	    }
	    if ($curr_hand eq "L") {
		$ss_b_map = $ss_b_map." L";
		if ($res_left[$beat] eq "" || $res_left[$beat] eq "0") {
		    $res_left[$beat] = $v;
		} else {
		    $res_left[$beat] = $res_left[$beat].$v;
		}
	    } else {
		$ss_b_map = $ss_b_map." R";
		if ($res_right[$beat] eq "" || $res_right[$beat] eq "0") {
		    $res_right[$beat] = $v;		
		} else {		
		    $res_right[$beat] = $res_right[$beat].$v;
		}	    
	    }
	    
	    if ($i + 1 <= length($ss) && uc(substr($ss,$i +1,1)) eq "X") {
		$i++;
	    }	

	    if (($multiplex == -1) && ($sync == -1)) {
		$curr_hand = &__switch_hand($curr_hand);
		$beat ++;	    
	    }
	}	    
    }

    my $next_hand=$curr_hand;

    for(my $i=1; $i<$beat; $i++)
    {
	if(($res_left[$i] eq "0" || $res_left[$i] eq "") && ($res_right[$i] eq "0" || $res_right[$i] eq "") 
	   && ($res_left[$i-1] ne "" && $res_right[$i-1] ne "" ))
	{	    
	    # HACK to remove eventual 0 after a Sync throw 
	    if(scalar @_ == 1 || $_[1] == 0) 
	    {   	    
		$res_left[$i] = "";
		$res_right[$i] = "";
	    }
	}    
    }

    $queue_hand=$curr_hand;

    # A last checking to remove remaining 0 in multiplex throw
    for (my $i = 0; $i < scalar(@res_right); $i++) {
	if(length($res_right[$i]>1))
	{
	    # In case of a 0x
	    $res_right[$i] =~ s/0X/Z/g;
	    $res_right[$i] =~ s/0x/Z/g;
	    $res_right[$i] =~ s/0//g;
	    $res_right[$i] =~ s/Z/0x/g;	
	}
    }
    for (my $i = 0; $i < scalar(@res_left); $i++) {
	if(length($res_left[$i]>1))
	{
	    # In case of a 0x
	    $res_left[$i] =~ s/0x/Z/g;
	    $res_left[$i] =~ s/0X/Z/g;
	    $res_left[$i] =~ s/0//g;
	    $res_left[$i] =~ s/Z/0x/g;
	}
    }


    if ($LADDER_DEBUG >= 1) {
	print "== LADDER::__build_lists : Right Hand Results \n";
	for (my $i = 0; $i < scalar(@res_right); $i++) {
	    if ($res_right[$i] ne "") {
		print "period ".$i." => ".$res_right[$i]."\n";
	    }
	}

	print "== LADDER::__build_lists : Left Hand Results \n";
	for (my $i = 0; $i < scalar(@res_left); $i++) {
	    if ($res_left[$i] ne "") {
		print "period ".$i." => ".$res_left[$i]."\n";
	    }
	}
	
	print "== LADDER::__build_lists : Hands ==> ".$ss_b_map."\n";   

	print "== LADDER::__build_lists : Queue Hand ==> ".$queue_hand."\n";   

    }



    # Now compute the queue hand to be able to reconstruct the whole siteswap (ie handling of "*" at end. Handling of "!" is done by checking $beat
    return ($beat, \@res_left, \@res_right, $queue_hand);

}


# Internal Usage : Take a Siteswap and compute Transitions and Siteswaps MAP for the throws (taking into account the colorisation model)
# It also return the period
sub __build_dicts
{
    #$_[0] : ss
    #$_[1] : color_mode
    #$_[2] : if present with value 0, hack is used to remove ss 0 after a sync one. If absent also.
    #$_[3] : Experimental: A transit_hash to update according to the color mode choosen. Be careful ! You need to have a complete view of all throw. 
    #         It may be mandatory to have twice the siteswap in the transition MAP before using this call . ==> Currently there are some bugs in it

    my $beat = -1;
    my $queue_hand = "";
    my @res_left = ();
    my @res_right = ();
    my $color_mode = 2;
    my %transit_hash = ();
    my %ss_hash = ();
    
    if (scalar @_ > 1) {
	$color_mode=$_[1];
    }

    if (scalar @_ >= 4) {
	%transit_hash = %{$_[3]};	
	while (my ($key, $value) = each(%transit_hash) ) 
	{
	    my $v1 = substr((split(/:/,$key))[0],1);
	    my $v2 = substr((split(/:/,$value))[0],1);		  

	    my $v = $v2 - $v1;
	    if($beat < $v1) 
	    {
		$beat = $v1;
	    }
	    if((substr((split(/:/,$key))[0],0,1) eq "R" && substr((split(/:/,$value))[0],0,1) eq "R") 
	       || (substr((split(/:/,$key))[0],0,1) eq "L" && substr((split(/:/,$value))[0],0,1) eq "L"))
	    {
		if($v%2!=0)
		{		    	
		    $ss_hash{$key} = sprintf("%x",$v)."x";	
		}
		else
		{		    
		    $ss_hash{$key} = sprintf("%x",$v);	
		}		
	    }	    	
	    else
	    {
		if($v%2==0)
		{		    	
		    $ss_hash{$key} = sprintf("%x",$v)."x";	
		}
		else
		{		    
		    $ss_hash{$key} = sprintf("%x",$v);	
		}
	    }
	    
	    if(substr((split(/:/,$key))[0],0,1) eq "R")
	    {
		$res_right[$v1] = $res_right[$v1].$ss_hash{$key};
	    }
	    else
	    {
		$res_left[$v1] = $res_left[$v1].$ss_hash{$key}; 		
	    }
	}
	$beat ++;

	my %src_hash=();
	my %src_num_hash=();
	my %dst_hash=();

	while (my ($key, $value) = each(%transit_hash) ) 
	{
	    my $v1 = substr((split(/:/,$key))[0],1);
	    my $v2 = substr((split(/:/,$value))[0],1);		  
	    
	    $src_hash{substr((split(/:/,$value))[0],0,1).($v2%$beat)} = $src_hash{substr((split(/:/,$value))[0],0,1).($v2%$beat)}.$key.";";
	    $src_num_hash{substr((split(/:/,$value))[0],0,1).($v2%$beat)}=$src_num_hash{substr((split(/:/,$value))[0],0,1).($v2%$beat)}.(split(/:/,$value))[1].";";
 	    $dst_hash{substr((split(/:/,$key))[0],0,1).($v1)} = $dst_hash{substr((split(/:/,$key))[0],0,1).($v1)}.$value.";";
	}
	
	if ($color_mode == 1)
	{
	    foreach my $i (sort keys (%src_hash)) { 	    
		my @src_list=split(/;/,$src_hash{$i});
		my @src_num_list=split(/;/,$src_num_hash{$i});
		my @dst_list=split(/;/,$dst_hash{$i});
		for (my $i=1; $i < scalar @src_list; $i++)
		{
		    if(hex($ss_hash{$src_list[$i]}) < hex($ss_hash{$src_list[$i-1]}))
		    {
			my $tmp=$src_list[$i-1];
			$src_list[$i-1]=$src_list[$i];
			$src_list[$i]=$tmp;
			$tmp=$src_num_list[$i-1];
			$src_num_list[$i-1]=$src_num_list[$i];
			$src_num_list[$i]=$tmp;
			$tmp=$dst_list[$i-1];
			$dst_list[$i-1]=$dst_list[$i];
			$dst_list[$i]=$tmp;
		    }
		} 
		for (my $i=scalar @src_list-1; $i > 1; $i--)
		{
		    if(hex($ss_hash{$src_list[$i]}) > hex($ss_hash{$src_list[$i-1]}))
		    {
			my $tmp=$src_list[$i-1];
			$src_list[$i-1]=$src_list[$i];
			$src_list[$i]=$tmp;
			$tmp=$src_num_list[$i-1];
			$src_num_list[$i-1]=$src_num_list[$i];
			$src_num_list[$i]=$tmp;
			$tmp=$dst_list[$i-1];
			$dst_list[$i-1]=$dst_list[$i];
			$dst_list[$i]=$tmp;
		    }
		} 
		
		$src_hash{$i} = join(";", @src_list).";";			       		
		$src_num_hash{$i} = join(";", @src_num_list).";";			       		
		$dst_hash{$i} = join(";", @dst_list).";";			       		
	    }
	}

	elsif ($color_mode == 2)
	{
	    foreach my $i (sort keys (%src_hash)) { 	    
		my @src_list=split(/;/,$src_hash{$i});
		my @src_num_list=split(/;/,$src_num_hash{$i});
		my @dst_list=split(/;/,$dst_hash{$i});
		for (my $i=1; $i < scalar @src_list; $i++)
		{
		    if(hex($ss_hash{$src_list[$i]}) > hex($ss_hash{$src_list[$i-1]}))
		    {
			my $tmp=$src_list[$i-1];
			$src_list[$i-1]=$src_list[$i];
			$src_list[$i]=$tmp;
			$tmp=$src_num_list[$i-1];
			$src_num_list[$i-1]=$src_num_list[$i];
			$src_num_list[$i]=$tmp;
			$tmp=$dst_list[$i-1];
			$dst_list[$i-1]=$dst_list[$i];
			$dst_list[$i]=$tmp;
		    }
		} 
		for (my $i=scalar @src_list-1; $i > 1; $i--)
		{
		    if(hex($ss_hash{$src_list[$i]}) < hex($ss_hash{$src_list[$i-1]}))
		    {
			my $tmp=$src_list[$i-1];
			$src_list[$i-1]=$src_list[$i];
			$src_list[$i]=$tmp;
			$tmp=$src_num_list[$i-1];
			$src_num_list[$i-1]=$src_num_list[$i];
			$src_num_list[$i]=$tmp;
			$tmp=$dst_list[$i-1];
			$dst_list[$i-1]=$dst_list[$i];
			$dst_list[$i]=$tmp;
		    }
		} 
		
		$src_hash{$i} = join(";", @src_list).";";			       		
		$src_num_hash{$i} = join(";", @src_num_list).";";			       		
		$dst_hash{$i} = join(";", @dst_list).";";			       		
	    }
	}
	

	my %transit_hash_tmp=();
	
	foreach my $k (sort keys (%transit_hash)) {
	    my $v1=(split(/:/,$k))[0];
	    my $v2=(split(/:/,$transit_hash{$k}))[0];
	    my $src='';
	    my $dst='';
	    if(exists ($src_num_hash{$v1}))
	    {
		my @src_num_list = split(/;/,$src_num_hash{$v1});
		my $new_idx = $src_num_list[(split(/:/,$k))[1]]; 		       
		$src=$v1.":".$new_idx;
	    }
	    else
	    {
		$src=$k;	
	    }

	    if(exists ($src_num_hash{$v2}))
	    {
		my @src_num_list = split(/;/,$src_num_hash{$v2});
		my $new_idx = $src_num_list[(split(/:/,$transit_hash{$k}))[1]]; 		       
		$dst=$v2.":".$new_idx;
	    }
	    else
	    {
		$dst=$transit_hash{$k};	    
	    }
	    
	    $transit_hash_tmp{$src}=$dst;
	}
	
	%transit_hash=%transit_hash_tmp;
	
    	
	if ($LADDER_DEBUG >= 1) {    
	    print "LADDER::__build_dicts : ============ TRANSITIONS =================\n";
	    for my $key (sort keys %transit_hash) {
		print $key." => ".$transit_hash{$key}."\n";
	    }	    

	    print "LADDER::__build_dicts : ============ SRC HASH FOR MULTIPLEXES =================\n";
	    foreach my $i (sort keys (%src_hash)) { 	    
		print $i." => ". $src_hash{$i}."\n";
	    }
	    print "LADDER::__build_dicts : ============ SRC HASH NUMBER FOR MULTIPLEXES =================\n";
	    foreach my $i (sort keys (%src_num_hash)) { 	    
		print $i." => ". $src_num_hash{$i}."\n";
	    }
	    print "=======================================================\n";
	    print "LADDER::__build_dicts : ============ DST HASH FOR MULTIPLEXES =================\n";
	    foreach my $i (sort keys (%dst_hash)) { 	    
		print $i." => ". $dst_hash{$i}."\n";
	    }
	    print "=======================================================\n";
	}
	
	if ($LADDER_DEBUG >= 1) {
	    print "== LADDER::__build_lists : Right Hand Results \n";
	    for (my $i = 0; $i < scalar(@res_right); $i++) {
		if ($res_right[$i] ne "") {
		    print "period ".$i." => ".$res_right[$i]."\n";
		}
	    }
	    
	    print "== LADDER::__build_lists : Left Hand Results \n";
	    for (my $i = 0; $i < scalar(@res_left); $i++) {
		if ($res_left[$i] ne "") {
		    print "period ".$i." => ".$res_left[$i]."\n";
		}
	    }
	}
    }
    
    else {
        my ($beat_tmp, $res_left_tmp, $res_right_tmp, $queue_hand_tmp) = &__build_lists($_[0],$_[2]);
	$queue_hand= $queue_hand_tmp;
	$beat=$beat_tmp;
	@res_left = @{$res_left_tmp};
	@res_right = @{$res_right_tmp};
	
	for (my $i = 0; $i < scalar(@res_right);$i++) {
	    my $res_tmp = $res_right[$i];
	    my $idx=0;
	    for (my $j=0; $j < length($res_tmp); $j++) {
		my $v= hex(substr($res_tmp,$j,1));	    
		my $dest = '';
		my $contain_x = -1;		
		if ($j < length($res_tmp) -1 && uc(substr($res_tmp,$j+1,1)) eq "X") {
		    $contain_x = 1;
		}	    
		
		if ($v %2 == 0) {		
		    $dest = "R";		    
		} else {
		    $dest = "L";		    
		}
		
		if ($contain_x == 1) {
		    if ($dest eq "L") {
			$dest = "R"
		    } else {
			$dest = "L";
		    }		
		    $j++;				
		}
		
		my $nk = -1;
		$transit_hash{"R".$i.":".$idx} = $dest.($i+$v);	    		
		
		if ($contain_x == 1) {
		    $ss_hash{"R".$i.":".$idx} = sprintf("%x",$v)."x";
		} else {
		    $ss_hash{"R".$i.":".$idx} = sprintf("%x",$v);
		}
		$idx++;
	    }	
	}
	
	for (my $i = 0; $i < scalar(@res_left);$i++) {
	    my $res_tmp = $res_left[$i];
	    my $idx = 0;
	    for (my $j=0; $j < length($res_tmp); $j++) {
		my $v= hex(substr($res_tmp,$j,1));	    
		my $dest = '';
		my $contain_x = -1;				
		if ($j < length($res_tmp) -1 && uc(substr($res_tmp,$j+1,1)) eq "X") {
		    $contain_x = 1;
		}
		
		if ($v %2 == 0) {		
		    $dest = "L";		    
		} else {
		    $dest = "R";		    
		}
		
		if ($contain_x == 1) {
		    if ($dest eq "L") {
			$dest = "R"
		    } else {
			$dest = "L";
		    }		
		    $j++;				
		}
		$transit_hash{"L".$i.":".$idx} = $dest.($i+$v);	    	       
		if ($contain_x == 1) {
		    $ss_hash{"L".$i.":".$idx} = sprintf("%x",$v)."x";
		} else {
		    $ss_hash{"L".$i.":".$idx} = sprintf("%x",$v);
		}
		
		$idx++ ;
	    }
	}
	

	# Build colorization
	if ($color_mode == 1 || $color_mode == 2) {	
	    for (my $i = 0; $i < scalar(@res_right);$i++) {
		my $res_tmp = $res_right[$i];
		my $idx=0;
		for (my $j=0; $j < length($res_tmp); $j++) {
		    my $v= hex(substr($res_tmp,$j,1));	    
		    my $dest = '';
		    my $contain_x = -1;		
		    if ($j < length($res_tmp) -1 && uc(substr($res_tmp,$j+1,1)) eq "X") {
			$contain_x = 1;
		    }	    
		    
		    if ($v %2 == 0) {		
			$dest = "R";		    
		    } else {
			$dest = "L";		    
		    }
		    
		    if ($contain_x == 1) {
			if ($dest eq "L") {
			    $dest = "R"
			} else {
			    $dest = "L";
			}		
			$j++;				
		    }

		    my $nk = -1;
		    $transit_hash{"R".$i.":".$idx} = $dest.($i+$v);	    		
		    
		    if ($contain_x == 1) {
			$ss_hash{"R".$i.":".$idx} = sprintf("%x",$v)."x";
		    } else {
			$ss_hash{"R".$i.":".$idx} = sprintf("%x",$v);
		    }
		    $idx++;
		}
		
		my $res_tmp = $res_left[$i];
		my $idx = 0;
		for (my $j=0; $j < length($res_tmp); $j++) {
		    my $v= hex(substr($res_tmp,$j,1));	    
		    my $dest = '';
		    my $contain_x = -1;				
		    if ($j < length($res_tmp) -1 && uc(substr($res_tmp,$j+1,1)) eq "X") {
			$contain_x = 1;
		    }
		    
		    if ($v %2 == 0) {		
			$dest = "L";		    
		    } else {
			$dest = "R";		    
		    }
		    
		    if ($contain_x == 1) {
			if ($dest eq "L") {
			    $dest = "R"
			} else {
			    $dest = "L";
			}		
			$j++;				
		    }

		    $transit_hash{"L".$i.":".$idx} = $dest.($i+$v);	    	       
		    
		    if ($contain_x == 1) {
			$ss_hash{"L".$i.":".$idx} = sprintf("%x",$v)."x";
		    } else {
			$ss_hash{"L".$i.":".$idx} = sprintf("%x",$v);
		    }
		    
		    $idx++ ;
		}
	    }
	}    
    }
    
    if ($LADDER_DEBUG >= 1) {    	
	print "LADDER::__build_dicts : ============ SITESWAP =================\n";
	foreach my $i (sort keys (%ss_hash)) { 	    
	    print $i." => ". $ss_hash{$i}."\n";
	}
	print "=======================================================\n";
    }
    
    # Build a temp dictionary to show what are the throws for a given multiplex
    # It could then be used to define new colorization rules
    my %transit_hash_tmp = ();
    
    if (scalar @_ >= 4) {
	for my $key (sort keys %transit_hash) {	    
	    my $v = (split (/:/, $transit_hash{$key}))[0];	        	    
	    if (exists $transit_hash_tmp{$v}) {		
		$transit_hash_tmp{$v}=$transit_hash_tmp{$v}.";".$key;
	    } else { 
		$transit_hash_tmp{$v}=$key;
	    }
	}
    }
    else
    {
	for my $key (sort keys %transit_hash) {	    
	    if (exists $transit_hash_tmp{$transit_hash{$key}}) {
		$transit_hash_tmp{$transit_hash{$key}}=$transit_hash_tmp{$transit_hash{$key}}.";".$key;
	    } else {
		$transit_hash_tmp{$transit_hash{$key}}=$key;
	    }
	}	
    }

    
    if($color_mode == 1) {  
	# Sorting 1 : the lowest previous siteswap throw is the first in the multiplex
	for my $key (sort keys %transit_hash_tmp) {
	    # Bubble sort
	    my @th = split (/;/, $transit_hash_tmp{$key});
	    my $stop = -1;
	    while($stop == -1)
	    {
		$stop = 1;
		for (my $i =0; $i < (scalar @th) -1 ; $i++) {
		    if ($ss_hash{$th[$i]} > $ss_hash{$th[$i +1]} || 
			($ss_hash{$th[$i]} == $ss_hash{$th[$i +1]} && (not(uc($ss_hash{$th[$i+1]}) =~ /X/) && uc($ss_hash{$th[$i]}) =~ /X/ ))) {			
			$stop = -1;
			my $th_tmp = $th[$i+1];
			$th[$i+1] = $th[$i];
			$th[$i] = $th_tmp;
		    }
		}	    
		for (my $i = (scalar @th) -1;$i > 1 ;$i--) {
		    if ($ss_hash{$th[$i]} < $ss_hash{$th[$i -1]} ||
			($ss_hash{$th[$i]} == $ss_hash{$th[$i -1]} && (not(uc($ss_hash{$th[$i]}) =~ /X/) && uc($ss_hash{$th[$i-1]}) =~ /X/))) {		       
			$stop = -1;
			my $th_tmp = $th[$i];
			$th[$i] = $th[$i-1];
			$th[$i-1] = $th_tmp;
		    }		
		}	 
	    }
	    $transit_hash_tmp{$key} = join(";", @th);			       		
	}
	
	for my $key (sort keys %transit_hash_tmp) {
	    my @th = split (/;/, $transit_hash_tmp{$key});	   
	    for (my $i =0;$i < (scalar @th) ; $i++) {
		$transit_hash{$th[$i]}=$key.":".$i;		   
	    }	    
	}
	
    } elsif ($color_mode == 2) {  
	# Sorting 2 : the highest previous siteswap throw is the first in the multiplex
	for my $key (sort keys %transit_hash_tmp) {
	    # Bubble sort 
	    my @th = split (/;/, $transit_hash_tmp{$key});
	    my $stop = -1;
	    while($stop == -1)
	    {
		$stop = 1;
		for (my $i =0; $i < (scalar @th) -1 ; $i++) {
		    if ($ss_hash{$th[$i]} < $ss_hash{$th[$i +1]}
			|| ($ss_hash{$th[$i]} == $ss_hash{$th[$i +1]} && (not(uc($ss_hash{$th[$i]}) =~ /X/) && uc($ss_hash{$th[$i + 1]}) =~ /X/ ))) {
			$stop = -1;
			my $th_tmp = $th[$i+1];
			$th[$i+1] = $th[$i];
			$th[$i] = $th_tmp;
		    }
		}	    
		for (my $i = (scalar @th) -1;$i > 1 ;$i--) {
		    if ($ss_hash{$th[$i]} > $ss_hash{$th[$i -1]}
			|| ($ss_hash{$th[$i]} == $ss_hash{$th[$i -1]} && (not(uc($ss_hash{$th[$i-1]}) =~ /X/) && uc($ss_hash{$th[$i]}) =~ /X/))) {
			$stop = -1;
			my $th_tmp = $th[$i];
			$th[$i] = $th[$i-1];
			$th[$i-1] = $th_tmp;
		    }		
		}	 
	    }
	    $transit_hash_tmp{$key} = join(";", @th);		
	}
	
	for my $key (sort keys %transit_hash_tmp) {
	    my @th = split (/;/, $transit_hash_tmp{$key});	        
	    for (my $i =0;$i < (scalar @th) ; $i++) {
		$transit_hash{$th[$i]}=$key.":".$i;
	    }	    
	}
    }


    if ($LADDER_DEBUG >= 1) {    		
	print "LADDER::__build_dicts : ====== THROW PER MULTIPLEX ==============\n";
	for my $key (sort keys %transit_hash_tmp) {
	    print $key." => ".$transit_hash_tmp{$key}."\n";
	}	    
	print "=======================================================\n";	
    }       
    
    if ($LADDER_DEBUG >= 1) {    
	print "LADDER::__build_dicts : ============ TRANSITIONS =================\n";
	for my $key (sort keys %transit_hash) {
	    print $key." => ".$transit_hash{$key}."\n";
	}	    
	print "=======================================================\n";	    
    }		
    
    return ($beat,\%transit_hash,\%ss_hash, $queue_hand);
}


# Internal Usage :  Take a Siteswap and build a color hash according to the color mode choosen 
#                   "0" Throws will never get a color. 
#                ==> If the transitions MAP is defined, prefer using  __build_colorMAP_from_transitionsMAP,
#                     and do it if there were some modifications.
#
sub __build_colorMAP_from_ss
{
    #$_[0] : ss
    #$_[1] : color_mode
    #$_[2] : dot mode  	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 

    my $ss = $_[0];
    my $color_mode=$_[1];
    my $dot_mode=$_[2];

    #Build Colorization and dicts
    my ($period,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($ss, $color_mode,$dot_mode);
    my %transit_hash = %{$transit_hash_tmp};
    my %ss_hash = %{$ss_hash_tmp};
    my %color_hash = ();
    my $cpt_color=0;

    for (my $i = 0; $i < $period ; $i++) {
     	for (my $j = 0; $j < $MAX_MULT; $j++) {
    	    if (exists $transit_hash{ "R".$i.":".$j }) {
    		my $color = '';
    		if (exists $color_hash{ "R".$i.":".$j }) {
    		    $color = $color_hash{ "R".$i.":".$j };
    		} else {
		    if($ss_hash{"R".$i.":".$j} ne "" && $ss_hash{"R".$i.":".$j} ne "0")
		    {
			$color = $common::GRAPHVIZ_COLOR_TABLE[$cpt_color];
			$color_hash{"R".$i.":".$j} = $color; 
			$cpt_color ++;
			if ($cpt_color == scalar @common::GRAPHVIZ_COLOR_TABLE) {
			    $cpt_color=0;
			}
    		    }		    
    		}
		
		if($ss_hash{$transit_hash{"R".$i.":".$j}} ne "" && $ss_hash{$transit_hash{"R".$i.":".$j}} ne "0")
		{
		    $color_hash{$transit_hash{"R".$i.":".$j}} = $color; 
		}
    	    }
    	}
    	for (my $j = 0; $j < $MAX_MULT; $j++) {
    	    if (exists $transit_hash{ "L".$i.":".$j }) {
    		my $color = '';
    		if (exists $color_hash{ "L".$i.":".$j }) {
    		    $color = $color_hash{ "L".$i.":".$j };
    		} else {
		    if($ss_hash{"L".$i.":".$j} ne "" && $ss_hash{"L".$i.":".$j} ne "0")
		    {
			$color = $common::GRAPHVIZ_COLOR_TABLE[$cpt_color];
			$color_hash{"L".$i.":".$j} = $color; 
			$cpt_color ++;
			if ($cpt_color == scalar @common::GRAPHVIZ_COLOR_TABLE) {
			    $cpt_color=0;
			}
		    }
    		}
		if($ss_hash{$transit_hash{"L".$i.":".$j}} ne "" && $ss_hash{$transit_hash{"L".$i.":".$j}} ne "0")
		{
		    $color_hash{$transit_hash{"L".$i.":".$j}} = $color; 
		}
    	    }
    	}
    }

    if ($LADDER_DEBUG >= 1) {    
	print "LADDER::__build_colorMAP : ============ COLORS =================\n";
	for my $key (sort keys %color_hash) {
	    print $key." => ".$color_hash{$key}."\n";
	}	    
	print "=======================================================\n";
    }		
    
    return \%color_hash;
}


# Internal Usage :  Take a TransitionMAP and build a colorMAP 
sub __build_colorMAP_from_transitionsMAP
{
    #$_[0] : transition MAP
    
    my %transit_hash = %{$_[0]};
    # my $color_mode=$_[1];
    # my $dot_mode=$_[2];
    my $period = 0;
    
    # Compute the period
    foreach my $k (sort keys (%transit_hash)) { 	    
	my $src = (split(/:/,$k))[0]; 
	if($period < substr($k,1) + 1)
	{
	    $period = substr($k,1) + 1;
	}
    }	

    # Build Colorization and dicts
    my %color_hash = ();
    my $cpt_color=0;
    
    for (my $i = 0; $i < $period ; $i++) {
     	for (my $j = 0; $j < $MAX_MULT; $j++) {
    	    if (exists $transit_hash{ "R".$i.":".$j }) {
    		my $color = '';
    		if (exists $color_hash{ "R".$i.":".$j }) {
    		    $color = $color_hash{ "R".$i.":".$j };
    		} else {
		    if($transit_hash{ "R".$i.":".$j } ne "R".$i.":".$j )
		    {
			$color = $common::GRAPHVIZ_COLOR_TABLE[$cpt_color];
			$color_hash{"R".$i.":".$j} = $color; 
			$cpt_color ++;
			if ($cpt_color == scalar @common::GRAPHVIZ_COLOR_TABLE) {
			    $cpt_color=0;
			}
    		    }		    
    		}
		
		if($transit_hash{ "R".$i.":".$j } ne "R".$i.":".$j)
		{
		    $color_hash{$transit_hash{"R".$i.":".$j}} = $color; 
		}
    	    }
    	}
    	for (my $j = 0; $j < $MAX_MULT; $j++) {
    	    if (exists $transit_hash{ "L".$i.":".$j }) {
    		my $color = '';
    		if (exists $color_hash{ "L".$i.":".$j }) {
    		    $color = $color_hash{ "L".$i.":".$j };
    		} else {
		    if($transit_hash{ "L".$i.":".$j } ne "L".$i.":".$j)
		    {
			$color = $common::GRAPHVIZ_COLOR_TABLE[$cpt_color];
			$color_hash{"L".$i.":".$j} = $color; 
			$cpt_color ++;
			if ($cpt_color == scalar @common::GRAPHVIZ_COLOR_TABLE) {
			    $cpt_color=0;
			}
		    }
    		}

		if($transit_hash{ "L".$i.":".$j } ne "L".$i.":".$j)
		{
		    $color_hash{$transit_hash{"L".$i.":".$j}} = $color; 
		}
    	    }
    	}
    }

    if ($LADDER_DEBUG >= 1) {    
	print "LADDER::__build_colorMAP_from_transitionsMAP : ============ COLORS =================\n";
	for my $key (sort keys %color_hash) {
	    print $key." => ".$color_hash{$key}."\n";
	}	    
	print "=======================================================\n";
    }		
    
    return \%color_hash;
}


# Internal Usage : Keep a view on all the objects number on each Beat in the Transition MAP
sub __build_objectsNbBeatsMAP_from_transitionsMAP
{
    #$_[0] : transition MAP 
    my %transit_hash = %{$_[0]};


    # Here we assume that all objects are present. There is no objects hole 
    my %objects_hash = ();   
    while (my ($key, $value) = each(%transit_hash) ) {		   
 	
	my $v1 = (split(/:/,$key))[0];
	my $v2 = (split(/:/,$value))[0];	
	
	if($v1 ne $v2)
	{
	    if(exists $objects_hash{$v1})
	    {
		if((split(/:/,$key))[1] +1 > $objects_hash{$v1})
		{
		    $objects_hash{$v1} = (split(/:/,$key))[1]+1; 
		}
	    }
	    else
	    {	   	    
		$objects_hash{$v1} = (split(/:/,$key))[1]+1; 
		
	    }
	    if(exists $objects_hash{$v2})
	    {
		if((split(/:/,$value))[1] +1 > $objects_hash{$v2})
		{
		    $objects_hash{$v2} = (split(/:/,$value))[1]+1; 
		}
	    }
	    else
	    {
		$objects_hash{$v2} = (split(/:/,$value))[1]+1; 
	    }
	}
    }

    if ($LADDER_DEBUG >= 1) {    	
	print "LADDER::__build_objectsNbBeatsMAP_from_transitionsMAP : ============ TRANSITIONS =================\n";
	foreach my $i (sort keys (%transit_hash)) { 	    
	    print $i." => ". $transit_hash{$i}."\n";
	}
	print "=======================================================\n";

	print "LADDER::__build_objectsNbBeatsMAP_from_transitionsMAP : ============ NUMBER ON BEATS =================\n";
	foreach my $i (sort keys (%objects_hash)) { 	    
	    print $i." => ". $objects_hash{$i}."\n";
	}
	print "=======================================================\n";
    }
    
    return \%objects_hash;

}


# Internal Usage : Keep a view on all the objects number on each Beat in the Siteswap MAP
sub __build_objectsNbBeatsMAP_from_ssMAP
{
    #$_[0] : siteswap MAP 

    my %ss_hash = %{$_[0]};


    # Here we assume that all objects are present. There is no objects hole 
    my %objects_hash = ();   
    while (my ($key, $value) = each(%ss_hash) ) {		   
 	
	my $v1 = (split(/:/,$key))[0];
	
	if(exists $objects_hash{$v1})
	{
	    if((split(/:/,$key))[1] +1 > $objects_hash{$v1})
	    {
		$objects_hash{$v1} = (split(/:/,$key))[1]+1; 
	    }
	}
	else
	{	   	    
	    $objects_hash{$v1} = (split(/:/,$key))[1]+1; 
	    
	}	
    }

    if ($LADDER_DEBUG >= 1) {    	
	print "LADDER::__build_objectsNbBeatsMAP_from_ssMAP : ============ SITESWAPS =================\n";
	foreach my $i (sort keys (%ss_hash)) { 	    
	    print $i." => ". $ss_hash{$i}."\n";
	}
	print "=======================================================\n";

	print "LADDER::__build_objectsNbBeatsMAP_from_ssMAP : ============ NUMBER ON BEATS =================\n";
	foreach my $i (sort keys (%objects_hash)) { 	    
	    print $i." => ". $objects_hash{$i}."\n";
	}
	print "=======================================================\n";
    }
    
    return \%objects_hash;

}



# Internal Usage : return a Siteswap MAP from a Transitions MAP 
sub __get_ssMAP_from_transitionsMAP
{
    # $_[0] : Ref on TransitionsMAP

    my %ss_hash = ();
    my %transit_hash = %{$_[0]};
    for my $key (sort keys %transit_hash) {
	my $src = substr((split(/:/, $key))[0],1);	   
	my $dst = substr((split(/:/, $transit_hash{$key}))[0],1);	   
	my $r = -1;
	my $v = $dst - $src; 	
	if ($v >= 0) {
	    $r = sprintf("%x",$v);
	} else {
	    $r = "-".sprintf("%x",$src - $dst);
	}
	
	my $src2 = substr((split(/:/, $key))[0],0,1).$src.":".(split(/:/, $key))[1];
	if (substr((split(/:/, $key))[0],0,1) eq substr((split(/:/, $transit_hash{$key}))[0],0,1)) {
	    if ($v %2 == 0) {
		$ss_hash{$src2}= $r;
	    } else {		
		if($r ne "0")
		{
		    $ss_hash{$src2}= $r."x";
		}
		else
		{
		    $ss_hash{$src2}= $r;
		}
	    }
	} else {
	    if ($v %2 == 0) {
		if($r ne "0")
		{
		    $ss_hash{$src2}= $r."x";
		}
		else
		{
		    $ss_hash{$src2}= $r;
		}
	    } else {
		$ss_hash{$src2}= $r;
	    }
	}
    }

    if ($LADDER_DEBUG >= 1) {    
	print "LADDER::__get_ssMAP_from_transitionsMAP : ================ TRANSITIONS ===================\n";
	for my $key (sort keys %transit_hash) {
	    print $key." => ".$transit_hash{$key}."\n";
	}	    
	print "=======================================================\n";	    

	print "LADDER::__get_ssMAP_from_transitionsMAP : ================== SITESWAP ===================\n";
	for my $key (sort keys %ss_hash) {
	    print $key." => ".$ss_hash{$key}."\n";
	}	    
	print "=======================================================\n";    
    }		

    
    return %ss_hash;
}



# Internal Usage : return a Siteswap from a Transitions MAP
sub __get_ss_from_transitionsMAP
{    
    #$_[0] : Ref on TransitionsMAP
    #$_[1] : Must be equal to "R", "L" to indicate the next hand awaited after the ss. 
    #        The goal is to handle last eventual "*"
    #        Any Value will handle a last ! if the last throw is a sync 

    sub __switch_hand
    {
	my $hand = uc($_[0]);
	if ($hand eq "R") {
	    return "L";
	} else {
	    return "R";
	}
    }

    my %transit_hash = %{$_[0]}; 
    my $color_mode=2;
    my $dot_mode=0;
    # Update to have correct Multiplex on key  according to the color_mode before reading it 
    #my ($period,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts(" ", $color_mode,$dot_mode,\%transit_hash);
    #%transit_hash = %{$transit_hash_tmp};

    my %ss_hash = &__get_ssMAP_from_transitionsMAP(\%transit_hash);  
    my $ss = "";

    my $period = -1;


    for my $key (sort keys %transit_hash) {
	my $k=(split(/:/,$key))[0];
	if ( $period < int(substr($k,1)) ) {
	    $period = int(substr($k,1));
	}
    }	    
    $period ++;

    my $prev_sync = -1;
    my $prev_beat = -1;
    my $prev_side = "L";


    my %objects_hash = %{&__build_objectsNbBeatsMAP_from_transitionsMAP(\%transit_hash)};

    for (my $i=0; $i< $period; $i++) {   
	if (exists $objects_hash{"R".${i}} && exists $objects_hash{"L".${i}}) {	

	    my $right=""; 
	    my $left=""; 
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $transit_hash{"R".${i}.":".$l}) {				
		    $right = $right.$ss_hash{"R".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }
	    if ($cpt > 1) {
		$right = "[".$right."]";
	    }
	    elsif ($cpt == 0) {
		$right = 0; 
	    }

	    $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $transit_hash{"L".${i}.":".$l}) {
		    $left = $left.$ss_hash{"L".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }	
	    if ($cpt > 1) {
		$left = "[".$left."]";
	    }
	    elsif ($cpt == 0) {
		$left = 0; 
	    }

	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "R") {
		    $ss = $ss."!(".$left.",".$right.")";
		} else {
		    $ss = $ss."!(".$right.",".$left.")";
		}
	    } else {
		if ($prev_side eq "R") {
		    $ss = $ss."(".$left.",".$right.")";
		} else {
		    $ss = $ss."(".$right.",".$left.")";
		}
	    }
	    
	    $prev_sync = 1;
	    $prev_beat=$i;
	} 
	elsif (exists $objects_hash{"R".${i}})
	{	    
	    my $right="";
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $transit_hash{"R".${i}.":".$l}) {
		    $right = $right.$ss_hash{"R".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }
	    if ($cpt > 1) {
		$right = "[".$right."]";
	    }
	    
	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "L") {
		    $ss = $ss."!".$right;
		} else {
		    $ss = $ss."!*".$right;
		}	
	    } else {
		if ($prev_side eq "L") {
		    $ss = $ss.$right;
		} else {
		    $ss = $ss."*".$right;
		}	
	    }
	    $prev_sync = -1;
	    $prev_side = "R";
	    $prev_beat=$i;
	} 
	elsif (exists $objects_hash{"L".${i}})
	{
	    my $left=""; 
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $transit_hash{"L".${i}.":".$l}) {
		    $left = $left.$ss_hash{"L".${i}.":".$l};
		    $cpt++;
		}
		$l++
	    }
	    if ($cpt > 1) {
		$left = "[".$left."]";
	    }
	    
	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "R") {
		    $ss = $ss."!".$left;
		} else {
		    $ss = $ss."!*".$left;
		}	
	    } else {
		if ($prev_side eq "R") {
		    $ss = $ss.$left;
		} else {
		    $ss = $ss."*".$left;
		}	
	    }
	    $prev_sync = -1;
	    $prev_side = "L";	
	    $prev_beat=$i;
	}	    
	else
	{
	    if ($prev_sync == 1)
	    {
		$prev_sync = -1;	    
	    }
	    else
	    {
		$ss=$ss."0";
		if ($prev_side eq "R")
		{
		    $prev_side = "L";			
		}
		else {
		    $prev_side = "R";			
		}	
	    }	
	    $prev_beat=$i;
	}
    }


    # Here the last "!" is handled
    if(exists $_[1] && $prev_sync == 1)
    {
	$ss=$ss."!";	
    }

    # The last "*" may be handled if the Awaited Hand is set in the call
    if(exists $_[1] && $_[1] eq $prev_side)
    {
	$ss=$ss."*";
    }

    # Remove all "**"
    $ss =~ s/\*\*//g;

    if ($LADDER_DEBUG >= 1) {
	print "LADDER::__get_ss_from_transitionsMAP: ".$ss."\n";
    }

    return $ss;
}



# Internal Usage : return a Siteswap from a Siteswaps MAP
sub __get_ss_from_ssMAP
{    
    #$_[0] : Ref on Siteswaps MAP
    #$_[1] : If exist, must be equal to "R", "L" to indicate the next hand awaited after the ss. 
    #        The goal is to handle last eventual "*"

    my %ss_hash = %{$_[0]}; 
    my $color_mode=2;
    my $ss = "";

    my $period = -1;

    for my $key (sort keys %ss_hash) {
	my $k=(split(/:/,$key))[0];
	if ( $period < int(substr($k,1)) ) {
	    $period = int(substr($k,1));
	}
    }	    
    $period ++;

    my $prev_sync = -1;
    my $prev_beat = -1;
    my $prev_side = "L";


    my %objects_hash = %{&__build_objectsNbBeatsMAP_from_ssMAP(\%ss_hash)};

    for (my $i=0; $i< $period; $i++) {   
	if (exists $objects_hash{"R".${i}} && exists $objects_hash{"L".${i}}) {	
	    
	    my $right=""; 
	    my $left=""; 
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $ss_hash{"R".${i}.":".$l}) {				
		    $right = $right.$ss_hash{"R".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }
	    if ($cpt > 1) {
		$right = "[".$right."]";
	    }
	    elsif ($cpt == 0) {
		$right = 0; 
	    }

	    $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $ss_hash{"L".${i}.":".$l}) {
		    $left = $left.$ss_hash{"L".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }	
	    if ($cpt > 1) {
		$left = "[".$left."]";
	    }
	    elsif ($cpt == 0) {
		$left = 0; 
	    }

	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "R") {
		    $ss = $ss."!(".$left.",".$right.")";
		} else {
		    $ss = $ss."!(".$right.",".$left.")";
		}
	    } else {
		if ($prev_side eq "R") {
		    $ss = $ss."(".$left.",".$right.")";
		} else {
		    $ss = $ss."(".$right.",".$left.")";
		}
	    }
	    
	    $prev_sync = 1;
	    $prev_beat=$i;
	} 
	elsif (exists $objects_hash{"R".${i}})
	{	    
	    my $right="";
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $ss_hash{"R".${i}.":".$l}) {
		    $right = $right.$ss_hash{"R".${i}.":".$l};
		    $cpt++;
		}
		$l++;
	    }
	    if ($cpt > 1) {
		$right = "[".$right."]";
	    }
	    
	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "L") {
		    $ss = $ss."!".$right;
		} else {
		    $ss = $ss."!*".$right;
		}	
	    } else {
		if ($prev_side eq "L") {
		    $ss = $ss.$right;
		} else {
		    $ss = $ss."*".$right;
		}	
	    }
	    $prev_sync = -1;
	    $prev_side = "R";
	    $prev_beat=$i;
	} 
	elsif (exists $objects_hash{"L".${i}})
	{
	    my $left=""; 
	    my $cpt = 0;
	    my $l = 0;
	    while ($l < $MAX_MULT)
	    {
		if(exists $ss_hash{"L".${i}.":".$l}) {
		    $left = $left.$ss_hash{"L".${i}.":".$l};
		    $cpt++;
		}
		$l++
	    }
	    if ($cpt > 1) {
		$left = "[".$left."]";
	    }
	    
	    if ($prev_sync == 1 && $i - $prev_beat == 1) {
		if ($prev_side eq "R") {
		    $ss = $ss."!".$left;
		} else {
		    $ss = $ss."!*".$left;
		}	
	    } else {
		if ($prev_side eq "R") {
		    $ss = $ss.$left;
		} else {
		    $ss = $ss."*".$left;
		}	
	    }
	    $prev_sync = -1;
	    $prev_side = "L";	
	    $prev_beat=$i;
	}	    
	else
	{
	    if ($prev_sync == 1)
	    {
		$prev_sync = -1;	    
	    }
	    else
	    {
		$ss=$ss."0";
		if ($prev_side eq "R")
		{
		    $prev_side = "L";			
		}
		else {
		    $prev_side = "R";			
		}	
	    }	
	    $prev_beat=$i;
	}
    }


    # Here the last "!" is handled
    if(exists $_[1] && $prev_sync == 1)
    {
	$ss=$ss."!";	
    }

    # The last "*" may be handled if the Awaited Hand is set in the call
    if(exists $_[1] && $_[1] eq $prev_side)
    {
	$ss=$ss."*";
    }

    # Remove all "**"
    $ss =~ s/\*\*//g;

    if ($LADDER_DEBUG >= 1) {
	print "LADDER::__get_ss_from_ssMAP: ".$ss."\n";
    }

    return $ss;

}


# Graphviz must be installed prior    
sub draw 
{    
    # $_[0] : SS
    # $_[1] : Image File
    # $_[2] : Options
    # $_[3] : Transition Hash (thus the siteswap will not be used anymore to draw the Diagram)    
    
    my $ss = $_[0];    
    my $flat = 2;
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

    my $period = -1;
    my $color_mode = 2;		# Colorization Mode for Multiplexes
    my $dot_mode = 0;		# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $label_pos = "t";	# Label Position (t: tail, h : head, m : middle, null/none : no label)
    my %ss_hash = ();
    my %transit_hash  = ();
    my $title = "Y";
    my $nullSS = "N";
    my $silence = 0;
    my $model=0;		# Drawing Model : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)  
    my $hands = "Y";            # Print Hands 
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $label_color="E";
    my $graphviz_output="N";
    my $hands_seq = "R,L";

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
				    "-H:s" => \$hands,
				    "-I:s" => \$hands_seq,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,			
	);

    
    my %color_hash = ();
    my $cpt_color = 0;
    my $default_color = $common::GRAPHVIZ_COLOR_TABLE[0];
    my $new_ss = $ss;
    my @hands_seq_int = split(',',$hands_seq);
    
    if($label_edge_colorization ne "E")
    {
	$label_color=$label_edge_colorization;
    }

    if (scalar @_ == 4) {
	%transit_hash=%{$_[3]};
	%ss_hash=&__get_ssMAP_from_transitionsMAP(\%transit_hash);
    }

    # No Transition MAP in input, then build it
    if (scalar keys %transit_hash ==0) {
	# Remove circle after a Sync throw
	my ($beat, $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss,$dot_mode);
	
	my @res_left = @{$res_left_tmp};
	my @res_right = @{$res_right_tmp};
	
	if ($period == -1) {
	    if ($beat <  $PERIOD_MAX) {
		$period = $PERIOD_MAX;
	    } else {
		$period = $beat + $PERIOD_MAX;
	    }
	}
	
	$new_ss = $ss;
	
	if ($beat != 0 ) {
	    my $r = int($period / $beat);
	    for (my $i=1; $i <= $r; $i++) {
		$new_ss = $new_ss.$ss;
	    }    
	}
    	
	if (scalar keys %ss_hash == 0) {
	    my ($beat,  $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($new_ss, $color_mode,$dot_mode);
	    $period = $beat;		
	    %ss_hash = %{$ss_hash_tmp};
	    %transit_hash = %{$transit_hash_tmp};
	} 
    }
    
    else
    {
	$new_ss = &__get_ss_from_transitionsMAP(\%transit_hash);
    }
    
    if (scalar keys %ss_hash != 0 || scalar keys %transit_hash !=0) {	
	if ($LADDER_DEBUG >= 1) {    
	    print "LADDER::draw : ================== SITESWAP ===================\n";
	    for my $key (sort keys %ss_hash) {
		print $key." => ".$ss_hash{$key}."\n";
	    }	    
	    print "=======================================================\n";
	    
	    print "LADDER::draw : ================ TRANSITIONS ===================\n";
	    for my $key (sort keys %transit_hash) {
		print $key." => ".$transit_hash{$key}."\n";
	    }	    
	    print "=======================================================\n";	    
	}		
	
	for my $key (sort keys %transit_hash) {	
	    my @th = split (/:/, $transit_hash{$key});
	    if ( $period < int(substr($th[0],1)) ) {
		$period = int(substr($th[0],1));
	    }	    
	}		
	$period ++;
    } else {	
	return -1;
    }
    
    #Build Colorization and dicts
    %color_hash=%{&__build_colorMAP_from_transitionsMAP(\%transit_hash,$color_mode,$dot_mode)};
    
    if ($LADDER_DEBUG >= 1) {
	print "LADDER::draw ===================== COLORS ==================\n";
	foreach my $i (sort keys (%color_hash)) { 	    
	    print $i." => ". $color_hash{$i}."\n";
	}
	print "====================================================\n";
    }            

    open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	|| die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
    print GRAPHVIZ "digraph LADDER_DIAGRAM{\n";    

    my $distance_label_slide = 1.5;
    my $distance_label_slide = 2.0;
    my $angle_label_slide_orig = 180;
    my $angle_label_slide = 25;
    # Dictionnary to draw Edge Label in S mode
    my %label_hash = {};
    
    if ($model==1) { # Drawing Model : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	print GRAPHVIZ "Start [label=\"\", shape=none]\n";	
	# With some siteswaps we got problem in generating the SS Async Diagram in Graphviz 2.28 and prior.
	# This was because of Multiplexes with the same height. 
	#   ($ss eq "4[22]0[32]32"
	#    || $ss eq "[222]0"
	#    || $ss eq "[22]2"
	#    || $ss eq "[22]2[23]22"
	#    || $ss eq "[44][22]3"
	#    || $ss eq "[54][22]2"
	#    || $ss eq "[64][62]1[22]2"
	#    || $ss eq "[75][22]2"	   
	#    || $ss eq "[776]20[76]20[76][22]0"
	#    )
	# This is a hack to correct this issue by removing nodesep. It does not remove all pbs
	#print GRAPHVIZ "nodesep=".($NODESEP*2)."\n";
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
	print GRAPHVIZ "\n\n";

	# Subgraph
	print GRAPHVIZ "subgraph diag {\n";
	print GRAPHVIZ "rank=same;\n";
	my $side = $hands_seq_int[0];
	my $side_cpt = 0;
	foreach my $i (0..($period-1)) {	    	 

	    if (uc($hands) eq 'Y')
	    {
		if (exists $ss_hash{ "R".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";	 
		} elsif (exists $ss_hash{ "L".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";	 
		} else {	 
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";
		}

		$side_cpt = ($side_cpt+1)%(scalar @hands_seq_int);
		$side = $hands_seq_int[$side_cpt];		    
	    }
	    else
	    {
		if (exists $ss_hash{ "R".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"\",  shape=circle, width=.1] // node N".${i}."\n";	 
		} elsif (exists $ss_hash{ "L".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"\",  shape=circle, width=.1] // node N".${i}."\n";	 
		} else {	 
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"\",  shape=point, width=.1] // node N".${i}."\n";
		}
	    }
	}
	
	print GRAPHVIZ " Start -> N0 [style=invis]\n"; 
	my $rtmp = "N0";
	for (my $i = 1; $i < $period; $i++) {
	    $rtmp = $rtmp." -> N".$i;
	}
	

	print GRAPHVIZ $rtmp." [style=invis]\n";
	print GRAPHVIZ "}\n";
	print GRAPHVIZ "\n\n";   
	
	foreach my $k (sort keys (%ss_hash)) { 	    
	    my $color = $default_color;
	    my $src = (split(/:/,$k))[0];
	    $src=substr($src,1);
	    my $css = lc($ss_hash{$k});
	    
	    $css =~ s/x//g;
	    $css = hex($css);
	    if (substr($ss_hash{$k},0,1) eq '-')
	    {
		$css = -$css;
	    }
	    my $dest = $css + int($src);
	    $src="N".$src;
	    $dest = "N".$dest;
	    if (($css > 0 || ($ss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && int(substr($dest,1)) < $period) {

		if ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && (substr($dest,1)) < $period && (substr($ss_hash{$k},0,1) eq '-')) {
		    $dest = int($src)+$css+1;
		    $dest = "N".$dest;
		}

		if ($color_mode != 0 && exists $color_hash{$k}) {
		    $color = $color_hash{$k};
		}		    
		
		if($label_edge_colorization eq "E")
		{
		    $label_color=$color;
		}

		
		if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		}
		if (uc($label_pos) eq "M") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  	
		} elsif (uc($label_pos) eq "X") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  	 
		} elsif (uc($label_pos) eq "T") {		   
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		} elsif (uc($label_pos) eq "S") {
		    if(exists $label_hash{ $src })
		    {	
			my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  
			$label_hash{ $src } ++;
		    }
		    else
		    {		
			my $angle = $angle_label_slide_orig;		       
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n"; 			
			$label_hash{ $src } = 1;
		    }
		} elsif (uc($label_pos) eq "H") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		}	    		
	    }	    
	}      
    } elsif ($model==2) { # Drawing Model : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)  
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	if(uc($hands) eq "Y")
	{
	    print GRAPHVIZ "RHand [label=\"Right\", shape=none]\n";
	    print GRAPHVIZ "LHand [label=\"Left\", shape=none]\n"; 
	}
	else
	{
	    print GRAPHVIZ "RHand [label=\"\", shape=none]\n";
	    print GRAPHVIZ "LHand [label=\"\", shape=none]\n"; 
	}   	
	print GRAPHVIZ "nodesep=".$NODESEP."\n";
	
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
	print GRAPHVIZ "\n\n";

	# Right Hand Subgraph
	print GRAPHVIZ "subgraph rhand_diag {\n";
	
	print GRAPHVIZ "rank=same;\n";
	foreach my $i (0..($period-1)) {		
	    if ($i%2 != 0) {
		print GRAPHVIZ "\""."R".${i}."\""." [label=\"\",  shape=point, width=.1, style=invis] // node R".${i}."\n";
		next;
	    }
	    if (exists $ss_hash{ "R".$i.":0" }) {
		print GRAPHVIZ "\""."R".${i}."\""." [label=\"\",  shape=circle, width=.2] // node R".${i}."\n";	 
	    } else {	 
		print GRAPHVIZ "\""."R".${i}."\""." [label=\"\",  shape=point, width=.1] // node R".${i}."\n";
	    }
	}
	print GRAPHVIZ "RHand -> R0 [style=invis]\n"; 
	
	my $rtmp = "R0";
	for (my $i = 1; $i < $period; $i++) {
	    $rtmp = $rtmp." -> R".$i;
	}
	
	print GRAPHVIZ $rtmp." [style=invis]\n";
	print GRAPHVIZ "}\n";
	print GRAPHVIZ "\n\n";   
	
	# Left Hand Subgraph
	print GRAPHVIZ "subgraph lhand_diag {\n";
	print GRAPHVIZ "rank=same;\n";  
	foreach my $i (0..($period-1)) {		
	    if ($i%2 != 0) {
		print GRAPHVIZ "\""."L".${i}."\""." [label=\"\",  shape=point, width=.1, style=invis] // node L".${i}."\n";
		next;
	    }
	    if (exists $ss_hash{ "L".$i.":0" }) {	 	  
		print GRAPHVIZ "\""."L".${i}."\""." [label=\"\",  shape=circle, width=.2] // node L".${i}."\n";	 
	    } else {		  
		print GRAPHVIZ "\""."L".${i}."\""." [label=\"\",  shape=point, width=.1 ] // node L".${i}."\n";
	    }	
	}
	print GRAPHVIZ "LHand -> L0 [style=invis]\n"; 
	my $ltmp = "L0";
	for (my $i = 1; $i < $period; $i++) {
	    $ltmp = $ltmp." -> L".$i;
	}

	print GRAPHVIZ $ltmp." [style=invis]\n";
	print GRAPHVIZ "}\n";
	print GRAPHVIZ "\n\n";

	# Connect subgraph
	print GRAPHVIZ "RHand -> LHand [style=invis]\n"; 
	foreach my $i (0..($period-1)) {
	    print GRAPHVIZ "\"R".${i}."\""."->"."\"L".${i}."\""." "." [style=invis]\n";
	}
	
	print GRAPHVIZ "\n\n";

	foreach my $k (sort keys (%transit_hash)) { 	    
	    my $color = $default_color;

	    my $src = (split(/:/,$k))[0]; 
	    my @dest_t =split(/:/,$transit_hash{$k});	

	    my $css = lc($ss_hash{$k});
	    $css =~ s/x//g;	    
	    $css = hex($css);
	    if (substr($ss_hash{$k},0,1) eq '-')
	    {
		$css = -$css;
	    }

	    if (($css > 0 || ($ss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && int(substr($dest_t[0],1)) < $period) {
		my $dest = substr($dest_t[0],0,1).((substr($dest_t[0],1)) );

		if ($color_mode != 0 && exists $color_hash{$k}) {
		    $color = $color_hash{$k};
		}		    

		if($label_edge_colorization eq "E")
		{
		    $label_color=$color;
		}
		
		if ($k =~ "L" && $transit_hash{$k} =~ "L") {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } ++;
			}
			else
			{
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } =1;
			}
			
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		} elsif ($k =~ "R" && $transit_hash{$k} =~ "R") {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N" || uc($label_pos) eq "NO") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n"; 
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".",  labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } ++;
			}
			else
			{
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".",  labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } =1;
			}
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		} else {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N" || uc($label_pos) eq "NO") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".",  labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } ++;
			}
			else
			{
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".",  labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } =1;
			}
			
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		}
		
	    }
	}
    } else { # Drawing Model = 0 : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)  
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	if(uc($hands) eq "Y")
	{
	    print GRAPHVIZ "RHand [label=\"Right\", shape=none]\n";
	    print GRAPHVIZ "LHand [label=\"Left\", shape=none]\n"; 
	}
	else
	{
	    print GRAPHVIZ "RHand [label=\"\", shape=none]\n";
	    print GRAPHVIZ "LHand [label=\"\", shape=none]\n"; 
	}	    
	print GRAPHVIZ "nodesep=".$NODESEP."\n"; 
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
	print GRAPHVIZ "\n\n";

	# Right Hand Subgraph
	print GRAPHVIZ "subgraph rhand_diag {\n";
	
	print GRAPHVIZ "rank=same;\n";
	foreach my $i (0..($period-1)) {		
	    if (exists $ss_hash{ "R".$i.":0" }) {
		print GRAPHVIZ "\""."R".${i}."\""." [label=\"\",  shape=circle, width=.2] // node R".${i}."\n";	 
	    } else {	 
		print GRAPHVIZ "\""."R".${i}."\""." [label=\"\",  shape=point, width=.1] // node R".${i}."\n";
	    }
	}
	print GRAPHVIZ "RHand -> R0 [style=invis]\n"; 
	
	my $rtmp = "R0";
	for (my $i = 1; $i < $period; $i++) {
	    $rtmp = $rtmp." -> R".$i;
	}
	
	print GRAPHVIZ $rtmp." [style=invis]\n";
	print GRAPHVIZ "}\n";
	print GRAPHVIZ "\n\n";   
	
	# Left Hand Subgraph
	print GRAPHVIZ "subgraph lhand_diag {\n";
	print GRAPHVIZ "rank=same;\n";  
	foreach my $i (0..($period-1)) {		
	    if (exists $ss_hash{ "L".$i.":0" }) {	 	  
		print GRAPHVIZ "\""."L".${i}."\""." [label=\"\",  shape=circle, width=.2] // node L".${i}."\n";	 
	    } else {		  
		print GRAPHVIZ "\""."L".${i}."\""." [label=\"\",  shape=point, width=.1 ] // node L".${i}."\n";
	    }	
	}
	print GRAPHVIZ "LHand -> L0 [style=invis]\n"; 
	my $ltmp = "L0";
	for (my $i = 1; $i < $period; $i++) {
	    $ltmp = $ltmp." -> L".$i;
	}

	print GRAPHVIZ $ltmp." [style=invis]\n";
	print GRAPHVIZ "}\n";
	print GRAPHVIZ "\n\n";

	# Connect subgraph
	print GRAPHVIZ "RHand -> LHand [style=invis]\n"; 
	foreach my $i (0..($period-1)) {
	    print GRAPHVIZ "\"R".${i}."\""."->"."\"L".${i}."\""." "." [style=invis]\n";
	}
	
	print GRAPHVIZ "\n\n";

	foreach my $k (sort keys (%transit_hash)) { 	    
	    my $color = $default_color;

	    my $src = (split(/:/,$k))[0]; 
	    my @dest_t =split(/:/,$transit_hash{$k});	
	    my $css = lc($ss_hash{$k});
	    $css =~ s/x//g;
	    $css = hex($css);
	    if (substr($ss_hash{$k},0,1) eq '-')
	    {
		$css = -$css;
	    }
	    
	    if (($css > 0 || ($ss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && int(substr($dest_t[0],1) -1) < $period) {

		my $dest = substr($dest_t[0],0,1).((substr($dest_t[0],1)) -1);
		if ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && (substr($dest_t[0],1)) < $period && (substr($ss_hash{$k},0,1) eq '-')) {
		    $dest = substr($dest_t[0],0,1).(substr($dest_t[0],1));
		}
		if ($color_mode != 0 && exists $color_hash{$k}) {
		    $color = $color_hash{$k};
		}		    		

		if($label_edge_colorization eq "E")
		{
		    $label_color=$color;
		}

		if ($k =~ "L" && $transit_hash{$k} =~ "L") {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  	
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } ++;
			}
			else
			{
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } =1;
			}

		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\":s"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		} elsif ($k =~ "R" && $transit_hash{$k} =~ "R") {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N" || uc($label_pos) eq "NO") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";   
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  		
			    $label_hash{ $src } ++;
			}
			else
			{
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  		
			    $label_hash{ $src } =1;
			}				
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\":n"."->"."\"".$dest."\":n"." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		} else {
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N" || uc($label_pos) eq "NO") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$ss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n"; 
		    } elsif (uc($label_pos) eq "T") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } ++;
			}
			else
			{			    
			    my $angle = $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$ss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  			
			    $label_hash{ $src } =1;			
			}		
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$ss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		    }	    
		}
		
		if ($css > 0 && (substr($dest_t[0],1)) < $period) {
		    print GRAPHVIZ "\"".$dest."\""."->"."\"".$dest_t[0]."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		}
		#elsif ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && (substr($dest_t[0],1)) < $period) {
		#		    print GRAPHVIZ "\"".$dest."\""."->"."\"".$dest_t[0]."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		#}	    
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
	copy("$conf::TMPDIR\\${fileOutput}.graphviz","$conf::RESULTS/");
    }
    
    if ($LADDER_DEBUG <= 0) {
	unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
    }

    print "\n";
    if ($silence == 0) {
	print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_DRAW_1." : "."$conf::RESULTS/$fileOutput"."\n\n";    
    }
}


sub sym
{
    # $_[0] : SS
    # $_[1] : Image File
    # $_[2] : Options
    
    my $ss = $_[0];

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $dot_mode=0; 	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $model=0;
    my $hands = "Y";            # Print Hands 
    my $silence = 0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[2]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,
				    "-D:i" => \$dot_mode,		
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);

    my ($beat,  $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss, $dot_mode);
    if ($period == -1) {
	if ($beat <  $PERIOD_MAX) {
	    $period = $PERIOD_MAX;
	} else {
	    $period = $beat + $PERIOD_MAX;
	}
    }

    my $new_ss = $ss;
    
    if ($beat !=0 ) {
	my $r = int($period / $beat);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss = $new_ss.$ss;
	}    
    }    

    my ($period, $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($new_ss, $color_mode, $dot_mode);
    my %transit_hash = %{$transit_hash_tmp};
    my %ss_hash = %{$ss_hash_tmp};

    my %transit_hash_tmp =();
    while ( my ($key, $value) = each(%transit_hash) ) {		   
	$value =~ s/L/r/;
	$value =~ s/R/L/;
	$value =~ s/r/R/;
	$key =~ s/L/r/;
	$key =~ s/R/L/;
	$key =~ s/r/R/;
	$transit_hash_tmp{$key}=$value;
    }
    
    %transit_hash=%transit_hash_tmp;
    
    $ss = &__get_ss_from_transitionsMAP(\%transit_hash);

    if ($silence == 0) {
	draw("$ss",$_[1],$_[2],\%transit_hash);        
	print colored [$common::COLOR_RESULT], $ss."\n";
    } else {
	draw("$ss",$_[1],$_[2]." -S 1",\%transit_hash);        
    }

    return lc($ss);
}



sub removeObj
{
    # $_[0] : SS
    # $_[1] : ObjNumber or ObjNumberList
    # $_[2] : Image File
    # $_[3] : Options
    
    my $ss = $_[0];
    my $objsToRemove = $_[1];
    $objsToRemove =~ s/\s+//g;

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $dot_mode=0; 	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $model=0;
    my $hands = "Y";            # Print Hands 
    my $silence = 0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,
				    "-D:i" => \$dot_mode,		
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);

    my ($beat,  $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss, $dot_mode);
    if ($period == -1) {
	if ($beat <  $PERIOD_MAX) {
	    $period = $PERIOD_MAX;
	} else {
	    $period = $beat + $PERIOD_MAX;
	}
    }

    my $new_ss = $ss;
    
    if ($beat !=0 ) {
	my $r = int($period / $beat);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss = $new_ss.$ss;
	}    
    }    

    
    my ($period, $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($new_ss,$color_mode,$dot_mode);
    my %transit_hash = %{$transit_hash_tmp};
    my %ss_hash = %{$ss_hash_tmp};
    my %color_hash=%{&__build_colorMAP_from_transitionsMAP(\%transit_hash,$color_mode,$dot_mode)};
    
    my @objList=();
    if( $objsToRemove =~ /\[/ && $objsToRemove =~ /\]/)
    {
 	my @v = split(/,/,$objsToRemove);
	
	for(my $i=0; $i < scalar @v; $i++)
	{
	    if($v[$i] eq "]")
	    {
		last;
	    }
	    push(@objList,$v[$i]);
	}	
    }
    else
    {
	push(@objList,$objsToRemove);
    }

    foreach my $o (@objList)
    {    
	foreach my $k (sort keys (%transit_hash))  	    
	{
	    if($color_hash{$k} eq $common::GRAPHVIZ_COLOR_TABLE[$o])
	    {
		delete $transit_hash{$k};
	    }
	}
    }
    
    $ss = &__get_ss_from_transitionsMAP(\%transit_hash);
    
    if ($silence == 0) {
	draw("$ss",$_[2],$_[3],\%transit_hash);        
	print colored [$common::COLOR_RESULT], $ss."\n";
    } else {
	draw("$ss",$_[2],$_[3]." -S 1",\%transit_hash);        
    }

    return lc($ss);
}


sub merge
{
    # $_[0] : SS 1
    # $_[1] : SS 2
    # $_[2] : Image File
    # $_[3] : Options
    
    my $ss1 = uc($_[0]);
    my $ss2 = uc($_[1]);

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $dot_mode=0; 	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $model=0;
    my $cleanMultiplex=0; # Set to 1 if you need to have 0 in multiplex 
    my $hands = "Y";            # Print Hands 
    my $silence=0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,
				    "-D:i" => \$dot_mode,		
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-R:i" => \$cleanMultiplex,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);

    my ($beat1,  $res_left_tmp1, $res_right_tmp1, $queue_hand1) = &__build_lists($ss1, $dot_mode);
    my $period1=-1;
    if ($period == -1) {
	if ($beat1 <  $PERIOD_MAX) {
	    $period1 = $PERIOD_MAX;
	} else {
	    $period1 = $beat1 + $PERIOD_MAX;
	}
    }
    my ($beat2,  $res_left_tmp2, $res_right_tmp2, $queue_hand2) = &__build_lists($ss2, $dot_mode);
    my $period2=-1;
    if ($period == -1) {
	if ($beat2 <  $PERIOD_MAX) {
	    $period2 = $PERIOD_MAX;
	} else {
	    $period2 = $beat2 + $PERIOD_MAX;
	}
    }

    $period = $period1;
    if($period2 > $period1)
    {$period=$period2;}

    my $new_ss1 = $ss1;    
    if ($beat1 !=0 ) {
	my $r = int($period / $beat1);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss1 = $new_ss1.$ss1;
	}    
    }    

    my $new_ss2=$ss2;
    if ($beat2 !=0 ) {
	my $r = int($period / $beat2);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss2 = $new_ss2.$ss2;
	}
    }    
    
    
    my ($period1, $transit_hash_tmp1, $ss_hash_tmp1, $queue_hand1) = &__build_dicts($new_ss1,$color_mode,$dot_mode);
    my %transit_hash1 = %{$transit_hash_tmp1};
    my ($period2, $transit_hash_tmp2, $ss_hash_tmp2, $queue_hand2) = &__build_dicts($new_ss2,$color_mode,$dot_mode);
    my %transit_hash2 = %{$transit_hash_tmp2};
    
    # Keep a view on all the objects on each Beat in the Transition MAP
    # Here we assume that all objects are present. There is no objects hole    
    my $objects_hash_tmp = &__build_objectsNbBeatsMAP_from_transitionsMAP(\%transit_hash1);
    my %objects_hash1 = %{$objects_hash_tmp};
    
    while( my ($key, $value) = each (%transit_hash2) )  	    
    {
	my $v1 = (split(/:/,$key))[0];
	my $v2 = (split(/:/,$value))[0];
	my $src = '';
	my $dst = '';

	if(exists $objects_hash1{$v1})
	{
	    $src = $v1.":".($objects_hash1{$v1}+(split(/:/,$key))[1]);	    
	}
	else
	{
	    $src=$key;

	}

	if(exists $objects_hash1{$v2})
	{	    
	    
	    $dst = $v2.":".($objects_hash1{$v2}+(split(/:/,$value))[1]);	    
	}
	else
	{
	    $dst=$value;
	    
	}

	
	$transit_hash1{$src}=$dst;
    }
    

    if($cleanMultiplex != 1)
    {
	# Remove 0 in Multiplex 
	my %number_hash=%{&__build_objectsNbBeatsMAP_from_transitionsMAP(\%transit_hash1)};
	foreach my $k (sort keys (%transit_hash1))  	    
	{
	    my $v1 = (split(/:/,$k))[0];
	    my $v2 = (split(/:/,$transit_hash1{$k}))[0];
	    if($v1 eq $v2 && exists $number_hash{$v1} && $number_hash{$v1} > 1)
	    {
		delete $transit_hash1{$k};
		$number_hash{$v1} --;
	    }
	}
    }
    
    my $ss = &__get_ss_from_transitionsMAP(\%transit_hash1);
    
    if ($silence == 0) {
	draw("$ss",$_[2],$_[3],\%transit_hash1);        
	print colored [$common::COLOR_RESULT], $ss."\n";
    } else {
	draw("$ss",$_[2],$_[3]." -S 1",\%transit_hash1);        
    }

    return lc($ss);
}


sub slide
{
    # $_[0] : SS
    # $_[1] : Hand To slide
    # $_[2] : Slide Value (+..., -...)
    # $_[3] : Image File
    # $_[4] : Options
    # $_[5] : -1 for drawing without printing the results 

    my $ss = $_[0];
    my $slide = $_[2];
    my $result = 1;

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $model=0;
    my $dot_mode=0;  	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $hands = "Y";            # Print Hands 
    my $silence = 0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[4]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,	
				    "-D:i" => \$dot_mode,	
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);

    my ($beat,  $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss, $dot_mode);

    if ($period == -1) {
	if ($beat <  $PERIOD_MAX) {
	    $period = $PERIOD_MAX;
	} else {
	    $period = $beat + $PERIOD_MAX;
	}
    }

    my $new_ss = $ss;
    
    if ($beat !=0 ) {
	my $r = int($period / $beat);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss = $new_ss.$ss;
	}    
    }    

    my ($period, $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($new_ss, $color_mode, $dot_mode);

    my %transit_hash = %{$transit_hash_tmp};
    my %ss_hash = %{$ss_hash_tmp};

    my %transit_hash_tmp =();
    my %ss_hash_tmp =();

    while ( my ($key, $value) = each(%transit_hash) ) {	
	my $v1 = (split(/:/,$key))[0];
	my $vin1 = int(substr($v1,1));       
	my $v2 = (split(/:/,$value))[0];
	my $vin2 = int(substr($v2,1));	      
	my $mod = 1;
	
	if ($key =~ $_[1]) {
	    $vin1 = int(substr($v1,1)) + $slide;
	    if ($vin1 >= 0) {
		if ($value =~ $_[1]) {		    
		    $vin2 = int(substr($v2,1)) + $slide;	      
		    $transit_hash_tmp{substr($v1,0,1).$vin1.":".((split(/:/,$key))[1])}=substr($v2,0,1).$vin2.":".((split(/:/,$value))[1]);	       
		} else {
		    $transit_hash_tmp{substr($v1,0,1).$vin1.":".((split(/:/,$key))[1])}=$value;		    
		}			
	    }	  	 
	} else {	
	    if ($value =~ $_[1]) {
		$vin2 = int(substr($v2,1)) + $slide;	      
		if ($vin2 >= 0) {
		    $transit_hash_tmp{$key}=substr($v2,0,1).$vin2.":".((split(/:/,$value))[1]);				 
		} else {
		    $mod = -1;
		}
	    } else {
		$transit_hash_tmp{$key}=$value;		
	    }	    
	}        
	
	if ($vin2 - $vin1 == 0) {
	    if (substr($v1,0,1) ne substr($v2,0,1)) {
		$result = -1;
	    }
	} elsif ($vin2 - $vin1 < 0) {
	    $result = -1;
	}
    }    

    %transit_hash=%transit_hash_tmp;   
    
    $ss = &__get_ss_from_transitionsMAP(\%transit_hash);    

    if ($silence==0) {
	draw("$ss",$_[3],$_[4],\%transit_hash);        	
	if ($result == -1) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_SLIDE_1."\n";
	}
	print colored [$common::COLOR_RESULT], $ss."\n";
    } else {
	draw("$ss",$_[3],$_[4]." -S 1",\%transit_hash);        
    }

    if ($result == -1) {
	return "-1:".lc($ss);
    } 
    else {
	return lc($ss);
    }
}


sub inv
{
    # $_[0] : SS
    # $_[1] : Image File
    # $_[2] : Options

    my $ss = $_[0];

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $dot_mode=0;   	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $model=0;
    my $hands = "Y";            # Print Hands 
    my $silence = 0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[2]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,
				    "-D:i" => \$dot_mode,		
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);

    my ($beat,  $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss,$dot_mode);
    if ($period == -1) {
	if ($beat <  $PERIOD_MAX) {
	    $period = $PERIOD_MAX;
	} else {
	    $period = $beat + $PERIOD_MAX;
	}
    }
    
    my $new_ss = $ss;
    
    if ($beat !=0 ) {
	my $r = int($period / $beat);
	for (my $i=0; $i < $r; $i++) {
	    $new_ss = $new_ss.$ss;
	}    
    }    
    
    my ($period, $transit_hash_tmp, $ss_hash_tmp, $queue_hand) = &__build_dicts($new_ss, $color_mode, $dot_mode);
    my %transit_hash = %{$transit_hash_tmp};
    my %ss_hash = %{$ss_hash_tmp};    

    my %transit_hash_tmp =();
    while ( my ($key, $value) = each(%transit_hash) ) {		   
	my $v1 = (split(/:/,$value))[0];
	my $v2 = (split(/:/,$key))[0];	
	my $vtm1 = $period -1 +1 - int(substr($v1,1));
	my $vtm2 = $period -1 +1 - int(substr($v2,1));
	my $src=substr($v1,0,1).$vtm1.":".((split(/:/,$value))[1]); 
	my $dst=substr($v2,0,1).$vtm2.":".((split(/:/,$key))[1]);

	if ($vtm1 >= 0 && $vtm2 >= 0) {
	    $transit_hash_tmp{$src} = $dst;
	}
    }
    %transit_hash=%transit_hash_tmp;

    # Keep a view on all the objects on each Beat in the Transition MAP
    # Here we assume that all objects are present. There is no objects hole 
    # my $objects_hash_tmp = &__build_objectsNbBeatsMAP_from_transitionsMAP(\%transit_hash);
    # my %objects_hash = %{$objects_hash_tmp};

    # # Now we can reverse the Multiplex
    # %transit_hash_tmp = ();
    # while ( my ($key, $value) = each(%transit_hash) ) {		   
    # 	my $v1 = (split(/:/,$key))[0];
    # 	my $v2 = (split(/:/,$value))[0];	
    # 	my $src = '';
    # 	my $dst = '';
    
    # 	if(exists $objects_hash{$v1})
    # 	{
    # 	    $src = $v1.":".($objects_hash{$v1} - 1 - (split(/:/,$key))[1]);
    # 	}
    # 	else
    # 	{
    # 	    $src = $key;
    # 	}
    # 	if(exists $objects_hash{$v2})
    # 	{
    # 	    $dst = $v2.":".($objects_hash{$v2} - 1 - (split(/:/,$value))[1]);
    # 	}
    # 	else
    # 	{
    # 	    $dst = $value;
    # 	}

    # 	$transit_hash_tmp{$src} = $dst;
    # }
    # %transit_hash=%transit_hash_tmp;


    $ss = &__get_ss_from_transitionsMAP(\%transit_hash);

    # We do not have the correct SS according to the color mode choosen but we will have the correct diagramm
    if ($silence == 0) {
	draw("$ss",$_[1],$_[2],\%transit_hash);        
	print colored [$common::COLOR_RESULT], $ss."\n";
    } else {
	draw("$ss",$_[1],$_[2]." -S 1",\%transit_hash);        
    }

    return lc($ss);
}



sub __toMultiSync_reduced
{
    # Reduced MultiSync notation
    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;
    my $res = '';

    # First do Operations for Synchronous SS      
    my $ss_tmp = "";
    my $ss_b = "L";
    my $ss_b_map = "";
    my $i = 0; 
    my $mult = -1;

    while ($i < length($ss)) {
	# Go through the whole sync throw
	if (substr($ss,$i,1) eq "(") {
	    my $j=$i;
	    $i++;	    
	    my $ss_v1='';
	    my $ss_v2='';
	    
	    if ($ss_b eq "L") { $ss_b = "R";}
	    else {$ss_b = "L";}

	    while (substr($ss,$i,1) ne "," && $i < length($ss)) {	
		$ss_v1 = $ss_v1.substr($ss,$i,1);
		if(substr($ss,$i,1) ne "X" && substr($ss,$i,1) ne "," && substr($ss,$i,1) ne "!" && substr($ss,$i,1) ne "[")
		{
		    $ss_b_map = $ss_b_map.$ss_b." ";
		}
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }

	    $i++;
	    if ($ss_b eq "L") { $ss_b = "R";}
	    else {$ss_b = "L";}

	    while (substr($ss,$i,1) ne ")" && $i < length($ss)) {		
		$ss_v2 = $ss_v2.substr($ss,$i,1);
		if(substr($ss,$i,1) ne "X" && substr($ss,$i,1) ne "," && substr($ss,$i,1) ne "!" && substr($ss,$i,1) ne "]")
		{
		    $ss_b_map = $ss_b_map.$ss_b." ";
		}
		
		$i ++;
	    }
	    if ($i == length($ss)) {
		return -1;
	    }
	    $i++;
	    $ss_tmp = $ss_tmp.$ss_v1."!".$ss_v2."*0";
	}
	
	else {
	    if (substr($ss,$i,1) eq "[") {
		$mult=1;
		if ($ss_b eq "L") { $ss_b = "R";}
		else {$ss_b = "L";}
	    } elsif (substr($ss,$i,1) eq "]") {
		$mult=-1;				    
	    } elsif (substr($ss,$i,1) eq "*") {
		if ($ss_b eq "L") {
		    $ss_b = "R";		 
		} else {
		    $ss_b = "L";
		}			
	    } else {
		if ($mult==1) {				    
		    $ss_b_map = $ss_b_map.$ss_b." ";		    
		} else {
		    if ($ss_b eq "L") {
			$ss_b = "R";
			$ss_b_map = $ss_b_map."R ";
		    } else {
			$ss_b = "L";
			$ss_b_map = $ss_b_map."L ";
		    }
		}
	    }
	    
	    $ss_tmp = $ss_tmp.substr($ss,$i,1);	    	    
	    $i++;
	}	
    }
    
    $ss=$ss_tmp;

    # Then do Operations for Multiplexes SS
    my $mult = -1;
    my $idx = 0;
    for (my $i = 0; $i < length($ss); $i++) {
	my $val = substr($ss,$i,1);
	if ($i+1 <length($ss) && uc(substr($ss,$i+1,1)) eq "X") {
	    $val = $val."X";
	    $i++;
	}
	if ($val eq "[") {
	    $mult = 1;	
	    $idx = 0;
	} elsif ($val eq "]") {
	    $mult = -1;
	} elsif ($mult == 1) {
	    if ($idx == 0) {
		$res = $res.$val;
	    } else {
		$res = $res."!*".$val;
	    }
	    $idx ++;
	} else {
	    $res = $res.$val;
	}
    }

    return $res;
}

sub __toMultiSync_classical
{   # As classical as possible 

    #$_[0] : Siteswap
    my $ss = uc($_[0]);	
    $ss =~ s/\s+//g;
    my $res = '';
    my $end = "";
    
    # Remove eventual 0 after a Sync throw
    my ($beat, $src_left_tmp, $src_right_tmp, $queue_hand) = &__build_lists($ss,0); 
    my @src_left = @{$src_left_tmp};
    my @src_right = @{$src_right_tmp};

    # To handle ! after Multisync since it reduces the period 
    if(($src_left[$beat] ne "0" && $src_left[$beat] ne "") || ($src_right[$beat] ne "0" && $src_right[$beat] ne ""))
    {
	$beat ++;	
	$end = "!";
    }

    my $side ="R";
    my $sync = -1;

    for (my $i=0; $i < $beat; $i++)
    {	    
	my $vt = uc($src_left[$i]);
	$vt =~ s/X//g;
	if(length($vt) > 1)
	{
	    $src_left[$i] = "[".$src_left[$i]."]";
	}
	$vt = uc($src_right[$i]);
	$vt =~ s/X//g;
	if(length($vt) > 1)
	{
	    $src_right[$i] = "[".$src_right[$i]."]";
	}
    }

    for (my $i=0; $i <$beat; $i++)
    {	    
	if($side eq "R")
	{		   
	    if($sync == 1)
	    {		
		if(($src_right[$i] eq "" || $src_right[$i] eq "0") && ($src_left[$i] eq "" || $src_left[$i] eq "0")) 		       	     		       	      
		{
		    # Nothing to do. It is an hold time
		    $sync = -1;
		}
		
		else
		{
		    $res = $res."!";
		}
		$sync = -1;		    
		
		if($src_right[$i] ne "" && $src_left[$i] ne "")
		{
		    $res = $res."(".$src_right[$i].",".$src_left[$i].")";
		    $side = "R";
		    $sync = 1;
		}

		elsif($src_right[$i] ne "")
		{
		    $res = $res.$src_right[$i];
		    $side = "L";
		    $sync = -1;
		}
		elsif($src_left[$i] ne "" )
		{
		    $res = $res."*".$src_left[$i];
		    $side = "R";
		    $sync = -1;		    
		}
	    }
	    else 
	    { 
                # Not Synchronous before
		if($src_right[$i] ne "" && $src_left[$i] ne "")
		{
		    $res = $res."(".$src_right[$i].",".$src_left[$i].")";
		    $side = "R";
		    $sync = 1;
		}
		
		elsif($src_right[$i] ne "")
		{
		    $res = $res.$src_right[$i];
		    $side = "L";
		    $sync = -1;
		}
		elsif($src_left[$i] ne "")
		{			  
		    $res = $res."*".$src_left[$i];
		    $side = "R";
		    $sync = -1;		    
		}
	    }
	    
	}
	
	else
	{		
	    if($sync == 1)
	    {	
		if(($src_right[$i] eq "" || $src_right[$i] eq "0") && ($src_left[$i] eq "" || $src_left[$i] eq "0")) 
		{
		    # Nothing to do. It is an hold time
		    $sync = -1;
		}
		else
		{
		    $res = $res."!";
		}
		
		if($src_right[$i] ne "" && $src_left[$i] ne "")
		{
		    $res = $res."(".$src_left[$i].",".$src_right[$i].")";
		    $side = "L";
		    $sync = 1;
		}

		elsif($src_right[$i] ne "")
		{
		    $res = $res."*".$src_right[$i];
		    $side = "L";
		    $sync = -1;
		}
		elsif($src_left[$i] ne "") 
		{
		    $res = $res.$src_left[$i];
		    $side = "R";
		    $sync = -1;
		}
	    }
	    
	    else
	    {
		if($src_right[$i] ne ""  && $src_left[$i] ne "")
		{
		    $res = $res."(".$src_left[$i].",".$src_right[$i].")";
		    $side = "L";
		    $sync = 1;
		}
		elsif($src_right[$i] ne "")
		{
		    $res = $res."*".$src_right[$i];
		    $side = "L";
		    $sync = -1;
		}
		elsif($src_left[$i] ne "" )
		{
		    $res = $res.$src_left[$i];
		    $side = "R";
		    $sync = -1;
		}
	    }
	}	       	    
	
	if($src_right[$i] ne "" && $src_left[$i] ne "")
	{
	    $sync = 1;
	}
    }
    
    # Handle the Queue
    if($sync == 1)
    {
	$res=$res."!";	
    }

    if($queue_hand eq $side)
    {
	return $res.$end;
    }
    else
    {
	return $res."*".$end;
    }
}


sub __toMultiSync_extended_async
{
    # Full extended MultiSync notation in Async Format
    my $ss = &toMultiSync(&SSWAP::expandSync($_[0],-1),0,"-1");    
    $ss =~ s/\s+//g;
    my $res = '';
    my @resd = ();
    my @resg = ();
    my $cur="R";
    my $beat=0;

    for (my $i=0; $i < length($ss); $i++) 
    {
	$resd[$i] = "";
	$resg[$i] = "";
    }

    for (my $i=0; $i < length($ss); $i++) 
    {
	my $v = substr($ss,$i,1);	
	if($v eq "*")
	{
	    if($cur eq "R")
	    {		    
		$cur = "L";
	    }
	    else
	    {
		$cur = "R";
	    }		    		
	}
	elsif($v eq "!" && $i != length($ss) -1)
	{
	    $beat --;
	}
	else
	{
	    if($cur eq "R")
	    {
		if(uc(substr($ss,$i+1,1)) ne "X")
		{
		    if($resd[$beat] ne "")
		    {
			$resd[$beat] = $resd[$beat]."!*".$v;
		    }
		    else
		    {
			$resd[$beat] = $v;
		    }
		}
		else
		{
		    if($resd[$beat] ne "")
		    {
			$resd[$beat] = $resd[$beat]."!*".$v."X";
		    }
		    else
		    {
			$resd[$beat] = $v."X";
		    }
		    $i++;
		}
		$beat ++;
		$cur = "L";
	    }
	    else
	    {
		if(uc(substr($ss,$i+1,1)) ne "X")
		{
		    if($resg[$beat] ne "")
		    {
			$resg[$beat] = $resg[$beat]."!*".$v;
		    }
		    else
		    {
			$resg[$beat] = $v;
		    }
		}
		else
		{
		    if($resg[$beat] ne "")
		    {
			$resg[$beat] = $resg[$beat]."!*".$v."X";
		    }
		    else
		    {
			$resg[$beat] = $v."X";
		    }				    
		    $i++;
		}
		$beat ++;
		$cur = "R";
	    }	    	    
	}
    }
    
    for (my $i=0; $i < $beat; $i++)
    {	
	$resd[$i] =~ s/00/0/g;
	$resg[$i] =~ s/00/0/g;
	
	if($resd[$i] eq "")
	{
	    $resd[$i]="0";
	}
	if($resg[$i] eq "")
	{	
	    $resg[$i]="0";
	}
	
	$res=$res.$resd[$i]."!".$resg[$i]; 	
    }

    my $queue = "*";

    # Handle eventual queue 
    if($cur ne "R")
    {
	$res=$res."*";
    }

    return $res;
}


sub __toMultiSync_extended_sync
{
    # Full extended MultiSync notation in Sync Format
    my $ss=$_[0];
    $ss =~ s/\s+//g;
    my $res = '';

    my ($beat, $res_left_tmp, $res_right_tmp, $queue_hand) = &__build_lists($ss,1);	
    my @res_left = @{$res_left_tmp};
    my @res_right = @{$res_right_tmp};

    for(my $i=0;$i<$beat;$i++)
    {
	my $v_r = $res_right[$i];
	if($v_r eq '')
	{
	    $v_r = 0;
	}
	elsif(length($v_r) > 2 || (length($v_r) == 2 &&  uc(substr($v_r,1,1)) ne 'X'))
	{
	    $v_r = '['.$v_r.']';
	}
	
	my $v_l = $res_left[$i];
	if($v_l eq '')
	{
	    $v_l = 0;
	}
	elsif(length($v_l) > 2 || (length($v_l) == 2 &&  uc(substr($v_l,1,1)) ne 'X'))
	{
	    $v_l = '['.$v_l.']';
	}
	
	$res .= '('.$v_r.','.$v_l.')!';
    }

    if($beat % 2 != 0 && substr($ss,0,1) ne '*' && $queue_hand ne "R")
    {
	$res .= '*';
    }

    return $res;
}



sub toMultiSync
{
    # $_[0] : Siteswap
    # $_[1] : output type : 0 : Reduced MultiSync format; 1 : Siteswap as classical as possible; 2 : Full Extended MultiSync; 
    # $_[2] : optional: a file to draw the result in
    # $_[3] : optional: Options 

    my $fileOutputType;
    my $period=-1;
    my $color_mode=2;
    my $label_pos;
    my $title = "Y";
    my $nullSS = "N";
    my $dot_mode=0;   	# if 0 : Remove 0 after sync throw (Default). Otherwise keep it as generated after a Multisync transformation 
    my $model=0;
    my $hands = "Y";            # Print Hands 
    my $silence = 0;
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $graphviz_output="N";

    my $ret = &GetOptionsFromString(uc($_[3]),    
				    "-O:s" => \$fileOutputType,
				    "-P:i" => \$period,
				    "-C:i" => \$color_mode,
				    "-D:i" => \$dot_mode,		
				    "-L:s" => \$label_pos,
				    "-T:s" => \$title,
				    "-N:s" => \$nullSS,
				    "-M:i" => \$model,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hands,
				    "-S:i" => \$silence,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
	);


    my $ss = uc($_[0]);
    $ss =~ s/\s+//g;
    my $res = '';

    # Reduced Multisync Format 
    if(scalar @_ <= 1 || ($_[1] ne "1" && $_[1] ne "2" && $_[1] ne "3"))
    {
	$res = &__toMultiSync_reduced($ss); 
	##########################
	# A few simplifications for Reduced Multisync ss
	##########################
	# Change *0* by 0	
	$res =~ s/\*0\*/0/g;
	# Change 0!0* by 0	
	$res =~ s/0!0\*/0/g;
	# Change !00* by 0	
	$res =~ s/!00\*/0/g;
	# Change !0*0 by 0	
	$res =~ s/!0\*0/0/g;
	# Change *00! by 0	
	$res =~ s/\*00!/0/g;
	# Change *0!0 by 0	
	$res =~ s/\*0!0/0/g;
	# Change 0** by 0	
	$res =~ s/0\*\*/0/g;

	# remove *0!  	
	$res =~ s/\*0!//g;
	# remove 0*!  	
	$res =~ s/0\*!//g;
	# remove 0!*  	
	$res =~ s/0!\*//g;
	# remove !*0  	
	$res =~ s/!\*0//g;
	# remove *!0  	
	$res =~ s/\*!0//g;
	# remove !0*  	
	$res =~ s/!0\*//g;
	# remove !00!  	
	$res =~ s/!00!//g;
	# remove 0!0!  	
	$res =~ s/0!0!//g;
	# Remove all "**"
	$res =~ s/\*\*//g;

	# change !0 by *
	$res =~ s/!0/\*/g;
	# change 0! by *
	$res =~ s/0!/\*/g;
    }    
    elsif (scalar @_ >= 2 && $_[1] eq "1")
    {
	# As classical as possible        	
	$res=&__toMultiSync_classical($ss,-1);	

	##########################
	# A few simplifications for classical ss
	##########################	
	# After Sync remove !*0 (or !0*) since it is already in the Sync behaviour	
	#$res =~ s/\)!\*0/\)/g;
	#$res =~ s/\)!0\*/\)/g;
	# Change !0 by *
	#$res =~ s/\)!0/\)\*/g;

	# Change *0* by 0	
	$res =~ s/\*0\*/0/g;
	# Change 0!0* by 0	
	$res =~ s/0!0\*/0/g;
	# Change !00* by 0	
	$res =~ s/!00\*/0/g;
	# Change !0*0 by 0	
	$res =~ s/!0\*0/0/g;
	# Change *00! by 0	
	$res =~ s/\*00!/0/g;
	# Change *0!0 by 0	
	$res =~ s/\*0!0/0/g;
	# Change 0** by 0	
	$res =~ s/0\*\*/0/g;

	# remove *0!  	
	$res =~ s/\*0!//g;
	# remove 0*!  	
	$res =~ s/0\*!//g;
	# remove 0!*  	
	$res =~ s/0!\*//g;
	# remove !*0  	
	$res =~ s/!\*0//g;
	# remove *!0  	
	$res =~ s/\*!0//g;
	# remove !0*  	
	$res =~ s/!0\*//g;
	# remove !00!  	
	$res =~ s/!00!//g;
	# remove 0!0!  	
	$res =~ s/0!0!//g;
	# Remove all "**"
	$res =~ s/\*\*//g;
    }
    elsif (scalar @_ >= 2 && $_[1] eq "2")
    {
	# Full Multisync Extended        	
	$res=&__toMultiSync_extended_async($ss,-1);	
    }
    elsif (scalar @_ >= 2 && $_[1] eq "3")
    {
	# Full Multisync Extended        	
	$res=&__toMultiSync_extended_sync(SSWAP::expandSync($ss,-1),-1);	
    }


    if (scalar @_ >= 3 && $_[2] ne "-1") {
	# Keep all the 0 for Full Multisync but remove after Sync throw for Classical SS
	if($_[1] == 0)
	{
	    if(scalar @_ >= 4)
	    {
		&draw($res,$_[2],"-D 1 ".$_[3]);
	    }
	    else
	    {
		&draw($res,$_[2],"-D 1");	
	    }
	}
	else
	{
	    if(scalar @_ >= 4)
	    {
		&draw($res,$_[2],"-D 0 ".$_[3]);
	    }
	    else
	    {
		&draw($res,$_[2],"-D 0");	
	    }
	}
    }

    if ($silence == 0 && (scalar @_ < 3 || $_[2] ne "-1")) {	
	print colored [$common::COLOR_RESULT], lc($res)."\n";
	
    }
    
    return lc($res);        
}





######################################################################
#
#                              TESTS
#
######################################################################


#################################################
#  Tests functions to generate drawing on jonglage.net List and HTML Results Generation
#################################################
sub __test_jonglage_net_list
{
    # Params : -1 for all tests (with an HTML index for results
    #          -2 identical with -1 but add some more tests for multisync
    
    my $f="test_jonglage_net_list_ladder.html";
    my $pics="pics_png.png";
    my $cpt = 0;
    if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
	&common::gen_HTML_head1($f,"Ladder Notation : Exemples");
	open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
	
	print HTML "\n";
	if(uc($LINK_GUNSWAP) eq 'Y')
	{
	    print HTML "<script type=\"text/javascript\" src=\"/js/visualisation_siteswap.js\"></script>\n\n";
	}
	print HTML "<BODY>\n";
	print HTML "<p>&nbsp;</p><p>&nbsp;</p><h1>Ladder Notation : Exemples</h1><p>&nbsp;</p>\n";
	print HTML "Vous trouverez ci-dessous de nombreux exemples de diagrammes en échelle:\n";
	print HTML "<ul>\n";
	print HTML "<li>la figure initiale;</li>\n";
	print HTML "<li>Sa Symétrie;</li>\n";
	print HTML "<li>Son diagramme Time Reversed;</li>\n";
	print HTML "<li>Son Diagramme après décalage de la main droite d'1 cran vers la droite, de 2 crans vers la droite, d'1 cran vers la gauche et de 2 crans vers la gauche lorsque ceux-ci sont possibles;</li>\n";
	print HTML "<li>Son Diagramme après décalage de la main gauche d'1 cran vers la droite, de 2 crans vers la droite, d'1 cran vers la gauche et de 2 crans vers la gauche lorsque ceux-ci sont possibles;</li>\n";
	print HTML "<li>le diagramme associé à sa notation correspondante de type MultiSynchrone (ou Mixte).</li>\n";
	print HTML "</ul>\n";
	print HTML "\n\n\n";
	print HTML "<p>&nbsp;</p>"."\n";
	print HTML "<p><table border=\"0\" >"."\n";
	print HTML "<tr><td COLSPAN=2></td>"."\n";	    	    
	print HTML "<td class=table_header>"."Diagramme"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Symétrie"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."Inversé"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."D+1"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."D+2"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."D-1"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."D-2"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."G+1"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."G+2"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."G-1"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."G-2"."</td>"."\n";	    	    
	if($_[0] eq "-2")
	{
	    print HTML "<td class=table_header COLSPAN=5>"."MultiSync 0 [direct,0,1,2]."."</td>"."\n";
	    print HTML "<td class=table_header COLSPAN=4>"."MultiSync 1 [direct,0,1,2]."."</td>"."\n";
	    print HTML "<td class=table_header COLSPAN=4>"."MultiSync 2 [direct,0,1,2]."."</td>"."\n";
	}
	else
	{
	    print HTML "<td class=table_header COLSPAN=2>"."MultiSync."."</td>"."\n";
	}
	print HTML "</tr>"."\n";

	use File::Copy;
	copy("./data/pics/".$pics,$conf::RESULTS."/".$pics);	  

    }
    
    my @ss_list = @common::SS_list_jonglage_net;
    if(scalar @_ == 1 && ($_[0] eq "-2" || $_[0] eq "-1"))
    {
	push (@ss_list, @common::SS_experimental);
    }
    
    @ss_list=sort(@ss_list);

    my $nb=0;
    foreach my $ss (@ss_list) {
	$nb++;
	my $nss = lc($ss);

	$nss =~ s/\s+//g;	
	$nss =~ s/\*/+/g;

	if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
	    print HTML "<tr>"."\n";	    	    
	    print HTML "<td class=table_header>$nb</td>"."\n";
	    if(uc($LINK_GUNSWAP) eq 'Y')
	    {
		print HTML "<td class=table_header><strong><a href=\"javascript:visualiserSiteswap('$ss')\">$ss</a></strong></td>"."\n";
	    }
	    elsif(uc($LINK_JUGGLINGLAB_GIF) eq 'Y')
	    {
		
		print HTML "<td class=table_header><strong><a href=\"https://jugglinglab.org/anim?pattern=$ss;colors=mixed\" target=\"_blank\">$ss</a></strong></td>"."\n";
	    }		      
	    else
	    {
		print HTML "<td class=table_header><strong>$ss</strong></td>"."\n";
	    }
	}
	print "\n\n\n";
	print colored [$common::COLOR_RESULT], "==== Diagram : ".$ss."\n";
	&draw($ss, $nss.".png","-E=E");	    		   
	$cpt++;
	if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {			
	    print HTML "<td class=table_content><a href=\"".$nss.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss.".png\" width=\"25\"/></a></td>"."\n";
	}

	if (scalar @_ == 1 && ($_[0] == 1 || $_[0] eq "-1" || $_[0] eq "-2")) {
	    print colored [$common::COLOR_RESULT], "==== Symetric : ";
	    &sym($ss, $nss."-sym.png","-E=E");
	    $cpt++;
	    print "\n";
	    if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
		print HTML "<td class=table_content><a href=\"".$nss."-sym.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-sym.png\" width=\"25\"/></a></td>"."\n";		
	    }
	}


	if (scalar @_ == 1 && ($_[0] == 2 || $_[0] eq "-1" || $_[0] eq "-2")) {	    
	    print colored [$common::COLOR_RESULT], "==== Inverse : ";
	    &inv($ss, $nss."-inv.png","-E=E");
	    $cpt++;
	    print "\n";
	    if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
		print HTML "<td class=table_content><a href=\"".$nss."-inv.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-inv.png\" width=\"25\"/></a></td>"."\n";
	    }
	}

	if (scalar @_ == 1 && ($_[0] == 3 || $_[0] eq "-1"  || $_[0] eq "-2")) {
	    print colored [$common::COLOR_RESULT], "==== Slide R+1 : ";
	    my $res1=&slide($ss, "R", 1, $nss."-slideR+1.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide R+2 : ";
	    my $res2=&slide($ss, "R", 2, $nss."-slideR+2.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide R-1 : ";
	    my $res3=&slide($ss, "R", -1, $nss."-slideR-1.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide R-2 : ";
	    my $res4=&slide($ss, "R", -2, $nss."-slideR-2.png","-n n -E=E");
	    print "\n";
	    
	    if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {

		if ($res1 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideR+1.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideR+1.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideR+1.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res2 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideR+2.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideR+2.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideR+2.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res3 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideR-1.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideR-1.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideR-1.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res4 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideR-2.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideR-2.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideR-2.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
	    }
	}
	
	if (scalar @_ == 1 && ($_[0] == 4 || $_[0] eq "-1" || $_[0] eq "-2")) {
	    print colored [$common::COLOR_RESULT], "==== Slide L+1 : ";
	    my $res1=&slide($ss, "L", 1, $nss."-slideL+1.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide L+2 : ";
	    my $res2=&slide($ss, "L", 2, $nss."-slideL+2.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide L-1 : ";
	    my $res3=&slide($ss, "L", -1, $nss."-slideL-1.png","-n n -E=E");
	    print "\n";
	    print colored [$common::COLOR_RESULT], "==== Slide L-2 : ";
	    my $res4=&slide($ss, "L", -2, $nss."-slideL-2.png","-n n -E=E");
	    print "\n";
	    
	    if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {

		if ($res1 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideL+1.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideL+1.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideL+1.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res2 !~ /-1:/) {		    
		    print HTML "<td class=table_content><a href=\"".$nss."-slideL+2.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideL+2.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideL+2.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res3 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideL-1.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideL-1.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideL-1.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
		if ($res4 !~ /-1:/) {
		    print HTML "<td class=table_content><a href=\"".$nss."-slideL-2.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-slideL-2.png\" width=\"25\"/></a></td>"."\n";
		    $cpt++;
		} else {
		    if ($LADDER_DEBUG <= 0) {
			unlink $conf::RESULTS."/".$nss."-slideL-2.png";
		    }
		    print HTML "<td class=table_content>&nbsp;</td>"."\n";
		}
	    }
	}

	if (scalar @_ == 1 && ($_[0] == 5 || $_[0] eq "-1" || $_[0] eq "-2")) {	   
	    print HTML "<td class=table_content><a href=\"".$nss."-multisync.png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$nss."-multisync.png\" width=\"25\"/></a></td>"."\n";
	    print colored [$common::COLOR_RESULT], "==== MultiSync : ";
	    my $v1=&toMultiSync($ss, 0, $nss."-multisync.png");
	    $cpt++;
	    print "\n";
	    if(&SSWAP::isEquivalent($v1,$ss,"",-1)==1)
	    { print HTML "<td class=table_content>".$v1."</td>\n";}
	    else { print HTML "<td class=table_content> <font color=\"red\">".$v1."</font></td>\n";}

	    if( $_[0] eq "-2" )
	    {
		my $v2 = &toMultiSync(&toMultiSync($ss, 0,-1), 0,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}
		
		$v2 = &toMultiSync(&toMultiSync($ss, 1,-1), 0,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v2 = &toMultiSync(&toMultiSync($ss, 2,-1), 0,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}
		
		$v1 = $ss;
		$v2 = &toMultiSync($ss, 1,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}
		
		$v2 = &toMultiSync(&toMultiSync($ss, 0,-1), 1,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v2 = &toMultiSync(&toMultiSync($ss, 1,-1), 1,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v2 = &toMultiSync(&toMultiSync($ss, 2,-1), 1,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v1 = $ss;
		$v2 = &toMultiSync($ss, 2,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}
		
		$v2 = &toMultiSync(&toMultiSync($ss, 0,-1), 2,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v2 = &toMultiSync(&toMultiSync($ss, 1,-1), 2,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}

		$v2 = &toMultiSync(&toMultiSync($ss, 2,-1), 2,-1);
		if(&SSWAP::isEquivalent($v1,$v2,"",-1)==1)
		{ print HTML "<td class=table_content>".$v2."</td>\n";}
		else { print HTML "<td class=table_content> <font color=\"red\">".$v2."</font></td>\n";}
	    }
	}

	
	if (scalar @_ == 1 &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
	    print HTML "</tr>"."\n";	    	    
	}		
    }

    if (scalar @_ == 1  &&  ($_[0] eq "-1" || $_[0] eq "-2")) {
	print HTML "</table></p>"."\n";
	print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module LADDER $LADDER_VERSION --</p><p>&nbsp;</p>\n";
	print HTML "</BODY>\n";
	close HTML;
    }

    print colored [$common::COLOR_RESULT], "\n\n====> ".$cpt." Files Generated\n ";

}


#################################################
#  Test functions for MultiSync generation 
#################################################
sub __test_toMultiSync()
{
    my @list_ss=(
	"ABC",
	"A(B,C)(D,E)",
	"A(B,C)D",
	"AB(C,D)E",
	"ABC(D,E)F",
	"(A,B)C(D,E)F",
	"*AB",
	"*(A,B)C",
	"(A,B)*C",
	"(A,B)*",
	"A*",
	"*(A,B)(C,D)E",
	"(A,B)*(C,D)E",
	"(A,B)(C,D)*E",
	"(A,B)(C,D)E*",
	"[AB]D",
	"A[BC]D",
	"[AB](C,D)[EFGH]",
	"([ABC],[DEF])[GH]IJ",
	"([ABC],[DEF])*[GH]*IJ",
	"(A,B)*0*C",
	"(A,B)*0*(C,D)",
	"AB*0*C",
	);
    
    my $i =0;
    foreach my $ss (@list_ss) {
	$i++;
	my $nss = "test".$i;
	print "==> $ss : ".&toMultiSync($ss, 0,-1)." | ".&toMultiSync(&toMultiSync($ss, 0,-1), 0,-1)." | ".&toMultiSync(&toMultiSync($ss, 1,-1), 0,-1)." | ".&toMultiSync($ss, 1,-1)." | ".&toMultiSync(&toMultiSync($ss, 0,-1), 1,-1)." | ".&toMultiSync(&toMultiSync($ss, 1,-1), 1,-1)."\n";
	print "\n";
    }
}


#################################################
#  Generic Test functions for drawing 
#################################################
sub __test
{
    my @ss_list_v = (
	"[543]",
	"4*26",
	"(6,4)*",
	"(6x,4)*",
	"(4,6x)*",
	"5354x1x(4,4)(4x,5)(4x,5)*5354x54x0(4,4)(5,4x)(5,4x)535354x1x*(4,4)(4x,5)(1x,5)!353",
	"24[45]",
	"24[54]",
	"51x*",
	"6x0*",
	"(6x,0)*",
	"4!40",
	"5!*4!*3",
	"(1x,3)!11x*",
	"(4,4)!"
	);

    # Do test(-1) for all tests

    my $i = 0;
    foreach my $ss (@ss_list_v) {
	$i++;
	my $nss = "test".$i;

	if (scalar @_ == 0 ||  $_[0] eq "0" || $_[0] eq "-1") {	    
	    &draw($ss, $nss.".png");	    
	    print "\n";
	}
	
	if (scalar @_ == 1 && ($_[0] == 1 || $_[0] eq "-1")) {
	    &sym($ss, $nss."-sym.png");    
	    print "\n";
	}
	
	if (scalar @_ == 1 && ($_[0] == 2 || $_[0] eq "-1")) {
	    &inv($ss, $nss."-inv.png");
	    print "\n";
	}
	if (scalar @_ == 1 && ($_[0] == 3 || $_[0] eq "-1")) {
	    &slide($ss, "R", 1, $nss."-slideR+1.png","-n n");
	    print "\n";
	    &slide($ss, "R", 2, $nss."-slideR+2.png","-n n");
	    print "\n";
	    &slide($ss, "R", -1, $nss."-slideR-1.png","-n n");
	    print "\n";
	    &slide($ss, "R", -2, $nss."-slideR-2.png","-n n");	
	    print "\n";
	}
	if (scalar @_ == 1 && ($_[0] == 4 || $_[0] eq "-1")) {
	    &slide($ss, "L", 1, $nss."-slideL+1.png","-n n");
	    print "\n";
	    &slide($ss, "L", 2, $nss."-slideL+2.png","-n n");
	    print "\n";
	    &slide($ss, "L", -1, $nss."-slideL-1.png","-n n");
	    print "\n";
	    &slide($ss, "L", -2, $nss."-slideL-2.png","-n n");	
	    print "\n";
	}
	if (scalar @_ == 1 && ($_[0] == 5 || $_[0] eq "-1")) {
	    &toMultiSync($ss, 0, $nss."-multisync.png");
	    print "\n";
	}	
    }

    if (scalar @_ == 1 && ($_[0] == 6 || $_[0] eq "-1")) {
	my %hash = (
	    'L2:0' => 'R4:0',
	    'R2:0' => 'R4:1',
	    'L4:0' => 'R6:0',
	    'R4:0' => 'R5:0',
	    'R4:1' => 'L6:0',
	    'R6:0' => 'R6:0'
	    );	
	
	&draw("Test","test-draw-hash.png","-n y",\%hash);
    }
    
    if (scalar @_ == 1 && ($_[0] == 7 || $_[0] eq "-1")) 
    {
	my @ss_list_tmp = (
	    "(4x,2)*",
	    "4x!20",
	    "(4,2)(2x,4x)",
	    "4!2*02X!4X*0",
	    "(4,2)(4x,2)*",
	    "4!20*4x!20",
	    );
	
	# Set Debug Mode to ON
	my $deb = $LADDER::LADDER_DEBUG;
	$LADDER::LADDER_DEBUG = 1;
	
	foreach my $ss (@ss_list_tmp) {		
	    my $nss = lc($ss);
	    $nss =~ s/\s+//g;	
	    $nss =~ s/\*/+/g;
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    print "\t\t __build_list::($ss);\n\t\t \n";
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    &__build_lists($ss);
	}

	foreach my $ss (@ss_list_tmp) {
	    my $nss = lc($ss);
	    $nss =~ s/\s+//g;	
	    $nss =~ s/\*/+/g;
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    print "\t\t toMultiSync::($ss,0);\n\t\t \n";
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    &toMultiSync($ss,0);
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    print "\t\t toMultiSync::($ss,1);\n\t\t \n";
	    print "----------------------------------------------------------------------------------------------------------------\n";
	    &toMultiSync($ss,1);
	}

	# Set Original Debug Mode
	$LADDER::LADDER_DEBUG = $deb;
    }	
    
    
    if (scalar @_ == 1 && ($_[0] == 8 || $_[0] eq "-1")) 
    {
	&LADDER::merge("66120","42022","test.png");
    }

    
    if (scalar @_ == 1 && ($_[0] == 9 || $_[0] eq "-1")) {
	my %hash = (
	    'L1:0' => '5',
	    'L3:0' => '9',
	    'L5:0' => '0',
	    'L7:0' => '2',
	    'R0:0' => '7',
	    'R2:0' => '6',
	    'R4:0' => '7',
	    'R6:0' => '7',
	    'R8:0' => '2',
	    );	
	
	print &__get_ss_from_ssMAP(\%hash);
    }

}	



1;
