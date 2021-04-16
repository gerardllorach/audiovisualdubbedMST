%% Sentence repetitions
silenceBetweenSentenceRepetitionsDuration = 1; % seconds

%% Cutting sentences
% Defines time to cut video before a sentence starts and after a sentence
% ends
timeCutBeforeStart = 1; % seconds
timeCutAfterEnd = 0.5; % seconds

%% Beeps
durationBeep = 0.2; % seconds
distanceBeeps = 1; % seconds
amplitudeBeep = 0.2; % Amplitude of the beep signal
beepFreq = 440; % Hz


%% Morse encode and decode
morseNumbers = { '-----', ... %0
                 '.----', ... %1
                 '..---', ... %2
                 '...--', ... %3
                 '....-', ... %4
                 '.....', ... %5
                 '-....', ... %6
                 '--...', ... %7
                 '---..', ... %8
                 '----.'};     %9
% 
% freqBands = [315, 690, 1111, 1560, 1991];
freqBands = [500, 1111, 1560, 1991, 2687];
dotDuration = 0.015; %s
dashDuration = 0.030; %s
pauseDuration = 0.020; %s

amplitudeMorseSignal = 0.1;
totalDurationMorseSignal = 1; % second
silenceDurationBeginMorseSignal = 0.250;