function [lists, listTable] = createSentenceLists(pathVideos,extension, numSentencesList, numLists)
% Create a table with filenames
filenames = dir([pathVideos, '*', extension]);

% Table variables
varTypes = ["string","double","double", "double","double","double","double", "double"];
varNames = ["Filename","TimesUsed","NoCombination","PosOne", "PosTwo", "PosThree",...
    "PosFour", "PosFive"];
listTable = table('Size',[length(filenames) length(varTypes)],'VariableTypes',varTypes,'VariableNames',varNames);
listTable.Filename = {filenames.name}';


% Assign values to table
for i=1:length(filenames)
   % Write the word number in the table
   nameTable = listTable{i,'Filename'}{1,1};
   listTable(i,'PosOne') = {str2num(nameTable(1))};
   listTable(i,'PosTwo') = {str2num(nameTable(2))};
   listTable(i,'PosThree') = {str2num(nameTable(3))};
   listTable(i,'PosFour') = {str2num(nameTable(4))};
   listTable(i,'PosFive') = {str2num(nameTable(5))};
end



% List
lists = {};
% Number of sentences per list (reduce if algorightm does not converge)
%numSentencesList = 9; % 10, 20


% Creates lists of "numSentencesList" sentences. The lists do not contain
% sentences that were used previouly used in the other lists.
for xx = 1:numLists % Number of lists
    mm = zeros(10,5);
    % While operator
    wordNum = 1;
    breakFlag = 0;% Double break
    discardedSentences = cell(1,numSentencesList);% At each position, store the sentences that do not fit with the previous sentence
    % Initialize list
    for ii = 1:numSentencesList
       lists(xx,ii) = {''}; 
    end
    while (wordNum < numSentencesList+1)
    	
        % Get sentences starting with a given number
        availableSentences = listTable(listTable{:,'PosOne'} == mod((wordNum-1),10) & listTable{:,'TimesUsed'} == 0 & listTable{:,'NoCombination'} == 0,:);
        % Random order of sentences
        randIndx = randperm(height(availableSentences), height(availableSentences));
        %randIndx = 1:height(availableSentences);
        %randIndx = height(availableSentences):-1:1;
        

        selCode = '00000';
        for j = 1:height(availableSentences)
            ri = randIndx(j);
            sentenceCode = availableSentences(ri,:).Filename{1,1};
            % Check if a word was used in a category
            count = 0;
            
            for i=1:5
                if(mm(str2num(sentenceCode(i))+1, i) == ceil(numSentencesList/10))
                    %disp("Word was used already in that category");
                    count = count + 1;
                    discardedSentences(j, wordNum) = {sentenceCode};
                    % Add NoCombination = 1 to listTable
                    listTable(ismember(listTable{:,'Filename'},sentenceCode),'NoCombination') = {1};                    break;
                end
                if (i == 5)
                   %disp("Win");
                   %disp(num2str(count));
                   %disp(sentenceCode);
                   selCode = sentenceCode;
                   breakFlag = 1;
                   break;
                end
            end
            if (breakFlag)
                breakFlag = 0;
               break; 
            end
        end

        % If selCode is '00000', go back
        % Dead end
        if (ismember(selCode, '00000'))
           % Unmark current available
           for dd = 1:size(discardedSentences(:,wordNum), 1)
               if (isa(discardedSentences{dd,wordNum},'double'))
                   continue;
               end
               %listTable(ismember(listTable{:,'Filename'},discardedSentences{dd,wordNum}),'NoCombination') = {0};
               listTable(listTable{:,'PosOne'} == mod((wordNum-1),10),'NoCombination') = {0};
           end
           discardedSentences(:,wordNum) = {''};
           % Reduce word number
           wordNum = wordNum -1;
           if (wordNum == 0)
               disp(["No more combinations available. ", num2str(size(lists, 1)), ' lists found.']);
               % Remove last row of list
               lists(xx,:) = [];
               return;
           end
           % Mark current unavailable due to path
           for dd = 1:size(discardedSentences(:,wordNum), 1)
               if (isa(discardedSentences{dd,wordNum},'double'))
                   continue;
               end
               listTable(ismember(listTable{:,'Filename'},discardedSentences{dd,wordNum}),'NoCombination') = {1};
           end
           % Remove from matrix and list
           prevCode = lists{xx,wordNum};
           lists(xx,wordNum) = {''};
           % Mark prevCode as unavailable
           listTable(ismember(listTable{:,'Filename'},prevCode),'NoCombination') = {1};
           % Remove from the matrix
            for i=1:5
                mm(str2num(prevCode(i))+1, i) = mm(str2num(prevCode(i))+1, i) - 1;
            end
            % Unmark as used
            listTable(ismember(listTable{:,'Filename'},prevCode),'TimesUsed') = {0};

            
            % Display up and downs
            availableSentences = listTable(listTable{:,'PosOne'} == mod((wordNum-1),10) & listTable{:,'TimesUsed'} == 0 & listTable{:,'NoCombination'} == 0,:);
            disp([strrep(cell2mat(lists(xx,:)), extension,''), num2str(size(availableSentences,1))]);

            
           continue;
        end
        

        % Mark it on the matrix
        for i=1:5
            mm(str2num(selCode(i))+1, i) = mm(str2num(selCode(i))+1, i) + 1;
        end
        % Mark it on the table
        listTable(ismember(listTable{:,'Filename'}, {selCode}),'TimesUsed') = {1};
        % Store it in list
        lists(xx,wordNum) = {selCode};
        % Go for next sentence
        % Add to wordNum
        wordNum = wordNum + 1;
        
        % Display up and downs
        %disp(strrep(cell2mat(list20(xx,:)), extension,''));
    end
    
end

cell2table(lists')
end

