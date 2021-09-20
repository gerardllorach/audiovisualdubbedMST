% Decodes a 5 digit signal
function decodedSentenceCode = morseDecode(signal, fs)

    globalVariables;
    % morseNumbers
    % freqBands
    % dotDuration
    % dashDuration

    decodedSentenceCode = '';
    for i = 1:length(freqBands)
        % Filtered signal containing only the morse code
        signalFiltered = bandpassFilter(signal, fs, freqBands(i)-200, freqBands(i)+200);
        % Envelope
        signalEnvelopeOri = envelope(signalFiltered, 1, 'peak');
        signalEnvelope = envelope(signalFiltered, 1, 'peak');
        
        
        % Maximal 
        maxValue = max(abs(signalEnvelope));
        % Make flat columns
        signalEnvelope(abs(signalEnvelope)>maxValue*0.5) = 1;
        signalEnvelope(abs(signalEnvelope)<maxValue*0.5) = 0;


        % Find the start and end of each column
        % Clean dips in the signal created by constructive/destructive wave
        % superposition
        cleanedSignalEnvelope = cleanEnvelopeInterferences(signalEnvelope, fs);
        % Minimum separation between column beginnings: 15ms + 20ms
        % Start of columns
        [~, locsStart] = findpeaks(diff(cleanedSignalEnvelope), 'MinPeakDistance',fs*0.03, 'MinPeakHeight', 0.5);
        % End of columns
        [~, locsEnd] = findpeaks(-diff(cleanedSignalEnvelope), 'MinPeakDistance',fs*0.03, 'MinPeakHeight', 0.5);
        % Length of columns
        % If peak's length don't match, error is happening
        if (length(locsStart) ~= length(locsEnd))
            disp(['Error: morse dash/dots are not found correctly in freq band: ', num2str(freqBands(i)), ' Hz.']);
            decodedSentenceCode(i) = 'x';
                figure
                plot(signalFiltered);
                hold on
                plot(signalEnvelope, 'linewidth', 2);
                plot(cleanedSignalEnvelope, 'linewidth', 3);
                plot(diff(signalEnvelope));
                scatter( locsStart, ones(1,length(locsStart)))
                scatter( locsEnd, ones(1,length(locsEnd)))
                title(['Freq band not decoded: ', num2str(freqBands(i)), ' Hz.']);
                hold off
            continue;
        end
        
        durationCodes = (locsEnd-locsStart)/fs;
        decodedMorse = '';
        for j = 1:length(durationCodes)
            % Discard too long or two short
            if (durationCodes(j) < dotDuration*0.5 | durationCodes(j) > dashDuration*1.5)
                continue;
            % Dash
            elseif (durationCodes(j) < dashDuration*1.1 & durationCodes(j) > dashDuration*0.70)
                decodedMorse(end+1) = '-';
            % Dot
            elseif (durationCodes(j) < dotDuration*1.1 & durationCodes(j) > dotDuration*0.70)
                decodedMorse(end+1) = '.';
            end
        end

        % If too many or too few decoded dots and dashes
        if (length(decodedMorse) ~= 5 )
            disp(['Error: morse code does not have 5 dots/dashes: ', decodedMorse, ' , in freq band: ', num2str(freqBands(i)), ' Hz.']);
            decodedSentenceCode(i) = 'x';
            figure
            plot(signal)
            hold on
            plot(signalFiltered);
            plot(signalEnvelopeOri, 'Linewidth', 2)
            plot(signalEnvelope*0.5, 'Linewidth', 2);
            plot(cleanedSignalEnvelope*0.5, 'Linewidth', 3);
            plot(diff(signalEnvelope));
            title(['Freq band not decoded: ', num2str(freqBands(i)), ' Hz.']);
            hold off
        else % 
            decodedSentenceCode(i) = num2str(find(ismember(morseNumbers,decodedMorse))-1);
        end

%         figure
%         plot(signalFiltered);
%         hold on
%         plot(signalEnvelope);
%         plot(diff(signalEnvelope));
%         title([decodedMorse, '    ', decodedSentenceCode(i)]);
%         hold off

    end
    
end


% Clean dips in the signal envelope created by constructive/destructive wave superposition
function cleanedEnv = cleanEnvelopeInterferences(signalEnvelope, fs)
    globalVariables;
    % dotDuration;
    
    % Signal envelope is 0s and 1s
    % Sometimes the different frequencies interfere with each other.
    % The duration of an interference should be shorter than the duration
    % of a one/zero encoding, otherwise an interference could be confused
    % with the encoding
    interfDuration = round(fs*dotDuration/2);
    % Constructive peaks
    [~, locsConstructive] = findpeaks(signalEnvelope,'MaxPeakWidth', interfDuration);
    % Remove constructive peaks
    for i=1:length(locsConstructive)
        idxPeak = locsConstructive(i);
        signalEnvelope(idxPeak:(idxPeak+interfDuration)) = zeros(1,1+interfDuration); % Does not matter if it is a column or row array. Alternatively you could use isrow(signalEnvelope)
    end
    
    % Destructive peaks
    [~, locsDestructive] = findpeaks(-signalEnvelope,'MaxPeakWidth', interfDuration);
    % Remove destructive peaks
    for i=1:length(locsDestructive)
        idxPeak = locsDestructive(i);
        signalEnvelope(idxPeak:(idxPeak+interfDuration)) = ones(1,1+interfDuration); % Does not matter if it is a column or row array. Alternatively you could use isrow(signalEnvelope)
    end
    
    cleanedEnv = signalEnvelope;
    
end