function total = sum_all(varargin)
% CONDOR.REDUCEFUNS.SUM_ALL(varargin) returns the sum of all 
% its input arguments.
% INPUT varargin: Arguments which should be summed.
%
% OUTPUT total: The sum of the input arguments
%
% EXAMPLES 
%        condor.reducefuns.sum_all(1,2,3)
%        % should return 6
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	total = sum([varargin{:}]);
end
