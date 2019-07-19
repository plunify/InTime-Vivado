To create a XPR project:

1. Download all files (.v, .xdc and .tcl) inside this directory to a local directory.

2. By default, the target device is "xc7k70tfbg484-2". If user wish to target other device, please change following parameter inside the create_project.tcl:
```Tcl
# define target device
set part "xc7k70tfbg484-2"
...
```

3. Run following command to execute the create_project.tcl in the local directory:
<vivado_installation>/bin/vivado -mode batch -s create_project.tcl
Please take note the project will be created by the same Vivado version of <vivado_installation>/bin/vivado.

4. After the script is completed, a XPR project named "eight_bit_uc" will be created in local directory.
To open the project in GUI mode, run following command:
<vivado_installation>/bin/vivado -mode gui -project ./eight_bit_uc.xpr
