function [br, nunst] = get_stability(br, varargin)     
% CONDOR.EXECUTE.GET_STABILITY(br, varargin) computes the
% stability of the branch br. Other arguments are passed down to GetStability 
% function of dde biftool. Computation is done on condor with
% condor.options('no_nodes') number of nodes.
%
% INPUT br:        The branch which stability should be computed.
%       varargin:  Arguments which should be passed down to the
%                  GetStability function of dde biftool.
%
% OUTPUT br:       Input branch with stability information added.
%        nunst:    Array of number of unstable eigenvalues.
%         
% REMARKS This functions depends on the option 'no_nodes'.
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    % condor.task.get_stability takes br, psd_nodes and returns {br, nunst}
    funfile = 'condor.tasks.get_stability'; 
    
    % br_split splits br into no_nodes part, constant returns its argument 
    % in a cell array (so it will be passed as an argument), and unpack
    % just returns its argument (so that cell arrays will be unpacked)
    % combined joins all returned cell arrays of the parfuns
    parfun = condor.parfuns.combined(condor.parfuns.br_split(br), ...
                                     condor.parfuns.unpack(varargin));
                                 
    % cell_apply applies brs_join to all returned brs and
    % arrs_join to all returned nunst
    reducefun = condor.reducefuns.cell_apply(@condor.helper.brs_join, ...
                                             @condor.helper.arrs_join);
    result = condor.execute(funfile, parfun, reducefun);
    [br, nunst] = result{:};
end
