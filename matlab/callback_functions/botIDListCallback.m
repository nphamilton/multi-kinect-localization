function [ ] = botIDListCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the botIDList when the
% information is published

global botIDList

botIDList = msg.Data;

end