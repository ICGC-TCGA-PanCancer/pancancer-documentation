# Switching to the new decider
The current decider that is being used, can be found [here](https://github.com/SeqWare/public-workflows/tree/brian_experiment_with_old_decider/decider-bwa-pancancer). This is an older version of the decider that has been modified slightly. An example of running the  old decider would be:

    perl workflow_decider.pl --gnos-url https://gtrepo-bsc.annailabs.com --report gtrepo-bsc.log --ignore-lane-count --upload-results --test --working-dir gtrepo-bsc --skip-cached
  
Here you have to make sure the url is correct and you make all logs and working dirs in the following format:
  
    gtrepo-(REPO NAME)

This is necessary for the scripts that read in the log file. The new decider has different flags so yuo must see which ones will work with the newer version. To do the same command with the new decider would look something like this:

    perl bin/workflow_decider.pl --seqware-clusters conf/cluster.json --workflow-version 2.6.0 --workflow-skip-scheduling --gnos-url https://gtrepo-bsc.annailabs.com --working-dir gtrepo-bsc --report gtrepo-bsc.log --use-cached-analysis
  
As you can see it looks quite different. The only thing that matters is that you get the same output as the old decider. 
