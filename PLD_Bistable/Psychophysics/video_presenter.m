
% Assert that Psychtoolbox is properly installed

AssertOpenGL;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get a list of all the image files in the 'frames' folder
imageFiles_PLD       = dir('stimuli_set/bistable_point_light_stimulus/*.jpg');
imageFiles_HL_toward = dir('stimuli_set/Toward_HL/*.jpg');
imageFiles_HL_away   = dir('stimuli_set/Away_HL/*.jpg');
numFrames = length(imageFiles_PLD);
numFrames  = 800 ; 
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
textures = cell(1, numFrames);
respose_image    = imread ('stimuli_set\Response.jpg') ;
texture_response =  Screen('MakeTexture', window, respose_image);
for i = 1:numFrames
    % Load the image
    image_PLD         = imread(fullfile('stimuli_set', 'bistable_point_light_stimulus', strcat ( 'frame', num2str(i),'.jpg')));
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
button = 0 ; 
Response_number = 0 ; 
Respponse_name  = 'Nan' ; 
video_frames = 300 ; 
start_frame  = 50 ;

for c = 1:30
    random_int = randi([1, 15], 1, 1);

    for i = start_frame:start_frame + video_frames
        % Get the texture
        texture_pld           =  textures_PLD{i}             ;
        texture_hl_away_ini   =  textures_HL_away_ini{i}     ;
        texture_hl_toward_ini =  textures_HL_towards_ini{i}  ;
        texture_hl_away_dci   =  textures_HL_away_dci{i}     ;
        texture_hl_toward_dci =  textures_HL_towards_dci{i}  ;
        % Display the texture on the screen
        
        if random_int > 4 
            texture = texture_pld;
        elseif random_int == 2
            texture = texture_hl_away_ini;
        elseif random_int == 3
            texture = texture_hl_toward_ini;
        elseif random_int == 4
            texture = texture_hl_toward_dci;
        end
        vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
        Screen('DrawTexture', window, texture)
        
        
        
        
    end
WaitSecs(0.2) ; 

    while 1
         Up = KbName('uparrow');
         Down = KbName('downarrow');
         [a,b,keyCode] = KbCheck;
         Screen('DrawTexture', window, texture_response);
         Screen('Flip', window);
         % Close the Psychtoolbox screen
         if any(keyCode(Up))
             Response_number = 1    ;
             Respponse_name  = 'UP' ;
             
             break;
         end
         if any(keyCode(Down))
             Response_number = 2    ;
             Respponse_name  = 'Down' ;
             break;
         end
     end
end 

sca;