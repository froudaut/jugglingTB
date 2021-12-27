#  ==== README for jugglingTB v1.5 ====

Author : Frederic Roudaut  


jugglingTB's goal is to provide an adaptative toolbox for different
juggling notations. It is designed to be easily extended. It was for my own needs only first to understand some algorithms and to write articles.
Thus do not expect some huge optimization ... I do it according to my need ;-/

Currently it supports the following notations :

- BTN : Body Trick Notation
- Extended SOU: Side-Over-Under Notation
- MMSTD: Mills Mess State Transition Diagram
- LADDER: Ladder Notation
- SSWAP: Siteswap Notation
- STACK: Stack Notation
- HTN: 3-Layers Notation/Harmonic Throws Notation
- SPYRO: Spyrograph for Spin/Antispin/Hybrids/Isolations ...

The SSWAP module contains the great Tool JugglingLab from Jack Boyce.
For my personal needs I added others tools:
- jdeep from Jack Boyce
- HTNMaker from Shawn Pinciara
- LABInfinite from MCP
- juggleSpyro, another personnal project
- PowerJuggler from Marco Tarini
- realsim from Pedro Teodoro
- Polyrythm-Fountain from Josh Mermelstein
	      
All of them may be launched from jugglingTB

## NEEDS & INSTALLATION

To use this tool you have 2 choices :
- using a binary
- starting from sources and installing mandatory modules.


### Binary 

You will find a binary for Windows 64bits (packaged with Strawberry Perl (64-bit) 5.32.1-64bit) named jugglingTB.exe. 
Simply run this file. 
A binary version packaged on Ubuntu, named jugglingTB.bin is also provided on some packages. 

### Sources

If you choose starting from sources, first of all you need Perl. 
You may find it quite easily on Linux and for Windows you should try with ActivePerl or Strawberry.

You may install them by yourself or simply by using the perl script __internal-install :  
    perl __internal-install

This script will install for you the following perl modules :
 - "Devel-Symdump", 
 - "Set-Scalar", 
 - "Parse-Yapp", 
 - "Excel-Writer-XLSX", 
 - "Perl4-CoreLibs", 
 - "File-Grep", 
 - "File-Copy-Recursive", 
 - "TermReadKey", 
 - "HTTP-Server-Simple",
 - "Win32-Console-ANSI" : usefull if you want to get color on "Cmd" terminals. 
 - "Chart-Gnuplot" : usefull for Autocompletion on Windows (!! Think to press 4 times on <ENTER> to avoid a Perl bug on Windows)
   

It will also configure conf.pm needed by jugglingTB. 
This file contains some different variables used by the Tool : 

  \# Langage

  LANG="FRENCH"

  \# Command to start HTML Browser

  HTTP_BROWSER="C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"

\# Columns Size for display

  XSIZE="60"

\# Default behaviour when starting JugglingToolBox. 0 is for not set, 1 is for set

  \# Usage when calling jugglingTB :

  jtbOptions_u="0"

  \# JugglingTB version 

  jtbOptions_v="0"

  \# JugglingTB Colorisation 

  jtbOptions_c="1"

  \# JugglingTB Help

  jtbOptions_h="0"

  \# JugglingTB Extended Help

  jtbOptions_H="0"

  \# JugglingTB Autocompletion

  jtbOptions_a="0"

  \# Unicode handling in lang.pm

  jtbOptions_s="0"

  \# Debug Mode

  jtbOptions_d="-1"

  \# Launch Tierce Appli for results

  jtbOptions_r="1"

By default, these options are not set. This default behaviour may be changed in
<conf.ini>. In this case, to unset an option you may have to explicitely indicate
 this by using the prefix <-no> when running jugglingTB.

\#\#\#  MODULES PARAMETERS \#\#\#

  \# All results will be set in this directory

  RESULTS="results"

  \# Local Temp Directory

  TMPDIR="tmp"

  \# JugglingLab Path (start with [CWD] for a relative path)

  JUGGLING_LAB_PATH="[CWD]/data/JugglingLab/v1.4.1"

  \# JML Version for JugglingLab

  JUGGLING_LAB_JML_VERSION="1.2"

  \# GRAPHVIZ Path for binary (needed to draw graphs such as Siteswap States-Transitions Diagram) (Mod LADDER/SSWAP)

  GRAPHVIZ_BIN="C:\Program Files (x86)\Graphviz\bin"

  \# GNUPLOT binary (needed to draw graphs such as HTN Grids) (Mod HTN)

  GNUPLOT_BIN="C:\Program Files\Gnuplot\bin\gnuplot.exe"

  \# Columns Size for display in Excel (Mod SSWAP)

  EXCELCOLSIZE="auto"

  
## RUNNING jugglingTB

 USAGE :  perl [[-|-no][a|c|h|H|i|s|u|v]] ./jugglingTB.pl

  -a : Activate autocompletion (Using C^d and <TAB>,  C^U to clear). [Very Bad using Cmd on MsWindows ;-(].
  -c : Give a colored interface for jugglingTB. It can be used only on ANSI capable terminal [ie not Cmd on MsWindows ;-(]
  -h : Help for jugglingTB.
  -H : Extended Help for jugglingTB.
  -i : Configuration File for jugglingTB (Default:conf.ini).
  -s : Display Special Characters (Unicode) in the Menus.
  -u : Usage for running jugglingTB.
  -v : Give the Version without running jugglingTB.

By default, these options are not set. This default behaviour may be changed in <conf.ini>. 
In this case, to unset an option you may have to explicitely indicate this by using the prefix <-no>.
Some configuration parameters may also be configured in <conf.ini> (such as the language for example).

## USING jugglingTB

cf help.en.txt/help.fr.txt for all available commands.

All private and public commands available from any menu may be get by
using the autocompletion functionnality of jugglingTB if set. 
Juste press TAB to get the completion if possible. Otherwise use C^D
(Control-D) to get possible completion. C^U will erase the current input.

Because of a Perl Bug, if you use autocompletion on Windows you will have to press 4 Times the <ENTER> Key instead of only once.


## EXTENDED jugglingTB

jugglingTB is very easy to extend. 
See modules/MODTEST.pm for an example on how create a new module.


What you need first of all is to declare the package and the basis
needed by jugglingTB :

-----------------------------------------------------------------
package MODTEST;
  
use common;

  use strict;

  use lang;

  use Term::ANSIColor;

$Term::ANSIColor::AUTORESET = 1;

&lang::initLang();

print "MODTEST $MODTEST::MODTEST_VERSION loaded\n";

  our $MODTEST_INFO = "MODTEST juggling Notation";

  our $MODTEST_HELP = "Test Module";

  our $MODTEST_VERSION = "v1.1";
  
-----------------------------------------------------------------


Every command of the module has also to be declared : 

-----------------------------------------------------------------
our %MODTEST_CMDS =
  
    (
  
         'cmd1'                  => ["cmd1hlp1","cmd1hlp2"],
  
         'cmd2'                  => ["cmd1hlp1","cmd1hlp2"]
  
    );
  
-----------------------------------------------------------------

The first string is the help information that will be automaticaly
printed by help/lsc.
The second one is the help information for the parameters that will be
printed by : help("cmd1") in the MODTEST Menu for example.  


You must also defined the content of the commands:

-----------------------------------------------------------------
sub cmd1

  {
  
    print colored [$common::COLOR_RESULT], "This is the Cmd1 Result\n";

  }


sub cmd2

  {
  
    print colored [$common::COLOR_RESULT], "This is the Cmd2 Result\n";

  }
  
 -----------------------------------------------------------------

If you want to use the multilanguage capability you have to declare
all the string to print in lang.pm.

After that you must indicate this module in jugglingTB.pl :

-----------------------------------------------------------------
use modules::MODTEST;

my @MODULES= ("BTN", "SOU", "MMSTD", "SITESWAP", "MODTEST");
  
-----------------------------------------------------------------

and that's all, all the help, command execution, menus ... will be
automaticaly taken into account. 
