function array = arr_join(varargin)
    is_vert = all(cellfun(@(arr) size(arr, 1) >= size(arr, 2), varargin));
    if(all(is_vert))
        array = vertcat(varargin{:});
    else
        array = horzcat(varargin{:});
    end;
end