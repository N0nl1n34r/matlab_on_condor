function fun = unpack(x)
    function parms = parfun(~)
        parms = x;
    end
    fun = @parfun;
end