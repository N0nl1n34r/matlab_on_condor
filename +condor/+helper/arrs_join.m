function array = arrs_join(varargin)
% CONDOR.HELPER.ARRS_JOIN(varargin) joins the arrays given as input to one 
% array.
%
% INPUT varargin: arrays which should be joined
%
% OUTPUT array: One array which is created by joining the input arguments.
%
% EXAMPLES
%        condor.helper.arrs_join(1:5, 2:3, 1) 
%        % should return [1:5 2:3 1]
%         
% See also CONDOR.HELPER.ARR_SPLIT
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    is_vert = all(cellfun(@(arr) size(arr, 1) >= size(arr, 2), varargin));
    if(all(is_vert))
        array = vertcat(varargin{:});
    else
        array = horzcat(varargin{:});
    end
end