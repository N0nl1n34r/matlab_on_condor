function varargout = options(opt, varargin)
% CONDOR.OPTIONS is a method which manages global and persistent options 
% for the condor package.
%
% CONDOR.OPTIONS(option_name) returns the value of option option_name.
% Valid options are: 'no_nodes': The number of nodes which should be used
%                                for computations. 
%                                Default is min([10 condor.free_nodes]).
%                    'debug':    In debug mode the condor folder is not
%                                cleaned after successful computations and
%                                jobs are only submitted if there are not
%                                already all results from a previous
%                                computation available. Default is false.
%                    'username': Username for condor job removal. Default
%                                is empty char array ''.
%
% CONDOR.OPTIONS('set', option_name, option_value) sets the option
% option_name to option_value. See above for valid option names.
%
% CONDOR.OPTIONS('reset') resets all options to default values.
%
% EXAMPLES
%       condor.options('no_nodes') % number of nodes used for computations
%       condor.options('set', 'no_nodes', 10) % use ten nodes
%       condor.options('set', 'debug', true)
%       condor.options('reset')
%         
% REMARKS I know, this is a silly way to have global options for all 
%         functions in a package. I'm not really convinced that this method
%         is a good idea, shrug.
%
% See also CONDOR.EXECUTE, CONDOR.CLEANUP, CONDOR.FREE_NODES
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    persistent opts
    
    if(isempty(opts))
        opts = struct('no_nodes', min([100 floor(condor.free_nodes/3)]), ...
                      'username', 'd_hess06', ...
                      'debug', false);
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
        case 'reset'
            opts = [];
        otherwise
            varargout = {opts.(opt)};
    end
end
            
