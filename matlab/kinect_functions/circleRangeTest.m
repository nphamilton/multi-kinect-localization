% This script is used for testing the limits of the Kinect camera. At
% what point will the circle detection no longer work? That's what this
% script aims to answer.

% Other things needed for Kinect tracking
warning('off','images:imfindcircles:warnForSmallRadius')
num_frames = 10000; % number of frames kinect will capture
imgColorAll = zeros(480,640,3,num_frames,'uint8'); % stores all captured imgs
mm_per_pixel = 5.663295322; % mm in one pixel at ground level
found = false;
camDistToFloor = 3058; % in mm, as measured with Kinect

if exist('vid', 'var') && exist('vid2', 'var')
    stop([vid vid2]);
    clear vid vid2;
elseif exist('vid1', 'var') && exist('vid2', 'var')
    stop([vid1 vid2]);
    clear vid1 vid2;
end

vid = videoinput('kinect',1); %color 
vid2 = videoinput('kinect',2); %depth

vid.FramesPerTrigger = 1;
vid2.FramesPerTrigger = 1;

vid.TriggerRepeat = num_frames;
vid2.TriggerRepeat = num_frames;

triggerconfig([vid vid2],'manual');
start([vid vid2])
% tigger a couple times in case first frames are bad
trigger([vid vid2])
trigger([vid vid2])

disp('setup complete')

while true
    trigger([vid vid2])
    % Get the acquired frames and metadata.
    [imgColor, ts_color, metaData_Color] = getdata(vid);
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);
    
    % Using the iRobot Create2 specifications
    rmin = 25;
    rmax = 35;
    % find circles
    [centers, radii, metrics] = imfindcircles(imgColor, [rmin,rmax], ...
        'ObjectPolarity', 'dark', 'Sensitivity', 0.96);
    
    % Display the results
    figure(1);
    image(imgColor) 
    hold on 
    viscircles(centers, radii);
    hold off
end