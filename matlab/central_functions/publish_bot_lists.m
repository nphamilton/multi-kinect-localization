function [ output_args ] = publish_bot_lists(botListPubs)
% Author: Nathaniel Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%
% Purpose: This function publishes the bot lists to all of the Kinects connected to the system.
%
global bot_lists

% Make sure the lists are the same size. If they aren't, an error should be posted
if length(bot_lists) == length(botListPubs)
	% If the sizes do match up, publish the associated bot list with each publisher
	for i = 1:length(botListPubs)
		% Create the message as a String type
		msg = rosmessage('std_msgs/String');
		msg.Data = bot_lists(i);
		send(botIDListPubs(i),msg);
	end
else
	error('bot_lists and botListPubs are not the same size.')
end

end

