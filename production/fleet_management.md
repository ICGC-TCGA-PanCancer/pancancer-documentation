## Managing an existing Pancancer environment

### To terminate a node
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



<!-- 
Some ideas:

  - basic stuff such as how to kill a worker node
  - deploying INI files to existing workers that have already finished their initial workflow
  - trouble-shooting workflow errors (maybe in workflow-specific pages)
  - terminating workers that are having problems
  - monitoring?
-->
