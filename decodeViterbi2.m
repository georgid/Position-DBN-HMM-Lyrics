
% decodes the drum type. 
% returns index of prob.with highest prob. 

% @param: prevDelta v*p*s x 1 vector 

function [ currDelta, backPointer] = decodeViterbi2(prevDelta, transMatrixFull, tableObsProbs, whichFrame,  V, P)

S =2;
sizes = [V,P,S];
dim = V*P*S;

if whichFrame == 1 % take init probs
	maxAbyDelta = prevDelta; 
	backPointer = sparse(dim,1);
else
	prevDeltaMat = diag(prevDelta);
	AbyDelta = prevDeltaMat * transMatrixFull;

	[maxAbyDeltaT , backPointerT]  = max(AbyDelta); 
	% maxValPrevStates is 1 x v*p*s vector	
	maxAbyDelta = maxAbyDeltaT';
	backPointer = backPointerT';

end



%%%%%%%%%% multiply by obs Probs
currDelta = sparse(dim,1);

silenceProb = tableObsProbs(end,whichFrame); 


s = 2;

fromIdx = sub2ind(sizes, 1,1,s);
toIdx = sub2ind(sizes, V,P,s);

currDelta(fromIdx:toIdx) = maxAbyDelta(fromIdx:toIdx) .* tableObsProbs(:,whichFrame); 

s =1; 

fromIdx = sub2ind(sizes, 1,1,s);
toIdx = sub2ind(sizes, V,P,s);

currDelta(fromIdx:toIdx) = maxAbyDelta(fromIdx:toIdx) .* silenceProb;



%%%% underflow check 
% if any(tableObsProbs(:,1)) ~= 1
%  error(sprintf('at time %d there is zero obs. prob.  ', whichFrame));
% 
% else % underflow check possilbe only if no obs zero prob.
% idxNonSil = find(maxAbyDelta);
% idxNonSilAfterMult = find(currDelta);
% if ~isequal(idxNonSil, idxNonSilAfterMult)
% 	error(sprintf('underflow at time %d there is zero obs. prob.  ', whichFrame))
% end
% end

	
	

% for v=1:V
% 	for p = 1:P
% 		s = 2;
% 		idx = sub2ind(sizes, v,p,s);
% 		if maxAbyDelta(idx) ~= 0
% 			 currDelta (idx) = maxAbyDelta (idx) * tableObsProbs(p,whichFrame); 
% 			 if tableObsProbs(p,whichFrame) ~= 0 && currDelta (idx) == 0
% 				 disp(fprintf('underflow at time %d at delta with index %d',whichFrame, idx));
% 			 end
% 		end
% 		
% 		s = 1;
% 		idx = sub2ind(sizes, v,p,s);
% 		if maxAbyDelta (idx) ~= 0
% 			 currDelta (idx) = maxAbyDelta (idx) * silenceProb; 
% 			 
% 			 if tableObsProbs(p,whichFrame) ~= 0 && currDelta (idx) == 0
% 				 disp(fprintf('underflow at time %d at delta with index %d',whichFrame, idx));
% 			 end
% 		end
% 		
% 	end
% end


currDelta = normalize(currDelta);

end


% normalization for a matrix of probs. 

function probsVectorNorm = normalize(probsVector)

totalSumProbs = sum( probsVector  );
probsVectorNorm = probsVector/totalSumProbs;

end