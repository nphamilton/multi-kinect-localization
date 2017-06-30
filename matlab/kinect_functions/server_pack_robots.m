function [msg] = server_pack_robots(indeces)

global botArray

msg = {};
for i = indeces
    if isGroundRobot(botArray(i).type) == 1
        msg = [msg; [char(10) '#|' botArray(i).name '|' int2str(botArray(i).X) '|' int2str(botArray(i).Y) '|' int2str(botArray(i).Z) '|' int2str(botArray(i).yaw) '|&']];
    elseif isAerialDrone(botArray(i).type) == 1
        msg = [msg; [char(10) '$|' botArray(i).name '|' int2str(botArray(i).X) '|' int2str(botArray(i).Y) '|' int2str(botArray(i).Z) '|' int2str(botArray(i).yaw) '|' '0' '|' '0' '|' '&']];
    end
end