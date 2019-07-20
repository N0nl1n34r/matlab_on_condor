function fun = arr_split(array, no_splits)
% CONDOR.PARFUNS.ARR_SPLIT(array) returns a parameter function, which 
% splits array into condor.options('no_nodes') evenly parts
%
% INPUT array: The array which shall be split into options('no_nodes')
%              parts
%
% OUTPUT parfun: parameter function which takes the job number as input and
%                returns the according part of the array in a cell as 
%                output.
%
% EXAMPLES 
%     condor.options('set', 'no_nodes', 2);
%     parfun = condor.parfuns.arr_split(1:10);
%     parameter_job_no_1 = parfun(1);
%     parameter_job_no_1{:}
%     ... should return 1:5
%
% REMARKS This functions depends on the global option 'no_nodes'
%
% See also CONDOR.OPTIONS
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
    if ~exist('no_splits', 'var')
        no_splits = condor.options('no_nodes');
    end
    split_array = condor.helper.arr_split(array, no_splits);
    function parms = parfun(job_no)
        parms = split_array(job_no);
    end
    fun = @parfun;
end