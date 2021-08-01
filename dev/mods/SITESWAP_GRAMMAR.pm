####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package SITESWAP_GRAMMAR;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver );
use Parse::Yapp::Driver;



sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'digit' => 2,
			"(" => 1,
			"[" => 5,
			'lexerror' => 6
		},
		DEFAULT => -4,
		GOTOS => {
			'input' => 4,
			'SS_class' => 3,
			'SS_sync' => 7
		}
	},
	{#State 1
		ACTIONS => {
			'digit' => 8,
			"[" => 11
		},
		GOTOS => {
			'SS_mult_with_x' => 9,
			'value' => 10,
			'SS_simpl' => 12
		}
	},
	{#State 2
		ACTIONS => {
			'digit' => 2,
			"[" => 5
		},
		DEFAULT => -4,
		GOTOS => {
			'SS_class' => 13
		}
	},
	{#State 3
		ACTIONS => {
			"*" => 14
		},
		DEFAULT => -17,
		GOTOS => {
			'SS_ext' => 15
		}
	},
	{#State 4
		ACTIONS => {
			'' => 16
		}
	},
	{#State 5
		ACTIONS => {
			'digit' => 18
		},
		GOTOS => {
			'SS_async' => 17
		}
	},
	{#State 6
		DEFAULT => -3
	},
	{#State 7
		ACTIONS => {
			"*" => 14
		},
		DEFAULT => -17,
		GOTOS => {
			'SS_ext' => 19
		}
	},
	{#State 8
		ACTIONS => {
			"x" => 20,
			"X" => 21
		},
		DEFAULT => -19
	},
	{#State 9
		DEFAULT => -12
	},
	{#State 10
		DEFAULT => -11
	},
	{#State 11
		ACTIONS => {
			'digit' => 8
		},
		GOTOS => {
			'SS_async_with_x' => 22,
			'value' => 23
		}
	},
	{#State 12
		ACTIONS => {
			"," => 24
		}
	},
	{#State 13
		DEFAULT => -5
	},
	{#State 14
		DEFAULT => -18
	},
	{#State 15
		DEFAULT => -1
	},
	{#State 16
		DEFAULT => 0
	},
	{#State 17
		ACTIONS => {
			"]" => 25
		}
	},
	{#State 18
		ACTIONS => {
			'digit' => 18
		},
		DEFAULT => -8,
		GOTOS => {
			'SS_async' => 26
		}
	},
	{#State 19
		DEFAULT => -2
	},
	{#State 20
		DEFAULT => -20
	},
	{#State 21
		DEFAULT => -21
	},
	{#State 22
		ACTIONS => {
			"]" => 27
		}
	},
	{#State 23
		ACTIONS => {
			'digit' => 8
		},
		DEFAULT => -14,
		GOTOS => {
			'SS_async_with_x' => 28,
			'value' => 23
		}
	},
	{#State 24
		ACTIONS => {
			'digit' => 8,
			"[" => 11
		},
		GOTOS => {
			'SS_mult_with_x' => 9,
			'value' => 10,
			'SS_simpl' => 29
		}
	},
	{#State 25
		ACTIONS => {
			'digit' => 2,
			"[" => 5
		},
		DEFAULT => -4,
		GOTOS => {
			'SS_class' => 30
		}
	},
	{#State 26
		DEFAULT => -7
	},
	{#State 27
		ACTIONS => {
			"[" => 11
		},
		DEFAULT => -16,
		GOTOS => {
			'SS_mult_with_x' => 31
		}
	},
	{#State 28
		DEFAULT => -13
	},
	{#State 29
		ACTIONS => {
			")" => 32
		}
	},
	{#State 30
		DEFAULT => -6
	},
	{#State 31
		DEFAULT => -15
	},
	{#State 32
		ACTIONS => {
			"(" => 1
		},
		DEFAULT => -10,
		GOTOS => {
			'SS_sync' => 33
		}
	},
	{#State 33
		DEFAULT => -9
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'input', 2,
sub
#line 4 "SITESWAP_GRAMMAR.yp"
{
    #my @res = @main::SWP;  
    #@main::SWP = ();
    #$main::idxSwp=0;
    #$main::SSsize=$_[1] + $_[1]*$_[2];
    #print $main::SSsize;
    return 0;
}
	],
	[#Rule 2
		 'input', 2,
sub
#line 13 "SITESWAP_GRAMMAR.yp"
{
    #my @res = @main::SWP;  
    #@main::SWP = ();
    #$main::idxSwp=0;
    #$main::SSsize=$_[1] +$_[1]*$_[2];
    #print $main::SSsize;
    return 0;
}
	],
	[#Rule 3
		 'input', 1,
sub
#line 22 "SITESWAP_GRAMMAR.yp"
{
    #$main::SSsize=0;
    return -1;
}
	],
	[#Rule 4
		 'SS_class', 0,
sub
#line 29 "SITESWAP_GRAMMAR.yp"
{
    #0;
}
	],
	[#Rule 5
		 'SS_class', 2,
sub
#line 34 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1])+$_[2];
}
	],
	[#Rule 6
		 'SS_class', 4,
sub
#line 39 "SITESWAP_GRAMMAR.yp"
{
    #$_[2]+$_[4];
}
	],
	[#Rule 7
		 'SS_async', 2,
sub
#line 45 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1])+$_[2];
}
	],
	[#Rule 8
		 'SS_async', 1,
sub
#line 49 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1]);
}
	],
	[#Rule 9
		 'SS_sync', 6,
sub
#line 61 "SITESWAP_GRAMMAR.yp"
{
    #$_[2]+$_[4]+$_[6];
}
	],
	[#Rule 10
		 'SS_sync', 5,
sub
#line 65 "SITESWAP_GRAMMAR.yp"
{
    #$_[2]+$_[4];
}
	],
	[#Rule 11
		 'SS_simpl', 1,
sub
#line 70 "SITESWAP_GRAMMAR.yp"
{
    #$_[1];
}
	],
	[#Rule 12
		 'SS_simpl', 1,
sub
#line 74 "SITESWAP_GRAMMAR.yp"
{
    #$_[1];
}
	],
	[#Rule 13
		 'SS_async_with_x', 2,
sub
#line 79 "SITESWAP_GRAMMAR.yp"
{
    #$_[1] + $_[2];
}
	],
	[#Rule 14
		 'SS_async_with_x', 1,
sub
#line 83 "SITESWAP_GRAMMAR.yp"
{
    #$_[1];
}
	],
	[#Rule 15
		 'SS_mult_with_x', 4,
sub
#line 88 "SITESWAP_GRAMMAR.yp"
{
    #$_[2] + $_[4];
}
	],
	[#Rule 16
		 'SS_mult_with_x', 3,
sub
#line 92 "SITESWAP_GRAMMAR.yp"
{
    #$_[2];
}
	],
	[#Rule 17
		 'SS_ext', 0,
sub
#line 98 "SITESWAP_GRAMMAR.yp"
{
    #0;
}
	],
	[#Rule 18
		 'SS_ext', 1,
sub
#line 102 "SITESWAP_GRAMMAR.yp"
{
    #1;
}
	],
	[#Rule 19
		 'value', 1,
sub
#line 107 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1]);
}
	],
	[#Rule 20
		 'value', 2,
sub
#line 111 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1]);
}
	],
	[#Rule 21
		 'value', 2,
sub
#line 115 "SITESWAP_GRAMMAR.yp"
{
    #int($_[1]);
}
	]
],
                                  @_);
    bless($self,$class);
}

#line 120 "SITESWAP_GRAMMAR.yp"


my $Input = "";
my $In="";

sub parse 
{
    $Input="$_[0]";        
    $In="$_[0]";
        my $p = new SITESWAP_GRAMMAR();        
    my $res = $p->YYParse( yylex => \&yylex, yyerror => \&yyerror);
    if($res==-1) {
	return $res;
    }
    return $p->YYNberr();
}

sub yyerror {
    my $e=join(", ",$_[0]->YYExpect);
    if($e ne "") {
    	  printf STDERR ('Error: a "%s" was found in <"%s"> where "%s" was expected'."\n", $_[0]->YYCurtok, $In, $_[0]->YYExpect);
	}
    else		
	{		
	    printf STDERR ('Error: a "%s" was found in "%s"'."\n", $_[0]->YYCurtok, $In);	
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
	s!^([\[\](),*xX])!! and return ($1, $1);
	print STDERR "Unexpected symbols: $Input\n" and return ("lexerror",$1);;	
    }
}

1;
