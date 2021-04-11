% Creates an acoustic signal that encodes five numbers in 5 different
% frequency bands
function signal = morseEncode(sentenceCode, fs)
    
    globalVariables;
    % morseNumbers
    % freqBands
    % dotDuration
    % dashDuration
    % pauseDuration
    % amplitudeMorseSignal
    % totalDurationMorseSignal
    % silenceDurationBeginMorseSignal
    
    % Encoded signal
    ss = zeros(1,fs*silenceDurationBeginMorseSignal); % 250 ms silence
    % Silence between beeps
    silenceSignal = zeros(1, fs*pauseDuration);

    % Iterate over sentence code
    for i = 1:length(sentenceCode)
        number = sentenceCode(i);
        code = morseNumbers{str2num(number)+1};
        % Frequency
        beepFreq = freqBands(i);
        lastIndex = 1;
        % Iterate morse number code
        for j = 1:length(code)
            mCode = code(j);
            % Duration
            if strcmp(mCode, '-')
                duration = dashDuration;
            else
                duration = dotDuration;
            end
            % Create beep
            beep = amplitudeMorseSignal * sin(2*pi*beepFreq*(0:1/fs:(duration-1/fs)));
            samplesMCode = length(beep)+length(silenceSignal);
            % Store beep
            ss(lastIndex:(lastIndex+samplesMCode - 1)) = ss(lastIndex:(lastIndex+samplesMCode - 1)) + [beep silenceSignal];
            % Keep lastIndex
            lastIndex = lastIndex+samplesMCode;
        end

    end
    
    % Final signal
    tmp = [zeros(1,fs*0.25) ss zeros(1, fs)];
    signal = tmp(1:(totalDurationMorseSignal*fs-1));
end
