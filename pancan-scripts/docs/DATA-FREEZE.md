# Data Freeze Page (http://pancancer.info/data_freeze)

# Table of Contents
  * [About](#about)
  * [Collecting the Data](#collecting-the-data)
  * [Visuals Created](#visuals-created)
  * [Adding New Train](#adding-new-train)
    * [First Step - Get Data](#first-step---get-file)
    * [Second Step - Add HTML](#second-step---add-html)
    * [Third Step - Add Javascript](#third-step---add-javascript)
  
## About 
This page shows the amount of uploaded data in previous data trains. 

## Collecting the Data
The page gets its data from master spreadsheets that were created shortly after each freeze. The spreadsheets that are currently being used are:

    Data Freeze 1.0 Report: https://docs.google.com/spreadsheets/d/14NItsHKJUevHZIuFkFTwNF-C12WbXTrFe0oM0Xq6b4M/edit#gid=111470950
    Data Freeze 2.0 Report: https://docs.google.com/spreadsheets/d/1X3ZO3SIRm7emv3F5jCU116EprDWJnRGNqCB8x5HqOws/edit?usp=drive_web
    
These master spreadsheets provide all the data from each freeze and is used to make all the tables and charts on the page. The script freeze.pl is how the data on the tables and the charts were collected. The script will create either a json file for the table, or a csv file for the chart. 

  # YOU CHOOSE WHICH FILE YOU WANT 
  USAGE: perl freeze_count.pl --file <INPUT FILE> --output <OUTPUT TYPE> csv or json
  
This will give you the data needed for the table and chart. At the moment it is set to produce output for Data Train 2.0, however you may change the input file to whatever you like. You just have to put the path to the new file into the --file option. 

## Visuals Created
Like most of the other visuals on other pages, the chart is made using d3.js (http://d3js.org/). This useful tool allows us to easily create these charts by feeding in data. In this case the data that is needed is a csv that is created from the script mentioned above. The table on top is populated by a json file that is also created from the script above. 

## Adding New Train 
Using the script freeze_count.pl makes adding a train fairly simple. For this example you will see how to add data train 2.0 to the site.

### First Step - Get Data 
The first thing you want to do is create a tsv file form the spreadsheet. You can just copy and paste it if you would like. So for this example we would copy the spreadsheet and put it into a new file called train_2.tsv. You can double check to see if it is actually a tsv by doing this command:

    # TABS SHOW UP AS ^I
    cat -t train_2.tsv

Now that you have the data needed, you want to run the script freeze_count.pl on the new file created. You will need to run it for the tsv as well as the json. You need both types of output for the chart and table. You also want to pipe the output to a file:

    perl freeze_count.pl --file train_2.tsv --output tsv > data_train2.tsv
    perl freeze_count.pl --file train_2.tsv --output json > data_train2.json
  
This is all the data you need to make the chart and table on the page

### Second Step - Add HTML
For this part you can mostly use the html used to make the first table and chart. I will include the html that was used for the data train 2.0:

    <div id="table" style="width:960px;margin:0px auto;">
    <h3>Data Freeze 2.0</h3>
    <table name="x" id="rounded-corner" summary="">
      <thead>
      <tr>
      <th scope="col"></th>
      <th scope="col"><a title="This column shows the sum of all the ICGC projects from Data Freeze 2.0.">ICGC Total</a></th>
      <th scope="col"><a title="This column shows the totals of all the TCGA projects from Data Freeze 2.0.">TCGA Total</a></th>
      <th scope="col"><a title="This column shows the totals of both the ICGC and TCGA projects from Data Freeze 2.0.">Cumluative Total</a></th>
      </thead>
      <tbody>
      <tr>
      <td><b>Specimens Uploaded</b></td><td>0</td><td>0</td><td>0</td>
      </tr>
      <tr>
      <td><b>Matched Tumour/Normal Pairs</b></td><td>0</td><td>0</td><td>0</td>
      </tr>
      </tbody>
      <tfoot>
      <tr>
      <td colspan="17">*Numbers from Data Freeze 2.0, projects not included did not upload anything</td>
      </tr>
      </tfoot>
    </table>
    </div><!--table-->
    <div id="bar2" style="width:960px;margin:0px auto;"><h3 style="margin-left:30px:">Total Specimens Uploaded - Data  Freeze 2.0</h3></div>
    
This html will be inside the tablediv div right under the data train 1.0 visuals.

### Third Step - Add Javascript
Now that the html is all set, you need to add a little javascript. You have to add one line to make the chart for data train 2.0. You want to call the "charts" function with new parameters for the new train. 

    charts("data_train1.tsv",140,"#bar1");
    # ADD THIS RIGHT UNDER THE FIRST FUNCTOIN CALL 
    charts("data_train2.tsv",510,"#bar2");
    
The parameters entered are (inputfile,max_number,div). You already know what the inputfile and div are so you just need to find the max number in the tsv file created from freeze_count.pl

For the table you need to read in the json file and populate the table. This can be done with a simple for loop:

    # Declare Variables
    var table = document.getElementsByName("x");
    var json_data;
    var cell_1 = [];
    var cell_2 = [];
    var val_1 = [];
    var val_2 = [];
    var total_1 = 0;
    var total_2 = 0;
    # Read in JSON file 
    d3.json("/bubbles/data_train2.json", function(error, json) {     
                json_data = json;
                for (var i = 1; i < json_data.length+1; i++){
                        
                cell_1[i] = table[0].rows[1].cells[i];
                val_1[i] = cell_1[i].firstChild.data;
                cell_1[i].firstChild.data = ''+json_data[i-1].uploaded;
                
                cell_2[i] = table[0].rows[2].cells[i];
                val_2[i] = cell_2[i].firstChild.data;
                cell_2[i].firstChild.data = ''+json_data[i-1].matched;
                }
    });
    
This will populate the table with the numbers that are in the json file.
