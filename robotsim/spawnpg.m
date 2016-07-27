function placementi = spawnpg(placements, placementid, objp, objR)
% spawn a placement on the table and the associated grasps
%
% input
% ----
% - placements - the placements computed by calcgrasps
% - placementid - the id of the placement in the placements to spawn
% - objp - 3by1 array indicating the x,y,z pos of the placement
% - objR - 3by3 array indicating the orientation of the placement
%
% output
% ----
% - placementi - the (objp, objR) placement on the table and the associated grasps
%
% author: Weiwei
% date: 20160222

    placementi = moveinterstate(placements{placementid}, objp, objR);
%     placementi = placements{placementid};
%     placementi.placementp = objp;
%     placementi.placementR = objR;
%     % % % % stablemesh
%     % verts
%     placementi.stablemesh.verts = placementi.placementR*placementi.stablemesh.verts';
%     placementi.stablemesh.verts = bsxfun(@plus, placementi.stablemesh.verts, placementi.placementp)';
%     % pcd
%     placementi.stablemesh.pcd = placementi.placementR*placementi.stablemesh.pcd';
%     placementi.stablemesh.pcd = bsxfun(@plus, placementi.stablemesh.pcd, placementi.placementp)';
%     % simplified verts
%     placementi.stablemesh.simplifiedverts = placementi.placementR*placementi.stablemesh.simplifiedverts';
%     placementi.stablemesh.simplifiedverts = bsxfun(@plus, placementi.stablemesh.simplifiedverts, placementi.placementp)';
%     % % % % grasp params 
%     for k = 1:size(placementi.graspparams,1)
%         placementi.graspparams(k).handx = placementi.placementR*placementi.graspparams(k).handx;
%         placementi.graspparams(k).handy = placementi.placementR*placementi.graspparams(k).handy;
%         placementi.graspparams(k).handz = placementi.placementR*placementi.graspparams(k).handz;
%         placementi.graspparams(k).tcp = placementi.placementR*placementi.graspparams(k).tcp+placementi.placementp;
%         placementi.graspparams(k).fgr1 = placementi.placementR*placementi.graspparams(k).fgr1+placementi.placementp;
%         placementi.graspparams(k).fgr2 = placementi.placementR*placementi.graspparams(k).fgr2+placementi.placementp;
%         placementi.graspparams(k).fgrcenter = placementi.placementR*placementi.graspparams(k).fgrcenter+placementi.placementp;
%     end
end

