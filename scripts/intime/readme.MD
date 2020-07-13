# InTime Scripts

## Contents

1. [simple/intimeflow.tcl](simple/intimeflow.tcl) is a quick start script showing how to run InTime using Tcl instead of the GUI.

2. [autorun_multi_recipes/autorun_multi_recipes.tcl](autorun_multi_recipes/autorun_multi_recipes.tcl) is an advanced InTime script that runs multiple recipes with different stop conditions. 

3. The [configuration](configuration/) folder contains sample scripts to set up and configure your InTime environment. Be sure to run them to initialize Vivado before using InTime.

4. [advanced/intime_default_exploresyn_postplace.tcl](advanced/intime_default_exploresyn_postplace.tcl) showcases a script that explores only synthesis settings and stops when post-placement timing is poor. This reduces turnaround time.

A detailed version of the Tcl reference for InTime can be found [here](https://support.plunify.com/en/doc/intime-doc/tcl-command-reference/).
Additional description of the Flow Properties can be found [here](https://docs.plunify.com/intime/flow_properties.html).
