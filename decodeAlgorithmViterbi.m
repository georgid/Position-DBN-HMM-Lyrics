% C is table with Maximaml state sequence till given time frame t
function [ endFrameDelta allBackpointers ]  = decodeAlgorithmViterbi( transMatrixFull, tableObsProbsResized, V, P)


% tableObsProbs = tableObsProbs(:,1:100);

S = 2;
sizes = [V,P,S];
dim = V*P*S;
% delta variable 
prevDelta = sparse(dim,1); 

% INITIALIZE delta

	
	% equally likely to start at any of first maxPosToStartAt positions.
	% and equally likely to start at s = 1,2
	% force to start at v=2
	maxStartPosition = 5;
	startVel = 2;
	maxStartSection = 2;
	vi(1:(maxStartPosition * maxStartSection)) = startVel;
	pi = [1:maxStartPosition 1:maxStartPosition];
	si(1:maxStartPosition)=1;
	si(maxStartPosition+1:maxStartPosition*maxStartSection)=2;
	
	idxes = sub2ind(sizes,vi,pi,si);
	prevDelta(idxes,1)  = 1/(maxStartPosition * maxStartSection);

	% this does not work % 	prevDelta  = normc(prevDelta);

 
numFeatureVectors = size(tableObsProbsResized,2);
allBackpointers = sparse(dim,numFeatureVectors);


%%%%%%%%% decoding
for whichFrame =1:numFeatureVectors
	
 	disp(fprintf('at iteration (frame) %d', whichFrame));

% 	[ currC, allBackpointersToPrevV(whichFrame,:,:), allBackpointersToPrevP(whichFrame,:,:) ] = ...
% 	decodeViterbi2(prevDelta , transMatrixFull, tableObsProbs, whichFrame, V,P);
%  	
	
	[ currDelta, allBackpointers(:,whichFrame)] = decodeViterbi2(prevDelta, transMatrixFull, tableObsProbsResized, whichFrame,  V, P);


	prevDelta = currDelta;
 	



end

endFrameDelta  = currDelta;




end
