#!/usr/bin/python
# not tested (yet)!
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

import numpy as np
import sys
import os
import shutil

#dont forget the biftool files in your home directory and set the environmental variables in matlab
#dont use parallelized code. condor wont know how many cores your program will use, thereby slowing down all processes on the client when the number of jobs exceeds the number of cores
#this is just an example for continuating the allen-cahn equation with p2p
outputname = "matlab_test"

# task_runner.m reads a job specific parameter file and then 
# computes the solution to a subproblem specified by the information in the parameter file
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

no_jobs = 15; # number of jobs you want to create
# task_create_file is a matlab file which, assuming that the variable no_jobs is set in the matlab workspace,
# creates no_jobs files named parameter_job_1.mat to parameter_job_($no_jobs).mat
# each submitted job only has access to one of these parameter files
# the parameter file should specify which part of the problem should be solved
task_create_file = "create_tasks.m"

# this command runs matlab, sets the no_jobs variable in the matlab workspace to the no_jobs variable in python
# and then runs the task_create_file
string_cmd = """matlab -nosplash -nodesktop -noFigureWindows -r "no_jobs={0};run('{1}');exit;" """.format(no_jobs, task_create_file)
subprocess.call(string_cmd, shell = True) # creates the parameter files

for i in range(no_jobs): # for each job one condor submit file is generated
    current_output_name = outputname + "_job_no_" + str(i+1) 
    current_submitfilename = current_output_name + ".sub"

    # transfered files for the ith job are all .m files, tarball starting with "include" (previously defined in transfer_files)
    # and the file parameter_job_no_i+1.mat
    current_transfer_files = transfer_files + ", parameter_job_no_" + str(i+1) + ".mat"
    
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
    """.format(string_arg, current_outputname, current_transfer_files)
    #requirements  = ((Machine=="SELDON.uni-muenster.de") && (CPUs>=4))
    
    
    g=open(current_submitfilename,"w")
    g.write(current_submittext)
    g.close()

    # use subprocess.call to directly submit the condor job
    print("condor_submit "+current_submitfilename)

