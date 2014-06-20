#!/usr/bin/perl 

use strict;
use warnings;

use CGI;
use JSON 2;
use IO::Handle;
my $count = 0;

my @origins;
my @project;
my @origins1;
my @origins2;
my @origins3;
my @dest;
my @dest1;
my @dest2;

#opens the file containing upload info 
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/out.csv") or &dienice("Can't open guestbook.txt: $!");
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
        if ($item eq 'defiles.txt'){push (@origins1, 'Heidelberg');push (@origins2, 'Heidelberg');push (@origins3, 'Heidelberg');}
                elsif ($item eq 'pbcadefiles.txt'){push (@origins1, 'Heidelberg');push (@origins2, 'PBCA-DE');push (@origins3, 'PBCA-DE');}
                elsif ($item eq 'malydefiles.txt'){push (@origins1, 'Heidelberg');push (@origins2, 'MALY-DE');push (@origins3, 'MALY-DE');}
                elsif ($item eq 'eopcdefiles.txt'){push (@origins1, 'Heidelberg');push (@origins2, 'EOPC-DE');push (@origins3, 'EOPC-DE');}
                elsif ($item eq 'brcaukfiles.txt'){push (@origins1, 'Hinxton');push (@origins2, 'BRCA-UK');push (@origins3, 'BRCA-UK');}
                elsif ($item eq 'cmdiukfiles.txt'){push (@origins1, 'Hinxton');push (@origins2, 'CMDI-UK');push (@origins3, 'CMDI-UK');}
                elsif ($item eq 'bocaukfiles.txt'){push (@origins1, 'Hinxton');push (@origins2, 'BOCA-UK');push (@origins3, 'BOCA-UK');}
                elsif ($item eq 'pradukfiles.txt'){push (@origins1, 'Hinxton');push (@origins2, 'PRAD-UK');push (@origins3, 'PRAD-UK');}
                elsif ($item eq 'esadukfiles.txt'){push (@origins1, 'Cambridge');push (@origins2, 'ESAD-UK');push (@origins3, 'ESAD-UK');}
                elsif ($item eq 'brcaeufiles.txt'){push (@origins1, 'Cambridge');push (@origins2, 'BRCA-EU');push (@origins3, 'BRCA-EU');}
                elsif ($item eq 'cafiles.txt'){push (@origins1, 'Toronto');push (@origins2, 'PACA-CA');push (@origins3, 'Toronto');}
                elsif ($item eq 'esfiles.txt'){push (@origins1, 'Barcelona');push (@origins2, 'CLLE-ES');push (@origins3, 'Barcelona');}
                elsif ($item eq 'sgfiles.txt'){push (@origins1, 'Singapore');push (@origins2, 'BTCA-SG');push (@origins3, 'Singapore');}
                elsif ($item eq 'jpfiles.txt'){push (@origins1, 'Tokyo');push (@origins2, 'LIRI-JP');push (@origins3, 'Tokyo');}
                elsif ($item eq 'krfiles.txt'){push (@origins1, 'Seoul');push (@origins2, 'LAML-KR');push (@origins3, 'Seoul');}
                else {push (@origins3, '');};
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

#pushing destinations for the arcs to @dest2
foreach my $thing (@dest1){
                if ($thing eq 'Heidelberg'){push (@dest2, 'DKFZ');}
                elsif ($thing eq 'Hinxton'){push (@dest2, 'EBI');}
                elsif ($thing eq 'Barcelona'){push (@dest2, 'BSC');}
                elsif ($thing eq 'Tokyo'){push (@dest2, 'RIKEN');}
                elsif ($thing eq 'Chicago'){push (@dest2, 'OSDC');}
                elsif ($thing eq 'Seoul'){push (@dest2, 'ETRI');}
                else {push (@dest2, 'NONE');};
        }

#creating the file that conatins the origins and destinations in a json file.
open(my $file1, '>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/table2.json");
my $p = 0;
print $file1 "[";
for ($p=1;$p < scalar @dest2;$p++){
        print $file1 qq({"origin": "$origins1[$p]",);
        print $file1 qq("project": "$origins2[$p]",);
        if ($p == scalar @dest2 -1){print $file1 qq("dest": "$dest2[$p]"}\n);}
        else {print $file1 qq("dest": "$dest2[$p]"},\n);}
}
print $file1 "]";
close $file1;


#creating bubble json files for every location 
#appends all the output to different files for each location
foreach my $thing ('Heidelberg','PBCA-DE','MALY-DE','EOPC-DE','Hinxton','BRCA-UK','CMDI-UK','BOCA-UK','PRAD-UK','Cambridge','ESAD-UK','BRCA-EU','Toronto','Barcelona','Singapore','Tokyo','Seoul'){
               open(my $file, '>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${thing}_bub.json");
               my $l = 0;
               my @elems;
               my $count_elem;
               
               #reset all variables
               @elems = ();
               $count_elem = 0;
               
               for ($l = 0; $l < scalar @origins3; $l++){
                       if($dest1[$l] eq ''){$dest1[$l] = $origins3[$l]}
                       if($origins3[$l] eq $thing){push(@elems, $l);}
               }

               print $file "[\n";
               
               #gathers the destination json data
               open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/location.json") or &dienice("Can't open guestbook.txt: $!");
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
               open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data.json") or &dienice("Can't open guestbook.txt: $!");
               while (my $line = <FH>) {
                              my $result = index($line, $origins3[$elems[0]]);
                              if ($result != -1){
                                             $count_bub += 1;
                                             if ($count_bub == 2 && $thing ne 'Tokyo'){print $file substr($line,0,-2);}
                                             elsif ($count_bub == 2 && $thing eq 'Tokyo'){print $file substr($line,0,-1);}
                                             else {print $file $line;}
                              }
               }
               close(FH);

               my $count_bub1 = 0;
               open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data1.json") or &dienice("Can't open guestbook.txt: $!");
               while (my $linea = <FH>){
                              my $res = index($linea, $origins3[$elems[0]]);
                              if ($res != -1){
                                              $count_bub1 += 1;
                                             if ($count_bub1 == 2 && $thing ne 'BRCA-EU'){print $file substr($linea,0,-2);}
                                             elsif ($count_bub1 == 2 && $thing eq 'BRCA-EU'){print $file substr($linea,0,-2);}
                                             else {print $file $linea;}
                              }
               }

               print $file "]\n";
               close $file;

}

my $count_front = 0;
my @front = [];

#making json for zoomed map, for cambridge and hinxton
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data.json") or &dienice("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
my $result_cam = index($line, "Cambridge");
my $result_hinx = index($line, "Hinxton");
if ($result_cam != -1 || $result_hinx != -1){
        $count_front += 1;
        if($count_front == 4){
                push(@front, substr($line,0,-2));}
        else {
        push (@front,$line);}
}
}
close(FH);

  open(my $fh, '>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/front_uk.json"); 
  print $fh "[\n";
  my $h = 0;
  for($h=1; $h < scalar @front; $h++){
          print $fh $front[$h];
  }
  print $fh "]";
  close $fh;

exit;
