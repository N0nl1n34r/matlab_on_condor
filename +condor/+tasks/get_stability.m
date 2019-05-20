function result = get_stability(br, psd_nodes, varargin)
    sys_init; % -> sys_funcs
    br.method.stability.psd_nodes = psd_nodes;
    [nunst,~,~,br.point]=GetStability(br,...
            'funcs',rfuncs, 'stabilityfield', 'l1', varargin{:});
    result = {br, nunst};
end
