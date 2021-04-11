function beepSignal = createBeeps(fs)

    globalVariables;
    % durationBeep
    % distanceBeeps
    % amplitudeBeep
    % beepFreq

    % Create sinusoid beep signal
    beep = amplitudeBeep * sin(2*pi*beepFreq*(0:1/fs:(durationBeep-1/fs)));
    % Add silence between beeps and concatenate beeps
    beepSignal = [beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep))];
    % Check how the beep signal sounds
    % sound(beepSignal, fs);
    
end