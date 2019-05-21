function fun = special_points(no_jobs, br, point_indices)
    split_indices = arr_split(point_indices, no_jobs);
    function parms = parfun(job_no)
        parms = {br, split_indices{job_no}};
    end
    fun = @parfun;           
end
