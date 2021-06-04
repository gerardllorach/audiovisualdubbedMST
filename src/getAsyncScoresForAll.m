function sortedTable = getAsyncScoresForAll(pathCutAudios)

syncScores = {};
files = dir([pathCutAudios, '*.wav']);

aScores = [];
aOverTime = {};
fileNames = {};
sentenceCodes = {};

% Iterate all audio files
for i=1:length(files)
    
    %[ss, fs] = audioread('src/cutVideos/02064_Take1_Repetition2.wav');
    [ss, fs] = audioread([pathCutAudios, files(i).name]);
    [asyncScore, asyncOverTime] = computeAsyncScore(ss, fs, 1, files(i).name);

    % Store variables
    fileNames(i) = {files(i).name};
    sCode = strsplit(files(i).name,'_');
    sentenceCodes(i) = sCode(1);
    aScores(i) = asyncScore;
    aOverTime(i) = {asyncOverTime};
end

asyncScoresTable = table(sentenceCodes', fileNames', aScores', aOverTime', 'VariableNames',{'SentenceCode' 'FileName' 'AsyncScore', 'AsyncOverTime'});
sortedTable = sortrows(asyncScoresTable, [1,3]); % Sort by sentenceCode and then by asynScore


end