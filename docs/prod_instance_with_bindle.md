# TCGA/ICGC PanCancer - Computational Node/Cluster from Scratch with Bindle

This is our SOP for how to launch clusters/nodes using Bindle
specifically for use by the TCGA/ICGC PanCancer project.  In addition to
providing production cluster environments for analyzing samples on the clouds
used by the PanCancer project, the Bindle process can also be used to
create workflow development environments.  Unlike AMI or OVA VM snapshots
the Bindle process builds an environment (whether cluster or single node)
up from a base Ubuntu 12.04 box, installing and configuring software as
it goes.  Any cloud-specific considerations are documented at the end of this guide.

Finally, single-node instances can be imaged and relaunched using the process detailed in the [following guide](image_instance.md)

## Use Cases

There are really three use cases for this technology by the PanCancer project.
First, to create a production environment for running analytical workflows for
PanCancer in environments that do not support image creation.
These are employed by "cloud shepherds" in "Phase II" to
analyze donors with standardized alignment and variant calling workflows.
This environment could also be used by "Phase III" researchers that need a virtual
cluster running Hadoop or SGE for their research.
The second use case is to create a workflow development environment for making and testing
new workflows for the project, especially if scaled-up testing across
a virtual cluster is required. Regardless, the directions for creating a node or
cluster with Bindle are the same.

### Build a PanCancer Workflow Running Environment

#### Overview of Steps

* decide on cloud environment and request an account, when you sign up you should get the cloud credentials you need (more detail below). Pancancer has 6 cloud environments, each with their own credentials, endpoints, settings, etc.
* launch an Ubuntu 12.04 VM in that cloud you will use this host as a "launcher host" which will launch other VMs that run workflows and/or are snapshotted for later use 
* ssh to this launcher host and use the instructions detailed below to setup the Bindle provision tool used to launch other VMs
* customize the Bindle template with your cloud settings (ex: ~/.bindle/aws.cfg), this was created for you by the above mentioned setup process
* launch your SeqWare worker node with PanCancer workflows using Bindle's launch\_cluster.pl tool
* you can do one of four things with this worker node:
   * 1) ssh into your SeqWare work node and launch SeqWare workflow(s) and monitor their results, this can be automated with a decider and is the process we use to automate "Phase II" of the project
    * _or_
    * 2) use the environment for developing, building, or using your own tools (e.g. "Phase III" activities), the following environments are available for your use:
       * GridEngine
       * SeqWare configured with the Oozie-SGE workflow engine
       * Hadoop HDFS 
       * Hadoop Oozie
   * _or_
   * 3) snapshot the VM to make an image which can then be launched again (potentially over and over again) and do the two above
   * _or_
   * 4) you can add the IP address to a workflow decider and have that decider schedule workflows here

Typically you would do 1 & 2 for development and 3 then 4 for production

#### Detailed Example - Amazon Web Services Single Node/Cluster of Nodes with the HelloWorld Workflow

Here I will show you how to create a single compute node running on AWS and
capable or executing the HelloWorld workflow to ensure your environment is
working.  This setup process will also install other PanCancer workflows along the way.  I chose AWS for its ease of access however please keep in mind
that we run in 6 academic clouds which do have their specific settings, see the section below. The mechanism for other clouds is
identical to the example below, however, so the example shown below should be
extremely helpful in accessing PanCancer clouds.

##### Step 0 - Get an Account

First, sign up for an account on the AWS website, see http://aws.amazon.com for
directions.  Brian O'Connor at OICR manages the accounts for the group.

##### Step 1 - Create a Launcher Host

Next, you can create a "launcher" host. This is your gateway to the system and
allows you to launch individual computational nodes (or clusters of nodes) that
actually do the processing of data.  It also is the location to run the
"decider" that will schedule the BWA (and other) workflows running on your many nodes in
this cloud.  This latter topic will be discussed in another guide focused on
workflow launching and automation.
 
The launcher host also improves the isolation of your computational
infrastructure.  It should be the only host accessible via SSH, should use SSH
keys rather than passwords, use a non-standard SSH port, and, ideally, include
Failtoban or another intrusion deterrent.  For AWS, please see the extensive
documentation on using security groups to isolate instances behind firewalls
and setup firewall rules at http://aws.amazon.com.

For our purposes we use an Ubuntu 12.04 AMI provided by Amazon.  See the
documentation on http://aws.amazon.com for information about programmatic,
command line, and web GUI tools for starting this launcher host.  For the
purposes of this tutorial we assume you have successfully started the launcher
host using the web GUI at http://aws.amazon.com.  

Next, we recommend you use an "m1.large" instance type as this is inexpensive
 to keep running constantly.

We also assume that you have setup your firewall (security group) and have
produced a .pem SSH key file for use to login to this host.  In my case my key
file is called "brian-oicr-3.pem" and, once launched, I can login to my
launcher host over SSH using something similar to the following:

    ssh -i brian-oicr-3.pem ubuntu@ec2-54-221-150-76.compute-1.amazonaws.com

Up to this point the activities we have described are not at all specific to
the PanCancer project.  If you have any issues following these steps please see
the extensive tutorials online for launching a EC2 host on AWS.  Also, please
be aware that Amazon charges by the hour, rounded up.  We are collectively responsible for the Amazon expenses you incur with your account so don't leave instances running if they aren't used.

#### Step 2 - Install Bindle, Vagrant, and Other Tools on the Launcher

The next step is to configure Vagrant (cloud-agnostic VM launcher),
Bindle (our tool for wrapping Vagrant and setting up a computational
environment/cluster), and various other dependencies to get these to work.  Log
onto your launcher now and download the current release of the architecture-setup project:

    wget https://github.com/ICGC-TCGA-PanCancer/architecture-setup/archive/1.0.1.tar.gz
    tar zxf 1.0.1.tar.gz
    cd architecture-setup-1.0.1

Now follow the documents at [architecture2](https://github.com/ICGC-TCGA-PanCancer/architecture-setup) which will install Bindle with all associated code for the pan-cancer profiles. These docs are authoritative here, the example below is just to give you an idea:

    sudo bash setup.sh
    ansible-playbook -i inventory site.yml

By default the inventory file points to the local host which will work perfectly for us here.

At this point you should have a launcher with Bindle and associated
tools installed. This is now the machine from which you can create one or more
SeqWare nodes/clusters for use with various workflows, GridEngine, or Hadoop.


#### Step 3 - Configuration

Now that you have Bindle and dependencies installed the next step is
to launch computational nodes or clusters that will run workflows via SeqWare,
launch cluster jobs via GridEngine, or perform MapReduce jobs.  In this step we
will launch a standalone node and in the next command block I will show you how to
launch a whole cluster of nodes that are suitable for larger-scale analysis.

Assuming you are still logged into your launcher node above, you will do the
following to setup a computational node.  The steps below assume you are
working in the Bindle directory:

    # run the Bindle launcher without a valid cfg file in order to copy over a template
    $ perl bin/launch_cluster.pl --config aws --custom-params 1
    # modify the .cfg file to include your settings, for AWS you need to make sure you fill in "aws.cfg"
    # For more help on filling the .cfg file, please refer to the section below
    $ vim ~/.bindle/aws.cfg
    # paste your key pem file contents, whatever you call it
    $ vim ~/.ssh/brian-oicr-3.pem
    $ chmod 600 ~/.ssh/brian-oicr-3.pem

Make sure you have copied your key to this machine (your pem file). I suggest
you use IAM to create limited scope credentials.  See the Amazon site for more
info.

Alternatively, you may want to launch a compute cluster instead of a single
node.  You can customize the number of worker nodes by increasing the number in the Bindle cfg file.

##### Filling in the config file

The config files are located at "~/.bindle/". Please open up aws.cfg (vim ~/.bindle/aws.cfg) since we are launching a cluster on AWS. 
One thing you must keep in mind before filling in the config files is not to delete any of the default
parameters you are not going to be needing. Simply, leave them blank if that is the case. 

##### Platform Specific Information

This section of the config file contains all the information that is required to set up the cloud platform.
We will need to fill out all the information in config/aws.cfg. For OpenStack, it is openstack.cfg and for vCloud, it is vcloud.cfg

Let us go through the parameters that might confuse you when you are filling the config file. I will not be going 
through the most obvious parameters (ie. key, secret_key, etc):

    [defaults]
    platform = aws
    aws_key= <fill this in>
    aws_secret_key= <fill this in>
    aws_instance_type = 'm1.xlarge' 
    aws_region = 'eu-west-1'
    aws_zone = nil 
    aws_image = <fill this in>
    aws_ssh_username = ubuntu
    aws_ssh_key_name = <fill this in>
    aws_ssh_pem_file = '<fill this in>'
   
    # For any single node cluster or a cluster in bionimbus environment, please leave this empty(Ex. '')
    # Else for a multi-node cluster, please specify the devices you want to use to setup gluster
    # To find out the list of devices you can use, execute “df | grep /dev/” on an instance currently running on the same platform.
    # (Ex. '--whitelist b,f' if you want to use sdb/xvdb and sdf/xvdf). 
    # Note, if your env. doesn't have devices, use the gluster_directory_path param
    gluster_device_whitelist='--whitelist b'
    # For any single node cluster or a cluster in bionimbus environment, please leave this empty(Ex. '')
    # Else for a multi-node cluster, please specify the directory if you are not using devices to set up gluster
    # (Ex. '--directorypath /mnt/volumes/gluster1')
    gluster_directory_path=''
    
    box = dummy
    box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'
    host_inventory_file_path=ansible_host_inventory.ini
    ansible_playbook = ../pancancer-bag/pancancer.yml
    seqware_provider=artifactory
    seqware_version='1.1.0-alpha.5'
    
    install_bwa=true
    
    number_of_clusters = 1
    number_of_single_node_clusters = 1
    bwa_workflow_version = 2.6.2
    

Note that all variables above are also passed along into Ansible. The other platform specific parameters are self explanatory. In the config file, there is a "fillmein" value which indicates that you
defintely have to fill those in to have bindle working properly. The others are default values that you may use unless otherwise stated.

##### Cluster Specific Information

This information exists in small blocks named cluster1, singlenode1, etc. These blocks contain essential information such as number of nodes,
target\_directory, the number of nodes to create, the Ansible categories for hosts, etc.
    
Please note that you can create a new cluster by copy-pasting the existing cluster1
block and modifying the configs for it or you can simply modify cluster1 configs and use that.
Feel free to change the number of nodes (min 1, max recommended 11). Please note that 
if the number of nodes is 1, it means that there will be 1 master and 0 worker nodes. 
An example cluster block will look something like this:

    # Clusters are named cluster1, cluster2, etc.
    # When launching a cluster using launch_cluster.pl
    # use the section name(cluster1 in this case) as a parameter to --launch-cluster
    [cluster1]
   
    # this includes one master and three worker nodes
    number_of_nodes=4
   
    # this specifies the output directory where everything will get installed on the launcher
    target_directory = target-aws-1
   
   
 
To use a specific cluster block, you need to use the section name of that block as a parameter to --custom-params when you
are running the launch_cluster perl script. More on this in the next step.


#### Step 4 - Launch a SeqWare Node/Cluster

Now that you have customized the settings in .cfg file, the next step is to launch a computational node. Note, each cluster gets its own target directory which you can specify the name of in .cfg file when you make a cluster block. Within the target dir you will find a log for each node (simply master.log for a single-node launch) and a directory for each node that is used by the vagrant command line tool (the "master" directory for a single-node launch). The latter is important for controlling your node/cluster once launched. 

    # now launch the compute node. For --cluster, you specify the name of the cluster block you want to launch from the .cfg file
    $ perl bin/launch_cluster.pl --config=aws --custom-params=cluster1

You can follow the progress of this cluster launch in another terminal with.
Use multiple terminals to watch logs for multiple-node clusters if you desire:

    # watch the log
    $ tail -f target-aws-1/master.log

Once this process finishes, you should see no error messages from
"bin/launch_cluster.pl". If so, you are ready to use your cluster/node.

If you want to launch multiple clusters, make sure to specify different target directory names (ex. target-os-1, target-os-2, etc.) in the config file!

#### Step 5 - Log In To Node/Cluster

Vagrant provides a simple way to log into a launched node/cluster.  Typically you will only want/need to login to the master node.  For example:

    # log into the master node
    $ cd target-aws-1/master
    $ vagrant ssh

This will log you into the master node.  You can change user to the seqware
user which will be used for subsequent steps or root if you need to do some
administration of the box.

    # switch user to seqware
    $ sudo su - seqware
    # or switch user to root (not generally needed!)
    $ sudo su -

#### Step 6 - Verify Node/Cluster with HelloWorld

Now that you have a node or a cluster the next step is to launch a sample
HelloWorld SeqWare workflow to ensure all the infrastructure on the box is
functioning correctly.  Depending on the template you used this may or may not
be already installed under the seqware user account. If not, you can download a
copy of the workflow and install it yourself following our guides on
http://seqware.io (see
https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4.zip).
The commands below assume the workflow is installed into
provisioned-bundles/Workflow\_Bundle\_HelloWorld\_1.0-SNAPSHOT\_SeqWare_1.1.0-alpha.4.

    # assumes you have logged into your master node and switched to the seqware user
    $ ls provisioned-bundles/
    Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4
    # now run the workflow
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.0-alpha.4

This command should finish without errors.  If there are problems please report
the errors to the SeqWare user group, see http://seqware.io/community/ for
information about posting to our mailing list.

#### Step 7 - Terminate Node/Cluster

At this point you have successfully ran a workflow.  You can use this node or
cluster to run real workflows or just as a general GridEngine or Hadoop
environment.  Those topics are beyond the scope of this document but are
covered in other SOPs.  When you finish with a node or cluster you can
terminate it or, depending on the environment, you can suspend it for use
later.  Keep in mind suspend works for single nodes but clusters of nodes
cannot be suspended and then booted up later again on most cloud infrastructure
because IP addresses typically change and this disrupts things like GridEngine
and Hadoop.

    # terminate the cluster/node
    $ perl bin/launcher/destroy_launcher.pl --cluster-name target-aws-1/

You should always check in the AWS console (or OpenStack, vCloud, or other
console for a different cloud) that your nodes have been terminated otherwise
you will be billed for a machine you think is terminated.


#### Next Steps

Much more information can be found in the README for the Bindle project, see https://github.com/CloudBindle

In latter sections of this document you can see more information about:

* differences with other PanCancer clouds environments, what needs to change in the above detailed steps, see "Cloud-Specific Notes" below
* different templates available, for example, ones that automatically install the BWA-Mem workflow, see "Additional Configuration Profiles" below

## Additional Configuration Profiles

This section describes some additional profiles we have available for the
PanCancer project. These are hosted by [pancancer-bag](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag) 

First, please see the general documentation above and the
README for Bindle, the tool we use to build these clusters using
Vagrant. This will walk you through the process of using this software.  This
tool allows us to create clusters in different cloud environments using a
common set of configuration scripts.  We have used this project to prepare two
different profiles, one for building clusters of VMs and another for single,
stand-alone VMs.  In addition, each of those can optionally install our
reference BWA (and potentially other) workflows.  This latter process can be
very time consuming so that is why we provide a profile with and without the
workflow(s) pre-installed.

### Cluster Without Workflows

Simply use Bindle (using the cfg file) at the seqware-bag playbook and omit pancancer-bag. 

### Cluster With BWA Workflow

Simply use Bindle (using the cfg file) at the pancancer-bag playbook. 

## Cloud-Specific Notes

Each cloud used for PanCancer will be slightly different.  This section covers
information that is particular to each.

### Notes for the EBI Embassy Cloud (vCloud)

The Embassy Cloud at EBI uses vCloud.  The Vagrant vCloud plugin has limited
functionality and, therefore, only single nodes can be launched there.

### Notes for BioNimbus PDC 1.1 (OpenStack)

BioNimbus uses OpenStack and the Vagrant OpenStack plugin is quite stable however the PDC 1.1 environment is in flux. You
can launch VM clusters or single nodes.

When you launch the cluster you need to do the following differently from the examples above:

    # install the OpenStack vagrant plugin
    $ vagrant plugin install vagrant-openstack-plugin
    # make sure you apply the rsync fix described in the README.md

    # example launching a host 
    $ perl bin/launcher/launch_cluster.pl --use-openstack --use-default-config --launch-cluster cluster1

There are several items you need to take care of post-provisioning to ensure you have a working cluster:

* generate your keypair using the web conole (or add the public key using command line tools: "nova keypair-add brian-pdc-3 > brian-pdc-3.pem; chmod 600 brian-pdc-3.pem; ssh-keygen -f brian-pdc-3.pem -y >> ~/.ssh/authorized_keys").
* make sure you patch the rsync issue, see README.md for this project
* you need to run SeqWare workflows as your own user not seqware. This has several side effects:
    * when you launch your cluster, login to the master node
    * "sudo su - seqware" and disable the seqware cronjob
    * make the following directories in your home directory: provisioned-bundles, released-bundles, crons, logs, jars, workflow-dev, and .seqware
    * copy the seqware binary to somewhere on your user path
    * copy the .bash_profile contents from the seqware account to your account
    * copy the .seqware/settings file from the seqware account to your account, modify paths
    * change the OOZIE_WORK_DIR variable to a shared gluster directory such as /glusterfs/data/ICGC1/scratch, BioNimbus will tell you where this should be
    * create a directory on HDFS in /user/$USERNAME, chown this directory to your usesrname.  For example: "sudo su - hdfs;  hadoop fs -mkdir /user/BOCONNOR; hadoop fs -chown BOCONNOR /user/BOCONNOR"
    * copy the seqware cronjob to your own user directory, modify the scripts to have your paths, install the cronjob
    * install the workflow(s) you want, these may already be in your released-bundles directory e.g. "seqware bundle install --zip Workflow_Bundle_BWA_2.2.0_SeqWare_1.0.13.zip"
    * probably want to manually install the BWA workflow rather than via the Bindle provisioning process. This lets you install as your own user in your own directory and not in the seqware directory (or you need to update the SeqWare metadb to point to the right place).  You can see below an example of changing the SeqWare MetaDB to point to your provisioned workflow bundle path:

    update workflow set current_working_dir =  '/glusterfs/netapp/homes1/BOCONNOR/provisioned-bundles/Workflow_Bundle_BWA_2.2.0_SeqWare_1.0.13' where workflow_id = 50;

After these changes you should have a working SeqWare environment set to run workflows as your user.

#### More PDC 1.1 Tips

You can snapshot the VM but if you do you need to ensure the hostname is reset on reboot and tomcat is restarted.  Add the following to /etc/rc.local (the exit 0 is already at the end of the script):

    hostname master
    /etc/init.d/tomcat7 restart
    exit 0

That will ensure the machine comes back after reboot.

Also, if you are going to snapshot in OpenStack you will want to make sure you setup SGE according to the instance type you will use in the future e.g. the flavor.  Here I'm adjusting for a 16 core, 64G machine:

    sudo qconf -aattr queue slots "[master=16]" main.q
    sudo qconf -mattr queue load_thresholds "np_load_avg=16" main.q
    sudo qconf -rattr exechost complex_values h_vmem=63000000000 master

To snapshot see the following command:

    nova image-create ff625cf8-e5c9-46b6-9c08-2c6189eb3f9f Ubuntu-12.04-LTS-v1.5.3-CgpCnIndelSnvStr-1.0-SNAPSHOT-SeqWare-1.1.0a5-v1

Adjust as need be, name your new image as you like.  You can then launch a new copy of this VM image using the standard nova commands.

### Notes for OICR (OpenStack)

OICR uses OpenStack internally for testing and the Vagrant OpenStack plugin is
quite stable.  The cluster is not available to the general PanCancer group.

* generate your keypair using the web conole

Here are some difference from the docs above:

    # install the open stack vagrant plugin
    $ vagrant plugin install vagrant-openstack-plugin

    # example launching a host
    $ perl bin/launcher/launch_cluster.pl --use-openstack --use-default-config --launch-cluster cluster1

Also note, here are the additional things I had to do to get this to work:

* I absolutely had to use float IP addresses for all nodes. Without the float IPs addresses the nodes could not reach the Internet and provisioning failed.
* I used the "seqware" network
* I used the "SoftEng" tennant
* see our internal wiki for more settings

### Notes for Annai Systems (BioComputeFarm)

Annai provides an OpenStack cluster that works quite well.  You can use it for
both nodes and clusters.

### Notes for Amazon (AWS)

OICR uses AWS internally for testing and the AWS Vagrant plugin is quite
stable. The cluster is available for any PanCancer user but is not officially
part of the Phase II activities.

Some issues I had to address on Amazon:

* some AMIs will automount the first ephemeral disk on /mnt, others will not. This causes issues with the provisioning process. We need to improve our support of these various configurations. With the current code, any device on /dev/sdf or above will automatically be formated, mounted, and added to gluster
* the network security group you launch master and workers in must allow incoming connections from itself otherwise the nodes will not be able to communicate with each other

### Notes for Barcelona (VirtualBox)

Cloud are not available for both of these environments.  Instead, please use
VirtualBox to launch a single node and then use the "Export Appliance..."
command to create an OVA file.  This OVA can be converted into a KVM/Xen VM and
deployed as many times as needed to process production data.
