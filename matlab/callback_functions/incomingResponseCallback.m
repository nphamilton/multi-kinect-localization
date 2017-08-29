function [ ] = incomingResponseCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update bot lists based on the responses returned from each Kinect node.

global bot_lists

% Split the messge into its components: kinect#,botInfo,botInfo,...
report = strsplit(msg.Data,',');

% Extract the Kinect number
kinectNum = str2double(report(1));

% Extract the bot info
for i = 2:length(report)
    % Split the bot info into its components: bot#:status:prevKinect#
    current = strsplit(report(i),':');
    botNum = current(1);
    status = current(2);
    prevNum = str2double(current(3));
    
    % Based on the status reported, the bot_lists need to be updated
    if strcmp(status, 'P') == 1
        % If the bot was found, remove the bot from the previous Kinect's
        % list and move it to the new one

        % Remove the botID from the previous Kinect's list
        prevKinectList = strcat(bot_lists(prevNum),','); % #,bot#,# -> #,bot#,#, || #,#,bot# -> #,#,bot#, || bot#,#,# -> bot#,#,#, || bot# -> bot#,
        s = strcat(botNum,','); % bot# -> bot#,
        newKinectList = strrep(prevKinectList,s,''); % #,bot#,#, -> #,#, || #,#,bot#, -> #,#, || bot#,#,#, -> #,#, || bot#, -> ''
        if length(newKinectList) > 1 % remove the possibility of putting an empty string through this process
            newKinectList = newKinectList(1:end-1); % #,#, -> #,#
        end
        bot_lists(prevNum) = newKinectList;
        
        % Add the botID to the new Kinect's list
        bot_lists(kinectNum) = strcat(bot_lists(kinectNum),',',botNum);
    elseif strcmp(status, 'NP') == 1
        % The bot was not found in the new field of view. Do nothing.
    else
        % This should not occur so report an error
        d = sprintf('Error: Invalid response concerning bot %s from Kinect %s/%s',botNum,kinectNum);
        disp(d);
    end
    
end

end