function placementi = spawnpgrgtik(hironx, placements, placementid, objp, objR)
% spawn a placement on the table and the associated grasps
% rgt - right arm
%
% input
% ----
% - hironx - the data structure of the robot
% - placements - the placements computed by calcgrasps
% - placementid - the id of the placement in the placements to spawn
% - objp - 3by1 array indicating the x,y,z pos of the placement
% - objR - 3by3 array indicating the orientation of the placement
%
% output
% ----
% - placementi - the initial placement on the table and the associated grasps
%
% author: Weiwei
% date: 20160222

    placementi = spawnpg(placements, placementid, objp, objR);
    % % % % filter ik
    hironxcp = hironx;
    graspidtodelete = [];
    for k = 1:size(placementi.graspparams,1)
        [isdone, baseyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, placementi.graspparams(k).fgrcenter,...
            [placementi.graspparams(k).handx,placementi.graspparams(k).handy,...
            placementi.graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            placementi.graspparams(k).baseyaw = baseyaw;
            placementi.graspparams(k).rgtjnts = rgtjnts;
        end
    end
    placementi.graspparams(graspidtodelete) = [];
    placementi.graspparamids(graspidtodelete) = [];
end

