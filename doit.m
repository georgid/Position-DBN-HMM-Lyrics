
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics');
% use data as loaded before
data;


%% construct query. for now this query is with different coefficient than
% query for subsequence-DTW
hasDeltas = 1;

tempoCoeff1 = 4;
tempoCoeff2 = 0.1;

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/matlab_htk');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyrics');
[queryPhonemesWithStates, targetPhonemes ] = lyrics2StatesNetwork(URI_wholeAudio_noExt, URI_score,  SECTION_NUM, tempoCoeff1, tempoCoeff2);


V = 5;
P = size(queryPhonemesWithStates,2);

withRealFeatures = 1;
withSilenceCutOff = 0;



%% create transMatrixFull


addpath('/Users/joro/Documents/Linz/drumsbBarModel/barmodelMIDIPositions_LAST/BarModelMidiBarPositions/train');
addpath('/Users/joro/Documents/Linz/drumsbBarModel/barmodelMIDIPositions_LAST/BarModelMidiBarPositions');

pr = 0.05;

pr = 0.2;

transMatrixFull = calcTransMatrixFull(V,P, pr);
 
%% decode
candSegments = dlmread('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics/candSegmentsTs.csv');

allWeights = [];
allStartFrames = [];
allEndFrames = [];


for i = 1:size(candSegments,2)
	startFr = candSegments(1,i);
	endFr = candSegments(2,i);
	[  decodedV decodedP decodedS tableObsProbs  ] = decodeOneCandSegment ( URI_targetNoExt, startFr, endFr, queryPhonemesWithStates, pathToModels, transMatrixFull,  V, hasDeltas, withRealFeatures, withSilenceCutOff );
	
	% rank by probs decoded with HHMM
	[ startResultFrames, endResultFrames, weights] = rankPaths( decodedP, decodedS, P, V, tableObsProbs );
	
	% for whole recording
	startResultFrames = startResultFrames + startFr - 1;
	endResultFrames = endResultFrames + startFr - 1;
	
	allWeights = [allWeights weights];
	allStartFrames = [ allStartFrames startResultFrames];
	allEndFrames = [allEndFrames endResultFrames];
	
	% visualize result . TODO:
	% 	visualizeResult()
end