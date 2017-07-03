function [ ] = incomingCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the botIDList when the
% information is published

global incomingList

incomingList = msg.Data;

end