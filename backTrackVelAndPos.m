%%% BACKTRACKINGs

function [mostProbVel mostProbPos mostProbS] =  backTrackVelAndPos( endFrameDelta, allBackPointers,  numFeatureVectors, V, P )

S =2;
sizes = [V,P,S];

% mostProbDrumType = zeros(numFeatureVectors,1);
mostProbS = zeros(numFeatureVectors,1);
mostProbVel = zeros(numFeatureVectors,1);
mostProbPos = zeros(numFeatureVectors,1);


%%%%%% get most probable position and velocity state: 

% last state
[val, index ] = max(endFrameDelta);
lastFrame = numFeatureVectors;
[mostProbVel(lastFrame) mostProbPos(lastFrame) mostProbS(lastFrame)] = ind2sub(sizes, index);

% backtracking
for whichFrame=numFeatureVectors:-1:2
	
	
	prevIndex = allBackPointers(index,whichFrame);
	[mostProbVel(whichFrame-1) mostProbPos(whichFrame-1) mostProbS(whichFrame-1)] = ind2sub(sizes, prevIndex);

	index = prevIndex;
	
	
end



end

