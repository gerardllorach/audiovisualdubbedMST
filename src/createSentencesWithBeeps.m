
% Creates audio files with beeps for the recording session.
% Inputs are the folder paths where the original audio files are and where the new audio files will be.
% createSentencesWithBeeps('MSTsentences', 'beepMSTSentences');

function createSentencesWithBeeps(originalSentencesPath, beepSentencesPath)

  % Get the filenames of the original audio
  originalSentencesNames = dir(strcat(originalSentencesPath,'/*.wav'));

  % Iterate the filenames
  for i = 1:length(originalSentencesNames)
    % Get filename of i sentence
    filename = originalSentencesNames(i).name;

    % Read audio file
    [ss, fs] = audioread([originalSentencesPath, '/', filename]); % '05126.wav' for example
    % Chose one stereo channel
    ss = ss(:,1);

    % Create three beeps signal
    durationBeep = 0.2; % seconds
    distanceBeeps = 1; % seconds
    amplitude = 0.2; % Amplitude of the beep signal
    beepFreq = 440; % Hz
    % Create sinusoid beep signal
    beep = amplitude * sin(2*pi*beepFreq*(0:1/fs:(durationBeep-1/fs)));
    % Add silence between beeps and concatenate beeps
    beepSignal = [beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep))];
    % Check how the beep signal sounds
    % sound(beepSignal, fs);

    % Add three beeps before sentence starts
    beep_ss = [beepSignal ss'];

    % Repeate the sentence four times
    beep_4ss = [beep_ss zeros(1,fs) ss' zeros(1,fs) ss' zeros(1,fs) ss' zeros(1,fs)]; % 1 second silence at the end

    % Check how the final signal sounds
    %sound(beep_4ss, fs);

    % Store the signal to be used during the recording
    audiowrite([beepSentencesPath, '/', erase(filename, '.wav'),'_withBeeps.wav'],  beep_4ss, fs);

  end

  disp(['Sentences with beeps created!']);
end
