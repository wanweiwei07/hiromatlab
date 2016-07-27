dbstop if error;

load data/interairl.mat
load data/placementsl.mat
load data/interairb.mat

% the table coordinates are global
% unncessry to do transformation
% tableverts = [[0.5, 0.5, -precision]; [-0.5, 0.5, -precision]; ...
%     [-0.5, -0.5, -precision]; [0.5, -0.5, -precision]];
% tablefaces = [[1, 2, 3]; [3, 4, 1]];
% boxpcd = cvtpcd(tableverts, tablefaces, 10000);

poslassem1 = [0;0;0];
rotlassem1 = eye(3,3);
%interairl1 = moveinterstate(interairl, poslassem1, rotlassem1);
interairl1 = interairl;

poslassem2 = [0.04;0;0];
rotlassem2 = eye(3,3);
interairl2 = moveinterstate(interairl, poslassem2, rotlassem2);

poslassem3 = [0.08;0;0];
rotlassem3 = eye(3,3);
interairl3 = moveinterstate(interairl, poslassem3, rotlassem3);

boxpos = [-0.1;-0.07;-0.012];
boxrot = eye(3,3);
obstacle = moveinterstate(interairb, boxpos, boxrot);
boxpcd = obstacle.stablemesh.pcd;

% remove the cdg of l2
interairl2 = removecdgmeta(interairl2, interairl1.stablemesh.pcd);
% remove the cdg of l3
interairl3 = removecdgmeta(interairl3, interairl2.stablemesh.pcd);

%%
% assemsgl is used to hold the two objects in the assembled structure
% assemsgl.obj1state = the first object and its associated grasps
% assemsgl.obj2state = the second object and its associated grasps
assemsgl_larray_box = [];
figure;
for placementid = 1:1
%     placementid = 4;
    transpl1 = placementsl{placementid}.transmat;
    rotpl1 = placementsl{placementid}.rotmat;   
    interairl1movedtmp = placementsl{placementid};
    interairl2movedtmp = moveinterstate(interairl2, rotpl1*transpl1+rotpl1*poslassem2, rotpl1*rotlassem2);
    interairl3movedtmp = moveinterstate(interairl3, rotpl1*transpl1+rotpl1*poslassem3, rotpl1*rotlassem3);
    
    interairl1moved = removecdgmeta(interairl1movedtmp, boxpcd);
    plotinterstates(interairl1moved, 'r');
    interairl2moved = removecdgmeta(interairl2movedtmp, boxpcd);
    plotinterstates(interairl2moved, 'r');
    interairl3moved = removecdgmeta(interairl3movedtmp, boxpcd);
    plotinterstates(interairl3moved, 'r');
    plot3(boxpcd(:,1), boxpcd(:,2), boxpcd(:,3), '.c');
    
    if ~isempty(interairl2moved.graspparams) ...
            && ~isempty(interairl3moved.graspparams) ...
            && ~isempty(interairl1moved.graspparams)
%            && ~isempty(placementsl{placementid}.graspparams)
        pair.obstaclestate = obstacle;
        pair.obj1state = interairl1moved;
%        pair.obj1state = placementsl{placementid};
        pair.obj2state = interairl2moved;
        pair.obj3state = interairl3moved;
        assemsgl_larray_box = [assemsgl_larray_box;pair];
    else
        disp('no grasps');
    end
end
save data/assemsgl_larray_box assemsgl_larray_box;