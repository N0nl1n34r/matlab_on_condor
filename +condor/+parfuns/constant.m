function fun = constant(c)
    function parms = parfun(~)
        parms = {c};
    end
    fun = @parfun;
end