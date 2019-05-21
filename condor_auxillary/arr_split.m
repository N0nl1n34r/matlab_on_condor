function split = arr_split(array, no)
    split_lengths = diff(floor(length(array)*(0:no)/no));
    if(size(array, 1) >= size(array, 2))
        split = mat2cell(array, split_lengths, 1);
    else
        split = mat2cell(array, 1, split_lengths);
    end;
end
	