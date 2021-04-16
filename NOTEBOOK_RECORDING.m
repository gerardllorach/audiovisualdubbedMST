

%% Prepare the audio files with beeps for the recording session
% Creates new audio files with three beeps in front and four sentence
% repetitions. An additional signal with the sentence code appears before
% the three beeps, in order to be able to identify each sentence
% programatically later.

% createSentencesWithBeeps(originalAudiosPath, beepAudiosPath)
addpath('src')
createSentencesWithBeeps('D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\', 'src/beepAudios/');


%% Play the sentences for the recording session
% A GUI will open with some basic buttons. Every time a sentence is played,
% an entry will be written to recordingLogs.txt with a date, time and
% sentence code.
addpath('src')
playSentencesForRecording('src/beepAudios');


%% Cut the videos/audios
% Given a directory with video files, it finds the sentences and takes from
% the audio file the start and end of each take/sentence repetition. The
% script finds the starts and ends and creates new files for each sentence
% repetition in a given folder.
addpath('src');
% cutAudios(channelSentenceWithBeeps, pathVideos, pathOriginalAudios, pathCutAudios)
cutAudios(1, '', 'D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\', 'src/cutAudios/');


%% Test Morse Encoder/Decoder

addpath('src')
sentenceCode = ''; % '59782';
for i = 0:99999
    sentenceCode(1) = num2str(floor(i/1e4));
    sentenceCode(2) = num2str(floor(i/1e3) - floor(i/1e4)*10);
    sentenceCode(3) = num2str(floor(i/1e2) - floor(i/1e3)*10);
    sentenceCode(4) = num2str(floor(i/1e1) - floor(i/1e2)*10);
    sentenceCode(5) = num2str(floor(i/1e0) - floor(i/1e1)*10);

     fs = 44100;
     signal = morseEncode(sentenceCode, fs);
     %sound(signal, fs);
     result = morseDecode(signal,fs);
     disp(['Original: ', sentenceCode, ', Result: ', result]);
end