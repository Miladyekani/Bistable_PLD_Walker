%% psychopysics task from scratch 
% struct for saving the data 
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
screenNumber = 1 ; 
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
Participant_responded = 0 ;
for trail = 1:30
    % Draw vertical fixation cross 
    Screen('DrawLine', window, lineColor, centerX, centerY-lineLength/2, centerX, centerY+lineLength/2, lineWidth);
    Screen('DrawLine', window, lineColor, centerX-lineLength/2, centerY, centerX+lineLength/2, centerY, lineWidth);
    
    Screen('Flip',window);
    WaitSecs(2);
    start_frame =  randi([2, 90], 1, 1);
    random_int  =  randi([1, 14], 1, 1);
    if random_int <11
        Text_to_show     = Texture.PLD ;
        info. trail_typ {trail} = 'PLD' ;
    elseif random_int == 11
        Text_to_show = Texture.Away.In ;
        info. trail_typ {trail} = 'Away-In' ;
    elseif random_int == 12
        Text_to_show = Texture.Away.Di ;
        info. trail_typ {trail} = 'Away_Di' ;
    elseif random_int == 13
        Text_to_show = Texture.Toward.In ;
        info. trail_typ {trail} = 'Toward_In' ;
    elseif random_int == 14
        Text_to_show = Texture.Toward.Di ;
        info. trail_typ {trail} = 'Toward_Di' ;
    end
 
    for i =start_frame:250
        
        Screen('DrawTexture', window, Text_to_show{i})
        vbl  = Screen('Flip', window);
        [a,b,keyCode] = KbCheck;
        if any(keyCode(Exit))
            break ;
        elseif random_int >= 11   
            T_0 = GetSecs() ; 
            if random_int >= 11  && Participant_responded == 0 
               [a,b,keyCode] = KbCheck;
               if any(keyCode(Right)) ||any(keyCode(Left))
                  info.Reaction_Time{trail} = GetSecs() - T_0 ; 
                  Beeper(1000,10)
                  Participant_responded = 1 ; 
                  d =  KbName(keyCode) ; 
                  info.Respons{trail}  = d{1} ; 
               end
            end
        end
    end 
    Participant_responded = 0 ;
    Screen('Flip',window);
    WaitSecs(0.5);
    if random_int<11
        T_0 = GetSecs() ;
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
sca; 
%%


