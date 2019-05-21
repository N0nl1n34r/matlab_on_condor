function [br, nunst] = get_stability(br, psd_nodes, varargin)     
    % condor.task.get_stability takes br, psd_nodes and returns {br, nunst}
    funfile = 'condor.tasks.get_stability'; 
    
    % br_split splits br into no_nodes part, constant returns its argument 
    % in a cell array (so it will be passed as an argument), and unpack
    % just returns its argument (so that cell arrays will be unpacked)
    % combined joins all returned cell arrays of the parfuns
    parfun = condor.parfuns.combined(condor.parfuns.br_split(br), ...
                                     condor.parfuns.constant(psd_nodes),...
                                     condor.parfuns.unpack(varargin));
                                 
    % cell_apply applies brs_join to all returned brs and
    % arrs_join to all returned nunst
    reducefun = condor.reducefuns.cell_apply(@condor.helper.brs_join, ...
                                             @condor.helper.arrs_join);
    result = condor.execute(funfile, parfun, reducefun);
    [br, nunst] = result{:};
end
