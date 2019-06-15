function cleanup()
% CONDOR.CLEANUP() removes all files created by CONDOR.EXECUTE and removes
% all condor jobs from the queue.
%
% INPUT none
%
% OUTPUT none
%
% EXAMPLES condor.cleanup % everything's so tidy now! 
%         
% REMARKS This function depends on the option 'username' to remove the jobs
%         from the condor queue. 
%
% See also CONDOR.EXECUTE
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    mdir = ['''' fileparts(mfilename('fullpath')), '/' ''''];
    [~,~] = system(['rm ' mdir '*_job_no_*.err']);
    [~,~] = system(['rm ' mdir '*_job_no_*.txt']);
    [~,~] = system(['rm ' mdir '*_job_no_*.log']);
    [~,~] = system(['rm ' mdir 'condor_execute.sub']);
    [~,~] = system(['rm ' mdir 'parameters_job_no_*.mat']);
    [~,~] = system(['rm ' mdir 'result_job_no_*.mat']);  
    [~,~] = system(['rm ' mdir 'include_dependencies.tar']); 
    [~,~] = system(['rm ' mdir 'include_dependencies.tar.gz']); 
    [~,~] = system(['condor_rm ' condor.options('username')]);
end
