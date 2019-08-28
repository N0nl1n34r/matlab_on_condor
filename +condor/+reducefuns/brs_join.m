function br = brs_join(varargin)
% CONDOR.REDUCEFUNS.brs_join(varargin) joins all of the input branches 
%
% INPUT varargin: branches which should be joined.
%
% OUTPUT br: The joined branch
%
% REMARKS This function is meant to be used with with DDE-BIFTOOL.
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	br = condor.helper.brs_join(varargin{:});
end
