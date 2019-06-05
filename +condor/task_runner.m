% This file will be run on each condor node.
% The python script which calls this script sets job_no and fun appropriately.

load(strcat("parameters_job_no_", num2str(job_no), ".mat"), ...
            'parameters');
result = fun(parameters{:});
save(strcat("result_job_no_", num2str(job_no), ".mat"), ...
            'result');
