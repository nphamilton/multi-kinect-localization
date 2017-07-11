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

if name == 'minidrone'
	return MINIDRONE;
elseif name == 'create2'
	return CREATE2;
elseif name == 'ardrone'
	return ARDRONE;
elseif name == '3dr'
	return THREEDR;
elseif name == 'ghost2'
	return GHOST2;
elseif name == 'mavicpro'
	return MAVICPRO;
elseif name == 'phantom3'
	return PHANTOM3;
elseif name == 'phantom4'
	return PHANTOM4;
else
	error('invalid type in the input')
	return 0;
end

end