## The Central Decider Client

The Central Decider Client is a client component that communicates with a Central Decider application. It makes requests to the Central Decider and recieves responses that is uses to generate INI files that should be scheduled to be run. 

## Generating INI files with the Central Decider Client
To use an INI file from the Central Decider Client on your worker node, follow these steps.

1. Make sure you are attached to your running pancancer_launcher container. If you not already attached, you can attach to a *running* container like this:

    ```docker attach pancancer_launcher```

2. Navigate to `~/architecture-setup/central-decider-client`.
3. Generate the INI's by running the client as descibed in the [central decider client documentation](https://github.com/ICGC-TCGA-PanCancer/central-decider-client/blob/develop/README.md#central-decider-client) . 

* Email Christina Yung cyung@oicr.on.ca and Adam Wright awright@oicr.on.ca for the central decider password

Example: 
```
perl generate_ini_files.pl --workflow-name=Workflow_Bundle_BWA --gnos-repo=https://gtrepo-etri.annailabs.com/ \
  --cloud-env=etri --template-file=templates/bwa_template.ini --vm-location-code=etri \
  --password=<central-decider-password>
  
```
The client will print to screen the files that were just generated. All generated ini files will be located in the ini folder.

Example output: 

    Generating: ini/CPCG_0203-PRAD-CA-CPCG_0203_Ly_R-normal.ini
    Generating: ini/CPCG_0203-PRAD-CA-CPCG_0203_Pr_P-tumour.ini
    Generating: ini/CPCG_0185-PRAD-CA-CPCG_0185_Ly_R-normal.ini

## Scheduling INI files
To execute a workflow using the INI files that you generated, you will need to move them to your worker node, and then run the workflow.

1. Copy INI files onto worker nodes that you would like them to run on using scp:

    `scp -i <pem-key> <ini-filepath> <user>@<worker hostname or IP address>:/tmp`

   Example:

    `scp -i ~/.ssh/MyKey.pem ini/New-Generated-INI-file.ini ubuntu@worker-node-ip-address.amazonaws.com:/tmp/New-Generated-INI-file.ini`
2. Run a workflow using the INI file.
    - Log into worker node.
    - Execute the command:

```
docker run --rm -h master -t -v /var/run/docker.sock:/var/run/docker.sock \
  -v /datastore:/datastore \
  -v /home/ubuntu/.ssh/gnos.pem:/home/ubuntu/.ssh/gnos.pem \
  -v <ini-filepath>:/workflow.ini \
  -v /workflows/:/workflows \
  -i pancancer/seqware_whitestar_pancancer:1.1.1 \
  bash -c 'seqware bundle launch --host master --ini /workflow.ini --dir /workflows/Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5 --no-metadata --engine whitestar'
```
The above command will run the docker image "pancancer/seqware_whitestar_pancancer" in a new container. The container will have access to `/workflows`, `/datastore`, your generated INI file (`<ini-filepath>`, which is the path you copy your INI file to in the previous step, such as : `/tmp/New-Generated-INI-file.ini`), and your gnos pem key. The command that docker executes once the container starts is 

    seqware bundle launch --host master --ini /workflow.ini --dir /workflows/Workflow_Bundle_BWA_2.6.1_SeqWare_1.1.0-alpha.5 --no-metadata --engine whitestar

This command illustrates executing the BWA workflow with a generated INI file. 
