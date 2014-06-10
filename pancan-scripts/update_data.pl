#!/usr/bin/perl -T

use strict;
use warnings;

use CGI;
use JSON 2;
use IO::Handle;

#print CGI->header("text/javascript");

my ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual);

my ($all_emp_count, $all_fill_count) = (0)x2;

#For all the arrays 
#[0]=Heidelberg,[1]=Cambridge,[2]=Toronto,[3]=Barcelona,[4]=Singapore,[5]=Tokyo,[6]Hinxton

my @fill_counts = (0,0,0,0,0,0,0);
my @emp_counts = (0,0,0,0,0,0,0);
my @totals = (0,0,0,0,0,0,0);
my @col = ("","","","","","","");
my @rad = (0,0,0,0,0,0,0);
my @size = (0,0,0,0,0,0,0);
my @ave = (0,0,0,0,0,0,0);
my @uploads = (0,0,0,0,0,0,0);

#reading from text file containing all spreadsheets
#individual project text files created from get_spreadsheets.pl
open (FILE, "~/ubuntu/gitroot/pancancer-info/pancan-scripts/results/all_sheets.txt");
while (<FILE>) {
        chomp;
        ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup,$dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
        if ($Actual eq "" && $Study ne 'Study'){
                $all_emp_count += 1;
                if (substr($dcc_project_code,5,6) eq 'SG'){
                        $emp_counts[4] += 1;
                        $totals[4] += 1;}
                elsif ($dcc_project_code eq 'ESAD-UK'){
                        $emp_counts[1] += 1;
                        $totals[1] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'ES'){
                        $emp_counts[3] += 1;
                        $totals[3] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'DE'){
                        $emp_counts[0] += 1;
                        $totals[0] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'JP'){
                        $emp_counts[5] += 1;
                        $totals[5] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'CA'){
                        $emp_counts[2] += 1;
                        $totals[2] +=1 ;}
                elsif($dcc_project_code eq 'BRCA-UK'){
                        $emp_counts[6] += 1;
                        $totals[6] += 1;}
                };

        if ($Actual ne "" && $Study ne 'Study'){
                $all_fill_count += 1;
                if (substr($dcc_project_code,5,6) eq 'SG'){
                        $fill_counts[4] += 1;
                        $totals[4] += 1;}
                elsif ($dcc_project_code eq 'ESAD-UK'){
                        $fill_counts[1] += 1;
                        $totals[1] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'ES'){
                        $fill_counts[3] += 1;
                        $totals[3] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'DE'){
                        $fill_counts[0] += 1;
                        $totals[0] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'JP'){
                        $fill_counts[5] += 1;
                        $totals[5] += 1;}
                elsif (substr($dcc_project_code,5,6) eq 'CA'){
                        $fill_counts[2] += 1;
                        $totals[2] +=1 ;}
                elsif($dcc_project_code eq 'BRCA-UK'){
                        $fill_counts[6] += 1;
                        $totals[6] += 1;}
                };
}
close (FILE);

#getting GNOS data straight from pancancer.info
use WWW::Mechanize;
# Create a new mechanize object
my $mech = WWW::Mechanize->new();
my @id = [];
my $counter = 0;
my $uploaded = 0;

#Finding what is uplaoded from the GNOS repo files
foreach my $a ("defiles.txt","esadukfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","brcaukfiles.txt"){
        foreach my $i ("gtrepo-bsc", "gtrepo-dkfz", "gtrepo-osdc", "gtrepo-etri", "gtrepo-ebi", "gtrepo-riken") {
                @id = [];
                my $url = "http://pancancer.info/${i}.log";
                # Associate the mechanize object with a URL
                $mech->get($url);
                
                # Print the content of the URL
                my $results = index ($url, "gtrepo");
                my $fname = substr($url,$results);
                my @content = [];
                
                #makes log files for every repo
                open(my $fh, '>', "${i}.log");
                print $fh $mech->content;
                close $fh;
                my @line;

                # Load URL::Escape to escape URI's with uri_escape method.
                use URI::Escape;
                my @links = $mech->links;
                foreach my $link (@links) {
                    print uri_escape($link->url), "\n";
                }

                #reads the log files and finds the specimen_id
                open(FH,"${i}.log") or &dienice("Can't open guestbook.txt: $!");
                while (my $line = <FH>) {
                 my $result = index($line, "SPECIMEN/SAMPLE:");
                 if ($result == 1){
                         push(@id, substr($line,$result+17));
                }
                }
                my $total_files = 0;
                #checks if the specimen_id's are in any repo
                open (FILE, "~/ubuntu/gitroot/pancancer-info/pancan-scripts/results/${a}");
                while (<FILE>) {
                        chomp;
                        ($Study, $dcc_project_code, $Accession_Identifier, $submitter_donor_id, $submitter_specimen_id, $submitter_sample_id, $Readgroup, $dcc_specimen_type, $Normal_Tumor_Designation,$ICGC_Sample_Identifier,$Sequencing_Strategy,$Number_of_BAM,$Target,$Actual) = split("\t");
                        #if it is found, update the data
                        if (grep( /^$submitter_specimen_id$/, @id) && $submitter_specimen_id ne ''){
                         $uploaded += 1;}
                         if ($Study ne "Study"){
                          $total_files += 1;}
                }
                close (FILE);
        }
        $uploads[$counter] = $uploaded;
        $counter += 1;
        $uploaded = 0;
}

#applying colors and radius to each bubble, also getting the average
my $h = 0;
for ($h = 0; $h < scalar @totals; $h++){
        $ave[$h] = $uploads[$h]/$totals[$h];

        if ($ave[$h] <= .15 && $ave[$h] >= 0.0){$col[$h] = "red";}
                elsif ($ave[$h] <= .80 && $ave[$h] > .15){$col[$h] = "yellow";}
                else {$col[$h] = "green";};

        if($totals[$h] <= 120 && $totals[$h] >=0){$rad[$h] = 15;}
                elsif($totals[$h] <= 300 && $totals[$h] >=120){$rad[$h] = 20;}
                else{$rad[$h] = 30;};

        $size[$h] = $rad[$h]*$ave[$h];
        if ($size[$h] >= 0.0 && $size[$h] < 3){$size[$h] = 3;};
}

#writes to bubble_data.json 
open(my $file,'>', "bubble_data.json");
print $file qq([
          {"name": "Heidelberg", "total": $totals[0], "uploaded": $uploads[0], "latitude": 49.403159, "longitude": 8.676061, "radius": $rad[0], "fillKey": "orange"},
          {"name": "Heidelberg", "total": $totals[0], "uploaded": $uploads[0], "latitude": 49.403159, "longitude": 8.676061, "radius": $size[0], "fillKey": "$col[0]"},
          
          {"name": "Cambridge", "total": $totals[1], "uploaded": $uploads[1], "latitude": 51.507919, "longitude": -0.123571 , "radius": $rad[1], "fillKey": "orange"},
          {"name": "Cambridge", "total": $totals[1], "uploaded": $uploads[1], "latitude": 51.507919, "longitude": -0.123571 , "radius": $size[1], "fillKey": "$col[1]"},
          
          {"name": "Hinxton", "total": $totals[6], "uploaded": $uploads[6], "latitude": 52.082869, "longitude": 0.18269 , "radius": $rad[6], "fillKey": "orange"},
          {"name": "Hinxton", "total": $totals[6], "uploaded": $uploads[6], "latitude": 52.082869, "longitude": 0.18269 , "radius": $size[6], "fillKey": "$col[6]"},
          
          {"name": "Toronto", "total": $totals[2], "uploaded": $uploads[2], "latitude": 43.7000, "longitude": -79.4000, "radius": $rad[2], "fillKey": "orange"},
          {"name": "Toronto", "total": $totals[2], "uploaded": $uploads[2], "latitude": 43.7000, "longitude": -79.4000, "radius": $size[2], "fillKey": "$col[2]"},
     
          {"name": "Barcelona", "total": $totals[3], "uploaded": $uploads[3], "latitude": 41.378691, "longitude": 2.175547, "radius": $rad[3], "fillKey": "orange"},
          {"name": "Barcelona", "total": $totals[3], "uploaded": $uploads[3], "latitude": 41.378691, "longitude": 2.175547, "radius": $size[3], "fillKey": "$col[3]"},

          {"name": "Singapore", "total": $totals[4], "uploaded": $uploads[4], "latitude": 1.2896700, "longitude": 103.8500700, "radius": $rad[4], "fillKey": "orange"},
          {"name": "Singapore", "total": $totals[4], "uploaded": $uploads[4], "latitude": 1.2896700, "longitude": 103.8500700, "radius": $size[4], "fillKey": "$col[4]"},

          {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $rad[5], "fillKey": "orange"},
          {"name": "Tokyo", "total": $totals[5], "uploaded": $uploads[5], "latitude": 35.684219, "longitude": 139.755020, "radius": $size[5], "fillKey": "$col[5]"}

]);
close $file;

use POSIX qw(strftime);

my $date = strftime "%m/%d/%Y - %R", localtime;

#updates the average data for the chart
#appending to file with all average data
open(my $f, '>>', "ave_data_archive.csv") or die "Could not open file '/home/jlugo/Desktop/d3js_projects/crunchbase-quarters.csv' $!";
print $f "$date,";
my $k = 0;
my $count1 = 0;
for ($k = 0; $k < scalar @totals; $k++){
        if ($count1 >= 0 && $count1 < scalar @totals -1){printf $f "%.2f,", $ave[$k];}
        else {printf $f "%.2f\n", $ave[$k];}
        $count1 += 1;
}
close $f;

#updates the total uploads for the chart
#appending to file with all upload data
open(my $f1, '>>', "up_data_archive.csv") or die "Could not open file '/home/jlugo/Desktop/d3js_projects/crunchbase-quarters.csv' $!";
print $f1 "$date,";
my $r = 0;
my $count2 = 0;
for ($r = 0; $r < scalar @totals; $r++){
        if ($count2 >= 0 && $count2 < scalar @totals -1){printf $f1 "%.2f,", $uploads[$r];}
        else {printf $f1 "%.2f\n", $uploads[$r];}
        $count2 += 1;
}
close $f1;

my @ary = [];
my $count_ave = 0;
my @ary1 = [];
my $count_up = 0;

#finding number of rows in the archived data
open(FH,"ave_data_archive.csv") or &dienice("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
    $count_ave += 1;
    push (@ary,"$line");
}
close(FH);

#only displaying 20 lines on the chart
open(my $file_ave, '>',"ave_data.csv") or &dienice("Can't open guestbook.txt: $!");
if ($count_ave > 20){
        my $h = 0;
        print $file_ave $ary[1];
        for ($h = $count_ave -21; $h < $count_ave +1;$h++){
                print $file_ave $ary[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_ave +1;$p++){
                print $file_ave $ary[$p];
        }
};
close $file_ave;

#only displaying 20 lines for daily
open(my $file_ave2, '>',"ave_daily.csv") or &dienice("Can't open guestbook.txt: $!");
if ($count_ave > 20){
        my $h = 0;
        print $file_ave2 $ary[1];
        for ($h = $count_ave -21; $h < $count_ave +1;$h++){
                my $result = index($ary[$h],'12:0');
                if ($result != -1){
                print $file_ave2 $ary[$h];
        }
}
}
else {
        print $file_ave2 $ary[1];
        my $p = 0;
        for ($p = 0; $p < $count_ave +1;$p++){
                my $result = index($ary[$p],'12:0');
                if ($result != -1){
                print $file_ave2 $ary[$p];
        }}
};
close $file_ave2;

#finding number of rows in the archived data
open(FH,"up_data_archive.csv") or &dienice("Can't open guestbook.txt: $!");
while (my $line = <FH>) {
    $count_up += 1;
    push (@ary1,"$line");
}
close(FH);

#only displaying 20 lines on the chart for hourly 
open(my $file_up, '>',"up_data.csv") or &dienice("Can't open guestbook.txt: $!");
if ($count_up > 20){
        my $h = 0;
        print $file_up $ary1[1];
        for ($h = $count_ave - 21; $h < $count_up +1;$h++){
                print $file_up $ary1[$h];
        }
}
else {
        my $p = 0;
        for ($p = 1; $p < $count_up +1;$p++){
                print $file_up $ary1[$p];
        }
};
close $file_up;

#only displaying 20 lines for daily
open(my $file_up2, '>',"up_daily.csv") or &dienice("Can't open guestbook.txt: $!");
if ($count_up > 20){
        my $h = 0;
        print $file_up2 $ary1[1];
        for ($h = $count_up -21; $h < $count_up +1;$h++){
                my $result = index($ary1[$h],'12:0');
                if ($result != -1){
                print $file_up2 $ary1[$h];
        }
}
}
else {
        print $file_up2 $ary1[1];
        my $p = 0;
        for ($p = 0; $p < $count_up +1;$p++){
                my $result = index($ary1[$p],'12:0');
                if ($result != -1){
                print $file_up2 $ary1[$p];
        }}
};
close $file_up2;

exit;
