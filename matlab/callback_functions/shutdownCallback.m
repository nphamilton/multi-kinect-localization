function [ ] = shutdownCallback( src, msg )
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: The purpose of this function is to update the decision for the
% system to shutdown when it is called for

global shutdown_command

shutdown_command = msg.Data;

end

