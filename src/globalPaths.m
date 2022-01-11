paths = struct;

% Folder with the audios in the format of 39491.wav (5 numbers -sentence code- and .wav)
paths.OriginalSentences = 'C:\Users\gllor\Desktop\Oldenburg\AVMST\olsavideo\female\dithered\';

% Folder where the audios with beeps signals will be stored. You probably
% need to create this folder if it does not exist.
paths.SentencesWithBeeps = 'src/beepAudios/';

% Folder where the video files from the camera are.
paths.RecordedRawVideos = '';

% Folder where the videos and audios are cut into Takes and Repetitions.
% You probably need to create this folder if it does not exist.
paths.CutTakes = 'src/cutVideos/';

% Folder where the final videos are stored. They have been manually
% selected from the best synchronous videos (removed videos with smiles and
% unwated facial expressions)
paths.FinalVideos = 'C:\Users\gllor\Desktop\Oldenburg\AVMST\AVMST_French\videos\female\';

% Folder where the lists are stored
paths.SentenceLists = '';
