% Open the video file
videoFile = 'Away_HL.mp4';
videoObj = VideoReader(videoFile);

% Extract frames from the video
numFrames = floor(videoObj.Duration *videoObj.FrameRate);
for i = 1:numFrames
    frame = read(videoObj, i);
    
    % Convert the frame to an image
    image = frame;
    
    % Save the image as a JPEG file
    imwrite(image, strcat('Away_HL\frame', num2str(i), '.jpg'));
end