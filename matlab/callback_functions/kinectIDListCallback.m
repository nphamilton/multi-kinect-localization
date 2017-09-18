function [ ] = kinectIDListCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the kinectIDList when the
% information is published

global kinectIDList

kinectIDList = msg.Data;

end