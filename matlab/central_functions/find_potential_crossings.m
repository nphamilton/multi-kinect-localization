function [ ] = find_potential_crossings(bots, publishers)
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose: Identify bots that might be about to cross from one Kinect's
% field of view to another.

% Globals and variable initializations
global kinect_locations;
global camDistToFloor;
numKinects = length(kinect_locations);
incomingList = strings(numKinects,1);

% Parse through all of the bots checking to see which ones have a
% hysteresis value greater than 1. If the bot hasn't been found twice, then
% it has likely crossed some boundary
for i = 1:length(bots)
    if bots(i).hyst > 1
        % Calculate which two Kinects are the closest (one should be the
        % Kinect it is currently assigned to)
        x = bots(i).X;
        y = bots(i).Y;
        z = bots(i).Z;
        closestDist = 100000000;
        closestKinect = 0;
        closestDist2 = 1000000000;
        closestKinect2 = 0;
        for j = 1:numKinects
            kinectX = kinect_locations(i,1);
            kinectY = kinect_locations(i,2);
            kinectZ = camDistToFloor;
            dist = sqrt((kinectX-x)^2 + (kinectY-y)^2 + (kinectZ-z)^2);
            if dist < closestDist2
                if dist < closestDist
                    closestDist2 = closestDist;
                    closestKinect2 = closestKinect;
                    closestDist = dist;
                    closestKinect = i;
                else
                    closestDist2 = dist;
                    closestKinect2 = i;
                end
            end
        end
        
        % Add them to the list of each Kinect as described in the
        % documentation
        incomingList(closestKinect) = strcat(incomingList(closestKinect),...
            num2str(closestKinect), ':', num2str(x), ':', num2str(y), ':', ...
            num2str(z), ':', num2str(i), ',');
        if closestKinect2 > 0
            incomingList(closestKinect2) = strcat(incomingList(closestKinect2),...
                num2str(closestKinect), ':', num2str(x), ':', num2str(y), ':', ...
                num2str(z), ':', num2str(i), ',');
        end
    end
end

% Publish the incomming lists
% Make sure the lists are the same size. If they aren't, an error should be posted
if numKinects == length(publishers)
	% If the sizes do match up, publish the associated bot list with each publisher
	for i = 1:numKinects
		% Create the message as a String type
		msg = rosmessage('std_msgs/String');
		msg.Data = char(incomingList(i));
		send(publishers(i),msg);
	end
else
	error('number of Kinects and number of imcoming publishers are not the same size.')
end

end

