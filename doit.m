
% SDTW
URI_score = '/Users/joro/Documents/Phd/UPF/turkish-makam-lyrics-2-audio-test-data/ussak--sarki--aksak--bu_aksam_gun--tatyos_efendi/' ;
URI_wholeAudio_noExt = '/Users/joro/Documents/Phd/UPF/ISTANBUL/idil/Sakin--Gec--Kalma';
SECTION_NUM = 2

addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/queryByLyricsVsLyrics/')
addpath('/Users/joro/Documents/Phd/UPF/voxforge/myScripts/lyrics_magic/')
doitSDTWParams(URI_score, URI_wholeAudio_noExt, SECTION_NUM)

% cand segments
command = [ '/usr/local/bin/python /Users/joro/Documents/Phd/UPF/voxforge/myScripts/SearchByLyricsEval/CandSegmentMerger.py ' URI_wholeAudio_noExt ' ' num2str(SECTION_NUM)];
system(command)

% position DBN-HMM
doitDBNHMM( URI_score, URI_wholeAudio_noExt, SECTION_NUM)