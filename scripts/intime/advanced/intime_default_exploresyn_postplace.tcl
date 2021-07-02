flow reset
flow set run_target private_cloud
flow set runs_per_round 12
flow set rounds 3
flow set concurrent_runs 12

# specify parent revision
flow set parent_revision_name "impl_1"
flow set parent_revision_job_id 0
flow set control_stop_when_goal_met true
flow set control_create_bitstreams false

# put synthesis settings in the whitelist
project setting_filters locklist clear
project setting_filters whitelist clear
project setting_filters blacklist clear
foreach my_setting [split [project setting_filters available_settings] "}{"] {
    if { [regexp -lineanchor -- {"name":"([^"]+)","step":"(SYNTH_DESIGN)"} "$my_setting" dummy setting_name setting_step] } {
        puts "INFO: Adding setting 'name=$setting_name' of 'step=$setting_step' into the Whitelist..."
        project setting_filters whitelist add $setting_name -step $setting_step
    }
}

# specify post-placement threshold
flow set control_stop_when_post_place_timing_bad true
flow set post_place_tns_limit -1000
flow set post_place_wns_limit -0.6
flow set post_place_whs_limit -1000

# run recipe
flow load_recipe "intime_default"
flow run_recipe "intime_default"
