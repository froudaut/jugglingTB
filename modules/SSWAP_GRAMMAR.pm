####################################################################
#
#    This file was generated using Parse::Yapp version 1.21.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package SSWAP_GRAMMAR;
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
			"*" => 3,
			'digit' => 12,
			"!" => 9,
			"[" => 6,
			'lexerror' => 11,
			"(" => 2
		},
		GOTOS => {
			'SS_async' => 7,
			'SS_unitary' => 8,
			'SS_extend' => 1,
			'input' => 10,
			'SS' => 4,
			'value' => 13,
			'SS_sync' => 5
		}
	},
	{#State 1
		ACTIONS => {
			"(" => 2,
			"[" => 6,
			'digit' => 12
		},
		GOTOS => {
			'SS' => 14,
			'SS_sync' => 5,
			'value' => 13,
			'SS_async' => 7,
			'SS_unitary' => 8
		}
	},
	{#State 2
		ACTIONS => {
			'digit' => 12,
			"[" => 6
		},
		GOTOS => {
			'SS_async' => 16,
			'SS_multisync_in_sync' => 15,
			'value' => 13
		}
	},
	{#State 3
		ACTIONS => {
			"*" => 3,
			"!" => 9
		},
		DEFAULT => -8,
		GOTOS => {
			'SS_extend' => 17
		}
	},
	{#State 4
		DEFAULT => -1
	},
	{#State 5
		DEFAULT => -13
	},
	{#State 6
		ACTIONS => {
			'digit' => 12
		},
		GOTOS => {
			'value' => 19,
			'SS_vanilla' => 18
		}
	},
	{#State 7
		DEFAULT => -12
	},
	{#State 8
		ACTIONS => {
			"!" => 9,
			"(" => 2,
			"*" => 3,
			'digit' => 12,
			"[" => 6
		},
		DEFAULT => -4,
		GOTOS => {
			'SS_extend' => 20,
			'SS_unitary' => 8,
			'SS_async' => 7,
			'SS' => 21,
			'value' => 13,
			'SS_sync' => 5
		}
	},
	{#State 9
		ACTIONS => {
			"*" => 3,
			"!" => 9
		},
		DEFAULT => -10,
		GOTOS => {
			'SS_extend' => 22
		}
	},
	{#State 10
		ACTIONS => {
			'' => 23
		}
	},
	{#State 11
		DEFAULT => -3
	},
	{#State 12
		ACTIONS => {
			"X" => 25,
			"x" => 24
		},
		DEFAULT => -23
	},
	{#State 13
		DEFAULT => -14
	},
	{#State 14
		DEFAULT => -2
	},
	{#State 15
		ACTIONS => {
			"," => 26
		}
	},
	{#State 16
		ACTIONS => {
			"!" => 9,
			"*" => 3,
			'digit' => 12,
			"[" => 6
		},
		DEFAULT => -18,
		GOTOS => {
			'value' => 13,
			'SS_extend' => 28,
			'SS_multisync_in_sync' => 27,
			'SS_async' => 16
		}
	},
	{#State 17
		DEFAULT => -9
	},
	{#State 18
		ACTIONS => {
			"]" => 29
		}
	},
	{#State 19
		ACTIONS => {
			'digit' => 12
		},
		DEFAULT => -16,
		GOTOS => {
			'value' => 19,
			'SS_vanilla' => 30
		}
	},
	{#State 20
		ACTIONS => {
			'digit' => 12,
			"(" => 2,
			"[" => 6
		},
		DEFAULT => -5,
		GOTOS => {
			'SS_async' => 7,
			'SS_unitary' => 8,
			'SS' => 31,
			'SS_sync' => 5,
			'value' => 13
		}
	},
	{#State 21
		DEFAULT => -6
	},
	{#State 22
		DEFAULT => -11
	},
	{#State 23
		DEFAULT => 0
	},
	{#State 24
		DEFAULT => -24
	},
	{#State 25
		DEFAULT => -25
	},
	{#State 26
		ACTIONS => {
			'digit' => 12,
			"[" => 6
		},
		GOTOS => {
			'SS_multisync_in_sync' => 32,
			'value' => 13,
			'SS_async' => 16
		}
	},
	{#State 27
		DEFAULT => -20
	},
	{#State 28
		ACTIONS => {
			'digit' => 12,
			"[" => 6
		},
		DEFAULT => -19,
		GOTOS => {
			'SS_multisync_in_sync' => 33,
			'value' => 13,
			'SS_async' => 16
		}
	},
	{#State 29
		DEFAULT => -15
	},
	{#State 30
		DEFAULT => -17
	},
	{#State 31
		DEFAULT => -7
	},
	{#State 32
		ACTIONS => {
			")" => 34
		}
	},
	{#State 33
		DEFAULT => -21
	},
	{#State 34
		DEFAULT => -22
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
#line 4 "SSWAP_GRAMMAR.yp"
{
    # Return is : 
     # Async : 1
     # Multiplex : 2
     # Sync : 3
     # Multiplex Sync : 4
     # MultiSync : 5
     # Error : -1

    return $_[1];
}
	],
	[#Rule 2
		 'input', 2,
sub
#line 16 "SSWAP_GRAMMAR.yp"
{
      if($_[1] eq '!') 
        {
	    return -1;
	}
      elsif($_[1] eq '*' && ($_[2] == 3 || $_[2] == 4))
	{
	     return $_[2];	 		
	}	
    else
	{	
	    return 5;	
	}

}
	],
	[#Rule 3
		 'input', 1,
sub
#line 32 "SSWAP_GRAMMAR.yp"
{
    return -1;
}
	],
	[#Rule 4
		 'SS', 1,
sub
#line 39 "SSWAP_GRAMMAR.yp"
{
    $_[1];
}
	],
	[#Rule 5
		 'SS', 2,
sub
#line 43 "SSWAP_GRAMMAR.yp"
{ 
    if($_[2] eq '*' && ($_[1] == 3 || $_[1] == 4))
	{
	     $_[1];	 		
	}	
    else
	{	
	    5;	
	}

}
	],
	[#Rule 6
		 'SS', 2,
sub
#line 55 "SSWAP_GRAMMAR.yp"
{	
    if($_[1] == $_[2])
	{
	    $_[1];
	}
    elsif(($_[1] == 1 && $_[2] == 2) || ($_[1] == 2 && $_[2] == 1))
	{
	    2;
	}
    elsif(($_[1] == 3 && $_[2] == 4) || ($_[1] == 4 && $_[2] == 3))
	{
	    4;
	}	
    else
	{
	    5;
	}	
}
	],
	[#Rule 7
		 'SS', 3,
sub
#line 74 "SSWAP_GRAMMAR.yp"
{
    5;	
}
	],
	[#Rule 8
		 'SS_extend', 1,
sub
#line 82 "SSWAP_GRAMMAR.yp"
{
    '*';
}
	],
	[#Rule 9
		 'SS_extend', 2,
sub
#line 86 "SSWAP_GRAMMAR.yp"
{
    5;
}
	],
	[#Rule 10
		 'SS_extend', 1,
sub
#line 90 "SSWAP_GRAMMAR.yp"
{
    5;	
}
	],
	[#Rule 11
		 'SS_extend', 2,
sub
#line 94 "SSWAP_GRAMMAR.yp"
{
    5;
}
	],
	[#Rule 12
		 'SS_unitary', 1,
sub
#line 101 "SSWAP_GRAMMAR.yp"
{
    $_[1];	
}
	],
	[#Rule 13
		 'SS_unitary', 1,
sub
#line 105 "SSWAP_GRAMMAR.yp"
{
    $_[1];
}
	],
	[#Rule 14
		 'SS_async', 1,
sub
#line 112 "SSWAP_GRAMMAR.yp"
{
    1;	
}
	],
	[#Rule 15
		 'SS_async', 3,
sub
#line 117 "SSWAP_GRAMMAR.yp"
{
    2;
}
	],
	[#Rule 16
		 'SS_vanilla', 1,
sub
#line 124 "SSWAP_GRAMMAR.yp"
{
}
	],
	[#Rule 17
		 'SS_vanilla', 2,
sub
#line 127 "SSWAP_GRAMMAR.yp"
{
}
	],
	[#Rule 18
		 'SS_multisync_in_sync', 1,
sub
#line 133 "SSWAP_GRAMMAR.yp"
{
   $_[1];	  
}
	],
	[#Rule 19
		 'SS_multisync_in_sync', 2,
sub
#line 137 "SSWAP_GRAMMAR.yp"
{
   5;	  
}
	],
	[#Rule 20
		 'SS_multisync_in_sync', 2,
sub
#line 141 "SSWAP_GRAMMAR.yp"
{
   5;
}
	],
	[#Rule 21
		 'SS_multisync_in_sync', 3,
sub
#line 145 "SSWAP_GRAMMAR.yp"
{
   5;
}
	],
	[#Rule 22
		 'SS_sync', 5,
sub
#line 153 "SSWAP_GRAMMAR.yp"
{
    if($_[2] == 2 || $_[4] == 2)
    {
	4;
    } 
    elsif($_[2] == 5 || $_[4] == 5)
    {
	5;
    } 
    else
    {
	3;
    }     
}
	],
	[#Rule 23
		 'value', 1,
sub
#line 171 "SSWAP_GRAMMAR.yp"
{
}
	],
	[#Rule 24
		 'value', 2,
sub
#line 174 "SSWAP_GRAMMAR.yp"
{
}
	],
	[#Rule 25
		 'value', 2,
sub
#line 177 "SSWAP_GRAMMAR.yp"
{
}
	]
],
                                  @_);
    bless($self,$class);
}

#line 180 "SSWAP_GRAMMAR.yp"


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
    my $p = new SSWAP_GRAMMAR();        
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
		printf STDERR ('Error: a "%s" was found in <"%s"> where "%s" was expected'."\n", $_[0]->YYCurtok, $In, $_[0]->YYExpect);
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
	s!^([\[\](),*\!xX])!! and return ($1, $1);
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
