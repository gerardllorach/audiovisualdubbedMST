
% Creates audio files with beeps for the recording session.
% Inputs are the folder paths where the original audio files are and where the new audio files will be.
% createSentencesWithBeeps('MSTsentences', 'beepMSTSentences');

function createSentencesWithBeeps(originalSentencesPath, beepSentencesPath)

  globalVariables;
  globalPaths;
  
  % Get the filenames of the original audio
  originalSentencesNames = dir(strcat(originalSentencesPath,'/*.wav'));
  if (size(originalSentencesNames,1) == 0)
    msgbox(['Original sentences not found in ', originalSentencesPath, '*/.wav Please revise src/globalPaths.m']);
    disp(['Original sentences not found in ', originalSentencesPath, '*/.wav Please revise src/globalPaths.m']);
    return
  end

  % Iterate the filenames
  for i = 1:length(originalSentencesNames)
    % Get filename and sentence code of i sentence
    filename = originalSentencesNames(i).name;
    sentenceCode = erase(filename, '.wav');
    
    % If sentenceCode does not contain a sentence code ('84651')
    if (isnan(str2double(sentenceCode)))
        disp(['Filename ', sentenceCode , ' is not correct, it should be 5 digits. Skipping audio file.']);
        continue;
    end

    % Read audio file
    [ss, fs] = audioread([originalSentencesPath, filename]); % '05126.wav' for example
    % Chose one stereo channel
    ss = ss(:,1);

    % Create three beeps signal
    beepSignal = createBeeps(fs);

    % Add three beeps before sentence starts
    beep_ss = [beepSignal ss'];

    % Repeate the sentence four times
    silenceBetweenRepetitions = zeros(1,fs*silenceBetweenSentenceRepetitionsDuration);
    beep_4ss = [beep_ss zeros(1,fs) ss' silenceBetweenRepetitions...
                                    ss' silenceBetweenRepetitions...
                                    ss' silenceBetweenRepetitions]; % 1 second silence at the end
    
    % Encode the signal code into an audio signal
    sentenceCodeAudio = morseEncode(sentenceCode, fs);
    
    % Add to signal
    sCode_beep_4ss = [sentenceCodeAudio beep_4ss];

    % Check how the final signal sounds
    %sound(sCode_beep_4ss, fs);

    % Store the signal to be used during the recording
    audiowrite([beepSentencesPath, sentenceCode,'_withBeeps.wav'],  sCode_beep_4ss, fs);

  end

  disp(['Sentences with beeps created!']);
end
