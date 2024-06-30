%%
clc; clear ; 
%% psychopysics task from scratch 
% struct for saving the data 
participantName    = input('Enter the participant name: ', 's');
Type_of_experiment = input('type of experiment: ');
Block_number = input('block : ');
if Block_number>10
    msg = 'Block_number cant be more than 10';
    error(msg)
end 
%%
currentDateTime = datetime('now');
DateTime = datestr(currentDateTime, 'yyyy-mm-dd-HH-MM-SS');
fil_name = strcat(participantName, DateTime) ; 
info.Reaction_Time =[]; info.Response =[]; info.Start_Frame = [] ; info.trail_type = [];
%% !!! I have wrote severa commands in one line in this section pay attention to the ;s !!!
%%% setup psychtoolbox and open a window 
AssertOpenGL; PsychDefaultSetup(2);
screens = Screen('Screens');screenNumber = max(screens);screenNumber =1;
white = WhiteIndex(screenNumber); black = BlackIndex(screenNumber);% define white and black color
[window, windowRect] = PsychImaging('OpenWindow', screenNumber,black);
% Get window dimensions
[windowWidth, windowHeight] = RectSize(windowRect);
% find center of the window 
centerX = (windowWidth / 2 );centerY = (windowHeight / 2);
% specifiy the size and color of the cross sign 
lineWidth = 4;lineLength = 20;lineColor = [255 255 255];
% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % ??? dont know 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);% Query the frame duration
%%
% % Inform the subject about the start of the task 
space  =     KbName('space') ;
image_start = imread('stimuli_set\ready.jpg') ;
image_start =  imresize(image_start, 0.5);
Task_initation   = Screen('MakeTexture', window,image_start); 
Screen('DrawTexture', window, Task_initation);
vbl  = Screen('Flip', window);
        while 1
            [a,b,keyCode] = KbCheck;
            if any(keyCode(space))
                Screen('Flip', window);
                break
            end
        end
% % test the termination message here 



%% creating all textures 
% make texxtures that are not realated to the stimuli like response screen 
image_response = imread('stimuli_set\Resp_PLD.jpg'); 
image_response =  imresize(image_response, 0.3);
Response_texture = Screen('MakeTexture', window,image_response); 
% make low and high response texture 
image_response_emotion = imread('stimuli_set\Resp_Emotion.jpg'); 
image_response_emotion =  imresize(image_response_emotion, 0.3);
Response_texture_emotion = Screen('MakeTexture', window,image_response_emotion);
image_end =  imread('stimuli_set\finish.jpg') ;
image_end =  imresize(image_end, 0.5);
Task_termination   = Screen('MakeTexture', window,image_end);
% make textures that are related to the walking stimulus
loaded_frame     = 500;
Texture.PLD      = Video_Text_Maker ('stimuli_set\PLD_BS'   ,loaded_frame,0,window);
Texture.Away     = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,0,window);
Texture.Toward   = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,0,window);
% load textures that are related to the face 
Im_path_happy    = 'stimuli_set\happy_face_1';
Im_path_angry    = 'stimuli_set\angry_face_1';


for i=1:34 
    if i<10
        image_nutre = imread(fullfile('stimuli_set\happy_face_1', strcat ( '__face005__0000', num2str(1),'.jpg')));
        textures_nutre{i}                 =  Screen('MakeTexture', window, image_nutre ) ;
        image_happy                       =  imread(fullfile(Im_path_happy, strcat ( '__face005__0000', num2str(i),'.jpg'))) ;    
        textures_happy{i}                 =  Screen('MakeTexture', window, image_happy ) ;
        image_angry                       =  imread(fullfile(Im_path_angry, strcat ( '__face005__0000', num2str(i),'.jpg'))) ;
        textures_angry{i}                 =  Screen('MakeTexture', window, image_angry  ) ;
     elseif  i>=10
        image_nutre = imread(fullfile('stimuli_set\happy_face_1', strcat ( '__face005__0000', num2str(1),'.jpg')));
        textures_nutre {i}                =  Screen('MakeTexture', window, image_nutre ) ;
        image_happy                       =  imread(fullfile(Im_path_happy, strcat ( '__face005__000', num2str(i),'.jpg'))) ;  
        textures_happy{i}                 =  Screen('MakeTexture', window, image_happy  ) ;
        image_angry                       =  imread(fullfile(Im_path_angry, strcat ( '__face005__000', num2str(i),'.jpg'))) ; 
        textures_angry{i}                 =  Screen('MakeTexture', window, image_angry ) ;
    end
end 
N = 400; % Number of rows
M = 300; % Number of columns
for i = 1 : 200
    white_noise_image = randn(N,M);
    white_noise_texture{i} = Screen('MakeTexture', window, white_noise_image);
end
%% Find the code of the keys we need during the task
Up    = KbName('uparrow')   ; Down  = KbName('downarrow') ; Right = KbName('rightarrow'); 
Left  = KbName('leftarrow') ; space  =     KbName('space') ;
%% setuo the others of the trails 
Chunke_number =7 ;
if Chunke_number < 5
    error ('Chunke_number should be more than 4');
end
Participant_responded = 0 ;
interval_for_modulation = repmat([3, 4], 1, Chunke_number);
trial_number = sum(interval_for_modulation) ; 
interval_for_modulation = interval_for_modulation(randperm(length(interval_for_modulation)));
Modulation_type = repmat([1, 2,3,4,5,6,7], 1, length(interval_for_modulation)/7);
interval_for_modulation = interval_for_modulation(randperm(length(interval_for_modulation)));
Modulation_type = Modulation_type(randperm(length(Modulation_type))) ; 
for i=2:length(interval_for_modulation)
interval_for_modulation(i) = interval_for_modulation(i)+interval_for_modulation(i-1) ; 
end
% flagg for modulation trail
%% adjust the postion of the walking stimuli  
picture = imread('stimuli_set/PLD_BS/frame1.jpg');
[picHeight, picWidth, ~] = size(picture);
distanceFromCenter =-140; % Change this value to adjust the distance from the center
[screenX, screenY] = Screen('WindowSize', window);
centerX = screenX/2;
desiredX = centerX - picWidth/2; % X position
desiredY = centerY + distanceFromCenter; % Y position
% Calculate the coordinates to place the picture at the desired position
positionRect = [desiredX, desiredY, desiredX + picWidth, desiredY + picHeight];
% Define button positions
buttonWidth = 400;
buttonHeight = 400;
screenRect = Screen('Rect', window);
leftButtonRect = [screenRect(3) / 4 - buttonWidth, screenRect(4) / 2 - buttonHeight / 2, screenRect(3) / 4, screenRect(4) / 2 + buttonHeight / 2];
rightButtonRect = [3 * screenRect(3) / 4, screenRect(4) / 2 - buttonHeight / 2, 3 * screenRect(3) / 4 + buttonWidth, screenRect(4) / 2 + buttonHeight / 2];


%% presenting the stimuli and getting the responses 
modulation_trail = 0  ; 
participant_score = 0 ; 
chunk_n = 1 ; 
last_trail = interval_for_modulation(end) ;


for trail=1 :trial_number 
        resp =0 ;  
         % terminate the session if the last trail has been reached 
        if trail == last_trail
            Screen('DrawTexture', window, Task_termination);
            Screen('Flip', window);
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 50);
            Screen('DrawText', window, num2str(participant_score), centerX, centerY, [255 0 0]);
            Screen('Flip', window);
        while 1
            [a,b,keyCode] = KbCheck;
            if any(keyCode(space))
                Screen('Flip', window);
                break
            end
        end
            % save(fil_name,'Info.mat');
            sca;
            break;
        end

        % find the type of the trail 
        if trail == interval_for_modulation(chunk_n )
            chunk_n = chunk_n + 1;
            modulation_trail = 1  ;
            if Modulation_type(chunk_n)     == 1 
                texture     = Texture.Away ;
                info.trail_type {trail} = 'Away';
                movement_stimulus = 1; 
            elseif Modulation_type(chunk_n) == 2
                texture     = Texture.Toward ;
                info.trail_type {trail} = 'Toward';
                movement_stimulus = 1; 
            elseif Modulation_type(chunk_n) == 3
                texture     =  textures_nutre;
                info.trail_type {trail} = 'Nutre';
                movement_stimulus = 0; 
                High_type = -1; 
            elseif Modulation_type(chunk_n) == 4
                texture     = textures_happy ;
                info.trail_type {trail} = 'Happy_high';
                movement_stimulus = 0; 
                High_type = 1; 
            elseif Modulation_type(chunk_n) == 5
                texture     = textures_angry ;
                info.trail_type {trail} = 'Angry_high';
                movement_stimulus = 0;
                High_type =1; 
            elseif Modulation_type(chunk_n) == 6
                texture     = textures_happy ;
                info.trail_type {trail} = 'Happy_low';
                movement_stimulus = 0;
                High_type = 0; 
            elseif Modulation_type(chunk_n) == 7
                texture     = textures_angry ;
                info.trail_type {trail} = 'Angry_low';
                movement_stimulus = 0;
                High_type = 0; 
            end
        else
            modulation_trail = 0  ;
            texture     = Texture.PLD ;
            info. trail_type {trail} = 'PLD';
            movement_stimulus = 1; 
        end
      
        if movement_stimulus == 1
            start_frame = randi([2, 20], 1, 1); 
            end_frame = 200; 
            IFW = 0.001 ; 
        elseif movement_stimulus == 0 && High_type == 0
            start_frame = 1 ;
            end_frame = 22+Block_number ; 
            IFW = 0.03 ; 
        elseif movement_stimulus ==0 && High_type == 1
            start_frame = 1 ;
            end_frame = 33 ;
            IFW = 0.03 ;
        elseif movement_stimulus ==0 && High_type == -1
            start_frame = 1 ;
            end_frame = 33 ;
            IFW = 0.03 ;
        end
        
   %present the white noise if modulation trial is reached
    if  modulation_trail == 1 
        N = 44100 *1.67; % Number of samples
        white_noise = randn(N,1);
        sound_obj = audioplayer(white_noise, 44100);
    for i=1 : 100
        Screen('DrawTexture', window, white_noise_texture{i}, [], [], 0);
        play(sound_obj);
        Screen('Flip', window);
    end
    end 
    %show the start of the task 
    % present the fixation cross
    Screen('DrawLine', window, lineColor, centerX, centerY-lineLength/2, centerX, centerY+lineLength/2, lineWidth);
    Screen('DrawLine', window, lineColor, centerX-lineLength/2, centerY, centerX+lineLength/2, centerY, lineWidth);
    Screen('Flip',window);
    WaitSecs(1);
        Participant_responded = 0 ;
    Screen('Flip', window);
    for i=start_frame: start_frame + end_frame
        if movement_stimulus == 1
            Screen('DrawTexture', window, texture{i},[],positionRect);
            vbl  = Screen('Flip', window);
        else 
            Screen('DrawTexture', window, texture{i});
            vbl  = Screen('Flip', window);
        end 
       
         WaitSecs(IFW);
    end
    %  wait if we have persented face stimulus 
    if movement_stimulus ~= 1 && High_type ==0
         WaitSecs(2.5+8*ifi);
    elseif movement_stimulus ~= 1 && High_type ==1
         WaitSecs(2.5);
    elseif movement_stimulus ~= 1 && High_type ==-1
        WaitSecs(2.5);
    end 

    if movement_stimulus == 1
        Screen('Flip',window)
        WaitSecs(0.5);
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
    elseif movement_stimulus == 0 &&  High_type ~= -1
        Screen('Flip',window)
        WaitSecs(0.5);
        T_0 = GetSecs() ;
        while 1
            [a,b,keyCode] = KbCheck;
            Screen('DrawTexture', window, Response_texture_emotion)
            Screen('Flip',window)
            if any(keyCode(Right)) ||any(keyCode(Left))
                info.Reaction_Time{trail} = GetSecs() - T_0 ;
                info.Respons{trail}  = KbName(keyCode);
                Beeper(1000,10);
                disp(KbName(keyCode));
                break
            end
        end
        if  strcmp(KbName(keyCode),'LeftArrow')&& High_type == 1
            % correct reponse 
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 50);
            Screen('DrawText', window, 'True', centerX, centerY, [0 255 0]);
            Screen('Flip', window);
            participant_score = participant_score+ 10 ; 
            WaitSecs(2);
        elseif strcmp(KbName(keyCode),'RightArrow')&& High_type == 1
            % uncorrect reponse
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 50);
            Screen('DrawText', window, 'False', centerX, centerY, [255 0 0]);
            Screen('Flip', window);
            participant_score = participant_score- 10 ; 
            WaitSecs(2);
        elseif strcmp(KbName(keyCode),'RightArrow')&& High_type == 0
            % correct reponse
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 50);
            Screen('DrawText', window, 'True', centerX, centerY, [0 255 0]);
            Screen('Flip', window);
            participant_score = participant_score+ 10 ; 
            WaitSecs(2);
        elseif strcmp(KbName(keyCode),'LeftArrow')&& High_type == 0
            % uncorrect reponse
            Screen('TextFont', window, 'Arial');
            Screen('TextSize', window, 50);
            Screen('DrawText', window, 'False', centerX, centerY, [255 0 0]);
            Screen('Flip', window);
            participant_score = participant_score- 10 ; 
            WaitSecs(2);
        end
        

    end
    
 
end 










