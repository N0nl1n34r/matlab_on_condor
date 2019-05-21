function brs = br_split(br, no)
	brs = cell(1, no);
	points = arr_split(br.point, no);
	for i = 1:no
		brs{i} = br;
		brs{i}.point = points{i};
	end
end