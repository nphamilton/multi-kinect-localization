function [ ] = botListCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the botList when the
% information is published

global botList

botList = msg.Data;

end