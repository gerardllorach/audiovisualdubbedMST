%% UTILITIES
% Extra scripts that can help with the material
%% Clean filenames
% Execute this script to change the name of the files.
addpath('src');
globalPaths;

extension = 'mp4';
filenames = dir([paths.FinalVideos, '*', extension]);

for i = 1:length(filenames)
    sName = filenames(i).name;
    cleanSentenceName = [sName(1:5), '.', extension]; % 5 digits per sentece
    movefile(sName, cleanSentenceName);
end

%% Create sentences lists
% In order to test the material, lists of 10, 20 or 30 sentences are
% sometimes required. These lists should contain sentences of 5 words. In a
% list, each sentence should be unique and each word should appear an equal
% amount of times.
addpath('utils')
addpath('src');
globalPaths; % paths.FinalVideos

% Creates lists of X number of sentences, making sure that each word is not
% repeated twice. Try with smaller numbers in numSentencePerList if 
% algorithm does not converge.
%createSentenceList('C:/myFolderWithVideos/', 'mp4', numSentencesPerList, numLists);
[uniqueLists, listTable] = createSentenceLists(paths.FinalVideos, 'mp4', 9, 10);
% The different combinations that are being tested are printed in the command window.

%% Combine lists
% From the lists found, create bigger lists. In the previous function, each
% sentence is used only once, therefore we can combine lists together.
% Find the best combination between the existing lists (each word should
% appear and repetitions should be avoided).
[combList, remainLists] = createTwoListBestCombination(uniqueLists);
% If there are more lists that remain, using them is smart, as the
% sentences used there are not present in the previous list

%% Add two sentences to a list
% If the sentences you have available are not enough to make combinations
% where each word appears once, you might want to add manually sentences
listPlusTwo = addTwoSentencesToList(listTable, combList); % Computation expense: totalNumSenteces x totalNumSentences
wordRepetitionMatrix = calcMatrixWordRepetitions(listPlusTwo, zeros(10,5));

%% Randomize order of the sentences
% Make that the same word is not consecutively used
permutedList = permutateOrderSentences(listPlusTwo);

%% Write the list in a file
% Check how many lists are available
% Select proper folder (10, 20 or 30 list)
%paths.SentenceLists
