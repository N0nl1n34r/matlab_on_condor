function [br, nunst] = get_stability(no_jobs, br, psd_nodes) 
    if(nargin < 3)
        psd_nodes = 20;
    end
    funfile = 'condor.task.get_stability';
    parfun = condor.parfuns.br_split(no_jobs, br);
    function result = reducefun(varargin)
        tmp_brs = cellfun(@(r) r{1}, varargin);
        tmp_br = brs_join(tmp_brs{:});
        tmp_nunst = cell2mat(cellfun(@(r) r{2}, varargin, ...
                                     'UniformOutput', false));
        result = [tmp_br, tmp_nunst];
    end
    result = condor.execute(no_jobs, funfile, parfun, @reducefun);
    [br, nunst] = result{:};
end;
