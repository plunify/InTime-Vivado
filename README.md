![alt text](images/Plunify_Logo_300.png)

# Run InTime in Tcl Mode (Vivado)
This repository contains scripts to run InTime in the Tcl Console or on the command-line. There are 3 ways to run InTime from a Tcl script.
1. From a command line shell
2. From the Tcl Console in InTime GUI 
3. From the Vivado Tcl Console

## Main Contents
1. [sample-designs](sample-designs/) : Quickstart designs for the various flows described here.
2. [scripts](scripts/) : Sample scripts to run InTime from each of these clients - command line, InTime GUI or Vivado Tcl console. 

## Run InTime in Project versus Non-project Mode
Using a command line shell, a typical way to start InTime is as such below

```intime.sh -mode batch -project <proj> -s intimeflow.tcl```

* For project-mode, use a XPR file for the ```<proj>``` option.
* For non-project mode-, use the a tcl build script for the ```<proj>``` option.

*Sample XPR project or build script are available under the sample-designs folder.

For InTime version 2.6.10 and older, a post-synthesis **DCP** file is required for non-project mode. 

## GUI
To learn more of the InTime GUI, refer to this [video](https://www.youtube.com/watch?v=lQvY_XZ3R7w).

## Requirements
1. Latest version of InTime.
2. Vivado with an appropriate license properly registered in InTime. If you have not done so, please refer to this [page](scripts/intime/configuration)

For more information about InTime, go to [here](https://www.plunify.com/en/intime/)
