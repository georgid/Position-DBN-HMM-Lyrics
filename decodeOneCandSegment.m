function [ decodedV decodedP decodedS tableObsProbs ] = decodeOneCandSegment ( URI_targetNoExt, startFr, endFr, queryPhonemesWithStates, pathToModels, transMatrixFull,  V, hasDeltas, withRealFeatures, withSilenceCutOff )


featureVectors = readMFCC_extractedWithHTK(URI_targetNoExt, hasDeltas, startFr, endFr);
tableObsProbs = calcSimMatrixLyrics(pathToModels,  queryPhonemesWithStates, featureVectors, hasDeltas, withRealFeatures, [], [], withSilenceCutOff);


P = size(queryPhonemesWithStates,2);

% multify each ObsProbs. V times, to prepare for matrix multiplication later.
% this op is expensive. do once
[ tableObsProbsResized] = prepareTableObsProbs( tableObsProbs, V);



%% decode 
[ endFrameDelta allBackPointers ]  =  decodeAlgorithmViterbi( transMatrixFull, tableObsProbsResized, V, P);
numFeatureVectors = size(tableObsProbs,2);

[decodedV decodedP decodedS]  =  backTrackVelAndPos( endFrameDelta, allBackPointers,  numFeatureVectors, V, P );


end

