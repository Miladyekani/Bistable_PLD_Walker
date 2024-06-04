%%
clc; clear ; 
%% psychopysics task from scratch 
% struct for saving the data 
participantName    = input('Enter the participant name: ', 's');
Type_of_experiment = input('type of experiment: ');
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
%% creating all textures 
% make texxtures that are not realated to the stimuli like response screen 
Response_texture = Screen('MakeTexture', window,imread('stimuli_set\Resp_Stimuli_for_PLD.jpg')); 
% make textures that are related to the walking stimulus
loaded_frame     = 500;
Texture.PLD      = Video_Text_Maker ('stimuli_set\PLD_BS'   ,loaded_frame,0,window);
Texture.Away     = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,0,window);
Texture.Toward   = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,0,window);
% load textures that are related to the face 
Im_path_happy    = 'stimuli_set\happy_face_1';
Im_path_angry    = 'stimuli_set\angry_face_1';


for i=1:50 
    if i<10
        image_nutre = imread(fullfile('stimuli_set\happy_face_1', strcat ( '__face005__0000', num2str(1),'.jpg')));
        textures_nutre{i}                 =  Screen('MakeTexture', window, image_nutre ) ;
        image_happy                       =  imread(fullfile(Im_path_happy, strcat ( '__face005__0000', num2str(i),'.jpg'))) ;    
        textures_happy{i}                 =  Screen('MakeTexture', window, image_happy ) ;
        image_angry                       =  imread(fullfile(Im_path_angry, strcat ( '__face005__0000', num2str(i),'.jpg'))) ;
        textures_angry{i}                 =  Screen('MakeTexture', window, image_angry  ) ;
     elseif i<35 && i>9
        image_nutre = imread(fullfile('stimuli_set\happy_face_1', strcat ( '__face005__0000', num2str(1),'.jpg')));
        textures_nutre {i}                =  Screen('MakeTexture', window, image_nutre ) ;
        image_happy                       =  imread(fullfile(Im_path_happy, strcat ( '__face005__000', num2str(i),'.jpg'))) ;  
        textures_happy{i}                 =  Screen('MakeTexture', window, image_happy  ) ;
        image_angry                       =  imread(fullfile(Im_path_angry, strcat ( '__face005__000', num2str(i),'.jpg'))) ; 
        textures_angry{i}                 =  Screen('MakeTexture', window, image_angry ) ;
    elseif  i>=35 
        image_nutre = imread(fullfile('stimuli_set\happy_face_1', strcat ( '__face005__0000', num2str(1),'.jpg')));
        textures_nutre  {i}               =  Screen('MakeTexture', window, image_nutre ) ;
        image_happy                       =  imread(fullfile(Im_path_happy, strcat ( '__face005__00035','.jpg'))) ;      
        textures_happy{i}                 =  Screen('MakeTexture', window, image_happy  ) ;
        image_angry                       =  imread(fullfile(Im_path_angry, strcat ( '__face005__00035','.jpg'))) ;
        textures_angry{i}                 =  Screen('MakeTexture', window, image_angry ) ;
    end
end 

%% Find the code of the keys we need during the task
Up    = KbName('uparrow')   ; Down  = KbName('downarrow') ; Right = KbName('rightarrow'); 
Left  = KbName('leftarrow') ; space  =     KbName('space') ;
%% setuo the others of the trails 
Chunke_number =5 ;
if Chunke_number < 5
    error ('Chunke_number should be more than 4');
end
Participant_responded = 0 ;
interval_for_modulation = repmat([5, 6], 1, Chunke_number);
trial_number = sum(interval_for_modulation) ; 
interval_for_modulation = interval_for_modulation(randperm(length(interval_for_modulation)));
Modulation_type = repmat([1, 2,3,4,5], 1, length(interval_for_modulation)/5);
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
%% presenting the stimuli and getting the responses 
modulation_trail = 0  ; 
chunk_n = 1 ; 
last_trail = interval_for_modulation(end) ;
for trail=1 :trial_number 
        resp =0 ;  
         % terminate the session if the last trail has been reached 
        if trail == last_trail
            % save(fil_name,'Info.mat');
            sca;
            break;
        end
        % present the fixation cross 
        Screen('DrawLine', window, lineColor, centerX, centerY-lineLength/2, centerX, centerY+lineLength/2, lineWidth);
        Screen('DrawLine', window, lineColor, centerX-lineLength/2, centerY, centerX+lineLength/2, centerY, lineWidth);
        Screen('Flip',window);
        WaitSecs(1);
        Participant_responded = 0 ;
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
            elseif Modulation_type(chunk_n) == 4
                texture     = textures_happy ;
                info.trail_type {trail} = 'Happy';
                movement_stimulus = 0; 
            elseif Modulation_type(chunk_n) == 5
                texture     = textures_angry ;
                info.trail_type {trail} = 'Angry';
                movement_stimulus = 0; 
            end
        else
            modulation_trail = 0  ;
            texture     = Texture.PLD ;
            info. trail_type {trail} = 'PLD';
            movement_stimulus = 1; 
        end
      
        if movement_stimulus == 1
            start_frame = randi([2, 20], 1, 1); ; 
            end_frame = 200; 
            IFW = 0.001 ; 
        else
            start_frame = 1 ;
            end_frame = 49 ; 
            IFW = 0.03 ; 
        end 
        
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
    end
end 
sca ; 










