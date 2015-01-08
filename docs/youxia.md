## Youxia ##

Pancancer uses the youxia suite of software tools to deploy, monitor, and teardown clusters on (Amazon) AWS.
Please refer to [Youxia](https://github.com/CloudBindle/youxia) for generic documentation for Youxia.

After using the [setup Playbook](https://github.com/CloudBindle/youxia/tree/develop/youxia-setup), you will have configured an instance with a deployer, reaper, and example decider running on a crontab. Edit this with the specific settings desired for your cluster. 

In particular, you will probably want to swap out the generic playbook included with Youxia with the last release of the pancancer playbook found [here](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag). You will want to check it out and then edit your crontab. 

### Controlled Shutdown ###

During the EBI outage, we had to shutdown all instances on AWS.

1. Edited ~ubuntu/crons/status.cron and commented out deployer and set kill limit on reaper to 0
2. Ran the cron

### Monitoring-bag Updates ###

You may reach a situation where you will want to update the sensu checks and the sensu-server with new checks and functionality. In order to do this, you will need to take the following steps:

1. Go to the monitoring-bag directory and pull a new copy

        git pull
2. Either pull the latest inventory used to deploy a node from the status log OR adjust the deployer to deploy one node as a test

        grep ansible-playbook ~/logs/status.log | tail -n 1 
        ansible-playbook -i <found inventory> <path to monitoring-bag> 
3. When you are satisfied with the new checks on that one specific node, you will want to deploy across all of your existing nodes
4. First, use the generator to list all of your nodes

        java -jar ~/youxia-generator/target/youxia-generator-1.1.0-alpha.3-jar-with-dependencies.jar --aws --output output.json
5. Use a converter script to convert from json to ansible playbook 
        cd ~/seqware-sandbox/ansible-pancancer/
        python host_inventory_form_json.py  --input_file_path output.json output.inventory
6. Merge the previous inventory file with the new one so that the merged inventory includes the sensu-server and a category of "master" for all other nodes
7. Re-run

        ansible-playbook -i output.inventory  /home/ubuntu/monitoring-bag/site.yml --private-key=<ssk key>
        
## Examples

In this section, we will detail our experiences setting up Youxia in particular environments

### OpenStack - From Scratch when snapshotting is not available ###

In certain OpenStack environments (OICR, Bionimbus) it is not possible to create image snapshots of images past a certain size (say 1TB). One workaround is to run all the various pancancer scripts from one integrated launch of the youxia deployer. These are the steps that you will need to take that differ from a typical youxia install. 

1. Use the regular architecture-setup procedure in order to setup bindle. Launch an instance after configuring the appropriate config file in ~/.bindle
2. You will need to harvest a json variable file from a working instance of bindle. These should reside in the working directories of Bindle. 

        $ ls
        ansible_run.1419384012.649983876.log  master      variables.1419384012.649983876.json
        inventory                             master.log  wrapscript.1419384012.649983876.sh
        $ls variables.1419384012.649983876.json 
        variables.1419384012.649983876.json

3. Setup youxia on the same host with the ansible-playbook/instructions in https://github.com/CloudBindle/youxia/tree/develop/youxia-setup
4. Install ansible 1.6.10 from https://seqwaremaven.oicr.on.ca/artifactory/simple/seqware-dependencies/ansible/ansible/1.6.10-precise/ansible-1.6.10-precise.deb
5. Configure youxia with an appropriate delay in your ~/.youxia/config . Modify deployer\_openstack.arbitrary_wait in miliiseconds. For example, it takes OpenStack at OICR roughly thirty minutes to spin up an instance successfully with a 1TB root disk. 
6. Make sure monitoring-bag has a properly setup ssl directory and disable the pem key distribution task if not using BWA. See the instructions at https://github.com/ICGC-TCGA-PanCancer/monitoring-bag
7. Launch the deployer and pass in the variable json file and the one-shot.yml from pancancer-bag. For example  

        $ java -jar youxia-deployer/target/youxia-deployer-1.1.0-beta.2-SNAPSHOT-jar-with-dependencies.jar --ansible-playbook ~/pancancer-bag/all.yml  --max-spot-price 1 --batch-size 1 --total-nodes-num 1 --openstack --ansible-extra-vars ~/variables.json

### Ireland ####

Here, we will document any specific steps taken for the deployment for pancancer with Ireland as a case study.

0. Create an AMI image with Bindle.
1. While proceeding through the youxia docs 
  1. Configure an integration for a Slack channel. In our case, we created a channel called #youxia-flying-snow and an Incoming WebHook which is specified in the youxia config file.
  2. Deploy an instance on Amazon and use the youxia-setup playbook against it to deploy all youxia components. We deployed youxia 1.1.0-beta.0

The following additions were required due to hook up the current monitoring-bag 

        --- a/youxia-setup/site.yml
        +++ b/youxia-setup/site.yml
        @@ -14,6 +14,17 @@
             lineinfile: dest=/etc/hosts line="{{ hostvars[item].ansible_ssh_host }} {{item}}" state=present
             when: hostvars[item].ansible_default_ipv4.address is defined
             with_items: groups['infra']
        +- hosts: infra
        +  tasks:
        +  - name: Install git
        +    sudo: True
        +    apt: name=git
        +  - name: Checkout the monitoring-bag git repo
        +    git: repo=https://github.com/ICGC-TCGA-PanCancer/monitoring-bag.git
        +         dest=/home/ubuntu/architecture2/monitoring-bag
        +         version=1.0-alpha.1
        +  - name: Generate SSL certificates
        +    shell: bash script.sh chdir=/home/ubuntu/architecture2/monitoring-bag/ssl creates=ssl_certs
        +  - name: Generate dummy bwa key (hardcoded in monitoring-bag)
        +    shell: touch /home/ubuntu/.ssh/gnostest.pem
        +

  3. Modify the crontab for the ubuntu user as required to specify the number of hosts that should be maintained
  4. Modify the crontab to disable the mock decider when you are satisfied with the operation of youxia
2. Hook up a decider from within the paired academic cloud.  
  1. For this step, ensure that the environment has access to Java 7. Download the jar files from artfiactory as documented in the youxia documentation and configure the generator component only.
3. Hook up the decider as required.
4. ???
