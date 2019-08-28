function fun = unpack(x)
% CONDOR.PARFUNS.UNPACK(x) returns a parameter function which 
%
%
% INPUT x: The value to unpack. x should be a cell or something which can
%          be sliced (i. e. x{:} must be valid code).
%
% OUTPUT parfun: A parameter function which returns x (not in a cell!) 
%                independent of job number. The result is that the contents
%                of x will be sliced into the target task.
% 
% EXAMPLES
%        reducefun = condor.reducefuns.unpack({'option_a', 1, ...
%                                              'option_b', 2});
%        reducefun(42)
%        % ... should return {'option_a', 1, 'option_b', 2}
%
% REMARKS This function is used in this package with
%         CONDORS.PARFUNS.COMBINED to pass varargin to a task.
%
% See also CONDOR.PARFUNS.COMBINED, CONDOR.PARFUNS.CONSTANT,
%          CONDOR.EXECUTE.GET_STABILITY
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    function parms = parfun(~)
        parms = x;
    end
    fun = @parfun;
end