function initialize_system(botIDList, kinectIDList)
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose: The purpose of this function is to gether information from the
% master about how many bots there are in the system and, more
% specifically, which ones need to be found at this node. Additionally, the
% Kinect is initialized in this function.

global botArray
global kinectNum
global xCenterMM
global yCenterMM

% Initialize the Kinect's central location
splitKinectList = strsplit(kinectIDList, ',');
kinect_count = length(splitKinectList);

for i = 1:kinect_count
    temp = strrep(splitKinectList(i), ':', ' ');
    currentKinectInfo = str2num(temp);
    if currentKinectInfo(1) == kinectNum
        xCenterMM = currentKinectInfo(2);
        yCenterMM = currentKinectInfo(3);
    end
end

% Initialize botArray and assign all bots to their location
splitBotList = strsplit(botIDList, ',');
robot_count = length(splitBotList);
robNames = cell(1,robot_count);
robTypes = cell(1,robot_count);
robColors = cell(1,robot_count);

for i = 1:robot_count
    currentRobInfo = strsplit(splitBotList(i), ':');
    robNames(i) = currentRobInfo(1);
    robTypes(i) = currentRobInfo(2);
    robColors(i) = currentRobInfo(3);
end

botArray = Robot.empty(robot_count,0);
for i = 1:robot_count
    botArray(i) = Robot;
    botArray(i).name = robNames(i);
    botArray(i).type = robTypes(i);
    botArray(i).color = robColors(i);
end

% This code is only used if using the IMAQ tool
% % Initialize the Kinect by capturing a few frames
% if exist('vid', 'var') && exist('vid2', 'var')
%     stop([vid vid2]);
%     clear vid vid2;
% elseif exist('vid1', 'var') && exist('vid2', 'var')
%     stop([vid1 vid2]);
%     clear vid1 vid2;
% end
% 
% vid1 = videoinput('kinect',1); %color 
% vid2 = videoinput('kinect',2); %depth
% 
% vid1.FramesPerTrigger = 1;
% vid2.FramesPerTrigger = 1;
% 
% vid1.TriggerRepeat = num_frames;
% vid2.TriggerRepeat = num_frames;
% 
% triggerconfig([vid1 vid2],'manual');
% start([vid1 vid2]);
% % trigger a couple times in case first frames are bad
% trigger([vid1 vid2])
% trigger([vid1 vid2]) 

end

