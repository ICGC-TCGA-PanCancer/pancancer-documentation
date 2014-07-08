#!/usr/bin/perl

use strict;
use warnings;

use JSON 2;
use IO::Handle;

my @origins;
my @origins1;
my @origins2;
my @origins3;
my @dest;
my @dest1;
my @uploads;
my @totals;

my %data = ( 'Heidelberg' => { 'latitude' => 49.403159,
                            'longitude' => 8.676061,},
             'Cambridge' => { 'latitude' => 52.202544,
                            'longitude' => 0.131237,},
             'Hinxton' => { 'latitude' => 52.082869,
                            'longitude' => 0.18269,},
             'Toronto' => { 'latitude' => 43.7000,
                            'longitude' => -79.4000,},
             'Barcelona' => { 'latitude' => 41.378691,
                            'longitude' => 2.175547,},
             'Singapore' => { 'latitude' => 1.2896700,
                            'longitude' => 103.8500700,},
             'Tokyo' => { 'latitude' => 35.684219,
                            'longitude' => 139.755020,},
             'Chicago' => { 'latitude' => 41.8500300,
                            'longitude' => -87.6500500,},
             'Seoul' => { 'latitude' => 37.532600,
                            'longitude' => 127.024612},
             'Kalyani' => { 'latitude' => 22.98000,
                            'longitude' => 88.44000,},);
			    
#opens the file containing upload info
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/out.csv") or die ("Can't open out.csv");
while (my $line = <FH>) {
  chomp $line;
  my $count = 0;
  my @fields = split "," , $line;
  my $result = index($line,'.txt');
  if ($result != -1){
	  push (@origins, $fields[0]);
	  push (@dest, $fields[1]);
	  push (@uploads, substr($fields[2],10));	  
  }
}

#reading from the bubble json data to find the totals for each location and puts it in @totals
open(FH,"/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/bubble_data.json") or die ("Can't open bubble_data.json");
while (my $line = <FH>) {
	chomp $line;
	my @fields2 = split "," , $line;
	my $result = index($line, "orange");
	if ($result != -1){
		push (@totals, substr($fields2[1],10));
	}
}
close(FH);

#check if any upload feild is empty.
my $c = 0;
for ($c = 0; $c < scalar @uploads; $c++){
	if ($uploads[$c] eq ''){
		$uploads[$c] = 0;}
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
                elsif ($item eq 'pacacafiles.txt'){push (@origins1, 'Toronto');push (@origins2, 'PACA-CA');push (@origins3, 'PACA-CA');}
                elsif ($item eq 'lirijpfiles.txt'){push (@origins1, 'Tokyo');push (@origins2, 'LIRI-JP');push (@origins3, 'LIRI-JP');}
                elsif ($item eq 'orcainfiles.txt'){push (@origins1, 'Kalyani');push (@origins2, 'ORCA-IN');push (@origins3, 'ORCA-IN');}
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

#creating the json files for the arc data for every location
foreach my $thing ('Heidelberg','PBCA-DE','MALY-DE','EOPC-DE','BRCA-UK','CMDI-UK','BOCA-UK','PRAD-UK','ESAD-UK','BRCA-EU','PACA-CA','Barcelona','Singapore','LIRI-JP','Seoul','ORCA-IN'){
               open(my $file, '>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/${thing}.json") or die ("Can't open ${thing}.json");
	       my @elems;
	       my $l = 0;
	       my $count_elem = 0;

		       @elems = ();
		       $count_elem = 0;
		       
	       for ($l = 0; $l < scalar @origins1; $l++){
                       if($dest1[$l] eq ''){$dest1[$l] = $origins1[$l]}
                       if($origins3[$l] eq $thing){
                       push(@elems, $l);
                       }
               }

	       print $file "[";
	       
	       foreach my $item (@elems){
		       $count_elem += 1;
		       if ($count_elem == scalar @elems){
		       print $file qq({"origin": {"latitude": $data{$origins1[$item]}{'latitude'}, "longitude": $data{$origins1[$item]}{'longitude'}}, "destination": {"latitude": $data{$dest1[$item]}{'latitude'}, "longitude": $data{$dest1[$item]}{'longitude'}} });}
		       else {print $file qq({"origin": {"latitude": $data{$origins1[$item]}{'latitude'}, "longitude": $data{$origins1[$item]}{'longitude'}}, "destination": {"latitude": $data{$dest1[$item]}{'latitude'}, "longitude": $data{$dest1[$item]}{'longitude'}} },\n);}
	       }
	       
	       print $file "]\n";

	       close $file;
}
exit;
