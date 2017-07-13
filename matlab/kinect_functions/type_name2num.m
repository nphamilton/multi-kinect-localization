function number = type_name2num(name)
% Author: Nate Hamilton
%  Email: nathaniel.p.hamilton@vanderbilt.edu
%  
% Purpose: This function converts a text name of the robot type to its associated number

% Assign drone definitions
MINIDRONE = 100;
CREATE2 = 101;
ARDRONE = 102;
THREEDR = 103;
GHOST2 = 104;
MAVICPRO = 105;
PHANTOM3 = 106;
PHANTOM4 = 107;

name = lower(name);

if strcmp(name,'minidrone')
    number = MINIDRONE;
elseif strcmp(name,'create2')
	number = CREATE2;
elseif strcmp(name,'ardrone')
	number = ARDRONE;
elseif strcmp(name,'3dr')
	number = THREEDR;
elseif strcmp(name,'ghost2')
	number = GHOST2;
elseif strcmp(name,'mavicpro')
	number = MAVICPRO;
elseif strcmp(name,'phantom3')
	number = PHANTOM3;
elseif strcmp(name,'phantom4')
	number = PHANTOM4;
else
	error('invalid type in the input')
    number = 0;
end

end