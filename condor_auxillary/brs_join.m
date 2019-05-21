function br = brs_join(varargin)
	br = varargin{1};
	points = cellfun(@(br) br.point, varargin, 'UniformOutput', false);
	br.point = horzcat(points{:});
end
