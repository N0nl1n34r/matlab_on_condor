disp('Starting Job')
mat = dir('*.mat'); 
for q = 1:length(mat) 
	load(mat(q).name); 
end

for i = 1:size(parameters, 1)
    parameter = parameters(i,:);
    try
        continue_steady_states(parameter)
    end
end
disp('Job Finished')
%%
function continue_steady_states(parameter)
	[br, rfuncs] = stationary(parameter);
	save(strcat('br_stst_', mat2str(parameter), '.mat'))
end

function continue_folds(parameter)
	br = parameter{1};
	fold_index = parameter{2};
	
	br_fold = fold(br, fold_index)
	save(strcat('br_fold_', num2str(fold_index), '.mat'))
end

function continue_hopfs(parameter)
	br = parameter{1};
	hopf_index = parameter{2};
	
	br_hopf = hopf(br, fold_index)
	save(strcat('br_hopf_', num2str(hopf_index), '.mat'))
end

function continue_periodic_orbits(parameter)
	br = parameter{1};
	po_index = parameter{2};
	
	br_po = hopf(br, po_index)
	save(strcat('br_po_', num2str(po_index), '.mat'))
end

function compute_stability_of_steady_states(parameter)
	br = parameter{1};
	job_no = parameter{2};
	br.method.stability.psd_nodes = 100;
   	[stat_nunst,dom,defect,br.point]=GetStability(br,...
        	'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',rfuncs, 'stabilityfield', 'l1');
	save(strcat('stst_br_with_stab_job', num2str(job_no), '.mat'))
end
