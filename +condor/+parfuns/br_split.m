function fun = br_split(br)
% CONDOR.PARFUNS.BR_SPLIT(br) returns a parameter function, which splits a 
% biftool branch into condor.options('no_nodes') evenly parts by splitting 
% the array of points.
%
% INPUT br: The br which shall be split into options('no_nodes') parts.
%
% OUTPUT parfun: parameter function which takes the job number as input and
%                returns the according part of the branch in a cell as 
%                output.
%
% EXAMPLES 
%     condor.options('set', 'no_nodes', 2);
%     parfun = condor.parfuns.br_split(1:10);
%     parameter_job_no_1 = parfun(1);
%     parameter_job_no_1{:}
%     ... should return 1:5
%
% REMARKS This functions depends on the global option 'no_nodes'.
%         This functions can for example be used to compute the stability
%         of a branch in a distributed way
%
% See also CONDOR.OPTIONS, CONDOR.TASKS.GET_STABILITY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
    no_jobs = condor.options('no_nodes');
	brs = condor.helper.br_split(br, no_jobs);
    function parm = parfun(job_no)
        parm = {brs{job_no}};
    end
	fun = @parfun;
end
