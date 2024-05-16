
%% try to crop the imaged by code 
% load and display the Iamge 
image = imread(fullfile('stimuli_set', 'Away_HL', strcat ( 'frame', num2str(3),'.jpg')));
 
% load and display the mask 
mask   = imread(fullfile('stimuli_set', strcat ( 'mask.jpg')));
% multiply them 
% present them 
image_double = im2double(image);
mask_double = im2double(mask);
result =  mask_double.*image_double ;

%%
mask   = imread(fullfile('stimuli_set',  'mask.jpg'));
a = 535;
b = 200;
c = 735;
d = 550;
for i = 1:1012
    image = imread(fullfile('stimuli_set', 'Away_HL', strcat ( 'frame', num2str(i),'.jpg')));
    image_double = im2double(image);
    mask_double = im2double(mask);
    masked_image =  mask_double.*image_double ;
    cropped_image = masked_image(b:d, a:c, :);
    imwrite(cropped_image, fullfile('stimuli_set', 'Away_HL', strcat ( 'frame', num2str(i),'.jpg')));
    
end
