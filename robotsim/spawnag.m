% not sure if this func is still needed 20160310

function interairi = spawnag(interair, objp, objR)
% intermediate placements in the air and the associated grasps
%
% input
% ----
% - interair - the standard interair state
% - objp - 3by1 array indicating the x,y,z pos of the placement
% - objR - 3by3 array indicating the orientation of the placement
%
% output
% ----
% - interairi - the (objp, objR) intermediate air state and its associated
% grasps

    interairi = interair;
    interairi.placementp = objp;
    interairi.placementR = objR;
    % % % % stablemesh
    % verts
    interairi.stablemesh.verts = interairi.placementR*interairi.stablemesh.verts';
    interairi.stablemesh.verts = bsxfun(@plus, interairi.stablemesh.verts, interairi.placementp)';
    % pcd
    interairi.stablemesh.pcd = interairi.placementR*interairi.stablemesh.pcd';
    interairi.stablemesh.pcd = bsxfun(@plus, interairi.stablemesh.pcd, interairi.placementp)';
    % simplified verts
    interairi.stablemesh.simplifiedverts = interairi.placementR*interairi.stablemesh.simplifiedverts';
    interairi.stablemesh.simplifiedverts = bsxfun(@plus, interairi.stablemesh.simplifiedverts, interairi.placementp)';
    % % % % grasp params 
    for k = 1:size(interairi.graspparams,1)
        interairi.graspparams(k).handx = interairi.placementR*interairi.graspparams(k).handx;
        interairi.graspparams(k).handy = interairi.placementR*interairi.graspparams(k).handy;
        interairi.graspparams(k).handz = interairi.placementR*interairi.graspparams(k).handz;
        interairi.graspparams(k).tcp = interairi.placementR*interairi.graspparams(k).tcp+interairi.placementp;
        interairi.graspparams(k).fgr1 = interairi.placementR*interairi.graspparams(k).fgr1+interairi.placementp;
        interairi.graspparams(k).fgr2 = interairi.placementR*interairi.graspparams(k).fgr2+interairi.placementp;
        interairi.graspparams(k).fgrcenter = interairi.placementR*interairi.graspparams(k).fgrcenter+interairi.placementp;
    end

end

