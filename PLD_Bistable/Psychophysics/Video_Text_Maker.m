%% load images and make textures 
function [Textures]= Video_Text_Maker(Im_Path,Frame_Num,Intenstity_change,window)
    for i=1:Frame_Num
        image_address       = fullfile(Im_Path, strcat ( 'frame', num2str(i),'.jpg'));
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