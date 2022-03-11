function [asyncScore, asyncOverTime] = computeAsyncScore(signal, fs, channelOriginal, sentenceName)

% Separate signals
ssOriginal = signal(:, channelOriginal);
otherChannel = mod(channelOriginal,2) + 1; % = channelOriginal == 1 ? 2 : 1;
ssRecorded = signal(:, otherChannel);

% Compute the mel spectograms using voicebox
% https://github.com/ImperialCollegeLondon/sap-voicebox/blob/master/voicebox/v_spgrambw.m
[T, F, melSpecOriginal] = v_spgrambw(ssOriginal, fs, 'm');
[T, F, melSpecRecorded] = v_spgrambw(ssRecorded, fs, 'm');
% Transformation from frame to seconds
% Check inside the v_spgrambw. Line 36
frame2sec = 0.45/200; % tinc = 0.45/BW = window increments; BW = bandwidth in Hz = 200;


% Compute Dynamic Time Warping
% https://www.mathworks.com/help/signal/ref/dtw.html
[dist,ix,iy] = dtw( melSpecRecorded', melSpecOriginal');


% Compute asynchrony over time (turn the warping path 45º, so it only represents
% asynchrony
asyncOverTime = (iy - ix)*frame2sec;

%  Compute asynchrony score and extreme values
asyncScore = sqrt(mean((asyncOverTime).^2));
maxVidBehind = min(asyncOverTime); % Below -45 ms is noticed
maxVidAhead = max(asyncOverTime); % Above 200 ms is noticed

% Plot asynchrony over time
plotAsync(asyncOverTime, asyncScore, maxVidBehind, maxVidAhead, frame2sec, sentenceName)

end


% Plot the asynchrony score with thresholds
function plotAsync(asyncOverTime, asyncScore, maxVidBehind, maxVidAhead, frame2sec, sentenceName)

% Inside thresholds
inSafeRange = asyncOverTime; % Async is inside the safe range
xAxisSafe = frame2sec*(1:length(asyncOverTime));
xAxisSafe(inSafeRange > 0.200 | inSafeRange < -0.045) = NaN;
inSafeRange(inSafeRange > 0.200 | inSafeRange < -0.045) = NaN;

% Outside thresholds
outSafeRange = asyncOverTime; % Async is outside the safe range
xAxisNotSafe = frame2sec*(1:length(asyncOverTime));
xAxisNotSafe(~isnan(inSafeRange)) = NaN;
outSafeRange(~isnan(inSafeRange)) = NaN;

% Plot the values
figure
plot(xAxisSafe, inSafeRange, 'LineWidth', 1.5, 'Color', 'k');
hold on
plot(xAxisNotSafe, outSafeRange, 'LineWidth', 1.5, 'Color', 'red');
hold off

%figure
%plot( frame2sec * (1:length(asyncOverTime)), asyncOverTime, 'LineWidth', 2, 'Color', 'red');
title({['Asynchrony over time for ', sentenceName],...
    ['Asynchrony score: ', num2str(asyncScore, '%.3f'),'s '],...
    ['Video ahead: ',num2str(maxVidAhead, '%.3f'), 's. Video behind: ', num2str(maxVidBehind, '%.3f'), 's.']},...
    'Interpreter', 'none');
ylabel('Asynchrony in seconds');
xlabel('Time in seconds');
ylim([-0.3 0.3]);
refline(0,0);
hline = refline(0,0.2);
hline.LineWidth = 0.3;
hline.Color = 'k';
hline = refline(0,-0.045);
hline.LineWidth = 0.3;
hline.Color = 'k';

set(gca, 'YGrid', 'on');

end
