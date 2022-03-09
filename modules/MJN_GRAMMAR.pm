####################################################################
#
#    This file was generated using Parse::Yapp version 1.21.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package MJN_GRAMMAR;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.21',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			"<" => 4,
			'lexerror' => 3
		},
		GOTOS => {
			'input' => 1,
			'MJN' => 2
		}
	},
	{#State 1
		ACTIONS => {
			'' => 5
		}
	},
	{#State 2
		DEFAULT => -1
	},
	{#State 3
		DEFAULT => -2
	},
	{#State 4
		ACTIONS => {
			"[" => 10,
			'digit' => 9,
			"(" => 7
		},
		GOTOS => {
			'jugglers' => 6,
			'throw' => 8
		}
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		ACTIONS => {
			">" => 11
		}
	},
	{#State 7
		ACTIONS => {
			"[" => 10,
			'digit' => 9,
			"(" => 7
		},
		GOTOS => {
			'throw' => 12
		}
	},
	{#State 8
		ACTIONS => {
			"|" => 13
		},
		DEFAULT => -5
	},
	{#State 9
		ACTIONS => {
			"p" => 14,
			"x" => 15
		},
		DEFAULT => -7
	},
	{#State 10
		ACTIONS => {
			'digit' => 17
		},
		GOTOS => {
			'mult' => 16
		}
	},
	{#State 11
		ACTIONS => {
			"<" => 4
		},
		DEFAULT => -3,
		GOTOS => {
			'MJN' => 18
		}
	},
	{#State 12
		ACTIONS => {
			"," => 19
		}
	},
	{#State 13
		ACTIONS => {
			"(" => 7,
			"[" => 10,
			'digit' => 9
		},
		GOTOS => {
			'throw' => 8,
			'jugglers' => 20
		}
	},
	{#State 14
		ACTIONS => {
			'digit' => 21
		},
		DEFAULT => -9
	},
	{#State 15
		ACTIONS => {
			"p" => 22
		},
		DEFAULT => -8
	},
	{#State 16
		ACTIONS => {
			"]" => 23
		}
	},
	{#State 17
		ACTIONS => {
			"x" => 24,
			'digit' => 17,
			"p" => 26
		},
		DEFAULT => -16,
		GOTOS => {
			'mult' => 25
		}
	},
	{#State 18
		DEFAULT => -4
	},
	{#State 19
		ACTIONS => {
			"[" => 10,
			'digit' => 9,
			"(" => 7
		},
		GOTOS => {
			'throw' => 27
		}
	},
	{#State 20
		DEFAULT => -6
	},
	{#State 21
		DEFAULT => -10
	},
	{#State 22
		ACTIONS => {
			'digit' => 28
		},
		DEFAULT => -11
	},
	{#State 23
		DEFAULT => -13
	},
	{#State 24
		ACTIONS => {
			"p" => 30,
			'digit' => 17
		},
		DEFAULT => -17,
		GOTOS => {
			'mult' => 29
		}
	},
	{#State 25
		DEFAULT => -22
	},
	{#State 26
		ACTIONS => {
			'digit' => 31,
			"/" => 32
		},
		DEFAULT => -18
	},
	{#State 27
		ACTIONS => {
			")" => 33
		}
	},
	{#State 28
		DEFAULT => -12
	},
	{#State 29
		DEFAULT => -23
	},
	{#State 30
		ACTIONS => {
			'digit' => 35,
			"/" => 34
		},
		DEFAULT => -20
	},
	{#State 31
		ACTIONS => {
			'digit' => 17
		},
		DEFAULT => -19,
		GOTOS => {
			'mult' => 36
		}
	},
	{#State 32
		ACTIONS => {
			'digit' => 17
		},
		GOTOS => {
			'mult' => 37
		}
	},
	{#State 33
		ACTIONS => {
			"!" => 38
		},
		DEFAULT => -14
	},
	{#State 34
		ACTIONS => {
			'digit' => 17
		},
		GOTOS => {
			'mult' => 39
		}
	},
	{#State 35
		ACTIONS => {
			'digit' => 17
		},
		DEFAULT => -21,
		GOTOS => {
			'mult' => 40
		}
	},
	{#State 36
		DEFAULT => -25
	},
	{#State 37
		DEFAULT => -24
	},
	{#State 38
		DEFAULT => -15
	},
	{#State 39
		DEFAULT => -26
	},
	{#State 40
		DEFAULT => -27
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'input', 1,
sub
#line 4 "MJN_GRAMMAR.yp"
{
    # Return is : 
    # Error : -1    
    return 1;
}
	],
	[#Rule 2
		 'input', 1,
sub
#line 10 "MJN_GRAMMAR.yp"
{
    return -1;
}
	],
	[#Rule 3
		 'MJN', 3,
sub
#line 17 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 4
		 'MJN', 4,
sub
#line 20 "MJN_GRAMMAR.yp"
{ 
}
	],
	[#Rule 5
		 'jugglers', 1,
sub
#line 26 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 6
		 'jugglers', 3,
sub
#line 29 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 7
		 'throw', 1,
sub
#line 36 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 8
		 'throw', 2,
sub
#line 39 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 9
		 'throw', 2,
sub
#line 42 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 10
		 'throw', 3,
sub
#line 45 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 11
		 'throw', 3,
sub
#line 48 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 12
		 'throw', 4,
sub
#line 51 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 13
		 'throw', 3,
sub
#line 54 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 14
		 'throw', 5,
sub
#line 57 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 15
		 'throw', 6,
sub
#line 60 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 16
		 'mult', 1,
sub
#line 66 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 17
		 'mult', 2,
sub
#line 69 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 18
		 'mult', 2,
sub
#line 72 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 19
		 'mult', 3,
sub
#line 75 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 20
		 'mult', 3,
sub
#line 78 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 21
		 'mult', 4,
sub
#line 81 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 22
		 'mult', 2,
sub
#line 84 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 23
		 'mult', 3,
sub
#line 87 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 24
		 'mult', 4,
sub
#line 90 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 25
		 'mult', 4,
sub
#line 93 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 26
		 'mult', 5,
sub
#line 96 "MJN_GRAMMAR.yp"
{
}
	],
	[#Rule 27
		 'mult', 5,
sub
#line 99 "MJN_GRAMMAR.yp"
{
}
	]
],
                                  @_);
    bless($self,$class);
}

#line 105 "MJN_GRAMMAR.yp"


my $Input = "";
my $In="";
my $verbose = "0";

sub parse 
{
    $Input="$_[0]";        
    $In="$_[0]";
    if (scalar @_ > 1 && $_[1] eq '-1')
    {
	$verbose = "$_[1]";
    }
    else
    {
	$verbose = "0";
    }
    my $p = new MJN_GRAMMAR();        
    my $res = $p->YYParse( yylex => \&yylex, yyerror => \&yyerror);
    if($res==-1) {
	return $res;
    }
    elsif($p->YYNberr() != 0) {
	return -1;
    }
    else {
	return $res;
    }	
}

sub yyerror {
    my $e=join(", ",$_[0]->YYExpect);
    if($e ne "") {
    	if($verbose ne "-1") {
		printf STDERR ('Error: a "%s" was found in "%s" where "%s" was expected'."\n", $_[0]->YYCurtok, $In, $_[0]->YYExpect);
	}
    }
    else		
	{
	 if($verbose ne "-1") {
	    printf STDERR ('Error: a "%s" was found in "%s"'."\n", $_[0]->YYCurtok, $In);	    
	 }
    	}
}


sub init_lexical_file{
    my $file = shift;
    local $/;
    undef $/;
    if ($file) {
	open F, $file or die "$!";
	$Input = <F>;
	close F;
    } else {
	$Input = <>
	    }
}

sub yylex{
    for($Input){
	# Advance spaces
	    1 while (s!^(\s+|\n)!!g);
	# EOF
	    return ("","") if $_ eq "";
	# Tokens
	    s!^([A-Fa-f0-9])!! and return ("digit", $1);
	s!^([<>\[\]\|\(\)PXpx,/\!])!! and return ($1, $1);
    	if($verbose ne "-1") {
		print STDERR "Unexpected symbols: $Input\n" and return ("lexerror",$1);
	}
	else
	{
		return ("lexerror",$1);
	}
    }
}

1;
