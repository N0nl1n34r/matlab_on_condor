function fun = parameter_sweep(varargin)
% CONDOR.PARFUNS.PARAMETER_SWEEP(varargin) returns a parameter function
% for parameter sweeps, where the possible values for each parameter are
% given as an input in form of an array. The parameter functions then
% returns for a given job number a matrix of parameters to iterate over,
% where each row corresponds to one parameter vector.
%
% INPUT varargin: Each of the input arguments is an array of values for one
%                 parameter. Then all possible tuples where the ith element 
%                 comes from the ith input are created and split into
%                 condor.options('no_nodes') parts.
%
% OUTPUT parfun: Parameter function which takes one argument, the job  
%                number and returns a cell array which contains one matrix 
%                where each row corresponds to one parameter vector 
%                (this is probably easier to understand if you just look at 
%                the example).
%
% EXAMPLES 
%          condor.options('set', 'no_nodes', 2)
%          % first parameter should have values 1,2 and 3 while the second
%          % parameter should have the values 4 and 5. All possible
%          % combinations of the first and second parameter will be created
%          parfun_sweep = condor.parfuns.parameter_sweep([1 2 3], [4 5]);
%          parameter_job_no_1 = parfun_sweep(1);
%          parameter_job_no_1{:}
%          % ... should return [1 4; 1 5; 2 4], each row is a combination
%          % of first parameter and second parameter and parameter_job_no_1
%          % contains the first half (roughly 1/condor.options('no_nodes'))
%          % of all possible combinations.
%        
% REMARKS This function depends on the option 'no_nodes'.
%         If this function is used for a custom task, it should probably
%         iterate over the rows of its input argument, since each row
%         corresponds to one parameter vector.
%
% See also CONDOR.PARFUNS.ARR_SPLIT
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    no_jobs = condor.options('no_nodes');
	parms = tuples(varargin{:}); 
    split_lengths = diff(floor(size(parms,1)*(0:no_jobs)/no_jobs));
	parms_split = mat2cell(parms, split_lengths);
	function parms = parfun(job_no)
		parms = {parms_split{job_no}};
	end
	fun = @parfun;
end

% generates a matrix of all possible tuples, where the ith element is from
% the ith argument
% this is basically the matlab version of the build-in mathematica version
% of tuples
% ... and it is ugly as shit, sorry
function matrix = tuples(varargin)
    if isempty(varargin) % recursion base case, although not really sensible
        matrix = [];
        return
    elseif length(varargin) == 1  % recursion base case
        % transpose since input arg is row vector and output is column vector
        matrix = varargin{1}'; 
        return
    end
    first_par = varargin{1};
    submatrix = tuples(varargin{2:end}); % recursion, yeah!
    matrix = zeros(size(submatrix,1)*length(first_par), length(varargin)); % preallocation
    for i=1:length(first_par)
        matrix(1+size(submatrix,1)*(i-1):i*size(submatrix,1), 1) = repmat(first_par(i), [size(submatrix,1) 1]);
        matrix(1+size(submatrix,1)*(i-1):i*size(submatrix,1), 2:size(matrix, 2)) = submatrix;
    end
end
