%% Instruction for subject 
AssertOpenGL;
PsychDefaultSetup(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
screens = Screen('Screens');
screenNumber = max(screens); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, black);% Open an on screen window
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);% Enable alpha blending for anti-aliasing
[screenXpixels, screenYpixels] = Screen('WindowSize', window);% Get the size of the on screen window

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ifi = Screen('GetFlipInterval', window);% Query the frame duration

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
INS_1=  imread ('stimuli_set\INS_1.jpg') ;  % PLD will come
INS_2=  imread ('stimuli_set\INS_2.jpg') ;  % How to respond to PLD 
INS_3=  imread ('stimuli_set\Response.jpg') ;  % HL will come 




