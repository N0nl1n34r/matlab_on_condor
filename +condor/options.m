function varargout = options(opt, varargin)
% This is a silly way to have global options for all functions in a
% package. 
% SYNOPSIS options('set', opt_name1, value1, ..., opt_namen, valuen) sets 
% the options (opt_name1 to opt_namen) to (value1 to valuen) respectively.
% options(opt_name) returns the value of the option opt_name
% currently allowed options are: 'no_nodes': the number of condor nodes to use when running execute.
    persistent opts
    
    if(isempty(opts))
        opts = struct('no_nodes', min([100 floor(condor.free_nodes/3)]));
    end
    
    switch opt
        case 'set'
            for i = 1:2:length(varargin)
                if(isfield(opts, varargin{i}))
                    opts = setfield(opts, varargin{i}, varargin{i+1});
                else
                    error(strcat("'", varargin{i}, ...
                                 "' is not a valid option."));
                end
            end
        otherwise
            varargout = {opts.(opt)};
    end
end
            
