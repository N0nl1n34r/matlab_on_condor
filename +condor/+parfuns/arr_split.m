function fun = arr_split(array)
    no_jobs = condor.options('no_nodes');
    split_array = arr_split(array, no_jobs);
    function parms = parfun(job_no)
        parms = {split_array{job_no}};
    end
    fun = @parfun;
end