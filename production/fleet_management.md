## Managing an existing Pancancer environment

### Launching a node
To launch a node, the command is fairly simple:

    cd ~/architecture-setup/Bindle/
    perl bin/launch_cluster.pl --config aws --custom-params singlenode

This assumes that your `~/.bindle/aws.cfg` (or `~/.bindle/openstack.cfg`) has the following section:

    [singlenode]
    number_of_nodes=1
    target_directory=singlenode_vagrant_1

The result of this will be a directory in Bindle named "singlenode_vagrant_1", containing files related to the launched node.

### Troubleshooting a node launch
If a node runs in to problems when launching, you might be able to find out more information about what happened in the vagrant logs. Navigate to the nodes directory, and inspect `master.log`.

    cd ~/architecture-setup/Bindle/singlenode_vagrant_1
    less master.log
    
These two commands will navigate to the directory that vagrant created when it attempted to launch the node and then view the log file.

Depending on what sort of error happened during startup, you may have to remove the node's directory and then try to launch the node again.

For example, if there was an error in your Bindle configuration file related to security keys (such as the wrong path to the ssh key file), those errors now exist in the files in the node directory, and it will probably be easier to simply remove the whole folder and try again than to try and correct every bad reference:

    cd ~/architecture-setup/Bindle/
    rm -rf singlenode_vagrant_1/
    perl bin/launch_cluster.pl --config aws --custom-params singlenode

If the worker node launches successfully, but the ansible playbook fails part of the way through (this is rare, but does happen sometimes, for example: a connection timeout while trying to download a large data file for a workflow), you can simply re-run the `launch_cluster.pl` script against the worker node. This script is what calls ansible and it is safe to run the ansible setup process on nodes where it has already run before.

### Adding new workflows
If you want to add a new workflow to an existing node, this can be done by modifying your bindle configuration file (`~/.bindle/aws.cfg` or `~/.bindle/openstack.cfg`). Simply update the `workflow_name` and `workflows` section and re-run the `launch_cluster.pl` command for a node. Bindle will run the ansible playbooks with the new workflow configurations and install the new workflows, as well as any new dependencies.

For example, change this:

    workflow_name=BWA,HelloWorld
    workflows=Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5,Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.1

to this:

    workflow_name=BWA,HelloWorld,Sanger
    workflows=Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5,Workflow_Bundle_HelloWorld_1.0-SNAPSHOT_SeqWare_1.1.1,Workflow_Bundle_SangerPancancerCgpCnIndelSnvStr_1.0.6_SeqWare_1.1.0

to install the Sanger workflow on a node that already has BWA and HelloWorld.

### Connecting to a worker node
There are a couple of ways to connect to your worker node:

1. Look at your environment management console (such as the AWS console or OpenStack dashboard), find the IP address worker node you want, and connect to it via SSH from the terminal of your choice. It's usually best to do this from your own workstation.
2. Directly from your launcher host (not recommended, except for making quick diagnostics):
    - Navigate to the the directory for the worker node:

            cd ~/architecture-setup/Bindle/singlenode_vagrant_1/master
        
    - Connect using vagrant:
    
            vagrant ssh

This will directly connect you from the launcher to the worker node.


### Terminating a node
If you have a node that you don't need or want anymore, you can shut it down like this:

1. Make sure you are attached to your running pancancer_launcher container 
2. Execute the following command:

```  
cd ~/architecture-setup/Bindle
perl bin/destroy-cluster.pl --cluster-name [the name of the node's folder]
```
For example, if your bindle config contained this information for the node in question:

    [singlenode]
    number_of_nodes=1
    target_directory=singlenode_vagrant_1
  
The actual command you would execute is:

    perl bin/destroy-cluster.pl --cluster-name singlenode_vagrant_1

<!-- Rewrite this section - since monitoring is now installed on all clients by default, it might not even need to be here anymore.

### Creating inventory file for monitoring-bag
To run the monitoring tools, you will need to generate an inventory file of your clients. To do this, run the following commands:

    cd ~/architecture-setup/Bindle
    perl bin/generate_master_inventory_file_for_ansible.pl <ansible-ssh-host> > inventory
    
After provisioning the node the monitoring should be setup on each node. The "ansible-ssh-host" in this command is the launcher hosts ip addresss. This will be used on each of the worker nodes and let them know where the sentral sensu server is for reporting their status.
-->

<!-- 
Some ideas:

  - basic stuff such as how to kill a worker node
  - deploying INI files to existing workers that have already finished their initial workflow
  - trouble-shooting workflow errors (maybe in workflow-specific pages)
  - terminating workers that are having problems
  - monitoring?
-->
