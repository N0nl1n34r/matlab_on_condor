function array = arrs_join(varargin)
% CONDOR.REDUCEFUNS.ARRS_JOIN(varargin) joins all of the input arrays.
%
% INPUT varargin: Arrays which should be joined.
%
% OUTPUT array: The joined array
%
% EXAMPLES 
%        condor.reducefuns.arrs_join([1,2,3], [7], [42,1])
%        % should return [1,2,3,7,42,1]
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	array = condor.helper.arrs_join(varargin{:});
end
