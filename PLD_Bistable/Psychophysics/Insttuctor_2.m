clc; clear ; 
%% psychopysics task from scratch 
% struct for saving the data 
participantName    = input('Enter the participant name: ', 's');
Type_of_experiment = input('type of experiment: ');
%%
currentDateTime = datetime('now');
DateTime = datestr(currentDateTime, 'yyyy-mm-dd-HH-MM-SS');
fil_name = strcat(participantName, DateTime) ; 
 
info.Reaction_Time =[]; info.Response =[]; info.Start_Frame = [] ; info. trail_typ = [];
% struct for saving the parameters 
param.Movie_Length = 2; % Written in second should be converted to frames 
param.e = 800;

%%
%%% setup psychtoolbox and open a window 
AssertOpenGL; 
PsychDefaultSetup(2);
screens = Screen('Screens');
screenNumber = max(screens);
screenNumber = 1;
white = WhiteIndex(screenNumber); 
black = BlackIndex(screenNumber);
[window, windowRect] = PsychImaging('OpenWindow', screenNumber,black);
% Get window dimensions
[windowWidth, windowHeight] = RectSize(windowRect);
% find center of the window 
centerX = (windowWidth / 2 )-7;
centerY = (windowHeight / 2)-55;
% specifiy the size and color of the cross sign 
lineWidth = 4;
lineLength = 20;
lineColor = [255 255 255];
% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % ??? dont know 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);% Query the frame duration
loaded_frame = 500;
%%% load textures 
Response_texture   = Screen('MakeTexture', window,imread('stimuli_set\Resp_Stimuli_for_PLD.jpg')); 
Texture.PLD        = Video_Text_Maker ('stimuli_set\PLD_BS'   ,loaded_frame,0,window);
Texture.Away.In    = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,1,window);
Texture.Away.Di    = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,2,window);
Texture.Toward.In  = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,1,window);
Texture.Toward.Di  = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,2,window);
vbl  = Screen('Flip', window);
Text_to_show = Texture.Toward.Di ;

%% Find the code of the keys we need during the task
Up    = KbName('uparrow')   ; Down  = KbName('downarrow') ; Right = KbName('rightarrow'); 
Left  = KbName('leftarrow') ; Exit  =     KbName('space') ;

%% present stimuli
Chunke_number = 8 ;
if Chunke_number < 4
    error ('Chunke_number should be more than 4');
end
Participant_responded = 0 ;
interval_for_modulation = repmat([5, 6], 1, Chunke_number);
trial_number = sum(interval_for_modulation) ; 
interval_for_modulation = interval_for_modulation(randperm(length(interval_for_modulation)));
Modulation_type = repmat([1, 2,3,4], 1, length(interval_for_modulation)/4);
interval_for_modulation = interval_for_modulation(randperm(length(interval_for_modulation)));
Modulation_type = Modulation_type(randperm(length(Modulation_type))) ; 
for i=2:length(interval_for_modulation)
interval_for_modulation(i) = interval_for_modulation(i)+interval_for_modulation(i-1) ; 
end
% flagg for modulation trail
modulation_trail = 0  ; 
chunk_n = 1 ; 
last_trail = interval_for_modulation(end) ; 
for trail = 1:trial_number
    Participant_responded = 0 ;
    if trail == last_trail 
        % save(fil_name,'Info.mat');
        sca;
    end
    % Draw  fixation cross 
    Screen('DrawLine', window, lineColor, centerX, centerY-lineLength/2, centerX, centerY+lineLength/2, lineWidth);
    Screen('DrawLine', window, lineColor, centerX-lineLength/2, centerY, centerX+lineLength/2, centerY, lineWidth);
    Screen('Flip',window);
    WaitSecs(2);
  
    if trail == interval_for_modulation(chunk_n )
        chunk_n = chunk_n + 1; 
        modulation_trail = 1  ; 
        if Modulation_type(chunk_n) == 1
             Text_to_show     = Texture.Away.In ;
             info. trail_typ {trail} = 'Away.In';
        elseif Modulation_type(chunk_n) == 2
             Text_to_show     = Texture.Away.Di ;
             info. trail_typ {trail} = 'Away.Di';
        elseif Modulation_type(chunk_n) == 3
             Text_to_show     = Texture.Toward.In ;
             info. trail_typ {trail} = 'Toward.In';
        elseif Modulation_type(chunk_n) == 4
             Text_to_show     = Texture.Toward.Di ;
             info. trail_typ {trail} = 'Toward.Di';
        end 
    else
        modulation_trail = 0  ; 
        Text_to_show     = Texture.PLD ;
        info. trail_typ {trail} = 'PLD';
    end
    
    if  modulation_trail == 1  
        
        start_frame =  randi([2, 90], 1, 1);
        end_frame   = start_frame + 100 ; 
    else 
        start_frame =  randi([2, 90], 1, 1);
        end_frame = start_frame + 90 ; 
        
    end 
    for i =start_frame:end_frame
        
        Screen('DrawTexture', window, Text_to_show{i})
        vbl  = Screen('Flip', window);
        WaitSecs(0.001)
        [a,b,keyCode] = KbCheck;
        if any(keyCode(Exit))
            break ;
        end
        if modulation_trail == 1 && Type_of_experiment == 1
            T_0 = GetSecs() ; 
            if Participant_responded == 0 
               [a,b,keyCode] = KbCheck;
               if any(keyCode(Right)) ||any(keyCode(Left))
                  info.Reaction_Time{trail} = GetSecs() - T_0 ; 
                  Beeper(1000,10);
                  Participant_responded = 1 ; 
                  info.Respons{trail}  = KbName(keyCode) ; 
               end
            end
        end
    end 
    Participant_responded = 0 ;
    Screen('Flip',window);
    WaitSecs(0.5);
    T_0 = GetSecs() ; 
    if modulation_trail == 0 || Type_of_experiment == 2
        while 1
            [a,b,keyCode] = KbCheck;
            Screen('DrawTexture', window, Response_texture)
            Screen('Flip',window)
            if any(keyCode(Up)) ||any(keyCode(Down))
                info.Reaction_Time{trail} = GetSecs() - T_0 ;
                info.Respons{trail}  = KbName(keyCode);
                Beeper(1000,10)
                break
            end
        end
    end
end

%%


