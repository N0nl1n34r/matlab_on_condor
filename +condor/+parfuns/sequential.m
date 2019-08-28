function parfun = sequential(varargin)
% CONDOR.PARFUNS.SEQUENTIAL(parfun_1, no_jobs_1, ...parfun_n, no_jobs_n) 
% returns a parameter function which combines the parameterfunctions 
% parfun_1 to parfun_n in sequential order, where the value of parfun_i is
% returned for no_jobs_i jobs.
%
% INPUT list of parfuns: The parameter functions which are to be combined
%                        sequentially
%       list of no_jobs: The number of jobs the parameter function should 
%                        be used before taking the next one.
%
% OUTPUT parfun: Sequentially combined parameter function.
%
% EXAMPLES 
%      parfun1 = @(job_no) {job_no};
%      parfun2 = @(job_no) {2*job_no};
%      sequential_parfun = condor.parfuns.sequential(parfun1, 3, ...
%                                                    parfun2, 5);
%      arrayfun(sequential_parfun, 1:5)
%      % ... should return {1, 2, 3, 2, 4}
%      % i. e. the first three values are from the first parameter function
%      % and the last two are from the second parameter function
%      % notice that job_no starts to count from 1 again.
% 
% REMARKS The job_no counter starts to count from 1 again for each new
%         parameter function.
%
% See also CONDOR.PARFUNS.COMBINED
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
%
    parfuns = varargin(1:2:length(varargin));
    job_nos = [varargin{2:2:length(varargin)}];
    cum_job_nos = cumsum(job_nos);
    function parameters = sequential_parfun(job_no)
        fun_index = find(job_no <= cum_job_nos, 1);
        if fun_index > 1
            job_no = job_no - cum_job_nos(fun_index-1);
        end
        parameters = parfuns{fun_index}(job_no);
    end
    parfun = @sequential_parfun;
end