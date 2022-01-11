function mm = calcMatrixWordRepetitions(list, mm)

ll = [];
for i = 1:size(list,2)
    for j = 1:5
        num = str2num(list{i}(j));
        ll(i,j) = num;
        mm(num+1, j) = mm(num+1, j) + 1;
   end
end

% Check if unique
% isValid = true;
% for j = 1:5
%     wordCategory = ll(:,j);
%     if (size(unique(wordCategory), 1) < 10)
%         %disp(['Word category was repeated ', num2str(i)]);
%         isValid = false;
%         break;
%     end
% end

end