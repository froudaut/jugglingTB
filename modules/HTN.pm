#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## HTN.pm   - Harmonic Throws Notation (3-Layers Notation) for jugglingTB   ##
##                                                                          ##
##                                                                          ##
## Copyright (C) 2015-2021  Frederic Roudaut  <frederic.roudaut@free.fr>    ##
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


package HTN;
use common;
use strict;
use lang;
use Cwd;
use Term::ANSIColor;        
use Chart::Gnuplot;
use Getopt::Long qw(GetOptionsFromString);
Getopt::Long::Configure ("ignorecase_always");

$Term::ANSIColor::AUTORESET = 1;


&lang::initLang();

our $HTN_INFO = "Harmonic Throws Notation (3-Layers Notation)";
our $HTN_HELP = $lang::MSG_HTN_MENU_HELP;
our $HTN_VERSION = "v0.6";

our %HTN_CMDS = 
    (    
	 'drawGrid'                  => ["$lang::MSG_HTN_MENU_DRAWGRID_1", "$lang::MSG_HTN_MENU_DRAWGRID_2"],
	 'HTNMaker'                  => ["$lang::MSG_HTN_MENU_HTNMAKER_1", "$lang::MSG_HTN_MENU_HTNMAKER_2"],
    );

print "HTN $HTN::HTN_VERSION loaded\n";

# To add debug behaviour 
our $HTN_DEBUG=-1;

my $PERIOD_MAX = 10;


# Internal Usage :  Take a chain of throws and split it into a Base 10 list in increasing order, removing X if present
sub _split_throws
{
    my $ss_chain = $_[0];
    my @res_throw = ();
    my @res_throw_in = ();
    my @res_throw_type = ();

    my $val_YShift = $_[1];

    for (my $i = 0; $i < length($ss_chain); $i++) {
	my $val = ''.hex(substr($ss_chain,$i,1));
	if ($i+1 <length($ss_chain) && uc(substr($ss_chain,$i+1,1)) eq 'X') {
	    $val = $val."X";
	    $i++;
	}
	
	push @res_throw_in, $val
    }

    @res_throw_in = sort @res_throw_in;
    	
    for (my $i = 0; $i < scalar(@res_throw_in); $i++) {
	my $val = $res_throw_in[$i];
	if(length($val)>1 && uc(substr($val,length($val)-1,1)) eq 'X')
	{
	    if (substr($val,0,length($val)-1) % 2 == 0)
	    {
		# Opposite Hand Throw
		push @res_throw_type, 1;
	    }
	    else
	    {
		# Same Hand Throw
		push @res_throw_type, 0;
	    }

	    $val = substr($val,0,length($val)-1);
	    push @res_throw, $val;
	}
	else
	{
	    if($val % 2 == 0)
	    {
		# Same Hand Throw
		push @res_throw_type, 0;
	    }
	    else
	    {
		# Opposite Hand Throw
		push @res_throw_type, 1;
	    }
	    push @res_throw, $val;
	}

    }

    if ($HTN_DEBUG >= 1) {
	print "== HTN::__split_throw : == RES_THROW ==\n";
	for (my $i = 0; $i < scalar @res_throw; $i++)
	{
	    print $res_throw[$i]." ";
	}
	print "\n";
	print "== HTN::__split_throw : == RES_THROW TYPE ==\n";
	for (my $i = 0; $i < scalar @res_throw_type; $i++)
	{
	    print $res_throw_type[$i]." ";    
	}
	print "\n";
    }
    
    return (\@res_throw,\@res_throw_type);
}


# Internal Usage :
#    - Adjust all the Throws heights to avoid overlap in the drawing 
#    - Draw the lines between sync Throws
#    - Draw the staples between hurries Throws
sub _compute_points
{
    my %matrix = %{$_[0]};
    my $circle_radius = $_[1];
    my $val_YShift = $_[2];
    my $staple_height = $_[3];
    my $staple_color = $_[4];
    my $sync_color = $_[5];
    my $chart = $_[6];
    my @points_same_hand_throw = ();
    my @points_opp_hand_throw = ();

    # Adjust All the Throw heights to avoid overlap in the drawing
    foreach my $key (keys(%matrix)) {
	my @beat = @{$matrix{$key}};
	
	for(my $i=0; $i < scalar @beat; $i++)
	{
	    my $val_init = $beat[$i][2];
	    my $max = int($val_init) + 1;
	    
	    for(my $j = $i+1; $j < scalar @beat; $j++)
	    {
		if($beat[$j][2] == $val_init)
		{
		    if($beat[$j][2] + $val_YShift >= $max)
		    {
			print colored [$common::COLOR_ERR], $lang::MSG_HTN_ERR_OVERLAP_1." : ".$val_YShift."\n";
			last;
		    }
		    else
		    {		
			$beat[$j][2] += $val_YShift;
		    }
		}		
	    }
	}

    }

    foreach my $key (keys(%matrix)) {
	my @beat = @{$matrix{$key}};

	for(my $i = 0; $i < scalar @beat; $i++)
	{
	    my $val = [$key,$beat[$i][2],$circle_radius];	    
	    if($beat[$i][3] == 0)	    
	    {
		push @points_same_hand_throw, $val;
	    }
	    else
	    {
		push @points_opp_hand_throw, $val;
	    }
	    
	    # We have to draw a lign for sync with every corresponding Circle in previous beat	    
	    if(scalar @{$beat[$i][4]} > 0 && $key > 0)
	    {		
		my @prev_beat = @{$matrix{$key-1}};
		for(my $j = 0; $j < scalar @prev_beat; $j++)
		{
		    for (my $k = 0; $k < scalar @{$beat[$i][4]}; $k++)
		    {
			if($beat[$i][4][$k] == $prev_beat[$j][0])
			{
			    # Add the line
			    # Until now we draw a line even when the 1st throw is 0 (if no other available), since the notation does not consider such case
			    if ($beat[$i][2] != 0)
			    {
				$chart->line(
				    from  => ''.$key.', '.$beat[$i][2],
				    to    => ''.($key-1).', '.$prev_beat[$j][2],
				    width => 5,
				    color => $sync_color);
			    }
			}	       
		    }
		
		}	    
	    }

	    # We have to draw a staple for hurries with every corresponding Circle in previous beat. (Ie with the same real beat)
	    if(scalar @{$beat[$i][5]} > 0 && $key > 0)
	    {		
	    	my @prev_beat = @{$matrix{$key-1}};
	    	for(my $j = 0; $j < scalar @prev_beat; $j++)
	    	{
	    	    for (my $k = 0; $k < scalar @{$beat[$i][5]}; $k++)
	    	    {
	    		if($beat[$i][5][$k] == $prev_beat[$j][1])
	    		{
	    		    # Add the staple
	    		    # Until now we were drawing a line even when the 1s throw is 0 (if no other available), since the notation does not consider such case
			    if ($beat[$i][2] != 0)
			    {
				$chart->line(
				    from  => ''.$key.', '.$beat[$i][2],
				    to    => ''.$key.', '.($beat[$i][2]-$staple_height),
				    width => 5,
				    color => $staple_color);

				$chart->line(
				    from  => ''.$key.', '.($beat[$i][2]-$staple_height),
				    to    => ''.($key-1).', '.($prev_beat[$j][2]-$staple_height),
				    width => 5,
				    color => $staple_color);

				$chart->line(
				    from  => ''.($key-1).', '.$prev_beat[$j][2],
				    to    => ''.($key-1).', '.($prev_beat[$j][2]-$staple_height),
				    width => 5,
				    color => $staple_color);
			    }
	    		}	       
	    	    }
		
	    	}	    
	    }	    
	}
    }
        
    return (\@points_same_hand_throw,\@points_opp_hand_throw);
}


    
sub drawGrid
{
    # $_[0] : SS
    # $_[1] : Image File
    # $_[2] : Options

    ##
    ## Called Functions :
    ##           - LADDER::draw
    ##           - SSWAP::getHeightMax
    ##           - &_split_throws
    ##           - &_compute_points

    # When the plotting method (e.g. plot2d) is called, Chart::Gnuplot would generate a Gnuplot script based on the information in the chart object and dataset object.
    # Then it would call the Gnuplot program. Unless specified explicitly in terminal of the Chart object, Chart::Gnuplot would by default generate the image in PS format first
    # and then convert the image (by ImageMagick) based on the extension of the filename. The rationale of this approach is that the postscript terminal is so far the best
    # developed terminal and so this would let users to enjoy the power of Gnuplot as much as possible.
    # Because the default terminal is postscript, if ImageMagick is not installed, you would always need to specify the terminal if the output format is not PS (or EPS).
    # On the other hand, for some image formats, e.g. mousing supported SVG, which ImageMagick cannot be converted to, the terminal must be set explicitly (e.g., svg mousing in this case).
    
    require modules::LADDER;
    require modules::SSWAP;

    my $ss = $_[0];    
    my $fileOutput = $conf::RESULTS."/3Layers_grid.png";    
    if (scalar @_ >= 2)
    {
	$fileOutput = $conf::RESULTS."/".$_[1];
    }

    my $circle_radius = 0.2;
    my $val_YShift = 0.25; # Y shift for same Throw on same Beat
    my $staple_height = 0.4;
    my $silence = 0;
    my $period = -1;
    my $title = 'Y';
    my $title_hand_mode = 'Y';
    my $title_content = '3-Layers Notation Grid: '.$ss;
    my $hand_mode = 'R';
    my $circle_color = '#a935bd';
    my $staple_color = 'green';
    my $sync_color = 'blue';
    my $hand_mode_color = 'blue';
    my $label = 'Y';
    my $label_x = 'Beats';
    my $label_y = 'Throws Heights';
    my $chart_terminal = 'AUTO';
    
    my $ret = &GetOptionsFromString($_[2],    
				    "-P:i" => \$period,
				    "-S:i" => \$silence,
				    "-T:s" => \$title,
				    "-L:s" => \$label,
				    "-U:s" => \$title_hand_mode,
				    "-V:s" => \$title_content,
				    "-H:s" => \$hand_mode,
				    "-R:o" => \$circle_radius,
				    "-C:s" => \$circle_color,
				    "-Y:o" => \$val_YShift,
				    "-A:o" => \$staple_height,
				    "-B:s" => \$staple_color,
				    "-D:s" => \$sync_color,
				    "-E:s" => \$hand_mode_color,
				    "-Z:s" => \$chart_terminal,
	);


    if(uc($title_hand_mode) eq 'Y')
    {
	if(uc($title) eq 'Y')
	{	
	    $title_content = $title_content.'  [Hand Mode: '.$hand_mode.']';
	}
	else
	{
	    $title_content = '';
	}
    }

    if (uc($label) ne 'Y')
    {
	$label_x = '';
	$label_y = '';
    }
        
    my ($beat, $src_left_tmp, $src_right_tmp) = &LADDER::__build_lists($ss);
    if ($period == -1) {
	if ($beat <  $PERIOD_MAX) {
	    $period = $PERIOD_MAX;
	} else {
	    $period = $beat + $PERIOD_MAX;
	}
    }
    	
    my $new_ss = $ss;	
    if ($beat != 0 ) {
	my $r = int($period / $beat);
	for (my $i=1; $i <= $r; $i++) {
	    $new_ss = $new_ss.$ss;
	}    
    }
    my ($beat, $src_left_tmp, $src_right_tmp) = &LADDER::__build_lists($new_ss);    
    my @src_left = @{$src_left_tmp};
    my @src_right = @{$src_right_tmp};

    my $height = 9;
    if($height < &SSWAP::getHeightMax($ss,-1))
    {
	$height = &SSWAP::getHeightMax($ss,-1);
    }	

    my $chart;

    if(uc($chart_terminal) ne 'AUTO')
    {
	# Create the chart object
	$chart = Chart::Gnuplot->new(
	    output  => $fileOutput,
	    gnuplot => $conf::GNUPLOT_BIN,
	    terminal => $chart_terminal,
	    title => {
		text => $title_content,
		font => 'Times,20',
		color    => 'black',	    
	    },

	    grid => {linetype => 'dash',
		     width => 5,
		     color => "red",	
	    },
	    
	    minorgrid => {
		linetype => 'dash',	
		width  => 2,
		color => "red",	
	    },
	    
	    border => undef,
	    
	    xlabel => {
		text => $label_x,
		font => 'Times,20',
		color => 'black',
	    },
	    
	    ylabel  => {
		text => $label_y,
		font => 'Times,20',
		color    => 'black',
	    },

	    yrange => [1-2*$circle_radius,$height+2*$circle_radius],
	    
	    xtics => {
		start => 0,
		incr => 2,
		minor => 1,
	    },
	    
	    ytics => {
		start => 1.0,
		incr => 4.0,
		end => 15.0,
		minor => 1,
		labelfmt => '%x'
	    }
	    );
    }

    else
    {	
	# Create the chart object
	$chart = Chart::Gnuplot->new(
	    output  => $fileOutput,
	    gnuplot => $conf::GNUPLOT_BIN,
	    title => {
		text => $title_content,
		font => 'Times,20',
		color    => 'black',	    
	    },

	    grid => {linetype => 'dash',
		     width => 5,
		     color => "red",	
	    },
	    
	    minorgrid => {
		linetype => 'dash',	
		width  => 2,
		color => "red",	
	    },
	    
	    border => undef,
	    
	    xlabel => {
		text => $label_x,
		font => 'Times,20',
		color => 'black',
	    },
	    
	    ylabel  => {
		text => $label_y,
		font => 'Times,20',
		color    => 'black',
	    },

	    yrange => [1-2*$circle_radius,$height+2*$circle_radius],
	    
	    xtics => {
		start => 0,
		incr => 2,
		minor => 1,
	    },
	    
	    ytics => {
		start => 1.0,
		incr => 4.0,
		end => 15.0,
		minor => 1,
		labelfmt => '%x'
	    }
	    );    
    }


    
    # We set a Matrix with Beat as key
    # Each value is : a List of Throw with following parameters in an array : 
    #   - Throw ID
    #   - Real Throw Beat
    #   - Throw Height (May be adapted for avoiding overlap in the drawing)
    #   - Same Hand (0) or Opposite Hand (1) Throw
    #   - List of Throw IDs for sync
    #   - List of Real Throw Beats for Hurries 
    
    my %points_matrix = ();   
    my $cpt_points = 0;
    my $point = []; 
    
        
    for (my $i = 0; $i < $beat; $i++) {

	my ($src_right_in_tmp, $src_right_throw_in_tmp) = _split_throws($src_right[$i], $val_YShift);
	my ($src_left_in_tmp, $src_left_throw_in_tmp) = _split_throws($src_left[$i], $val_YShift);
	my @src_right_in = @{$src_right_in_tmp};
	my @src_left_in = @{$src_left_in_tmp};
	my @src_right_throw_in = @{$src_right_throw_in_tmp};
	my @src_left_throw_in = @{$src_left_throw_in_tmp};
	
	if(uc($hand_mode) eq 'R')
	{
	    if (scalar(@src_right_in) > 0)
	    {
		my @peer_sync_points = ();
		my $sync_line_point;
		for (my $j = 0; $j < scalar(@src_right_in); $j++) {
		    $sync_line_point = $cpt_points;
		    if($src_right_throw_in[$j] == 0)
		    {
			$point = [$cpt_points, $i, $src_right_in[$j], 0, [], []];
		    }
		    else
		    {
			$point = [$cpt_points, $i, $src_right_in[$j], 1, [], []];
		    }

		    if(not exists($points_matrix{$i}))
		    {
			$points_matrix{$i} = [];		
		    }		    
		    push @{$points_matrix{$i}}, $point;
		    $cpt_points ++;
		    		    
		    if (scalar(@src_left_in) > 0 & $j == 0)
		    {
			# we have a sync here.
			# We have to add the peer sync points only for the first throw 
			for (my $k = 0; $k < scalar(@src_left_in); $k++) {
			    if($src_left_throw_in[$k] == 0)
			    {
				$point = [$cpt_points, $i, $src_left_in[$k], 0, [$sync_line_point], []];
			    }
			    else
			    {
				$point = [$cpt_points, $i, $src_left_in[$k], 1, [$sync_line_point], []];			    
			    }			    
				
			    if(not exists($points_matrix{$i+1}))
			    {
				$points_matrix{$i+1} = [];
			    }
			    push @peer_sync_points, $point;		    
			    $cpt_points ++;
			}
		    }

		    elsif($j != 0)
		    {
			for (my $k=0; $k < scalar @peer_sync_points; $k++)
			{			    
			    push @{@peer_sync_points[$k]->[4]}, $sync_line_point;			    
			}
		    }
		}

		for (my $k=0; $k < scalar @peer_sync_points; $k++)
		{
		    push @{$points_matrix{$i+1}}, $peer_sync_points[$k];		    
		}

		$hand_mode = 'L';
	    }
	    
	    elsif (scalar(@src_left_in) > 0)
	    {
		# This is a hurry on left hand (left mode in Notation)
		if ($i%2 == 0)
		{
		    # Add a line to represent the Hand Mode Change 
		    $chart->line(
			from  => ''.($i-0.2).', 5',
			to    => ''.($i).', 5.5',
			width => 5,
			color => $hand_mode_color);
		    $hand_mode = 'R';
		}

		for (my $j = 0; $j < scalar(@src_left_in); $j++) {
		    
		    if($src_left_throw_in[$j] == 0)
		    {
			$point = [$cpt_points, $i, $src_left_in[$j], 0, [], []];
		    }
		    else
		    {
			$point = [$cpt_points, $i, $src_left_in[$j], 1, [], []];
		    }		
		    		    
		    if ($i%2 != 0 && $i > 0)
		    {
			## If Hack To avoid staple from a 0 has to be done :
			## it should be done here:
			push @{$point->[5]}, $i-1;
			# We do not reconsider the Hand Mode
			$hand_mode = 'L';	 
		    }
		    		   				    
		    if(not exists($points_matrix{$i}))
		    {
			$points_matrix{$i} = [];
		    }
		    
		    push @{$points_matrix{$i}}, $point;		    
		    $cpt_points ++;
		}
	    }

	    else
	    {
		$hand_mode = 'L';		
	    }
	}
	
	elsif(uc($hand_mode) eq 'L')
	{
	    if (scalar(@src_left_in) > 0)
	    {
		my @peer_sync_points = ();
		my $sync_line_point;
		for (my $j = 0; $j < scalar(@src_left_in); $j++) {
		    $sync_line_point = $cpt_points;
		    if($src_left_throw_in[$j] == 0)
		    {
			$point = [$cpt_points, $i, $src_left_in[$j], 0, [], []];
		    }
		    else
		    {
			$point = [$cpt_points, $i, $src_left_in[$j], 1, [], []];
		    }		    
		    if(not exists($points_matrix{$i}))
		    {
			$points_matrix{$i} = [];
		    }
		    push @{$points_matrix{$i}}, $point;	
		    $cpt_points ++;
		    
		    if (scalar(@src_right_in) > 0 && $j == 0)
		    {
			# we have a sync here
			# We have to add the peer sync points only for the first throw 
			for (my $k = 0; $k < scalar(@src_right_in); $k++) {
			    if($src_right_throw_in[$k] == 0)
			    {
				$point = [$cpt_points, $i, $src_right_in[$k], 0, [$sync_line_point], []];
			    }
			    else
			    {
				$point = [$cpt_points, $i, $src_right_in[$k], 1, [$sync_line_point], []];
			    }			    
			    
			    if(not exists($points_matrix{$i+1}))
			    {
				$points_matrix{$i+1} = [];
			    }
			    
			    push @peer_sync_points, $point;		    
			    $cpt_points ++;
			    
			}
		    }
		    
		    elsif ($j != 0)
		    {
			for (my $k=0; $k < scalar @peer_sync_points; $k++)
			{
			    push @{@peer_sync_points[$k]->[4]}, $sync_line_point;			    
			}
		    }
		    
		}
		
		for (my $k=0; $k < scalar @peer_sync_points; $k++)
		{
		    push @{$points_matrix{$i+1}}, $peer_sync_points[$k];		    
		}
		$hand_mode = 'R';
	    }
	    
	    elsif (scalar(@src_right_in) > 0)
	    {
		# This is a hurry on right hand (Right Mode in Notation)
		if ($i%2 == 0)
		{
		    # Add a line to represent the Hand Mode Change 
		    $chart->line(
			from  => ''.($i).', 5.5',
			to    => ''.($i+0.2).', 5',
			width => 5,
			color => $hand_mode_color);
		    $hand_mode = 'L';
		}

		for (my $j = 0; $j < scalar(@src_right_in); $j++) {		
		    if($src_right_throw_in[$j] == 0)
		    {
			$point = [$cpt_points, $i, $src_right_in[$j], 0, [], []];
		    }
		    else
		    {
			$point = [$cpt_points, $i, $src_right_in[$j], 1, [], []];
		    }		    		    

		    if ($i%2 != 0 && $i > 0)
		    {
			## If Hack To avoid staple from a 0 has to be done :
			## it should be done here:
			push @{$point->[5]}, $i-1;
			# We do not reconsider the Hand Mode
			$hand_mode = 'R';		    
		    }

		    if(not exists($points_matrix{$i}))
		    {
			$points_matrix{$i} = [];
		    }
		    push @{$points_matrix{$i}}, $point;
		    $cpt_points ++;
		}
	    }

	    else
	    {
		$hand_mode = 'R';		
	    }
	    
	}	
    }
    
    
    if ($HTN_DEBUG >= 1) {
	print "== HTN::drawGrid : == POINTS_MATRIX ==\n";
	print "We set a Matrix with Beat as key\n";
	print "Each value is : a List of Throw with following parameters in an array:\n";
	print " - Throw ID\n";
	print " - Real Throw Beat\n";
	print " - Throw Height (May be adapted for avoiding overlap in the drawing)\n";
	print " - Same Hand (0) or Opposite Hand (1) Throw\n";
	print " - List of Throw IDs for sync\n";
	print " - List of Real Throw Beats for Hurries\n";

	foreach my $k (sort {$a <=> $b } keys(%points_matrix))
	{
	    print '== Beat '.$k.'=='."\n";
	    my @l = @{$points_matrix{$k}};
	    for (my $i = 0; $i < scalar @l; $i++)
	    {
		print '  '.$l[$i][0].','.$l[$i][1].','.$l[$i][2].','.$l[$i][3].',[ ';
		for (my $j = 0; $j < scalar @{$l[$i][4]}; $j++)
		{
		    print $l[$i][4][$j].' ';
		}
		print "],[ ";
		for (my $j = 0; $j < scalar @{$l[$i][5]}; $j++)
		{
		    print $l[$i][5][$j].' ';
		}
		print "]\n";											
	    }
	}
    }

    my ($points_same_hand_throw_tmp, $points_opp_hand_throw_tmp) = _compute_points(\%points_matrix, $circle_radius, $val_YShift, $staple_height, $staple_color, $sync_color, $chart);
    
    if ($HTN_DEBUG >= 1) {
	print "== HTN::drawGrid : == ADJUSTED POINTS_MATRIX ==\n";
	foreach my $k (sort {$a <=> $b } keys(%points_matrix))
	{
	    print '== Beat '.$k.'=='."\n";
	    my @l = @{$points_matrix{$k}};
	    for (my $i = 0; $i < scalar @l; $i++)
	    {
		print '  '.$l[$i][0].','.$l[$i][1].','.$l[$i][2].','.$l[$i][3].',[ ';
		for (my $j = 0; $j < scalar @{$l[$i][4]}; $j++)
		{
		    print $l[$i][4][$j].' ';
		}
		print "],[ ";											
		for (my $j = 0; $j < scalar @{$l[$i][5]}; $j++)
		{
		    print $l[$i][5][$j].' ';
		}
		print "]\n";											
	    }
	}
    }
    
    my @points_same_hand_throw = @{$points_same_hand_throw_tmp};
    my @points_opp_hand_throw = @{$points_opp_hand_throw_tmp};
    
    my $dataSetPoints_opp_hand_throw = Chart::Gnuplot::DataSet->new(
	points => \@points_opp_hand_throw,
	style => 'circles',
	fill => {
	    color   => $circle_color,
	    density => 0.8,
	},
	color   => $circle_color,
	);
    
    my $dataSetPoints_same_hand_throw = Chart::Gnuplot::DataSet->new(
	points => \@points_same_hand_throw,
	style => 'circles',
	color => $circle_color,
    	width => 4.0,
	);

    if ($silence == 0) {
	print colored [$common::COLOR_RESULT], "Gnuplot Parameters :\n";
	print colored [$common::COLOR_RESULT], " - Bin: ".$chart->gnuplot."\n";
	print colored [$common::COLOR_RESULT], " - Terminal Driver: ".$chart->terminal."\n";
	print colored [$common::COLOR_RESULT], " - Output: ".$chart->output."\n";
    }
    
    if (scalar @points_same_hand_throw > 0 && scalar @points_opp_hand_throw > 0)
    {
	$chart->plot2d($dataSetPoints_same_hand_throw, $dataSetPoints_opp_hand_throw);
    }
    elsif (scalar @points_same_hand_throw > 0)
    {
	$chart->plot2d($dataSetPoints_same_hand_throw);
    }
    elsif (scalar @points_opp_hand_throw > 0)
    {
	$chart->plot2d($dataSetPoints_opp_hand_throw);
    }
    else
    {
	print colored [$common::COLOR_ERR], $lang::MSG_HTN_ERR_DRAWGRID_1."\n\n";
    }
    
    if ($silence == 0) {
	print colored [$common::COLOR_RESULT], $lang::MSG_HTN_DRAWGRID_1." : "."$fileOutput"."\n\n";    
    }
    
}


sub HTNMaker
{
    my $pwd = cwd();
    if ($common::OS eq "MSWin32") {
	system("start /b cmd /c \"$conf::HTTP_BROWSER\" ${pwd}/data/HTNMaker/HTNMaker.html");
    } else {
	# Unix-like OS
	system("$conf::HTTP_BROWSER ${pwd}/data/HTNMaker/HTNMaker.html &");
    }
}

1;
