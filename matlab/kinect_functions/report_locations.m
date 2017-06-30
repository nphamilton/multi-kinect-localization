function report_locations(botList, publisher)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to report location information
% recorded by the Kinect to the main computer so it can record the
% information and determine which systems should be looking for which bots.

numBots = length(botList);
indeces = str2num(botList);

if numBots > 0
    % If any robots are present, then report a comma-delimited list
    % of bot info
    index = indeces(1);
    report = strcat(num2str(index), ':', num2str(botArray(index).radius), ...
    ':', num2str(botArray(index).X), ':',  num2str(botArray(index).Y), ...
    num2str(botArray(index).Z), ':', num2str(botArray(index).yaw), ':', ...
    num2str(botArray(index).hysteresis));
    for i = 2:length(indeces)
        index = indeces(i);
        temp = strcat(num2str(index), ':', num2str(botArray(index).radius), ...
        ':', num2str(botArray(index).X), ':',  num2str(botArray(index).Y), ...
        num2str(botArray(index).Z), ':', num2str(botArray(index).yaw), ':', ...
        num2str(botArray(index).hysteresis));
        report = strcat(report, ',', temp);
    end
else
    % If no robots are present in this Kinect's field of view, report an
    % empty string
    report = '';
end

% The report has been made, so publish it
msg = rosmessage('std_msgs/String');
msg.Data = report; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
send(publisher,msg);

% Additionally, send the information to the robots themselves
server_send_robots(indeces);
end

