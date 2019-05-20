function pause_till_files_exist(expected_files, seconds_to_wait)
    if(nargin < 2)
        seconds_to_wait = 5;
    end
    f = waitbar(0, "Waiting for condor jobs to finish...", ...
                   'Name', 'condor.execute');
    while(~all(isfile(expected_files)))
        are_files = isfile(expected_files);
        waitbar(sum(are_files)/length(are_files), f, ...
                "Waiting for condor jobs to finish...");
        pause(seconds_to_wait);
    end
    close(f);
end