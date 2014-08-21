# Sites Page (http://pancancer.info/)

# Table of Contents
  * [Scripts Needed](#scripts-needed)
  * [About](#about)
  * [Collecting the Data](#collecting-the-data)
  * [Visuals Created](#visuals-created)
  * [Adding New Train](#adding-new-train)
    * [First Step - Get Data](#first-step---get-file)
    * [Second Step - Add HTML](#second-step---add-html)
    * [Third Step - Add Javascript](#third-step---add-javascript)
    
## Scripts Needed 
  * align_count.pl
  * decider.sh

## About 
This page is the main part of the site. It shows the aligned/unaligned amount of specimens for each train. The trains are filtered to only show the specimens that are included in the repspective train. There is also a live table that shows all the ones that are aligned using workflow 2.6 or higher. You can access log files associated with each count by clicking the headers. 

## Collecting the Data 
The data for this page comes from the log files that are created from the workflow_decider.pl script. With these log files, the script align_count.pl will produce a json file that will show the amount that are aligned, unaligned, and remaining for each repo. You can also choose which train you want to count for. An example for running the script for train 2.0 is :

    perl align_count.pl --train 2

This command will produce a json file that looks like this:

    [
    {"repo": "gtrepo-bsc", "align": 0, "total_unalign": 192, "remaining": 192},
    {"repo": "gtrepo-osdc-icgc", "align": 0, "total_unalign": 0, "remaining": 0},
    {"repo": "gtrepo-osdc-tcga", "align": 0, "total_unalign": 0, "remaining": 0},
    {"repo": "gtrepo-dkfz", "align": 34, "total_unalign": 718, "remaining": 684},
    {"repo": "gtrepo-ebi", "align": 4, "total_unalign": 599, "remaining": 595},
    {"repo": "gtrepo-etri", "align": 5, "total_unalign": 20, "remaining": 15},
    {"repo": "gtrepo-riken", "align": 0, "total_unalign": 591, "remaining": 591},
    {"repo": "gtrepo-cghub", "align": 462, "total_unalign": 462, "remaining": 0}
    ]

Just pipe the output to a file like train2.json. If you want to get the json for the map you can use the bubbles option:

    perl align_count.pl --train 2 > train2.json
    perl align_count.pl --train bubbles > traindata2.json
    
If you run the script with the train "2" option, it will push the total aligned number to the file align_archive.csv. This archive file is needed for making the chart on http://pancancer.info/trajectory .

## Visuals Created
There are maps and tables on this page that were made using d3. You can see more about the maps [here](http://datamaps.github.io/) and see more about tables [here](https://github.com/ICGC-TCGA-PanCancer/pancancer-info/blob/develop/pancan-scripts/docs/how-to-tables.md) 

## Adding New Train 
Adding a train invovles changing the scripts and should not be too much of a hassel. For this exmaple you will see how to add data train 2.0

### First Step - Changing Scripts
The first thing you need to do go into the script align_count.pl and add a couple of things. You need to add the data train 2.0 file that we will be reading from. Go into the spreadsheet for the report and make a tsv file on the server. The report for data train 2.0 is found here https://docs.google.com/spreadsheets/d/1X3ZO3SIRm7emv3F5jCU116EprDWJnRGNqCB8x5HqOws/edit#gid=1173712136 you can just copy and paste the spreadsheet into a file called train_2.csv

You then have to read it into the script itself:

    # DECLARE NEW ARRAY
    my @spec_marc2;
    open(FH,"train_2.tsv") or die("Can't open train_2.tsv $!");
    while (my $line = <FH>) {
    chomp $line;
    my @cols = split "\t" , $line;
    push (@spec_marc2,$cols[3]); # $cols[3] is the specimen names
    }
    close(FH);
    
Now we have to change the array that is being read. You want to change it so that it reads from all the repos taht are involved in the train. In this case we want to add this:

    elsif($train eq "2"){
    @ary = ("gtrepo-bsc","gtrepo-osdc-icgc","gtrepo-osdc-tcga","gtrepo-dkfz","gtrepo-ebi","gtrepo-etri","gtrepo-riken","gtrepo-cghub");}
    
In the for loop you want to add these variables:

    my $data2 = 0; # COUNT FOR ALIGNED 
    my $unaligned_total2 = 0; # COUNT FOR UNALIGNED
    my $check2 = 0; # CHECK FOR NUMBER OF ALIGNMENTS PER SPECIMEN
    
The variable $check2 is to make sure we only count one of the alignments for specimens that may have multiple alignments. Now you must add some things under each condition: 

    if (index($line,"SPECIMEN/SAMPLE:") != -1){
      $check2 = 0; # ADD 
    }
   
    if (index($line,"ALIGNMENT:") != -1 && $spec ne ""){
    # is it unaligned?
    if (index($line,"unaligned") != -1) { # ADD
    elsif ($spec ~~ @spec_marc2){ # ADD
        $unaligned_total2 += 1;# ADD
        }# ADD
    }
    
    elsif (index($line,"Workflow_Bundle_BWA") != -1){
    if ($train eq "1" or $train eq "2" or $train eq "bubbles"){ # ADD 
        if($spec ~~ @spec_marc2){ # ADD 
        $check2 += 1; # ADD 
        #print "$line\n"; # ADD 
        if ($check2 == 1){ # ADD 
        #print " $elem $spec\n"; # ADD 
        $data2+=1;}; # ADD 
        }} # ADD 
    }  

After adding these lines to the conditions, the script is almost functional for data train 2.0. Now we need to add a couple more lines:

    my $unaligned_remain2 = $unaligned_total2 - $data2;
    if ($unaligned_remain2 < 0) {$unaligned_remain2 = 0;}
    if ($unaligned_total2 < $data2){$unaligned_total2 = $data2;}
    
    elsif($train eq "2"){
    if ($elem ne "gtrepo-cghub"){
    print qq({"repo": "$elem", "align": $data2, "total_unalign": $unaligned_total2, "remaining": $unaligned_remain2},\n);}
    else{
    print qq({"repo": "$elem", "align": $data2, "total_unalign": $unaligned_total2, "remaining": $unaligned_remain2}\n);}
    } 
    
Adding all of this should allow the script to make a json output that reflects data train 2.0

### Second Step - Add HTML
Now that you have the proper output coming from the script, you can change the html to add another table and map. To make a new table add this code:

    <div id="#data2" style="width:911px;">
    <h2 style="float:left;">Data Train 2.0</h2>
    <p style="float:left;">This table only displays the specimens that are part of data train 2.0. Only specimens from <a target="_blank" href="https://docs.google.com/spreadsheets/d/1X3ZO3SIRm7emv3F5jCU116EprDWJnRGNqCB8x5HqOws/edit#gid=1481057674">Data Freeze Train 2.0 Report</a> are included.</p>
    <p>
    <table name ="x1" id="rounded-corner" summary="">
    <thead>
    <tr><th></th><th><a target="_blank" href="log_train/1gtrepo-bsc.log">Barcelona</a></th><th><a target="_blank" href="log_train/1gtrepo-osdc-icgc.log">Chicago(ICGC)</a></th><th><a target="_blank" href="log_train/1gtrepo-osdc-tcga.log">Chicago(TCGA)</a></th><th><a target="_blank" href="log_train/1gtrepo-dkfz.log">Heidelberg</a></th><th><a target="_blank" href="log_train/1gtrepo-ebi.log">London</a></th><th><a target="_blank" href="log_train/1gtrepo-etri.log">Seoul</a></th><th><a target="_blank" href="log_train/1gtrepo-riken.log">Tokyo</a></th><th><a target="_blank" href="log_train/1gtrepo-cghub.log">Santa Cruz</a></th><th>Total</th><th>% of 4150</th></tr>
    </thead>
    <tbody>
    <tr><td><b>Aligned Specimens</b></td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
    
    <tr><td><b>Remaining Specimens to Align</b></td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
    
    <tr><td><b>Total Unaligned Specimens</b></td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
    </tbody>
    <tfoot>
    <tr>
    <td colspan="19">*Click for  <a target="_blank" href="https://docs.google.com/spreadsheets/d/1X3ZO3SIRm7emv3F5jCU116EprDWJnRGNqCB8x5HqOws/edit#gid=1481057674">Data Freeze Train 2.0 Report</a></td>
    </tr>
    </tfoot>
    
    </table>
    </p>
    </div>

This will create a table full of zeros and will be populated by the json that is going to be fed. 

### Third Step - Add Javascript
Now we have to populate the table with data from the json produced by the script align_count.pl. Add these variables:

    var json_data2;
    var table2 = document.getElementsByName("x1");
    var cell_1 = [];
    var cell_2 = [];
    var cell_3 = [];
    var total_4 = 0;
    var total_5 = 0;
    var total_6 = 0;
    
To read in the json file you have to use the d3 library: 

    d3.json("train2.json", function(error, json) {
                json_data2 = json;
                var arr =[];
                for (var i = 0; i < json_data2.length; i++){                

                cell_1[i] = table2[0].rows[1].cells[i+1];
                val_1[i] = cell_1[i].firstChild.data;
                cell_1[i].firstChild.data = ''+json_data2[i].align;
                total_4 += json_data2[i].align;
                
                cell_2[i] = table2[0].rows[2].cells[i+1];
                val_2[i] = cell_2[i].firstChild.data;
                cell_2[i].firstChild.data = ''+json_data2[i].remaining;
                total_5 += json_data2[i].remaining;
                
                cell_3[i] = table2[0].rows[3].cells[i+1];
                val_3[i] = cell_3[i].firstChild.data;
                cell_3[i].firstChild.data = ''+json_data2[i].total_unalign;
                if (json_data2[i].total_unalign == 0 && json_data2[i].repo != "gtrepo-osdc-icgc"){
                        arr.push("yes");}
                else{
                        arr.push("no");}        
                total_6 += json_data2[i].total_unalign;
                }

                for (var t = 0;t < arr.length;t++){
                if (arr[t] == "yes"){
                cell_1[t] = table2[0].rows[1].cells[t+1];
                cell_2[t] = table2[0].rows[2].cells[t+1];
                cell_3[t] = table2[0].rows[3].cells[t+1];

                cell_1[t].firstChild.data = 'offline';
                cell_2[t].firstChild.data = 'offline';
                cell_3[t].firstChild.data = 'offline';}
                }
                cell_1[9] = table2[0].rows[1].cells[9];
                cell_2[9] = table2[0].rows[2].cells[9];
                cell_3[9] = table2[0].rows[3].cells[9];
        
                cell_1[9].firstChild.data = '' + total_4;
                cell_2[9].firstChild.data = '' + total_5;
                cell_3[9].firstChild.data = '' + total_6;
        
                cell_1[10] = table2[0].rows[1].cells[10];
        
                var ave = (total_4/4150)*100;
                var num = ave.toFixed(2);
        
                cell_1[10].firstChild.data = '' + num;
                
    });


To make the map that goes with the table you need to add some more javascript with a little more html. The following code will use the d3 library to create a map with "bubbles" on it that correspond to the data from the table:

    <h2>Map for Train 2.0</h2>
    <div id="container1" style="position:relative; width:800px; height:500px"></div></center>

     <script>
      var colors = d3.scale.category10();
       //basic map config with custom fills, mercator projection
      var map = new Datamap({
        scope: 'world',
        element: document.getElementById('container1'),
        geographyConfig: {
          popupOnHover: false,
          highlightOnHover: false,
          highlightFillColor: '#ABDDA4',
        },
        projection: 'mercator',
        fills: {defaultFill: "#ABDDA4",
                gt50: colors(Math.random() * 20),
                gt60: "#63AFD0",
                gt70: "#0772A1",}
      })
        
        var json_data;
                  
                  d3.json("bubbles/traindata2.json", function(error, json) {
                          json_data = json;
                          map.bubbles(json_data, {
                                 popupTemplate: function(geo, data) {
                                          return "<div class='hoverinfo'>"+data.name+"<br/>Aligned: " + data.aligned + " Total: " +data.total+ "</div>";   
                                }
                          });
                  });
     </script>

