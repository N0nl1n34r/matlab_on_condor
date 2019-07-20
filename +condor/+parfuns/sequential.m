function parfun = sequential(varargin)
    parfuns = varargin(1:2:length(varargin));
    job_nos = [varargin{2:2:length(varargin)}];
    cum_job_nos = cumsum(job_nos);
    function parameters = sequential_parfun(job_no)
        fun_index = find(job_no <= cum_job_nos, 1);
        if fun_index > 1
            job_no = job_no - cum_job_nos(fun_index-1);
        end
        parameters = parfuns{fun_index}(job_no);
    end
    parfun = @sequential_parfun;
end