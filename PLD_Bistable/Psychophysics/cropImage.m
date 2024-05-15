function cropped_image = cropImage(image_address,mask_address,a,b,c,d)
    % Load the image
    image = imread(image_address);
    mask   = imread(mask_address);
    image_double = im2double(image);
    mask_double = im2double(mask);
    masked_image =  mask_double.*image_double ;
    
    % Crop the image
    cropped_image = masked_image(b:d, a:c, :);

    % Display the cropped image
    imshow(cropped_image);
end