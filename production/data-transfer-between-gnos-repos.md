# File transfer between GNOS Repositories

This document goes through a method of downloading files from one GNOS repository and uploading them to another. 
Transfering the files can come in handy when you in particular want a set of files on a single GNOS Repo. This is 
particularily important for the Sanger workflow, as it requires the aligned BAMs to be from the same repo. 

##Downloading the GNOS files based on analysis ID

## Download metadata xml file:
  
    wget -O metadata.xml https://gtrepo-<institute-name>.annailabs.com/cghub/metadata/analysisFull/<analysisUUID>

## Download analysis files:
    gtdownload -c <yourPath>/gnostest.pem -v -d https://gtrepo-<institute-name>.annailabs.com/cghub/data/analysis/download/<analysisUUID>

##Create upload xml files from metadata.xml

###analysis.xml:
From the metadata.xml file copy the following section into a new file analysis.xml inside of the <analysisUUID> folder.

```
<ANALYSIS_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.ncbi.nlm.nih.gov/viewvc/v1/trunk/sra/doc/SRA_1-5/SRA.analysis.xsd?view=co">
<ANALYSIS center_name="OICR" analysis_center="ebi" analysis_date="2015-07-23T13:39:11">
<TITLE>TCGA/ICGC PanCancer Donor-Level Variant Calling for Participant PCSI_0287</TITLE>
<STUDY_REF refcenter="OICR" refname="icgc_pancancer_vcf" />
....
</ANALYSIS>
</ANALYSIS_SET>
```
###experiment.xml
From the metadata.xml file copy the following section into a new file experiment.xml inside of the <analysisUUID> folder.
```
<EXPERIMENT_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.ncbi.nlm.nih.gov/viewvc/v1/trunk/sra/doc/SRA_1-5/SRA.experiment.xsd?view=co">
<EXPERIMENT center_name="CNG" alias="CNG:C0UREACXX:B00FS9W">
…
</EXPERIMENT>
</EXPERIMENT_SET>
```
###run.xml
From the metadata.xml file copy the following section into a new file run.xml inside of the <analysisUUID> folder.
```
<run_xml>
<RUN_SET xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.ncbi.nlm.nih.gov/viewvc/v1/trunk/sra/doc/SRA_1-5/SRA.run.xsd?view=co">
<RUN center_name="CNG" alias="CNG:C0LVJACXX">
<EXPERIMENT_REF refcenter="CNG" refname="CNG:C0LVJACXX:B00FS9W" />
….
</RUN>
</RUN_SET>
```
##Uploading data to new repo
At this point you have downloaded and prepared the data for upload next you will need to perform and cgsubmit, which will
provide you with and manifext.xml file and then do a cgsubmit with the following two commands. 

###Generate Manifest file
  cgsubmit -s https://gtrepo-dkfz.annailabs.com -o $submitlog -u $data_folder -c $GNOS_PERM > $submitlog.out


###Example manifest.xml file
```
<?xml version="1.0" encoding="utf-8"?>
<SUBMISSION center_name="OICR" created_by="cgsubmit 3.1.1" submission_date="2015-06-26T21:44:42.218628" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="GeneTorrentManifest.xsd">
<SERVER_INFO server_path="bd04c5d4-1c46-11e5-ae07-56b44df37a3f" submission_uri="https://gtrepo-dkfz.annailabs.com/cghub/data/analysis/upload/bd04c5d4-1c46-11e5-ae07-56b44df37a3f"/>
<FILES>
<FILE checksum="58af37d425466bcbf4886efa119674c0" checksum_method="MD5" filename="C0ENM.3.bam" filetype="bam"/>
</FILES>

</SUBMISSION>
```

##Upload bam file
  gtupload -v -c <yourpath>/gnostest.pem -u <analysisUUID>/manifest.xml >> <analysisUUID>/gtupload.log 2>&1
