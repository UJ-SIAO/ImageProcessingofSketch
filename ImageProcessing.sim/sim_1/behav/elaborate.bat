@echo off
set xv_path=D:\\Xilinx\\Vivado\\2016.1\\bin
call %xv_path%/xelab  -wto 11c0f9077c8d48b29af9ee84f4115304 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L xpm -L fifo_generator_v13_1_0 -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_behav xil_defaultlib.tb xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
