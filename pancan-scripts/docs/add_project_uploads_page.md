# Adding a project to http://pancancer.info/

## Table of Contents
* [Collecting data](#collecting-data)
* [Changing Scripts](#changing-scripts)
	* [Update_data.pl](#update_datapl)
	* [Arc_read.pl](#arc_readpl)
	* [Bubble_read.pl](#bubble_readpl)
	* [Uploads.html](#uploadshtml)
	* [Run_get.sh](#run_getsh)
* [Changing Files](#changing-files)

## Collecting Data
Normally to get the data, you would download the spreadsheets using get_spreadsheets.pl . You update the hash that is in the script with they key from the spreadsheet you want to download and the title of the spreadsheet. This is a special case because the people from Beijing could not access google drive so we have to download the file manually. The download can be found here:

	GACA-CN: https://wiki.oicr.on.ca/download/attachments/57771379/submission.sheets.xls?version=1&modificationDate=1405331109000&api=v2
			
Once this is downloaded you want to make it into a tsv and call it something like gacacnfiles.txt

## Changing Scripts

### Update_data.pl
This script creates the json files you need for the maps/tables and the csv files needed for the charts. There are many arrays that are being used in the script and you want to make sure that the project you add is before LINC-JP and PRAC-CA. For example if LINC-JP was 25th in the arrays and PRAD-CA was 26th in the arrays, you want to put GACA-CN as 24th in the arrays, so we will do that now:

    elsif($projectcode eq 'GACA-CN'){
          $total_icgc += $numberofspecimens;
          $totals_match += $pledgednumberofwgstnpairs;
          $uplo[24] = $numberofspecimensuploaded;
          $matches_up[24] = $pairuploaded;
          $totals[24] += $numberofspecimens;}
            
This is because LINC-JP and PRAD-CA have not uploaded anything yet and they have not provided any spreadsheets at the moment. After adding this you want to add the right file to the foreach loop that is reading everything in. Just make sure that it is at the end because order matters.

    foreach my $a ("defiles.txt","camfiles.txt","cafiles.txt","esfiles.txt","sgfiles.txt","jpfiles.txt","hinfiles.txt","krfiles.txt","pbcadefiles.txt","malydefiles.txt","eopcdefiles.txt","brcaeufiles.txt","pradukfiles.txt","esadukfiles.txt","brcaukfiles.txt","cmdiukfiles.txt","bocaukfiles.txt","lirijpfiles.txt","pacacafiles.txt","orcainfiles.txt",,"aufiles.txt","pacaaufiles.txt","paenaufiles.txt","ovaufiles.txt","gacacnfiles.txt")
      
Now you want to fix the totals for the icgc totlas count:

    $total_icgc = $totals[0] + $totals[1] + $totals[2] + $totals[3] + $totals[4] + $totals[5] + $totals[6] + $totals[7] + $totals[20] + $totals[19] + $totals[24] + $missing; # ADDED $totals[24]
      
After that you want to add the project to the json file that is being created:

    {"name": "Beijing", "total": $totals[24], "uploaded": $uploads[24], "latitude": 39.9139, "longitude": 116.3917, "radius": $rad[24], "fillKey": "orange","match": $match_pair[24], "project": "GACA-CN"}, 
    {"name": "Beijing", "total": $totals[24], "uploaded": $uploads[24], "latitude": 39.9139, "longitude": 116.3917, "radius": $size[24], "fillKey": "$col[24]", "project": "GACA-CN"},
          
Now you want to go to the part where the upload and average data is created and add the project that you are interested in. One thing to note here is that you need to add one to the amount that is being subtracted from scalar @totals for every project that you are adding. In this case we are only adding one project so we will change 18 to 19 and 19 to 20 right under it. After doing that you want to add the uploads/averages by putting printf $f “%.3f,” $ave[24] OR $uploads[24]; This will ensure that the txt file that is being read to make the charts will have all the right information. You also want to make sure to put it right before the 100 because that is for the TCGA data.

    open(my $f, '>>', "/home/ubuntu/gitroot/pancancer-info/pancan-scripts/map-data/ave_data_archive.csv") or die ("Could not open ave_data_archive.csv"); 
    print $f "$date,"; 
    my $k = 0; 
    my $count1 = 0; 
    for ($k = 0; $k < scalar @totals - 19; $k++){ # CHANGED 18 TO 19
      if ($count1 >= 0 && $count1 < scalar @totals -20){printf $f "%.3f,", $ave[$k];} # CHANGED 19 TO 20 
      else {printf $f "%.3f,", $ave[$k];} 
      $count1 += 1; 
    } 
    printf $f "%.3f,", $ave[19]; 
    printf $f "%.3f,", $ave[20]; 
    printf $f "%.3f,", $ave[24]; # ADDED THIS LINE
    print $f "100.000\n"; 
    close $f;
    # DO THE SAME FOR UP_DATA_ARCHIVE.CSV

This project happens to be uploading to RIKEN so we will go and add it to the csv that reads uploads and averages for the charts. We will add:

	elsif ($thing eq 'RIKEN'){ 
      #print $file "quarter,BTCA-SG,LIRI-JP,ORCA-IN,GACA-CN\n"; 
      #print $filea "quarter,BTCA-SG,LIRI-JP,ORCA-IN,GACA-CN\n"; 
      printf $file "$date,%.3f,%.3f,%.3f,%.3f\n", $uploads[4],$uploads[5],$uploads[19],$uploads[24]; # ADDED $uploads[24]
      printf $filea "$date,%.3f,%.3f,%.3f,%.3f\n", $ave[4],$ave[5],$ave[19],$ave[24];} # ADDED $ave[24]
          
### Arc_read.pl
This script does not need as many things added to it. We will update the hash with the Beijing information by adding:

	'Beijing' => { 'latitude' => 39.9139, 
                 'longitude' => 116.3917,},
                      
We will also add a condition as well:

	elsif ($item eq 'gacacnfiles.txt'){push (@origins1, 'Beijing');push (@origins2, 'GACA-CN');push (@origins3, 'GACA-CN');}
			
Finally we will add the project to the foreach loop:

	foreach my $thing ('Heidelberg','PBCA-DE','MALY-DE','EOPC-DE','BRCA-UK','CMDI-UK','BOCA-UK','PRAD-UK','ESAD-UK','BRCA-EU','PACA-CA','Barcelona','Singapore','LIRI-JP','Seoul','ORCA-IN','Brisbane','PACA-AU','PAEN-AU','OV-AU','GACA-CN'){

### Bubble_read.pl
The changes to this script will be very similar to the changes made in arc_read.pl. 

First we will add the condition:

	elsif ($item eq 'gacacnfiles.txt'){push (@origins1, 'Beijing');push (@origins2, 'GACA-CN');push (@origins3, 'GACA-CN');}
			
Then we will add the project to the foreach loop;

	foreach my $thing ('Heidelberg','PBCA-DE','MALY-DE','EOPC-DE','BRCA-UK','CMDI-UK','BOCA-UK','PRAD-UK','ESAD-UK','BRCA-EU','PACA-CA','Barcelona','Singapore','LIRI-JP','Seoul','ORCA-IN','Brisbane','PACA-AU','PAEN-AU','OV-AU','GACA-CN'){

### Uploads.html
For the html script there are a couple things that we have to change. We will start off by changing the table on the top of the page. This requires you to add a header which will look like this:

	<th scope="col"><a target="_blank" href="aufiles.txt" title="PACA-AU, PAEN-AU, OV-AU">Brisbane</a></th>
    <th scope="col"><a target="_blank" href="gacacnfiles.txt" title="GACA-CN">Beijing</a></th> <!-- ADDED this line -->
    <th scope="col"><a target="_blank" href="jpfiles.txt" title="LIRI-JP, LINC-JP">Tokyo</a></th>
      
We then have to update the columns by adding <td>0</td> to each row. We must also consider the table on the bottom of the page. This one needs another row so we will find it under the div named "center2" and add this line to the table:

	<tr>
    <td>Normal</td><td>0</td> <td>0</td>
    </tr>
 
We also have to add a tab to the bottom portion of the page by adding this:
 
 	<li><a href="#tab10">Kalyani</a></li>
 	<li><a href="#tab12">Beijing</a></li> <!-- ADDED this line -->
 
After that we will add the actual div that contains the tab content:

	<div id="tab11a" style="margin:0px auto;position:relative; width: 800px; height: 500px;">
    </div></div>

    <div id="tab12" style="margin:0px auto;position:relative; width: 800px; height: 500px;"class="tab">
    </div> <!-- Added this line -->
 			
As for the javascript portion, this takes much attention to detail. For the cell variables, we need to change the number because the new table will have a different number of columns than the old one. Right after the json file is read, there are a number of variables that update the table. These numbers must be increased by one because we are adding one more column to the table. If the code looked like this:

	cell_1[11] = table[0].rows[1].cells[11];
    cell_2[11] = table[0].rows[2].cells[11];
    cell_3[11] = table[0].rows[3].cells[11];
    cell_6[11] = table[0].rows[4].cells[11];
      
We would change all the 11's to 12's but keep the row numbers the same because we are not changing the number of rows in the table. You will do this for all the cell variables where the json is being read.

You also have to add this part to the javascript portion near the end f the script:

	else if(currentAttrValue.slice(1) == 'tab12'){
    $('#tab12').empty();
    whole_world(currentAttrValue.slice(1),"bubbles/GACA-CN_bub.json","GACA-CN.json");}

This is to make the map read the right data when the Beijing tab is clicked

### Run_get.sh
Adding a new project to the shell script is very important. You must add this line to the script:

	cat *GACA-CN*.txt > gacacnfiles.txt 

## Changing Files
When update_data.pl is run, it appends data to certain csv files. We will update the headers to reflect the change. Since this project is uploading to RIKEN we will go into RIKEN_up_archive.csv and RIKEN_ave_archive.csv and add GACA-CN to the end of the header:

	quarter,BTCA-SG,LIRI-JP,ORCA-IN,GACA-CN

We also have to go in and put Beijing in the header of up_data_archive.csv and ave_data_archive.csv. Be sure to put it right before TCGA-US because order matters in this file. 

	quarter,Heidelberg,Cambridge,Toronto,Barcelona,Singapore,Tokyo,Hinxton,Seoul,Kalyani,Brisbane,Beijing,TCGA-US
	
The last file we have to change is location.json . We just have to add this one line to the json file:

	{"name": "Beijing", "latitude": 39.9139, "longitude": 116.3917, "radius": 15, "fillKey": "blue","project": "GACA-CN"},


