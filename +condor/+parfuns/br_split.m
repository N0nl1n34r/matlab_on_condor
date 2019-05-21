function fun = br_split(no_jobs, br)
	brs = br_split(br, no_jobs);
    function parm = parfun(no_job)
        parm = {brs{i}};
    end
	fun = @parfun;
end
