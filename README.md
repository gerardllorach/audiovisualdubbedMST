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
   · choose a location without natural light (to avoid light changing throughout the day).
   · do not use automatic gain control for audio
- Microphone:
  · use a shotgun microphone (also called boom I think) or a cardioid microphone, close to the speaker (e.g., above the speaker or below at the height of the knees and outside the recording frame of the camera).
  · check out this video for mic setups: https://www.youtube.com/watch?v=cusxbkwyvQ4.
  · never let the audio signal go over -12 dB in the camera and in the handheld recorder.
   
## Preparing the audio files for the recording session
You will need to do some preparations for the recording session. You will add some "beep" signals to the original sentences in order to indicate to the talker that a sentence is coming. This is fairly easy, but you need to remember how you did it for the post-processing of the recordings. You can choose your own method for doing this. In the following example, three 200ms beeps, each separated by 1 second, are played before the sentence repetitions. The sentence is repeated four times. The following code has been written for Matlab:
```MATLAB
% Read audio file
[ss, fs] = audioread('<audio file name>');
% Chose one stereo channel
ss = ss(:,1);

% Create three beeps signal
durationBeep = 0.2; % seconds
distanceBeeps = 1; % seconds
beepFreq = 440; % Hz
beep = sin(2*pi*beepFreq*(0:1/fs:(durationBeep-1/fs)));
% Add silence between beeps and concatenate beeps
beepSignal = [beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep)) beep zeros(1,fs*(distanceBeeps - durationBeep))];
% sound(beepSignal, fs); % Check how the beep signal sounds

% Add three beeps before sentence starts
beep_ss = [beepSignal ss'];

% Repeate the sentence four times
beep_4ss = [beep_ss zeros(1,fs) ss' zeros(1,fs) ss' zeros(1,fs) ss'];

% Play the sound to the talker
sound(beep_4ss, fs);

```
