## Autorun_multi_recipes.tcl

This custom Tcl script automatically executes multiple InTime recipes in the order below. When each recipe completes, the script sets the revision with the best timing result as the parent revision for the next recipe.

## Requirement:
A project is required before running this script.
To get a sample XPR project, please see [here](../../../examples/project_mode)

## How to run:
### Run autorun_multi_recipes.tcl in InTime Tcl Console:
1. Launch InTime and open a project. 
2. Run the autorun_multi_recipes.tcl script at the Tcl Console by using following command:
source autorun_multi_recipes.tcl

### Run autorun_multi_recipes.tcl in Command Line:
1. Change current directory to a Vivado project directory.
2. Run following example command:

* For Linux:
```
<intime_installed_dir>/intime.sh -project <proj> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"
```

* For Windows:
```
<intime_installed_dir>\bin\intime.exe -project <prog> -mode batch -s autorun_multi_recipes.tcl -toolchain vivado 
-toolchain_version 2018.3.0 -tclargs "-output_dir <output_directory>"
```

## Explanation:
The autorun_multi_recipes.tcl example script is divided into five different parts:

- Variable declaration for important information like the recipes to use, TNS goal, number of runs per rounds, etc.
- InTime flow configuration and recipe execution.
- Results verification to either stop or execute subsequent recipes.
- Export strategies to Tcl scripts.
- Summarize and print results.


### A. Variable Declaration

First it describes what recipes to use and in what order of execution. In this example, for Vivado the order of execution is:
#### Hot Start -> InTime Default -> extra_opt_exploration

You can modify this sequence to use different recipes or to change the order of execution.

```Tcl
# Define order of recipes to execute. 
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

The below part shows how to define the goals for Total Negative Slack(TNS), Worst Negative Slack (WNS) for each recipe, number of runs per round, number of rounds. ```end_tns_goal``` contains the final TNS goal. Upon reaching the final TNS goal, there can be various follow-on actions, for example generate bitstream, copy files, and so on.
```tcl
# Define end goal
set end_tns_goal 0
set end_wns_goal "*" ; #Don't Care
```

The ```recipe_target_result_tns``` defines a recipe goal that tells InTime to switch to a subsequent recipe if it meets this TNS target. Typically, the earlier goals are set at a worse level compared to the later goals.
```tcl
# Define tns goal for each recipe run
set recipe_target_result_tns(hot_start) "-2500"
set recipe_target_result_tns(intime_default) "-1000"
set recipe_target_result_tns(deep_dive) "-500"
set recipe_target_result_tns(auto_placement) "0"
set recipe_target_result_tns(seeded_effort_level_exploration) "0"
set recipe_target_result_tns(vivado_explorer) "0"
set recipe_target_result_tns(extra_opt_exploration) "0"


# Define runs_per_round for each recipe run
set recipe_target_runs_p_round(hot_start) 50
set recipe_target_runs_p_round(intime_default) 10
set recipe_target_runs_p_round(deep_dive) 10
set recipe_target_runs_p_round(seeded_effort_level_exploration) 10
set recipe_target_runs_p_round(auto_placement) 10
set recipe_target_runs_p_round(vivado_explorer) 10
set recipe_target_runs_p_round(extra_opt_exploration) 10
```
### B. InTime flow configuration and recipe execution.

The InTime flow configuration and recipe execution are outlined below. 

```tcl
# Configure InTime Flow settings 
# -> Type 'flow properties' in Tcl console to shows all the available flow property to configure
flow reset                 ; # Reset Intime internal flow 
flow restore_defaults      ; # Restore all flow property to default value
flow set run_target local  ; # Set to run strategies on local machine
flow set goal speed_tns    ; # Set goal type as speed_tns for timing optimization
flow set concurrent_runs 3 ; # Number of builds to run in parallel
flow set control_stop_when_goal_met true ; # Stop current recipe run when goal is met
flow set control_create_bitstreams false ; # Set to false to save compute time
```

- ```flow reset``` is used to reset the internal flow history. It is a recommended practice to always reset the internal flow history before running any recipe.
- ```flow set <property> <value>``` is the command to configure InTime flow settings. For example, ```setting flow set control_stop_when_goal```_met to true enables InTime to stop the current recipe when the goal is met. Otherwise, InTime allows the recipe to continue running even after the goal is met.
- Setting ```flow set control_create_bitstreams``` to true enables bitstream files to be created for every revision. Note: This takes up more time to complete each strategy.

To start a recipe, use the command ```flow run_recipe <recipe_name>``` as shown below. If the recipe run completes, the ```flow run_recipe``` command returns 0, otherwise it returns 1.

```tcl
# Run the current recipe
if { [catch { flow run_recipe $current_recipe }] } {
    puts "ERROR: Recipe $current_recipe failed, continuing with the rest of the flow... ${::errorInfo}"
    set recipe_run_fail 1
    set return_code 1
}        
```

### C. Results verification

In this section, the script checks if any revision in this round meets the target goal. If yes, it stops, otherwise it continues to execute the subsequent recipes until all user-defined recipes are executed.

```tcl
 # Check if the goal was met. Stop this script if the goal is met
set job_id [flow get local_job_id]
if { $flow_continue && !$recipe_run_fail } {
    puts "INFO: Checking results in $current_recipe recipe run \(job $job_id \) "
    results clear
    results add job $job_id
    set best_revision_name [lindex [results summary best -list] 0]
    catch { strategy unset_active }
    catch { strategy set_active $best_revision_name $job_id }
    set best_revision_tns    [ strategy results -field "TNS" ]
    set best_revision_wslack [ strategy results -field "Worst Slack" ]
    puts "INFO: -> Best result in job \($job_id\) is $best_revision_name revision with TNS = $best_revision_tns and Worst Slack = $best_revision_wslack "
    if { [is_job_met_criteria $job_id "" 0 "speed_tns" $end_tns_goal] } {
        puts "INFO: -> Goal met! .. exiting optimization"
        set flow_continue 0
        set goal_met 1
    }
}
```

### D. Export Strategies into Tcl Scripts
This section shows how to export strategy settings for each strategy into a Tcl script. 

```tcl
# Export strategies to Tcl for successful revisions
results clear 
catch { strategy unset_active }
set count 0
foreach id $jobs_ran {
    results add job $id
    set stratname_list_success [results summary success -list]
    set best_revname_per_job [lindex [results summary best -list] 0]
    foreach stratname $stratname_list_success {
        strategy set_active $stratname $id
        strategy export "$export_settings_tcl_dir/job${id}_${stratname}.tcl" -script_tcl
        catch { strategy unset_active }
    }
}
```

The command ```strategy export <export_tcl_name> -script_tcl``` is used to export settings for the current strategy into a Tcl script file. In this example, the script only exports strategies that compiled successfully. It uses the command ```results summary success -list``` to obtain a list of such strategies. You must always set the “active strategy” using the command ```strategy set_active <strategy_name> <job_id>``` before running the ```strategy export <export_tcl_name> -script_tcl``` command.

### E. Results Summary
When the recipe runs are done, the results will be inside the output directory. 

Under the output directory, you should see pass or fail file. If the end goal is met, you should able to see pass file in the output directory. Otherwise, you should see a fail file instead. 

The ```best_<job_id>_<strategy_name>.tcl``` script is an  Tcl script which reproduces the best timing result among the generated strategies. Meanwhile, the folder export_strategies_tcl contains the exported strategy Tcl scripts of all the other strategies that are compiled successfully. (Note that the output directory is cleaned up whenever this example script is executed. Please back up this folder if necessary.)

```tcl
# Export best strategy in tcl 
catch { strategy unset_active }
set best_job [ lindex $best_revname_n_job 0]
set best_revname [ lindex $best_revname_n_job 1]
strategy set_active $best_revname $best_job
strategy export "$result_dir/best_job${best_job}_${best_revname}.tcl" -script_tcl
catch { strategy unset_active }
```
This section will print a summary of the results you selected. To select all the relevant results using their job IDs: ```results add job <job_id>``` , then return  revisions that compiled successfully via ```results summary success``` command.

```tcl
# Export summary of results in summary_result.rpt
foreach id $jobs_ran {
    results add job $id
}

set summary_result [results summary success]
if { [catch { open $summary_result_rpt w } fh] } {
    puts "ERROR: Couldn't open file: $fh"
    set return_code 1
} else {
    puts $fh "$summary_result"
    catch { close $fh }
}
results clear
```
