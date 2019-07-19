# define target device
set part "xc7k70tfbg484-2"

# create project file
create_project -part $part eight_bit_uc

# add source files
add_files {
  alu.v
  data_mux.v
  ins_decode.v
  ins_rom.v
  io.v
  prgm_cntr.v
  reg_file.v
  spcl_regs.v
  eight_bit_uc.v
}
add_files eight_bit_uc.xdc

# launch runs
launch_runs [current_run]
wait_on_run [current_run]
