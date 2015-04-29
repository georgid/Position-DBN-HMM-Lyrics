
% decodes the drum type. 
% returns index of prob.with highest prob. 
function [ currC, backPointerV, backPointerP ] = decodeViterbi(prevC, transMatrixFull, tableObsProbs, whichFrame,  V, P)

S = 2; 
D = size(tableObsProbs,1);

	% pointer to prev. V state 
	backPointerV = zeros(V,P);
	% pointer to prec. P state
	backPointerP = zeros(V,P);

% INITIALIZE: put probs as A table
if (whichFrame == 1)
	A = zeros(V,P);

	% equally likely to start at any of first maxPosToStartAt positions.
	% force to start at v=2
	maxPosToStartAt = 10;
	startAtVel = 2;
	A(2,1:maxPosToStartAt) = 1/(maxPosToStartAt*1);


else 
	%create table A. It is table C (delta table) multiplied by transProbs 
	[A, backPointerV, backPointerP]  = calcATableViterbi(prevC, transMatrixFull);
end



%%%%%%%%%%% calc curr table C
currC = zeros(V,P);


% % with obsProb table of one probability for one state
% 
% for p = 1:P
% whichState = mapPosition(p);
% currC(:,p) = A(:,p) .* tableObsProbs(whichState,whichFrame);
% end


	% with obsProb table of repeating states . being read from python

if size(tableObsProbs,1) ~= P
		error(sprintf('tableObsProbs has %d rows, but expected positions are %d', size(tableObsProbs,1), P));
end


for v = 1:V
currC(v,:) = A(v,:) .* tableObsProbs(:,whichFrame)';
% currC(v,:) = A(v,:);
end


% here normalize currC
currC = normalize(currC);

% check 
% if any(any(currC))
% 	disp(fprintf('C is all zeros at iteration (frame): %d \n', whichFrame));
% end





end



% normalization for a matrix of probs. 

function probsMatrix = normalize(probsMatrix)

totalSumProbs = sum( sum ( probsMatrix ) );
probsMatrix = probsMatrix/totalSumProbs;

end