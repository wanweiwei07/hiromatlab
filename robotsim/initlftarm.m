function lftarm = initlftarm()
% initialize the structure of hiro's left arm
%
% output
%----------
% - lftarm - a data structure that has name, mother, child, b (link length), R
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
% date: 20160218

    lftarm(1).name = 'link1';
    lftarm(1).mother = 0;
    lftarm(1).child = 2;
    lftarm(1).b = [0, 0.145, 0.370296]';
    lftarm(1).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(1).a = [0, 0, 1]';
    lftarm(1).q = 0;
    lftarm(1).inherentR = rodrigues([1,0,0], -0.262799);
    
    lftarm(2).name = 'link2';
    lftarm(2).mother = 1;
    lftarm(2).child = 3;
    lftarm(2).b = [0, 0.095, 0]';
    lftarm(2).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(2).a = [0, 0, 1]';
    lftarm(2).q = 0;
    
    lftarm(3).name = 'link3';
    lftarm(3).mother = 2;
    lftarm(3).child = 4;
    lftarm(3).b = [-0.03, 0, -0.25]';
    lftarm(3).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(3).a = [0, 1, 0]';
    lftarm(3).q = 0;
    
    lftarm(4).name = 'link4';
    lftarm(4).mother = 3;
    lftarm(4).child = 5;
    lftarm(4).b = [0, 0, 0]';
    lftarm(4).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(4).a = [0, 1, 0]';
    lftarm(4).q = 0;
    
    lftarm(5).name = 'link5';
    lftarm(5).mother = 4;
    lftarm(5).child = 6;
    lftarm(5).b = [0, 0, -0.235]';
    lftarm(5).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(5).a = [0, 0, 1]';
    lftarm(5).q = 0;
    
    lftarm(6).name = 'link6';
    lftarm(6).mother = 5;
    lftarm(6).child = 7;
    lftarm(6).b = [0, 0, -0.09]';
    lftarm(6).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(6).a = [0, 1, 0]';
    lftarm(6).q = 0;
    
    lftarm(7).name = 'link7';
    lftarm(7).mother = 6;
    lftarm(7).child = 0;
    lftarm(7).b = [-0.22, 0, 0]';
    lftarm(7).R = [1 0 0; 0 1 0; 0 0 1];
    lftarm(7).a = [1, 0, 0]';
    lftarm(7).q = 0;
    
    lftarm = updatergtarm(lftarm);
end