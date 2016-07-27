function [hironxcp, keyposeout] = movekprgt7sim(hironx, keyposein, bodyyaw, rgtjnts)
% move the keypose (both the rob and the obj) using bodyyaw, and rgtjnts
%
% input
% ----
% - hironx - the structure that includes rgtarm, lftarm, rgthnd, lfthnd
% - keyposein - the starting keypose, keyposeout are computed from this one
% - bodyyaw - the yaw angle of the robot body
% - rgtjnts - the 6 rgtjnt values
%
% output
% ----
% - keyposeout - the moved robot and object conf
%
% author: Weiwei
% date: 20160311

%     keyposeout = keyposein;

    hironxcp = movergtjnts7sim(hironx, bodyyaw, rgtjnts);
    newp = hironxcp.rgtarm(7).ep;
    newR = hironxcp.rgtarm(7).R;
    oldp = keyposein.graspparams(1).fgrcenter;
    oldR = [keyposein.graspparams(1).handx, ...
        keyposein.graspparams(1).handy, ...
        keyposein.graspparams(1).handz];
    relp = newp-oldp;
    relR = newR*oldR';

%     keyposeout.graspparam.handx = newR(1,:);
%     keyposeout.graspparam.handy = newR(2,:);
%     keyposeout.graspparam.handz = newR(3,:);
%     keyposeout.graspparam.tcp = relR*(keyposein.graspparam.tcp-...
%         keyposein.graspparam.fgrcenter)+keyposein.graspparam.fgrcenter+relp;
%     keyposeout.graspparam.fgr1 = relR*(keyposein.graspparam.fgr1-...
%         keyposein.graspparam.fgrcenter)+keyposein.graspparam.fgrcenter+relp;
%     keyposeout.graspparam.fgr2 = relR*(keyposein.graspparam.fgr2-...
%         keyposein.graspparam.fgrcenter)+keyposein.graspparam.fgrcenter+relp;
%     keyposeout.graspparam.fgrcenter = newp;
%     
%     keyposeout.graspparam.vertpalm = bsxfun(@plus, relR*(keyposein.graspparam.vertpalm'-...
%         keyposein.graspparam.fgrcenter), keyposein.graspparam.fgrcenter+relp)';
%     keyposeout.graspparam.vertfgr1 = bsxfun(@plus, relR*(keyposein.graspparam.vertfgr1'-...
%         keyposein.graspparam.fgrcenter), keyposein.graspparam.vertfgr1+relp)';
%     keyposeout.graspparam.vertfgr2 = bsxfun(@plus, relR*(keyposein.graspparam.vertfgr2'-...
%         keyposein.graspparam.fgrcenter), keyposein.graspparam.vertfgr2+relp)';
    
    % obj mesh
    keyposeout = moveinterstaterel(keyposein, relp, relR);
end

