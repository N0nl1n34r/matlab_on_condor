function result = execute(funfile, parfun, reducefun)
% EXECUTE(no_jobs, funfile, parfun, reducefun) executes the function
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
%               condor.
%
% INPUT no_jobs: The number of condor jobs which will be created. Each job
%                will execute the same function specified by funfile but
%                the parameters, with which the function is called, can be
%                dependent on the job number and are given by parfun.
%       funfile: String/char array containing the name of a function or
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
%      execute(100, 'identity', @(job_no) {job_no}, ...
%                     @(varargin) sum(cellfun(@(x) x, varargin)))
%      ... is a needlessly complicated way of summing all the integers from
%      1 to 100 (identity contains a function which returns its argument).
%
%      brs = br_split(br, no_jobs);
%      br = execute(no_jobs, 'br_calculate_stability', @(job_no)
%      br{job_no}, @brs_join);
%      ... is a very much needed way to calculate the stability of a branch
%      in an embarrassingly parallel (this is a technical term!) way.
%      
% REMARKS This only works on machines on which condor_submit is a terminal
%         command (i.e. machines in the institute).
%
%         Dependencies are handled automatically, so if the function
%         specified by funfile depends on other .m files, they are copied
%         to the condor node as well (yes, this means libraries are copied 
%         automatically).
%
%         If any of the jobs on condor are terminated irregulary, so that
%         no results_job_no_[[x]].mat file is created, you are out of luck.
%         As this function waits until all these result files are created,
%         you will have to terminate operations by pressing ctrl+c.
%         If you want to avoid this situation, make sure that your function
%         handles all its exceptions properly.
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 15-May-2019
%
    no_jobs = condor.options('no_nodes');
    
    tarball_dependencies(funfile);
    create_job_parameter_files(parfun, no_jobs);
    submit_on_condor(funfile, no_jobs);
    
    condor.pause_till_files_exist(condor_expected_files(no_jobs));
    results = get_job_results(no_jobs);
    result = reducefun(results{:});
    condor.cleanup();
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
    for i = 1:no_jobs
        job_no = i;
        parameters = parfun(job_no);
        save(strcat(fileparts(mfilename('fullpath')), '/', ...
                    'parameters_job_no_', num2str(i), '.mat'), ...
             'parameters', 'job_no');
    end
end

function submit_on_condor(funfile, no_jobs)
    mdir = fileparts(mfilename('fullpath'));
    [~, funname, funext] = fileparts(funfile); 
    if(funext ~= ".m")
        funname = strcat(funname, funext);
    end
    [~, ~] = system(['cd ''' mdir  ''' && ' ...
           './matlab_submit_on_condor.py ' num2str(no_jobs) ' ' funname]);
end

function ef = condor_expected_files(no_jobs)
    ef = arrayfun(@(no) strcat(fileparts(mfilename('fullpath')), '/', ...
                               "result_job_no_", num2str(no), ".mat"), ...
                  1:no_jobs);
end

function results = get_job_results(no_jobs)
    results = cell(1, no_jobs);
    for no = 1:no_jobs
        load(strcat(fileparts(mfilename('fullpath')), '/', ...
                              "result_job_no_", num2str(no), ".mat"), ...
             'result');
        results{no} = result;
    end
end
