function hironx = movelftjnts7sim(hironx, bodyyaw, lftjnts)
% move the bodyyaw plus the left 6 joints of hironx
%
% input
% ----
% - hironx - the date structure of the robot
% - bodyyaw - the bodyyaw of the left arm, in degree
% - lftjnts - the 6 joint values of left arm, in degree, 6by1
%
% output
% ----
% - hironx - the updated robot structure
%
% author: Weiwei
% date: 20160222

    hironx.base.bodyyaw = bodyyaw*pi/180;

    hironx.lftarm(2).q = lftjnts(1)*pi/180;
    hironx.lftarm(3).q = lftjnts(2)*pi/180;
    hironx.lftarm(4).q = lftjnts(3)*pi/180;
    hironx.lftarm(5).q = lftjnts(4)*pi/180;
    hironx.lftarm(6).q = lftjnts(5)*pi/180;
    hironx.lftarm(7).q = lftjnts(6)*pi/180;
    
    hironx = updatehironx(hironx);

end

