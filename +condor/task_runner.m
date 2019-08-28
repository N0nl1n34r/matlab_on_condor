% This file will be run on each condor node.
% The python script which calls this script sets job_no and fun appropriately.
load(strcat("parameters_job_no_", num2str(job_no), ".mat"), ...
            'parameters');

% make sure that condor.execute does not get stuck as it waits for the 
% result_job_no_<i>.mat file (without this try catch block, in case of an
% error the result file would never be created as code execution is
% aborted.)
try 
    result = fun(parameters{:});
    suc = true;
    errmsg = '';
catch error
    result = [];
    suc = false;
    errmsg = error.message;
end

save(strcat("result_job_no_", num2str(job_no), ".mat"), ...
            'result', 'suc', 'errmsg');
