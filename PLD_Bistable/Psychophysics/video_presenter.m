
% Assert that Psychtoolbox is properly installed

AssertOpenGL;

% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get a list of all the image files in the 'frames' folder
imageFiles = dir('stimuli_set/bistable_point_light_stimulus/*.jpg');
numFrames = length(imageFiles);
numFrames  = 100 ; 
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
    image = imread(fullfile('stimuli_set', 'bistable_point_light_stimulus', strcat ( 'frame', num2str(i),'.jpg')));
    
    % Make the image into a texture
    textures{i} = Screen('MakeTexture', window, image);
end

% Sync us and get a time stamp
vbl = Screen('Flip', window);
waitframes = 1;

% Maximum priority level
topPriorityLevel = MaxPriority(window);
Priority(topPriorityLevel);
% Loop through each image texture and present it on the scree

for i = 1:numFrames
    % Get the texture
    texture = textures{i};
    
    % Display the texture on the screen

    vbl  = Screen('Flip', window, vbl + (waitframes - 0.5) * ifi);
    Screen('DrawTexture', window, texture)
   



end
WaitSecs(1);
Screen('DrawTexture', window, texture_response);
Screen('Flip', window);
WaitSecs(1);
response = 0;
while ~response
    [~, ~, keyCode] = KbCheck;
    keyIndex = find(keyCode);
    
    keyName = KbName(keyIndex);

end
% Close the Psychtoolbox screen
sca;