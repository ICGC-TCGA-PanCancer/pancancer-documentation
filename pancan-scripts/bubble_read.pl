#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use JSON 2;
use IO::Handle;
my $count = 0;

my @origins;
my @origins1;
my @dest;
my @dest1;

#opens the file containing upload info 
open(FH,"~/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/out.csv") or &dienice("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
  chomp $line;
  my $count = 0;
  my @fields = split "," , $line;
  my $result = index($line,'.txt');
  if ($result != -1){
          push (@origins, $fields[0]); 
          push (@dest, $fields[1]);
    }
}
close(FH);

#pushing origins for the arcs to @origins1
foreach my $item (@origins){
                if ($item eq 'defiles.txt'){push (@origins1, 'Heidelberg');}
                elsif ($item eq 'brcaukfiles.txt'){push (@origins1, 'Hinxton');}
                elsif ($item eq 'esadukfiles.txt'){push (@origins1, 'Cambridge');}
                elsif ($item eq 'cafiles.txt'){push (@origins1, 'Toronto');}
                elsif ($item eq 'esfiles.txt'){push (@origins1, 'Barcelona');}
                elsif ($item eq 'sgfiles.txt'){push (@origins1, 'Singapore');}
                elsif ($item eq 'jpfiles.txt'){push (@origins1, 'Tokyo');}
                else {push (@origins1, '');};
        }

#pushing destinations for the arcs to @dest1
foreach my $elem (@dest){
                if ($elem eq 'gtrepo-dkfz'){push (@dest1, 'Heidelberg');}
                elsif ($elem eq 'gtrepo-ebi'){push (@dest1, 'Hinxton');}
                elsif ($elem eq 'gtrepo-bsc'){push (@dest1, 'Barcelona');}
                elsif ($elem eq 'gtrepo-riken'){push (@dest1, 'Tokyo');}
                elsif ($elem eq 'gtrepo-osdc'){push (@dest1, 'Chicago');}
                elsif ($elem eq 'gtrepo-etri'){push (@dest1, 'Seoul');}
                else {push (@dest1, '');};
        }

#creating bubble json files for every location 
#appends all the output to different files for each location
foreach my $thing ('Heidelberg','Cambridge','Hinxton','Toronto','Barcelona','Singapore','Tokyo'){
               open(my $file, '>', "~/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${thing}_bub.json"); 
               my $l = 0;
               my @elems;
               my $count_elem;
               
               #reset all variables
               @elems = ();
               $count_elem = 0;
               
               for ($l = 0; $l < scalar @origins1; $l++){
                       if($dest1[$l] eq ''){$dest1[$l] = $origins1[$l]}
                       if($origins1[$l] eq $thing){push(@elems, $l);}
               }

               print $file "[\n";
               
               #gathers the destination json data
               open(FH,"~/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/location.json") or &dienice("Can't open guestbook.txt: $!");
               while (my $line = <FH>) {
                              foreach my $items (@elems){
                                             my $result = index($line, $dest1[$items]);
                                             if ($result != -1){
                                                     print $file $line;
                                             }
                              }
               }
               close(FH);
               
               my $count_bub = 0;
               open(FH,"~/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data.json") or &dienice("Can't open guestbook.txt: $!");
               while (my $line = <FH>) {
                              my $result = index($line, $origins1[$elems[0]]);
                              if ($result != -1){
                                             $count_bub += 1;
                                             if ($count_bub == 2 && $thing ne 'Tokyo'){print $file substr($line,0,-2);}
                                             elsif ($count_bub == 2 && $thing eq 'Tokyo'){print $file substr($line,0,-1);}
                                             else {print $file $line;}
                              }
               }
               close(FH);

               print $file "]\n";
               close $file;
}
exit;
