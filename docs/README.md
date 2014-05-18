# Overview

These documents primarily focus on "Phase II", where a core set of standardized pipelines are created by a small group of developers for running across all cloud environments.  They are targeted at three users, IT staff, Bioinformatics Workflow Developers, and Cloud Shepherds.  The latter of which focus on ensuring data is uploaded to each of the PanCancer cloud environments, the standardized workflows are successfully working, and data at each cloud is automatically analyzed with the available alignment/variant calling workflows.

The last section focuses on "Phase III", the moment in the project where analysis working group researchers log into these cloud environments to perform novel algorithms development and analysis on standardized workflow output.

# IT-Focused

These IT guides give an overview of our thoughts on the cloud-nature of this project as well as concrete recommendations for how to optimally setup OpenStack, our recommended cloud technology for this project.

* [VM Infrastructure Overview](https://wiki.oicr.on.ca/display/PANCANCER/PanCancer+VM+Deployment+Guide): Over of the cloud architecture envisioned by the project.
* [OpenStack Installation Guide](openstack_install.md): Specific recommendations on how to install and configure OpenStack for use with PanCancer.

# Developer-Focused

These guides are geared towards a developer wanting to create a new workflow for the PanCancer project in "Phase II".  They walk you through the process of creating a workflow development and testing environment, running a sample production-ready workflow from the project, creating and testing your new workflow, and advanced workflow authoring topics.

* [Our Workflow Approach](workflow_approach.md)
* Creating a Workflow Development Environment
    * [Launch a Test/Dev Node via Amazon](dev_node_ami.md): a fast way to get a working development environment in the cloud
    * [Launch a Test/Dev Node Locally via VirtualBox](dev_node_ova.md): a fast way to get a working development environment running on your local machine, it is a great way to develop workflows and test locally before scaling up
    * [Create a New Test/Dev Node with Bindle and VirtualBox](dev_node_ova_shared.md): allows you to create a dev/testing node from scratch with our latest provisioning tool, includes a shared folder so you can edit workflows in an IDE and test the workflow in the VM
    * [Create a New Test/Dev Node/Cluster with Bindle and a Cloud](prod_cluster_with_bindle.md): allows you to create virtual clusters of machines from scratch on a cloud with our latest provisioning tool, useful for scaling up your tests
* [Test Run the Production BWA Workflow](run_bwa.md): ensure your development environment works by running the BWA workfow
* [Create, Test, and Package a New Workflow](create_workflow.md): basic overview of creating a new workflow
* [Advanced Workflow Creation Topics](advanced_workflows.md): some more advanced concepts for workflow development

# Cloud Shepherd-Focused

These guides are geared towards our "Cloud Shepherds".  For each cloud environment we have assigned a cloud shepherd to 1) ensure our provisioning process can build virtual clusters in that environment and 2) setup automated running of core "Phase II" workflows within their respective clouds. They also work closely with workflow authors to ensure new core workflows are deployed smoothly to these environments.

* [Create a New Production Node/Cluster with Bindle](prod_cluster_with_bindle.md): instructions for the cloud shepherd to create virtual clusters of machines with our latest provisioning tool
* [Automatically Running Workflows in a Cloud with a Decider](run_bwa_with_decider.md): instructions for automating the running of workflows with a decider.

# Working Group Researchers

These guides focus on researchers in "Phase III" who are accessing the cloud environments, analyzing data produced in "Phase II" with the standardized workflows, and creating their own novel algoirthms/protocols for analyzing data.

* [Accessing Clouds](researchers_accessing_clouds.md)
* [Accessing Phase II Data within the Clouds](researching_accessing_data.md)

# Testing Matrix

What profiles from Bindle have been tested in which cloud environments.

| *Configuration name*                                              | OpenStack (OICR) | AWS      | vCloud (EBI Embassy) | VirtualBox | OpenStack (BioNimbus PDC) |
|-------------------------------------------------------------------|:----------------:|:--------:|:--------------------:|:----------:|:-----------:|
|*vagrant_cluster_launch.seqware.install.sge_cluster.json.template* | &#x2713;         | &#x2713; |                      |            | |
|*vagrant_cluster_launch.seqware.install.sge_node.json.template*    | &#x2713;         | &#x2713; | &#x2713;             | &#x2713;   | |
|*vagrant_cluster_launch.seqware.sge_cluster.json.template*         | &#x2713;         | &#x2713; |                      |            | |
|*vagrant_cluster_launch.seqware.sge_node.json.template*            | &#x2713;         | &#x2713; | &#x2713;             | &#x2713;   | |
|*vagrant_cluster_launch.pancancer.seqware.install.sge_cluster.json.template*   | &#x2713; | &#x2713; | &#x2717; | NA | &#x2713; |
|*vagrant_cluster_launch.pancancer.seqware.install.sge_node.json.template*      | &#x2713; | &#x2713; |  | &#x2713; | &#x2713; |
