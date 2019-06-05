#!/usr/bin/python
# This is the executable which is actually run on each condor node.
# it unzips all transfered tarballs, sets the job_no and fun variable
# for matlab and then runs the file task_runner.m in matlab.
# The matlab script then creates a result mat file and after completion 
# everthing is transferred back to the local machine.
import numpy as np
import subprocess
import sys

#parse the command line arguments
arg = sys.argv[1:]
for i in np.arange(len(arg)):
        if (arg[i] == '-i'):
            scriptname = arg[i+1]
            directoryname = arg[i+2]
            funname = arg[i+3]
            job_no = arg[i+4]

#extract all copied tarballs and move them to the new folder 'libraries' 
subprocess.call("""mkdir libraries""", shell=True) 
subprocess.call("""find -maxdepth 1 -name "*tar.gz" -exec tar --directory=libraries -xzf '{}' \;""", shell= True)

#start matlab without graphical user interface, add all folders and subfolders in current folder to path, run scriptname and then exit matlab so that this python script can continue and so that condor realizes at the end of this script
#that the job is done
string_cmd = """matlab -nosplash -nodesktop -noFigureWindows -r "addpath(genpath('.')); job_no={0}; fun=@{1};run('{2}');exit;" """.format(job_no, funname, scriptname)

#execute above command
subprocess.call(string_cmd, shell = True)