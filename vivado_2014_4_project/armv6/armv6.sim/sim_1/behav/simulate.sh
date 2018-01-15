#!/bin/sh -f
xv_path="/opt/Xilinx/Vivado/2014.4"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim armv6_TB_behav -key {Behavioral:sim_1:Functional:armv6_TB} -tclbatch armv6_TB.tcl -log simulate.log
