%% psychopysics task from scratch 
% struct for saving the data 
info.Reactio_Time =[]; info.Response =[]; info.Start_Frame = [] ; 
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
% Enable alpha blending for anti-aliasing
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA); % ??? dont know 
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
ifi = Screen('GetFlipInterval', window);% Query the frame duration
loaded_frame = 500;
%%% load textures 
Texture.Away.In    = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,1,window);
Texture.Away.Di    = Video_Text_Maker ('stimuli_set\Away_HL'  ,loaded_frame,2,window);
Texture.Toward.In  = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,1,window);
Texture.Toward.Di  = Video_Text_Maker ('stimuli_set\Toward_HL',loaded_frame,2,window);
Texture.PLD        = Video_Text_Maker ('stimuli_set\PLD_BS'   ,loaded_frame,0,window);

vbl  = Screen('Flip', window);
for i=1:300
    Screen('DrawTexture', window, Texture.Away.Di{i} )
    vbl  = Screen('Flip', window);
end
%% Find the code of the keys we need during the task
Up    = KbName('uparrow')   ; Down  = KbName('downarrow') ; Right = KbName('rightarrow'); 
Left  = KbName('leftarrow') ; Exit  =     KbName('space') ;
%%

%% load images and make textures 
function [Textures]= Video_Text_Maker(Im_Path,Frame_Num,Intenstity_change,window)
    for i=1:Frame_Num
        image_address       = fullfile(Im_Path, strcat ( 'frame', num2str(i),'.jpg'));
        disp(image_address)
        image               = imread(image_address);
        if Intenstity_change == 1 && i>90
            textures{i}  =  Screen('MakeTexture', window, image * (1+i*0.0009)  ) ;
        elseif Intenstity_change == 2 &&  i>90
            textures{i}  =  Screen('MakeTexture', window, image * (1+(-i*0.0009)));
        else
            textures{i}  =  Screen('MakeTexture', window, image  ) ;
        end
    Textures = textures ; 
    end


end