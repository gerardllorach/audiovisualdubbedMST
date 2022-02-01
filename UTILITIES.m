%% UTILITIES
% Extra scripts that can help with the material and the experimental
% testing
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
[uniqueLists, listTable] = createSentenceLists(paths.FinalVideos, 'mp4', 9, 20);
% The different combinations that are being tested are printed in the command window.

    %% Combine lists
    % From the lists found, create bigger lists. In the previous function, each
    % sentence is used only once, therefore we can combine lists together.
    % Find the best combination between the existing lists (each word should
    % appear and repetitions should be avoided).
    [combList, remainLists] = createTwoListBestCombination(uniqueLists);
    % If there are more lists that remain, using them is smart, as the
    % sentences used there are not present in the previous list. Once you
    % store the previous list, you use this line to create another list.
    %[combList, remainLists] = createTwoListBestCombination(remainLists);

    %% Add two sentences to a list
    % If the sentences you have available are not enough to make combinations
    % where each word appears once, you might want to add manually sentences
    listPlusTwo = addTwoSentencesToList(listTable, combList); % Computation expense: totalNumSenteces x totalNumSentences
    wordRepetitionMatrix = calcMatrixWordRepetitions(listPlusTwo, zeros(10,5));

    %% Randomize order of the sentences
    % Make that the same word is not consecutively used
    permutedList = permutateOrderSentences(listPlusTwo);

    %% Write 18+2 list in a file
    numList = 1;
    writeSentenceListToFile(permutedList, numList, paths.SentenceLists)


    %% Semibalanced creation script
    % Automatically execute past scripts to generate several lists
    numLists = 20;
    numList = 1;
    while (numList < numLists)
        [remainLists, listTable] = createSentenceLists(paths.FinalVideos, 'mp4', 9, 20);
        while (size(remainLists,1) > 1)
            [combList, remainLists] = createTwoListBestCombination(remainLists);
            listPlusTwo = addTwoSentencesToList(listTable, combList);
            permutedList = permutateOrderSentences(listPlusTwo);
            writeSentenceListToFile(permutedList, numList, paths.SentenceLists);
            numList = numList + 1;
        end
    end
    

%% Write the list in a file
% Check how many lists are available
% Select proper folder (10, 20 or 30 list)
writecell(uniqueLists, [paths.SentenceLists, 'list10All.txt']);

for i = 1:size(uniqueLists, 1)
    permList = permutateOrderSentences(uniqueLists(i,:));
    writecell(permList', [paths.SentenceLists, 'list10.', num2str(i) ,'.txt']);
end

%% Create 20 sentence lists from 10 sentence lists
% Random combinations of 10 sentence lists
load('finalListsFromFrenchAudios.mat'); % uniqueLists
combinations = [
    1 2; 3 4; 5 6; 7 8; 9 10; 11 12; 13 14;
    1 3; 5 7; 2 4; 6 8; 7 9; 13 15; 10 11; 11 12; 
    1 4; 3 6; 14 15; 7 10; 2 5; 8 11; 9 12; 10 13; 
    1 5; 2 6; 10 15; 3 7; 4 8; 9 14;  11 1; 12 2; 13 3;
    4 10; 6 12; 5 11; 7 13; 8 14; 9 15; 1 6; 2 10; 3 11;
    7 15; 4 12; 5 13; 6 14; 
    ];

for i = 1:size(combinations, 1)
    idx1 = combinations(i,1);
    idx2 = combinations(i,2);
    list20 = [uniqueLists(idx1,:) uniqueLists(idx2,:)]; % Merge 10 sentence lists
    list20perm = permutateOrderSentences(list20); % Randomize order of sentences
    writecell(list20perm', [paths.SentenceLists, 'list20.', num2str(i) ,'.txt']); % Store to file
end

%% Compare missing
load('finalListsFromFrenchAudios.mat'); % uniqueLists
pathVideos = 'C:\Users\gllor\Desktop\Oldenburg\AVMST\AVMST_French\videos\female\';
filenames = dir([pathVideos, '*', 'mp4']);
vidNames = {filenames.name};

allSentences = reshape(uniqueLists, [150,1]);
result = {};

for i = 1:150
isFound = sum(sum(ismember(vidNames,{[allSentences{i}(1:5),'.mp4']})));
result(i,:) = [allSentences{i} {isFound}];
end

result((cell2mat(result(:,2)) == 0), 2) = {'MISSING'};