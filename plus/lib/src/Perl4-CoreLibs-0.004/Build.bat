@rem = '--*-Perl-*--
@set "ErrorLevel="
@if "%OS%" == "Windows_NT" @goto WinNT
@perl -x -S "%0" --build_bat %1 %2 %3 %4 %5 %6 %7 %8 %9
@set ErrorLevel=%ErrorLevel%
@goto endofperl
:WinNT
@perl -x -S %0 --build_bat %*
@set ErrorLevel=%ErrorLevel%
@if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" @goto endofperl
@if %ErrorLevel% == 9009 @echo You do not have Perl in your PATH.
@goto endofperl
@rem ';
#!perl
#line 16

use strict;
use Cwd;
use File::Basename;
use File::Spec;

sub magic_number_matches {
  return 0 unless -e '_build\\magicnum';
  my $FH;
  open $FH, '<','_build\\magicnum' or return 0;
  my $filenum = <$FH>;
  close $FH;
  return $filenum == 141695;
}

my $progname;
my $orig_dir;
BEGIN {
  $^W = 1;  # Use warnings
  $progname = basename($0);
  $orig_dir = Cwd::cwd();
  my $base_dir = 'C:\\Users\\rpff7206\\Desktop\\JUGGLI~1\\JUGGLI~1.4\\plus\\lib\\src\\PERL4-~1.004';
  if (!magic_number_matches()) {
    unless (chdir($base_dir)) {
      die ("Couldn't chdir($base_dir), aborting\n");
    }
    unless (magic_number_matches()) {
      die ("Configuration seems to be out of date, please re-run 'perl Build.PL' again.\n");
    }
  }
  unshift @INC,
    (

    );

}

close(*DATA) unless eof(*DATA); # ensure no open handles to this script

use Module::Build;
Module::Build->VERSION(q{0.26});

# Some platforms have problems setting $^X in shebang contexts, fix it up here
$^X = Module::Build->find_perl_interpreter;

if (-e 'Build.PL' and not Module::Build->up_to_date('Build.PL', $progname)) {
   warn "Warning: Build.PL has been altered.  You may need to run 'perl Build.PL' again.\n";
}

# This should have just enough arguments to be able to bootstrap the rest.
my $build = Module::Build->resume (
  properties => {
    config_dir => '_build',
    orig_dir => $orig_dir,
  },
);

$build->dispatch;
__END__
:endofperl
@set "ErrorLevel=" & @goto _undefined_label_ 2>NUL || @"%COMSPEC%" /d/c @exit %ErrorLevel%
