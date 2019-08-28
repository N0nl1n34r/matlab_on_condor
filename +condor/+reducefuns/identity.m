function reducefun = identity()
% CONDOR.REDUCEFUNS.IDENTITY() returns a reduce function which returns its 
% input arguments unchanged.
% INPUT none
%
% OUTPUT reducefun: A reduce function which returns its input arguments as
%                   output arguments.
%
% EXAMPLES 
%        condor.reducefuns.identity(1,2,3)
%        % should return {1,2,3}
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
    function varargin = identity(varargin)
    end
    reducefun = @identity;
end