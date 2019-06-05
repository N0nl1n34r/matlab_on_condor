function free_nodes = free_nodes()
% CONDOR.FREE_NODES() returns the number of currently available condor
% nodes.
%
% INPUT none
%
% OUTPUT free_nodes: The number of currently available condor nodes.
%
% EXAMPLES 
%       condor.free_nodes() 
%       % after sharing this code probably returns something close to zero :(
%         
% REMARKS This only works on machines on which condor_status is a terminal
%         command (i.e. machines in the institute).
%
% See also CONDOR.EXECUTE, CONDOR.CLEANUP
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    free_nodes = 0;
    [exit_code, command_output] = system('condor_status -total');
    if(exit_code == 0)
        command_output = strsplit(command_output);
        % I know, this is horrible...
        free_nodes = str2num(command_output{end-4});
    else
        error(command_output);
    end
end
