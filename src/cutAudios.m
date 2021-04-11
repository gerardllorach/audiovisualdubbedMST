function cutAudios(channelSentenceWithBeeps, pathVideos, pathOriginalAudios, pathCutAudios)
    % channelSentenceWithBeeps -> 1 channel L, 2 channel R

    close all
    globalVariables; 
    % silenceBetweenSentenceRepetitionsDuration
    % totalDurationMorseSignal
    % silenceDurationBeginMorseSignal
    % timeCutBeforeStart
    % timeCutAfterEnd

    % Read video files
    videoFiles = dir([pathVideos, '*.mkv']);

    % Iterate through video files
    for i = 1:length(videoFiles)
        % Get audio tracks
        [ssVideo, fs] = audioread(videoFiles(i).name);
        % Choose the right audio channel (one with beeps, one with the audio
        % from the recording session)
        ss = ssVideo(:,channelSentenceWithBeeps); % 1 channel L, 2 channel R
    %      sound(ss,fs)
    %      clear sound
        % Three beep signal
        beepSignal = createBeeps(fs);

        % Find the three beeps in the audio tracks
        % Correlation
        [acor, lag] = xcorr(ss, beepSignal);
        [maxCorr, ~] = max(abs(acor));
        % Find peaks (separated by at least 8 seconds, i.e. each take lasts 3*4 seconds + pause in between)
        [peaks, locs] = findpeaks(abs(acor), lag, 'MinPeakDistance',fs*8, 'MinPeakHeight', maxCorr*0.8);
        findpeaks(abs(acor), lag, 'MinPeakDistance',fs*8, 'MinPeakHeight', maxCorr*0.8); % Plot the peaks
        disp([num2str(length(locs)), ' takes found (three beeps signal).']);

        % Cutting locations in samples for each take (4 sentence
        % repetitions)
        % beep beep beep (takesStartIdxs) SENTENCE SENTENCE SENTENCE SENTENCE
        takesStartIdxs = locs + length(beepSignal);
        % Find the sentence codes start samples (audio morse coded)
        sentenceCodeStartIdxs = locs - totalDurationMorseSignal*fs;
        % Iterate through takes
        for j = 1:length(takesStartIdxs)
            % Find the sentence code
            sentenceCodeSignal = ss(sentenceCodeStartIdxs(j)+0.5*silenceDurationBeginMorseSignal*fs:sentenceCodeStartIdxs(j) + 0.55*totalDurationMorseSignal*fs);
            sentenceCode = morseDecode(sentenceCodeSignal, fs);
            if (contains(sentenceCode, 'x'))
                % Let the user decide the sentence code
                myCell = inputdlg(['Do you know the sentence code at ', num2str(takesStartIdxs(j)/fs), ...
                                   ' seconds, for video ', videoFiles(i).name, '?',...
                                   ' It was possible to decode: ', sentenceCode, ...
                                   ' Your answer should be 5 digits, e.g. 01248.'], 'Sentence code');
                sentenceCode = myCell{1}; 
            end
            % Find sentence duration
            filePathAndName = [pathOriginalAudios, '\',sentenceCode, '.wav'];
            % If file does not exist, let the user fill it
            if (exist(filePathAndName, 'file') == 0)
                disp(['File ', sentenceCode, ' does not exist', filePathAndName]);
                continue;
            end
            [originalSentence, fsOriginal] = audioread(filePathAndName);
            sentenceDuration = length(originalSentence)/fsOriginal;
            % Get the 3 repetitions
            % sentence, SENTENCE, SENTENCE, SENTENCE
            for k =1:3
                % Define cutting indexes (skips first sentence)
                startIdx = takesStartIdxs(j) + k*sentenceDuration*fs + k*silenceBetweenSentenceRepetitionsDuration*fs - timeCutBeforeStart*fs;
                endIdx = takesStartIdxs(j) + (k+1)*sentenceDuration*fs + k*silenceBetweenSentenceRepetitionsDuration*fs + timeCutAfterEnd*fs;
                % Cut the videos according to the sentence duration
                % TODO: cut video
                % TODO: check for Take number
                audiowrite([pathCutAudios, sentenceCode, '_Take1_Repetition', num2str(k), '.wav'], ssVideo(round(startIdx):round(endIdx), :), fs);
            end

        end

    end

end

