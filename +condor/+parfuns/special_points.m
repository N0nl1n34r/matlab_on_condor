function fun = special_points(br, point_indices)
    no_jobs = condor.options('no_nodes');
    split_indices = arr_split(point_indices, no_jobs);
    function parms = parfun(job_no)
        parms = {br, split_indices{job_no}};
    end
    fun = @parfun;           
end
