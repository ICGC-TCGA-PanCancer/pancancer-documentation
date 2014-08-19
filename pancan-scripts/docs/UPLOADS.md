# Uploads Page (http://pancancer.info/uploads.html)

## About
This page shows the specimens uploaded for every project. The first table shows aggregates the ICGC projects by city and puts all the TCGA projects together in one column. It shows the totals and percentages of all sites as well. Below the table are two charts which show the percentage and uploaded specimens each day/week. This is a good way to see the progress of each city. There are also options to view everything by the associated repo for both charts. Finally there is a map with tabs of all the cities included. This map is mainly for looking at the uploads/project and there is also a table showing the GNOS repo that each project is uploading to.

## Collecting the Data
This site gets the number of uploads by referencing variuos spreadsheets:

	BTCA-SG: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddGhFak1rZEJmUHFjOWR3MTRPVndrVlE&usp=drive_web
  	BOCA-UK: https://docs.google.com/spreadsheet/ccc?key=0AoQ6zq-rG38-dE5ZZVEyaUNadU9mZlpVN1hDU0lDOWc&usp=drive_web
  	BRCA-EU: https://docs.google.com/spreadsheet/ccc?key=0AoQ6zq-rG38-dGxmTXM0bVdrYWxKUFpSaHFHWFJOaEE&usp=drive_web#gid=0
  	BRCA-UK: https://docs.google.com/spreadsheet/ccc?key=0AoQ6zq-rG38-dGhvbjUzRUR5ZEJHN1RyMEhqM1QwMUE&usp=drive_web#gid=0
  	CLLE-ES: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddFlnVTNmVXA5dWFNWlBhbVlpTFdWTlE&usp=drive_web
  	CMDI-UK: https://docs.google.com/spreadsheet/ccc?key=0AoQ6zq-rG38-dDMzQmZvNGVLUU9LRnpiV0RSenNCbHc&usp=drive_web
  	EOPC-DE: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddEUtMUdHTFlrajA5Y0poQmFqTVdpY3c&usp=drive_web
  	ESAD-UK: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddENiS3F2V1BIU3diVGpRd3hPeHkyWXc&usp=drive_web#gid=4
	LIRI-JP: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddExGbTZfSG1HZmZJTEUxVjN0NzZNNlE&usp=drive_web
  	LICA-FR: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddFctcDhqajNtWVM5aWxzQzByTzl2MEE&usp=drive_web
  	MALY-DE: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddFdLWlJ3YkxoMzA4TnB4QXhkQ0VuWVE&usp=drive_web
  	ORCA-IN: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddEdwaHBVdlJqMlVfYjd5SFRqek9PbHc&usp=drive_web
  	OV-AU: https://docs.google.com/spreadsheet/ccc?key=0AmNjl5CExbvAdGNqc0wzcG5sZVBEZmJrbUtMaWNoQVE&usp=drive_web
  	PACA-AU: https://docs.google.com/spreadsheet/ccc?key=0AmNjl5CExbvAdDA0N2JEZXptQXVKcXR3SmNja0llSWc&usp=drive_web
  	PAEN-AU: https://docs.google.com/spreadsheet/ccc?key=0AmNjl5CExbvAdG1iekFoNDRnZ1p5bm1KSzBhUmItNlE&usp=drive_web
  	PBCA-DE: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddDAyT2x1WmQ5dkl0NENnVTdPSXBLRXc&usp=drive_web
  	PRAD-UK: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddEZ6aUdVMnVoX1FEdVZ2REswY3pVMGc&usp=drive_web#gid=6
  	LAML-KR: https://docs.google.com/spreadsheet/ccc?key=0ApWzavEDzSJddEJfUVJ2TEd0aGJJazM3RktXVmtGX1E&usp=drive_web

These spreadsheets are most of the projects that are part of ICGC. There are also two master spreadsheets for data train 1 and 2:
  Data Train 1.0: https://docs.google.com/spreadsheets/d/14NItsHKJUevHZIuFkFTwNF-C12WbXTrFe0oM0Xq6b4M/edit?usp=drive_web
  Data Train 2.0: https://docs.google.com/spreadsheets/d/1X3ZO3SIRm7emv3F5jCU116EprDWJnRGNqCB8x5HqOws/edit?usp=drive_web
  
And this spreadsheet is a quick check of what si uploaded so far by project:
  Summary: https://docs.google.com/spreadsheet/ccc?key=0AnBqxOn9BY8ldE5RUk5WX09hV1k4MllOVDdBMFFRNWc&usp=drive_web#gid=0
  
The script get_spreadsheets.pl will download all these spreadsheets except the master ones and will use process them for getting the final numbers. It will turn the spreadsheets into txt files which are tab separated so you acan easily parse them for wanted information.

## Counting Logic
Once all these files are downloaded, the script update_data.pl will parse them and look for what has been uploaded. Using log files from the workflow_decider.pl, the script will check if any of the specimens in the spreadsheets are in the log files and if it is there, it means that the specimen has been uplaoded. For example, if you are looking to see if specimen RK123_B01 has been uploaded, the script will check the log files and see that it is in gtrepo-riken.log:

  DONOR/PARTICIPANT: RK123

	SAMPLE OVERVIEW
	SPECIMEN/SAMPLE: RK123_B01
		ALIGNMENT: unaligned
			ANALYZED SAMPLE/ALIQUOT: RK123_B01
				LIBRARY: WGS:RIKEN:RK123_B01_L01
					BAMS: CB4AB818-C622-11E3-BF01-24C6515278C0.bam,CB774658-C622-11E3-BF01-24C6515278C0.bam,CB297928-C622-11E3-BF01-24C6515278C0.bam,CB703FA2-C622-11E3-BF01-24C6515278C0.bam
					ANALYSIS_IDS: 2b29c42f-da58-11e3-9e71-fa88058fb7ba,2b2f1e93-da58-11e3-9e71-fa88058fb7ba,2b25adb3-da58-11e3-9e71-fa88058fb7ba,2b1a7137-da58-11e3-9e71-fa88058fb7ba

After this happens for all the specimens in every spreadsheet, it will have a total count for each project. However it will also check the upload count in this spreadsheet:

  https://docs.google.com/spreadsheet/ccc?key=0AnBqxOn9BY8ldE5RUk5WX09hV1k4MllOVDdBMFFRNWc&usp=drive_web#gid=0

If the count for uploads for any project is higher in this spreadsheet, the site will use that number instead. This is possible because the spreadsheets are made by many people and may not be regularly updated. The summary page gets updated weekly from the xml files made from the workflow_decider.pl

## Visuals Created
There are many visuals that are included on this page and a majority of them are made through the d3.js library. D3(Data Driven Douments) is a javascript tool that makes great visuals. You can look at examples here http://d3js.org/ . The two charts are made from csv files that look like this:
  
    quarter,Heidelberg,Cambridge,Toronto,Barcelona,Singapore,Tokyo,Hinxton,Seoul,Kalyani,Brisbane,Beijing,TCGA-US
    Tue Jul 29 '14 - 13:03,720.000,178.000,154.000,198.000,12.000,529.000,398.000,20.000,26.000,0.000000,25.000000,1874
    Wed Jul 30 '14 - 13:02,720.000,178.000,154.000,198.000,12.000,529.000,398.000,20.000,26.000,0.000000,25.000000,1874
    Thu Jul 31 '14 - 13:02,720.000,178.000,154.000,198.000,12.000,529.000,398.000,20.000,26.000,0.000000,25.000000,1874
    Fri Aug 01 '14 - 13:02,720.000,178.000,154.000,198.000,12.000,529.000,398.000,20.000,26.000,0.000000,25.000000,1874
    
The graphs will read in these csv's and produce a multi-series line graph.

The maps are also created using d3 and take in json data to graph. The json files look something like this:
  
    [
          {"name": "Heidelberg", "total": 812, "uploaded": 811, "latitude": 49.403159, "longitude": 8.676061, "radius": 30, "fillKey": "orange", "match": 392, "tumour": 305, "normal": 278},
          {"name": "Heidelberg", "total": 812, "uploaded": 811, "latitude": 49.403159, "longitude": 8.676061, "radius": 29.9630541871921, "fillKey": "green"},
          {"name": "Cambridge", "total": 484, "uploaded": 502, "latitude": 52.202544, "longitude": 0.131237 , "radius": 20, "fillKey": "orange","match": 164,"tumour": 58, "normal": 60},
          {"name": "Cambridge", "total": 484, "uploaded": 502, "latitude": 52.202544, "longitude": 0.131237 , "radius": 20.7438016528926, "fillKey": "green"},

          {"name": "Hinxton", "total": 262, "uploaded": 398, "latitude": 52.082869, "longitude": 0.18269 , "radius": 20, "fillKey": "orange", "match": 176,"tumour": 129, "normal": 91},
          {"name": "Hinxton", "total": 262, "uploaded": 398, "latitude": 52.082869, "longitude": 0.18269 , "radius": 30.381679389313, "fillKey": "green"},

          {"name": "Toronto", "total": 504, "uploaded": 177, "latitude": 43.7000, "longitude": -79.4000, "radius": 30, "fillKey": "orange","match": 88, "tumour": 78, "normal": 76},
          {"name": "Toronto", "total": 504, "uploaded": 177, "latitude": 43.7000, "longitude": -79.4000, "radius": 9.16666666666667, "fillKey": "yellow"}
    ]
    
These json files are also used to populate the tables that are made from javascript but not d3. 

The scripts that create these files are update_data.pl, bubble_read.pl, and arc_read.pl. These scripts will take care of all the files that are needed for the site. Combined with the run_get.sh shell script the flies will be allocated to the proper directory.
