function permutedList = permutateOrderSentences(inputList)
%% Randomize order of the sentences
% Make that the same word is not consecutively said
permutedList = {};
for numTries = 1:1000
    inputList = inputList(randperm(size(inputList,2)));
    numericalList=[];
    for i = 1:size(inputList,2)
        for j = 1:5
            num = str2num(inputList{i}(j));
            numericalList(i,j) = num;
       end
    end
    % Combination were no words are said consecutively
    if(sum(sum(diff(numericalList)==0)) == 0)
        permutedList = inputList;
        return;
    end
end
disp('A combination was not found without consecutive words');

end

