## SeqWare Working Directories ##

At various times, you may need to examine the SeqWare working directory for a particular workflow in order to do debugging or to harvest the results of a failed workflow that is unable to upload its results. This tutorial explains how to locate and explore these directories. 

### Locating it ###

There are a number of ways to locate the SeqWare working directory for a particular workflow.

First, you will need to locate your oozie working directory. Look at your ~/.seqware/settings file for the key of OOZIE\_WORK_\DIR. All workflow runs will create a randomly generated directory within this directory.

To locate the precise one that you are interested in:
* SeqWare reports the working directory when launching. When launching with either `seqware bundle launch` or 'seqware workflow-run launch-scheduled` look for a line that reads like the following 

        Using working directory: /usr/tmp/oozie/oozie-71c52ee1-ab47-455e-b7f6-18d0b9a40af3
* If you are working with an install of SeqWare using the oozie-sge workflow engine, you can use the `oozie jobs` command to obtain a list of workflow runs. Then follow up with the `oozie job -info <Job ID>`. The suffix of the Oozie app path can then be appended to your Oozie working directory to get the working directory. 
* If you are running with a install of SeqWare that includes the webservice, you can ask SeqWare. Use the command 'seqware workflow list' to locate the SeqWare accession of the workflow that you launched. Use the command `seqware workflow report --accession <accession>`, you're looking for the entry "Workflow Run Working Dir". Alternatively, if you know the accession for the workflow run, you can use `seqware workflow-run report --accession <accession>`
