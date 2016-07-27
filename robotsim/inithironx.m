function hironx = inithironx()
% initialize the structure of hiro's right arm
%
% output
%----------
% - hironx - the robot structure which has rgtarm, rgthnd, lftarm, and lfthnd,
%           each xarm is a data structure that has name, mother, child, b (link length), R
%           (orientation), a (rotation axis) of a joint, q (rot angle of
%           joint, radian)
%           note: default x, y, z is the same as robot coordinates.
%           Each element of ulink is a link
%           the element.b indicates the vector of this link
%           the element.R indicates the rotation matrix of this link
%           the element.a indicates the rotation axis of the link's p
%           (namely the joint)
%           ulink(2).p --> jnt1, ulink(7).p --> jnt6, etc
%           ulink(1).p is the jnt connection with world
%
% author: Weiwei
% date: 201602178

    rgtarm = initrgtarm();
    lftarm = initlftarm();
    hironx.rgtarm = rgtarm;
    hironx.lftarm = lftarm;
    
    hironx.base.bodyyaw = 0;
    hironx.base.headyaw = 0;
    hironx.base.headpitch = 0;
    
    hironx = updatehironx(hironx);

end