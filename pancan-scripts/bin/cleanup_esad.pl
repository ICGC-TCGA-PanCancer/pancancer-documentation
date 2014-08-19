#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use JSON 2;
use IO::Handle;
my $count = 0;

my @lines;

#opens the file containing upload info 
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/results/esadukfiles.txt") or die("Can't open esadukfiles.txt: $!");
while (my $line = <FH>) {
  chomp $line;
  #my @fields = split "\t" , $line;
  my $find = "/";
  my $replace = "-";
  $find = quotemeta $find;

  $line =~ s/$find/$replace/g;
  push (@lines,$line);

}
close(FH);

open(my $file, '>',"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/results/esadukfiles.txt") or die("Can't open esadukfiles.txt: $!");
for (my $i = 0;$i < scalar @lines;$i++){
  print $file "$lines[$i]\n";
}
close $file;
