function pause_till_files_exist(expected_files, seconds_to_wait, monitor_function)
    if ~exist('seconds_to_wait', 'var')
        seconds_to_wait = 5;
    end
    if ~exist('monitor_function', 'var')
        monitor_function = condor.options('monitor_function');
    end
    while(~all(isfile(expected_files)))
        are_files = isfile(expected_files);
        monitor_function(expected_files, ...
                         expected_files(~are_files), ...
                         sum(are_files)/length(are_files));
        pause(seconds_to_wait);
    end
end