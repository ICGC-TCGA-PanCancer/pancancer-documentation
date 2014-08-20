# Adding a project to http://pancancer.info/

## Table of Contents

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
