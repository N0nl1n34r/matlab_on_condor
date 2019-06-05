function result = get_stability(br, psd_nodes, varargin)
% CONDOR.TASKS.GET_STABILITY(br, psd_nodes, varargin) computes the
% stability of a br on a condor node.
%
%
% INPUT br:        The branch of which the stability should be computed.
%       psd_nodes: The number of nodes for spectral differencing
%       varargin:  Other arguments to pass down to GetStability from dde
%                  biftool
%
% OUTPUT result:   A cell array containing {br, nunst}, i. e. the branch
%                  with stability information added and nunst, the number 
%                  of unstable eigenvalues.
%
% REMARKS  This function is not to be intended to be used by a user.
%          Instead use CONDOR.EXECUTE.GET_STABILITY to compute the
%          stability of a branch on condor.
%       
% See also CONDOR.EXECUTE.GET_STABILITY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    br.method.stability.psd_nodes = psd_nodes;
    [nunst,~,~,br.point]=GetStability(br,...
            'funcs', sys_func, 'stabilityfield', 'l1', varargin{:});
    result = {br, nunst};
end
