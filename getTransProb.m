% wrapper to get the actual probability as if transMatrix were 
% full 4-D matrix done,
% This is done becasue trans matrix is sparse => if full 4-D matrix done becomes too big

function transProb = getTransProb(transMatrix, fromV,fromP,fromS, toV,toP, toS)

transProb =0;

% first possible target point
if(toV==transMatrix(fromV,fromP, fromS, 1,1,1) && toP==transMatrix(fromV,fromP,fromS, 1,1,2) && toS==transMatrix(fromV,fromP, fromS, 1,1,3) )
	transProb =transMatrix(fromV,fromP,fromS, 1,1,4);
% second possible point
elseif (toV==transMatrix(fromV,fromP, fromS, 2,1,1) && toP==transMatrix(fromV,fromP,fromS, 2,1,2) && toS==transMatrix(fromV,fromP, fromS, 2,1,3) )
	transProb =transMatrix(fromV,fromP,fromS, 2,1,4);
	% third possible point
elseif (toV==transMatrix(fromV,fromP, fromS, 3,1,1) && toP==transMatrix(fromV,fromP,fromS, 3,1,2) && toS==transMatrix(fromV,fromP, fromS, 3,1,3) )
	transProb =transMatrix(fromV,fromP,fromS, 3,1,4);

elseif (toV==transMatrix(fromV,fromP, fromS, 1,2,1) && toP==transMatrix(fromV,fromP,fromS, 1,2,2) && toS==transMatrix(fromV,fromP, fromS, 1,2,3) )
	transProb =transMatrix(fromV,fromP,fromS, 1,2,4);

elseif (toV==transMatrix(fromV,fromP, fromS, 2,2,1) && toP==transMatrix(fromV,fromP,fromS, 2,2,2) && toS==transMatrix(fromV,fromP, fromS, 2,2,3) )
	transProb =transMatrix(fromV,fromP,fromS, 2,2,4);

elseif (toV==transMatrix(fromV,fromP, fromS, 3,2,1) && toP==transMatrix(fromV,fromP,fromS, 3,2,2) && toS==transMatrix(fromV,fromP, fromS, 3,2,3) )
	transProb =transMatrix(fromV,fromP,fromS, 3,2,4);
	
	
else transProb =0;
	
end

	
end
