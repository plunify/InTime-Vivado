#----------------------------------------------------------------------
# Script      : intimeflow.tcl
# Description : Example on how to run the Hot Start recipe via Tcl
# Author      : Plunify
# Version     : 1.1
#               
# Return : None
#
# Usage :
#    1. Via the InTime Tcl console
#       % source <script.tcl>
#
#    2. Via the Command-line
#       % intime.sh -mode batch -platform minimal -s <script.tcl>
#----------------------------------------------------------------------

# Sample script for InTime Optimization
# Adjust the run_target, runs_per_round and round variables according to your recipe
flow reset
flow set run_target local
flow set runs_per_round 2
flow set rounds 1
flow set concurrent_runs 1
flow set control_create_bitstreams false
flow load_recipe "hot_start"
flow run_recipe "hot_start"
