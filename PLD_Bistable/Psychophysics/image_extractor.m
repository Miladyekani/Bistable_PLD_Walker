% Open the video file
videoFile = 'PLD_BS.mp4';
videoObj = VideoReader(videoFile);

% Extract frames from the video
numFrames = floor(videoObj.Duration *videoObj.FrameRate);
for i = 1:numFrames
    frame = read(videoObj, i);
    
    % Convert the frame to an image
    image = frame;
    
    % Save the image as a JPEG file
    imwrite(image, strcat('stimuli_set\PLD_BS\frame', num2str(i), '.jpg'));
end