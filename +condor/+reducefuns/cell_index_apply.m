function fun = cell_index_apply(cell_index, apply_fun)
    function result = reducefun(varargin)
        cell_elements = cellfun(@(r) r{cell_index}, varargin, ...
                                'UniformOutput', false);
        result = apply_fun(cell_elements{:});
    end
    fun = @reducefun;
end