function reducefun = sum(varargin)
% CONDOR.REDUCEFUNS.SUM(varargin) returns a reduce function which sums all 
% of its input arguments.
% INPUT none
%
% OUTPUT reducefun: A reduce function which sums its input arguments.
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
    function total = sum_inputs(varargin)
        total = sum([varargin{:}]);
    end
    reducefun = @sum_inputs;
end
