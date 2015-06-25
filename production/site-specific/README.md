## Site-specific tips and tricks
This page contains tips, tricks, and information about running the pancancer tools in specific environments.

### DKFZ - OpenStack

Some of the German cloud images don't have natting rules in place to allow communication between machines and the<br>
cloud controller.  To acheive this a couple of custom nat rules need to be added to IPTABLES.

This further complicates the use of docker by requiring us to use the host NIC INSIDE the docker container to avoid<br>
problems created by a [natting hairpin](http://en.wikipedia.org/wiki/Hairpinning).

Use the: `--net="host"` option when launching docker to achieve this.<br>
We are currently testing a solution to bake this workaround into later versions of the launcher.



### AWS With Arch 3


1. Workaround https://github.com/ICGC-TCGA-PanCancer/container-host-bag/issues/7 by spinning up an existing worker AMI and installing BWA
2. Needed to spin up an external Ubuntu 14.04 instance to use as a sensu server and point ~/.youxia/config at it since it looks like arch3/youxia can't connect to the container itself to idempotently setup/skip sensu-server setup
3. Change the following fields of the BWA template :numOfThreads, use_gtdownload,use_gtupload, skip_upload, input_reference, gnos_key, cleanup
  * input_reference is wrong by default (for arch3 anyway)
  * input_reference needs to be a path valid inside the container
  * gnos_key location is also wrong by default
4. Commands

        perl generate_ini_files.pl --workflow-name=Workflow_Bundle_BWA  --gnos-repo=https://gtrepo-ebi.annailabs.com/ --whitelist=aws_ireland.150611-1743.paca-ca.txt  --template-file=templates/bwa_template.ini --password=<blank out> --vm-location-code=aws_ireland
  
        java -cp ~/arch3/bin/pancancer-arch-3-1.1-alpha.0.jar info.pancancer.arch3.jobGenerator.JobGeneratorDEWorkflow --workflow-name BWA --workflow-version 2.6.1 --workflow-path /workflows/Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5 --config ~/arch3/config/masterConfig.json --ini-dir ini_batch_1

### ETRI with Arch3

1. ETRI seems to have no networking setup for openstack. Simply blank this value in your masterConfig.json
2. ~~Use the same workaround as above to direct the deployer to point at a different sensu-server. Since the new version of the monitoring-bag has this value hard-coded to lookup from an environment variable, disable this and put in the ip address for the external sensu server~~ Newer versions of youxia allow you to simply not deploy the server component via youxia
3. Note that the ~/.ssh/gnos.pem location has changed. It is now ~/.gnos/gnos.pem. Change this in your bwa template. 
4. To kick things off, use the following commands:

        java -cp ~/arch3/bin/pancancer-arch-3-*.jar info.pancancer.arch3.jobGenerator.JobGeneratorDEWorkflow --workflow-name BWA --workflow-version 2.6.1 --workflow-path /workflows/Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5 --config ~/arch3/config/masterConfig.json --ini-dir ini_batch_2
        nohup  java -cp ~/arch3/bin/pancancer-arch-3-*.jar info.pancancer.arch3.containerProvisioner.ContainerProvisionerThreads  --config ~/arch3/config/masterConfig.json --endless &> provisioner.out &
        nohup java -cp ~/arch3/bin/pancancer-arch-*.jar info.pancancer.arch3.coordinator.Coordinator  --config ~/arch3/config/masterConfig.json --endless &> coordinator.out &
        
 For this deployment, we also setup a snapshot version of our reporting, but that is outside the scope of this document. 
