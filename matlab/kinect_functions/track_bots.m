function track_bots(botList, imgColor, imgDepth)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to track all of the robots
% specified in the botList

% convert the botList to an array of indeces
indeces = str2num(char(botList));

% For each index, track the corresponding bot in botArray
for i = indeces
    trackBots(imgColor, imgDepth, i);
end

end

