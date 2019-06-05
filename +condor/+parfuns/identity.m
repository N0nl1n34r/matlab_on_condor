function result = identity(job_no)
% CONDOR.PARFUNS.IDENTITY(job_no) is a parameter function which returns the
% given job_no in a cell array.
%
% INPUT job_no: The number of the job.
%
% OUTPUT result: The given job number in a cell array.
%         
% REMARKS If you want to use this function with CONDOR.EXECUTE you need to
%         use a function handle, i.e. @identity, since this function in
%         contrast to the other functions does not return a parameter
%         function but already is one.
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

    result = {job_no};
end