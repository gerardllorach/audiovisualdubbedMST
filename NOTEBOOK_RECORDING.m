

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
% You need to install ffmpeg for this (https://ffmpeg.org/)
addpath('src');
% cutAudios(channelSentenceWithBeeps, pathVideos, pathOriginalAudios, pathCutAudios)
cutVideos(1, '', 'D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\', 'src/cutVideos/');


%% Test Morse Encoder/Decoder
% Takes many hours. It checks that the encoded signal can be decoded
addpath('src')
testMorse()