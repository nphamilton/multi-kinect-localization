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

% Declare tracking Factors
hysteresis = 100;
BBoxFactor = 1.7;

% Fetch the botID_list info

% Initiale the kinect using the gained info
initialize_system(botIDList);

% Fetch the specified bot_list info

% Find all of the robots specified by the master
find_robots(botList);

% Report the location information
report_locations(botList);

% Setup subscription for window_command

% Setup subscription for incoming

% Track the robots and report their locations until commands come in to
% exit or quit
while windowCommand ~= 'x' %TODO: INCLUDE ALL ENDING STUFF
    % Fetch specified bot_list info
    
    % Track the specified bots
    track_bots(botList);
    
    % Check for incoming bots
    check_incoming(incomingList);
    
    % Report location information
    report_locations(botList);
end

% Upon exit, do this shit...