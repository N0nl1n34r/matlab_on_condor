function split = arr_split(array, no)
% CONDOR.HELPER.ARR_SPLIT(array, no) splits the array into no approximatly
% equal large parts.
%
% INPUT array: The array which should be split into parts.
%       no:    The number of parts the array should be split into.
%
% OUTPUT split: A cell array where each element is an array which is one
%               part of the input array.
%
% EXAMPLES 
%        split = condor.helper.arr_split(1:10, 3);
%        split{1} % should return 1:3
%        split{2} % should return 4:6
%        split{3} % should return 7:10
%
% See also CONDOR.HELPER.ARRS_JOIN
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    split_lengths = diff(floor(length(array)*(0:no)/no));
    if(size(array, 1) >= size(array, 2))
        split = mat2cell(array, split_lengths, 1);
    else
        split = mat2cell(array, 1, split_lengths);
    end
end
	