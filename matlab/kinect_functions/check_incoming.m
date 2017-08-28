function check_incoming(incomingList, responsePub, imgColor, imgDepth)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: To check fringes for possible crossing over of robots from
% outside the field of view to inside the field of view.

global botArray
global kinectNum

% Parse the incoming list
splitList = strsplit(incomingList, ',');
robot_count = length(splitList);
robotNums = cell(1,robot_count);
searchAreas = cell(1,robot_count);
prevKinectNums = cell(1,robot_count);
statuses = cell(1,robot_count);

for i = 2:robot_count
    currentRobInfo = strsplit(splitList(i), ':');
    robotNums(i) = currentRobInfo(1);
    searchAreas(i) = currentRobInfo(2);
    prevKinectNums(i) = currentRobInfo(3);
end

% Search the image for incomming robots
for i = 1:robot_count
    botArray(robotNums(i)).BBox = 0; %FIX DIS IS CRAP
    trackBots(imgColor, imgDepth, robotNums(i));
    
    % If the robot was not found, then the hysteresis value will be greater
    % than 0 and the status should indicate not present
    if botArray(robotNums(i)).hyst > 0
        statuses(i) = 'NP'; % NP for "Not Present"
    % The hysteresis value will be 0 if it was found and the status should
    % indicate present
    else
        statuses(i) = 'P'; % P for "Present"
    end
end

% Report findings
k = num2str(kinectNum);
index = robotNums(1);
report = strcat(k,',',num2str(index), ':', statuses(1), ':', prevKinectNums(1));
for i = 2:length(indeces)
    index = robotNums(i);
    temp = strcat(num2str(index), ':', statuses(i), ':', prevKinectNums(i));
    report = strcat(report, ',', temp);
end
% The report has been made, so publish it
msg = rosmessage('std_msgs/String');
msg.Data = report;
send(responsePub,msg);

end

