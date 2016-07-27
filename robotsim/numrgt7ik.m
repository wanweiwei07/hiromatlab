function [isdone, bodyyaw, rgtjnts, trajrgtjnts] = numrgt7ik(hironx, pos, dcm)
% move the jntid jnt of base and rgtarm with tcp = pos, quaternion
%
% input
% ----------
% - rgtarm - the data structure of robot links
% - pos - position of jnt, 3-by-1, [x, y, z]
% - dcm - the [handx, handy, handz] rotation mat of tcp
%
% output
% ----------
% - isdone - if the ik is available
% - bodyyaw - the body yaw in degree
% - rgtjnts - the right arm joint values in degree
% - trajrgtjnts - the sequence of rgtarm jnts on the trajectory of motion
%
% author: Weiwei
% date: 20160222

    hironxcp = hironx;
    bodyyaw = eurgtbik(pos);
    hironxcp = movebasesim(hironxcp, bodyyaw);
    [isdone, rgtjnts, trajrgtjnts] = ...
    	numrgtik(hironxcp.rgtarm, pos, dcm);
    
end