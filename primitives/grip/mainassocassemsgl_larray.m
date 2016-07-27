dbstop if error;

load data/interairl.mat
load data/placementsl.mat

% the table coordinates are global
% unncessry to do transformation
precision = 0.001;
tableverts = [[0.5, 0.5, -precision]; [-0.5, 0.5, -precision]; ...
    [-0.5, -0.5, -precision]; [0.5, -0.5, -precision]];
tablefaces = [[1, 2, 3]; [3, 4, 1]];
tablepcd = cvtpcd(tableverts, tablefaces, 10000);

poslassem1 = [0;0;0];
rotlassem1 = eye(3,3);
interairl1 = interairl;

poslassem2 = [0.04;0;0];
rotlassem2 = eye(3,3);
interairl2 = moveinterstate(interairl, poslassem2, rotlassem2);

poslassem3 = [0.08;0;0];
rotlassem3 = eye(3,3);
interairl3 = moveinterstate(interairl, poslassem3, rotlassem3);

poslassem4 = [0.12;0;0];
rotlassem4 = eye(3,3);
interairl4 = moveinterstate(interairl, poslassem4, rotlassem4);

poslassem5 = [0.16;0;0];
rotlassem5 = eye(3,3);
interairl5 = moveinterstate(interairl, poslassem5, rotlassem5);

% remove the cdg of l2
interairl2 = removecdgmeta(interairl2, interairl1.stablemesh.pcd);
interairl2 = removecdgmeta(interairl2, interairl3.stablemesh.pcd);
% remove the cdg of l3
interairl3 = removecdgmeta(interairl3, interairl2.stablemesh.pcd);
interairl3 = removecdgmeta(interairl3, interairl4.stablemesh.pcd);
% remove the cdg of l4
interairl4 = removecdgmeta(interairl4, interairl3.stablemesh.pcd);
interairl4 = removecdgmeta(interairl4, interairl5.stablemesh.pcd);
% remove the cdg of l4
interairl5 = removecdgmeta(interairl5, interairl4.stablemesh.pcd);

% placementsl = associnterstateps(interairl);

%%
% assemsgl is used to hold the two objects in the assembled structure
% assemsgl.obj1state = the first object and its associated grasps
% assemsgl.obj2state = the second object and its associated grasps
assemsgl_larray3 = [];
figure;
for placementid = 1:1
%     placementid = 4;
    transpl1 = placementsl{placementid}.transmat;
    rotpl1 = placementsl{placementid}.rotmat;
    interairl2moved = moveinterstate(interairl2, rotpl1*transpl1+rotpl1*poslassem2, rotpl1*rotlassem2);
    iscollided2 = sum(inpolyhedron(interairl2moved.stablemesh.faces, interairl2moved.stablemesh.verts, tablepcd));
    interairl3moved = moveinterstate(interairl3, rotpl1*transpl1+rotpl1*poslassem3, rotpl1*rotlassem3);
    iscollided3 = sum(inpolyhedron(interairl3moved.stablemesh.faces, interairl3moved.stablemesh.verts, tablepcd));
    interairl4moved = moveinterstate(interairl4, rotpl1*transpl1+rotpl1*poslassem4, rotpl1*rotlassem4);
    iscollided4 = sum(inpolyhedron(interairl4moved.stablemesh.faces, interairl4moved.stablemesh.verts, tablepcd));
    interairl5moved = moveinterstate(interairl5, rotpl1*transpl1+rotpl1*poslassem5, rotpl1*rotlassem5);
    iscollided5 = sum(inpolyhedron(interairl5moved.stablemesh.faces, interairl5moved.stablemesh.verts, tablepcd));
    
    subplot(2, ceil(size(placementsl, 1)/2), placementid);
    if iscollided2
        interairl2moved.graspparamids = [];
        interairl2moved.graspparams = [];
        plotinterstates(interairl2moved, 'r', [1, 0.7, 0.7]);
    else
        interairl2moved = removecdgmeta(interairl2moved, tablepcd);
        plotinterstates(interairl2moved, 'r');
    end
    if iscollided3
        interairl3moved.graspparamids = [];
        interairl3moved.graspparams = [];
        plotinterstates(interairl3moved, 'r', [1, 0.7, 0.7]);
    else
        interairl3moved = removecdgmeta(interairl3moved, tablepcd);
        plotinterstates(interairl3moved, 'r');
    end
    if iscollided4
        interairl4moved.graspparamids = [];
        interairl4moved.graspparams = [];
        plotinterstates(interairl4moved, 'r', [1, 0.7, 0.7]);
    else
        interairl4moved = removecdgmeta(interairl4moved, tablepcd);
        plotinterstates(interairl4moved, 'r');
    end
    if iscollided5
        interairl5moved.graspparamids = [];
        interairl5moved.graspparams = [];
        plotinterstates(interairl5moved, 'r', [1, 0.7, 0.7]);
    else
        interairl5moved = removecdgmeta(interairl5moved, tablepcd);
        plotinterstates(interairl5moved, 'r');
    end
    plotinterstates(placementsl{placementid}, 'b');
    plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
    
    
    if ~isempty(interairl2moved.graspparams) ...
            && ~isempty(interairl3moved.graspparams) ...
            && ~isempty(interairl4moved.graspparams) ...
            && ~isempty(interairl5moved.graspparams) ...
            && ~isempty(placementsl{placementid}.graspparams)
        pair.obj1state = placementsl{placementid};
        pair.obj2state = interairl2moved;
        pair.obj3state = interairl3moved;
        pair.obj4state = interairl4moved;
        pair.obj5state = interairl5moved;
        assemsgl_larray3 = [assemsgl_larray3;pair];
    end
end
save data/assemsgl_larray3 assemsgl_larray3;