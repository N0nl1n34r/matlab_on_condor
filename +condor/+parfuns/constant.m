function fun = constant(c)
% CONDOR.PARFUNS.CONSTANT(c) return the constant parameter function which 
% always returns c in a cell array.
%
% INPUT c: The constant which the parameter function should return.
%
% OUTPUT parfun: Parameter function, which returns the constant c for each
%                job number
%
% EXAMPLES 
%          constant_parfun = condor.parfuns.constant(42);
%          constant_parfun(17)
%          %... should return {42}
%
% REMARKS The constant c can be of any type.
%
% See also CONDOR.PARFUNS for other parameter functions
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    function parms = parfun(~)
        parms = {c};
    end
    fun = @parfun;
end