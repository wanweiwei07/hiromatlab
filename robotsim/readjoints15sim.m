function bodyrls = readjoints15sim(hironx)
% read the joint values of the hironx robot
% 3->body, only the first one, bodyyaw, is used.
% 6->right, 6->left
% 1-> speed, it is not used
% we use the same data structure as in the robotcon.movejoints15
% and robotcon.readjoints to make 
% things coherent
%
% input
% ----
% - hironx - the date structure of the robot
% 
% output
% ----
% - bodyrls - an 1by15 array including the 15 joint values
%
% author: Weiwei
% date: 20160222

    bodyrls(1) = hironx.base.yaw*180/pi;
    bodyrls(2) = hironx.base.headyaw*180/pi;
    bodyrls(3) = hironx.base.headpitch*180/pi;
    bodyrls(4:9) = readjoints6sim(hironx.rgtarm);
    bodyrls(10:15) = readjoints6sim(hironx.lftarm);

end

