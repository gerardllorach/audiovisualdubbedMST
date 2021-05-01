%% NOTEBOOK RECORDING
%----------------------------------------------------------------------
%----------------------------------------------------------------------

% Here you will find the scripts to record and to process the audiovisual
% MST, based on an existing audio-only MST.


%% ------------------- PRE-RECORDING SESSION -------------------
%---------------------------------------------------------------

%% Prepare the audio files with beeps for the recording session
% Creates new audio files with three beeps in front and four sentence
% repetitions. An additional signal with the sentence code appears before
% the three beeps, in order to be able to identify each sentence
% programatically later.

% createSentencesWithBeeps(originalAudiosPath, beepAudiosPath)
addpath('src')
createSentencesWithBeeps('D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\', 'src/beepAudios/');


%% -------------------   RECORDING SESSION -------------------
%-------------------------------------------------------------

%% Play the sentences for the recording session
% A GUI will open with some basic buttons. Every time a sentence is played,
% an entry will be written to recordingLogs.txt with a date, time and
% sentence code.
addpath('src')
playSentencesForRecording('src/beepAudios');



%% ------------------- POST-RECORDING SESSION -------------------
%----------------------------------------------------------------

%% Cut the videos/audios
% Given a directory with video files, it finds the sentences and takes from
% the audio file the start and end of each take/sentence repetition. The
% script finds the starts and ends and creates new files for each sentence
% repetition in a given folder.
% You need to install ffmpeg for this (https://ffmpeg.org/)
addpath('src');
% cutVideos(channelSentenceWithBeeps, pathVideos, pathOriginalAudios, pathCutAudios)
cutVideos(1, '', 'D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\', 'src/cutVideos/');


%% Check the asynchrony of the repetitions
% For this section you need to download the VOICEBOX Matlab toolbox and 
% reference the path
% http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
close all
addpath('src');
addpath('sap-voicebox-master/voicebox'); % voicebox path

% getAsyncScoresForAll(pathCutAudios);
asyncTable = getAsyncScoresForAll('src/cutVideos/');
% TODO: select the best

%% Test Morse Encoder/Decoder
% Takes many hours. It checks that the encoded signal can be decoded
addpath('src')
testMorse();

%% Test asynchrony score with a delayed signal
% Test with a signal delayed 200ms
addpath('src');
addpath('sap-voicebox-master/voicebox');
[ss, fs] = audioread('D:\Oldenburg\AVOLSA_Masked_Experiment\molsa\Stimuli\female\dithered\02064.wav');
delaySec = 0.2;
ssA = [ss(:,1); zeros(round(delaySec*fs), 1)];
ssA(:,2) = [zeros(round(delaySec*fs), 1) ; ss(:,1)]; % Delayed 200ms
figure
plot(1/fs*1:length(ssA), ssA)
computeAsyncScore(ssA, fs, 1);