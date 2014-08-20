# Sites Page (http://pancancer.info/)

# Table of Contents
  * [About](#about)
  * [Collecting the Data](#collecting-the-data)
  * [Visuals Created](#visuals-created)
  * [Adding New Train](#adding-new-train)
    * [First Step - Get Data](#first-step---get-file)
    * [Second Step - Add HTML](#second-step---add-html)
    * [Third Step - Add Javascript](#third-step---add-javascript)
    
## About 
This page is the main part of the site. It shows the aligned/unaligned amount of specimens for each train. The trains are filtered to only show the specimens that are included in the repspective train. There is also a live table that shows all the ones that are aligned using workflow 2.6 or higher. You can access log files associated with each count by clicking the headers. 

## Collecting the Data 
The data for this page comes from the log files that are created from the workflow_decider.pl script. With these log files, the script align_count.pl will produce a json file that will show the amount that are aligned, unaligned, and remaining for each repo. You can also choose which train you want to count for. An example for running the script for train 2.0 is :

        perl align_count.pl --train 2
      
