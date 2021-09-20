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

% createSentencesWithBeeps(pathOriginalSentences, pathSentencesWithBeeps)
addpath('src')
globalPaths; % Define here all your paths.
createSentencesWithBeeps(paths.OriginalSentences, paths.SentencesWithBeeps);


%% -------------------   RECORDING SESSION -------------------
%-------------------------------------------------------------

%% Play the sentences for the recording session
% A GUI will open with some basic buttons. Every time a sentence is played,
% an entry will be written to recordingLogs.txt with a date, time and
% sentence code.
addpath('src')
globalPaths; % Define here all your paths.
playSentencesForRecording(paths.SentencesWithBeeps);


%% ------------------- POST-RECORDING SESSION -------------------
%----------------------------------------------------------------

%% Cut the videos/audios
% Given a directory with video files, it finds the sentences and takes from
% the audio file the start and end of each take/sentence repetition. The
% script finds the starts and ends and creates new files for each sentence
% repetition in a given folder.
% You need to install ffmpeg for this (https://ffmpeg.org/)
addpath('src');
globalPaths; % Define here all your paths.
% channelSentenceWithBeeps -> 1 channel L, 2 channel R
% cutTakes(channelSentenceWithBeeps, pathRecordedRawVideos, pathOriginalSentences, pathCutTakes, videoFormat)
cutTakes(1, paths.RecordedRawVideos, paths.OriginalSentences, paths.CutTakes, 'm4v');


%% Check the asynchrony of the repetitions
% For this section you need to download the VOICEBOX Matlab toolbox
% http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
% It is recommended that the audios of the recording session are denoised,
% if background noise is present. It seems to improve the asynchrony
% scores.
close all
addpath('src');
addpath('sap-voicebox-master/voicebox'); % voicebox path
globalPaths;

% getAsyncScoresForAll(pathCutTakes);
asyncTable = getAsyncScoresForAll(paths.CutTakes);
% TODO: select the best



%% Appendix
return;


%% Test Morse Encoder/Decoder
% Takes many hours. It checks that the encoded signal can be decoded
addpath('src')
testMorse();

%% Test asynchrony score with a delayed signal
% Test with a signal delayed 200ms
addpath('src');
addpath('sap-voicebox-master/voicebox');
globalPaths;
sentenceName = '02064.wav'
[ss, fs] = audioread([paths.OriginalSentences, sentenceName]);
delaySec = 0.2;
ssA = [ss(:,1); zeros(round(delaySec*fs), 1)];
ssA(:,2) = [zeros(round(delaySec*fs), 1) ; ss(:,1)]; % Delayed 200ms
figure
plot(1/fs*1:length(ssA), ssA)
computeAsyncScore(ssA, fs, 1, sentenceName);
% Check asynScore with noisy delayed signal. It seem to affect quite a lot
% (~0.02 async) if the recording was noisy, when comparing to the denoised
% recording.
noise = 0.5*max(ssA(:,2))*(rand(size(ssA,1),1) - 0.5)*2;
ssA(:,2) = ssA(:,2) + noise;
computeAsyncScore(ssA, fs, 1, sentenceName);
