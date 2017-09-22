function check_incoming(incomingList, responsePub, imgColor, imgDepth)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: To check fringes for possible crossing over of robots from
% outside the field of view to inside the field of view.

global botArray
global kinectNum
factor = 3.0;

% Parse the incoming list
splitList = strsplit(incomingList, ',');
robot_count = length(splitList);
robotNums = zeros(1,robot_count);
searchAreas = zeros(3,robot_count);
prevKinectNums = zeros(1,robot_count);
statuses = strings(1,robot_count);

for i = 2:robot_count
    currentRobInfo = strsplit(splitList(i), ':');
    robotNums(i) = str2num(currentRobInfo(1));
    searchAreas(1,i) = str2num(currentRobInfo(2));
    searchAreas(2,i) = str2num(currentRobInfo(3));
    searchAreas(3,i) = str2num(currentRobInfo(4));
    prevKinectNums(i) = str2num(currentRobInfo(5));
end

% Search the image for incomming robots
for i = 1:robot_count
    [center, radius] = getPixelCoord(robotNums(i), searchAreas(1,i), searchAreas(2,i), searchAreas(3,i));
    botArray(robotNums(i)).BBox = getBBox(center, radius, botArray(robotNums(i)).type, factor);
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

