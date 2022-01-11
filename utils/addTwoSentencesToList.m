function listPlusTwo = addTwoSentencesToList(listTable, combList)
%% Additional sentences to a list
% This can happen when the first part of the algorithm does not converge
% If sentences are not complete (not enough sentences to create equal
% combinations), find two sentences in the set that minimize zeros and ones
weights = ones(height(listTable), height(listTable))*1000;
for i = 1:height(listTable)
    % Find a sentence that does not exists in the current list
    sNameI = listTable{i, 'Filename'};
    % Check if it exists already
    if (ismember(combList, sNameI))
        continue;
    end
    for j = 1:height(listTable)
        if (i==j) % Do not use twice the same sentence
            continue;
        end
        sNameJ = listTable{j, 'Filename'};
        % Check if it exists already
        if (ismember(combList, sNameJ))
            continue;
        end
        % Store the new word usage matrix
        m = calcMatrixWordRepetitions([combList, sNameI, sNameJ], zeros(10,5));
        numZeros = sum(sum(m==0));
        numOnes = sum(sum(m==1));
        numAboveThree = sum(sum(m>3));
        % Calculate the weight. We give more importance to zeros than ones
        weight = numZeros*4 + numAboveThree*4;
        % Store weight
        weights(i,j) = weight;
    end
end


minValue = min(weights(:));
[rows, columns] = find(weights == minValue);
% Additional sentence
sAdd1 = listTable{rows(1),'Filename'};
sAdd2 = listTable{columns(1),'Filename'};

listPlusTwo = [combList, sAdd1, sAdd2];


end
