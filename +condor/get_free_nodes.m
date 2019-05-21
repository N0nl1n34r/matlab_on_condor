function free_nodes = get_free_nodes()
    free_nodes = 0;
    [exit_code, command_output] = system('condor_status -total');
    if(exit_code == 0)
        command_output = strsplit(command_output);
        % I know, this is horrible...
        free_nodes = str2num(command_output{end-4});
    end
end
