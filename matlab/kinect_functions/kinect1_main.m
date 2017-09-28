% kinect1_main.m
% 
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this code is to run the entirety of the kinect1
% code from initialization to active tracking to exiting upon completion.

% Declare all global variables that will be used
global mm_per_pixel
global camDistToFloor
global kinectNum
global BBoxFactor
global hysteresis
global MINIDRONE
global CREATE2
global ARDRONE
global THREEDR
global GHOST2
global MAVICPRO
global PHANTOM3
global PHANTOM4
global botArray
global IP
global xCenterMM
global yCenterMM
global invertedCamera
global botIDList
global kinectIDList
global botList
global shutdown_command
global incomingList
global rgbImageName
global depthImageName

IP = '0';

% Assign drone definitions
MINIDRONE = 100;
CREATE2 = 101;
ARDRONE = 102;
THREEDR = 103;
GHOST2 = 104;
MAVICPRO = 105;
PHANTOM3 = 106;
PHANTOM4 = 107;

% Establish Kinect Settings
% NOTE: THESE VALUES CHANGE FOR EACH KINECT
camDistToFloor = 3058; % in mm, as measured with Kinect
mm_per_pixel = 5.663295322; % mm in one pixel at ground level
warning('off','images:imfindcircles:warnForSmallRadius')
kinectNum = 1;
invertedCamera = 0;
rgbImageName = 'rgb_image.jpg';
depthImageName = 'depth_image.jpg';


% Declare tracking Factors
hysteresis = 100;
BBoxFactor = 1.7;

% Initialize the values which will be filled by subscriptions
botIDList = "";
botList = "";
shutdown_command = 0;
incomingList = "";

% initialize remaining global variables
xCenterMM = 0;
yCenterMM = 0;

% Create generic subscribers
botIDListSub = rossubscriber('/botID_list','std_msgs/String',@botIDListCallback);
kinectIDListSub = rossubscriber('/kinectID_list','std_msgs/String',@kinectIDListCallback);
shutdownSub = rossubscriber('/shutdown','std_msgs/Byte',@shutdownCallback);

% Create Kinect-specific subscribers
botListSub = rossubscriber('/kinect1/bot_list','std_msgs/String',@botListCallback);
incomingSub = rossubscriber('/kinect1/incoming','std_msgs/String',@incomingCallback);

% Create publishers. All are Kinect-specific.
locationPub = rospublisher('/kinect1/locations','std_msgs/String');
responsePub = rospublisher('/kinect1/response','std_msgs/String');

% Wait until the botID_list has been sent
while strcmp(botIDList,'') == 1 || strcmp(kinectIDList,'') == 1
end

% Initiale the kinect using the gained info
initialize_system(botIDList, kinectIDList);

% Find all of the robots specified by the master
find_robots(botList, imgColor, imgDepth);

% Report the location information
report_locations(botList);

% Track the robots and report their locations until commands come in to
% exit or quit
while shutdown_command == 0
    % Use the Kinect to collect an image
% This code is for use with MatLab's IMAQ tool on a Windows device
%     trigger([vid vid2])
%     [imgColor, ts_color, metaData_Color] = getdata(vid);
%     [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);

% This code is for use with a Linux device running the cameraParsr.cpp
% program
    imgColor = imread(rgbImageName,jpg);
    imgDepth = imread(depthImageName,jpg);

    % Track the specified bots
    track_bots(botList, imgColor, imgDepth);
    
    % Check for incoming bots if there are any
    if strcmp(incomingList,'') == 0
        check_incoming(incomingList, responsePub, imgColor, imgDepth);
    end
    
    % Report location information
    report_locations(botList, locationPub);
end

% Upon exit, do the following...