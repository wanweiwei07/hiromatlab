function updatedinterstate = removecdgmeta(interstate, objpcd)
% remove the grasps that collides with the objects in the objlis
% this is the nonbatch version
%
% input
% ----
% - interstate - a data structure that indicates one interstate
% - objlist - the objects for collision detection, column-first cell
%
% output
% ----
% - updatedinterstateair - the interstate with collided grasps removed
%
% author: Weiwei
% date: 20160224

    totalgraspids = interstate.graspparamids;
    totalgrasps = interstate.graspparams;
    ntotalgrasps = size(interstate.graspparams, 1);
    
    updatedinterstate = interstate;
    updatedinterstate.graspparamids = [];
    updatedinterstate.graspparams = [];
    
    % the commented part allow obstacles to be between the fingers
%     for i = 1:ntotalgrasps
%         thisgrasp = totalgrasps(i);
%         thisgraspid = totalgraspids(i);
%         vertpalm = thisgrasp.vertpalm;
%         f3palm = thisgrasp.f3palm;
%         vertfgr1 = thisgrasp.vertfgr1;
%         f3fgr1 = thisgrasp.f3fgr1;
%         vertfgr2 = thisgrasp.vertfgr2;
%         f3fgr2 = thisgrasp.f3fgr2;
%         % see if there is intersection
%         pntsforcd = objpcd;
%         inpalm = inpolyhedron(f3palm, vertpalm, pntsforcd);
%         infgr1 = inpolyhedron(f3fgr1, vertfgr1, pntsforcd);
%         infgr2 = inpolyhedron(f3fgr2, vertfgr2, pntsforcd);
%         isinpalm = sum(inpalm);
%         isinfgr1 = sum(infgr1);
%         isinfgr2 = sum(infgr2);
%         if isinpalm || isinfgr1 || isinfgr2
%             continue;
%         end
%         updatedinterstate.graspparamids = [updatedinterstate.graspparamids; thisgraspid];
%         updatedinterstate.graspparams = [updatedinterstate.graspparams; thisgrasp];
%     end
    % the following part doesn't allow obstacles to be between the fingers
    for i = 1:ntotalgrasps
%         cla;
        thisgrasp = totalgrasps(i);
        thisgraspid = totalgraspids(i);
        vertpalm = thisgrasp.vertpalm;
        f3palm = thisgrasp.f3palm;
        vertfgr1 = thisgrasp.vertfgr1;
        f3fgr1 = thisgrasp.f3fgr1;
        vertfgr2 = thisgrasp.vertfgr2;
        f3fgr2 = thisgrasp.f3fgr2;
        vertfgrs = [vertfgr1;vertfgr2];
        f3fgrs = convhulln(vertfgrs);
        tmp = f3fgrs(:,1);
        f3fgrs(:,1) = f3fgrs(:,3);
        f3fgrs(:,3) = tmp;
        % see if there is intersection
        pntsforcd = objpcd;
        inpalm = inpolyhedron(f3palm, vertpalm, pntsforcd);
        infgrs = inpolyhedron(f3fgrs, vertfgrs, pntsforcd);
%         plotinterstatesobjmodels(interstate);
%         drawMesh(vertfgr1, f3fgr1);
%         drawMesh(vertfgr2, f3fgr2);
%         drawMesh(vertfgrs, f3fgrs);
%         drawMesh(vertpalm, f3palm);
        isinpalm = sum(inpalm);
        isinfgrs = sum(infgrs);
        if isinpalm || isinfgrs
            continue;
        end
        updatedinterstate.graspparamids = [updatedinterstate.graspparamids; thisgraspid];
        updatedinterstate.graspparams = [updatedinterstate.graspparams; thisgrasp];
    end
end

