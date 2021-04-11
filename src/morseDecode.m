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
        % Minimum separation between column beginnings: 15ms + 20ms
        % Start of columns
        [~, locsStart] = findpeaks(diff(signalEnvelope), 'MinPeakDistance',fs*0.03, 'MinPeakHeight', 0.5);
        % End of columns
        [~, locsEnd] = findpeaks(-diff(signalEnvelope), 'MinPeakDistance',fs*0.03, 'MinPeakHeight', 0.5);
        % Length of columns
        % If peak's length don't match, error is happening
        if (length(locsStart) ~= length(locsEnd))
            disp(['Error: morse dash/dots are not found correctly in freq band: ', num2str(freqBands(i)), ' Hz.']);
            decodedSentenceCode(i) = 'x';
                figure
                plot(signalFiltered);
                hold on
                plot(signalEnvelope);
                plot(diff(signalEnvelope));
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
            elseif (durationCodes(j) < dashDuration*1.1 & durationCodes(j) > dashDuration*0.9)
                decodedMorse(end+1) = '-';
            % Dot
            elseif (durationCodes(j) < dotDuration*1.1 & durationCodes(j) > dotDuration*0.75)
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