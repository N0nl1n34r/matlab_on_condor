function fun = combined(varargin)
% CONDOR.PARFUNS.COMBINED(varargin) combines multiple parameter functions
% to one combined parameter function.
%
% INPUT varargin: Parameter functions which shall be combined.
%
% OUTPUT parfun: Parameter function which, given a job number, returns a 
%                cell array where the results of the given input functions 
%                (varaargin) are concatenated.
%
% EXAMPLES 
%          % parfun which returns the job number
%          parfun1 = @(no) {no}; 
%          % parfun which returns double the job number
%          parfun2 = @(no) {2*no};
%          combined_parfun = condor.parfuns.combined(parfun1, parfun2);
%          combined_parfun(3)
%          % ... should return {3, 6}
%
%          see CONDOR.EXECUTE.GET_STABILITY, where CONDOR.PARFUNS.COMBINED
%          is used to pass a splitted branch, the number of spectral
%          differencing nodes and a variable number of constant options.
%         
% REMARKS This function is useful, if you have a task which takes multiple
%         arguments and you want to use the already available functions in 
%         this package.
%
% See also CONDOR.EXECUTE.GET_STABILITY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	function parms = parfun(no_job)
		parms = cellfun(@(f) f(no_job), varargin, 'UniformOutput', false);
		parms = horzcat(parms{:});
    end
	fun = @parfun;
end
