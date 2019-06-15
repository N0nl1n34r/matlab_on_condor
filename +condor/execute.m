function result = execute(funfile, parfun, reducefun)
% CONDOR.EXECUTE(funfile, parfun, reducefun) executes the function
% specified by funfile on no_jobs condor nodes, where the arguments given 
% to the ith node is given by the cell array parfun(i) which is spliced
% into the function. The outputs of all jobs are given as a return value
% after applying them to reducefun.
%
% SYNOPSIS: Output of this function can be imagined as
%           reducefun(fun(parfun(1){:}), fun(parfun(2){:}), ...,
%           fun(parfun(i){:}), ..., fun(parfun(no_jobs){:})) where fun is 
%           the function specified by funfile. Except for the fact that 
%           1.) matlab doesn't allow indexing of arbitrary expressions,
%               which is stupid (replace fun(parfun(i)){:} with parms =
%               parfun(i); fun(parms{:});).
%           2.) Each of the calls of fun is done on a different node on
%               condor. The number of nodes can be set by using
%               condor.options('set', 'no_nodes', <number>).
%
% INPUT funfile: String/char array containing the name of a function or
%                path to a file, which contains a function. This function
%                will be executed on condor. Parameters passed to this
%                function for the job with number i are given by the return
%                value of parfun(i), which is spliced into the function.
%       parfun:  Function handle, which takes one integer argument (the job
%                number) returns a cell array with parameters with which 
%                the function specified by funfile will be called.
%       reducefun: Function handle, which takes no_jobs amount of input
%                  arguments and returns one value as output. 
%
% OUTPUT result: Output of reducefun applied to the results of the nodes.
%
% EXAMPLES 
%      condor.options('set', 'no_nodes', 10);
%      condor.execute('condor.tasks.identity', ...
%                     @condor.parfuns.identity, ...
%                     @condor.reducefuns.sum_all)
%      % ... is a needlessly complicated way of summing all the integers 
%      % from from 1 to 10.
% 
% REMARKS The number of nodes/created jobs can be set by using 
%         condor.options('set', no_nodes, <number>)
%
%         This function depends on the option 'no_nodes' and 'debug'.
%         
%         This only works on machines on which condor_submit is a terminal
%         command (i.e. machines in the institute).
%
%         Dependencies are handled automatically, so if the function
%         specified by funfile depends on other .m files, they are copied
%         to the condor node as well (yes, this means libraries are copied 
%         automatically).
%         For more information on what is and what isn't copied see:
%         https://de.mathworks.com/help/matlab/matlab_prog/identify-dependencies.html
%
%         If any of the jobs on condor are terminated irregulary, so that
%         no results_job_no_[[x]].mat file is created, you are out of luck.
%         As this function waits until all these result files are created,
%         you will have to terminate operations by pressing ctrl+c.
%         If you want to avoid this situation, make sure that your function
%         handles all its exceptions properly. It is advised to call
%         condor.cleanup if this should occur.
%
% See also CONDOR.EXECUTE.GET_STABILITY, CONDOR.OPTIONS, CONDOR.CLEANUP
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
%
    no_jobs = condor.options('no_nodes');
    if(~(condor.options('debug') && ...
         all(isfile(condor_expected_files(no_jobs)))))
        tarball_dependencies(funfile);
        create_job_parameter_files(parfun, no_jobs);
        submit_on_condor(funfile, no_jobs);

        condor.helper.pause_till_files_exist(condor_expected_files(no_jobs));
    end
    results = get_job_results(no_jobs);
    result = reducefun(results{:});
    if(~condor.options('debug'))
        condor.cleanup();
    end
end

function tarball_dependencies(funfile)
    dep = get_dependencies(funfile);
    warnings = warning;
    warning('off', 'MATLAB:tar:archiveName');
    tar(strcat(fileparts(mfilename('fullpath')), '/', ...
               'include_dependencies.tar'), dep);
    gzip(strcat(fileparts(mfilename('fullpath')), '/', ...
                'include_dependencies.tar'));
    warning(warnings);
end

function dep = get_dependencies(funfile)
    dep = matlab.codetools.requiredFilesAndProducts(funfile);
    % if funfile specifies function in package, add package
    % to dependencies
    funfile_full = which(funfile);
    if(is_file_in_package(funfile_full))
        package_name = fileparts(funfile_full);
        % get top most package name, as function may be in sub package
        while(is_file_in_package(package_name))
            package_name = fileparts(package_name);
        end
        dep = dep(~startsWith(dep, package_name));
        dep{end+1} = strcat(package_name);
    end
end

function result = is_file_in_package(filepath)
    result = startsWith(parent_dir_name(filepath), '+');
end

function dir_name = parent_dir_name(path_name)
    [parent_path, ~] = fileparts(path_name);
    [~, dir_name] = fileparts(parent_path);
end

function create_job_parameter_files(parfun, no_jobs)
    % jobs in matlab start with 1, but due to the condor submit file
    % parameter files start at 0 -> therefore job_no = i, but file uses i-1
    for i = 1:no_jobs
        job_no = i;
        parameters = parfun(job_no);
        save(strcat(fileparts(mfilename('fullpath')), '/', ...
                    'parameters_job_no_', num2str(i-1), '.mat'), ...
             'parameters', 'job_no');
    end
end

function submit_on_condor(funfile, no_jobs)
    mdir = fileparts(mfilename('fullpath'));
    [~, funname, funext] = fileparts(funfile); 
    if(funext ~= ".m") % function is in a package
        funname = strcat(funname, funext);
    end
    [~, ~] = system(['cd ''' mdir  ''' && ' ...
           'chmod +x matlab_submit_on_condor.py']); 
    [~, ~] = system(['cd ''' mdir  ''' && ' ...
           './matlab_submit_on_condor.py ' num2str(no_jobs) ' ' funname]);
end

function ef = condor_expected_files(no_jobs)
    ef = arrayfun(@(no) strcat(fileparts(mfilename('fullpath')), '/', ...
                               "result_job_no_", num2str(no), ".mat"), ...
                  0:(no_jobs-1));
end

function results = get_job_results(no_jobs)
    results = cell(1, no_jobs);
    result_index = 1;
    for job_no = 0:(no_jobs-1)
        job = load(strcat(fileparts(mfilename('fullpath')), '/', ...
                          "result_job_no_", num2str(job_no), ".mat"), ...
                   'result', 'suc', 'errmsg');
        if job.suc
            results{result_index} = job.result;
            result_index = result_index + 1;
        else
            warning(['Job number ' num2str(job_no) ' failed.' ...
                     newline 'Corresponding output will be omitted in the return value.'])
            warning(job.errmsg);
        end
    end
    results = results(1:result_index-1);
end
