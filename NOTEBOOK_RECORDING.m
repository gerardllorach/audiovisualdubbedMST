

%% Prepare the audio files with beeps for the recording session
% Creates new audio files with three beeps in front and four sentence
% repetitions
% createSentencesWithBeeps(originalAudiosPath, beepAudiosPath)
addpath('src')
createSentencesWithBeeps('D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered', 'src/beepAudios');


%% Play the sentences for the recording session
addpath('src')

playSentencesForRecording();
