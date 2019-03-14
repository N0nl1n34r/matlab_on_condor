h = 2;
a = 10.5:0.5:15;
b = [0.01 0:0.05:1];
tau = [0 0.01 0.1 1 1:0.5:5 5:5:100];
omega = 1;

parms = tuples(h, a, b, omega,tau);
parms_split = mat2cell(parms, diff(floor(size(parms,1)*(0:no_jobs)/no_jobs)));

for i = 1:no_jobs
    parameters = parms_split{i};
    save(strcat('parameter_job_no_', num2str(i), '.mat'), 'parameters')
end

% generates a matrix of all possible tuples, where the ith element is from
% the ith argument
% this is basically the matlab version of the build-in mathematica version
% of tuples
function matrix = tuples(varargin)
    if isempty(varargin) % recursion base case, although not really sensible
        matrix = [];
        return
    elseif length(varargin) == 1  % recursion base case
        % transpose since input arg is row vector and output is column vector
        matrix = varargin{1}'; 
        return
    end
    first_par = varargin{1};
    submatrix = tuples(varargin{2:end}); % recursion, yeah!
    matrix = zeros(size(submatrix,1)*length(first_par), length(varargin)); % preallocation
    for i=1:length(first_par)
        matrix(1+size(submatrix,1)*(i-1):i*size(submatrix,1), 1) = repmat(first_par(i), [size(submatrix,1) 1]);
        matrix(1+size(submatrix,1)*(i-1):i*size(submatrix,1), 2:size(matrix, 2)) = submatrix;
    end
end
