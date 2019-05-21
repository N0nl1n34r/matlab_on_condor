function result = get_stability(br, psd_nodes, varargin)
    br.method.stability.psd_nodes = psd_nodes;
    [nunst,~,~,br.point]=GetStability(br,...
            'funcs', sys_func, 'stabilityfield', 'l1', varargin{:});
    result = {br, nunst};
end
