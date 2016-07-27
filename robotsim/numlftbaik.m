function [isdone, bodyyaw, lftjnts, trajlftjnts] = numlftbaik(hironx, pos, dcm)
% move the jntid jnt of base and lftarm with tcp = pos, quaternion
%
% input
% ----------
% - hironx - the data structure of robot
% - pos - position of jnt, 3-by-1, [x, y, z]
% - dcm - the [handx, handy, handz] rotation mat of tcp
%
% output
% ----------
% - isdone - if the ik is available
% - bodyyaw - the body yaw in degree
% - lftjnts - the left arm joint values in degree
% - trajlftjnts - the sequence of lftarm jnts on the trajectory of motion
%
% author: Weiwei
% date: 20160222

    hironxcp = hironx;
    bodyyaw = eulftbik(pos);
    hironxcp = movebasesim(hironxcp, bodyyaw);
    [isdone, lftjnts, trajlftjnts] = ...
    	numlftik(hironxcp.lftarm, pos, dcm);
    
end