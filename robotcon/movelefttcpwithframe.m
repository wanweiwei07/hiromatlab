function isdone = movelefttcpwithframe(hirosock, xyz, axisx, axisy, axisz, spd)
% move the position of left tcp to the specified x,y,z
% move the orientation to the local frame specified by axisx, axisy, axisz
% the moving speed is spd
%
% input
%----------
% - hirosock - the socket object where users send command to
% - xyz - a list including the x, y, z position of tcp
% - axisx, axisy, axisz - three triples (column main) indicating the three
%                         axis of the hand's local frame
% - spd - moving speed
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160204

    dcmmat = [axisx'; axisy'; axisz'];
    [yawangle, pitchangle, rollangle] = dcm2angle(dcmmat);
    movetcp_paramlist = [xyz(1), xyz(2), xyz(3), yawangle, pitchangle, rollangle, spd];
    isdone = movelefttcp(hirosock, movetcp_paramlist);

end

