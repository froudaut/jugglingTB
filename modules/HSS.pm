#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## HSS.pm   - Hand Siteswap Notation for jugglingTB                         ##
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

package HSS;
use common;
use strict;
use lang;
use Term::ANSIColor;        
use modules::SSWAP;
use modules::LADDER;    
use modules::MHN;    
use Getopt::Long qw(GetOptionsFromString);
use List::Util 'first';

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $HSS_INFO = "OSS/HSS juggling Notation";
our $HSS_HELP = $lang::MSG_HSS_MENU_HELP;
our $HSS_VERSION = "v0.3";

our %HSS_CMDS = 
    (
     'basicMap'           => ["$lang::MSG_HSS_MENU_BASICMAP_1","$lang::MSG_HSS_MENU_BASICMAP_2"],
     'changeHSS'          => ["$lang::MSG_HSS_MENU_CHANGEHSS_1","$lang::MSG_HSS_MENU_CHANGEHSS_2"],
     'getHandsSeq'        => ["$lang::MSG_HSS_MENU_GETHANDSSEQ_1","$lang::MSG_HSS_MENU_GETHANDSSEQ_2"],
     'draw'               => ["$lang::MSG_HSS_MENU_DRAW_1","$lang::MSG_HSS_MENU_DRAW_2"],
     'isValid'            => ["$lang::MSG_HSS_MENU_ISVALID_1","$lang::MSG_HSS_MENU_ISVALID_2"],
     'toMHN'              => ["$lang::MSG_HSS_MENU_TOMHN_1","$lang::MSG_HSS_MENU_TOMHN_2"],
     'toSS'               => ["$lang::MSG_HSS_MENU_TOSS_1","$lang::MSG_HSS_MENU_TOSS_2"],
    );

print "HSS $HSS::HSS_VERSION loaded\n";

# To add debug behaviour 
our $HSS_DEBUG=-1;

my $PERIOD_MAX = 25;
my $MAX_MULT = 15;
my $NODESEP = .2;


sub changeHSS
{
    my $ss = $_[0];
    my $hss = $_[1];
    my $nhss = $_[2];
    my $nss = '';

    if(&SSWAP::isValid($ss,-1) <= 0)
    {
	if ((scalar @_ <=  3) || ($_[3] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR1 => $ss\n";
	}
	return -1;
    }

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	if ((scalar @_ <=  3) || ($_[3] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR2 => $hss\n";
	}
	return -1;
    }

    if(&SSWAP::isValid($nhss,-1) <= 0)
    {
	if ((scalar @_ <=  3) || ($_[3] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_CHANGEHSS_ERROR2 => $nhss\n";
	}
	return -1;
    }

    
    my $hand_period = 40;  # Must be multiple of hands and greater than SS period
    my @hss_map = '' x $hand_period;
    my @nhss_map = '' x $hand_period;
    my @ss_map_r = '' x $hand_period;
    my @ss_map_l = '' x $hand_period;
    my $cur_hand = 'R';
    my $cpt_r = 0;
    my $cpt_l = 0;
    
    for(my $i=0; $i<$hand_period;$i++)
    {
	my $th=substr($hss,$i%length($hss),1);
	if($hss_map[$i] eq '')
	{	   
	    if($cur_hand eq 'R')
	    {
		$hss_map[$i] = $cur_hand.$cpt_r;
		$cur_hand = 'L';
	    }
	    else
	    {
		$hss_map[$i] = $cur_hand.$cpt_l;
		$cur_hand = 'R';
	    }	    
	}

	if(($hss_map[($i+int($th))%$hand_period]) eq '')
	{
	    if(substr($hss_map[$i],0,1) eq 'R')
	    {
		$cpt_r++;
		$hss_map[($i+int($th))%$hand_period] = substr($hss_map[$i],0,1).$cpt_r;
	    }
	    else
	    {
		$cpt_l++;
		$hss_map[($i+int($th))%$hand_period] = substr($hss_map[$i],0,1).$cpt_l;
	    }
	}		    
    }

    if ((scalar @_ <=  3) || ($_[3] ne "-1")) 
    {
	print "=== HSS MAP ===\n";
	for(my $i=0; $i < scalar(@hss_map);$i ++)
	{
	    print $hss_map[$i]." ";
	}
	print "\n\n";
    }
    
    $cpt_r = 0;
    $cpt_l = 0;
    for(my $i = 0; $i < $hand_period; $i++)
    {
	my $val=int(substr($ss,$i%length($ss),1));
	if(substr($hss_map[$i],0,1) eq 'R')
	{	    
	    $ss_map_r[$cpt_r] = $hss_map[($i+$val)%$hand_period];
	    $cpt_r++;
	}
	else
	{	    
	    $ss_map_l[$cpt_l] = $hss_map[($i+$val)%$hand_period];
	    $cpt_l++;
	}
	
    }

    if ((scalar @_ <=  3) || ($_[3] ne "-1")) 
    {
	print "=== OSS MAP (Right) ===\n";
	for(my $i = 0; $i < $hand_period; $i++)
	{
	    if ($ss_map_r[$i] eq '')
	    {
		print " _ ";
	    }
	    else
	    {
		print $ss_map_r[$i]." ";
	    }
	}
	print "\n\n";

	
	print "=== OSS MAP (Left) ===\n";
	for(my $i = 0; $i < $hand_period; $i++)
	{
	    if ($ss_map_l[$i] eq '')
	    {
		print " _ ";
	    }
	    else
	    {
		print $ss_map_l[$i]." ";
	    }
	}
	print "\n\n";
    }

    $cur_hand = 'R';
    $cpt_r = 0;
    $cpt_l = 0;
    for(my $i=0; $i<$hand_period;$i++)
    {
	my $th=substr($nhss,$i%length($nhss),1);
	if($nhss_map[$i] eq '')
	{	   
	    if($cur_hand eq 'R')
	    {
		$nhss_map[$i] = $cur_hand.$cpt_r;
		$cur_hand = 'L';
	    }
	    else
	    {
		$nhss_map[$i] = $cur_hand.$cpt_l;
		$cur_hand = 'R';
	    }	    
	}

	if(($nhss_map[($i+int($th))%$hand_period]) eq '')
	{
	    if(substr($nhss_map[$i],0,1) eq 'R')
	    {
		$cpt_r++;
		$nhss_map[($i+int($th))%$hand_period] = substr($nhss_map[$i],0,1).$cpt_r;
	    }
	    else
	    {
		$cpt_l++;
		$nhss_map[($i+int($th))%$hand_period] = substr($nhss_map[$i],0,1).$cpt_l;
	    }
	}		    
    }

    if ((scalar @_ <=  3) || ($_[3] ne "-1")) 
    {
	print "=== NEW HSS MAP ===\n";
	for(my $i=0; $i < scalar(@nhss_map);$i ++)
	{
	    print $nhss_map[$i]." ";
	}
	print "\n\n";
    }

    for(my $i=0; $i<$hand_period;$i++)
    {
	my $dest = '';
	if(substr($nhss_map[$i],0,1) eq 'R')
	{
	    $dest = $ss_map_r[substr($nhss_map[$i],1)];
	}
	else
	{
	    $dest = $ss_map_l[substr($nhss_map[$i],1)];
	}

	my $found = -1;
	for(my $j=0; $j < scalar(@nhss_map); $j++)
	{
	    if($nhss_map[$j] eq $dest)
	    {		
		my $val = $j - $i;
		if($j < $i)
		{
		    $val = scalar(@nhss_map) + $val;
		}
		if($val > 16)
		{
		    $val = '_';		    
		}
		else
		{
		    $val = sprintf("%X", $val);
		}
		$nss = $nss.''.$val;
		$found = 1;
		last;
	    }
	}
	if($found == -1)
	{
	    $nss = $nss.'_';
	}       	

    }

    if ((scalar @_ <=  3) || ($_[3] ne "-1")) {
	print $nss." ...\n";
    }

    return $nss;

}


sub basicMap
{
    my $max_objs=15;
    my $max_hands=15;
    
    if(scalar @_ >= 1)
    {
	$max_hands = $_[0];
	if(scalar @_ >= 2)
	{
	    $max_objs = $_[1];
	}
    }
    
    print "\n\n\t row : nb Hands\n\t column: nb Objects\n\n";
    print "\t Cn : Cascade Next-Hand\n";
    print "\t Cp : Cascade Previous-Hand\n";
    print "\t Fs : Fountain Same-Hand\n";
    print "\t C : Other Cascade\n";
    print "\t F : Fountain Crossed\n\n\n";    
    
    print '    |';    
    for(my $n=1; $n <= $max_objs; $n ++)
    {       
	if($n<10)
	{
	    print "  $n |";
	}
	else
	{
	    print " $n |";
	}		    
    }
    print "\n ";
    print "-----" x $max_objs ;
    print "----\n";

    for(my $h=1; $h <= $max_hands; $h ++)
    {
	for(my $n=1; $n <= $max_objs; $n++)
	{
	    if ($n == 1)
	    {
		if($h<10)
		{
		    print "  $h |";
		}
		else
		{
		    print " $h |";
		}		    
	    }
	    
	    if($n%$h == 0)
	    {
		print ' Fs |';      		
	    }
	    elsif($n%$h == 1)
	    {
		print ' Cn |';
	    }
	    elsif($n%$h == $h-1)
	    {
		print ' Cp |';
	    }
	    else
	    {
		if(&__pgcd($n,$h) == 1)
		{
		    print '  C |';
		}
		else
		{
		    print '  F |';
		}
		
	    }		
	}

	print "\n ";
	print "-----" x $max_objs ;
	print "----\n";
    }
    print "\n";
}



sub getHandsSeq
{
    my $hss = $_[0];
    my $hands_in = $_[1];
    

    my @hands=split(/,/,$hands_in);
    

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR1\n";
	}
	return -1;
    }

    if(&SSWAP::getSSType($hss,-1) ne 'V')
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR2\n";
	}
	return -1;
    }

    my $hands_nb = &SSWAP::getObjNumber($hss,-1);
    
    if($hands_nb != scalar(@hands))
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR3 => $hands_nb\n";
	}
	return -1;
    }

    # Compute Period Hand Map Period
    my $hand_map_period = 0;
    my @hands_map = ('') x 30;
    
    # for (my $i = 0; $i < length($hss); $i++)
    # {
    # 	if(hex(substr($hss,$i,1)) > $hand_map_period)
    # 	{
    # 	    $hand_map_period = hex(substr($hss,$i,1));
    # 	}	
    # }

    # if($hand_map_period % length($hss) == 0)
    # {
    # 	$hss = $hss x ($hand_map_period / length($hss)); 
    # }
    # else
    # {
    # 	$hss = $hss x ($hand_map_period / length($hss) + 1); 
    # }

    # @hands_map = '' x ($hand_map_period / length($hss) + 1);

    my $cpt = 0;
    my $hands_map_end = 0;
    my $finish = -1;
    my $hands_seq = '';

    while(1)
    {
	if ($finish == 1)
	{
	    last;
	}
	
	for(my $i=0; $i < length($hss); $i ++)
	{
	    if($hands_map[$cpt] eq '')
	    {
		if(substr($hss,$i,1) != 0)
		{
		    my $cur_hand = shift(@hands);		    
		    $hands_map[$cpt] = $cur_hand;
		}	    
	    }
	    
	    if($hands_map[$cpt+hex(substr($hss,$i,1))] eq '')
	    {	    
		$hands_map[$cpt+hex(substr($hss,$i,1))]=$hands_map[$cpt];
		if($hands_map_end < $cpt+hex(substr($hss,$i,1)))
		{
		    $hands_map_end = $cpt+hex(substr($hss,$i,1));
		}
	    }
	    
	    $cpt++;
	}

	if(scalar @hands == 0)
	{
	    $finish = 1;
	    last;
	}	
    }

    my $recompute=-1;
    for(my $i=$cpt;$i<=$hands_map_end;$i++)
    {
	if($hands_map[$i] ne '' && $hands_map[$i%$cpt] ne $hands_map[$i])
	{
	    $recompute = 1;
	}
    }

    if($recompute == 1)
    {
	my $hands_seq = '';
	if(scalar @_ <= 3)
	{
	    $hss .= $hss;
	    print "recomputing ... $hss\n";
	    $hands_seq = &getHandsSeq($hss,$hands_in,$_[2],$_[0]);
	}
	else
	{
	    $hss = $hss.$_[3];
	    print "recomputing ... $hss\n";	   
	    $hands_seq = &getHandsSeq($hss,$hands_in,$_[2],$_[0]);
	}
	return $hands_seq;	    			 
    }
    
    for(my $i=0; $i < $cpt; $i++)
    {
	if($hands_map[$i] eq '')
	{
	    if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
		print "- ";
	    }
	    if($hands_seq eq '')
	    {
		$hands_seq .= '-';
	    }
	    else
	    {
		$hands_seq .= ',-';
	    }		
	}
	else
	{
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print $hands_map[$i]." ";
	    }
	    if($hands_seq eq '')
	    {
		$hands_seq .= $hands_map[$i];
	    }
	    else
	    {
		$hands_seq .= ','.$hands_map[$i];
	    }

	}
    }

    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print "\n\n";
    }
    
    return $hands_seq;
}


sub getHandsSeq_old
{
    my $hss = $_[0];
    my $hands_in = $_[1];

    my @hands=split(/,/,$hands_in);
    

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR1\n";
	}
	return -1;
    }

    if(&SSWAP::getSSType($hss,-1) ne 'V')
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR2\n";
	}
	return -1;
    }

    my $hands_nb = &SSWAP::getObjNumber($hss,-1);
    
    if($hands_nb != scalar(@hands))
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_GETHANDSSEQ_ERROR3 => $hands_nb\n";
	}
	return -1;
    }

    # Compute Period Hand Map Period
    my $hand_map_period = 0;
    my @hands_map = ();
    
    for (my $i = 0; $i < length($hss); $i++)
    {
	if(hex(substr($hss,$i,1)) > $hand_map_period)
	{
	    $hand_map_period = hex(substr($hss,$i,1));
	}	
    }

    if($hand_map_period % length($hss) == 0)
    {
	$hss = $hss x ($hand_map_period / length($hss)); 
    }
    else
    {
	$hss = $hss x ($hand_map_period / length($hss) + 1); 
    }

    @hands_map = '' x ($hand_map_period / length($hss) + 1);
    my $cpt=0;    
    for(my $i=0; $i < length($hss); $i ++)
    {
	if($hands_map[$i] eq '')
	{
	    if(substr($hss,$i,1) != 0)
	    {
		$hands_map[$i] = $hands[$cpt];
		$cpt++;
	    }	    
	}
	if($hands_map[($i+hex(substr($hss,$i,1)))%length($hss)] eq '')
	{	    
	    $hands_map[($i+hex(substr($hss,$i,1)))%length($hss)]=$hands_map[$i];
	    #$hands_map[$i+hex(substr($hss,$i,1))]=$hands_map[$i];
	}
	elsif($hands_map[($i+hex(substr($hss,$i,1)))%length($hss)] ne $hands_map[$i] && $_[3] ne "-2")
	{
	    $hss = $hss.$hss;
	    if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
		print "recomputing ... $hss\n";
	    }
	    my $hands_seq = &getHandsSeq($hss,$hands_in,$_[2],-2,$_[0]);
	    return $hands_seq;	    			 
	}	    	    
    }

    my $hands_seq = '';
    for(my $i=0; $i < length($hss); $i++)
    {
	if($hands_map[$i] eq '')
	{
	    if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
		print "- ";
	    }
	    if($hands_seq eq '')
	    {
		$hands_seq .= '-';
	    }
	    else
	    {
		$hands_seq .= ',-';
	    }		
	}
	else
	{
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print $hands_map[$i]." ";
	    }
	    if($hands_seq eq '')
	    {
		$hands_seq .= $hands_map[$i];
	    }
	    else
	    {
		$hands_seq .= ','.$hands_map[$i];
	    }

	}
    }

    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print "\n\n";
    }
    
    return $hands_seq;
}


sub draw
{
    my $oss = $_[0];   
    my $hss = $_[1];   
    my $fileOutput=$_[2];

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
    my $label_pos = "x";	# Label Position (t: tail, h : head, m : middle, null/none : no label)
    my %oss_hash = ();
    my %hss_hash = ();
    my %oss_transit_hash  = ();
    my %hss_transit_hash  = ();
    my $title = "Y";
    my $nullSS = "N";
    my $silence = 0;
    my $model=0;		# Drawing Model : 0=LADDER, 1=SITESWAP ASYNC (Flat the LADDER), 2=SITESWAP SYNC (Remove the Silence on the LADDER)  
    my $hands = "Y";            # Print Hands 
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $label_color="E";
    my $graphviz_output="N";
    my $show_hss='Y';
    my $hands_base="M";
    my $quick='N';
    
    my $ret = &GetOptionsFromString(uc($_[3]),    
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
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
				    "-A:s" => \$show_hss,
				    "-B:s" => \$hands_base,
				    "-Q:s" => \$quick,
				    
	);

    my $hands_nb = &SSWAP::getObjNumber($hss,-1);
    my $hands_l = '';
    
    for(my $i=0;$i<$hands_nb;$i++)
    {
	if($i==0)
	{
	    $hands_l .= $hands_base.$i;
	}
	else
	{
	    $hands_l .= ','.$hands_base.$i;
	}
    }

    my $hands_seq = &getHandsSeq($hss,$hands_l,-1);
    my @hands_seq_int = split(',',$hands_seq);
    my $default_color = $common::GRAPHVIZ_COLOR_TABLE[0];
    if($label_edge_colorization ne "E")
    {
	$label_color=$label_edge_colorization;
    }
    
    if(uc($show_hss) eq "N")
    {
	######### Use Classical SSWAP Drawing
	my $opts="-H $hands -i $hands_seq $_[3]";
	&SSWAP::draw($oss,$fileOutput,$opts);
    }
    else
    {
	######### Draw HSS/OSS 

	# OSS Computation
	my %oss_color_hash = ();
	my $new_oss = $oss;
	
	# No Transition MAP in input, then build it
	if (scalar keys %oss_transit_hash ==0) {
	    # Remove circle after a Sync throw
	    my ($beat, $res_left_tmp, $res_right_tmp, $queue_hand) = &LADDER::__build_lists($oss,$dot_mode);
	    
	    my @res_left = @{$res_left_tmp};
	    my @res_right = @{$res_right_tmp};
	    
	    if ($period == -1) {
		if ($beat <  $PERIOD_MAX) {
		    $period = $PERIOD_MAX;
		} else {
		    $period = $beat + $PERIOD_MAX;
		}
	    }
	    
	    $new_oss = $oss;
	    
	    if ($beat != 0 ) {
		my $r = int($period / $beat);
		for (my $i=1; $i <= $r; $i++) {
		    $new_oss = $new_oss.$oss;
		}    
	    }
	    
	    if (scalar keys %oss_hash == 0) {
		my ($beat,  $oss_transit_hash_tmp, $oss_hash_tmp, $queue_hand) = &LADDER::__build_dicts($new_oss, $color_mode,$dot_mode);
		$period = $beat;		
		%oss_hash = %{$oss_hash_tmp};
		%oss_transit_hash = %{$oss_transit_hash_tmp};
	    } 
	}
	
	else
	{
	    $new_oss = &LADDER::__get_ss_from_transitionsMAP(\%oss_transit_hash);
	}
	
	if (scalar keys %oss_hash != 0 || scalar keys %oss_transit_hash !=0) {	
	    if ($HSS_DEBUG >= 1) {    
		print "HSS::draw : ================== OSS SITESWAP ===================\n";
		for my $key (sort keys %oss_hash) {
		    print $key." => ".$oss_hash{$key}."\n";
		}	    
		print "=======================================================\n";
		
		print "HSS::draw : ================ OSS TRANSITIONS ===================\n";
		for my $key (sort keys %oss_transit_hash) {
		    print $key." => ".$oss_transit_hash{$key}."\n";
		}	    
		print "=======================================================\n";	    
	    }		
	    
	    for my $key (sort keys %oss_transit_hash) {	
		my @th = split (/:/, $oss_transit_hash{$key});
		if ( $period < int(substr($th[0],1)) ) {
		    $period = int(substr($th[0],1));
		}	    
	    }		
	    $period ++;
	} else {	
	    return -1;
	}
	
	#Build Colorization and dicts
	%oss_color_hash=%{&LADDER::__build_colorMAP_from_transitionsMAP(\%oss_transit_hash)};
	
	if ($HSS_DEBUG >= 1) {
	    print "HSS::draw ===================== OSS COLORS ==================\n";
	    foreach my $i (sort keys (%oss_color_hash)) { 	    
		print $i." => ". $oss_color_hash{$i}."\n";
	    }
	    print "====================================================\n";
	}            


	# HSS Computation
	my %hss_color_hash = ();
	my $new_hss = $hss;

	# Build Transition MAP 
	if (scalar keys %hss_transit_hash ==0) {
	    # Remove circle after a Sync throw
	    my ($beat, $res_left_tmp, $res_right_tmp, $queue_hand) = &LADDER::__build_lists($hss,$dot_mode);
	    
	    my @res_left = @{$res_left_tmp};
	    my @res_right = @{$res_right_tmp};
	    
	    if ($period == -1) {
		if ($beat <  $PERIOD_MAX) {
		    $period = $PERIOD_MAX;
		} else {
		    $period = $beat + $PERIOD_MAX;
		}
	    }
	    
	    $new_hss = $hss;
	    
	    if ($beat != 0 ) {
		my $r = int($period / $beat);
		for (my $i=1; $i <= $r; $i++) {
		    $new_hss = $new_hss.$hss;
		}    
	    }
	    
	    if (scalar keys %hss_hash == 0) {
		my ($beat,  $hss_transit_hash_tmp, $hss_hash_tmp, $queue_hand) = &LADDER::__build_dicts($new_hss, $color_mode,$dot_mode);		
		#$period = $beat;   # Drawing period is the one computed for OSS	
		%hss_hash = %{$hss_hash_tmp};
		%hss_transit_hash = %{$hss_transit_hash_tmp};
	    } 
	}
	
	else
	{
	    $new_hss = &LADDER::__get_ss_from_transitionsMAP(\%hss_transit_hash);
	}
	
	if (scalar keys %hss_hash != 0 || scalar keys %hss_transit_hash !=0) {	
	    if ($HSS_DEBUG >= 1) {    
		print "HSS::draw : ================== HSS SITESWAP ===================\n";
		for my $key (sort keys %hss_hash) {
		    print $key." => ".$hss_hash{$key}."\n";
		}	    
		print "=======================================================\n";
		
		print "HSS::draw : ================ HSS TRANSITIONS ===================\n";
		for my $key (sort keys %hss_transit_hash) {
		    print $key." => ".$hss_transit_hash{$key}."\n";
		}	    
		print "=======================================================\n";	    
	    }		
	    
	    # for my $key (sort keys %hss_transit_hash) {	
	    # 	my @th = split (/:/, $hss_transit_hash{$key});
	    # 	if ( $period < int(substr($th[0],1)) ) {
	    # 	    $period = int(substr($th[0],1));
	    # 	}	    
	    #  }		
	    #  $period ++;
	} else {	
	    return -1;
	}
	
	#Build Colorization and dicts
	%hss_color_hash=%{&LADDER::__build_colorMAP_from_transitionsMAP(\%hss_transit_hash,2)};
	
	if ($HSS_DEBUG >= 1) {
	    print "HSS::draw ===================== HSS COLORS ==================\n";
	    foreach my $i (sort keys (%hss_color_hash)) { 	    
		print $i." => ". $hss_color_hash{$i}."\n";
	    }
	    print "====================================================\n";
	}            

	
	open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	    || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
	print GRAPHVIZ "digraph HSS_DIAGRAM{\n";    

	my $distance_label_slide = 2.0;
	my $angle_label_slide_orig = 180;
	my $angle_label_slide = 25;
	# Dictionnary to draw Edge Label in S mode
	my %label_hash = {};
	
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	print GRAPHVIZ "Start [label=\"\", shape=none]\n";
	#print GRAPHVIZ "N0 [label=\"\", shape=none]\n";	
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
	
	if(uc($quick eq "Y"))
	{
	    print GRAPHVIZ "nslimit=0.1\n nslimit1=0.1\n mclimit=0.1\n maxiter=0.1\n";
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
		if (exists $oss_hash{ "R".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";	 
		} elsif (exists $oss_hash{ "L".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";	 
		} else {	 
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node N".${i}."\n";
		}

		$side_cpt = ($side_cpt+1)%(scalar @hands_seq_int);
		$side = $hands_seq_int[$side_cpt];		    
	    }
	    else
	    {
		if (exists $oss_hash{ "R".$i.":0" }) {
		    print GRAPHVIZ "\""."N".${i}."\""." [label=\"\",  shape=circle, width=.1] // node N".${i}."\n";	 
		} elsif (exists $oss_hash{ "L".$i.":0" }) {
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

	# Draw OSS		
	foreach my $k (sort keys (%oss_hash)) { 	    
	    my $color = $default_color;
	    my $src = (split(/:/,$k))[0];
	    $src=substr($src,1);
	    my $css = lc($oss_hash{$k});
	    
	    $css =~ s/x//g;
	    $css = hex($css);
	    if (substr($oss_hash{$k},0,1) eq '-')
	    {
		$css = -$css;
	    }
	    my $dest = $css + int($src);
	    $src="N".$src;
	    $dest = "N".$dest;
	    if (($css > 0 || ($oss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && int(substr($dest,1)) < $period) {

		if ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && (substr($dest,1)) < $period && (substr($oss_hash{$k},0,1) eq '-')) {
		    $dest = int($src)+$css+1;
		    $dest = "N".$dest;
		}

		if ($color_mode != 0 && exists $oss_color_hash{$k}) {
		    $color = $oss_color_hash{$k};
		}		    
		
		if($label_edge_colorization eq "E")
		{
		    $label_color=$color;
		}
		
		if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		}
		if (uc($label_pos) eq "M") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$oss_hash{$k}."\"".", color=\"".$color."\"]\n";  	
		} elsif (uc($label_pos) eq "X") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$oss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  	 
		} elsif (uc($label_pos) eq "T") {		   
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$oss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		} elsif (uc($label_pos) eq "S") {
		    if(exists $label_hash{ $src })
		    {	
			my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$oss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  
			$label_hash{ $src } ++;
		    }
		    else
		    {		
			my $angle = $angle_label_slide_orig;		       
			print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$oss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n"; 			
			$label_hash{ $src } = 1;
		    }
		} elsif (uc($label_pos) eq "H") {
		    print GRAPHVIZ "\"".$src."\""."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$oss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		}	    		
	    }	    
	}      


	# Draw HSS		
	foreach my $k (sort keys (%hss_hash)) { 	    
	    my $color = $default_color;
	    my $src = (split(/:/,$k))[0];
	    $src=substr($src,1);
	    my $css = lc($hss_hash{$k});
	    
	    $css =~ s/x//g;
	    $css = hex($css);
	    if (substr($hss_hash{$k},0,1) eq '-')
	    {
		$css = -$css;
	    }
	    my $dest = $css + int($src);
	    $src="N".$src;
	    $dest = "N".$dest;
	    if (($css > 0 || ($hss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && int(substr($dest,1)) < $period) {

		if ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && (substr($dest,1)) < $period && (substr($hss_hash{$k},0,1) eq '-')) {
		    $dest = int($src)+$css+1;
		    $dest = "N".$dest;
		}

		if ($color_mode != 0 && exists $hss_color_hash{$k}) {
		    $color = $hss_color_hash{$k};
		}		    
		
		if($label_edge_colorization eq "E")
		{
		    $label_color=$color;
		}

		
		if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
		    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\"]\n";    
		}
		if (uc($label_pos) eq "M") {
		    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$hss_hash{$k}."\"".", color=\"".$color."\"]\n";  	
		} elsif (uc($label_pos) eq "X") {
		    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$hss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\"]\n";  	 
		} elsif (uc($label_pos) eq "T") {		   
		    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
		} elsif (uc($label_pos) eq "S") {
		    if(exists $label_hash{ $src })
		    {	
			my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n";  
			$label_hash{ $src } ++;
		    }
		    else
		    {		
			my $angle = $angle_label_slide_orig;		       
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\"]\n"; 			
			$label_hash{ $src } = 1;
		    }
		} elsif (uc($label_pos) eq "H") {
		    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$hss_hash{$k}."\"".", color=\"".$color."\"]\n";  			
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
	
	if ($HSS_DEBUG <= 0) {
	    unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
	}

	print "\n";
	if ($silence == 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_DRAW_1." : "."$conf::RESULTS/$fileOutput"."\n\n";    
	}
    }
}


sub isValid
{
    my $oss = $_[0];
    my $hss = $_[1];

    if(&SSWAP::isValid($oss,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ISVALID_ERROR1\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }

    if(&SSWAP::getSSType($oss,-1) ne 'V' && &SSWAP::getSSType($oss,-1) ne 'M')
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ISVALID_ERROR2\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }

    if(&SSWAP::isValid($hss,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ISVALID_ERROR3\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    if(&SSWAP::getSSType($hss,-1) ne 'V')
    {
	if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ISVALID_ERROR4\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }

    my $period_oss = &SSWAP::getPeriod($oss,-1);
    my $period_hss =  &SSWAP::getPeriod($hss,-1);
    $oss = $oss x ($period_hss / $period_oss); 
    
    # Check Case with 0 in HSS
    my $beat = 0;
    my @oss_zero = ();
    for (my $i=0; $i< length($oss); $i++)
    {
	if(substr($oss,$i,1) eq '[')
	{
	    $i++;
	    my $val = '';
	    while($i < length($oss) && substr($oss,$i,1) ne ']')
	    {
		$i++;
		$val .= substr($oss,$i,1);
	    }
	    if ($val eq '0')
	    {
		push(@oss_zero,$beat);
	    }	    
	}
	else {
	    push(@oss_zero,$beat);
	}
	$beat ++;
    }
    
    for (my $i=0; $i< length($hss); $i++)
    {
	if(substr($hss,$i,1) eq '0' and not(first {$_ eq $i} @oss_zero))
	{
	    if ((scalar @_ <=  2) || ($_[2] ne "-1")) {
		print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_ISVALID_ERROR5\n";
		print colored [$common::COLOR_RESULT], "False\n";
	    }
	    return -1;	    
	}	
    }
    
    
    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    
    return 1;
}


sub toMHN
{
    my $oss = $_[0];
    my $hss = $_[1];

    my $hands_base="M";
    my $nbhands = &SSWAP::getObjNumber($hss,-1);
    my $hands_l_str = '';
    my @hands_l = ();


    if(&isValid($oss,$hss,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_TOMHN_ERROR1\n";
	}
	return -1;
    }
    
    for(my $i=0;$i<$nbhands;$i++)
    {
	if($i==0)
	{
	    $hands_l_str = $hands_base.$i;
	}
	else
	{
	    $hands_l_str .= ','.$hands_base.$i;
	}
	push(@hands_l, $hands_base.$i);
    }

    my $hands_seq_str = &getHandsSeq($hss,$hands_l_str,-1);
    my @hands_seq = split(',',$hands_seq_str);

    my $ossperiod = &SSWAP::getPeriod($oss,-1);
    if($ossperiod%scalar(@hands_seq) != 0)
    {
	my $mult = 1;
	my $found = -1;
	while($mult <= scalar(@hands_seq) && $found == -1)
	{
	    if(($ossperiod*$mult)%scalar(@hands_seq) == 0)
	    {
		$found = 1;
	    }
	    else
	    {
		$mult ++;
	    }
	}
	$oss = $oss x $mult;
	$ossperiod = &SSWAP::getPeriod($oss,-1);
    }
    
    my @matrix = @{&MHN::__emptyMatrix($nbhands,$ossperiod)};
    my $beat = 0;
    
    for (my $i=0; $i < length($oss); $i++)
    {
	my $hand_src = $hands_seq[$beat%scalar(@hands_seq)];
	if($hand_src eq '_')
	{
	    for(my $j=0; $j < $nbhands; $j++)
	    {
		$matrix[$j][$beat%scalar(@hands_seq)] = 0;
	    }	    
	}
	
	elsif(substr($oss,$i,1) eq '[')
	{
	    $i++;
	    my $hand_src_num = '';
	    my $hand_dst_num = '';
	    my $entry = '';
	    
	    for(my $j=0; $j < $nbhands; $j++)
	    {	    
		if($hands_l[$j] eq $hand_src)
		{
		    $hand_src_num = $j;
		    last;
		}		 
	    }

	    while($i < length($oss) && substr($oss,$i,1) ne ']')
	    {
		# Find ending hand
		my $hand_dst=$hands_seq[($beat+hex(substr($oss,$i,1)))%(scalar @hands_seq)];		
		for(my $j=0; $j < $nbhands; $j++)
		{	    
		    if($hands_l[$j] eq $hand_dst)
		    {
			$hand_dst_num = $j;
			last;
		    }		 
		}
		
		if($hand_src_num == $hand_dst_num)
		{
		    $entry.= substr($oss,$i,1);
		}
		else {
		    $entry .= substr($oss,$i,1).':'.$hand_dst_num;
		}
		$i++;
	    }

	    $matrix[$hand_src_num][$beat] = $entry;
	}
	else
	{
	    my $hand_src_num = '';
	    my $hand_dst_num = '';
	    
	    for(my $j=0; $j < $nbhands; $j++)
	    {	    
		if($hands_l[$j] eq $hand_src)
		{
		    $hand_src_num = $j;
		    last;
		}		 
	    }
	    
	    # Find ending hand
	    my $hand_dst=$hands_seq[($beat+hex(substr($oss,$i,1)))%(scalar @hands_seq)];		
	    for(my $j=0; $j < $nbhands; $j++)
	    {	    
		if($hands_l[$j] eq $hand_dst)
		{
		    $hand_dst_num = $j;
		    last;
		}		 
	    }
	    
	    if($hand_src_num == $hand_dst_num)
	    {
		$matrix[$hand_src_num][$beat] = substr($oss,$i,1);
	    }
	    else {
		$matrix[$hand_src_num][$beat] = substr($oss,$i,1).':'.$hand_dst_num;
	    }	    
	}
	
	$beat ++;
    }

    my $res = &MHN::__matrixToStr(\@matrix);
    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$res\n";
    }
    
    return $res;
}


sub toSS
{
    my $oss = $_[0];
    my $hss = $_[1];
    my $ss = '';

    if(&HSS::isValid($oss,$hss,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_TOMHN_ERROR1\n";
	}
	return -1;
    }

    
    my $nbhands = &SSWAP::getObjNumber($hss,-1);
    if($nbhands > 2)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "$lang::MSG_HSS_TOSS_ERROR0\n";
	}
	return -1;	
    }

    my $mhn=&toMHN($oss,$hss,-1);
    $ss = &MHN::toSS($mhn,-1);
    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], "$ss\n";
    }
    
    return $ss;
    
}



1;
