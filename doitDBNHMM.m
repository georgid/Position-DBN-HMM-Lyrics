
function [allWeights, allStartFrames, allEndFrames] = doitDBNHMM( URI_scorePath, URI_wholeAudio_noExt, SECTION_NUM)

% URI_scorePath = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;
% URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';
% SECTION_NUM = 4
% doitDBNHMM( URI_scorePath, URI_wholeAudio_noExt, SECTION_NUM)


addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics');


%% construct query. for now this query is with different coefficient than
% query for subsequence-DTW
hasDeltas = 1;

tempoCoeff1 = 2;
tempoCoeff2 = 0.1;

pathToModels =  '/Users/joro/Documents/Phd/UPF/voxforge/auto/scripts/interim_files/';

addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/matlab_htk');
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyrics');


[queryPhonemesWithStates, targetPhonemes ] = lyrics2StatesNetwork(URI_wholeAudio_noExt, URI_scorePath,  SECTION_NUM, tempoCoeff1, tempoCoeff2);

phonemes_URI1 = [URI_scorePath   num2str(SECTION_NUM)  '.states_'  sprintf('%1.1f', tempoCoeff1)];
disp(phonemes_URI1)

addpath('..')
% parse stateNetworks
queryPhonemesWithStates = readTextFile(phonemes_URI1);

% [queryPhonemesWithStates, targetPhonemes ] = lyrics2StatesNetwork(URI_wholeAudio_noExt, URI_score,  SECTION_NUM, tempoCoeff1, tempoCoeff2);


V = 5;
P = size(queryPhonemesWithStates,2);

withRealFeatures = 1;
withSilenceCutOff = 0;



%% create transMatrixFull


% addpath('/Users/joro/Documents/Linz/drumsbBarModel/barmodelMIDIPositions_LAST/BarModelMidiBarPositions/train');
% addpath('/Users/joro/Documents/Linz/drumsbBarModel/barmodelMIDIPositions_LAST/BarModelMidiBarPositions');


phi = 0.2;
disp('calculating trans matrix');
transMatrixFull = calcTransMatrixFull(V,P, phi);
 
%% decode
URI_candidateSegmentsTs = [URI_wholeAudio_noExt  '_' num2str(SECTION_NUM)  '_candSegmentsTs.csv']
candSegments = dlmread(URI_candidateSegmentsTs);


allWeights = [];
allStartFrames = [];
allEndFrames = [];



for i = 1:size(candSegments,1)
	startFr = candSegments(i,1);
	endFr = candSegments(i,2);
	[  decodedV decodedP decodedS tableObsProbs  ] = decodeOneCandSegment ( URI_wholeAudio_noExt, startFr, endFr, queryPhonemesWithStates, pathToModels, transMatrixFull,  V, hasDeltas, withRealFeatures, withSilenceCutOff );
	
	% rank by probs decoded with HHMM
	[ startResultFramesCandSegment, endResultFramesCandSegment, weights] = rankPaths( decodedP, decodedS, P, V, tableObsProbs );
	
	% for whole recording
	startResultFrames = startResultFramesCandSegment + startFr - 1;
	endResultFrames = endResultFramesCandSegment + startFr - 1;
	
	allWeights = [allWeights weights]; 
	allStartFrames = [ allStartFrames startResultFrames]; 
	allEndFrames = [allEndFrames endResultFrames]; 
	
	% visualize result . TODO:
	% 	visualizeResult()
end

numFramesPerSec = 100.0;
allStartFrames = allStartFrames / numFramesPerSec;
allEndFrames = allEndFrames / numFramesPerSec;
% 
% allWeights = allWeights';
% allStartFrames = allStartFrames';
% allEndFrames = allEndFrames';

begins_URI = [URI_wholeAudio_noExt  '_' num2str(SECTION_NUM) '_results_begins.tsv'];
ends_URI = [URI_wholeAudio_noExt '_'  num2str(SECTION_NUM) '_results_ends.tsv'];
weights_URI = [URI_wholeAudio_noExt '_'  num2str(SECTION_NUM) '_results_weights.tsv'];

dlmwrite(begins_URI , allStartFrames);
dlmwrite(ends_URI, allEndFrames);
dlmwrite(weights_URI, allWeights);

end