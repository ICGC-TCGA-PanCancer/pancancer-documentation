# PanCancer Architecture

## DESCRIPTION

The architecture consists of two main parts: the GNOS servers that host all of the data and the clusters that process the data. 

### GNOS

There are several GNOS servers around the world which host the PanCancer data. They can be accessed with client tools such as "cgquery".

### Cloud Environments

The archtecture can be been created on a number of cloud (and non-cloud) environments such as VirtualBox, vCloud, OpenStack and AWS. 

#### Development

VirtualBox is supported to allow workflow developers the abililty to spin up a SeqWare on their own computer. 

#### Provisioning

[Architecture Provisioning Scripts](https://github.com/ICGC-TCGA-PanCancer/architecture-setup) have been created to download, install and configure the environments with the various parts of the PanCancer Architecture. This system has been broken down into several GitHub projects for the sake of modularity. 

Depending on what you are intending on accomplishing you might want to setup the individual parts individually - each sub project can be installed independently. 

## Component Overview

While you will be learning about the various components in more detail as you proceed through the install guide for each role and component, this is a quick overview of most of the components for one pair of clouds. 

A commercial cloud can be paired with an academic cloud, SeqWare single-node instances run in each cloud, while youxia tooling (deployer, reaper) creates and tears down nodes running in AWS. We take advantage of the AWS and Openstack API in order to retrieve information on running instances while Sensu is used to aggregate data from checks collecting information about system status such disk space, running workflows, network IO performance, etc. A single decider queries GNOS and schedules workflows on the various SeqWare clusters. Finally, Bindle is used (in conjunction with the seqware-bag and pancancer-bag which are ansible playbooks) in order to create the original instances which can be imaged. 

Bindle can also be used in academic clouds to create instances (which may be imaged depending on what capabilities are available on each cloud). 


![Image of youxia](youxia.png)
