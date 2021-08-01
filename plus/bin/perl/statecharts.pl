#! /usr/bin/perl  -W
#
#   schart.pl, version 1
#
#   Prints state charts (a juggling notation for siteswaps)
#   Written on 24-25th March 2005 by Daniel Clemente (n142857@at@gmail/com),
#  while learning Perl ("man perlintro")
#
#   More help at http://www.danielclemente.com/linux/schart.html
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, version 2.
#

use strict;
use Getopt::Std;

my %opts;
getopts('htxm:n:', \%opts) or &usage();
&usage() if $opts{h};

die("Please tell me the maximum throw height. (See $0 -h)\n")
  unless defined $opts{m};

my $max_throw=$opts{m};
die("${max_throw}??? ".
  "Could the maximum throw type be a natural number, please?\n")
  unless $max_throw =~ /^\d+$/;

if (defined $opts{n}) {
  die("I want the number of balls to be a natural\n")
    unless $opts{n} =~ /^\d+$/;
}
my $only_n_balls=$opts{n};

#  This flag says we want the table made of "throw types" for each state,
# not "next state" for each throw type
my $tttable=$opts{t};

my $putXs=$opts{x};

# Finished parsing options


my $last_state=2**$max_throw-1;

# Number of characters needed to print any state in decimal form
my $last_state_width=length $last_state;



print "Juggling state chart\nfor throws up to $max_throw, ",
  (defined $only_n_balls) ?
    "but only for $only_n_balls balls\n\n" :
    "including pickups (+) and drops (-)\n\n"
  ;



print " || State", " "x($max_throw+2+$last_state_width+2-6), "|";

unless (defined $tttable) {  # The default behaviour

  # We want + and - columns if dealing with a variable number of balls
  unless (defined $only_n_balls) {
    print " ", &state_decimal('+'), " |";
    print " ", &state_decimal('-'), " |";
  }

  print " ", &state_decimal($_), " |" foreach (0..$max_throw);

  # Print a lot of dashes (------...)
  print "|\n%|", "-"x(
    ($max_throw+1+(defined $only_n_balls?0:2)) * ($last_state_width+3) +
    ($max_throw==0?1:$max_throw) + 2 + $last_state_width + 2 + 1
    ), "||\n";

} else { # Column headers are states

  my $number_of_columns=0;
  foreach (0..$last_state) {

    # Don't show states which don't have the desired number of balls
    if (defined $only_n_balls) {
      next if &number_of_ones($_) != $only_n_balls;
    }

    # We will need this to print the dashes on the next line
    $number_of_columns++;

    print " ", &state_decimal($_), " |";
  }

  # Print a lot of dashes (------...)
  print "|\n%|", "-"x(
    ($number_of_columns)*($last_state_width+3) +
    ($max_throw==0?1:$max_throw) + 2 + $last_state_width + 2 + 1
    ), "||\n";

}


my $state;
for($state=0; $state<=$last_state; $state++) {   # For every row

  if (defined $only_n_balls) {
    next if &number_of_ones($state) != $only_n_balls;
  }

  # A hash to store the result state for each throw in the current state
  my %transitions;

  # Ends in 0: we have no balls to throw; we can take one (+) or 'throw' a 0
  if ( ($state & 1) == 0) {

    $transitions{0}=$state>>1;         # 'Pop' it from the queue

    $transitions{'+'}=$state|1;

  } else {
    # We have a ball; maybe we can throw a 1, 2, 3, 4, ... or drop it (-)

    $transitions{'-'}=$state-1; # Switch off the LSB (least signifiant bit)

    foreach my $throw_type (1..$max_throw) {
      my $ends=2**$throw_type;       # Has a 1 where the ball would land

      $transitions{$throw_type}=($state|$ends)>>1
        if ( ($state & $ends) == 0); # Only if no other balls will be there
    }

  }

  # Now print the columns with the transitions for the current state
  print " | ".&state_binary($state)." (".&state_decimal($state).") |";

  unless (defined $tttable) {  # Each row has states

    foreach my $column ('+', '-', 0..$max_throw) {
      if (defined $only_n_balls) {
        next if $column eq '+' || $column eq '-';
      }

      # This will be printed if we don't know the transition
      my $number=" "x$last_state_width;

      $number=&state_decimal($transitions{$column})
        if defined $transitions{$column};

      print " ", $number, " |";
    }

  } else {                     # Each row has throw types

    my $state2;
    foreach my $state2 (0..$last_state) {        # For every column

      # Some columns may be missing in the table
      if (defined $only_n_balls) {
        next if &number_of_ones($state2) != $only_n_balls;
      }

      # Is there any $throw_made so that $transitions{$throw_made}==$state2 ?
      my $throw_made;
      foreach (keys %transitions) {
        if ($transitions{$_}==$state2) {
          $throw_made=$_;
          last;    # We have already found it
        }
      }

      my $number=" "x$last_state_width;     # Default value is blank
      if (defined $throw_made) {
        unless ( defined $only_n_balls &&
          ($throw_made eq '+' || $throw_made eq '-')
        ) {
          $number=&state_decimal($throw_made)
        }
      }

      $number=&state_decimal('X')
        if (defined $putXs && $state eq $state2 && $number=~/^[ ]*$/);

      print " ", $number, " |";

    }
  }

  print "|\n";     # Row printed

}

print "\n";

exit 0;       # And here ends the program


sub state_binary {      # Pad with zeros to the left
    return sprintf("%0${max_throw}b", shift);
}

sub state_decimal {     # Pad with spaces to the left
  # Note that states and throw types are treated equally (same padding)

  return " "x($last_state_width-1).$_[0] if ($_[0] =~ /^[+-X]$/);

  return sprintf("%${last_state_width}u", shift);
}

sub number_of_ones {
  my $total=0;
  my $n=shift;
  while($n>0) {
    $total+=($n&1);
    $n>>=1;
  }
  return $total;
}

sub usage {
  print STDERR << "EOF";

Usage: $0 -m max_throw [-n balls] [-t] [-x] [-h]

-m max_throw : which throw heights to consider (from 0 to max_throw).
-n balls     : only show states with that number of balls; no drops or pickups.
-t           : show the throw types inside the table, and use the "final state"
               as the horizontal axis. Easier to understand, but tables are
               giant (2^max_throw rows and 2^max_throw columns).
-x           : when -t is on, add X marks as reference points
-h           : show this help

Example : $0 -m5 -n3 -t -x

You can use txt2tags to convert the output to other formats, like TeX and HTML.

schart.pl, version 1. March 2005, Daniel Clemente. License: GPL
More help at http://www.danielclemente.com/linux/schart.html

EOF
  exit;
}
