function getAsyncScoresForAll(pathCutAudios)

files = dir([pathCutAudios, '*.wav']);

% Iterate all audio files
for i=1:length(files)
    
    %[ss, fs] = audioread('src/cutVideos/02064_Take1_Repetition2.wav');
    [ss, fs] = audioread([pathCutAudios, files(i).name]);
    [asyncScore, asyncOverTime] = computeAsyncScore(ss, fs, 1);

end

end