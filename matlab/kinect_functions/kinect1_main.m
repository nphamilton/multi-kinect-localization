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
camDistToFloor = 3058; % in mm, as measured with Kinect
mm_per_pixel = 5.663295322; % mm in one pixel at ground level
warning('off','images:imfindcircles:warnForSmallRadius')
kinectNum = 1;

% Declare tracking Factors
hysteresis = 100;
BBoxFactor = 1.7;

% Create generic subscribers
botIDListSub = rossubscriber('/botID_list','std_msgs/String');
wndwCmndSub = rossubscriber('/window_command','std_msgs/String');

% Create Kinect-specific subscribers
botListSub = rossubscriber('/kinect1/bot_list','std_msgs/String');
incomingSub = rossubscriber('/kinect1/incoming','std_msgs/String');

% Create publishers. All are Kinect-specific.
locationPub = rospublisher('/kinect1/locations','std_msgs/String');
responsePub = rospublisher('/kinect1/response','std_msgs/String');

% Fetch the botID_list info
msg = receive(botIDListSub,1); % This should never take longer than a second to receive
botIDList = msg.Data;

% Initiale the kinect using the gained info
initialize_system(botIDList);

% Fetch the specified bot_list info
msg = receive(botListSub,1); % This should never take longer than a second to receive
botList = msg.Data;

% Find all of the robots specified by the master
find_robots(botList, imgColor, imgDepth);

% Report the location information
report_locations(botList);

% Fetch window_command
msg = receive(wndwCmndSub,1); % This should never take longer than a second to receive
windowCommand = msg.Data;

% Track the robots and report their locations until commands come in to
% exit or quit
while windowCommand ~= 'x' && windowCommand ~= 'q'
    % Fetch specified bot_list info and incoming bots
    msg = receive(botListSub,1); % This should never take longer than a second to receive
    botList = msg.Data;
    msg = receive(incomingSub,1); % This should never take longer than a second to receive
    incomingList = msg.Data;
    
    % Use the Kinect to collect an image
    trigger([vid vid2])
    [imgColor, ts_color, metaData_Color] = getdata(vid);
    [imgDepth, ts_depth, metaData_Depth] = getdata(vid2);

    % Track the specified bots
    track_bots(botList, imgColor, imgDepth);
    
    % Check for incoming bots if there are any
    if incomingList ~= ''
        check_incoming(incomingList, responsePub, imgColor, imgDepth);
    end
    
    % Update bot_list just in case the incoming changed something
    msg = receive(botListSub,1); % This should never take longer than a second to receive
    botList = msg.Data;
    
    % Report location information
    report_locations(botList, locationPub);
    
    % Fetch window_command
    msg = receive(wndwCmndSub,1); % This should never take longer than a second to receive
    windowCommand = msg.Data;
end

% Upon exit, do this shit...