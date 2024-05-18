
% Assert that Psychtoolbox is properly installed
info.RT=[];
info.RK=[];

AssertOpenGL;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);
% Get a list of all the image files in the 'frames' folder
numFrames  = 800 ; button = 0 ; Response_number = 0 ; Respponse_name  = 'Nan' ; video_frames = 300 ; start_frame  = 50 ;
% Get the screen numbers
screens = Screen('Screens');
% Draw to the external screen if avaliable
screenNumber = max(screens);
screenNumber = 1
% Define black and white
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

% Open an on screen window
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);

% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Query the frame duration
ifi = Screen('GetFlipInterval', window);

% Pre-load images and textures
info.textures = {};
respose_image    = imread ('stimuli_set\Response.jpg') ;
texture_response =  Screen('MakeTexture', window, respose_image);
% specify the keys 
Up = KbName('uparrow');
Down = KbName('downarrow');
Right = KbName('rightarrow');
Left = KbName('leftarrow');
Exit =     KbName('space');
for i = 1:numFrames
    % Load the image
    image_PLD         = imread(fullfile('stimuli_set', 'PLD_BS', strcat ( 'frame', num2str(i),'.jpg')));
    image_HL_away     = imread(fullfile('stimuli_set', 'Away_HL', strcat ( 'frame', num2str(i),'.jpg')));
    image_HL_toward   = imread(fullfile('stimuli_set', 'Toward_HL', strcat ( 'frame', num2str(i),'.jpg')));
    
    % Make the image into a texture
    if i>90
        textures_HL_away_ini{i}     = Screen('MakeTexture', window, image_HL_away *  (1+i*0.0009) );
        textures_HL_towards_ini{i}  = Screen('MakeTexture', window, image_HL_toward* (1+i*0.0009) );
        textures_HL_away_dci{i}     = Screen('MakeTexture', window, image_HL_away *  (1+(-i*0.0009)));
        textures_HL_towards_dci{i}  = Screen('MakeTexture', window, image_HL_toward* (1+(-i*0.0009)));
    else
        textures_HL_away_ini{i}     = Screen('MakeTexture', window, image_HL_away   );
        textures_HL_towards_ini{i}  = Screen('MakeTexture', window, image_HL_toward );
        textures_HL_away_dci{i}     = Screen('MakeTexture', window, image_HL_away   );
        textures_HL_towards_dci{i}  = Screen('MakeTexture', window, image_HL_toward );
    end 
    textures_PLD{i}             = Screen    ('MakeTexture', window, image_PLD)  ;
    
end

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 0.2;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
% Loop through each image texture and present it on the scree

trial_type  = 'Nan' ; 
for c = 1:30
    random_int = randi([1, 15], 1, 1);
    start_frame = randi([2, 90], 1, 1);
    [a,b,keyCode] = KbCheck;

    for i = start_frame:start_frame + video_frames

        % Display the texture on the screen
        
        if random_int > 5 
            texture = textures_PLD{i} ;
            trial_type = 1; 
        elseif random_int == 2
          
            texture = textures_HL_away_ini{i};
            trial_type = 2;
        elseif random_int == 3
            
            texture = textures_HL_towards_ini{i} ;
            trial_type = 3;
        elseif random_int == 4
           
            texture =  textures_HL_away_dci{i};
            trial_type = 4';
        elseif random_int == 5
         
            texture =  textures_HL_towards_dci{i};
            trial_type = 5;
        end
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        Screen('DrawTexture', window, texture)
        if random_int <= 5
            [a,b,keyCode] = KbCheck;
            if (any(keyCode(Left))||any(keyCode(Right)) )
                break;
            end
        end 
        
        
        
    end
WaitSecs(0.2) ; 

    while 1
         [a,b,keyCode] = KbCheck;

         Screen('Flip', window);
         % Close the Psychtoolbox screen
         if any(trial_type == 1)
             if any(keyCode(Up))
                 Response_number = 1    ;
                 Respponse_name  = 'UP' ;
                 break;
             elseif any(keyCode(Down))
                 Response_number = 2    ;
                 Respponse_name  = 'Down' ;
                 break;
             end
         elseif any(trial_type > 1)
             if any(keyCode(Right))
                 Response_number = 3    ;
                 Respponse_name  = 'Right' ;
                 break;
             elseif any(keyCode(Left))
                 Response_number = 4   ;
                 Respponse_name  = 'Left' ;
                 break;
             end

         end
         if any(keyCode(Exit))
           sca;
         end
     end
end 

sca;