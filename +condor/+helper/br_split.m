function brs = br_split(br, no)
% CONDOR.HELPER.ARR_SPLIT(br, no) splits the branch br into no approximatly
% equal large parts.
%
% INPUT br: The branch which should be split into parts.
%       no: The number of parts the branch should be split into.
%
% OUTPUT split: A cell array where each element is an branch which is one
%               part of the input branch.
%
% EXAMPLES 
%        br = struct('point', 1:10);
%        brs = condor.helper.br_split(br, 3);
%        brs{1}.point % should return 1:3
%        brs{2}.point % should return 4:6
%        brs{3}.point % should return 7:10
%
% See also CONDOR.HELPER.BRS_JOIN
%
% created with MATLAB ver.: 9.5.0.944444 (R2018b) on Debian GNU/Linux
% Version: 9 (stretch)
%
% created by: Denis Hessel, d.hessel@wwu.de
% DATE: 05-June-2019

	brs = cell(1, no);
	points = condor.helper.arr_split(br.point, no);
	for i = 1:no
		brs{i} = br;
		brs{i}.point = points{i};
	end
end