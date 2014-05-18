# TCGA/ICGC PanCancer - Workflow Development Node from Scratch with Bindle and VirtualBox

This is our SOP for how to create a SeqWare workflow development environment
for use with the PanCancer project. Since the environment also contains
GridEngine and Hadoop it may be useful for creating workflows using those tools
directly however the focus will be on SeqWare workflow development. In this SOP we use
[VirtualBox](https://www.virtualbox.org/) to run a local VM which has a shared
folder with your desktop. This lets you develop in an IDE on your host
operating system and then compile and debug the workflow on the virtual
machine.  This is extemely helpful since it greatly shortens the turnaround time
between making changes in the workflow and trying it out in a VM.

NOTE: if you have problems getting this to work I would recommend using one of
our pre-created VMs by following either the [Launch a Test/Dev Node via Amazon](dev_node_ami.md)
guide or the [Launch a Test/Dev Node Locally via VirtualBox](dev_node_ova.md) guide.  Either
of these environments will let you create, test, and package workflows and can be
setup much more quickly than what is described here. The advantage of this guide is you can create a shared working environment which allows you to use your native OS's IDE and the VM for running/testing/compiling workflows.

## Use Cases

This approach is designed to create a workflow
development environment for creating and testing new workflows locally in
VirtualBox. It uses Bindle to start with a base Ubuntu 12.04 box and install/
configure all needed software at first boot.  After finished installing
you are left with a local workflow
development environment for creating new workflows for the project. Other guides
will show you how to use a similar approach to build nodes, or clusters of nodes,
in cloud environments.

## Steps

* you will be working locally using VirtualBox, make sure you have a Linux or Mac available to work on with 16G of RAM
* download and install:
    * Bindle
    * Vagrant
    * VirtualBox
* copy and customize the Bindle template of your choice (a single node only, do not use a cluster profile)
* launch your development node using vagrant_cluster_launch.pl, select "--use-virtualbox"
* ssh into your node
* Vagrant will automatically create a vagrant directory ("/vagrant" on the VM and within your "working_dir/master" dir) that is shared between your host and the VM
* create new SeqWare workflows in this "working_dir/master" directory, please see the Developer Getting Started Guide at http://seqware.io
* you can compile SeqWare workflows on your local computer or on the VM
* launch SeqWare workflow(s) on your VM to test them and monitor their results
* package your workflow as a zip bundle once your testing is complete, this can be distributed to other clouds for installation and execution in Phase II or Phase III.  See [Test Run the Production BWA Workflow](run_bwa.md) and [Create, Test, and Package a New Workflow](create_workflow.md).

## Detailed Steps Using VirtualBox Locally

The following is a detailed example showing you how to setup the workflow development environment:

### Step - Download and Install Components

These steps will be different depending on whether or not you use a Mac or
Linux host machine.  Much more information about Bindle can be found
at our GitHub site https://github.com/SeqWare/vagrant. In particular take a
look at the README.md which goes into great detail about installing and
configuring these tools.

This is an example for a Linux machine running Ubuntu 12.04. You will need to
follow a similar process if using a Mac but the detail are beyond the scope of
this document.

Note the "$" is the Bash shell prompt in these examples and "#" is a comment:

    # download and install VirtualBox
    $ wget http://download.virtualbox.org/virtualbox/4.3.8/virtualbox-4.3_4.3.8-92456~Ubuntu~precise_amd64.deb
    # sudo dpkg -i virtualbox-4.3_4.3.8-92456~Ubuntu~precise_amd64.deb

    # download SeqWare Vagrant 1.2
    $ wget http://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/bindle_1.2.tar.gz
    $ tar zxf bindle_1.2.tar.gz
    $ cd bindle_1.2

    # install bindle dependencies, again see README for Bindle
    $ sudo apt-get update
    $ sudo apt-get install libjson-perl libtemplate-perl make gcc

    # make sure you have all the dependencies needed for Bindle, this should not produce an error
    $ perl -c vagrant_cluster_launch.pl

    # now install the Vagrant tool which is used by Bindle
    $ wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.4.3_x86_64.deb
    $ sudo dpkg -i vagrant_1.4.3_x86_64.deb
    $ vagrant plugin install vagrant-aws

In the future we will provide pre-configured OVA for the development environment
to eliminate the installation tasks above. All that will be required is
VirtualBox. For now please move on to the next step.

### Step - Configuration

Now that you have Bindle and dependencies installed the next step is
to launch your local VM that will run workflows via SeqWare, launch cluster
jobs via GridEngine, or perform MapReduce jobs.

The steps below assume you are working in the bindle_1.2 directory:

    # copy the template used to setup a SeqWare single compute node for PanCancer
    # no modifications are required since you are launching using VirtualBox
    $ cp templates/sample_configs/vagrant_cluster_launch.pancancer.seqware.install.sge_node.json.template vagrant_cluster_launch.json

### Step - Launch a SeqWare Dev Node

Now that you have customized the settings in vagrant_cluster_launch.json the
next step is to launch a computational node. Note, each launch of a
node/cluster gets its own "--working-dir", you cannot resuse these.  Within the
working dir you will find a log for each node (simply master.log for a
single-node launch) and a directory for each node that is used by the vagrant
command line tool (the "master" directory for a single-node launch). The latter
is important for controlling your node/cluster once launched.

For VirtualBox there are two optional parameters that control memory and CPUs
used.  We recommend 12G for the RAM and 2 or more CPUs depending on what is
availble on your machine. Do not attempt to use more RAM/CPU than you have
available.

    # now launch the compute node, 12G RAM, 2 CPU cores
    $ perl vagrant_cluster_launch.pl --use-virtualbox --working-dir target-vb-1 --vb-ram 12000 --vb-cores 2 --config-file vagrant_cluster_launch.json

You can follow the progress of this cluster launch in another terminal with.
Use multiple terminals to watch logs for multiple-node clusters if you desire:

    # watch the log
    $ tail -f target-vb-1/master.log

Once this process complete you should see no error messages from
"vagrant_cluster_launch.pl". If so, you are ready to use your workflow
development node.

### Step - Log In To Node/Cluster

Vagrant provides a simple way to log into a launched node.  For example:

    # log into the master node
    $ cd target-vb-1/master
    $ vagrant ssh

This will log you into the master node.  You can change user to the vagrant
user which will be used for subsequent steps or root if you need to do some
administration of the box. We use the "vagrant" user because that user owns the
/vagrant directory which is the shared filesystem with target-vb-1/master. By
using this user we can edit files via and IDE on the host computer and compile
and test the workflow as the vagrant user working in /vagrant. The vagrant user
is very similarly configured compared to the seqware user and can, essentially,
be thought of in the same way:

    # switch user to vagrant
    $ sudo su - vagrant
    # or switch user to root (not generally needed!)
    $ sudo su -

#### Step - Verify Node/Cluster with HelloWorld

Now that you have a workflow development node the next step is to launch a sample
HelloWorld SeqWare workflow to ensure all the infrastructure on the box is
functioning correctly.  Depending on the template you used this may or may not
be already installed under the seqware user account. If not, you can download a
copy of the workflow and install it yourself following our guides on
http://seqware.io (see
https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13.zip).

    # assumes you have logged into your master node and switched to the vagrant user
    # download the sample HelloWorld workflow
    $ wget https://s3.amazonaws.com/oicr.workflow.bundles/released-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13.zip
    # install the workflow
    $ seqware bundle install --zip Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13.zip
    # now run the workflow with default test settings
    $ seqware bundle launch --dir provisioned-bundles/Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.0.13

This command should finish without errors.  If there are problems please report
the errors to the SeqWare user group, see http://seqware.io/community/ for
information about posting to our mailing list.

## Next Steps

Take a look at the [Test Run the Production BWA Workflow](run_bwa.md) to see how to install and run the BWA workflow and [Create, Test, and Package a New Workflow](create_workflow.md) for information on creating your own workflows.

Much more information about building nodes/clusters in the cloud can be found in the README for the Bindle
project, see https://github.com/SeqWare/vagrant

For general workflow development using SeqWare we encourage you look at our extensive
documentation on http://seqware.io and post to the user list if you run into
problems.
