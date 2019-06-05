function fun = special_points(br, point_indices)
% CONDOR.PARFUNS.SPECIAL_POINTS(br, point_indices) returns a parameter
% function so that the target task gets the branch and an array of
% point_indices as arguments. Basically point_indices will be split into
% condor.options('no_node') parts and each task gets the branch and a part
% of the point_indices.
%
% INPUT br:            A branch.
%       point_indices: An array of point indices which should be split.
%
% OUTPUT parfun: A parameter function which returns the branch and a part.
%                of the point indices in a cell array.
%
% EXAMPLES 
%         
% REMARKS This function depends on the option 'no_nodes'.
%
% See also
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    no_jobs = condor.options('no_nodes');
    split_indices = condor.helper.arr_split(point_indices, no_jobs);
    function parms = parfun(job_no)
        parms = {br, split_indices{job_no}};
    end
    fun = @parfun;           
end
