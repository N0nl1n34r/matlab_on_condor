#!/usr/bin/python
#not tested (yet)!
import numpy as np
import sys
import os
import shutil

#dont forget the biftool files in your home directory and set the environmental variables in matlab
#dont use parallelized code. condor wont know how many cores your program will use, thereby slowing down all processes on the client when the number of jobs exceeds the number of cores
#this is just an example for continuating the allen-cahn equation with p2p
outputname = "matlab_test"
submitfilename = outputname + ".sub"

scriptname = "task_runner.m"
#above matlab script creates a directory in which it saves the solution files 
#since condor only transfers files back to the host and not directories we need to specify the directory name so that
#the execute_matlab_script knows which directory to compress so that it can be transfered back as a file
directoryname = outputname
#list of dependencies of the specific example script. This will be different for each problem

#transfer all files, which end with ".m"
filenames = [f for f in os.listdir(".") if f.endswith('.m')]
#tranfer all tarballs, which start with "include"
filenames += [f for f in os.listdir(".") if f.endswith('.tar.gz') and f.startswith('include')]
transfer_files= ", ".join(filenames)

#arguments to pass to the executable
string_arg = "-i " + scriptname + " " + directoryname


#executable is transferred by default
submittext = """universe      = vanilla
Executable    = execute_matlab_script.py
arguments     = {0}
Log           = {1}.log
error         = {1}.err
output        = {1}.txt
requirements  = ((Machine!="MAXWELL.uni-muenster.de") && (Machine!="THOMSON.uni-muenster.de"))
notification  = Never
getenv        = true
rank          = kflops
transfer_input_files    = {2}
should_transfer_files   = YES
when_to_transfer_output = ON_EXIT_OR_EVICT
Queue
""".format(string_arg, outputname, transfer_files)
#requirements  = ((Machine=="SELDON.uni-muenster.de") && (CPUs>=4))
g=open(submitfilename,"w")
g.write(submittext)
g.close()

print("condor_submit "+submitfilename)

