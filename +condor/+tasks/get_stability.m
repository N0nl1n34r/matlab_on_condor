function result = get_stability(br, psd_nodes)
    sys_init;
    br.method.stability.psd_nodes = psd_nodes;
    [nunst,~,~,br.point]=GetStability(br,...
            'funcs',rfuncs, 'stabilityfield', 'l1');
    result = {br, nunst};
end
