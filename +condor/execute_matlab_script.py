#!/usr/bin/python
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

#extract all copied tarballs            
subprocess.call("""find -maxdepth 1 -name "*tar.gz" -exec tar xzf '{}' \;""", shell= True)

#start matlab without graphical user interface, add all folders and subfolders in current folder to path, run scriptname and then exit matlab so that this python script can continue and so that condor realizes at the end of this script
#that the job is done
string_cmd = """matlab -nosplash -nodesktop -noFigureWindows -r "addpath(genpath('.')); job_no={0}; fun=@{1};run('{2}');exit;" """.format(job_no, funname, scriptname)
print string_cmd

#execute above command
subprocess.call(string_cmd, shell = True)
#compress the directory containing the solution files into a tarball/.tar.gz in order to allow condor to transfer it back to host machine
#subprocess.call("tar -zcf {0:}_job_no_{1}.tar.gz *.mat".format(directoryname,job_no), shell = True)
#subprocess.call("rm *.mat")

#extract with tar xvf temp.gar.gz
