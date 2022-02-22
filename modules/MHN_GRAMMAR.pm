####################################################################
#
#    This file was generated using Parse::Yapp version 1.21.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package MHN_GRAMMAR;
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
			"(" => 4,
			'lexerror' => 2
		},
		GOTOS => {
			'MHN' => 1,
			'input' => 3
		}
	},
	{#State 1
		DEFAULT => -1
	},
	{#State 2
		DEFAULT => -2
	},
	{#State 3
		ACTIONS => {
			'' => 5
		}
	},
	{#State 4
		ACTIONS => {
			'digit' => 7
		},
		GOTOS => {
			'hand_throws' => 6,
			'throw' => 8
		}
	},
	{#State 5
		DEFAULT => 0
	},
	{#State 6
		ACTIONS => {
			")" => 9
		}
	},
	{#State 7
		ACTIONS => {
			'digit' => 7,
			":" => 10
		},
		DEFAULT => -7,
		GOTOS => {
			'throw' => 11
		}
	},
	{#State 8
		ACTIONS => {
			"," => 12
		},
		DEFAULT => -5
	},
	{#State 9
		ACTIONS => {
			"(" => 4
		},
		DEFAULT => -3,
		GOTOS => {
			'MHN' => 13
		}
	},
	{#State 10
		ACTIONS => {
			'digit' => 14
		}
	},
	{#State 11
		DEFAULT => -9
	},
	{#State 12
		ACTIONS => {
			'digit' => 7
		},
		GOTOS => {
			'throw' => 8,
			'hand_throws' => 15
		}
	},
	{#State 13
		DEFAULT => -4
	},
	{#State 14
		ACTIONS => {
			'digit' => 7
		},
		DEFAULT => -8,
		GOTOS => {
			'throw' => 16
		}
	},
	{#State 15
		DEFAULT => -6
	},
	{#State 16
		DEFAULT => -10
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
#line 4 "MHN_GRAMMAR.yp"
{
    # Return is : 
    # Error : -1    
    return 1;
}
	],
	[#Rule 2
		 'input', 1,
sub
#line 10 "MHN_GRAMMAR.yp"
{
    return -1;
}
	],
	[#Rule 3
		 'MHN', 3,
sub
#line 17 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 4
		 'MHN', 4,
sub
#line 20 "MHN_GRAMMAR.yp"
{ 
}
	],
	[#Rule 5
		 'hand_throws', 1,
sub
#line 26 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 6
		 'hand_throws', 3,
sub
#line 29 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 7
		 'throw', 1,
sub
#line 36 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 8
		 'throw', 3,
sub
#line 39 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 9
		 'throw', 2,
sub
#line 42 "MHN_GRAMMAR.yp"
{
}
	],
	[#Rule 10
		 'throw', 4,
sub
#line 45 "MHN_GRAMMAR.yp"
{
}
	]
],
                                  @_);
    bless($self,$class);
}

#line 51 "MHN_GRAMMAR.yp"


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
    my $p = new MHN_GRAMMAR();        
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
	s!^([\[\]():,])!! and return ($1, $1);
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
