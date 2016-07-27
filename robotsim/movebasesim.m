function  hironx = movebasesim(hironx, bodyyaw)
% move the base of the hironx
%
% input 
% ----
% - hironx - the structure that includes base, rgtarm, lftarm, etc.
% - bodyyaw - body yaw angle, expressed in degree
%
% author: Weiwei
% date: 20160222

    hironx.base.bodyyaw = bodyyaw*pi/180;
    hironx = updatehironx(hironx);

end

