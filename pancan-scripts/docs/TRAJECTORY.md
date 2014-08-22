# Trajectory Page (http://pancancer.info/trajectory)

# Table of Contents
  * [Scripts Needed](#scripts-needed)
  * [About](#about)
  * [Collecting the Data](#collecting-the-data)
  * [Visuals Created](#visuals-created)

## Scripts Needed
  * time.pl
  * decider.sh

## About
This page was made to predict the completion date for the alignments. It is based on three averages, which are: daily, bi-daily, and weekly. Based on these averages there are three lines showing the slope and this will tell us when the estimated date of completion will be from each average. The target number represented by the red line is the number of uploaded specimens for data train 2.0. 

## Collecting the Data
This site works along side with http://pancancer.info/index1.html . It will keep an archive of the number of aligned specimens each day and that is the data used to create each line. The archive with all the numbers of alignments per day is called align_archive.csv . This file is made from running the script align_count.pl . When the script runs, it will get a total count of alignments and push the numbers to the archive along with the date. It will only push the data to the file if you choose the train "2". You can run it by putting in this command:

    # USAGE: perl align_count.pl --train <TRAIN NUMBER>
    perl align_count.pl --train 2
    
At the same time, it will output a json file that is used for the site http://pancancer.info/

Using the archive created, you can now look through it and find the slope of each line you need. The script time.pl will do just that. Once it is run it will create a csv file that is used to make the chart. Run this command to see an example:

    perl time.pl
    
This will read in all the information from the archive and find each slope for the different time periods. The site uses a file called est.csv to read from so you could just pipe the output from time.pl to est.csv like this:

    perl time.pl > est.csv
    
After this you want to put the csv file in the place where the site is reading data from, in this case it is reading from /var/www

    cp est.csv /var/www/
    
## Visuals Created
The chart is a multi-series line chart that is very similar to the one on http://pancancer.info/uploads.html .There are also tooltips that are included so you can hover over each point and see the data for that day. To see more on how the chart was made, you can look at [this](http://www.delimited.io/blog/2014/3/3/creating-multi-series-charts-in-d3-lines-bars-area-and-streamgraphs). The line chart example is very good and explained quite well.
