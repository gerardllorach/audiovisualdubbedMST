# How to create video material for the Matrix Sentence Test
This is a repository with guidelines and code to create visual material for Matrix Sentence Test for speech audiometry. Please read the [scientific manuscript](https://arxiv.org/abs/1912.04700) first, if you haven't.

## Getting the audio-only material
The audio-only material belongs to HörTech gGmbH. In principle, they can give you the material for research purposes for a limited period of time. You will find contact information on their [website](https://www.hoertech.de/en). The specific website for the MST can be found in this [link](https://www.hoertech.de/en/devices/intma.html). You can directly specify that you need it for creating an audiovisual MST and that the audio files are required.

The audio-only MST from HörTech will be mentioned as "original audio" throughout this guide.

## Recording setup
You will need a computer, a camera, a microphone and probably a sound mixing table/handheld recorder. Each setup will depend on the equipment that you have available. We propose a setup with a mirrorless camera (sony alpha 7), a shotgun microphone and a handheld recorder (Zoom H6).

### Audio routing
The camera needs to record two audio inputs at the same time: one from the talker (captured by the shotgun microphone) and another one from the computer, where the original audio is being played. Because most cameras have one audio input, the Zoom H6 will mix the captured audio and the computer audio. The line out of the Zoom H6 will be connected to the audio input of the camera. The shotun microphone will be connected to the Zoom H6 channel 1 and the computer audio to the Zoom H6 channel 2. The computer will have two audio outputs from the headphone output. You can achieve that with a jack splitter. One of the outputs will be connected to the Zoom H6, as mentioned before, and the other will be connected to the earphones that the talker will use. You can also use an external sound card to do that. The final connections should look like this:
- Microphone -> (XRL female -- XRL male) <- Zoom input channel 1
- Computer audio output -> (3.5mm jack splitter male -- 3.5mm jack splitter female 1 -- 3.5mm jack male -- 6.35mm jack male) <- Zoom input channel 2
- Computer audio output -> (3.5mm jack splitter male -- 3.5mm jack splitter female 2) <- earphone to the talker
- Zoom line out -> (3.5mm jack male -- 3.5mm jack male) <- Camera audio input

According to this setup, you will need the following cables: a XRL cable (female-male), a 3.5mm jack splitter (1 male-2 female), a jack from mini to normal (3.5mm jack male - 6.35mm jack male), a 3.5mm jack (male-male).

### Recording settings
- Camera:
   · record at 50 or 60 fps, 1080p (full HD). At 50 fps, one frame equals to 20ms. Ideally, the camera records in mp4 or some other standard format.
   · avoid using automatic settings. If you do so, maybe the camera settings change during the recording session and one (video) sentence might look different from another.
   · use optical zoom if you have, in order to separate/blur the background. You can also play with the aperture to blur the background (specified as f/<number> in cameras).
   · do not use automatic gain control for audio
- Microphone:
  · use a shotgun microphone (also called boom I think) or a cardioid microphone, close to the speaker (e.g., above the speaker or below at the height of the knees and outside the recording frame of the camera).
  · check out this video for mic setups: https://www.youtube.com/watch?v=cusxbkwyvQ4.
  · never let the audio signal go over -12 dB in the camera and in the handheld recorder.

### Location
There will be the talker (person speaking the sentences) and the recording equipment (camera, handheld recorder, microphone, computer and lights). Choose a chair/stool for the talker that is comfortable and also forces the talker to sit with a straight back. Avoid using chairs with a high backrest, as it could appear in the video unintentionally.

Choose an acoustically-treated room, or a room where there is almost no reverberation. Avoid a room with natural light, as it can change throughout the recording session. Ideally, you want to get uniform lighting to the face of the talker, avoiding hard shadows. You can use two/three frontal-lateral diffuse light sources and one/two back hard light sources.

Choose a location with an uniform background. If you have the possibility, separate the talker from the backwall/background. You can increase this effect with the zoom and the aperture of the camera. You can also use a green/blue background. This is useful if you want to later want to change the background. Beware that you will need to be careful with the lighting. For example back hard lights are recommended to separate the talker from the green background.

### Endurance
Batteries are very important, both for the equipment and the talker. A session with 150 sentences should last around 2 hours. Make sure that you have extra batteries for every piece of equipment. The battery of a Sony Alpha lasts around 30 minutes. If you can connect the camera with a power cord that would be ideal, otherwise bring extra batteries. The battery of the handheld recorder usually lasts longer than a recording session (over 20 hours). Check the same for the computer and lights (ideally all connected with power cords).

Make pauses for the talker. You don't want your talker to be tired, as the task requires to be focused. Bring water/refreshments for the talker. To keep the same position of the talker in the chair/stool, you can use the display screen of the camera. By default, the display screen comes with a grid, usually by pressing the display button (DISP). You can use a non permanent marker and directly paint on the display screen where the eyes and the mouth should always be.

### Choose the right talker
You should choose the right talker for you experiment. The most usual case is that you want a talker that is easy to speechread (lipread). Speech therapists and theater actors are a good choice.

### Preparing the audio files for the recording session
You will need to do some preparations for the recording session. You will add some "beep" signals to the original sentences in order to indicate to the talker that a sentence is coming. This is fairly easy, but you need to remember how you did it for the post-processing of the recordings. You can choose your own method for doing this. In the following example, three 200ms beeps, each separated by 1 second, are played before the sentence repetitions. The sentence is repeated four times. The corresponding function in this repository is "src/createSentencesWithBeeps.m". The following code has been written for Matlab:
```MATLAB
% Read audio file
[ss, fs] = audioread('<audio filename>'); % '05126.wav' for example
% Chose one stereo channel
ss = ss(:,1);

% Create three beeps signal
durationBeep = 0.2; % seconds
distanceBeeps = 1; % seconds
amplitude = 0.2; % Amplitude of the beep signal
beepFreq = 440; % Hz
beep = amplitude * sin(2*pi*beepFreq*(0:1/fs:(durationBeep-1/fs)));
% Add silence between beeps and concatenate beeps
beepSignal = [beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep))];
% sound(beepSignal, fs); % Check how the beep signal sounds

% Add three beeps before sentence starts
beep_ss = [beepSignal ss'];

% Repeate the sentence four times
beep_4ss = [beep_ss zeros(1,fs) ss' zeros(1,fs) ss' zeros(1,fs) ss'];

% Check how the signal sounds
%sound(beep_4ss, fs);

% Store the signal to be used during the recording
audiowrite(['<audio filename>','_withBeeps.wav'],  beep_4ss, fs);

```

## Recording session

### Testing
Testing is most important. By testing the setup yourself, you will find out problems that should not appear during the recording session. Try to record 10-20 sentences. You can adjust the spacing between sentences, the beeps... Ideally, you should also check that the sentences are correctly recorded and that you can extract the final videos that are the most synchronous.

### Playing the sentences
Before playing each sentence, it is useful to display the code name and take of the sentence with a paper or a clapperboard, e.g., "15246 - Take 1". This way you can later find and distinguish each sentence in the videos by scrolling through the video. It is possible that you will have to repeat the recording of a sentence more than once. Therefore, there will be more than one take for some sentences (remember to write it down on the clapperboard).

You can use a script to play the sentences or just an audio player, like VLC. The script "playSentencesForRecording.m" is prepared to play the sentences. You can select a specific sentence to play and keep going through all the sentences with a GUI. A log is written everytime you play a sentence with the date and time. This log might be useful when going through the videos, as you will be able to infer where the sentences are in the video sequences.

### Instructions for the talker during the recording
Keep the mouth closed before and after each sentence. Keep a neutral face. Do not change the prosody (intonation).
