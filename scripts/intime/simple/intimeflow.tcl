# Sample script for InTime Optimization. Works in Windows & Linux environments
# Adjust the run_target, runs_per_round and round variables according to your recipe
flow reset
flow set run_target local
flow set runs_per_round 2
flow set rounds 1
flow set concurrent_runs 1
flow set control_create_bitstreams false
flow run_recipe "hot_start"
