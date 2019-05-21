function fun = br_split(br)
    no_jobs = condor.options('no_nodes');
	brs = condor.helper.br_split(br, no_jobs);
    function parm = parfun(job_no)
        parm = {brs{job_no}};
    end
	fun = @parfun;
end
