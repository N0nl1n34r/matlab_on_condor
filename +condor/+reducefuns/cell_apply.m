function fun = cell_apply(varargin)
    cell_index_funs = cell(1, length(varargin));
    for i = 1:length(varargin)
        cell_index_funs{i} = ...
            condor.reducefuns.cell_index_apply(i, varargin{i});
    end
    fun = condor.reducefuns.combined(cell_index_funs{:});
end
                                     