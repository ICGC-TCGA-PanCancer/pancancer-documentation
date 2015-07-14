## Managing an existing Pancancer environment
<!-- TODO: Update/rewrite this to use Youxia instead of Bindle -->
### Launching a node

Worker nodes can be launched using [Youxia](https://github.com/CloudBindle/youxia) [Deployer](https://github.com/CloudBindle/youxia#deployer).

To launch a single node, you can use Youxia like this:

    cd ~/arch3
    java -cp pancancer.jar io.cloudbindle.youxia.deployer.Deployer  --ansible-playbook ~/architecture-setup/container-host-bag/install.yml --max-spot-price 1 --batch-size 1 --total-nodes-num 1 -e ~/params.json

The above command assumes you are running in an Architecture3 pancancer\_launcher docker container. If you are not, you may need to adjust:
 - The path to the jar file that contains the Youxia Deployer
 - The path to the ansible playbook
 - The path to the Youxia parameters file.

You may want to read the section on [Youxia configuration](https://github.com/CloudBindle/youxia#configuration) for details about how to write `params.json` and `~/.youxia/config`.

### Troubleshooting a node launch

Typically, most Youxia launches fail due to configuration errors, so make sure they are correct! You can check the `arch3.log` file, if you are in a pancancer\_launcher container for any details that the Deployer may have written. You can also check the console, in case Youxia wrote useful messages directly to the console (such as when you are not in pancancer\_launcher).

In AWS, a launch could fail if the spot price goes up while the ansible playbook is still setting up the node.

In OpenStack, a launch could fail if the requested resources simply aren't available in the OpenStack environment that you are using.

Sometimes a worker node will fail to launch if it does not have enough disk space to run the setup playbook (here, it is the container-host-bag playbook, but you could specify something else), so be sure that the AMI/OpenStack Image you choose will be able to handle what you are installing.

### Connecting to a worker node

If you need to log in to a worker to trouble shoot it, you should be able to do so with SSH. To do this, find the worker node in question and then connect to it using SSH.

In OpenStack, you may have to connect to it from a machine that is in the same network as the worker node, since worker nodes often only have private IP addresses and probably cannot be accessed directly from your workstation.

In AWS, you would want to ensure that the security group to which your worker node belongs will allow SSH access to whatever IP address you are trying to connect from - you *could* connect to a worker directly from your workstation, if you configure the security groups properly.

### Terminating a node

Terminating a node can be done with the Youxia [Reaper](https://github.com/CloudBindle/youxia#reaper).

A command that can reap all nodes that have more than 5 workflows would look like this:

    cd ~/arch3
    java -cp pancancer.jar io.cloudbindle.youxia.reaper.Reaper --kill-limit 0

Again, this assumes that you are using Youxia inside pancancer\_launcher. If not, you will need to adjust the path to the jar file appropriately.

Youxia Reaper also allows you to specify kill-lists of specific hosts:

    java -cp pancancer.jar io.cloudbindle.youxia.reaper.Reaper \
         --kill-list kill-targets.json --kill-limit 0 --OpenStack

with kill-tagets.json:

    ["192.168.0.1","192.168.0.2"]

This comman will kill all OpenStack hosts in that file, even if they have not yet run *any* workflows.
