function fun = combined(varargin)
    outer_varargin = varargin;
    function result = reducefun(varargin)
        result = cellfun(@(f) f(varargin{:}), outer_varargin, ...
                         'UniformOutput', false);
    end
    fun = @reducefun;
end