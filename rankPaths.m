function [ startFrames, endFrames, weights] = rankPaths( decodedP, decodedS, maxPos, maxVel, tableObsProbs)
% when there is a restart of position, consider as new section. 

% 2 is query section
timeFrameIdxs = find(decodedS == 2);
positionS2 = decodedP(timeFrameIdxs);

% list of weights
weights = [];

currWeight = 0;

prevPos = 0;

pathLength = 0;

startFrames = timeFrameIdxs(1);
endFrames = [];

% find timeframes 
for i=1:size(timeFrameIdxs,1)
	
	currTimeFrame = timeFrameIdxs(i);
	currPos = positionS2(i);
	
	% check here for restart of query section
	if currPos <= prevPos
		% make sure end of section reached
			
			if prevPos > maxPos - maxVel -1 
				fprintf('final pos %d', prevPos); 
				currWeight = currWeight / pathLength;
				weights = [weights currWeight];
% 				currWeight = sprintf('%.30f', currWeight)

				endFrames = [endFrames timeFrameIdxs(i-1)];
				startFrames = [startFrames currTimeFrame];


			end
			
			% reset
			currWeight = 0;
			pathLength = 0;
	% only if a S2 path finishes at last frame
	elseif i == size(timeFrameIdxs,1) 
			
			if currPos > maxPos - maxVel -1
				fprintf('final pos %d', prevPos); 
				currWeight = currWeight / pathLength;
% 				currWeight = sprintf('%.30f', currWeight)

				weights = [weights currWeight];
				endFrames = [endFrames timeFrameIdxs(i-1)];
				

			end
			
	
	end
	
	currWeight = currWeight + tableObsProbs(currPos, currTimeFrame);
	
	% increments: 
	prevPos = currPos;
	pathLength = pathLength + 1;
end

% make sure same lengths
lEnds = length(endFrames);
startFrames = startFrames(1:lEnds);


end

