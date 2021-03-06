% central_command_main.m
%
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose:
%
close all;
format longg;

load('run_number.mat')

% Declare global variables
global disp_waypoints;
global disp_waypoint_names;
global fig_closed;
global clear_history;
global waypoints_transmitted;
global send_launch;
global IP;
global bots;
global bot_lists;
global kinect_locations;
global camDistToFloor;
global BBoxFactor;
global gFrameCount;

% Define values for global variable
disp_waypoints = 1;
disp_waypoint_names = 0;
fig_closed = 0;
clear_history = 0;
waypoints_transmitted = 0;
send_launch = 0;
BBoxFactor = 3; % intentionally large because it is used for searching for drones not found in previous locations
IP = '10.255.24.255';
camDistToFloor = 3058; % in mm, as measured with Kinect

% Create generic publishers
botIDListPub = rospublisher('/botID_list','std_msgs/String');
kinectLocationPub = rospublisher('/kinectID_list','std_msgs/String');
shutdownPub = rospublisher('/shutdown','std_msgs/Byte');

% Other necessary variables from load_settings
USE_SERVER = 1; %Enable/disable the network server
USE_WPT = 1;    %Enable/disable loading waypoints and walls
USE_HISTORY = 1;%Enable/disable history
BOTLIST_FILENAME = 'robot_list.txt';
% Grid size and spacing parameters
TX_PERIOD = 0.05;	%sec
X_MAX = 3100;       %mm
Y_MAX = 3700;       %mm
LINE_LEN = 167;     %mm (should be iRobot Create radius)

% Path tracing variables
MOTION_HISTORY_SIZE = 5; % number of points used to determine if motion has occurred
HISTORY_SIZE = 2500; %number of points in each history for drawing

% File export settings
SAVE_TO_FILE = false;
OUTPUT_FILENAME = 'C:\data.xml';

% Setup the figure
fig = figure('KeyPressFcn',@fig_key_handler);

% Setup save file
if(SAVE_TO_FILE)
   fileHandle = fopen(OUTPUT_FILENAME,'w+'); 
end

% Open the list and parse through it to create the botID_list
[botID_list, kinectID_list, WPT_FILENAME] = parse_input(BOTLIST_FILENAME);

% Load the walls and waypoints (if required)
[walls, waypoints] = load_wpt(WPT_FILENAME, USE_WPT);

% Establish boundaries for each Kinect node
establish_boundaries(kinect_locations);

% Create kinect-specific subscribers
[numKinects, p] = size(kinect_locations);
botListPubs = robotics.ros.Publisher.empty(0,numKinects);
incomingPubs = robotics.ros.Publisher.empty(0,numKinects);
locationsSubs = robotics.ros.Subscriber.empty(0,numKinects);
responseSubs = robotics.ros.Subscriber.empty(0,numKinects);
for i = 1:numKinects
    botS = sprintf('/kinect%i/bot_list',i);
    incS = sprintf('/kinect%i/incoming',i);
    locS = sprintf('/kinect%i/locations',i);
    resS = sprintf('/kinect%i/response',i);
    botListPubs(i) = rospublisher(botS,'std_msgs/String');
    incomingPubs(i) = rospublisher(incS,'std_msgs/String');
    locationsSubs(i) = rossubscriber(locS,'std_msgs/String',@locationReportCallback);
    responseSubs(i) = rossubscriber(resS,'std_msgs/String',@incomingResponseCallback);
end

% Publish botID_list
msg = rosmessage('std_msgs/String');
msg.Data = char(botID_list);
send(botIDListPub,msg);

% Publish the specific bot lists
publish_bot_lists(botListPubs);

% Publish Kinect locations to kinectID_list
msg = rosmessage('std_msgs/String');
msg.Data = char(kinectID_list);
send(kinectLocationPub,msg);

% Now that both botID_list and kinectID_list have been published, the nodes
% will start searching for and reporting robot locations

gFrameCount = 0;
n = 0;
while true
    fprintf('Loop Number: %d\n',n);
    n = n + 1;
    % Check each robot's location information for potential boundary crossing
    % and inform the appropriate Kinects of the incident(s)
    find_potential_crossings(bots, incomingPubs);

    % Publish the updated bot lists
    publish_bot_lists(botListPubs);
    
    % Update the figure every ****** times
    frameCount = gFrameCount;
    if rem(frameCount,4) == 1
        plot_bots(fig, LINE_LEN, X_MAX, Y_MAX, bots, waypoints, walls,...
            disp_waypoints, disp_waypoint_names)
    end
    
    % Check the window command for exit command
    % Interpret an exit key press
    if get(fig,'currentkey') == 'x'
        disp('Exiting...');
        close all;
        % Send the shutdown command
        msg = rosmessage('std_msgs/Byte');
		msg.Data = 0;
		send(shutdownPub,msg);
        shutdown_track = 0;
        judp('SEND',4000,IP,int8('ABORT'));
        break;
    end
    
    if get(fig,'currentkey') == 'q'
        disp('Exiting...');
        close all;
        % Send the shutdown command
        msg = rosmessage('std_msgs/Byte');
		msg.Data = 0;
		send(shutdownPub,msg);
        shutdown_track = 1;
        judp('SEND',4000,IP,int8('ABORT'));
        break;
    end

    % If the window command indicates to send waypoints, send them
    if USE_SERVER == 1       
        % Send waypoints and robot positions
         if(waypoints_transmitted == 0)
             waypoints_transmitted = 1;
             server_send_waypoints(waypoints);
             if(SAVE_TO_FILE)
                save_robot_data(bots, fileHandle);
             end
         end

        % If launching the robots
        if send_launch == 1
            server_send_waypoints(waypoints);
            judp('SEND',4000,IP,int8(['GO ' int2str(size(waypoints,2)) ' ' int2str(run_number)]));
            run_number = run_number + 1;
            send_launch = 0;
        end
        
        % If aborting the robots
        if send_launch == -1
            judp('SEND',4000,IP,int8('ABORT'));
            disp('Aborting...');
            send_launch = 0;
            waypoints_transmitted = 1;
        end
    end
end

% Upon exit, do the following...
