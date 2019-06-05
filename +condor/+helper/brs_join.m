function br = brs_join(varargin)
% CONDOR.HELPER.BRS_JOIN(varargin) joins the branches given as input to one
% branch.
%
% INPUT varargin: branches which should be joined.
%
% OUTPUT array: One branch which is created by joining the input arguments.
%
% EXAMPLES
%        br = condor.helper.arrs_join(struct('point', 1:5), ...
%                                     struct('point', 2:3), ...
%                                     struct('point', 1)); 
%        br.point
%        % should return [1:5 2:3 1]
%         
% See also CONDOR.HELPER.ARR_SPLIT
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	br = varargin{1};
	points = cellfun(@(br) br.point, varargin, 'UniformOutput', false);
	br.point = horzcat(points{:});
end
