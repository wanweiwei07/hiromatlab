function armjnts = readjoints6sim(rbtarm)
% read the joint values of a robot arm
%
% input
% ----
% - rbtarm - the date structure of the robot's right or left arm
% 
% output
% ----
% - armjnts - an 1by6 array including the 6 joint a the rbtarm
%
% author: Weiwei
% date: 20160222

    armjnt1 = rbtarm(2).q;
    armjnt2 = rbtarm(3).q;
    armjnt3 = rbtarm(4).q;
    armjnt4 = rbtarm(5).q;
    armjnt5 = rbtarm(6).q;
    armjnt6 = rbtarm(7).q;
    
    armjnts(1) = armjnt1*180/pi;
    armjnts(2) = armjnt2*180/pi;
    armjnts(3) = armjnt3*180/pi;
    armjnts(4) = armjnt4*180/pi;
    armjnts(5) = armjnt5*180/pi;
    armjnts(6) = armjnt6*180/pi;
    
end

