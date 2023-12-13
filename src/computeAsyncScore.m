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

% Plot mel spectrogram
% figure
% subplot(2,1,1)
% v_spgrambw(ssRecorded, fs, 'PJcwm');
% title('Recorded audio')
% subplot(2,1,2)
% v_spgrambw(ssOriginal, fs, 'PJcwm');
% title('Original audio')
% print(gcf,['Melspec', '.png'],'-dpng','-r300');

% Compute Dynamic Time Warping
% https://www.mathworks.com/help/signal/ref/dtw.html
% [dist,ix,iy] = dtw( melSpecRecorded', melSpecOriginal');
[dist,ix,iy] = customDTW( melSpecRecorded', melSpecOriginal', 3);


% Compute asynchrony over time (turn the warping path 45º, so it only represents
% asynchrony
asyncOverTime = (iy - ix)*frame2sec;

%  Compute asynchrony score and extreme values
asyncScore = sqrt(mean((asyncOverTime).^2));
maxVidBehind = min(asyncOverTime); % Below -45 ms is noticed
maxVidAhead = max(asyncOverTime); % Above 200 ms is noticed


figure('Position', [100, 100, 800, 600]);
subplot(2,1,1)
plotDTWLines(ssOriginal, ssRecorded, fs, frame2sec, ix, iy, sentenceName, asyncScore, maxVidBehind, maxVidAhead);
title({['Time misalignment score: ', num2str(asyncScore, '%.3f'),'s '],...
    ['Max. recorded audio ahead-of-time: ',num2str(abs(maxVidAhead), '%.3f'), 's. Max. recorded audio behind-time: ', num2str(abs(maxVidBehind), '%.3f'), 's.']},...
        'Interpreter', 'none');

% Plot asynchrony over time
subplot(2,1,2)
plotAsync(asyncOverTime, asyncScore, maxVidBehind, maxVidAhead, frame2sec, sentenceName)

end






% Plot the DTW lines between the two signals
function plotDTWLines(ssOriginal, ssRecorded, fs, frame2sec, ix, iy, sentenceName, asyncScore, maxVidBehind, maxVidAhead)
    %figure('Position', [100, 100, 2000, 300]);
    % Plot recorded signal
    tt = (0:(length(ssRecorded)-1))/fs;
    plot(tt, ssRecorded/max(abs(ssRecorded)) + 1);
    hold on
    % Plot original signal
    tt = (0:(length(ssOriginal)-1))/fs;
    plot(tt, ssOriginal/max(abs(ssOriginal)) - 1);
    
    for i=1:4:size(ix,1)
        distance = iy(i)*frame2sec - ix(i)*frame2sec;
        if (distance > 0.2 || distance < -0.045)
            plot([ix(i)*frame2sec iy(i)*frame2sec], [1 -1], 'Color', [1 0 0 0.66], 'LineWidth', 0.2);
        else
            plot([ix(i)*frame2sec iy(i)*frame2sec], [1 -1], 'Color', [0 0 0 0.66], 'LineWidth', 0.2);
        end
    end

    % Title
%     title({['Sentence code: ', sentenceName],...
%         ['Asynchrony score: ', num2str(asyncScore, '%.3f'),'s '],...
%         ['Max. video ahead: ',num2str(maxVidAhead, '%.3f'), 's. Max. video behind: ', num2str(maxVidBehind, '%.3f'), 's.']},...
%         'Interpreter', 'none');
    
    % Y label
    yticks([-1, 0, 1]);
    yticklabels({'Original audio', 'DTW', 'Recorded audio'});
    

    % X label
%     xlabel('Time in seconds');
    xlabel({'Time in seconds', ' ', ' ', ' '});
    set(gca, 'XGrid', 'on');

    % Text
    textString = sentenceName;
%     wordsMatrix; % Load words
%     textString = [sentenceName, '  -'];
%     for i = 1:5
%         word = SentenceCodes{i,str2num(sentenceName(i))+1};
%         textString = [textString, '  ', word];
%     end

    textX = tt(end)/2; % X-coordinate of the text
    textY = -2.33; % Y-coordinate of the text
    text(textX, textY, textString, 'FontSize', 12, 'FontAngle', 'italic', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
    ylim([-3 2])
    xlim([0 tt(end)])
end







% Plot the time misalignment score with thresholds
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
% figure
plot(xAxisSafe, inSafeRange, 'LineWidth', 1.5, 'Color', 'k');
hold on
plot(xAxisNotSafe, outSafeRange, 'LineWidth', 1.5, 'Color', 'red');
hold off

%figure
%plot( frame2sec * (1:length(asyncOverTime)), asyncOverTime, 'LineWidth', 2, 'Color', 'red');
title({['Time misalignment over time for ', sentenceName],...
    ['Time misalignment score: ', num2str(asyncScore, '%.3f'),'s '],...
    ['Video ahead: ',num2str(maxVidAhead, '%.3f'), 's. Video behind: ', num2str(maxVidBehind, '%.3f'), 's.']},...
    'Interpreter', 'none');
ylabel('Time misalignment in seconds');
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
