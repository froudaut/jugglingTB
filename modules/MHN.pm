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
use List::MoreUtils qw(any);
use Cwd;
use POSIX;

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
     'genPolyrhythm'        => ["$lang::MSG_MHN_MENU_GENPOLYRHYTHM_1","$lang::MSG_MHN_MENU_GENPOLYRHYTHM_2"],
     'lowerHeightOnTempo'   => ["$lang::MSG_MHN_MENU_LOWERHEIGHTONTEMPO_1","$lang::MSG_MHN_MENU_LOWERHEIGHTONTEMPO_2"],
     'printMHNListHTML'     => ["$lang::MSG_MHN_MENU_PRINTMHNLISTHTML_1","$lang::MSG_MHN_MENU_PRINTMHNLISTHTML_2"],
    );

print "MHN $MHN::MHN_VERSION loaded\n";

# To add debug behaviour 
our $MHN_DEBUG=1;

my $NODESEP = .3;

my $MAX_MULT = 15;
my $MAX_HEIGHT = 15;
my $MAX_NBOBJ = 15;

my $LINK_GUNSWAP='N'; # To add Gunswap Link for jonglage.net in generation
my $LINK_JUGGLINGLAB_GIF='N'; # To add JugglingLab GIF Server Link for jonglage.net in generation


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

    return lc($res);
}


sub getPeriod
{
    my $mhn = $_[0];
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
    my @matrix = @{&__toMHNmatrix($mhn)};
    
    if(@matrix == ())
    {
	return -1;
    }
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
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
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
    my $link_hands = 0;          # To link hands by peer (not shown in doc)
    
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
    
    if (uc($async_mode) eq "Y" && &isAsync($mhn,-1) == 1)
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
	
	my $opts="-h $hands -i $hands_seq ";
	# Remove Useless options
	for (my $i=0; $i < length($_[2]); $i++)
	{
	    if(substr($_[2],$i,1) eq '-' && $i < length($_[2])
	       && (uc(substr($_[2],$i+1,1)) eq 'A'
		   || uc(substr($_[2],$i+1,1)) eq 'Z'
		   || uc(substr($_[2],$i+1,1)) eq 'F'
		   || uc(substr($_[2],$i+1,1)) eq 'I'
		   || uc(substr($_[2],$i+1,1)) eq 'H'
		   || uc(substr($_[2],$i+1,1)) eq 'B'
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


	if(scalar @_ <= 3)
	{
	    &SSWAP::draw($ss,$fileOutput,$opts);
	}
	else
	{
	    &SSWAP::draw($ss,$fileOutput,$opts, $_[3]);
	}
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


	if ($MHN_DEBUG >= 1) { 
	    print "== MHN::draw : Color Map \n";
	    for (my $i = 0; $i < $nbhands; $i++) {
		print $i.":\t";
		for (my $j = 0; $j < $period; $j++) {
		    if($color_map[$i][$j] ne '0')
		    {
			print join(',',@{$color_map[$i][$j]})."\t";
		    }
		}
		print "\n";
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
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
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
    $mhn =~ s/\s+//g;
    my @matrix = @{&__toMHNmatrix($mhn)};
    my $side = 'R';
    
    if(&isValid($mhn,-1) == -1)
    {
	return -1;
    }

    my $period = &getPeriod($mhn,-1);
    my $nbhands = &getHandsNumber($mhn,-1);

    if($period % 2 != 0)
    {
	return -1;
    }
    for(my $i=0; $i<$nbhands; $i+=2)
    {
	$side = 'R';
	for(my $j=0; $j<$period;$j++)
	{
	    if($matrix[$i][$j] ne '0' && $matrix[$i+1][$j] ne '0')
	    {
		return -1;
	    }
	    else
	    {
		if($side eq 'R')
		{
		    if($matrix[$i+1][$j] ne '0')
		    {
			return -1;
		    }
		}
		elsif($side eq 'L')
		{
		    if($matrix[$i][$j] ne '0')
		    {
			return -1;
		    }
		}
	    }
	    if($side eq 'R')
	    {
		$side = 'L';
	    }
	    elsif($side eq 'L')
	    {
		$side = 'R';
	    }
	}
    }

    return 1;
}


sub toMJN
{
    my $mhn = $_[0];
    $mhn =~ s/\s+//g;
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
		    if($cpt > 0)
		    {
			$right .= ' ';
		    }
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
		    if($cpt > 0)
		    {
			$left .= ' ';
		    }

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
				$left .= 'ax';			    
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
	    my $mustSimpl = -1;
	    if($i+1 < $period)
	    {
		$mustSimpl = 1;
		for(my $j=0; $j < $nbhands; $j++)
		{
		    if(($matrix[$j][$i+1]) ne '0')
		    {
			$mustSimpl = -1;
			last;
		    }
		    
		}
	    }

	    
	    $mjn .= '<';
	    
	    for(my $j=0; $j < $nbhands; $j+=2)
	    {
		my $right = '';
		my $left = '';
		
		my $in = $matrix[$j][$i];
		my $cpt = 0;
		for(my $k=0;$k<length($in);$k++)
		{
		    if($cpt > 0)
		    {
			$right .= ' ';
		    }
		    if(($k+1 < length($in) && substr($in,$k+1,1) ne ':') || ($k+1 >= length($in)))
		    {
			$right .= substr($in,$k,1);
			if(hex(substr($in,$k,1)) % 2 != 0)
			{
			    $right .= 'x';			    
			}
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
		    if($cpt > 0)
		    {
			$left .= ' ';
		    }
		    if(($k+1 < length($in) && substr($in,$k+1,1) ne ':') || ($k+1 >= length($in)))
		    {
			$left .= substr($in,$k,1);
			if(hex(substr($in,$k,1)) % 2 != 0 && substr($in,$k,1) ne '0' )
			{
			    $left .= 'x';			    
			}			
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

		if($left eq '')
		{
		    $left = '0';
		}
		$mjn .= '('.$right.','.$left.')';

		if ($mustSimpl == -1)
		{
		    $mjn .= '!';
		}
		
		if($j + 2 < $nbhands)
		{
		    $mjn .= '|';
		}
	    }
	    
	    $mjn .= '>';

	    if ($mustSimpl == 1)
	    {
		$i++;				    
	    }
	    
	}
    }
    
    if ((scalar @_ <= 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], $mjn."\n";
    }
    
    return $mjn;					
    
}


sub __genPolyrhythm
{
    my $nbhands = $_[0];
    my $period = $_[1];
    my $max_height = $_[2];
    my $nbval = $_[3];
    my @matrix = @{$_[4]};
    my @matrix_catch = @{$_[5]};
    my $sum = $_[6];
    my $expected_sum = $_[7];
    my $direct_print = $_[8];
    my @exclude_throws = @{$_[9]};
    my $res_ref = $_[10];
    my $opts = $_[11];
    
    my $MJN_print = 'N';    
    my $MHNandMJN_print = 'N';
    my $lower_height_list = 'N';
    my $lower_height_list_JL = 'N';
    
    my $ret = &GetOptionsFromString(uc($opts),    
				    "-M:s" => \$MJN_print,
				    "-B:s" => \$MHNandMJN_print,
				    "-L:s" => \$lower_height_list,
				    "-J:s" => \$lower_height_list_JL,
	);
    
    if($nbval == 0 && $sum == $expected_sum)
    {	
	my $val = '';
	
	my $v = &__matrixToStr(\@matrix);
	my $v_mjn = '';

	if(uc($MHNandMJN_print) eq 'Y')
	{
	    $v_mjn = &toMJN($v,'',-1);
	    $val = $v.";".$v_mjn;
	}
	elsif(uc($MJN_print) eq 'Y')
	{
	    $v_mjn = &toMJN($v,'',-1);
	    $val = $v_mjn;
	}
	else
	{
	    $val = $v;
	}

	if(uc($lower_height_list) eq 'Y' && (uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N'))
	{	    
	    $val .= ';'.&lowerHeightOnTempo($v,'',-1); 
	}
	if(uc($lower_height_list) eq 'Y' && (uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y'))
	{	    
	    $val .= ';'.&toMJN(&lowerHeightOnTempo($v,'',-1),'',-1); 
	}
	
	if(uc($lower_height_list_JL) eq 'Y' && (uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N'))
	{	    
	    $val .= ';'.&lowerHeightOnTempo($v,'-j y',-1); 
	}
	if(uc($lower_height_list_JL) eq 'Y' && (uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y'))
	{	    
	    $val .= ';'.&toMJN(&lowerHeightOnTempo($v,'-j y',-1),'',-1); 
	}
	
	if($MHN_DEBUG >= 1)
	{
	    &__printMatrix(\@matrix);
	}
	if($direct_print ==1)
	{
	    print lc($val)."\n";
	}

	push(@{$_[10]}, lc($val));
	return $res_ref;
    }
    
    elsif($nbval == 0)
    {
	return -1;
    }
    
    for(my $i = 0; $i <= $max_height; $i ++)
    {
	if(not(any {uc($_) eq (sprintf("%X",$i))} @exclude_throws))
	{
	    for(my $l=0; $l < $nbhands; $l++)
	    {
		my $sum_tmp = $sum;
		my $nbval_tmp = $nbval;
		my @matrix_tmp = ();
		my @matrix_catch_tmp = ();

		for(my $m=0; $m < $nbhands; $m++) {
		    for(my $n=0; $n < $period; $n++) {
			$matrix_tmp[$m][$n] = $matrix[$m][$n];
			$matrix_catch_tmp[$m][$n] = $matrix_catch[$m][$n];
		    }
		}
		
		if($i + $sum_tmp <=  $expected_sum)
		{
		    $nbval_tmp --;
		    $sum_tmp += $i;
		    my $found = -1;
		    for(my $j=0; $j < $nbhands; $j ++)
		    {
			for(my $k=0; $k < $period; $k ++)
			{
			    if($matrix[$j][$k] eq '?')
			    {			    
				if($i != 0 && $matrix_catch[$l][($k+$i)%$period] eq '?')
				{
				    $matrix_tmp[$j][$k] = sprintf('%X',$i).':'.$l;
				    $matrix_catch_tmp[$l][($k+$i)%$period] = 1;		

				    &__genPolyrhythm($nbhands, $period, $max_height, $nbval_tmp,
						     \@matrix_tmp,\@matrix_catch_tmp, $sum_tmp, $expected_sum,
						     $direct_print, \@exclude_throws, \@{$_[10]}, $opts);
				}

				elsif($i == 0 && $matrix_catch[$j][$k] eq '?' && $l == 0)
				{
				    $matrix_tmp[$j][$k] = '0';
				    $matrix_catch_tmp[$j][$k] = '1';
				    &__genPolyrhythm($nbhands, $period, $max_height, $nbval_tmp,
						     \@matrix_tmp,\@matrix_catch_tmp, $sum_tmp, $expected_sum,
						     $direct_print, \@exclude_throws, \@{$_[10]}, $opts);       				   
				}
				
				$found = 1;
			    }
			    if($found == 1)
			    {
				last;
			    }
			}
			if($found == 1)
			{
			    last;
			}
		    }
		}
	    }
	}
    }       
}


sub genPolyrhythm
{
    my $nbhands = $_[0];
    my $nbobjects = $_[1];
    my $max_height = hex($_[2]);
    my $ratios = $_[3];
    my @exclude_throws = ('0');
    if(scalar @_ >= 5)
    {
	if($_[4] eq '')
	{
	    @exclude_throws = ();
	}
	else
	{
	    @exclude_throws = @{$_[4]};
	}
    }

    my $MJN_print = 'N';
    my $MHNandMJN_print = 'Y';
    my $splines_mode=2;          # 0: default, 1: curved, 2: line 
    my $quick="N";
    my $lower_height_list = 'N';
    my $lower_height_list_JL = 'N';
    
    my $ret = &GetOptionsFromString(uc($_[5]),    
				    "-M:s" => \$MJN_print,				    
				    "-B:s" => \$MHNandMJN_print,
				    "-F:i" => \$splines_mode,
				    "-Q:s" => \$quick,
				    "-L:s" => \$lower_height_list,
				    "-J:s" => \$lower_height_list_JL,
	);

    my $opts = "-m $MJN_print -b $MHNandMJN_print -L $lower_height_list -J $lower_height_list_JL";

    if (scalar @_ >= 7 && $_[6] ne "-1") {	    	    	    	    
	if("HTML:"=~substr(uc($_[6]),0,5))
	{
	    $opts = "-m N -b N";
	}
	if("JML:"=~substr(uc($_[6]),0,4))
	{
	    $opts = "-m Y -b N";	    
	}
    }
    
    
    my @res = ();
    my $title = '-- POLYRHYTHMS MHN --';
    my $direct_print = 1;
    my $f = '';
    
    if($max_height eq '' || hex($max_height) > $MAX_HEIGHT)
    {
	$max_height = $MAX_HEIGHT;
    }
    else
    {
	$max_height=hex($max_height);
    }
    
    my @ratios_l = split (/,/,$ratios);
    if(scalar @ratios_l != $nbhands-1)
    {
	print colored [$common::COLOR_RESULT], $lang::MSG_MHN_GENPOLYRYTHM_ERR0."\n";
	return -1;
    }
    my $ratioL = 1;
    my $GCF = 1;

    # Get a Commun ratioL
    for(my $i = 0; $i < scalar @ratios_l; $i++)
    {
	my @val = split(/:/, $ratios_l[$i]);
	if($val[0] % $ratioL == 0)
	{
	    $ratioL = $val[0];
	}
	else
	{
	    $ratioL = $val[0] * $ratioL;
	}
    }

    # Update all Ratios with the commun ratioL
    my @ratios_l2 = ();
    for(my $i = 0; $i < scalar @ratios_l; $i++)
    {
	my @val = split(/:/, $ratios_l[$i]);
	push (@ratios_l2, ($ratioL.":".($ratioL/$val[0])*$val[1]));
    }
    
    # Get a Commun GCF
    for(my $i = 0; $i < scalar @ratios_l2; $i++)
    {
	my @val = split(/:/, $ratios_l2[$i]);
	if(($val[0] * $val[1]) % $GCF ==0)
	{
	    $GCF = $val[0] * $val[1];
	}
	else
	{
	    $GCF = $val[0] * $val[1] * $GCF;
	}
    }

    # Update all Ratios with the GCF to get the divisions map
    my @div_map = ();
    my @val = split(/:/, $ratios_l2[0]);
    my $div_map_hand0 = $GCF/$val[0];
    for(my $i = 0; $i < scalar @ratios_l2; $i++)
    {
	@val = split(/:/, $ratios_l2[$i]);
	push (@div_map, $GCF/$val[1]);	
    }    
    
    my @matrix = @{&__emptyMatrix($nbhands,$GCF)};
    my $nbval = 0;
    for(my $j = 0 ;$j < $GCF;$j += $div_map_hand0)
    {
	$matrix[0][$j] = '?';
	$nbval ++;
    }
    
    for(my $i=1;$i < $nbhands;$i ++)
    {
	my $nb=$div_map[$i-1];
	for(my $j = 0 ; $j < $GCF; $j += $nb)
	{
	    $matrix[$i][$j] = '?';
	    $nbval ++;
	}
    }

    my $expected_sum = $GCF * $nbobjects;
    
    if($MHN_DEBUG >= 1)
    {
	print "=== MHN::genPolyrhythm Model ===\n";
	&__printMatrix(\@matrix);	
    }

    &__genPolyrhythm($nbhands, $GCF, $max_height, $nbval, \@matrix, \@matrix, 0,
		     $expected_sum, $direct_print, \@exclude_throws, \@res, $opts);        

    
    if (scalar @_ >= 7 && $_[6] ne "-1") {	    	    	    	    
	if("HTML:"=~substr(uc($_[6]),0,5))
	{
	    $f =substr($_[6],5);
	    $title.= "\n================================================================\n";	   
	    $title.= $lang::MSG_MHN_POLYRHYTHM_MSG1." : ".join(';',@ratios_l)."\n";     
	    $title.= $lang::MSG_MHN_GENERAL2." : ".$nbobjects."\n";
	    $title.= $lang::MSG_MHN_GENERAL3." : ".$nbhands."\n";     
	    $title.= "================================================================\n\n";
	    
	    &printMHNListHTML('-1',$f,"$title","-m $MJN_print -b $MHNandMJN_print -l $lower_height_list -j $lower_height_list_JL -f $splines_mode -q $quick",\@res);
	}
	elsif("JML:"=~substr(uc($_[6]),0,4))
	{
	    $f =substr($_[6],4);
	    open(FILE,"> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 
	    print FILE "<?xml version=\"1.0\"?>\n";
	    print FILE "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE "<patternlist>\n";
	    print FILE "<title>".$title."</title>\n";
	    print FILE "<line display=\'".$title."\'"."/>\n";	   
	    print FILE "<line display=\"\"/>\n";	   
	    print FILE "<line display=\"========================================\""."/>\n";	   
	    print FILE "<line display=\"$lang::MSG_MHN_POLYRHYTHM_MSG1"." : ".join(';',@ratios_l)."\"/>\n";     
	    print FILE "<line display=\"$lang::MSG_MHN_GENERAL2"." : ".$nbobjects."\"/>\n";
	    print FILE "<line display=\"$lang::MSG_MHN_GENERAL3"." : ".$nbhands."\"/>\n";     	    
	    print FILE "<line display=\"========================================\""."/>\n";	   
	    print FILE "<line display=\"\"/>\n";	    
	    close FILE;

	    &printMHNListWithoutHeaders(\@res,'', $_[6]);
	    
	    open(FILE,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ; 

	    print FILE "<line display=\"\" />\n";
	    print FILE "<line display=\"   [ => ".(scalar @res)." MJN(s) ]"."\"/>\n";     
	    print FILE "<line display=\"\" />\n";
	    print FILE "<line display=\"----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\" />\n";		
	    print FILE "</patternlist>\n";
	    print FILE "</jml>\n";

	    close FILE;
	    print colored [$common::COLOR_RESULT], "\n====> ".(scalar @res)." MHN(s) Generated\n ";
	    
	}	
	else {
	    $f =$_[6];
	    open(FILE,"> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE $title."\n";
	    print FILE "\n================================================================\n";	   
	    print FILE $lang::MSG_MHN_POLYRHYTHM_MSG1." : ".join(';',@ratios_l)."\n";     
	    print FILE $lang::MSG_MHN_GENERAL2." : ".$nbobjects."\n";
	    print FILE $lang::MSG_MHN_GENERAL3." : ".$nbhands."\n";     
	    print FILE "================================================================\n\n";
	    close FILE;

	    &printMHNListWithoutHeaders(\@res,'', $f);

	    open(FILE,">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;   
	    print FILE "\n\n====> ".(scalar @res)." MHN(s) Generated\n ";
	    close FILE;
	    print colored [$common::COLOR_RESULT], "\n====> ".(scalar @res)." MHN(s) Generated\n ";
	}
    } 
    
    return \@res;        
}


sub printMHNListWithoutHeaders
{
    # For HTML generation use printMHNListHTML instead 
    
    my @flist= ();
    my $opts = $_[1];
    my $output = $_[2];
    my $filein = $_[3];

    if("JML:"=~substr(uc($_[2]),0,4))
    {
	my $f =substr($_[2],4);
	open(FILE,">> $conf::RESULTS/$f".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$f.jml> $lang::MSG_GENERAL_ERR1b") ;
	if($_[0] eq '')
	{
	    open(FILEIN, '<', $filein) || die ("$lang::MSG_GENERAL_ERR1 <$filein>") ;
	    while ( my $mhn = <FILEIN> ) {
		$mhn =~ s/\s+//g;
		&common::displayComputingPrompt();	    
		my $val = $mhn;
		$val =~ s/</&lt;/g;
		$val =~ s/>/&gt;/g;		
		
		if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
		{
		    print FILE "<line display=\'".$val."\' notation=\"siteswap\" pattern=\"pattern=$val";
		    print FILE ";colors=mixed;\" />\n";
		}
		else
		{
		    print FILE "<line display=\'".$val."\' notation=\"siteswap\">\n";
		    print FILE "pattern=$val";
		    print FILE ";colors=mixed;\n"; 
		    print FILE "</line>\n";				
		}
	    }
	    close FILEIN
	}
	else
	{
	    @flist = @{$_[0]};	
	    for(my $i=0; $i < scalar @flist; $i++)
	    {       	
		&common::displayComputingPrompt();	    
		my $val = $flist[$i];
		$val =~ s/</&lt;/g;
		$val =~ s/>/&gt;/g;		
		
		if($conf::JUGGLING_LAB_JML_VERSION eq "1.1")
		{
		    print FILE "<line display=\'".$val."\' notation=\"siteswap\" pattern=\"pattern=$val";
		    print FILE ";colors=mixed;\" />\n";
		}
		else
		{
		    print FILE "<line display=\'".$val."\' notation=\"siteswap\">\n";
		    print FILE "pattern=$val";
		    print FILE ";colors=mixed;\n"; 
		    print FILE "</line>\n";				
		}
	    }
	    &common::hideComputingPrompt();	    
	    close FILE;
	}
    }
    else
    {
	open(FILE,">> $conf::RESULTS/$output") || die ("$lang::MSG_GENERAL_ERR1 <$output> $lang::MSG_GENERAL_ERR1b") ;
	if($_[0] eq '')
	{
	    open(FILEIN, '<', $filein) || die ("$lang::MSG_GENERAL_ERR1 <$filein>") ;
	    while ( my $mhn = <FILEIN> ) {  	
		$mhn =~ s/\s+//g;
		&common::displayComputingPrompt();	  
		print FILE "$mhn\n";	
	    }
	}
	else {
	    @flist = @{$_[0]};	
	    for(my $i=0; $i < scalar @flist; $i++)
	    {
		&common::displayComputingPrompt();	  
		print FILE "$flist[$i]\n";	
	    }
	}
	&common::hideComputingPrompt();	    
	close FILE;
    }
}



sub printMHNListHTML
{    
    my $flist = $_[0];
    my @flistmhn_lowHeight = ();
    my @flistmhn_lowHeightJL = ();
    my @flistmjn = ();
    my @flistmjn_lowHeight = ();
    my @flistmjn_lowHeightJL = ();
    my $flistgen = '';
    my $f = $_[1].".html";    
    my $fjml = $_[1];
    my $fjml_lowHeight = $_[1]."_lowHeight";
    my $fjml_lowHeightJL = $_[1]."_lowHeightJL";
    my $newflistmhn = $_[1]."_mhn.txt";
    my $newflistmhn_lowHeight = $_[1]."_mhn_lowHeight.txt";
    my $newflistmhn_lowHeightJL = $_[1]."_mhn_lowHeightJL.txt";
    my $newflistmjn = $_[1]."_mjn.txt";
    my $newflistmjn_lowHeight = $_[1]."_mjn_lowHeight.txt";
    my $newflistmjn_lowHeightJL = $_[1]."_mjn_lowHeightJL.txt";
    my $title = $_[2];
    my $opts = $_[3];
    my $pwd = cwd();

    my $lower_height_list = 'N';      # Lower Heights in SS, i.e keep tempo but add extra Holding time    
    # Lower Heights in SS for Juggling Compatibility,
    # i.e keep tempo but add extra Holding time (only 1x, 2 combinations)
    my $lower_height_list_JL = 'N';
    
    my $MJN_print = 'N';
    my $MHNandMJN_print = 'N';
    my $splines_mode=2;          # 0: default, 1: curved, 2: line 
    my $quick = 'N';
    
    my $ret = &GetOptionsFromString(uc($opts),
				    "-M:s" => \$MJN_print,				    
				    "-B:s" => \$MHNandMJN_print,
				    "-F:i" => \$splines_mode,
				    "-Q:s" => \$quick,
				    "-L:s" => \$lower_height_list,
				    "-J:s" => \$lower_height_list_JL,
	);

    my $title_jml = $title;
    for(my $i=0;$i<length($title);$i++)
    {
	if(substr($title,$i,1) eq "=")
	{
	    $title_jml = substr($title,0,$i-1);
	    last;
	}
    }
    
    my $intro_jml = $title; 
    $intro_jml =~ s/\n/"\/>\n<line display="/g ;
    
    my $num = 1;
    while (-e "$conf::RESULTS/".$f || -e "$conf::RESULTS/".$fjml.".jml"
	   || -e "$conf::RESULTS/".$fjml_lowHeight.".jml" || -e "$conf::RESULTS/".$fjml_lowHeightJL.".jml"
	   || -e "$conf::RESULTS/".$newflistmhn || -e "$conf::RESULTS/".$newflistmjn
	   || -e "$conf::RESULTS/".$newflistmhn_lowHeight || -e "$conf::RESULTS/".$newflistmhn_lowHeightJL
	   || -e "$conf::RESULTS/".$newflistmjn_lowHeight || -e "$conf::RESULTS/".$newflistmjn_lowHeightJL
	)	
    {
	$f = $_[1]."-".$num.".html";
	$fjml = $_[1]."-".$num;
	$fjml_lowHeight = $_[1]."_lowHeight-".$num;
	$fjml_lowHeightJL = $_[1]."_lowHeightJL-".$num;
	$newflistmjn = $_[1]."_mjn-".$num.".txt";
	$newflistmjn_lowHeight = $_[1]."_mjn-".$num."_lowHeight.txt";
	$newflistmjn_lowHeightJL = $_[1]."_mjn-".$num."_lowHeightJL.txt";
	$newflistmhn = $_[1]."_mhn-".$num.".txt";
	$newflistmhn_lowHeight = $_[1]."_mhn-".$num."_lowHeight.txt";
	$newflistmhn_lowHeightJL = $_[1]."_mhn-".$num."_lowHeightJL.txt";
	$num ++;
    }

    my $run_browser = 1;
    my $cpt = 1;
    my $pics="pics_png.png";
    my $pics_true="pics_green_tick.png";
    my $pics_false="pics_red_negative.png";
    copy("./data/pics/".$pics,$conf::RESULTS."/".$pics);
    copy("./data/pics/".$pics_true,$conf::RESULTS."/".$pics_true);
    copy("./data/pics/".$pics_false,$conf::RESULTS."/".$pics_false);

    &common::gen_HTML_head1($f,$title_jml);
    
    # Generate a file with the mhn list if no file is provided as input
    if($flist eq '-1' || $flist eq '')
    {
	my $now = strftime('%Y%m%d%H%M%S',localtime);	
	$flistgen = "$pwd/".$conf::TMPDIR."/printMHNListHTML-".$now.".txt";
	my @list = @{$_[4]};
	open(FILELIST, '>', "$flistgen") or die ("$lang::MSG_GENERAL_ERR1 <$flistgen> $lang::MSG_GENERAL_ERR1b") ;
	for(my $i =0; $i < scalar @list; $i++)
	{
	    print FILELIST $list[$i]."\n";
	}
	close FILELIST;
	$flist = $flistgen;
    }
    
    open(FILEIN, '<', $flist) || die ("$lang::MSG_GENERAL_ERR1 <$flist>") ;
    open(HTML, ">> $conf::RESULTS/$f") || die ("$lang::MSG_GENERAL_ERR1 <$f> $lang::MSG_GENERAL_ERR1b") ;
    
    print HTML "\n";
    if(uc($LINK_GUNSWAP) eq 'Y')
    {
	print HTML "<script type=\"text/javascript\" src=\"/js/visualisation_siteswap.js\"></script>\n\n";
    }

    print HTML "<BODY>\n";
    my $title_html = $title;
    $title_html =~ s/\n/<br\/>\n/g;
    print HTML "<p>&nbsp;</p><h1>".$title_html."</h1><p>&nbsp;</p>\n";    
    print HTML "\n\n\n";    
    
    print HTML "<p><table border=\"0\" >"."\n";

    print HTML "<tr><td COLSPAN=4></td>"."\n";
    if(uc($lower_height_list) eq 'Y')
    {
	print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Extra Holding Time"."</td>"."\n";
    }    
    if(uc($lower_height_list_JL) eq 'Y')
    {
	print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Split Extra Holding Time for JL"."</td>"."\n";
    }    
    
    if(uc($MHNandMJN_print) eq 'Y')
    {
	print HTML "<td COLSPAN=3>&nbsp;</td>"."\n";
	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Extra Holding Time"."</td>"."\n";
	}    
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td COLSPAN=3 class=table_header>"."Same Tempo/Split Extra Holding Time for JL"."</td>"."\n";
	}    
    }
    
    print HTML "</tr>\n<tr><td COLSPAN=1></td>"."\n";
    
    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N' )
    {
	print HTML "<td class=table_header>"."MHN"."</td>"."\n";	    	    
	print HTML "<td class=table_header>"."MHN Diagram"."</td>"."\n";
	print HTML "<td class=table_header>"."Valid"."</td>"."\n";

 	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td class=table_header>"."MHN"."</td>"."\n";	    	    
	    print HTML "<td class=table_header>"."MHN Diagram"."</td>"."\n";
	    print HTML "<td class=table_header>"."Valid"."</td>"."\n";
	}    
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td class=table_header>"."MHN"."</td>"."\n";	    	    
	    print HTML "<td class=table_header>"."MHN Diagram"."</td>"."\n";
	    print HTML "<td class=table_header>"."Valid"."</td>"."\n";
	}    
    }
    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y')
    {	
	print HTML "<td class=table_header>"."MJN"."</td>"."\n";
	print HTML "<td class=table_header>"."MJN Diagram"."</td>"."\n";
	print HTML "<td class=table_header>"."Valid"."</td>"."\n";

	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td class=table_header>"."MJN"."</td>"."\n";
	    print HTML "<td class=table_header>"."MJN Diagram"."</td>"."\n";
	    print HTML "<td class=table_header>"."Valid"."</td>"."\n";
	}    
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td class=table_header>"."MJN"."</td>"."\n";
	    print HTML "<td class=table_header>"."MJN Diagram"."</td>"."\n";
	    print HTML "<td class=table_header>"."Valid"."</td>"."\n";
	}    
    }
    print HTML "</tr>"."\n";

    while ( my $mhn = <FILEIN> ) {  	
	$mhn =~ s/\s+//g;

	if($mhn ne '' && $mhn !~ m/=>/)
	{
	    print HTML "<tr>"."\n";	    	    
	    print HTML "<td class=table_header>$cpt</td>"."\n";

	    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N')
	    {
		print HTML "<td class=table_content>".$mhn."</td>"."\n";
		my $mhn_f = $mhn;
		$mhn_f =~ s/:/=/g;
		&draw($mhn, $mhn_f.".png", "-f $splines_mode -q $quick");
		print HTML "<td class=table_content><a href=\"".$mhn_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$mhn_f.".png\" width=\"25\"/></a></td>"."\n";
		if(&isValid($mhn,-1) > 0)
		{
		    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
		}
		else
		{
		    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
		}

		my $lower = '';
		my $lowerJL = '';
		if(uc($lower_height_list) eq 'Y')
		{
		    $lower = &lowerHeightOnTempo($mhn,'',-1);
		    push(@flistmhn_lowHeight, $lower);

		    if($lower ne $mhn)
		    {
			print HTML "<td class=table_content>".$lower."</td>"."\n";
			my $lower_f = $lower;
			$lower_f =~ s/:/=/g;
			&draw($lower, $lower_f.".png", "-f $splines_mode -q $quick");
			print HTML "<td class=table_content><a href=\"".$lower_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$lower_f.".png\" width=\"25\"/></a></td>"."\n";
			if(&isValid($lower,-1) > 0)
			{
			    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
			}
			else
			{
			    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
			}
		    }
		    else
		    {
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
		    }
		    
		}
		
		if(uc($lower_height_list_JL) eq 'Y')
		{
		    $lowerJL = &lowerHeightOnTempo($mhn,'-J Y',-1);
		    push(@flistmhn_lowHeightJL, $lowerJL);

		    if($lowerJL ne $mhn && $lowerJL ne $lower)
		    {
			print HTML "<td class=table_content>".$lowerJL."</td>"."\n";
			my $lower_f = $lowerJL;
			$lower_f =~ s/:/=/g;
			&draw($lowerJL, $lower_f.".png", "-f $splines_mode -q $quick");
			print HTML "<td class=table_content><a href=\"".$lower_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$lower_f.".png\" width=\"25\"/></a></td>"."\n";
			if(&isValid($lowerJL,-1) > 0)
			{
			    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
			}
			else
			{
			    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
			}
		    }
		    else
		    {
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
		    }
		}		
	    }
	    
	    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y')
	    {
		my $mjn = &toMJN($mhn,'',-1);
		push(@flistmjn, $mjn);
		
		if(uc($LINK_GUNSWAP) eq 'Y')
		{
		    print HTML "<td class=table_content><a href=\"javascript:visualiserSiteswap('$mjn')\">$mjn</a></td>"."\n";
		}
		elsif(uc($LINK_JUGGLINGLAB_GIF) eq 'Y')
		{		
		    print HTML "<td class=table_content><a href=\"https://jugglinglab.org/anim?pattern=$mjn;colors=mixed\" target=\"_blank\">$mjn</a></td>"."\n";
		}		      
		else
		{
		    print HTML "<td class=table_content>".$mjn."</td>"."\n";
		}

		my $mjn_f = $mjn;
		$mjn_f =~ s/</{/g;
		$mjn_f =~ s/>/}/g;
		$mjn_f =~ s/\//#/g;
		$mjn_f =~ s/\|/;/g;

		&MJN::draw($mjn, $mjn_f.".png","");
		print HTML "<td class=table_content><a href=\"".$mjn_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$mjn_f.".png\" width=\"25\"/></a></td>"."\n";
		if(&MJN::isValid($mjn,-1) > 0)
		{
		    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
		}
		else
		{
		    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
		}

		my $lower = '';
		my $lowerJL = '';
		
		if(uc($lower_height_list) eq 'Y')
		{
		    $lower = &toMJN(&lowerHeightOnTempo($mhn,'',-1),'',-1);
		    push(@flistmjn_lowHeight, $lower);

		    if($lower ne $mjn)
		    {
			if(uc($LINK_GUNSWAP) eq 'Y')
			{
			    print HTML "<td class=table_content><a href=\"javascript:visualiserSiteswap('$lower')\">$mjn</a></td>"."\n";
			}
			elsif(uc($LINK_JUGGLINGLAB_GIF) eq 'Y')
			{		
			    print HTML "<td class=table_content><a href=\"https://jugglinglab.org/anim?pattern=$mjn;colors=mixed\" target=\"_blank\">$lower</a></td>"."\n";
			}		      
			else
			{
			    print HTML "<td class=table_content>".$lower."</td>"."\n";
			}
			
			my $lower_f = $lower;
			$lower_f =~ s/</{/g;
			$lower_f =~ s/>/}/g;
			$lower_f =~ s/\//#/g;
			$lower_f =~ s/\|/;/g;
			
			&MJN::draw($lower, $lower_f.".png", "-f $splines_mode -q $quick");
			print HTML "<td class=table_content><a href=\"".$lower_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$lower_f.".png\" width=\"25\"/></a></td>"."\n";
			if(&MJN::isValid($lower,-1) > 0)
			{
			    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
			}
			else
			{
			    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
			}
		    }
		    else
		    {
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
		    }

		}
		
		if(uc($lower_height_list_JL) eq 'Y')
		{
		    $lowerJL = &toMJN(&lowerHeightOnTempo($mhn,'-J Y',-1),'',-1);
		    push(@flistmjn_lowHeightJL, $lowerJL);

		    if($lowerJL ne $mjn && $lowerJL ne $lower)
		    {
			if(uc($LINK_GUNSWAP) eq 'Y')
			{
			    print HTML "<td class=table_content><a href=\"javascript:visualiserSiteswap('$lowerJL')\">$mjn</a></td>"."\n";
			}
			elsif(uc($LINK_JUGGLINGLAB_GIF) eq 'Y')
			{		
			    print HTML "<td class=table_content><a href=\"https://jugglinglab.org/anim?pattern=$mjn;colors=mixed\" target=\"_blank\">$lowerJL</a></td>"."\n";
			}		      
			else
			{
			    print HTML "<td class=table_content>".$lowerJL."</td>"."\n";
			}
			
			my $lower_f = $lowerJL;
			$lower_f =~ s/</{/g;
			$lower_f =~ s/>/}/g;
			$lower_f =~ s/\//#/g;
			$lower_f =~ s/\|/;/g;		    
			
			&MJN::draw($lowerJL, $lower_f.".png", "-f $splines_mode -q $quick");
			print HTML "<td class=table_content><a href=\"".$lower_f.".png\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$lower_f.".png\" width=\"25\"/></a></td>"."\n";
			if(&MJN::isValid($lowerJL,-1) > 0)
			{
			    print HTML "<td class=table_content><img src=\"".$pics_true."\" alt=\"True\" width=\"35\"/></td>"."\n"; 
			}
			else
			{
			    print HTML "<td class=table_content><img src=\"".$pics_false."\" alt=\"False\" width=\"35\"/></td>"."\n"; 
			}
		    }
		    else
		    {
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
			print HTML "<td class=table_content>&nbsp;</td>"."\n";
		    }		
		}
	    }
	    
	    print HTML "</tr>"."\n";
	    $cpt++;
	}
    }
    
    close(FILEIN); 
    
    print HTML "<tr>"."\n";
    print HTML "<td class=table_header>JML File</td>";
    
    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N')
    {
	print HTML "<td COLSPAN=3 class=table_content>&nbsp;</td>"."\n";
	open(FILE_TXT_MHN,"> $conf::RESULTS/$newflistmhn") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn> $lang::MSG_GENERAL_ERR1b");
	print FILE_TXT_MHN $title."\n\n";
	close FILE_TXT_MHN;

	&printMHNListWithoutHeaders('','', "$newflistmhn",$flist);

	open(FILE_TXT_MHN,">> $conf::RESULTS/$newflistmhn") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn> $lang::MSG_GENERAL_ERR1b");
	print FILE_TXT_MHN "\n   [ => ".($cpt-1)." MHN(s) ]"."\n\n";     
	print FILE_TXT_MHN "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	close FILE_TXT_MHN;

	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td COLSPAN=3 class=table_content>&nbsp;</td>"."\n";
	    open(FILE_TXT_MHN_LOWHEIGHT,"> $conf::RESULTS/$newflistmhn_lowHeight") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn_lowHeight> $lang::MSG_GENERAL_ERR1b");
	    print FILE_TXT_MHN_LOWHEIGHT $title."\n\n";
	    close FILE_TXT_MHN_LOWHEIGHT;

	    &printMHNListWithoutHeaders(\@flistmhn_lowHeight,'', "$newflistmhn_lowHeight");

	    open(FILE_TXT_MHN_LOWHEIGHT,">> $conf::RESULTS/$newflistmhn_lowHeight") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn_lowHeight> $lang::MSG_GENERAL_ERR1b");
	    print FILE_TXT_MHN_LOWHEIGHT "\n   [ => ".($cpt-1)." MHN(s) ]"."\n\n";     
	    print FILE_TXT_MHN_LOWHEIGHT "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	    close FILE_TXT_MHN_LOWHEIGHT;
	}
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td COLSPAN=3 class=table_content>&nbsp;</td>"."\n";
	    open(FILE_TXT_MHN_LOWHEIGHTJL,"> $conf::RESULTS/$newflistmhn_lowHeightJL") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn_lowHeightJL> $lang::MSG_GENERAL_ERR1b");
	    print FILE_TXT_MHN_LOWHEIGHTJL $title."\n\n";
	    close FILE_TXT_MHN_LOWHEIGHTJL;
	    
	    &printMHNListWithoutHeaders(\@flistmhn_lowHeightJL,'', "$newflistmhn_lowHeightJL");

	    open(FILE_TXT_MHN_LOWHEIGHTJL,">> $conf::RESULTS/$newflistmhn_lowHeightJL") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmhn_lowHeightJL> $lang::MSG_GENERAL_ERR1b");
	    print FILE_TXT_MHN_LOWHEIGHTJL "\n   [ => ".($cpt-1)." MHN(s) ]"."\n\n";     
	    print FILE_TXT_MHN_LOWHEIGHTJL "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	    close FILE_TXT_MHN_LOWHEIGHTJL;
	}		
    }

    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y')
    {	
	open(FILE_JML,"> $conf::RESULTS/$fjml".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml.jml> $lang::MSG_GENERAL_ERR1b");
	open(FILE_TXT_MJN,"> $conf::RESULTS/$newflistmjn") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn> $lang::MSG_GENERAL_ERR1b");

	print FILE_JML "<?xml version=\"1.0\"?>\n";
	print FILE_JML "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	print FILE_JML "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	print FILE_JML "<patternlist>\n";
	print FILE_JML "<title>".$title_jml."</title>\n";
	print FILE_JML "<line display=\"".$intro_jml."\""."/>\n";	   
	print FILE_JML "<line display=\"\"/>\n";	   
	close FILE_JML;

	print FILE_TXT_MJN $title."\n\n";
	close FILE_TXT_MJN;
	
	&printMHNListWithoutHeaders(\@flistmjn,'', "JML:$fjml");
	&printMHNListWithoutHeaders(\@flistmjn,'', "$newflistmjn");

	open(FILE_JML,">> $conf::RESULTS/$fjml".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml.jml> $lang::MSG_GENERAL_ERR1b") ;
	open(FILE_TXT_MJN,">> $conf::RESULTS/$newflistmjn") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn> $lang::MSG_GENERAL_ERR1b") ;

	print FILE_JML "<line display=\"\" />\n";
	print FILE_JML "<line display=\"   [ => ".($cpt-1)." MJN(s) ]"."\"/>\n";     
	print FILE_JML "<line display=\"\" />\n";
	print FILE_JML "<line display=\"----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\" />\n";		
	print FILE_JML "</patternlist>\n";
	print FILE_JML "</jml>\n";
	close FILE_JML;
	
	print FILE_TXT_MJN "\n   [ => ".($cpt-1)." MJN(s) ]"."\n\n";     
	print FILE_TXT_MJN "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	close FILE_TXT_MJN;

	print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjml.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjml.".jml"."\" width=\"25\"/></a>"."</td>\n";

	if(uc($lower_height_list) eq 'Y')
	{
	    open(FILE_JML_LOWHEIGHT,"> $conf::RESULTS/$fjml_lowHeight".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml_lowHeight.jml> $lang::MSG_GENERAL_ERR1b");
	    open(FILE_TXT_MJN_LOWHEIGHT,"> $conf::RESULTS/$newflistmjn_lowHeight") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn_lowHeight> $lang::MSG_GENERAL_ERR1b");
	    
	    print FILE_JML_LOWHEIGHT "<?xml version=\"1.0\"?>\n";
	    print FILE_JML_LOWHEIGHT "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML_LOWHEIGHT "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML_LOWHEIGHT "<patternlist>\n";
	    print FILE_JML_LOWHEIGHT "<title>".$title_jml."</title>\n";
	    print FILE_JML_LOWHEIGHT "<line display=\"".$intro_jml."\""."/>\n";	   
	    print FILE_JML_LOWHEIGHT "<line display=\"\"/>\n";	   
	    close FILE_JML_LOWHEIGHT;
	    
	    print FILE_TXT_MJN_LOWHEIGHT $title."\n\n";
	    close FILE_TXT_MJN_LOWHEIGHT;
	    
	    &printMHNListWithoutHeaders(\@flistmjn_lowHeight,'', "JML:$fjml_lowHeight");
	    &printMHNListWithoutHeaders(\@flistmjn_lowHeight,'', "$newflistmjn_lowHeight");

	    open(FILE_JML_LOWHEIGHT,">> $conf::RESULTS/$fjml_lowHeight".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml_lowHeight.jml> $lang::MSG_GENERAL_ERR1b") ;
	    open(FILE_TXT_MJN_LOWHEIGHT,">> $conf::RESULTS/$newflistmjn_lowHeight") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn_lowHeight> $lang::MSG_GENERAL_ERR1b") ;
	    
	    print FILE_JML_LOWHEIGHT "<line display=\"\" />\n";
	    print FILE_JML_LOWHEIGHT "<line display=\"   [ => ".($cpt-1)." MJN(s) ]"."\"/>\n";     
	    print FILE_JML_LOWHEIGHT "<line display=\"\" />\n";
	    print FILE_JML_LOWHEIGHT "<line display=\"----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\" />\n";		
	    print FILE_JML_LOWHEIGHT "</patternlist>\n";
	    print FILE_JML_LOWHEIGHT "</jml>\n";
	    close FILE_JML_LOWHEIGHT;
	    
	    print FILE_TXT_MJN_LOWHEIGHT "\n   [ => ".($cpt-1)." MJN(s) ]"."\n\n";     
	    print FILE_TXT_MJN_LOWHEIGHT "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	    close FILE_TXT_MJN_LOWHEIGHT;

	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjml_lowHeight.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjml_lowHeight.".jml"."\" width=\"25\"/></a>"."</td>\n";

	}
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    open(FILE_JML_LOWHEIGHTJL,"> $conf::RESULTS/$fjml_lowHeightJL".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml_lowHeightJL.jml> $lang::MSG_GENERAL_ERR1b");
	    open(FILE_TXT_MJN_LOWHEIGHTJL,"> $conf::RESULTS/$newflistmjn_lowHeightJL") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn_lowHeightJL> $lang::MSG_GENERAL_ERR1b");
	    
	    print FILE_JML_LOWHEIGHTJL "<?xml version=\"1.0\"?>\n";
	    print FILE_JML_LOWHEIGHTJL "<!DOCTYPE jml SYSTEM \"file://jml.dtd\">\n";
	    print FILE_JML_LOWHEIGHTJL "<jml version=\"".$conf::JUGGLING_LAB_JML_VERSION."\">\n";
	    print FILE_JML_LOWHEIGHTJL "<patternlist>\n";
	    print FILE_JML_LOWHEIGHTJL "<title>".$title_jml."</title>\n";
	    print FILE_JML_LOWHEIGHTJL "<line display=\"".$intro_jml."\""."/>\n";	   
	    print FILE_JML_LOWHEIGHTJL "<line display=\"\"/>\n";	   
	    close FILE_JML_LOWHEIGHTJL;

	    print FILE_TXT_MJN_LOWHEIGHTJL $title."\n\n";
	    close FILE_TXT_MJN_LOWHEIGHTJL;

	    &printMHNListWithoutHeaders(\@flistmjn_lowHeightJL,'', "JML:$fjml_lowHeightJL");
	    &printMHNListWithoutHeaders(\@flistmjn_lowHeightJL,'', "$newflistmjn_lowHeightJL");
	    
	    open(FILE_JML_LOWHEIGHTJL,">> $conf::RESULTS/$fjml_lowHeightJL".".jml") || die ("$lang::MSG_GENERAL_ERR1 <$fjml_lowHeightJL.jml> $lang::MSG_GENERAL_ERR1b") ;
	    open(FILE_TXT_MJN_LOWHEIGHTJL,">> $conf::RESULTS/$newflistmjn_lowHeightJL") || die ("$lang::MSG_GENERAL_ERR1 <$newflistmjn_lowHeightJL> $lang::MSG_GENERAL_ERR1b") ;
	    
	    print FILE_JML_LOWHEIGHTJL "<line display=\"\" />\n";
	    print FILE_JML_LOWHEIGHTJL "<line display=\"   [ => ".($cpt-1)." MJN(s) ]"."\"/>\n";     
	    print FILE_JML_LOWHEIGHTJL "<line display=\"\" />\n";
	    print FILE_JML_LOWHEIGHTJL "<line display=\"----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\" />\n";		
	    print FILE_JML_LOWHEIGHTJL "</patternlist>\n";
	    print FILE_JML_LOWHEIGHTJL "</jml>\n";
	    close FILE_JML_LOWHEIGHTJL;
	    
	    print FILE_TXT_MJN_LOWHEIGHTJL "\n   [ => ".($cpt-1)." MJN(s) ]"."\n\n";     
	    print FILE_TXT_MJN_LOWHEIGHTJL "----------- Creation : JugglingTB (Module MHN $MHN_VERSION)\n";			
	    close FILE_TXT_MJN_LOWHEIGHTJL;

	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$fjml_lowHeightJL.".jml"."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$fjml_lowHeightJL.".jml"."\" width=\"25\"/></a>"."</td>\n";
	}
	
    }
    
    print HTML "</tr>"."\n";

    print HTML "<tr>"."\n";
    print HTML "<td class=table_header>TXT File</td>";

    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'N' )
    {
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmhn."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmhn."\" width=\"25\"/></a>"."</td>\n";
	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmhn_lowHeight."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmhn_lowHeight."\" width=\"25\"/></a>"."</td>\n";
	}
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmhn_lowHeightJL."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmhn_lowHeightJL."\" width=\"25\"/></a>"."</td>\n";
	}
    }
    
    if(uc($MHNandMJN_print) eq 'Y' || uc($MJN_print) eq 'Y' )
    {
	print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmjn."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmjn."\" width=\"25\"/></a>"."</td>\n";
	if(uc($lower_height_list) eq 'Y')
	{
	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmjn_lowHeight."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmjn_lowHeight."\" width=\"25\"/></a>"."</td>\n";
	}
	if(uc($lower_height_list_JL) eq 'Y')
	{
	    print HTML "<td class=table_content COLSPAN=3><a href=\"".$newflistmjn_lowHeightJL."\" target=\"_blank\"><img src=\"".$pics."\" alt=\"".$newflistmjn_lowHeightJL."\" width=\"25\"/></a>"."</td>\n";
	}
    }
    
    print HTML "</tr>"."\n";
    print HTML "</table></p>"."\n";

    
    print HTML "<p>&nbsp;</p><p>-- Creation : JugglingTB, Module MHN $MHN_VERSION --</p><p>&nbsp;</p>\n";
    print HTML "</BODY>\n";
    close HTML;

    if(($_[0] eq '-1' || $_[0] eq '') && $MHN_DEBUG <= 0)
    {
	unlink $flistgen;
    }
    
    if ($run_browser == 1 && $conf::jtbOptions_r == 1)
    {
	if ($common::OS eq "MSWin32") {
	    system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/$conf::RESULTS/$f");
	} else {
	    # Unix-like OS
	    system("$conf::HTTP_BROWSER ${pwd}/$conf::RESULTS/$f &");
	}		
    }

    
    print colored [$common::COLOR_RESULT], "\n\n====> ".($cpt-1)." MHNs Generated\n ";

}


sub lowerHeightOnTempo
{
    my $mhn = lc($_[0]);
    $mhn =~ s/\s+//g;

    my $free_beat = 1;
    my $min_heigh_same_hand = 3;
    my $jugglinglab_interop = 'N';
    
    my $ret = &GetOptionsFromString(uc($_[1]),
				    # Set number of free Beats between Throws on same hand upon lowering height. Default is 1 Since Dwell time is ~1 also
				    "-F:i" => \$free_beat,
				    # Do not lower SS on same hand more than defined throw. Default is 3 to avoid to transform throw in hold 
				    "-M:i" => \$min_heigh_same_hand,
				    # Set to Y to set new holding time as 1x, 2 combination. Useful for viewing in JugglingLab 
				    "-J:s" => \$jugglinglab_interop,				    
	);


    my @matrix=@{&__toMHNmatrix($mhn)};    
    my $period = &getPeriod($mhn,-1);
    my $nbhands = &getHandsNumber($mhn,-1);

    my @matrix_res = @{&__emptyMatrix($nbhands,$period)};
    
    for (my $i=0; $i < $nbhands; $i++)
    {
	for (my $j=0 ; $j < $period; $j++)
	{
	    my $val=$matrix[$i][$j];
	    if($val ne '0')
	    {
		for (my $k=0; $k < length($val); $k++)
		{
		    if($k+1 < length($val) && substr($val,$k+1,1) eq ':')
		    {
			my $dest = hex(substr($val,$k+2,1));
			my $new_catch_back = 0;
			
			for (my $l = $j+hex(substr($val,$k,1))-1; $l > $j; $l --)
			{
			    if($matrix[$dest][$l%$period] eq '0')
			    {
				$new_catch_back ++;				
			    }
			    else
			    {
				last;
			    }
			}

			if($new_catch_back > $free_beat)
			{
			    $new_catch_back -= $free_beat;
			}
			else
			{
			    $new_catch_back = 0;
			}
			
			if($dest == $i)
			{
			    if(hex(substr($val,$k,1)) - $new_catch_back < $min_heigh_same_hand && $new_catch_back != 0)
			    {
				$new_catch_back = $new_catch_back - ($min_heigh_same_hand - (hex(substr($val,$k,1)) - $new_catch_back));
			    }
			    $matrix_res[$i][$j] = sprintf("%X", hex(substr($val,$k,1)) - $new_catch_back);
			}
			else
			{
			    $matrix_res[$i][$j] = sprintf("%X", hex(substr($val,$k,1)) - $new_catch_back).':'.$dest;
			}
			if($jugglinglab_interop eq 'N' && $new_catch_back != 0)
			{
			    $matrix_res[$dest][($j + hex(substr($val,$k,1)) - $new_catch_back)%$period] = sprintf("%X",$new_catch_back);
			}
			elsif($new_catch_back != 0)
			{
			    my $cpt = int($new_catch_back / 2);
			    for(my $m=0; $m < $cpt; $m++)
			    {
				$matrix_res[$dest][($j + hex(substr($val,$k,1)) + $m*2 -$new_catch_back)%$period] = '2';
			    }
			    if($new_catch_back % 2 != 0)
			    {
				$matrix_res[$dest][($j + hex(substr($val,$k,1)) + $cpt*2 -$new_catch_back)%$period] = '1';
			    }
			}
			$k+=2;
		    }
		    else
		    {
			my $dest = $i;
			my $new_catch_back = 0;
			
			for (my $l = $j+hex(substr($val,$k,1))-1; $l > $j; $l --)
			{			    
			    if($matrix[$dest][$l%$period] eq '0')
			    {
				$new_catch_back ++;
			    }
			    else
			    {
				last;
			    }
			}

			if($new_catch_back > $free_beat)
			{
			    $new_catch_back -= $free_beat;
			}
			else
			{
			    $new_catch_back = 0;
			}

			if(hex(substr($val,$k,1)) - $new_catch_back < $min_heigh_same_hand && $new_catch_back != 0)
			{
			    $new_catch_back = $new_catch_back - ($min_heigh_same_hand - (hex(substr($val,$k,1)) - $new_catch_back));
			}

			$matrix_res[$i][$j] = sprintf("%X", hex(substr($val,$k,1)) - $new_catch_back);
			if($jugglinglab_interop eq 'N' && $new_catch_back != 0)
			{
			    $matrix_res[$dest][($j + hex(substr($val,$k,1)) - $new_catch_back)%$period] = sprintf("%X",$new_catch_back);
			}
			elsif($new_catch_back != 0)
			{
			    my $cpt = int($new_catch_back / 2);
			    for(my $m=0; $m < $cpt; $m++)
			    {
				$matrix_res[$dest][($j + hex(substr($val,$k,1)) + $m*2 -$new_catch_back)%$period] = '2';
			    }
			    if($new_catch_back % 2 != 0)
			    {
				$matrix_res[$dest][($j + hex(substr($val,$k,1)) + $cpt*2 -$new_catch_back)%$period] = '1';
			    }
			}
		    }
		}	
	    }	    	    
	}
    }

    my $res=&__matrixToStr(\@matrix_res);
    
    if ((scalar @_ == 2) || ($_[2] ne "-1")) {
	print colored [$common::COLOR_RESULT], $res."\n";
    }

    return $res;
}



#################################################
#  Test function to generate Polyrhythms Lists for 4 Hands
#################################################
sub __test_polyrhythm_list_4hands_gen
{
    for(my $i=1; $i <= 4; $i++) {
	for(my $a=1; $a <= 4; $a++) {
	    for(my $b=1; $b <= 4; $b++) {
		for(my $c=1; $c <= 4; $c++) {
		    for(my $d=1; $d <= 4; $d++) {
			for(my $e=1; $e <= 4; $e++) {
			    for(my $f=1; $f <= 4; $f++) {
				my $filename = 'polyrhythms-MHN-4hands-'.$i.'objects_'.$a.'!'.$b.'_'.$c.'!'.$d.'_'.$e.'!'.$f.'.txt';
				print "\n==== ".$filename.' ===='."\n";
				&genPolyrhythm(4,$i,'f',"$a:$b,$c:$d,$e:$f",'','-b Y -l Y -j y',$filename);		
			    }
			}
		    }
		}
	    }
	}
    }
}




1;
