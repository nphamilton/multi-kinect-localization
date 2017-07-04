function [botID_list] = parse_input(fileName)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to parse through the input file
% name for all of the robot information.
% 
% The file is setup with the following format:
%
% numBots numKinects
% Kinect 1
% botName type color
% botName type color
% Kinect 2
% botName type color
% .
% .

global bots
global bot_lists

% Open the file
f = fopen(fileName,'r');
firstline = fgets(f);
C = textscan(firstline,'%d %d');
numBots = C{1};
numKinects = C{2};

% Initialize the array of bots
bots = Robot.empty(numBots,0);
for i = 1:numBots
    bots(i) = Robot;
end

% Initialize the bot lists
bot_lists = cells(numKinects,1);
for i = 1:numKinects
    bot_lists(i) = '';
end
botIDs = '';

% Parse through the file reading one line at a time
botNum = 1;
kinectNum = 1;
nextline = fgets(f);
while ischar(nextline)
    if numel(nextline) > 6
        if nextline(1:6) == 'Kinect' || nextline(1:6) == 'kinect'
            % If the line is for declaring the next Kinect number, update
            % the Kinect number
            C = textscan(nextline,'%s %d');
            
            % But first, clean up the previous Kinect's bot list by
            % removing the last comma
            if bot_lists(kinectNum) ~= '';
                temp = bot_lists(kinectNum);
                temp = temp(1:end-1);
                bot_lists(kinectNum) = temp;
            end
            
            % Update the Kinect number
            kinectNum = C{2};
            
        else
            % Otherwise the line is for declaring a robot
            C = textscan(nextline,'%s %s %s');
            %assign the info to the appropriate spot in bots
            bots(botNum).name = C{1};
            bots(botNum).type = type_name2num(C{2});
            bots(botNum).color = C{3};
            
            % Update the appropriat bot_list
            bot_lists(kinectNum) = strcat(bot_lists(kinectNum), num2str(botNum), ',');
            
            % Increment to the next bot
            butNum = botNum + 1; 
        end
    end
    nextline = fgets(f);
end

fclose(fileName);
end

