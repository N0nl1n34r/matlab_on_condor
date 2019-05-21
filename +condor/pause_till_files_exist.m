function pause_till_files_exist(expected_files, seconds_to_wait)
    if(nargin < 2)
        seconds_to_wait = 5;
    end
    while(~all(isfile(expected_files)))
        pause(seconds_to_wait);
    end
end