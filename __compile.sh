#!/bin/sh

sudo pp -o jugglingTB.bin jugglingTB.pl WebServer.pl -M File::Path -M Devel::Symdump  -M Set::Scalar -M Parse::Yapp -M Perl4::CoreLibs -M Term::ReadKey -M File::Grep -M File::Copy::Recursive -M Chart::Gnuplot -M HTTP::Server::Simple 
