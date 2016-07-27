function rgtarm = initrgtarm()
% initialize the structure of hiro's right arm
%
% output
%----------
% - rgtarm - a data structure that has name, mother, child, b (link length), R
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
% date: 20160217

    rgtarm(1).name = 'link1';
    rgtarm(1).mother = 0;
    rgtarm(1).child = 2;
    rgtarm(1).b = [0, -0.145, 0.370296]';
    rgtarm(1).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(1).a = [0, 0, 1]';
    rgtarm(1).q = 0;
    rgtarm(1).inherentR = rodrigues([1,0,0], 0.262799);
    
    rgtarm(2).name = 'link2';
    rgtarm(2).mother = 1;
    rgtarm(2).child = 3;
    rgtarm(2).b = [0, -0.095, 0]';
    rgtarm(2).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(2).a = [0, 0, 1]';
    rgtarm(2).q = 0;
    
    rgtarm(3).name = 'link3';
    rgtarm(3).mother = 2;
    rgtarm(3).child = 4;
    rgtarm(3).b = [-0.03, 0, -0.25]';
    rgtarm(3).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(3).a = [0, 1, 0]';
    rgtarm(3).q = 0;
    
    rgtarm(4).name = 'link4';
    rgtarm(4).mother = 3;
    rgtarm(4).child = 5;
    rgtarm(4).b = [0, 0, 0]';
    rgtarm(4).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(4).a = [0, 1, 0]';
    rgtarm(4).q = 0;
    
    rgtarm(5).name = 'link5';
    rgtarm(5).mother = 4;
    rgtarm(5).child = 6;
    rgtarm(5).b = [0, 0, -0.235]';
    rgtarm(5).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(5).a = [0, 0, 1]';
    rgtarm(5).q = 0;
    
    rgtarm(6).name = 'link6';
    rgtarm(6).mother = 5;
    rgtarm(6).child = 7;
    rgtarm(6).b = [0, 0, -0.09]';
    rgtarm(6).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(6).a = [0, 1, 0]';
    rgtarm(6).q = 0;
    
    rgtarm(7).name = 'link7';
    rgtarm(7).mother = 6;
    rgtarm(7).child = 0;
    rgtarm(7).b = [-0.22, 0, 0]';
    rgtarm(7).R = [1 0 0; 0 1 0; 0 0 1];
    rgtarm(7).a = [1, 0, 0]';
    rgtarm(7).q = 0;
    
    rgtarm = updatergtarm(rgtarm);
    
end