function [ tableObsProbsResized] = prepareTableObsProbs( tableObsProbs, V)
% resize to be in format v*p* for efficient multiplication
%   Detailed explanation goes here

tableObsProbsResized = [];

for row = 1:size(tableObsProbs,1)
	rows = repmat(tableObsProbs(row,:),V,1);
	tableObsProbsResized = vertcat(tableObsProbsResized, rows);
end

end

