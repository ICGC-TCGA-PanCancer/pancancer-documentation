## Site-specific tips and tricks
This page contains tips, tricks, and information about running the pancancer tools in specific environments.

### DKFZ  <br>

Some of the German cloud images don't have natting rules in place to allow communication between machines and the<br>
cloud controller.  To acheive this a couple of custom nat rules need to be added to IPTABLES.<br><br>

This further complicates the use of docker by requiring us to use the host NIC INSIDE the docker container to avoid<br>
problems created by a natting hairpin.<br>
Use the: `--net="host"` option when launching docker to achieve this.<br>
We are currently testing a solution to bake this workaround into later versions of the launcher.<br><br>
