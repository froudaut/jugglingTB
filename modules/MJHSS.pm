#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## MJHSS.pm   - Multi-Juggler Hand Siteswap Notation for jugglingTB         ##
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

package MJHSS;
use common;
use strict;
use lang;
use Term::ANSIColor;
use modules::MJN; 
use modules::SSWAP;    
use Getopt::Long qw(GetOptionsFromString);


$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $MJHSS_INFO = "Multi-Juggler Hand Siteswap Notation";
our $MJHSS_HELP = $lang::MSG_MJHSS_MENU_HELP;
our $MJHSS_VERSION = "v0.2";

our %MJHSS_CMDS = 
    (
     'draw'                 => ["$lang::MSG_MJHSS_MENU_DRAW_1","$lang::MSG_MJHSS_MENU_DRAW_2"], 
     'isValid'               => ["$lang::MSG_MJHSS_MENU_ISVALID_1","$lang::MSG_MJHSS_MENU_ISVALID_2"], 
    );

print "MJHSS $MJHSS::MJHSS_VERSION loaded\n";

# To add debug behaviour 
our $MJHSS_DEBUG=-1;

my $PERIOD_MAX = 25;
my $MAX_MULT = 15;
my $NODESEP = .3;
my $RANKSEP = 1.0;


sub isValid
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $mjhss = $_[1];
    $mjhss =~ s/\s+//g;
    $mjhss =~ s/\(//g;
    $mjhss =~ s/\)//g;

    if(&MJN::isValid($mjn,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print $lang::MSG_MJHSS_ISVALID_ERR0."\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}

	return -1;
    }

    if(&MJN::isAsync($mjn,-1) <= 0)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print $lang::MSG_MJHSS_ISVALID_ERR5."\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}

	return -1;
    }

    my @matrix = @{&MJN::__toMJNMatrixAsync($mjn)};
    my $nbjugglers = &MJN::getJugglersNumber($mjn,-1);    
    my @mjhss_l = split(/,/,$mjhss);
    my $hands_seq_mjhss = '';
    
    if($nbjugglers != scalar @mjhss_l)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print $lang::MSG_MJHSS_ISVALID_ERR1."\n";
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }

    for(my $i=0;$i< scalar @mjhss_l;$i++)
    {
	if(&SSWAP::isValid($mjhss_l[$i],-1) <= 0)
	{
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print $lang::MSG_MJHSS_ISVALID_ERR2." : ".$mjhss_l[$i],"\n";
		print colored [$common::COLOR_RESULT], "False\n";
	    }
	    return -1;
	}

	if(&SSWAP::getSSType($mjhss_l[$i],-1) ne 'V')
	{
	    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
		print $lang::MSG_MJHSS_ISVALID_ERR3." : ".$mjhss_l[$i]."\n";
		print colored [$common::COLOR_RESULT], "False\n";
	    }
	    return -1;
	}

	
	for(my $j=0; $j<length($mjhss_l[$i]); $j++)
	{
	    if(substr($mjhss_l[$i],$j,1) eq '0')
	    {
		if($j > scalar @matrix)
		{
		    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
			print $lang::MSG_MJHSS_ISVALID_ERR4." : ".$mjhss_l[$i]."\n";
			print colored [$common::COLOR_RESULT], "False\n";
		    }
		    return -1;
		}
		
		for(my $k=$j;$k < scalar @{$matrix[$i]}; $k+=length($mjhss_l[$i]))
		{
		    if($matrix[$k][$i] ne '0')
		    {
			if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
			    print $lang::MSG_MJHSS_ISVALID_ERR4." : ".$mjhss_l[$i]."\n";
			    print colored [$common::COLOR_RESULT], "False\n";
			}
			return -1;
		    }
		}
	    }
	}
    }

    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    return 1;
}


sub draw
{
    my $mjn = $_[0];
    $mjn =~ s/\s+//g;
    my $mjhss = $_[1];
    $mjhss =~ s/\s+//g;
    $mjhss =~ s/\(//g;    
    $mjhss =~ s/\)//g;

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
    my $hands_base='H';
    my $hands_seq = '';
    my $hands = 'Y';
    my $show_hss = 'Y';
    my $hss_style_val=0;    
    my $hss_style='dashed';    
    
    
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
				    "-H:s" => \$jugglers,
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
				    "-B:s" => \$jugglers_base,
				    "-A:s" => \$show_hss,
				    "-F:i" => \$splines_mode,
				    "-Z:s" => \$zero_hand,
				    "-Q:s" => \$quick,
				    "-J:s" => \$hands,
				    "-K:s" => \$hands_base,
				    "-Y:i" => \$hss_style_val,
	);


    if($hss_style_val == 0)
    {
	$hss_style = "dashed";
    }
    if($hss_style_val == 1)
    {
	$hss_style = "dotted";
    }
    if($hss_style_val == 2)
    {
	$hss_style = "solid";
    }
    if($hss_style_val == 3)
    {
	$hss_style = "bold";
    }
    if($hss_style_val == 4)
    {
	$hss_style = "invis";
    }

    my @matrix=@{&MJN::__toMJNMatrixAsync($mjn)};
    
    # Compute Period & Nb Jugglers even if MJN is invalid, to be able to draw even invalid Matrix 
    my $mjnJugglers = 0;
    for(my $i=0;$i<scalar @matrix;$i++)
    {
	my @res_lin = @{$matrix[$i]};
	if($mjnJugglers < scalar @res_lin)
	{
	    $mjnJugglers = scalar @res_lin;
	}
    }	
    my $mjnPeriod = scalar @matrix;
    
    my @mjhss_l = split(/,/,$mjhss);
    my $hands_seq_mjhss = '';
    
    if($mjnJugglers != scalar @mjhss_l)
    {
	if ($silence == 0)
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_MJHSS_DRAW_1."\n";
	}
    }

    for(my $i=0; $i < scalar @mjhss_l; $i++)
    {
	my $hands_nb = &SSWAP::getObjNumber($mjhss_l[$i],-1);
	my $hands_l = '';
	
	for(my $j=0;$j<$hands_nb;$j++)
	{
	    if($j==0)
	    {
		$hands_l .= $hands_base.$j;
	    }
	    else
	    {
		$hands_l .= ','.$hands_base.$j;
	    }
	}
	
	
	my $hands_seq = &HSS::getHandsSeq($mjhss_l[$i],$hands_l,-1);
	$hands_seq_mjhss .= '('.$hands_seq.')';
    }
    
    if(uc($show_hss) eq "N")
    {
	######### Use Classical MJN Drawing
	my $opts="-H $jugglers -J Y -K $hands_seq_mjhss ".$_[3];
	&MJN::draw($mjn,$fileOutput,$opts);
    }

    else
    {
	######### Draw HSS/MJN for Each HSS Set
	my @hands_seq_l = ();
	
	if(uc($hands) eq 'Y')
	{	    
	    my @in = split(/\(/,$hands_seq_mjhss);
	    for(my $i=0; $i < $mjnJugglers; $i++)
	    {
		$in[$i+1]=substr($in[$i+1],0,length($in[$i+1]) -1);
		my @in_l = split(/,/,$in[$i+1]);
		$hands_seq_l[$i] = \@in_l; 
	    }			    
	}
	
	my @color_table = @common::GRAPHVIZ_COLOR_TABLE;
	my @color_map = @{&MJN::__emptyMatrix($mjnJugglers,$period)};	
	my $default_color = $common::GRAPHVIZ_COLOR_TABLE[0];
	my $cpt_color = 0;
	my $color = $default_color;
	
	open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	    || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
	print GRAPHVIZ "digraph MJHSS_DIAGRAM{\n";    
	
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
		    if($matrix[$j%$mjnPeriod][$i] ne '0')
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

	
	#### Draw MJN
	foreach my $j (0..($period-1)) {
	    foreach my $i (0..($mjnJugglers-1)) {
		if($matrix[$j%$mjnPeriod][$i] ne '0')
		{
		    my $src = "J${i}_${j}";
		    my $num_throw = 0;
		    
		    for(my $k=0; $k < length($matrix[$j%$mjnPeriod][$i]); $k++)
		    {
			if(uc(substr($matrix[$j%$mjnPeriod][$i],$k,1)) ne 'P')
			{			    
			    my $dest = "J";
			    my $throw = substr($matrix[$j%$mjnPeriod][$i],$k,1);
			    my $destp = $j+hex($throw);
			    my $destj = '';
			    if($k+1 < length($matrix[$j%$mjnPeriod][$i]) && uc(substr($matrix[$j%$mjnPeriod][$i],$k+1,1)) eq "P")
			    {
				$destj = hex(substr($matrix[$j%$mjnPeriod][$i],$k+2,1));
				$k+=2;
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
				
			    }

			    $num_throw ++;
			}
		    }
		    
		}
		
	    }
	}


	foreach my $i (0..($mjnJugglers-1)) {
	    
	    my %hss_transit_hash  = ();
	    my %hss_hash = ();
	    my $hss = $mjhss_l[$i];

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
		if ($MJHSS_DEBUG >= 1) {    
		    print "MJHSS::draw : ================== HSS SITESWAP ===================\n";
		    for my $key (sort keys %hss_hash) {
			print $key." => ".$hss_hash{$key}."\n";
		    }	    
		    print "=======================================================\n";
		    
		    print "MJHSS::draw : ================ HSS TRANSITIONS ===================\n";
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
	    
	    if ($MJHSS_DEBUG >= 1) {
		print "MJHSS::draw ===================== MJHSS COLORS ==================\n";
		foreach my $i (sort keys (%hss_color_hash)) { 	    
		    print $i." => ". $hss_color_hash{$i}."\n";
		}
		print "====================================================\n";
	    }            

	    #### Draw HSS		
	    foreach my $k (sort keys (%hss_hash)) {
		
		my $color = $default_color;
		my $src = (split(/:/,$k))[0];
		$src=substr($src,1);
		my $css = lc($hss_hash{$k});

		$css =~ s/x//g;
		$css = hex($css);
		if (substr($hss_hash{$k},0,1) eq '_')
		{
		    $css = -$css;
		}
		my $dest = $css + int($src);
		$src="J".${i}."_".$src;
		if (($css > 0 || ($hss_hash{$k} ne "0" && (uc($nullSS) eq "Y"  || uc($nullSS) eq "YES"))) && $dest < $period) {
		    if ((uc($nullSS) eq "Y" || uc($nullSS) eq "YES") && $dest < $period && (substr($hss_hash{$k},0,1) eq '_')) {
			$dest = int($src)+$css+1;
			$dest = "J".${i}."_".$dest;
		    }
		    else
		    {
			$dest = "J".${i}."_".$dest;
		    }
		    if ($color_mode != 0 && exists $hss_color_hash{$k}) {
			$color = $hss_color_hash{$k};
		    }		    
		    
		    if($label_edge_colorization eq "E")
		    {
			$label_color=$color;
		    }

		    
		    if (uc($label_pos) eq "NONE" || uc($label_pos) eq "NULL"  || uc($label_pos) eq "N"  || uc($label_pos) eq "NO" ) {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , color=\"".$color."\", style=$hss_style]\n";    
		    }
		    if (uc($label_pos) eq "M") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , label=\"".$hss_hash{$k}."\"".", color=\"".$color."\", style=$hss_style]\n";  	
		    } elsif (uc($label_pos) eq "X") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , xlabel=\"".$hss_hash{$k}."\"".", forcelabels=true, color=\"".$color."\", style=$hss_style]\n";
		    } elsif (uc($label_pos) eq "T") {		   
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", color=\"".$color."\", style=$hss_style]\n";  			
		    } elsif (uc($label_pos) eq "S") {
			if(exists $label_hash{ $src })
			{	
			    my $angle = $label_hash{ $src } * $angle_label_slide + $angle_label_slide_orig;			
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", style=$hss_style]\n";  
			    $label_hash{ $src } ++;
			}
			else
			{		
			    my $angle = $angle_label_slide_orig;		       
			    print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , taillabel=\"".$hss_hash{$k}."\"".", labeldistance=".$distance_label_slide.", labelangle=".$angle.", color=\"".$color."\", style=$hss_style]\n"; 			
			    $label_hash{ $src } = 1;
			}
		    } elsif (uc($label_pos) eq "H") {
			print GRAPHVIZ "\"".$src."\":s"."->"."\"".$dest."\""." "."[dir=forward,  fontcolor=".$label_color.", fontname=\"Times-Bold\" , headlabel=\"".$hss_hash{$k}."\"".", color=\"".$color."\", style=$hss_style]\n";  			
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
	
	if ($MJHSS_DEBUG <= 0) {
	    unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
	}
	
	print "\n";
	if ($silence == 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_DRAW_1." : "."$conf::RESULTS/$fileOutput"."\n\n";    
	}
	
    }
    
}




1;
