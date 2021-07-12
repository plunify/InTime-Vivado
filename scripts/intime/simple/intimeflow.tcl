#----------------------------------------------------------------------
# Script      : autorun_multi_recipes.tcl
# Description : auto run multiple InTime Recipes in a user-defined order
# Author      : Plunify
# Version     : 1.1
#               
# Return : None
#
# Usage :
#    1. Via Intime Tcl console
#       % source <script.tcl>
#
#    2. Via Command-line
#       % intime.sh -mode batch -platform minimal -s <script.tcl>
#----------------------------------------------------------------------

# Sample script for InTime Optimization. Works in Windows & Linux environments
# Adjust the run_target, runs_per_round and round variables according to your recipe
flow reset
flow set run_target local
flow set runs_per_round 2
flow set rounds 1
flow set concurrent_runs 1
flow set control_create_bitstreams false
flow load_recipe "hot_start"
flow run_recipe "hot_start"
