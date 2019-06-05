function fun = combined(varargin)
% CONDOR.REDUCEFUNS.COMBINED(vararging) returns a reduce function which
% combines the return values of all given reduce function in a cell array
%
% INPUT varargin: A list of reduce functions.
%
% OUTPUT reducefun: A combined reduce function which returns a cell array
%                   where the ith element is the return value of the ith 
%                   given reduce function
%
% EXAMPLES 
%        reducefun1 = condor.reducefuns.cell_index_apply(1, ...
%                         @(varargin) strcat(varargin{:}));
%        reducefun2 = condor.reducefuns.cell_index_apply(2, ...
%                         @(varargin) strcat(varargin{:}));
%        reducefun = condor.reducefuns.combined(reducefun1, reducefun2);
%        reducefun({"Mathematica ", "Matlab "}, {"rules", "sucks"})
%        % should return even more truth than the cell_index_apply example.
%
% See also CONDOR.REDUCEFUNS.CELL_APPLY, CONDOR.REDUCEFUNS.CELL_INDEX_APPLY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    outer_varargin = varargin;
    function result = reducefun(varargin)
        result = cellfun(@(f) f(varargin{:}), outer_varargin, ...
                         'UniformOutput', false);
    end
    fun = @reducefun;
end