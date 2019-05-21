function fun = arr_split(no_jobs, array)
    split_array = arr_split(array, no_jobs);
    function parms = parfun(job_no)
        parms = {split_array{job_no}};
    end
    fun = @parfun;
end