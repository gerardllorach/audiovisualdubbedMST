function [combList, uniqueLists] = createTwoListBestCombination(uniqueLists)

mInit = zeros(10,5); % 10 words per 5 word categories

% Automatize best combination (tries that every word is said)
for i=1:size(uniqueLists,1) % Num lists
    mI = calcMatrixWordRepetitions(uniqueLists(i,:), mInit);
    for j=1:size(uniqueLists,1)
        mJ = calcMatrixWordRepetitions(uniqueLists(j,:), mI);
        mTotalZeros(i,j) = sum(sum(mJ==0));
    end
end
% Find best combination
minValue = min(mTotalZeros(:));
[rows, columns] = find(mTotalZeros == minValue);

% Lists to add together:
combList = [uniqueLists(rows(1),:), uniqueLists(columns(1),:)];

uniqueLists([rows(1) columns(1)],:) = [];

end

