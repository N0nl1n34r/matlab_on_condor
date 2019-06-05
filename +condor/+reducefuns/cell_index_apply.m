function fun = cell_index_apply(cell_index, apply_fun)
% CONDOR.REDUCEFUNS.CELL_INDEX_APPLY(cell_index, apply_fun) returns a
% reduce function which takes a variable amount of cells as input and 
% returns apply_fun applied to the cell_index th element of each of the 
% input cell.
%
% INPUT cell_index: The index of the element to which apply_fun should be
%                   applied
%       apply_fun:  The function which should be applied to the
%                   cell_index th element of each input cell.
%
% OUTPUT reducefun: A reduce function which takes a variable amount of
%                   cells as input and returns apply_fun applied to the
%                   cell_indexed element of each input cell.
%
% EXAMPLES 
%        reducefun = condor.reducefuns.cell_index_apply(3, ...
%                         @(varargin) sum([varargin{:}]));
%        reducefun({1,2,3}, {5,4,3}, {1,2,3})
%        % ... should return 9, since all third elements of each of the
%        % cell arrays are summed.
%
%        reducefun = condor.reducefuns.cell_index_apply(2, ...
%                         @(varargin) strcat(varargin{:}));
%        reducefun({"Mathematica ", "Matlab "}, {"rules", "sucks"})
%        % ... should return the truth.
% REMARKS 
%
% See also
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    function result = reducefun(varargin)
        cell_elements = cellfun(@(r) r{cell_index}, varargin, ...
                                'UniformOutput', false);
        result = apply_fun(cell_elements{:});
    end
    fun = @reducefun;
end