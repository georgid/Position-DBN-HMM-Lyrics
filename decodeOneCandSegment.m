function [ decodedV decodedP decodedS tableObsProbs ] = decodeOneCandSegment ( URI_targetNoExt, startFr, endFr, queryPhonemesWithStates, pathToModels, transMatrixFull,  V, hasDeltas, withRealFeatures, withSilenceCutOff )
% 1. precomputes and prepares observation probability table  
% 2. decodes with Viterbi the meta-state-space (cartesian product of V-, P- and S-states spaces) 
% 3. makes sence of decoded sequence of meta-state-space
%%%% retunrs
%%%%  decodedV - sequence of velocity states
%%%%  decodedP - sequence of position states
%%%%% decodedS - sequence of section (0 -Query or 1- Filler)

featureVectors = readMFCC_extractedWithHTK(URI_targetNoExt, hasDeltas, startFr, endFr);
tableObsProbs = calcSimMatrixLyrics(pathToModels,  queryPhonemesWithStates, featureVectors, hasDeltas, withRealFeatures, [], [], withSilenceCutOff);


P = size(queryPhonemesWithStates,2);

% 1. multify each ObsProbs. V times, to prepare for matrix multiplication later.
% this op is expensive. do once
[ tableObsProbsResized] = prepareTableObsProbs( tableObsProbs, V);



%% 2. decode with Viterbi
[ endFrameDelta allBackPointers ]  =  decodeAlgorithmViterbi( transMatrixFull, tableObsProbsResized, V, P);
numFeatureVectors = size(tableObsProbs,2);

%% 3. 
[decodedV decodedP decodedS]  =  backTrackVelAndPos( endFrameDelta, allBackPointers,  numFeatureVectors, V, P );


end

