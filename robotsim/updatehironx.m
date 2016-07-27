function hironx = updatehironx(hironx)
% update the positions of different joints
% namely forward kinematics
%
% input
% -----------
% - hironx - the structure that includes rgtarm, lftarm, rgthnd, lfthnd
% - bodyyaw - body yaw angle, expressed in radian
%
% author: Weiwei
% date: 20160217
    
    hironx.rgtarm(1).R = rodrigues([0,0,1], hironx.base.bodyyaw)*hironx.rgtarm(1).inherentR;
    hironx.lftarm(1).R = rodrigues([0,0,1], hironx.base.bodyyaw)*hironx.lftarm(1).inherentR;
    hironx.rgtarm = updatergtarm(hironx.rgtarm);
    hironx.lftarm = updatelftarm(hironx.lftarm);

end