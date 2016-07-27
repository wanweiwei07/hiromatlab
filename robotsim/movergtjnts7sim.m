function hironx = movergtjnts7sim(hironx, bodyyaw, rgtjnts)
% move the bodyyaw plus the right 6 joints of hironx
%
% input
% ----
% - hironx - the date structure of the robot
% - bodyyaw - the bodyyaw of the left arm, in degree
% - rgtjnts - the 6 joint values of right arm, in degree, 6by1
%
% output
% ----
% - hironx - the updated robot structure
%
% author: Weiwei
% date: 20160222

    hironx.base.bodyyaw = bodyyaw*pi/180;

    hironx.rgtarm(2).q = rgtjnts(1)*pi/180;
    hironx.rgtarm(3).q = rgtjnts(2)*pi/180;
    hironx.rgtarm(4).q = rgtjnts(3)*pi/180;
    hironx.rgtarm(5).q = rgtjnts(4)*pi/180;
    hironx.rgtarm(6).q = rgtjnts(5)*pi/180;
    hironx.rgtarm(7).q = rgtjnts(6)*pi/180;
    
    hironx = updatehironx(hironx);

end

