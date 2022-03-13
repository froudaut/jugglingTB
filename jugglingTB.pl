#!/bin/perl
##############################################################################
## jugglingTB                                                               ##
##                                                                          ##
##                                                                          ##
## jugglingTB.pl -   Perl Implementation of the Juggling Notations Toolbox  ##
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

BEGIN
{
    # Done before everything 
    use Getopt::Long qw(:config);   
    use Getopt::Long qw(GetOptionsFromString);   
    use common;
    use lang;
    use conf;
    use Set::Scalar;
    use Term::Complete;
    require Term::ANSIColor;
    require Encode;
    require Devel::Symdump;    

    ## 
    ## Main Part - 1
    ##

    &lang::initLang();

    # Default Configuration File
    my $jtbOptions_conf="conf.ini";
    
    my $params = $ARGV;       

    # First Init Conf
    &GetOptionsFromString($params,			 
			  "i=s" => \$jtbOptions_conf			 
	);    

    &conf::init($jtbOptions_conf);
    
    # Parse Options and Overload conf
    Getopt::Long::Configure( "no_ignore_case" );
    if(!GetOptions( "v!" => \$conf::jtbOptions_v, 
		    "c!" => \$conf::jtbOptions_c,
		    "d=i" => \$conf::jtbOptions_d,
		    "u!" => \$conf::jtbOptions_u,
		    "h!" => \$conf::jtbOptions_h,
		    "H!" => \$conf::jtbOptions_H,
		    "s!" => \$conf::jtbOptions_s,
		    "a!" => \$conf::jtbOptions_a,
		    "e=s" => \$conf::jtbOptions_e,
		    "f=s" => \$conf::jtbOptions_f,
		    "i=s" => \$jtbOptions_conf
       ))
    { 
	$common::NoSpecialChar = 1;        
	&lang::initLang();
	$ENV{'ANSI_COLORS_DISABLED'}=1;        
	die(&usage()); 
    }
    
    print "Config loaded : \"".$jtbOptions_conf."\"\n";
    
    #if($conf::jtbOptions_i)
    #{
    #}
    #else
    #{
    #	&conf::init();
    #}
    
    if($conf::jtbOptions_c)
    {
	if($common::OS eq "MSWin32")
	{	
	    require Win32::Console::ANSI;
	}
	use Term::ANSIColor;        
	use Term::ANSIColor qw(:constants);   
	$Term::ANSIColor::AUTORESET = 1;
	print colored [$common::COLOR_ERR], "Colorization loaded\n";
    }
    
    else
    {
	$ENV{'ANSI_COLORS_DISABLED'}=1;        
    }
    
    if($conf::jtbOptions_s)
    {
	print colored [$common::COLOR_ERR], "Unicode Menus loaded\n";

	$common::NoSpecialChar = 0;
	if($common::OS eq "MSWin32")
	{
	    binmode(STDOUT, ':encoding(latin1)');
	    print colored [$common::COLOR_ERR], $lang::MSG_MAIN_WINDOWS_CHARSET;
	    #system('chcp 65001 > nul:');
	    system('chcp 1252 > nul:');
	}
	
	else
	{
	    binmode(STDOUT, ':encoding(UTF-8)');
	}	
    }

    else
    {
	$common::NoSpecialChar = 1;        
    }

    if($conf::jtbOptions_a)
    {
	if($common::OS eq "MSWin32")
	{
	    require Term::ReadKey;
	    Term::ReadKey::ReadMode(4);
	    Term::ReadKey::SetControlChars([KILL,13]);
	}

	print colored [$common::COLOR_ERR], "Autocompletion loaded\n";
	$common::Autocompletion = 1;
    }
    
    else
    {
	$common::Autocompletion = 0;
    }
    
    
    &lang::initLang();

    
    sub usage 
    {
	# Special handling for .exe
	if($0 =~ ".exe")
	{
	    print colored [$common::COLOR_HELPCMD], "\n USAGE :  $0 [[-|-no][a|c|h|H|s|u|v|d int|e cmd|f cmd|i 'file']]*\n" ;
	}
	else
	{
	    print colored [$common::COLOR_HELPCMD], "\n USAGE :  perl -I . $0 [[-|-no][a|c|h|H|s|u|v|d int|e cmd|f cmd|i 'file']]*\n" ;
	}
	print "\n";
	print colored [$common::COLOR_HELPCMD], "  -a";   
	print " : $lang::MSG_MAIN_USAGE_a\n";
	print colored [$common::COLOR_HELPCMD], "  -c";   
	print " : $lang::MSG_MAIN_USAGE_c\n";   
	print colored [$common::COLOR_HELPCMD], "  -h";
	print " : $lang::MSG_MAIN_USAGE_h\n";   
	print colored [$common::COLOR_HELPCMD], "  -H";
	print " : $lang::MSG_MAIN_USAGE_H\n";
	print colored [$common::COLOR_HELPCMD], "  -s";   
	print " : $lang::MSG_MAIN_USAGE_s\n";   
	print colored [$common::COLOR_HELPCMD], "  -u";   
	print " : $lang::MSG_MAIN_USAGE_u\n";
	print colored [$common::COLOR_HELPCMD], "  -v";   
	print " : $lang::MSG_MAIN_USAGE_v\n";	
	print colored [$common::COLOR_HELPCMD], "  -d int";
	print " : $lang::MSG_MAIN_USAGE_d\n";
	print colored [$common::COLOR_HELPCMD], "  -e cmd";   
	print " : $lang::MSG_MAIN_USAGE_e\n";   
	print colored [$common::COLOR_HELPCMD], "  -f cmd";   
	print " : $lang::MSG_MAIN_USAGE_f\n";   
	print colored [$common::COLOR_HELPCMD], "  -i 'file'";   
	print " : $lang::MSG_MAIN_USAGE_i\n";
	print "$lang::MSG_MAIN_USAGE_CONF\n";         
    }
}

###########################################################################################################
###
###
###  This is the part to update to add or remove Modules
###

use modules::BTN;
use modules::HSS;
use modules::HTN;
use modules::LADDER;
use modules::MLHSS;
use modules::MJN;
use modules::MJHSS;
use modules::MHN;
use modules::MMSTD;
use modules::SOU;
use modules::SPYRO;
use modules::SSWAP;
use modules::STACK;
#use modules::MODTEST;

my @MODULES= ("BTN", "HSS", "HTN", "LADDER", "MHN", "MJN", "MJHSS", "MLHSS", "MMSTD", "SOU", "SPYRO", "SSWAP", "STACK");
###########################################################################################################

# Set the Debug Mode in each module
foreach my $v (@MODULES)
{
    my $debug=eval("${v}::${v}_DEBUG");  	     
    ${$debug} = $conf::jtbOptions_d;   			

}

###
###
###
###
###########################################################################################################

my $JUGGLINGTB_VERSION = "v1.6";

my %JUGGLINGTB_CMDS = 
    (    
	 'lsc'     => [$lang::MSG_MAIN_MENU_LSC_1, ""], 
	 'lsc2'    => [$lang::MSG_MAIN_MENU_LSC_2, ""], 
	 'main'    => [$lang::MSG_MAIN_MENU_MAIN_1, ""],
	 'mods'    => [$lang::MSG_MAIN_MENU_MODS_1, ""],
	 'help'    => [$lang::MSG_MAIN_MENU_HELP_1, $lang::MSG_MAIN_MENU_HELP_2],
	 'help2'   => [$lang::MSG_MAIN_MENU_HELP2_1, $lang::MSG_MAIN_MENU_HELP2_2],
	 'version' => [$lang::MSG_MOD_VERSION_1, $lang::MSG_MOD_VERSION_2],
	 'usage'   => [$lang::MSG_MAIN_MENU_USAGE_1, ""],
	 'exit'    => [$lang::MSG_MAIN_MENU_EXIT_1, ""],
	 '!'       => [$lang::MSG_MAIN_MENU_EXC_1, $lang::MSG_MAIN_MENU_EXC_2],
	 '?'       => [$lang::MSG_MAIN_MENU_INT_1, $lang::MSG_MAIN_MENU_INT_2],
	 'credits' => [$lang::MSG_MAIN_MENU_CREDITS_1, ""],
    );

my $JUGGLINGTB_MODULES = Set::Scalar->new(@MODULES);
my $JUGGLINGTB_PROMPT="JugglingTB-${JUGGLINGTB_VERSION}";
#($JUGGLINGTB_PROMPT=$0) =~ s:.*/::;

# Force flush after printing
$| = 1;

# current Menu
my $currentSubMenu="main";

# Menu Length for printing 
my $submenuLength = 22;
my $menuLength = 10;

my @LOCAL_CONTEXT =();
my @GLOBAL_CONTEXT = ();

if($common::Autocompletion == 1)
{
    # AutoCompletion (All commands + module names + main commands that are available in every menu)
    my @packs = ("main",  @MODULES);
    @GLOBAL_CONTEXT = (Devel::Symdump->new(@packs) ->functions, @packs); 
    my @MAIN_CONTEXT = Devel::Symdump->new(("main")) ->functions;
    for(my $i=0; $i < scalar @MAIN_CONTEXT; $i ++)
    {
	$MAIN_CONTEXT[$i] =~ s/main:://ig;		
    }

    @GLOBAL_CONTEXT=(@GLOBAL_CONTEXT, @MAIN_CONTEXT);
}


# Handler for C^c in a module function call 
my $nint = 0; 
sub killFunction {
    $nint++;
    if ($nint >= 2) 
    {	
	$nint = 0;
	die ("\rKilled by repeated ^C entries\n");
    }
}
$SIG{INT} = 'killFunction'; # traps keyboard interrupt


#
# Interactive Perl.
#
#  ! command  Pass command to shell. $val <== $?
#  !! command  Pass command to shell. $val <== $?
#  ?    Print $val.
#  perl stuff  $val <== eval 'perl stuff'
#
# Multiline perl text uses slosh extension.
#
# Some parts are from :
#  - Cameron Simpson <cameron@cse.unsw.edu.au>, 23feb93
#
sub runEnv 
{
    require 'flush.pl';
    
    if($conf::jtbOptions_e)
    {
	print "\n\t==> ".$conf::jtbOptions_e."\n";
	eval($conf::jtbOptions_e."\n");				
	exit 0;
    }
    elsif($conf::jtbOptions_f)
    {
	print "\n\t==> Command File :".$conf::jtbOptions_f."\n";
	open(FILE,$conf::jtbOptions_f) 
	    || die ("$lang::MSG_GENERAL_ERR1 <$conf::jtbOptions_f> $lang::MSG_GENERAL_ERR1b") ;
	while (<FILE>) {
	    eval($_."\n");				
	}
	
	exit 0;
    }    

    $tty=(-t STDIN);
    $ps1=$JUGGLINGTB_PROMPT.'> ';
    $ps2=(' ' x length($JUGGLINGTB_PROMPT)).'> ';
    
    defined($ENV{'SHELL'}) || ($ENV{'SHELL'}='/bin/sh');
    
    $xit=0;
    $val=0;

  MAINLOOP:
    
    while(1)
  {
      
      $SIG{INT} = 'killFunction'; # traps keyboard interrupt
      #(&flush(STDOUT), ($tty && print colored [$common::COLOR_PROMPT], $ps1), defined($_=<STDIN>)) { 
      &flush(STDOUT);
      print colored [$common::COLOR_PROMPT], $ps1;		
      
      if($common::Autocompletion == 0)
      {	    
	  if(defined($_=<STDIN>) && $tty)
	  {
	      &__runEnv();		
	  }
      }
      
      else
      {	
	  if(defined($_=Complete("", (@GLOBAL_CONTEXT,@LOCAL_CONTEXT))) && $tty)	    
	  {
	      #Add local Context to autocompletion (ie without MOD::)	
	      if(!(${currentSubMenu} eq "main"))
	      {
		  @LOCAL_CONTEXT = Devel::Symdump->new(($currentSubMenu)) ->functions;
		  for(my $i=0; $i < scalar @LOCAL_CONTEXT; $i ++)
		  {
		      $LOCAL_CONTEXT[$i] =~ s/${currentSubMenu}:://ig;		
		  }
	      }
	      
	      &__runEnv();		
	  }
      }
  }
    
    # Exit the program
    $tty && print "\n";    
    exit $xit;
    

    sub __runEnv
    {
	tr/\n//d;
	s/^\s+//;
	
	# slosh extension
	while (/\\$/) {
	    s/\\$//;
	    if (($tty && print "$ps2"), defined($line=<STDIN>)) 
	    {
		$line =~ tr/\n//d;
		$_.="\n".$line;
	    } 
	    else 
	    {		
		print colored [$common::COLOR_ERR], "$JUGGLINGTB_PROMPT: ${lang::MSG_MAIN_ERR1}\n";
		$xit=1;
		last MAINLOOP;
	    }
	}
	
	if (/^!!/) {
	    s/^!!//;
	    $val=&__shellcmd2($_);
	    print "\n";
	} 
	elsif (/^!/) {
	    s/^!//;
	    $val=&__shellcmd($_);
	    print "\n";
	} 
	
	else {
	    s/\s+$//;
	    if ($_ eq '?') {
		print $val, "\n";
	    } 
	    else 
	    {
		# Go down into a module menu by autocompletion is the length is at least >=2
		if(length($_)>=2)
		{
		    foreach my $v (@MODULES)
		    {
			# Get help on the SubMenu
			#my $in = $_;
			#$in =~ s/\*/\\*/ig;
			#if($v =~ m/$in/)
			if(index($v,$_) == 0) 
			{
			    $_ = $v;
			    last;
			}
		    }
		}

		if($JUGGLINGTB_MODULES->has($_))
		{
		    $ps1=$_.'> ';
		    $currentSubMenu=$_;
		}				
		
		else
		{		    
		    # Call from a Module		    
		    if ($currentSubMenu ne "main") 
		    {	
			# if command is main, go back to the main
			if($_ eq "main")
			{
			    $currentSubMenu="main";
			    $ps1=$JUGGLINGTB_PROMPT.'> ';
			}
			
			else
			{
			    my %cmdlist=eval("\%${currentSubMenu}::${currentSubMenu}_CMDS");
			    
			    if ( (%cmdlist) && $cmdlist{substr($_,0,index($_,"("))})
			    {				
				# Command Evaluation in the module menu
				$val=eval("${currentSubMenu}::$_");
			    }
			    
			    else
			    {
				# Command Evaluation as in the main menu
				$val=eval $_;				
			    }
			    
			    if ($@) 
			    {
				print colored [$common::COLOR_ERR], "eval : $@\n";
				$xit=1;
			    } 			
			    
			    else 
			    {
				$xit=($val == 0);			
			    }			
			    
			}
		    }		    

		    else
		    {						
			# You are in the main menu
			# Command Evaluation in the main menu
			
			$val=eval $_;						
			
			if ($@) 
			{
			    print colored [$common::COLOR_ERR], "eval : $@\n";
			    $xit=1;
			} 
			else 
			{
			    $xit=($val == 0);			
			}			
		    }		
		}
	    }
	}
    }
}

sub __shellcmd 
{
    local($shc)=@_;
    local($xit,$pid);
    if (!defined(my $pid=fork)) {
	print colored [$common::COLOR_ERR], "$JUGGLINGTB_PROMPT : fork ${lang::MSG_MAIN_ERR2}: $!\n";
	$xit=$!;
    } elsif ($pid == 0) {
	# child
	# $SIG{'INT'}='DEFAULT';
	if($common::OS eq "linux")
	{		
	    exec($ENV{'SHELL'},'-c',$shc);
	    print colored [$common::COLOR_ERR], "$JUGGLINGTB_PROMPT : exec $ENV{'SHELL'} ${lang::MSG_MAIN_ERR2}: $!\n";
	    exit 1;
	}
	else
	{
	    #it is supposed to be MSWin32
	    exec($shc);
	    print colored [$common::COLOR_ERR], "$JUGGLINGTB_PROMPT : exec ${lang::MSG_MAIN_ERR2}: $!\n";
	    exit 1;
	}
    } 
    else 
    {
	# parent
	local($wait);
	$wait=waitpid($pid,0);
	$SIG{'INT'}='IGNORE';
	if ($wait == -1) {
	    die "no child? (waitpid: $!)";
	} else {
	    if ($pid != $wait) {
		die "waitpid($pid,0) == $wait";
	    } 
	    else 
	    {
		$xit=$?;
	    }
	}
    }
    $xit;
}


sub __shellcmd2 
{
    system($_);
}


sub __displayInfo
{
    $info = $_[0];
    if($common::NoSpecialChar == 1)
    {
	for my $nletter (keys %common::HASH_SPECIAL_UNICODE_CHAR)
	{
	    $info =~ s/$nletter/$common::HASH_SPECIAL_UNICODE_CHAR{$nletter}/ig
	}
    }
    
    @containGlob = split(/\n/, $info);

    for($lign=0;$lign < scalar @containGlob; $lign ++)
    {
	@contain = split(/ /, $containGlob[$lign]);
	$nbcar = 0;
	$word = 0;
	$disp = "";
	$nlign = 0;
	
	while ($word <= (scalar @contain) )
	{	   
	    if(($nbcar + length($contain[$word])) <= $_[2])
	    {
		$nbcar += length ($contain[$word]);
		$disp = "${disp} $contain[$word]";
		$word ++;
	    }
	    
	    else
	    {
		if(($nlign == 0) && ($lign == 0))  
		{
		    if($_[3]) 
		    {
			print colored [$_[3]], $disp."\n";
		    }
		    else
		    {
			print $disp."\n";
		    }
		}
		else
		{
		    if($_[3]) 
		    {
			print colored [$_[3]], ' ' x ($_[1]).$disp."\n";			    			
		    }
		    else
		    {
			print ' ' x ($_[1]).$disp."\n";			    
		    }
		}

		$nlign ++;
		$nbcar = 0;
		$disp = "";
	    }			
	}

	if(($nlign == 0)  && ($lign == 0))
	{
	    if($_[3])
	    {
		print colored [$_[3]],$disp."\n";
	    }
	    else
	    {
		print $disp."\n";
	    }
	}
	else
	{		    
	    if($_[3])
	    {
		print colored [$_[3]], ' ' x ($_[1]).$disp."\n";		    
	    }
	    else
	    {
		print ' ' x ($_[1]).$disp."\n";		    
	    }
	}
    }
}


sub lsc 
{
    my $containLength = $conf::XSIZE -5;
    &common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
    
    print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
    foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
    {
	print colored [$common::COLOR_HELPCMD], "  $cmd";
	$text = $JUGGLINGTB_CMDS{$cmd};
	print (' ' x ($menuLength - length($cmd))); 
	my $containLength = $conf::XSIZE - $menuLength -2;
	&common::displayInfo($text->[0], $menuLength + 2, $containLength);
    }
    
    print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
    if($JUGGLINGTB_MODULES->size==0)
    {
	print $lang::MSG_MAIN_LSC_NOMODA;
    }
    else
    {
	print $lang::MSG_MAIN_LSC_MODA;
	while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	{
	    print colored [$common::COLOR_HELPMENU], "$menu ";
	}
	print "\n";
	
	while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	{	    
	    if(defined ("%${menu}::${menu}_CMDS"))
	    {		
		print "\n";
		my %subMenu=eval("%${menu}::${menu}_CMDS");

		print colored [$common::COLOR_HELPMENU], "\n  ${menu} ";
		
		if(defined ("${menu}::${menu}_INFO"))
		{		   
		    my $menuInfo=eval("\$${menu}::${menu}_INFO");		    
		    print colored [$common::COLOR_HELPMENU], " - $menuInfo ";		    
		}
		
		if(defined ("${menu}::${menu}_VERSION"))
		{
		    my $menuVersion = eval("\$${menu}::${menu}_VERSION");
		    print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
		}
		
		print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
		
		if(defined ("${menu}::${menu}_HELP"))
		{
		    my $h=eval("\$${menu}::${menu}_HELP");		    	    	    
		    my $containLength = $conf::XSIZE - 5 ;
		    print (' ' x 5); 
		    &common::displayInfo($h,5,$containLength);
		    print "\n\n";
		}
		
		foreach my $cmd (sort keys %subMenu)
		{
		    $text = $subMenu{$cmd};	    
		    print colored [$common::COLOR_HELPCMD], "  - $cmd";
		    print (' ' x ($submenuLength - length($cmd))); 
		    print " : ";
		    my $containLength = $conf::XSIZE - $submenuLength - 7 ;
		    &common::displayInfo($text->[0],$submenuLength + 7, $containLength );
		}
	    }
	}	
	
	print "\n";

    }
}


sub lsc2 
{
    my $containLength = $conf::XSIZE - 5;
    &common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
    
    print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
    foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
    {
	print colored [$common::COLOR_HELPCMD], "  $cmd";
	$text = $JUGGLINGTB_CMDS{$cmd};
	print (' ' x ($menuLength - length($cmd))); 
	my $containLength = $conf::XSIZE - $menuLength - 2 ;
	&common::displayInfo($text->[0], $menuLength + 2, $containLength, $common::COLOR_HELPPARAMCMD );		    
	my $containLength = $conf::XSIZE - $menuLength - 5;
	print (' ' x ($menuLength + 5)); 
	&common::displayInfo($text->[1], $menuLength + 5, $containLength );
	print "\n";
    }
    
    print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
    if($JUGGLINGTB_MODULES->size==0)
    {
	print $lang::MSG_MAIN_LSC_NOMODA;
    }
    else
    {
	print $lang::MSG_MAIN_LSC_MODA;
	while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	{
	    print colored [$common::COLOR_HELPMENU], "$menu ";
	}
	print "\n";
	
	while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	{	    
	    if(defined ("%${menu}::${menu}_CMDS"))
	    {		
		print "\n";
		my %subMenu=eval("%${menu}::${menu}_CMDS");

		print colored [$common::COLOR_HELPMENU], "\n  ${menu} ";
		
		if(defined ("${menu}::${menu}_INFO"))
		{		   
		    my $menuInfo=eval("\$${menu}::${menu}_INFO");		    
		    print colored [$common::COLOR_HELPMENU], " - $menuInfo ";		    
		}
		
		if(defined ("${menu}::${menu}_VERSION"))
		{
		    my $menuVersion = eval("\$${menu}::${menu}_VERSION");
		    print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
		}
		
		print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
		
		if(defined ("${menu}::${menu}_HELP"))
		{
		    my $h=eval("\$${menu}::${menu}_HELP");		    	    	    
		    my $containLength = $conf::XSIZE - 5;
		    print (' ' x 5); 
		    &common::displayInfo($h,5,$containLength);
		    print "\n\n";
		}

		foreach my $cmd (sort keys %subMenu)
		{
		    $text = $subMenu{$cmd};	    
		    
		    print colored [$common::COLOR_HELPCMD], "  - $cmd : ";
		    print (' ' x ($submenuLength - length($cmd))); 

		    my $containLength = $conf::XSIZE - $submenuLength - 7 ;
		    &common::displayInfo($text->[0],$submenuLength + 7, $containLength, $common::COLOR_HELPPARAMCMD );		    
		    my $containLength = $conf::XSIZE -5 ;
		    print (' ' x (5)); 
		    &common::displayInfo($text->[1], 5, $containLength );
		    print "\n\n";
		}
	    }
	}	
	
	print "\n";
	
    }
}


sub version
{
    if ($currentSubMenu eq "main")
    {
	print colored [$common::COLOR_HELPMENU], "$JUGGLINGTB_VERSION\n"; 
    }
    else
    {
	my $menuCmd=eval("\$${currentSubMenu}::${currentSubMenu}_VERSION");
	print colored [$common::COLOR_HELPMENU], "$menuCmd \n"; 
    }   
}


sub credits 
{    
    print colored [$common::COLOR_HELPMENU], "$common::AUTHOR ($common::AUTHOR_MAIL)\n";      
}


sub mods
{
    if($JUGGLINGTB_MODULES->size==0)
    {
	print $lang::MSG_MAIN_LSC_NOMODA;
    }
    else
    {
	print $lang::MSG_MAIN_LSC_MODA;
	while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	{
	    print colored [$common::COLOR_HELPMENU], "$menu ";
	}
	print "\n";
    }	
}


sub help
{
    # Help with One Argument
    if(scalar @_ == 1 )
    {	
	# Get basic help on the SubMenu main

	if ($_[0] =~ "main")
	{
	    # Get Basic Help on Commands in Main Module
	    my $containLength = $conf::XSIZE -5;
	    &common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
	    
	    print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
	    foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
	    {
		print colored [$common::COLOR_HELPCMD], "  $cmd";
		$text = $JUGGLINGTB_CMDS{$cmd};
		print (' ' x ($menuLength - length($cmd))); 
		my $containLength = $conf::XSIZE - $menuLength -2;
		&common::displayInfo($text->[0], $menuLength + 2, $containLength);
	    }
	    
	    print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
	    if($JUGGLINGTB_MODULES->size==0)
	    {
		print $lang::MSG_MAIN_LSC_NOMODA;
	    }
	    else
	    {
		print $lang::MSG_MAIN_LSC_MODA;
		while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
		{
		    print colored [$common::COLOR_HELPMENU], "$menu ";
		}
		print "\n\n";					
	    }


	}

	foreach my $v (@MODULES)
	{
	    # Get basic help on the SubMenu
	    if($v =~ $_[0])
	    {
		my $h=eval("\$${v}::${v}_HELP");		    	    	    		
		if(defined ("${v}::${v}_INFO"))
		{		   
		    my $menuInfo=eval("\$${v}::${v}_INFO");		    
		    print colored [$common::COLOR_HELPMENU], "\n - $menuInfo ";		    
		}
		
		if(defined ("${v}::${v}_VERSION"))
		{
		    my $menuVersion = eval("\$${v}::${v}_VERSION");
		    print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
		}
		print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
		
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($h,5,$containLength);
		print "\n\n";
		
		my %menuCmd=eval("\%${v}::${v}_CMDS");		    		
		foreach my $cmd (sort keys %menuCmd)
		{
		    $text = $menuCmd{$cmd};	    		    
		    print colored [$common::COLOR_HELPCMD], "  - $cmd";
		    print (' ' x ($submenuLength - length($cmd))); 
		    print " : ";
		    my $containLength = $conf::XSIZE - $submenuLength -7;
		    &common::displayInfo($text->[0], $submenuLength + 7, $containLength);		
		}
		
		print "\n\n";	
		return;
	    }
	    
	    # Get Advanced help on a command in absolute format
	    elsif($_[0] =~$v && $_[0] =~/::/)
	    {		
		my $smenufunc = (split(/::/,$_[0]))[1];
		my %menuCmd=eval("\%${v}::${v}_CMDS");	
		$text = $menuCmd{$smenufunc};

		print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
		print "\n";
		print (' ' x 5); 
		&common::displayInfo($text->[1],5,$containLength);
		print "\n\n";	
		return;
	    }	    
	}	

	# Get Advanced help on a command in Main Module
	if ($currentSubMenu eq "main")
	{	
	    $text = $JUGGLINGTB_CMDS{$_[0]};	    

	    print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 	    
	    my $containLength = $conf::XSIZE - 5 ;
	    print (' ' x 5); 
	    &common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
	    print "\n";
	    print (' ' x 5); 
	    &common::displayInfo($text->[1],5,$containLength);
	    print "\n\n";	
	    return;
	}

	# Get Advanced help on a command in Current Module
	else
	{
	    my %menuCmd=eval("%${currentSubMenu}::${currentSubMenu}_CMDS");		    
	    $text = $menuCmd{$_[0]};	

	    print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 
	    my $containLength = $conf::XSIZE - 5 ;
	    print (' ' x 5); 
	    &common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
	    print "\n";
	    print (' ' x 5); 
	    &common::displayInfo($text->[1],5,$containLength);
	    print "\n\n";	
	    return;
	}	
    }

    # No Argument in Help Call
    else
    {
	# Get Basic Help on Commands in Main Module
	my $containLength = $conf::XSIZE -5;
	&common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
	
	print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
	foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
	{
	    print colored [$common::COLOR_HELPCMD], "  $cmd";
	    $text = $JUGGLINGTB_CMDS{$cmd};
	    print (' ' x ($menuLength - length($cmd))); 
	    my $containLength = $conf::XSIZE - $menuLength -2;
	    &common::displayInfo($text->[0], $menuLength + 2, $containLength);
	}
	
	print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
	if($JUGGLINGTB_MODULES->size==0)
	{
	    print $lang::MSG_MAIN_LSC_NOMODA;
	}
	else
	{
	    print $lang::MSG_MAIN_LSC_MODA;
	    while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	    {
		print colored [$common::COLOR_HELPMENU], "$menu ";
	    }
	    print "\n\n";					
	}
	
	if ($currentSubMenu eq "main")
	{			    
	    # All is already done
	    print "\n";					
	    return;
	}
	
	# Get Basic Help on Commands in Current Module
	else
	{
	    my %subMenu=eval("%${currentSubMenu}::${currentSubmenu}_CMDS");
	    print colored [$common::COLOR_HELPMENU], "\n  ${currentSubMenu} ";
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_INFO"))
	    {		   
		my $menuInfo=eval("\$${currentSubMenu}::${currentSubMenu}_INFO");		    
		print colored [$common::COLOR_HELPMENU], " - $menuInfo ";		    
	    }
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_VERSION"))
	    {
		my $menuVersion = eval("\$${currentSubMenu}::${currentSubMenu}_VERSION");
		print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
	    }
	    
	    print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_HELP"))
	    {
		my $h=eval("\$${currentSubMenu}::${currentSubMenu}_HELP");		    	    	    
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($h,5,$containLength);
		print "\n\n";
	    }

	    my %menuCmd=eval("\%${currentSubMenu}::${currentSubMenu}_CMDS");		    
	    
	    foreach my $cmd (sort keys %menuCmd)
	    {
		$text = $menuCmd{$cmd};	    
		
		print colored [$common::COLOR_HELPCMD], "  - $cmd";
		print (' ' x ($submenuLength - length($cmd))); 
		print " : ";
		my $containLength = $conf::XSIZE - $submenuLength -7;
		&common::displayInfo($text->[0], $submenuLength + 7, $containLength);		
	    }	
	    
	    print "\n\n";	
	    return;
	}
    }

}

sub help2
{
    # Help with One Argument
    if(scalar @_ == 1)
    {	
	if($_[0] =~"main")
	{
	    my $containLength = $conf::XSIZE -5;
	    &common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
	    
	    print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
	    foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
	    {
		print colored [$common::COLOR_HELPCMD], "  $cmd";
		$text = $JUGGLINGTB_CMDS{$cmd};
		print (' ' x ($menuLength - length($cmd))); 
		my $containLength = $conf::XSIZE - $menuLength -2;
		&common::displayInfo($text->[0], $menuLength + 2, $containLength, $common::COLOR_HELPPARAMCMD );		    
		my $containLength = $conf::XSIZE - $menuLength - 5;
		print (' ' x ($menuLength + 5)); 
		&common::displayInfo($text->[1], $menuLength + 5, $containLength );
		print "\n";
	    }
	    
	    print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
	    if($JUGGLINGTB_MODULES->size==0)
	    {
		print $lang::MSG_MAIN_LSC_NOMODA;
	    }
	    else
	    {
		print $lang::MSG_MAIN_LSC_MODA;
		while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
		{
		    print colored [$common::COLOR_HELPMENU], "$menu ";
		}
		print "\n\n";					
	    }
	    
	}
	foreach my $v (@MODULES)
	{
	    # Get Advanced help on the SubMenu
	    if($v =~ $_[0])
	    {
		my $h=eval("\$${v}::${v}_HELP");
		
		my %subMenu=eval("%${v}::${v}_CMDS");
		print colored [$common::COLOR_HELPMENU], "\n  ${v} ";
		
		if(defined ("${v}::${v}_INFO"))
		{		   
		    my $menuInfo=eval("\$${v}::${v}_INFO");		    
		    print colored [$common::COLOR_HELPMENU], " - $menuInfo ";		    
		}
		
		if(defined ("${v}::${v}_VERSION"))
		{
		    my $menuVersion = eval("\$${v}::${v}_VERSION");
		    print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
		}
		
		print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
		
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($h,5,$containLength);
		print "\n\n";
		my %menuCmd=eval("\%${v}::${v}_CMDS");		    		
		foreach my $cmd (sort keys %menuCmd)
		{
		    $text = $menuCmd{$cmd};	    
		    
		    print colored [$common::COLOR_HELPCMD], "  - $cmd";
		    print (' ' x ($submenuLength - length($cmd))); 
		    print " : ";
		    my $containLength = $conf::XSIZE - $submenuLength -7;		     
		    &common::displayInfo($text->[0],$submenuLength + 7, $containLength, $common::COLOR_HELPPARAMCMD );		    
		    my $containLength = $conf::XSIZE -5 ;
		    print (' ' x (5)); 
		    &common::displayInfo($text->[1], 5, $containLength );
		    print "\n\n";	    				    
		}		 		 	
		return ;
	    }

	    # Get Advanced help on a command in absolute format
	    elsif($_[0] =~$v && $_[0] =~/::/)
	    {		
		my $smenufunc = (split(/::/,$_[0]))[1];
		my %menuCmd=eval("\%${v}::${v}_CMDS");	
		$text = $menuCmd{$smenufunc};
		print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
		print "\n";
		print (' ' x 5); 
		&common::displayInfo($text->[1],5,$containLength);
		print "\n\n";	
		return;
	    }	    
	}

	# Get Advanced help on a command in Main Module
	if ($currentSubMenu eq "main")
	{	
	    $text = $JUGGLINGTB_CMDS{$_[0]};	    
	    print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 
	    
	    my $containLength = $conf::XSIZE - 5 ;
	    print (' ' x 5); 
	    &common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
	    print "\n";
	    print (' ' x 5); 
	    &common::displayInfo($text->[1],5,$containLength);
	    print "\n\n";	
	    return;
	}

	# Get Advanced help on a command in Current Module
	else
	{
	    my %menuCmd=eval("%${currentSubMenu}::${currentSubMenu}_CMDS");		    
	    $text = $menuCmd{$_[0]};	
	    print colored [$common::COLOR_HELPCMD], "\n  <$_[0]>\n\n"; 
	    my $containLength = $conf::XSIZE - 5 ;
	    print (' ' x 5); 
	    &common::displayInfo($text->[0],5,$containLength, $common::COLOR_HELPPARAMCMD);
	    print "\n";
	    print (' ' x 5); 
	    &common::displayInfo($text->[1],5,$containLength);
	    print "\n\n";	
	    return;
	}

    }

    # Help without Argument
    ####################################################################

    else
    {
	my $containLength = $conf::XSIZE -5;
	&common::displayInfo($lang::MSG_MAIN_LSC, 5, $containLength); 
	
	print colored [$common::COLOR_HELPMENU], "\n=============  $lang::MSG_MAIN_LSC_MAINCMDS =============\n\n";
	foreach my $cmd (sort keys %JUGGLINGTB_CMDS)
	{
	    print colored [$common::COLOR_HELPCMD], "  $cmd";
	    $text = $JUGGLINGTB_CMDS{$cmd};
	    print (' ' x ($menuLength - length($cmd))); 
	    my $containLength = $conf::XSIZE - $menuLength -2;
	    &common::displayInfo($text->[0], $menuLength + 2, $containLength, $common::COLOR_HELPPARAMCMD );		    
	    my $containLength = $conf::XSIZE - $menuLength - 5;
	    print (' ' x ($menuLength + 5)); 
	    &common::displayInfo($text->[1], $menuLength + 5, $containLength );
	    print "\n";
	}
	
	print colored [$common::COLOR_HELPMENU], "\n============ $lang::MSG_MAIN_LSC_MOD ============\n\n"; 
	if($JUGGLINGTB_MODULES->size==0)
	{
	    print $lang::MSG_MAIN_LSC_NOMODA;
	}
	else
	{
	    print $lang::MSG_MAIN_LSC_MODA;
	    while (defined(my $menu = $JUGGLINGTB_MODULES->each)) 
	    {
		print colored [$common::COLOR_HELPMENU], "$menu ";
	    }
	    print "\n\n";					
	}
	
	if ($currentSubMenu eq "main")
	{		
	    # Get Advanced help in Main Module
	    # All is already done
	    print "\n";					
	    return;
	}
	
	else
	{
	    # Get Advanced help in Current Module
	    my %subMenu=eval("%${currentSubMenu}::${currentSubmenu}_CMDS");
	    print colored [$common::COLOR_HELPMENU], "\n  ${currentSubMenu} ";
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_INFO"))
	    {		   
		my $menuInfo=eval("\$${currentSubMenu}::${currentSubMenu}_INFO");		    
		print colored [$common::COLOR_HELPMENU], " - $menuInfo ";		    
	    }
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_VERSION"))
	    {
		my $menuVersion = eval("\$${currentSubMenu}::${currentSubMenu}_VERSION");
		print colored [$common::COLOR_HELPMENU], "($menuVersion)";		    
	    }
	    
	    print colored [$common::COLOR_HELPMENU], "\n-----------------------------------------\n";
	    
	    if(defined ("${currentSubMenu}::${currentSubMenu}_HELP"))
	    {
		my $h=eval("\$${currentSubMenu}::${currentSubMenu}_HELP");		    	    	    
		my $containLength = $conf::XSIZE - 5 ;
		print (' ' x 5); 
		&common::displayInfo($h,5,$containLength);
		print "\n\n";
	    }
	    
	    my %menuCmd=eval("\%${currentSubMenu}::${currentSubMenu}_CMDS");		    
	    
	    foreach my $cmd (sort keys %menuCmd)
	    {
		$text = $menuCmd{$cmd};	    
		
		print colored [$common::COLOR_HELPCMD], "  - $cmd";
		print (' ' x ($submenuLength - length($cmd))); 
		my $containLength = $conf::XSIZE - $submenuLength - 7 ;
		&common::displayInfo($text->[0],$submenuLength + 7, $containLength, $common::COLOR_HELPPARAMCMD );		    
		my $containLength = $conf::XSIZE -5 ;
		print (' ' x (5)); 
		&common::displayInfo($text->[1], 5, $containLength );
		print "\n\n";
		
	    }			
	    
	    return;
	}	    
	
    }    
}



sub exit 
{
    exit $_[0];
}

sub quit 
{
    exit $_[0];
}

sub bye
{
    exit $_[0];
}



## 
## Main Part - 2
##

if($conf::jtbOptions_h)
{
    &usage();
    &lsc();     
    exit 1;
}

if($conf::jtbOptions_H)
{
    &usage();
    &lsc2();     
    exit 1;
}

if($conf::jtbOptions_v)
{
    print "JugglingTB : $JUGGLINGTB_VERSION\n"; 
    print "Copyright : $common::AUTHOR ($common::AUTHOR_MAIL)\n";       
    exit 1;
}    

if($conf::jtbOptions_u)
{ 
    &usage();
    exit 1;
}


&runEnv();


END
{
    if($conf::jtbOptions_a)
    {
	print "\n";
	if($common::OS eq "MSWin32")
	{
	    Term::ReadKey::ReadMode(0);
	}
    }
}
