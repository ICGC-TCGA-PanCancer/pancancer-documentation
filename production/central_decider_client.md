## The Central Decider Client

The Central Decider Client is a client component that communicates with a Central Decider application. It makes requests to the Central Decider and recieves responses that contain information about what samples should be run. You can read more about the Central Decider Client [here](https://github.com/ICGC-TCGA-PanCancer/central-decider-client/blob/develop/README.md#central-decider-client).

## Using INI files from the Central Decider Client
To use an INI file from the Central Decider Client on your worker node, follow these steps.

1. Make sure you are attached to your running pancancer_launcher container. If you not already attached, you can attach to a *running* container like this:

    ```docker attach pancancer_launcher```

2. Navigate to `~/architecture-setup/central-decider-client`.
3. Run the `generate_ini_files.pl` script to generate an INI file. The client will print to screen what files were generated. All generated ini files will be located in the ini folder. 
4. Use the INI file *(Adam: any tips on how to fill in this step? Solomon: I know the procedure for this without docker but we will have to develop a process with docker.)*
