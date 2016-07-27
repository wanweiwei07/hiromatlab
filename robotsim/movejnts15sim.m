function hironx = movejnts15sim(hironx, bodyrls)
% move the 15 joints of hironx
% 3->body, only the first one, bodyyaw, is used.
% 6->right, 6->left
% 1-> speed, it is not used
% we use the same data structure as in the robotcon.movejoints15 to make 
% things coherent
% 
% input
% ---------
% - hironx - the data structure of the robot
% - bodyrls - a list including the body joints, right joints, left joints, 
% and left arm, hand configuration is not included
%
% output
% ---------
% - hironx - the data structure of the robot with updated kinematics
%
% author: Weiwei
% date: 20160215

    bodyyaw = bodyrls(1)*pi/180;
    rgtjnt1 = bodyrls(4)*pi/180;
    rgtjnt2 = bodyrls(5)*pi/180;
    rgtjnt3 = bodyrls(6)*pi/180;
    rgtjnt4 = bodyrls(7)*pi/180;
    rgtjnt5 = bodyrls(8)*pi/180;
    rgtjnt6 = bodyrls(9)*pi/180;
    lftjnt1 = bodyrls(10)*pi/180;
    lftjnt2 = bodyrls(11)*pi/180;
    lftjnt3 = bodyrls(12)*pi/180;
    lftjnt4 = bodyrls(13)*pi/180;
    lftjnt5 = bodyrls(14)*pi/180;
    lftjnt6 = bodyrls(15)*pi/180;
    
    hironx.base.bodyyaw = bodyyaw;
    hironx.rgtarm(2).q = rgtjnt1;
    hironx.rgtarm(3).q = rgtjnt2;
    hironx.rgtarm(4).q = rgtjnt3;
    hironx.rgtarm(5).q = rgtjnt4;
    hironx.rgtarm(6).q = rgtjnt5;
    hironx.rgtarm(7).q = rgtjnt6;
    
    hironx.lftarm(2).q = lftjnt1;
    hironx.lftarm(3).q = lftjnt2;
    hironx.lftarm(4).q = lftjnt3;
    hironx.lftarm(5).q = lftjnt4;
    hironx.lftarm(6).q = lftjnt5;
    hironx.lftarm(7).q = lftjnt6;

    hironx = updatehironx(hironx);
    
end