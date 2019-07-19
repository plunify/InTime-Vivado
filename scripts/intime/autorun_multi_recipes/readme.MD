## Understanding autorun_multi_recipes.tcl

This custom Tcl script automatically executes multiple InTime recipes in the order below. When each recipe completes, the script sets the revision with the best timing result as the parent
revision for the next recipe.

Requirement:
A XPR project is required before running autorun_multi_recipes.tcl.
To get a sample of XPR project, please see [here](examples/project_mode)

Steps to run autorun_multi_recipes.tcl in InTime Tcl Console:
1. Launch InTime and open a Vivado XPR project. 
2. Run the autorun_multi_recipes.tcl script at the Tcl Console by using following command:
source autorun_multi_recipes.tcl

Steps to run autorun_multi_recipes.tcl in Command Line:
1. Change current directory to a Vivado XPR project directory.
2. Run following example command:
For Linux:
<intime_installed_dir>/intime.sh -project <XPR_file> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"

For Windows:
<intime_installed_dir>\bin\intime.exe -project <XPR_file> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"

After the script run is completed, user can find the results inside the output directory.
Under the output directory, you should see pass or fail file. If the end goal is met, you should able to see pass file in the output directory. Otherwise, you should see a fail file instead. The best_<job_id>_<strategy_name>.tcl script is an exported strategy Tcl script which reproduces the best timing result among the generated strategies. Meanwhile, the folder export_strategies_tcl contains the exported strategy Tcl scripts of all the other strategies that are compiled successfully. Note that the output directory is cleaned up whenever this example script is executed. Please back up this folder if necessary.
