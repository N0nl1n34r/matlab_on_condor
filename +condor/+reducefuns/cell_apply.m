function fun = cell_apply(varargin)
% CONDOR.REDUCEFUNS.CELL_APPLY(varargin) returns a combined cell reduce 
% function where ith input reduce function is used to reduce the ith 
% elements of each of the cells given to the output reduce function. 
% (look at the example as this seems to be impossible to describe accuratly
% with words)
%
%
% INPUT varargin: A list of reduce functions. 
%
% OUTPUT reducefun: A cell reduce function where the ith input argument to 
%                   this function is used to reduce the ith elements of 
%                   each of the cells given to the returned reduce
%                   function.
%
% EXAMPLES 
%     reducefun = condor.reducefuns.cell_apply(@condor.helper.arrs_join, ...
%                                          @(varargin) sum([varargin{:}]));
%     % arrs_join is applied to the first element of each of the cells
%     % the second elements are summed
%     reducefun({1:3, 1:10}, {4:10, 11:100})
%     % ... should return {1:10, 5050}         
%
% See also CONDOR.REDUCEFUNS.CELL_INDEX_APPLY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    cell_index_funs = cell(1, length(varargin));
    for i = 1:length(varargin)
        cell_index_funs{i} = ...
            condor.reducefuns.cell_index_apply(i, varargin{i});
    end
    fun = condor.reducefuns.combined(cell_index_funs{:});
end
                                     