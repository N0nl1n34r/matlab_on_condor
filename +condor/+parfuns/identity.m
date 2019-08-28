function parfun = identity()
% CONDOR.PARFUNS.IDENTITY() returns a parameter function which returns its
% job number unchanged.
%
% INPUT none
%
% OUTPUT parfun: Parameter function which returns the job number in a cell
%                array.
%         
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019
    function results = identity(job_no)
        result = {job_no};
    end
    parfun = @identity; 
end