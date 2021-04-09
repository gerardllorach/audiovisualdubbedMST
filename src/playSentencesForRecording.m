
function playSentencesForRecording()

    % Read all filenames
    audioFilenames = dir('src/beepAudios/*.wav');
    cellFiles = struct2cell(audioFilenames);
    listFilenames = cellFiles(1,:);

    % GUI
    close all
    screenSize = get(0,'screensize');
    height = screenSize(4);
    width = screenSize(3);
    f = figure('Position', [0, 0, width, height]);

    fontSize = 30;
    textHeight = 60;
    
    % GUI data for the callbacks
    GUIData = struct('audioFilenames', audioFilenames);
    % Start button
    GUIData.startBtn = uicontrol('Style', 'pushbutton', 'String', 'Start',...
            'Position', [width/3, height/2 + textHeight*1.2, width/3, textHeight], 'FontSize', fontSize);
    GUIData.listSentencesBtn = uicontrol('Style', 'popupmenu', 'String', listFilenames,...
            'Position', [width/3, height/2, width/3, textHeight], 'FontSize', fontSize*0.5);
        
    % Current sentence text
    GUIData.currentSentenceText = uicontrol('Style', 'text', 'String', ['Playing '],'Visible', 'Off',...
            'Position', [width/4, height/2, width/2, textHeight*4], 'FontSize', fontSize*2);
    GUIData.stopSoundBtn = uicontrol('Style', 'pushbutton', 'String', 'Stop sound (and wait)', 'Visible', 'Off',...
        'Position', [width/3, textHeight, width/3, textHeight], 'FontSize', fontSize);

    % Replay sentence
    GUIData.replayText = uicontrol('Style', 'text', 'String', ['Previous sentence: '],'Visible', 'Off',...
            'Position', [width/4, 2*height/3 + textHeight*1.2, width/2, textHeight], 'FontSize', fontSize);
    GUIData.replayBtn = uicontrol('Style','pushbutton', 'String', 'Replay sentence','Visible', 'Off',...
            'Position', [width/4, 2*height/3, width/2, textHeight], 'FontSize', fontSize);
    % Play next sentence  
    GUIData.playNextText = uicontrol('Style', 'text', 'String', ['Next sentence: '],'Visible', 'Off',...
            'Position', [width/4, height/3 + textHeight*1.2, width/2, textHeight], 'FontSize', fontSize);
    GUIData.playNextBtn = uicontrol('Style','pushbutton', 'String', 'Play next sentence','Visible', 'Off',...
            'Position', [width/4, height/3, width/2, textHeight], 'FontSize', fontSize);
    % Back button
    GUIData.backBtn = uicontrol('Style', 'pushbutton', 'String', 'Back to selection', 'Visible', 'Off',...
        'Position', [width/3, textHeight, width/3, textHeight], 'FontSize', fontSize);
    % Exit button
    GUIData.exitBtn = uicontrol('Style', 'pushbutton', 'String', 'Exit', 'Visible', 'On',...
        'Position', [width/3, textHeight, width/3, textHeight], 'FontSize', fontSize);
    
    
    % Callbacks
    GUIData.startBtn.Callback = @start;
    GUIData.backBtn.Callback = @back;
    GUIData.exitBtn.Callback = 'close all';
    GUIData.stopSoundBtn.Callback = 'clear sound';

    % UserData for callbacks
    GUIData.startBtn.UserData = GUIData;
    GUIData.replayBtn.UserData = GUIData;
    GUIData.playNextBtn.UserData = GUIData;
    GUIData.backBtn.UserData = GUIData;
    GUIData.exitBtn.UserData = GUIData;
end



% Start button clicked callback
function start(src, event)
    % Get data
    GUIData = get(src, 'UserData');

    % Hide start buttons
    GUIData.startBtn.Visible = 'Off';
    GUIData.listSentencesBtn.Visible = 'Off';
    GUIData.exitBtn.Visible = 'Off';
    
    % Call play sentence
    playSentence(src, event, GUIData.listSentencesBtn.Value);

end


% Back button clicked callback
function back(src, event)
    % Get data
    GUIData = get(src, 'UserData');

    % Show start buttons
    GUIData.startBtn.Visible = 'On';
    GUIData.listSentencesBtn.Visible = 'On';
    GUIData.exitBtn.Visible = 'On';
    
    hidePlayReplayBtns(GUIData);
end



% Hide play/replay buttons
function hidePlayReplayBtns(GUIData)
    % Hide buttons
    GUIData.replayBtn.Visible = 'Off';
    GUIData.replayText.Visible = 'Off';
    GUIData.playNextBtn.Visible = 'Off';
    GUIData.playNextText.Visible = 'Off';
    % Hide back button
    GUIData.backBtn.Visible = 'Off';
end







function playSentence(src, event, index)

    % Get data
    GUIData = get(src, 'UserData');
     % Hide buttons
    hidePlayReplayBtns(GUIData);
    
    % Get the audio name
    audioName = (GUIData.audioFilenames(index).name);
    sentenceCode = erase(audioName, '_withBeeps.wav');
    
    % Display current sentence
    GUIData.currentSentenceText.String = ['Playing ', sentenceCode];
    GUIData.currentSentenceText.Visible = 'On';
    GUIData.stopSoundBtn.Visible = 'On';
    
    % Audio read and play
    [ss, fs] = audioread(audioName);
    sound(ss, fs);
    % Wait until sentence is finished
    pause(length(ss)/fs);
    % Log what was played
    time = datestr(datetime(), 'yyyy.mm.dd_HH.MM.SS');
    fileID = fopen('src/recordingLogs.txt','a');
    fprintf(fileID, [time, ', ', sentenceCode, '\r\n']);
    fclose(fileID);
    
    
    % Show/Hide buttons
    GUIData.currentSentenceText.Visible = 'Off';
    GUIData.stopSoundBtn.Visible = 'Off';
    % Replay
    GUIData.replayBtn.Visible = 'On';
    GUIData.replayText.String = ['Previous: ', sentenceCode];
    GUIData.replayText.Visible = 'On';
    % Callback
    GUIData.replayBtn.Callback = {@playSentence,index};
    
    % Play next
    if (index+1 < length(GUIData.audioFilenames)) % Not at the end
        GUIData.playNextBtn.Visible = 'On';
        GUIData.playNextText.String = ['Next: ', erase(GUIData.audioFilenames(index+1).name, '_withBeeps.wav')];
        GUIData.playNextText.Visible = 'On';
        % Callback
        GUIData.playNextBtn.Callback = {@playSentence,index+1};
    end
    
    % Back
    GUIData.backBtn.Visible = 'On';
    
end






