#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## MHN.pm   - Multi-Hand Notation for jugglingTB                            ##
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

package MHN;
use common;
use strict;
use lang;
use Term::ANSIColor;
use modules::MHN_GRAMMAR;    
use modules::SSWAP;    
use Getopt::Long qw(GetOptionsFromString);


$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $MHN_INFO = "Multi-Hand Notation";
our $MHN_HELP = $lang::MSG_MHN_MENU_HELP;
our $MHN_VERSION = "v0.3";

our %MHN_CMDS = 
    (
     'getPeriod'            => ["$lang::MSG_MHN_MENU_GETPERIOD_1","$lang::MSG_MHN_MENU_GETPERIOD_2"],
     'getObjNumber'         => ["$lang::MSG_MHN_MENU_GETOBJNUMBER_1","$lang::MSG_MHN_MENU_GETOBJNUMBER_2"],
     'getHandsNumber'       => ["$lang::MSG_MHN_MENU_GETHANDSNUMBER_1","$lang::MSG_MHN_MENU_GETHANDSNUMBER_2"],
     'isValid'              => ["$lang::MSG_MHN_MENU_ISVALID_1","$lang::MSG_MHN_MENU_ISVALID_2"],
     'isSyntaxValid'        => ["$lang::MSG_MHN_MENU_ISSYNTAXVALID_1","$lang::MSG_MHN_MENU_ISSYNTAXVALID_2"],
     'isAsync'              => ["$lang::MSG_MHN_MENU_ISASYNC_1","$lang::MSG_MHN_MENU_ISASYNC_2"],
     'draw'                 => ["$lang::MSG_MHN_MENU_DRAW_1","$lang::MSG_MHN_MENU_DRAW_2"], 
     'toHSS'                => ["$lang::MSG_MHN_MENU_TOHSS_1","$lang::MSG_MHN_MENU_TOHSS_2"], 
     'toSS'                 => ["$lang::MSG_MHN_MENU_TOSS_1","$lang::MSG_MHN_MENU_TOSS_2"], 
     'toMJN'                => ["$lang::MSG_MHN_MENU_TOMJN_1","$lang::MSG_MHN_MENU_TOMJN_2"], 
    );

print "MHN $MHN::MHN_VERSION loaded\n";

# To add debug behaviour 
our $MHN_DEBUG=-1;

my $NODESEP = .3;


sub __toMHNmatrix
{
    my $in=$_[0];
    my @read_in=split(/\)/,$in);
    my @res = ();
    
    for(my $i=0; $i<scalar(@read_in); $i++)
    {
	my $val=$read_in[$i];
	$val =~ s/\(//g;	
	my @read_in2 = split(/,/, $val);
	$res[$i] = \@read_in2;	
    }

    return \@res;
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
	$res .= '(';
	my @lin = @{$matrix[$i]};
	if (scalar @lin >= 1)
	{
	    $res .= $matrix[$i][0];	
	    for(my $j=1; $j<scalar @lin; $j++)
	    {
		$res .= ','.$matrix[$i][$j];
	    }
	}
	$res .= ')';
    }

    return $res;
}


sub getPeriod
{
    my $mhn = $_[0];   
    my @matrix = @{&__toMHNmatrix($mhn)};
    my @res_lin = @{$matrix[0]};

    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}
	return -1;
    }
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], scalar @res_lin."\n";
    }

    
    return (scalar @res_lin);
}


sub getHandsNumber
{
    my $mhn = $_[0];   
    my @matrix = @{&__toMHNmatrix($mhn)};

    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }
    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], scalar @matrix."\n";
    }
    return (scalar @matrix);
}


sub getObjNumber
{
    my $mhn = $_[0];   
    my @matrix = @{&__toMHNmatrix($mhn)};
    my $sum = 0;
    
    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }
    for(my $i=0; $i<scalar @matrix; $i++)
    {
	my @lin = @{$matrix[$i]};
	for(my $j=0; $j<scalar @lin; $j++)
	{
	    for (my $k=0; $k < length($matrix[$i][$j]) ;$k++)
	    {
		if(substr($matrix[$i][$j],$k,1) ne ":") 
		{
		    $sum += hex(substr($matrix[$i][$j],$k,1));
		}
		if(substr($matrix[$i][$j],$k,1) eq ":")
		{
		    $k++; #Hand num is only one number in hexa
		}
		
	    }
	}
    }

    my  $nb = $sum/int(&getPeriod($mhn)); 

    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], $nb."\n";
    }
    return ($nb);
}



sub isSyntaxValid
{
    # res is -1 if a lexical/syntaxic error is found, 1 otherwise
    my $res=MHN_GRAMMAR::parse($_[0],$_[1]);
    
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
    my $mhn = $_[0];
    my @matrix = @{&__toMHNmatrix($mhn)};
    my @lin = @{$matrix[0]};
    my $period = scalar @lin;
    my $nbhands = scalar(@matrix);

    if(&isSyntaxValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    my @startcount = @{&__emptyMatrix($nbhands, $period)};
    my @endcount = @{&__emptyMatrix($nbhands, $period)};
    
    for(my $i=0; $i<scalar @matrix; $i++)
    {
	my @lin = @{$matrix[$i]};
	if($period != scalar @lin)
	{
	    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
		print colored [$common::COLOR_RESULT], "False\n";
	    }
	    return -1;
	}
	
	for(my $j=0; $j<scalar @lin; $j++)
	{
	    my $entry=$matrix[$i][$j];
	    for (my $k=0; $k < length($entry) ;$k++)
	    {
		if(substr($entry,$k,1) ne ":"
		   && substr($entry,$k,1) ne "0") 		
		{
		    $startcount[$i][$j]++;
		    if($k+2<length($entry) && substr($entry,$k+1,1) eq ":")
		    {
			if(hex(substr($entry,$k+2,1)) > ($nbhands-1))
			{
			    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
				print colored [$common::COLOR_RESULT], "False\n";
			    }
			    return -1;   
			}
			$endcount[hex(substr($entry,$k+2,1))][($j+hex(substr($entry,$k,1)))%$period]++;
			$k+=2; #Hand num is only one number long in hexa
		    }
		    else
		    {
			$endcount[$i][($j+hex(substr($entry,$k,1)))%$period]++;			
		    }
		}		
	    }
	}
    }

    my $valid=1;
    for(my $i=0;$i<scalar @endcount;$i++)
    {
	my @linend = @{$endcount[$i]};
	for(my $j=0;$j<scalar @linend;$j++)
	{
	    if($endcount[$i][$j] != $startcount[$i][$j])
	    {
		print "Invalid : $endcount[$i][$j] catch on Hand: $i, Beat: $j\n";
		$valid=-1;
	    }
	}
    }


    if ((scalar @_ == 1) || ($_[1] ne "-1")) {    

	if($valid == 1)
	{
	    print colored [$common::COLOR_RESULT], "True\n";
	}
	else
	{
	    print colored [$common::COLOR_RESULT], "False\n";
	}
    }
    
    return $valid;
}


sub isAsync
{
    my $mhn = $_[0];   
    my @matrix = @{&__toMHNmatrix($mhn)};

    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], "False\n";
	}
	return -1;
    }
    
    my $nbhands = &getHandsNumber($_[0],-1);
    my $period = &getPeriod($_[0],-1);

    for(my $j=0;$j<$period;$j++)
    {
	my $done = -1;
	for(my $i=0;$i<$nbhands;$i++)
	{
	    if ($matrix[$i][$j] ne '0')
	    {
		if($done == 1)
		{		    
		    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
			print colored [$common::COLOR_RESULT], "False\n";
		    }
		    return -1;
		}
		$done = 1;
	    }
	}
    }

    if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	print colored [$common::COLOR_RESULT], "True\n";
    }
    return 1;
    
}


sub draw
{
    my $mhn = $_[0];   
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
    my $hands = "Y";            # Print Hands 
    my $title_content = "";
    my $label_edge_colorization = "E";
    my $label_color="E";
    my $graphviz_output="N";
    my $hands_base="";
    my $hands_base_init="H";
    my $async_mode="N";
    my $splines_mode=2;          # 0: default, 1: curved, 2: line 
    my $zero_hand="Y";           # Y to have eventual 0 in HSS
    my $quick="N";
    my $inner_hands_seq_undef='R,L';
    my $inner_hands_seq = '';
    my $inner_hands = 'N';
    my $link_hands = 0;          # To link hands by peer
    
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
				    "-E:s" => \$label_edge_colorization,
				    "-G:s" => \$graphviz_output,
				    "-B:s" => \$hands_base,
				    "-A:s" => \$async_mode,
				    "-F:i" => \$splines_mode,
				    "-Z:s" => \$zero_hand,
				    "-Q:s" => \$quick,
				    "-J:s" => \$inner_hands,
				    "-K:s" => \$inner_hands_seq,
				    "-I:i" => \$link_hands,

	);

    
    my @matrix = @{&__toMHNmatrix($mhn)};

    if(uc($inner_hands) eq 'Y' && $hands_base eq '')
    {
	$hands_base = 'J';
    }
    elsif($hands_base eq '')
    {
	$hands_base = $hands_base_init;
    }
    
    if (uc($async_mode) eq "Y" && &isAsync($mhn,-1) )
    {
	my $mhnperiod = &getPeriod($mhn,-1);
	my $nbhands = &getHandsNumber($mhn,-1);

	my $ss = '';
	my $hss = '';
	my $hands_seq = '';

	for(my $j=0;$j<$mhnperiod;$j++)
	{
	    for(my $i=0;$i<$nbhands;$i++)
	    {
		if ($matrix[$i][$j] ne '0')
		{
		    my $entry='';
		    my $cpt = 0;
		    for (my $k=0; $k < length($matrix[$i][$j]); $k++)
		    {
			if(substr($matrix[$i][$j],$k,1) eq ':')
			{
			    $k++;
			}
			else
			{
			    $entry .= substr($matrix[$i][$j],$k,1);
			    $cpt ++;
			}			
		    }
		    if($cpt > 1)
		    {
			$ss .= $entry;
		    }
		    else
		    {
			$ss .= $entry;
		    }
		    if ($hands_seq eq '')
		    {
			$hands_seq .= $hands_base.$i;
		    }
		    else
		    {
			$hands_seq .= ','.$hands_base.$i;
		    }
		    
		    last;
		}

		elsif ($i==0) {
		    # if 0 is the only value for this period on all hands, then choose the first hand
		    my $found = -1;
		    for(my $k=1;$k<$nbhands;$k++)
		    {
			if($matrix[$k][$j] ne '0')
			{
			    $found = 1;
			    last;
			}
		    }
		    if($found == -1)
		    {
			$ss .= '0';
			if(uc($zero_hand) eq "N")
			{			    
			    if ($hands_seq eq '')
			    {
				$hands_seq .= $hands_base.'0';
			    }
			    else
			    {
				$hands_seq .= ','.$hands_base.'0';
			    }
			}
			else
			{
			    if ($hands_seq eq '')
			    {
				$hands_seq .= '_';
			    }
			    else
			    {
				$hands_seq .= ',_';
			    }
			    
			}
		    }
		}
	    }
	}
	
	my @hands_seq_list = split(/,/,$hands_seq);
	for (my $i=0; $i<scalar @hands_seq_list;$i++)
	{
	    if($hands_seq_list[$i] eq '_')
	    {
		$hss .= '0';
	    }
	    else {		
		
		my $next_throw=-1;
		my $j = $i;
		while($next_throw == -1)
		{
		    $j=($j+1);
		    if($hands_seq_list[$i] eq $hands_seq_list[$j%(scalar @hands_seq_list)])
		    {
			$hss .= $j-$i;
			$next_throw=1;
			last;
		    }			    
		}
	    }
	}
	
	my $opts="-H $hands -i $hands_seq ";
	# Remove Useless options
	for (my $i=0; $i < length($_[2]); $i++)
	{
	    if(substr($_[2],$i,1) eq '-' && $i < length($_[2])
	       && (uc(substr($_[2],$i+1,1)) eq 'A'
		   || uc(substr($_[2],$i+1,1)) eq 'Z'
		   || uc(substr($_[2],$i+1,1)) eq 'F'
		   || uc(substr($_[2],$i+1,1)) eq 'J'
		   || uc(substr($_[2],$i+1,1)) eq 'K')
		)
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

	
	&SSWAP::draw($ss,$fileOutput,$opts, $_[3]);
	print colored [$common::COLOR_RESULT], "OSS : $ss\n";
	print colored [$common::COLOR_RESULT], "HSS : $hss\n\n";
	
    }
    
    else
    {
	
	# Compute Period & Nb Hands even if MHN is invalid, to be able to draw even invalid Matrix 
	my $mhnperiod = 0;
	for(my $i=0;$i<scalar @matrix;$i++)
	{
	    my @res_lin = @{$matrix[$i]};
	    if($mhnperiod < scalar @res_lin)
	    {
		$mhnperiod = scalar @res_lin;
	    }
	}
	
	my $nbhands = scalar @matrix;
	my @inner_hands_seq_l = ();
	
	if(uc($inner_hands) eq 'Y')
	{
	    if($inner_hands_seq eq '')
	    {
		my @in = split(/,/,$inner_hands_seq_undef);
		for(my $i=0; $i < $nbhands; $i++)
		{
		    $inner_hands_seq_l[$i] = \@in;
		}
	    }
	    else
	    {
		my @in = split(/\(/,$inner_hands_seq);
		for(my $i=0; $i < $nbhands; $i++)
		{
		    $in[$i+1]=substr($in[$i+1],0,length($in[$i+1]) -1);
		    my @in_l = split(/,/,$in[$i+1]);
		    $inner_hands_seq_l[$i] = \@in_l; 
		}		
	    }
	}
	
	my @color_table = @common::GRAPHVIZ_COLOR_TABLE;
	my @color_map = @{&__emptyMatrix($nbhands,$period)};	
	my $default_color = $common::GRAPHVIZ_COLOR_TABLE[0];
	my $cpt_color = 0;
	my $color = $default_color;
	
	open(GRAPHVIZ,"> $conf::TMPDIR\\${fileOutput}.graphviz") 
	    || die ("$lang::MSG_GENERAL_ERR1 <$conf::TMPDIR\\${fileOutput}.graphviz> $lang::MSG_GENERAL_ERR1b") ;
	print GRAPHVIZ "digraph MHN_DIAGRAM{\n";    
	
	my $distance_label_slide = 2.2;
	my $angle_label_slide_orig = 180;
	my $angle_label_slide = 25;
	# Dictionnary to draw Edge Label in S mode
	my %label_hash = {};
	
	print GRAPHVIZ "node [color=black, shape=point]\n";
	print GRAPHVIZ "edge [color=".$default_color.", dir=none]\n";
	
	foreach my $i (0..($nbhands-1)) {
	    if (uc($hands) eq 'Y')
	    {
		print GRAPHVIZ "H$i [label=\"${hands_base}${i}\", shape=none]\n";
	    }
	    else {
		print GRAPHVIZ "H$i [label=\"\", shape=none]\n";
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
	foreach my $i (0..($nbhands-1)) {	    
	    print GRAPHVIZ "subgraph diag_H${i} {\n";
	    print GRAPHVIZ "rank=same;\n";

	    foreach my $j (0..($period-1)) {	    	 		

		if (uc($inner_hands) eq 'Y')
		{
		    my $side = $inner_hands_seq_l[$i][$j%scalar @{$inner_hands_seq_l[$i]}];
		    print GRAPHVIZ "\""."H${i}_".${j}."\""." [label=\"".$side."\",  shape=plain, width=.1] // node H${i}_".${j}."\n";
		}	
		else
		{
		    if($matrix[$i][$j%$mhnperiod] ne '0')
		    {
			print GRAPHVIZ "\""."H${i}_".${j}."\""." [label=\"\",  shape=circle, width=.2] // node H${i}_".${j}."\n";  
		    } else {	 
			print GRAPHVIZ "\""."H${i}_".${j}."\""." [label=\"\",  shape=point, width=.1] // node H${i}_".${j}."\n";
		    }
		}

	    }
	    
	    print GRAPHVIZ " H${i} -> H${i}_0 [style=invis]\n"; 
	    my $rtmp = "H${i}_0";
	    for (my $j = 1; $j < $period; $j++) {
		$rtmp = $rtmp." -> H${i}_".$j;
	    }
	    
	    print GRAPHVIZ $rtmp." [style=invis]\n";
	    print GRAPHVIZ "}\n";
	    print GRAPHVIZ "\n\n";   
	}
	
	# Connect subgraphs     
	foreach my $i (0..($nbhands-2)) {
	    if($link_hands == 0)
	    {
		print GRAPHVIZ "H${i} -> H".(${i}+1)." [style=invis]\n";
	    }
	    else
	    {
		if($i%2 == 0)
		{
		    print GRAPHVIZ "H${i} -> H".(${i}+1)." [style=dashed]\n";
		}
		else
		{
		    print GRAPHVIZ "H${i} -> H".(${i}+1)." [style=invis]\n";		    
		}
	    }
	    
	}
	foreach my $j (0..($period-1)) {
	    foreach my $i (0..($nbhands-2)) {
		print GRAPHVIZ "\"H${i}_".${j}."\""."->"."\"H".(${i}+1)."_".${j}."\""." "." [style=invis]\n";
	    }
	}
	print GRAPHVIZ "\n\n";

	foreach my $j (0..($period-1)) {
	    foreach my $i (0..($nbhands-1)) {
		if($matrix[$i][$j%$mhnperiod] ne '0')
		{
		    my $src = "H${i}_${j}";
		    my $num_throw = 0;
		    
		    for(my $k=0; $k < length($matrix[$i][$j%$mhnperiod]); $k++)
		    {

			if(substr($matrix[$i][$j%$mhnperiod],$k,1) ne ':')
			{
			    
			    my $dest = "H";
			    my $throw = substr($matrix[$i][$j%$mhnperiod],$k,1);
			    my $destp = $j+hex($throw);
			    my $desth = '';
			    if($k+1 < length($matrix[$i][$j%$mhnperiod]) && substr($matrix[$i][$j%$mhnperiod],$k+1,1) eq ":")
			    {
				$desth = hex(substr($matrix[$i][$j%$mhnperiod],$k+2,1));
				$k+=2;
			    }
			    else
			    {
				$desth = ${i};
			    }
			    $dest .= $desth.'_'.$destp;

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
			    
			    if($destp < $period && $color_map[$desth][$destp] eq '0')
			    {
				my @color_throws = ();
				push(@color_throws, $color);
				$color_map[$desth][$destp] = \@color_throws;
			    }
			    elsif($destp < $period)
			    {
				my @color_throws = @{$color_map[$desth][$destp]};
				push(@color_throws, $color);
				$color_map[$desth][$destp] = \@color_throws;
			    }
			    
			    if($label_edge_colorization eq "E")
			    {
				$label_color=$color;
			    }

			    if($destp < $period)
			    {
				if($i == $desth && $i > ($nbhands/2 -1) )
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
				elsif($i == $desth)
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
					if($i > $desth)
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
	
	if ($MHN_DEBUG <= 0) {
	    unlink "$conf::TMPDIR\\${fileOutput}.graphviz";
	}
	
	print "\n";
	if ($silence == 0) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_LADDER_DRAW_1." : "."$conf::RESULTS/$fileOutput"."\n\n";    
	}
	
    }
    
}


sub toHSS
{
    my $mhn = $_[0];
    my $hands_base="H";
    my $zero_hand="Y";   # Y to have eventual 0 in HSS

    my $ret = &GetOptionsFromString(uc($_[1]),    
				    "-Z:s" => \$zero_hand,
	);

    
    my @matrix = @{&__toMHNmatrix($mhn)};

    if (&isAsync($mhn,-1) == 1)
    {
	my $mhnperiod = &getPeriod($mhn,-1);
	my $nbhands = &getHandsNumber($mhn,-1);

	my $ss = '';
	my $hss = '';
	my $hands_seq = '';

	for(my $j=0;$j<$mhnperiod;$j++)
	{
	    for(my $i=0;$i<$nbhands;$i++)
	    {
		if ($matrix[$i][$j] ne '0')
		{
		    my $entry='';
		    my $cpt = 0;
		    for (my $k=0; $k < length($matrix[$i][$j]); $k++)
		    {
			if(substr($matrix[$i][$j],$k,1) eq ':')
			{
			    $k++;
			}
			else
			{
			    $entry .= substr($matrix[$i][$j],$k,1);
			    $cpt ++;
			}			
		    }
		    if($cpt > 1)
		    {
			$ss .= $entry;
		    }
		    else
		    {
			$ss .= $entry;
		    }
		    if ($hands_seq eq '')
		    {
			$hands_seq .= $hands_base.$i;
		    }
		    else
		    {
			$hands_seq .= ','.$hands_base.$i;
		    }
		    
		    last;
		}

		elsif ($i==0) {
		    
		    my $found = -1;
		    for(my $k=1;$k<$nbhands;$k++)
		    {
			if($matrix[$k][$j] ne '0')
			{
			    $found = 1;
			    last;
			}
		    }
		    
		    if($found == -1)
		    {
			$ss .= '0';
			if(uc($zero_hand) eq "N")
			{
			    # if 0 is the only value for this period on all hands, then choose the first hand				
			    if ($hands_seq eq '')
			    {
				$hands_seq .= $hands_base.'0';
			    }
			    else
			    {
				$hands_seq .= ','.$hands_base.'0';
			    }
			}
			else {
			    if ($hands_seq eq '')
			    {
				$hands_seq .= '_';
			    }
			    else
			    {
				$hands_seq .= ',_';
			    }				
			}

		    }					    
		}
	    }
	}
	
	my @hands_seq_list = split(/,/,$hands_seq);
	for (my $i=0; $i<scalar @hands_seq_list;$i++)
	{
	    if($hands_seq_list[$i] eq '_')
	    {
		$hss .= '0';
	    }
	    else {		
		my $next_throw=-1;
		my $j = $i;
		while($next_throw == -1)
		{
		    $j++;
		    if($hands_seq_list[$i] eq  $hands_seq_list[$j%(scalar @hands_seq_list)])
		    {
			$hss .= $j-$i;
			$next_throw=1;
			last;
		    }			    
		}
	    }
	}

	if(scalar @_ <= 2 || $_[2] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], "OSS: $ss\n";
	    print colored [$common::COLOR_RESULT], "HSS: $hss\n\n";
	}
	return ($ss,$hss);	
    }

    else {
	if(scalar @_ <= 2 || $_[2] ne "-1")
	{
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_TOHSS_ERR0."\n";	    
	}
	return (-1,-1);
    }
    
}


sub toSS
{
    my $mhn = $_[0];    
    my @matrix = @{&__toMHNmatrix($mhn)};
    my $ss = '';
    
    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }

    my $nbhands = &getHandsNumber($mhn,-1);
    my $period = &getPeriod($mhn,-1);

    if($nbhands == 1)
    {
	for(my $j=0; $j < $period; $j++)
	{
	    my $entry = $matrix[0][$j];
	    my $val = '';
	    my $cpt = 0;
	    for(my $k=0; $k < length($entry); $k++)
	    {
		if(hex(substr($entry,$k,1)) % 2 != 0)
		{
		    $val .= substr($entry,$k,1).'x0';
		}
		else {
		    $val .= substr($entry,$k,1).'0';
		}		
		
		if($k+2 < length($entry) && substr($entry,$k+1,1) eq ':')
		{
		    $k+=2;
		}
		$cpt ++;
	    }
	    if($cpt > 1)
	    {
		$ss .= '['.$val.']';
	    }
	    else
	    {
		$ss .= $val;
	    }
	}

	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $ss."\n";
	}
	
	return $ss;	
    }

    elsif($nbhands == 2)
    {
	my $val_l = '';
	
	for(my $j=0; $j < $period; $j++)
	{
	    my $entry0 = $matrix[0][$j];
	    my $val_r = '';
	    my $cpt_r = 0;
	    for(my $k=0; $k < length($entry0); $k++)
	    {
		if($k+2 < length($entry0) && substr($entry0,$k+1,1) eq ':')
		{
		    if((hex(substr($entry0,$k,1)) % 2 == 0 && substr($entry0,$k+2,1) eq '0')
		       || (hex(substr($entry0,$k,1)) % 2 != 0 && substr($entry0,$k+2,1) eq '1'))
		    {
			$val_r .= substr($entry0,$k,1);
		    }
		    elsif((hex(substr($entry0,$k,1)) % 2 == 0 && substr($entry0,$k+2,1) eq '1')
			  || (hex(substr($entry0,$k,1)) % 2 != 0 && substr($entry0,$k+2,1) eq '0'))
		    {
			$val_r .= substr($entry0,$k,1).'x';
		    }
		    $k +=2;
		}
		else {
		    if(hex(substr($entry0,$k,1)) % 2 == 0)
		    {
			$val_r .= substr($entry0,$k,1);
		    }
		    else
		    {
			$val_r .= substr($entry0,$k,1).'x';
		    }
		}
		$cpt_r ++;
	    }

	    my $entry1 = $matrix[1][$j];
	    my $val_l = '';
	    my $cpt_l = 0;
	    for(my $k=0; $k < length($entry1); $k++)
	    {
		if($k+2 < length($entry1) && substr($entry1,$k+1,1) eq ':')
		{
		    if((hex(substr($entry1,$k,1)) % 2 == 0 && substr($entry1,$k+2,1) eq '1')
		       || (hex(substr($entry1,$k,1)) % 2 != 0 && substr($entry1,$k+2,1) eq '0'))
		    {
			$val_l .= substr($entry1,$k,1);
		    }
		    elsif((hex(substr($entry1,$k,1)) % 2 == 0 && substr($entry1,$k+2,1) eq '0')
			  || (hex(substr($entry1,$k,1)) % 2 != 0 && substr($entry1,$k+2,1) eq '1'))
		    {
			$val_l .= substr($entry1,$k,1).'x';
		    }
		    $k +=2;
		}
		else {
		    if(hex(substr($entry1,$k,1)) % 2 == 0)
		    {
			$val_l .= substr($entry1,$k,1);
		    }
		    else
		    {
			$val_l .= substr($entry1,$k,1).'x';
		    }
		}
		$cpt_l ++;
	    }

	    if($cpt_r > 1)
	    {
		$val_r = '['.$val_r.']';
	    }
	    if($cpt_l > 1)
	    {
		$val_l = '['.$val_l.']';
	    }
	    
	    $ss .= '('.$val_r.','.$val_l.')!';
	}
	
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], &SSWAP::simplify($ss,-1)."\n";
	}
	
	return &SSWAP::simplify($ss,-1);					
    }

    else
    {
	if ((scalar @_ == 1) || ($_[1] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_TOSS_ERR0."\n";
	}
	return -1;	    
    }    
}


sub __isMJNasync
{
    my $mhn = $_[0];
    my @matrix = @{&__toMHNmatrix($mhn)};

    if(&isValid($mhn,-1) == -1)
    {
	return -1;
    }

    my $period = &getPeriod($mhn,-1);
    my $nbhands = &getHandsNumber($mhn,-1);

    for(my $i=0; $i<$nbhands; $i+=2)
    {
	for(my $j=0; $j<$period;$j++)
	{
	    if($matrix[$i][$j] ne '0' && $matrix[$i+1][$j] ne '0')
	    {

		return -1;
	    }
	}
    }

    return 1;
}


sub toMJN
{
    my $mhn = $_[0];        
    my $mode = 0; # 0: Auto, 1: Async, 2: Sync
    my @matrix = @{&__toMHNmatrix($mhn)};
    my $mjn = '';

    if (scalar @_ > 1)
    {
	$mode = $_[1];
    }
    
    if(&isValid($mhn,-1) == -1)
    {
	if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	    print colored [$common::COLOR_RESULT], $lang::MSG_MHN_ISVALID_ERR0." : ".$_[0]."\n";
	}

	return -1;
    }

    my $nbhands = &getHandsNumber($mhn,-1);
    my $period = &getPeriod($mhn,-1);
    
    # This Is an Async Model MJN
    if(($mode == 0 && &__isMJNasync($mhn,-1) == 1) || $mode == 1)
    {
       	for(my $i=0; $i < $period; $i++)
	{
	    $mjn .= '<';
	    
	    for(my $j=0; $j < $nbhands; $j+=2)
	    {
		my $right = '';
		my $left = '';
		
		my $in = $matrix[$j][$i];
		my $cpt = 0;
		for(my $k=0;$k<length($in);$k++)
		{
		    if($k+1 < length($in) && substr($in,$k+1,1) ne ':')
		    {
			$right .= substr($in,$k,1);
		    }
		    elsif($k+1 >= length($in))
		    {
			$right .= substr($in,$k,1);
		    }
		    else
		    {
			$right .= substr($in,$k,1);
			my $dest = int(hex(substr($in,$k+2,1)) / 2) +1;
			if(hex(substr($in,$k+2,1) %2 == 0))
			{
			    if(hex(substr($in,$k,1)) % 2 != 0)
			    {
				$right .= 'x';			    
			    }
			}
			else
			{
			    if(hex(substr($in,$k,1)) % 2 == 0 && substr($in,$k,1) ne '0')
			    {
				$right .= 'x';			    
			    }
			}
			if(int($j/2) +1 != $dest)
			{
			    $right .= 'p'.$dest;
			}
			$k += 2;
		    }
		    $cpt ++;
		}
		if($cpt > 1)
		{
		    $right = '['.$right.']';
		}

		$in = $matrix[$j+1][$i];
		$cpt = 0;
		for(my $k=0;$k<length($in);$k++)
		{
		    if($k+1 < length($in) && substr($in,$k+1,1) ne ':')
		    {
			$left .= substr($in,$k,1);
		    }
		    elsif($k+1 >= length($in))
		    {
			$left .= substr($in,$k,1);
		    }
		    else
		    {
			$left .= substr($in,$k,1);
			my $dest = int(hex(substr($in,$k+2,1)) / 2) +1;
			if(hex(substr($in,$k+2,1) %2 == 0))
			{
			    if(hex(substr($in,$k,1)) % 2 == 0 && substr($in,$k,1) ne '0' )
			    {
				$left .= 'x';			    
			    }
			}
			else
			{
			    if(hex(substr($in,$k,1)) % 2 != 0)
			    {
				$left .= 'x';			    
			    }
			}
			if(int($j/2) +1 != $dest)
			{
			    $left .= 'p'.$dest;
			}
			$k += 2;
		    }
		    $cpt ++;
		}	    
		if($cpt > 1)
		{
		    $left = '['.$left.']';
		}

		if($right eq '0' && $left eq '0')
		{
		    $mjn .= '0';
		}
		elsif($right ne '0' && $left eq '0')
		{
		    $mjn .= $right;
		}
		elsif($left ne '0' && $right eq '0')
		{
		    $mjn .= $left;
		}
		elsif($left ne '0' && $right ne '0')
		{
		    $mjn .= '('.$right.','.$left.')!';
		}		
		if($j + 2 < $nbhands)
		{
		    $mjn .= '|';
		}
	    }
	    
	    $mjn .= '>';
	}
    }
    
    # This Is a Sync Model MJN
    elsif(($mode == 0 && &__isMJNasync($mhn,-1) == -1) || $mode == 2)
    {
	for(my $i=0; $i < $period; $i++)
	{
	    $mjn .= '<';
	    
	    for(my $j=0; $j < $nbhands; $j+=2)
	    {
		my $right = '';
		my $left = '';
		
		my $in = $matrix[$j][$i];
		my $cpt = 0;
		for(my $k=0;$k<length($in);$k++)
		{
		    if($k+1 < length($in) && substr($in,$k+1,1) ne ':')
		    {
			$right .= substr($in,$k,1);
		    }
		    elsif($k+1 >= length($in))
		    {
			$right .= substr($in,$k,1);
		    }
		    else
		    {
			$right .= substr($in,$k,1);
			my $dest = int(hex(substr($in,$k+2,1)) / 2) +1;
			if(hex(substr($in,$k+2,1) %2 == 0))
			{
			    if(hex(substr($in,$k,1)) % 2 != 0)
			    {
				$right .= 'x';			    
			    }
			}
			else
			{
			    if(hex(substr($in,$k,1)) % 2 == 0 && substr($in,$k,1) ne '0')
			    {
				$right .= 'x';			    
			    }
			}
			if(int($j/2) +1 != $dest)
			{
			    $right .= 'p'.$dest;
			}
			$k += 2;
		    }
		    $cpt ++;
		}
		if($cpt > 1)
		{
		    $right = '['.$right.']';
		}

		$in = $matrix[$j+1][$i];
		$cpt = 0;
		for(my $k=0;$k<length($in);$k++)
		{
		    if($k+1 < length($in) && substr($in,$k+1,1) ne ':')
		    {
			$left .= substr($in,$k,1);
		    }
		    elsif($k+1 >= length($in))
		    {
			$left .= substr($in,$k,1);
		    }
		    else
		    {
			$left .= substr($in,$k,1);
			my $dest = int(hex(substr($in,$k+2,1)) / 2) +1;
			if(hex(substr($in,$k+2,1) %2 == 0))
			{
			    if(hex(substr($in,$k,1)) % 2 == 0 && substr($in,$k,1) ne '0' )
			    {
				$left .= 'x';			    
			    }
			}
			else
			{
			    if(hex(substr($in,$k,1)) % 2 != 0)
			    {
				$left .= 'x';			    
			    }
			}
			if(int($j/2) +1 != $dest)
			{
			    $left .= 'p'.$dest;
			}
			$k += 2;
		    }
		    $cpt ++;
		}	    
		if($cpt > 1)
		{
		    $left = '['.$left.']';
		}
		
		$mjn .= '('.$right.','.$left.')!';
		
		if($j + 2 < $nbhands)
		{
		    $mjn .= '|';
		}
	    }
	    
	    $mjn .= '>';
	}
    }
    
    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], $mjn."\n";
    }
    
    return $mjn;					
    
}


1;
