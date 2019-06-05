#!/usr/bin/python
# this file is supposed to create multiple condor submit files
# for embarrassingly parallel problems (https://en.wikipedia.org/wiki/Embarrassingly_parallel)
# the idea is that
# 1) a matlab task_create_file splits the whole problem into smaller chunks 
#    by creating specific parameter files for each job
# 2) this python script creates a condor submit file for each job. For each job only
#    the job specific parameter file is transfered, while all other parameter files are not
# 3) the matlab script which is run on condor reads the job specific parameter file and thereby
#    knows which subproblems should be solved, and solves them.
# 4) Once all jobs are done and if necessary, the solutions for the subproblems are used
#    to solve the whole problem.
# Specific examples I had in mind were: 
#   - parameter sweeps: each job continues a stst solution for different starting parameters
#     each parameter file contains a list of starting parameters for which steady states should be continued
#   - split a branch in no_job parts, each job calculates the stability of one of the branch parts
#     each parameter file contains a branch variable with only the points of which the stability should be computed
#   - etc.
# Side note: this could have easily been done within matlab, but since matlab
# is such a nice fucking language it doesn't support multiline strings.
import numpy as np
import sys
import os
import shutil
import subprocess

outputname = "condor_execute"
scriptname = "task_runner.m"

#above matlab script creates a directory in which it saves the solution files 
#since condor only transfers files back to the host and not directories we need to specify the directory name so that
#the execute_matlab_script knows which directory to compress so that it can be transfered back as a file
directoryname = outputname
#list of dependencies of the specific example script. This will be different for each problem

#transfer all files, which end with ".m"
filenames = [scriptname] #[f for f in os.listdir(".") if f.endswith('.m')]
#tranfer all tarballs, which start with "include"
filenames += [f for f in os.listdir(".") if f.endswith('.tar.gz') and f.startswith('include')]
transfer_files= ", ".join(filenames)

#arguments to pass to the executable
func_name = sys.argv[2]
string_arg = "-i " + scriptname + " " + directoryname + " " + func_name

no_jobs = int(sys.argv[1])#175; # number of jobs you want to create

for i in range(no_jobs): # for each job one condor submit file is generated
    current_outputname = outputname + "_job_no_" + str(i+1) 
    current_submitfilename = current_outputname + ".sub"

    # transfered files for the ith job are all .m files, tarball starting with "include" (previously defined in transfer_files)
    # and the file parameter_job_no_i+1.mat
    current_transfer_files = transfer_files + ", parameters_job_no_" + str(i+1) + ".mat"
    
    current_string_arg = string_arg + " " + str(i + 1)
    #executable is transferred by default
    current_submittext = """universe      = vanilla
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
    """.format(current_string_arg, current_outputname, current_transfer_files)
    #requirements  = ((Machine=="SELDON.uni-muenster.de") && (CPUs>=4))
    
    
    g=open(current_submitfilename,"w")
    g.write(current_submittext)
    g.close()

    # use subprocess.call to directly submit the condor job
    subprocess.call("condor_submit "+current_submitfilename, shell=True)