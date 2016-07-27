function movedinterstate = moveinterstaterel(interstate, pos, rot)
% move the interstate to a new pos and rot
% unlike the create interstate function, this function doesn't change
% the coordinate system; it moves the objects and the associated grasps
%
% input
% ----
% - inwterstate - a data structure that indicates one interstate
% - pos - the new position of the interstate
% - rot - the new rotation of the interstate
%
% output
% ----
% - movedinterstate - the moved interstate
%
% author: Weiwei
% date: 20160224

    movedinterstate = interstate;
    % reset to original pos and rot
    % % % % stablemesh
    % verts
    movedinterstate.stablemesh.verts = ...
        (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.stablemesh.verts', movedinterstate.placementp))';
    % pcd
    movedinterstate.stablemesh.pcd = ...
        (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.stablemesh.pcd', movedinterstate.placementp))';
    % simplified verts
    movedinterstate.stablemesh.simplifiedverts = ...
        (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.stablemesh.simplifiedverts', movedinterstate.placementp))';
    % % % % grasp params 
    for k = 1:size(movedinterstate.graspparams,1)
        movedinterstate.graspparams(k).handx = movedinterstate.placementR'*movedinterstate.graspparams(k).handx;
        movedinterstate.graspparams(k).handy = movedinterstate.placementR'*movedinterstate.graspparams(k).handy;
        movedinterstate.graspparams(k).handz = movedinterstate.placementR'*movedinterstate.graspparams(k).handz;
        movedinterstate.graspparams(k).tcp = movedinterstate.placementR'*(movedinterstate.graspparams(k).tcp-movedinterstate.placementp);
        movedinterstate.graspparams(k).fgr1 = movedinterstate.placementR'*(movedinterstate.graspparams(k).fgr1-movedinterstate.placementp);
        movedinterstate.graspparams(k).fgr2 = movedinterstate.placementR'*(movedinterstate.graspparams(k).fgr2-movedinterstate.placementp);
        movedinterstate.graspparams(k).fgrcenter = movedinterstate.placementR'*(movedinterstate.graspparams(k).fgrcenter-movedinterstate.placementp);
        movedinterstate.graspparams(k).vertpalm = (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.graspparams(k).vertpalm', movedinterstate.placementp))';
        movedinterstate.graspparams(k).vertfgr1 = (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.graspparams(k).vertfgr1', movedinterstate.placementp))';
        movedinterstate.graspparams(k).vertfgr2 = (movedinterstate.placementR'*bsxfun(@minus, movedinterstate.graspparams(k).vertfgr2', movedinterstate.placementp))';
    end

    % compute to new pos and rot
    movedinterstate.placementp = pos+movedinterstate.placementp;
    movedinterstate.placementR = rot*movedinterstate.placementR;
    % % % % stablemesh
    % verts
    movedinterstate.stablemesh.verts = movedinterstate.placementR*movedinterstate.stablemesh.verts';
    movedinterstate.stablemesh.verts = bsxfun(@plus, movedinterstate.stablemesh.verts, movedinterstate.placementp)';
    % pcd
    movedinterstate.stablemesh.pcd = movedinterstate.placementR*movedinterstate.stablemesh.pcd';
    movedinterstate.stablemesh.pcd = bsxfun(@plus, movedinterstate.stablemesh.pcd, movedinterstate.placementp)';
    % simplified verts
    movedinterstate.stablemesh.simplifiedverts = movedinterstate.placementR*movedinterstate.stablemesh.simplifiedverts';
    movedinterstate.stablemesh.simplifiedverts = bsxfun(@plus, movedinterstate.stablemesh.simplifiedverts, movedinterstate.placementp)';
    % % % % grasp params 
    for k = 1:size(movedinterstate.graspparams,1)
        movedinterstate.graspparams(k).handx = movedinterstate.placementR*movedinterstate.graspparams(k).handx;
        movedinterstate.graspparams(k).handy = movedinterstate.placementR*movedinterstate.graspparams(k).handy;
        movedinterstate.graspparams(k).handz = movedinterstate.placementR*movedinterstate.graspparams(k).handz;
        movedinterstate.graspparams(k).tcp = movedinterstate.placementR*movedinterstate.graspparams(k).tcp+movedinterstate.placementp;
        movedinterstate.graspparams(k).fgr1 = movedinterstate.placementR*movedinterstate.graspparams(k).fgr1+movedinterstate.placementp;
        movedinterstate.graspparams(k).fgr2 = movedinterstate.placementR*movedinterstate.graspparams(k).fgr2+movedinterstate.placementp;
        movedinterstate.graspparams(k).fgrcenter = movedinterstate.placementR*movedinterstate.graspparams(k).fgrcenter+movedinterstate.placementp;
        movedinterstate.graspparams(k).vertpalm = bsxfun(@plus, movedinterstate.placementR*movedinterstate.graspparams(k).vertpalm', movedinterstate.placementp)';
        movedinterstate.graspparams(k).vertfgr1 = bsxfun(@plus, movedinterstate.placementR*movedinterstate.graspparams(k).vertfgr1', movedinterstate.placementp)';
        movedinterstate.graspparams(k).vertfgr2 = bsxfun(@plus, movedinterstate.placementR*movedinterstate.graspparams(k).vertfgr2', movedinterstate.placementp)';
    end

end

