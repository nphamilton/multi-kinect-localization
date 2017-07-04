function [ ] = locationReportCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the recorded location
% information of each robot.

global bots

% Split the report into its components: kinect#,botInfo,botInfo,...
report = strsplit(msg.Data, ',');

% Extract the Kinect number
kinectNum = str2double(report(1));

% Extract each robots info and record it
for i = 2:length(report)
    % Split the current bot into its individual components:
    % bot#:r:X:Y:Z:Y:Hysteresis
    currentBot = strsplit(report(i),':');
    
    % Extract the bot number
    botNum = str2double(currentBot(1));
    
    % Extract and update the radius information
    bots(botNum).radius = str2double(currentBot(2));
    bots(botNum).radii = [bots(botNum).radii, bots(botNum).radius];
    
    % Extract and update the X information
    bots(botNum).X = str2double(currentBot(3));
    bots(botNum).Xs = [bots(botNum).Xs, bots(botNum).X];
    
    % Extract and update the Y information
    bots(botNum).Y = str2double(currentBot(4));
    bots(botNum).Ys = [bots(botNum).Ys, bots(botNum).Y];
    
    % Extract and update the Z information
    bots(botNum).Z = str2double(currentBot(5));
    bots(botNum).Zs = [bots(botNum).Zs, bots(botNum).Z];
    
    % Extract and update the yaw information
    bots(botNum).yaw = str2double(currentBot(6));
    bots(botNum).yaws = [bots(botNum).yaws, bots(botNum).yaw];
    
    % Extract and update the hysteresis information
    bots(botNum).hyst = str2double(currentBot(7));
    
    % Update kinectNum
    bots(botNum).kinectNum = kinectNum;
    bots(botNum).kinectNums = [bots(botNum).kinectNums, bots(botNum).kinectNum];
end

end