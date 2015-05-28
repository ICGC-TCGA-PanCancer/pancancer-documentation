## The Central Decider Client

The Central Decider Client is a client component that communicates with a Central Decider application. It makes requests to the Central Decider and recieves responses that is uses to generate INI files that should be scheduled to be run. 

You can read more about the Central Decider Client [here](https://github.com/ICGC-TCGA-PanCancer/central-decider-client/blob/develop/README.md#central-decider-client).

## Generating INI files with the Central Decider Client
To use an INI file from the Central Decider Client on your worker node, follow these steps.

1. Make sure you are attached to your running pancancer_launcher container. If you not already attached, you can attach to a *running* container like this:

    ```docker attach pancancer_launcher```

2. Navigate to `~/architecture-setup/central-decider-client`.
3. Run the `generate_ini_files.pl` script to generate an INI file. The client will print to screen the files that were just generated. All generated ini files will be located in the ini folder. 
4. 

## Scheduling INI files
1. Copy INI files onto worker nodes that you would like them to run on 
    - scp -i <pem-key> <ini-filepath>  <seqware-hostname>:/tmp

2. Schedule ini file on worker node
    -  log into worker node
    - Execute the command:

```
       docker run --rm -h master -t -v /var/run/docker.sock:/var/run/docker.sock \
        -v /datastore:/datastore \
        -v /home/ubuntu/.ssh/gnos.pem:/home/ubuntu/.ssh/gnos.pem \
        -v `pwd`/workflow.ini:/workflow.ini \
        -v /workflows/:/workflows \
        -i pancancer/seqware_whitestar_pancancer:1.1.1 \
        bash -c 'seqware bundle launch --host master --ini /workflow.ini --dir /workflows/Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5 --no-metadata --engine whitestar'
```
