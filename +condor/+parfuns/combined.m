function fun = combined(varargin)
	function parms = parfun(no_job)
		parms = cellfun(@(f) f(no_job), varargin, 'UniformOutput', false)
		parms = cat(2, parms{:});
	end;
	fun = @parfun;
end
