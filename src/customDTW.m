function [dtw_distance, ix, iy] = customDTW(signalA, signalB, maxFrame2FrameCount)

% Signal structure should be (features, time)

% Length of signals
n = length(signalA);
m = length(signalB);

% Matrix filled with large values
dtw_matrix = inf(n,m);
% Initialize the path matrix to store the path indices
path = zeros(n, m, 2);

% Initialize first element of DTW matrix
dtw_matrix(1,1) = eucDistance(signalA(:, 1), signalB(:, 1));
path(1, 1, :) = [0, 0]; % Start of the path


% Fill the first row of the DTW matrix
for i = 2:n
    cost = eucDistance(signalA(:, i), signalB(:, 1));
    dtw_matrix(i, 1) = cost + dtw_matrix(i-1, 1);
    path(i, 1, :) = [i-1, 1];
end

% Fill the first column of the DTW matrix
for j = 2:m
    cost = eucDistance(signalA(:, 1), signalB(:, j));
    dtw_matrix(1, j) = cost + dtw_matrix(1, j-1);
    path(1, j, :) = [1, j-1];

end


% Fill in the rest of the DTW matrix
for i = 2:n
    for j = 2:m
        cost = eucDistance(signalA(:, i), signalB(:, j));
        [min_cost, min_idx] = min([dtw_matrix(i-1, j), dtw_matrix(i, j-1), dtw_matrix(i-1, j-1)]);
        dtw_matrix(i, j) = cost + min_cost;

        if min_idx == 1
            path(i, j, :) = [i-1, j];
        elseif min_idx == 2
            path(i, j, :) = [i, j-1];
        else
            path(i, j, :) = [i-1, j-1];
        end
    end
end

 % The DTW distance is the value in the bottom-right corner of the matrix
 dtw_distance = dtw_matrix(n, m);


 % Backtrack to find the minimum cost path
i = n;
j = m;
min_cost_path_indices = [i, j];

countI = 0;
countJ = 0;
while i > 1 || j > 1
    prev_i = path(i, j, 1);
    prev_j = path(i, j, 2);
    min_cost_path_indices = [prev_i, prev_j; min_cost_path_indices];

    % Check if the frame is reused
    if (i == prev_i)
        countI = countI + 1;
    else
        countI = 0;
    end
    if (j == prev_j)
        countJ = countJ + 1;
    else
        countJ = 0;
    end

    % Remove 1 if exceeded the maxFrame2FrameCount (limits the number of times
    % a frame can be assigned to other ones). while loop goes from n,m to 1
    if (countI >= maxFrame2FrameCount-1)
        prev_i = max(1,prev_i - 1);
        countI = 0;
    end
    if (countJ >= maxFrame2FrameCount-1)
        prev_j = max(1,prev_j - 1);
        countJ = 0;
    end

    i = prev_i;
    j = prev_j;
end
path = min_cost_path_indices;

ix = path(:,1);
iy = path(:,2);

end



function value = eucDistance(a, b)

 value = sqrt(sum((a-b).*(a-b)));

end

