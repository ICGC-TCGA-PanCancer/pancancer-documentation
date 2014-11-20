## Youxia ##

Pancancer uses the youxia suite of software tools to deploy, monitor, and teardown clusters on (Amazon) AWS.
Please refer to [Youxia](https://github.com/CloudBindle/youxia) for generic documentation for Youxia.

After using the [setup Playbook](https://github.com/CloudBindle/youxia/tree/develop/youxia-setup), you will have configured an instance with a deployer, reaper, and example decider running on a crontab. Edit this with the specific settings desired for your cluster. 

In particular, you will probably want to swap out the generic playbook included with Youxia with the last release of the pancancer playbook found [here](https://github.com/ICGC-TCGA-PanCancer/monitoring-bag). You will want to check it out and then edit your crontab. 

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

### Ireland ####

Here, we will document any specific steps taken for the deployment for pancancer with Ireland as a case study.

0. Create an AMI image. For this step, we used [Bindle](https://github.com/CloudBindle/Bindle#persistance-of-ephemeral-disks---aws) deploying to an instance with a persistent EBS root filesystem. We used version 2.0-alpha.1 of Bindle paired with the 1.0-alpha.1 of [pancancer-bag](https://github.com/ICGC-TCGA-PanCancer/pancancer-bag). Note that some changes were required to seqware-bag subsequent to [1.0-alpha.2](https://github.com/SeqWare/seqware-bag/releases/tag/1.0-alpha.2) and are documented by the following commits.
  1. The Seqware Webservice was patched with a development build to address an issue with a missing GET interface
  2. This patch was subsequently released as SeqWare 1.1.0-alpha.5 which should be used for all future deployments with Youxia
1. While proceeding through the youxia docs 
  1. Configure an integration for a Slack channel. In our case, we created a channel called #youxia-flying-snow and an Incoming WebHook which is specified in the youxia config file.
  2. Deploy an instance on Amazon and use the youxia-setup playbook against it to deploy all youxia components. We deployed youxia 1.1.0-alpha.3 with a slightly patched reaper.
  3. Modify the crontab for the ubuntu user as required to specify the number of hosts that should be maintained
  4. Modify the crontab to disable the mock decider when you are satisfied with the operation of youxia
2. Hook up a decider from within the paired academic cloud.  
  1. For this step, ensure that the environment has access to Java 7. Download the jar files from artfiactory as documented in the youxia documentation and configure the generator component only.
3. Hook up the decider as required.
4. ???
