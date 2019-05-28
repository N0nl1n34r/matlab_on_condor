function cleanup()
    mdir = ['''' fileparts(mfilename('fullpath')), '/' ''''];
    [~,~] = system(['rm ' mdir '*_job_no_*.err']);
    [~,~] = system(['rm ' mdir '*_job_no_*.txt']);
    [~,~] = system(['rm ' mdir '*_job_no_*.log']);
    [~,~] = system(['rm ' mdir '*_job_no_*.sub']);
    [~,~] = system(['rm ' mdir 'parameters_job_no_*.mat']);
    [~,~] = system(['rm ' mdir 'result_job_no_*.mat']);  
    [~,~] = system(['rm ' mdir 'include_dependencies.tar']); 
    [~,~] = system(['rm ' mdir 'include_dependencies.tar.gz']); 
    [~,~] = system(['condor_rm ' condor.options('username')]);
end
