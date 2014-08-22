# QC Metrics (http://pancancer.info/qc)

# Table of Contents
  * [Scripts Needed](#scripts-needed)
  * [About](#about)
  * [Collecting the Data](#collecting-the-data)
  * [Visuals Created](#visuals-created)
  * [Adding Metrics](#adding-metrics)
    * [First Step](#first-step)
    * [Second Step](#second-step)
    * [Third Step](#third-step)
 
## Scripts Needed
  * xml_parse.pl
  * cleanup.pl
  * per_specimen.pl
  * parse.sh

## About 
This page shows the qc metrics for that are from the xml files created from the workflow_decider.pl . Only the aligned files have qc metrics so not all xml files are included. It provides a histogram showing distribution of whatever metric you would like to look at. You can also filter the results by readgroup or specimen, by project, and by specimen type. This shows the user a good indication of the quality of the files uploaded. There are also links provided to show the data that has been graphed so the user can analyze it themselves.

## Collecting the Data
Before running anything, make sure to run the workflow decider for all repos and gather all the xml files that are needed.

        perl workflow_decider.pl --gnos-url https://gtrepo-bsc.annailabs.com --report gtrepo-bsc.log --ignore-lane-count --upload-results --test --working-dir gtrepo-bsc
        perl workflow_decider.pl --gnos-url https://gtrepo-ebi.annailabs.com --report gtrepo-ebi.log --ignore-lane-count --upload-results --test --working-dir gtrepo-ebi
        perl workflow_decider.pl --gnos-url https://gtrepo-dkfz.annailabs.com --report gtrepo-dkfz.log --ignore-lane-count --upload-results --test --working-dir gtrepo-dkfz
        perl workflow_decider.pl --gnos-url https://gtrepo-etri.annailabs.com --report gtrepo-etri.log --ignore-lane-count --upload-results --test --working-dir gtrepo-etri
        perl workflow_decider.pl --gnos-url https://gtrepo-osdc-icgc.annailabs.com --report gtrepo-osdc-icgc.log --ignore-lane-count --upload-results --test --working-dir gtrepo-osdc-icgc
        perl workflow_decider.pl --gnos-url https://gtrepo-osdc-tcga.annailabs.com --report gtrepo-osdc-tcga.log --ignore-lane-count --upload-results --test --working-dir gtrepo-osdc-tcga
        perl workflow_decider.pl --gnos-url https://gtrepo-riken.annailabs.com --report gtrepo-riken.log --ignore-lane-count --upload-results --test --working-dir gtrepo-riken
        perl workflow_decider.pl --gnos-url https://cghub.ucsc.edu --report gtrepo-cgub.log --ignore-lane-count --upload-results --test --working-dir gtrepo-cghub

As described in the brief description, all the data is from the xml files created from the workflow_decider.pl . The script xml_parse.pl is able to take a file and produce this output:

    2014-07-31 15:33:09,105a51c4-cc7e-4d0f-9cf8-e4d64a31d14d,UCEC-US,Primary tumour - solid tissue,5c22c8d6-5805-455c-8e1c-e6b8006738e4,105a51c4-cc7e-4d0f-9cf8-e4d64a31d14d,ca213835-efc5-4216-a762-a6b320b516bf,,b8f26252-d5bc-4084-8006-dc2ef9928a52,648456b0-d91a-11e3-950a-0927963883d2,184798760,100,7454081758,WUGSC:C2U7DACXX_2,20477109,36777574305,246.807,WGS:WUGSC:H_LR-D1-A17K-01A-11D-A325-09-lg1-lib1a,184671356,157733691,180063318,82923635,100,18463176094,1cfaec8e-9f51-42c0-8543-f055e6492c12,ILLUMINA,648456b0-d91a-11e3-950a-0927963883d2,74810056,18314398211,369597520,7474360756,251.000,31.518,PAWG.1cfaec8e-9f51-42c0-8543-f055e6492c12.bam,184798760,184227162,368898518,36959752000,12.3199173333333,99.5070916736671,99.8108748132293,0.426771508098864,48.7187570955563,5.54038051986929
    
Using the shell script, parse.sh, it will go through each gtrepo working directory and aggregate the output into one file called all.csv . It will then go and clean it up by runnung cleanup.pl, getting rid of any rows without any qc metrics and make the file all_qc.csv . After that it will make a last file called bases.csv which only includes the metrics per specimen. 

## Visuals Created
The histogram is created using d3.js (http://d3js.org/) and all the data needed is created through the scripts: xml_parse.pl, cleanup.pl, specimen_bases.pl . With these scripts, you will have all the necessary files to create the histogram. The histogram lets the user easily see what the distribution is like and provides a quick way of checking if the uploads are meeting criteria(ex. 30x Coverage). To see more on how the histogram was made, click [here](http://bl.ocks.org/mbostock/3048450). The one used on the site is very similar to this example.

## Adding Metrics
The javascript making the graph filters the information based on which fields are selected from the drop down menus. To add other metrics to the graph you have to change the csv files that are created from the scripts. 

### First Step
Change the temp.csv file by adding the header of the new metric you want. For example if you want to add percentage of total reads r2, you could add a header like %_total_reads_r2 to the end, as seen below:

        date,aliquot_id,dcc_project_code,dcc_specimen_type,submitter_donor_id,submitter_sample_id,submitter_specimen_id,total_lanes,use_cntl,read_group_id,#_total_reads_r2,read_length_r1,#_gc_bases_r1,platform_unit,#_duplicate_reads,#_mapped_bases,mean_insert_size,library,#_mapped_reads_r1,#_divergent_bases,#_mapped_reads_properly_paired,#_divergent_bases_r2,read_length_r2,#_mapped_bases_r1,sample,platform,readgroup,#_divergent_bases_r1,#_mapped_bases_r2,#_total_reads,#_gc_bases_r2,median_insert_size,insert_size_sd,bam_filename,#_total_reads_r1,#_mapped_reads_r2,#_mapped_reads,#_total_bases,average_coverage,%_mapped_bases,%_mapped_reads,%_divergent_bases,%_mapped_reads_proplery_paired,%_duplicate_reads,%_total_reads_r2

### Second Step 
Go into the script cleanup.pl and add an array of the information you want to add and a variable for the number. In this case we will make the array percent_reads_r2 and the variable reads_r2:

        my @percent_reads_r2;
        my $reads_r2;

After that is made you want to put the calculation into the loop and then push the number to the array. For this calculation we need to see which columns are needed. They turn out to be column 10/ column 29 = total_reads_r2/total_reads:

        if ($fields[13] ne "" && $fields[4] ne "" && $fields[4] ne "Primary tumour - solid tissue" && $fields[4] ne "Normal - other" && $fields[0] ne "date"){
        
        $reads_r2 = ($fields[10]/$fields[29]); # ADDING NEW LINES HERE
        push(@percent_reads_r2,$reads_r2); # ADDING NEW LINES HERE
        
        # Calculating the total bases per readgroup
        $total = ($fields[10] * $fields[22]) + ($fields[11]*$fields[34]);
        # Calculating the average coverage per readgroup
        $ave = $total/3000000000;
        $map_base = ($fields[15]/$total)*100;
        $diver_bases = ($fields[19]/$total)*100;
        $map_reads = ($fields[36]/$fields[29])*100;
        $proper = ($fields[20]/$fields[29])*100;
        $dup = ($fields[14]/$fields[29])*100;
        push(@mapb,$map_base);
        push(@mapr,$map_reads);
        push(@diver,$diver_bases);
        push(@prop,$proper);
        push(@dupli,$dup);
        push(@average,$ave);
        push(@total_bases,$total);
        push (@lines,$line);
        }

After this you want to add it to the part that actually prints the results:

        open(my $file, '>',"/home/ubuntu/gitroot/public-workflows/decider-bwa-pancancer/all_qc1.csv") or die ("Can't open all_qc.csv: $!");
        for (my $i = 0; $i < scalar @lines;$i++){
        if ($i == 0){print $file "$lines[0]\n";}
        # ADDING $percent_reads_r2[$i] TO END OF LINE
        else{print $file "$lines[$i],$total_bases[$i],$average[$i],$mapb[$i],$mapr[$i],$diver[$i],$prop[$i],$dupli[$i],$percent_reads_r2[$i]\n";}
        };
        close $file;
        
Now you want to change the output for the per specimen file as well. Here we will add the calculation to the output. Go into the script specimen_bases.pl and add these lines:

        my $percent_reads_r2 = ($spec{$key}{"total_reads_r2"}/{$spec}{$key}{"total_reads"}); # ADD THIS LINE RIGHT BEFORE LARGE PRINT STATEMENT 
        # ADD NUMBER TO PRINT STATEMENT
        print "$date,$ali,$proj,$type,$donor,$sample_id,$key,$lanes,$cntl,$read_id,$total_reads_r2,$read_length_r1,$gc_bases_r1,$platform_unit,$duplicate_reads,$mapped_bases,$mean_insert_size,$library,$mapped_reads_r1,$divergent_bases,$properly_paired,$divergent_bases_r2,$read_length_r2,$mapped_bases_r1,$sample,$platform,$readgroup,$divergent_bases_r1,$mapped_bases_r2,$total_reads,$gc_bases_r2,$median_insert_size,$insert_size_sd,$bam,$total_reads_r1,$mapped_reads_r2,$mapped_reads,$total,$ave,$per_mapped_bases,$per_mapped_reads,$per_diver_bases,$per_proper,$per_dup,$percent_reads_r2\n";
        
## Third Step
By this step you should hvae successfully created a new csv file with your new header at the end. The next step is to go into the html and add this option to the drop down menu:

        <option value="%_total_reads_r2">% Total Reads R2</option>
        
This should allow the graph to filter the data based on this new metric when ou go to choose it.
