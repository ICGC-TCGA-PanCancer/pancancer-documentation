# Tables on Pancancer.info

## The HTML Portion
First I will show you all the html used to make a table and then break it down. Here is the html for a table on pancancer.info:

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

So this is the code to generate the table on the page. Some important things to keep note of, are the table name, which is "x1" and the order of the columns. This is important when trying to populate the table from the html. The whole table is contained within the div "#data2" and has a width that you may adjust. The styling of the table comes from the css document style1.css which is imported at the top of the html document. You can easily change the format of the table and change the links that are associated with it as well. 

## The Javascript Portion 
The javascript portion is the part that actually populates the table by reading in some kind of json file. Here is the code used for the data train 2.0 table:

    <script type="text/javascript">
    var table2 = document.getElementsByName("x1");
    var json_data2;
    var cell_1 = [];
    var cell_2 = [];
    var cell_3 = [];
    var total_4 = 0;
    var total_5 = 0;
    var total_6 = 0;
  
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
    </script>
  
As i mentioned above, the table name is needed in the javascript portion. The following line makes sure that it is changing the right table on the page:

  var table2 = document.getElementsByName("x1");
  
You can also see some variables being made which are used in the for loop. The json file being read looks like this:

    [
    {"repo": "gtrepo-bsc", "align": 0, "total_unalign": 192, "remaining": 192},
    {"repo": "gtrepo-osdc-icgc", "align": 0, "total_unalign": 0, "remaining": 0},
    {"repo": "gtrepo-osdc-tcga", "align": 0, "total_unalign": 0, "remaining": 0},
    {"repo": "gtrepo-dkfz", "align": 39, "total_unalign": 718, "remaining": 679},
    {"repo": "gtrepo-ebi", "align": 4, "total_unalign": 599, "remaining": 595},
    {"repo": "gtrepo-etri", "align": 5, "total_unalign": 20, "remaining": 15},
    {"repo": "gtrepo-riken", "align": 0, "total_unalign": 591, "remaining": 591},
    {"repo": "gtrepo-cghub", "align": 477, "total_unalign": 477, "remaining": 0}  
    ]

This is why the order of the columns matter. It must match the order of the json file for the right numbers to display in the right position. In the for loop we go through each element in the json file and get all three numbers from it to put on the table. We also check if all three numbers are zero, this means that it is offline. We are also getting the totals for every row. Actually changing the cell in the table is a three step process. 

The first step is to say which cell you want to change by doing this:

    cell_1[1] = table2[0].rows[1].cells[1];

This line will go to the first row and pick the first cell. The cells start the count at zero so make sure you choose the one you actually want. The next step is to get the current value of the cell:

    val_1[1] = cell_1[1].firstChild.data;
  
This will get the current value of whatever cell you give it. The last step is to change the cell contents to whatever you like:

    cell_1[1].firstChild.data = ''+json_data2[0].align;
  
This line will make the first cell in the first row 0. This is because the first element in the array has a value of 0 for the align key. 

These are the three steps needed to change the values in the table and you see me doing this manually when i enter the totals and average. 
