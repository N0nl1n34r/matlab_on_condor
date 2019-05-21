function fun = constant(c)
    function parms = parfun(job_no)
        parms = {c};
    end
    fun = @parfun;
end