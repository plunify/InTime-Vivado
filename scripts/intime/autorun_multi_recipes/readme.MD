## Understanding autorun_multi_recipes.tcl

This custom Tcl script automatically executes multiple InTime recipes in the order below. When each recipe completes, the script sets the revision with the best timing result as the parent revision for the next recipe.

## Requirement:
A XPR project is required before running autorun_multi_recipes.tcl.
To get a sample of XPR project, please see [here](../../../examples/project_mode)

## How to run
### Run autorun_multi_recipes.tcl in InTime Tcl Console:
1. Launch InTime and open a Vivado XPR project. 
2. Run the autorun_multi_recipes.tcl script at the Tcl Console by using following command:
source autorun_multi_recipes.tcl

### Run autorun_multi_recipes.tcl in Command Line:
1. Change current directory to a Vivado XPR project directory.
2. Run following example command:

#### For Linux:
<intime_installed_dir>/intime.sh -project <proj> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"

#### For Windows:
<intime_installed_dir>\bin\intime.exe -project <prog> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"

## Explanation
The autorun_multi_recipes.tcl example script is divided into five different parts:

A. Variable declaration for important information like the recipes to use, TNS goal, number of runs per rounds, etc.
B. InTime flow configuration and recipe execution.
C. Results verification to either stop or execute subsequent recipes.
D. Export strategies to Tcl scripts.
E. Summarize and print results.

### A. Variable Declaration
```# Define order of recipes to execute. 
# -> Type 'flow recipes -supported' in Tcl console to show all available recipe's name
set current_toolchain [project info toolchain]
if { [string equal "$current_toolchain" "quartusii"] } {
    # Execution Order : hot_start > intime_default > deep_dive > seeded_effort_level_exploration
    set recipes_list [list "hot_start" "intime_default" "deep_dive" "seeded_effort_level_exploration" ]

} elseif { [string equal "$current_toolchain" "vivado"] } {
    set recipes_list [list "hot_start" "intime_default" "extra_opt_exploration"]

} else {
    set recipes_list [list "intime_default"]

}
```


### Results:
After the script run is completed, user can find the results inside the output directory.
Under the output directory, you should see pass or fail file. If the end goal is met, you should able to see pass file in the output directory. Otherwise, you should see a fail file instead. 

The best_<job_id>_<strategy_name>.tcl script is an exported strategy Tcl script which reproduces the best timing result among the generated strategies. Meanwhile, the folder export_strategies_tcl contains the exported strategy Tcl scripts of all the other strategies that are compiled successfully. Note that the output directory is cleaned up whenever this example script is executed. Please back up this folder if necessary.
