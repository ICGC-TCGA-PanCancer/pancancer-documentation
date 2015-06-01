# Bindle Testing SOP

## Overview

This guide will guide you through the basic testing process for bindle.
Note that this guide does not explain you how to set up bindle for the 
particular environment you are going to be testing. For that, please 
refer to CloudBindle/Bindle repository.

## The Template files to test with (from [pancancer-bag[(https://github.com/ICGC-TCGA-PanCancer/pancancer-bag)) :

* vagrant_cluster_launch.pancancer.bwa_workflow.seqware.install.sge_cluster.json.template
* vagrant_cluster_launch.pancancer.bwa_workflow.seqware.install.sge_node.json.template
* vagrant_cluster_launch.pancancer.seqware.install.sge_cluster.json.template
* vagrant_cluster_launch.pancancer.seqware.install.sge_node.json.template

## Testing Process

The following is a detailed example of the testing process once you have launched
a cluster successfully using bindle. 

### Step - Check if gluster is setup or not

This checks for gluster. It should be set up for a multi-node cluster but shouldn't exist for a single node cluster.

    # check for gluster peers. If set up properly, it will show you a list of peers(worker1,worker2, etc.)
    # if it isn't set up, it will give you the following: "peer status: No peers present"
    $ sudo gluster peer status
    
    # check for gluster volumes. If set up properly, it will show you a list of gluster volumes
    # if it isn't set up, it will give you the following: "No volumes present"
    $ sudo gluster volume status
    
### Step - Run the Seqware Sanity Check Tool

This simply checks if the seqware environment is set up correctly on the cluster.

#### For SeqWare 1.1.X

    # switch to the seqware user
    $ sudo su - seqware
    $ seqware check --help
    $ seqware check --master
    # Check to see if it passed (0 is a pass and fail otherwise)
    $ echo $?

#### For SeqWare 1.0.X

    # switch to the seqware user
    $ sudo su - seqware
    # get the jar for seqware sanity check if you do not have it already
    $ wget https://seqwaremaven.oicr.on.ca/artifactory/seqware-release/com/github/seqware/seqware-sanity-check/1.0.15/seqware-sanity-check-1.0.15-jar-with-dependencies.jar
    # run the jar file   
    $ java -jar seqware-sanity-check-1.0.15-jar-with-dependencies.jar
    # Check to see if it passed (0 is a pass and fail otherwise)
    $ echo $?

### Step - Run the HelloWorld Workflow

This step assumes that the workflow is installed already on the cluster.  If not, you can download a copy of the workflow and install it yourself following our guides on http://seqware.io (see https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4.zip). 

    # assumes you have logged into your master node and switched to the seqware user
    $ ls provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4
    # now run the workflow
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4 

### Step - Run the BWA Workflow in local test mode if you have installed bindle using the BWA template

    # assumes you have logged into your master node and switched to the seqware user
    $ ls provisioned-bundles/Workflow_Bundle_BWA_2.6.2_SeqWare_1.1.0-alpha.4
    # now run the workflow
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_BWA_2.6.2_SeqWare_1.1.0-alpha.4/

## Next Steps

Update the [testing matrix](https://github.com/SeqWare/pancancer-info/blob/develop/docs/README.md#testing-matrix)
