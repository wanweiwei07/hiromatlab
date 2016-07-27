dbstop if error;

load data/interairl.mat
load data/interairtri.mat

% the table coordinates are global
% unncessry to do transformation
precision = 0.001;
tableverts = [[0.5, 0.5, -precision]; [-0.5, 0.5, -precision]; ...
    [-0.5, -0.5, -precision]; [0.5, -0.5, -precision]];
tablefaces = [[1, 2, 3]; [3, 4, 1]];
tablepcd = cvtpcd(tableverts, tablefaces, 10000);

postriassem = [0.0225;-0.0075;-0.0075];
rottriassem = rodrigues([0;1;0], -pi);
interstatetri = moveinterstate(interairtri, postriassem, rottriassem);
interstatel = removecdgmeta(interairl, interstatetri.stablemesh.pcd);

placementstri = associnterstateps(interstatetri);


%%
% assemsgl is used to hold the two objects in the assembled structure
% assemsgl.obj1state = the first object and its associated grasps
% assemsgl.obj2state = the second object and its associated grasps
assemsgl = [];
figure;
for placementid = 1:size(placementstri, 1)
% for placementid = 5:5
%     placementid = 4;
    transpt1 = placementstri{placementid}.transmat;
    rotpt1 = placementstri{placementid}.rotmat;
    interstatelmoved = moveinterstate(interstatel, rotpt1*transpt1, rotpt1);
    iscollided = sum(inpolyhedron(interstatelmoved.stablemesh.faces, interstatelmoved.stablemesh.verts, tablepcd));
    
    subplot(2, ceil(size(placementstri, 1)/2), placementid);
    if iscollided
        interstatelmoved.graspparamids = [];
        interstatelmoved.graspparams = [];
        plotinterstates(interstatelmoved, 'r', [1, 0.7, 0.7]);
    else
        if(checkassemstability(placementstri{placementid}, interstatelmoved))
            if(checkassemcdupdown(placementstri{placementid}, interstatelmoved))
                interstatelmoved.graspparamids = [];
                interstatelmoved.graspparams = [];
                plotinterstates(interstatelmoved, 'r', [0.3, 1, 0.3]);
            else
                interstatelmoved = removecdgmeta(interstatelmoved, tablepcd);
                plotinterstates(interstatelmoved, 'r');
            end
        else
            interstatelmoved.graspparamids = [];
            interstatelmoved.graspparams = [];
            plotinterstates(interstatelmoved, 'r', [0.7, 1, 0.7]);
        end
    end
    plotinterstates(placementstri{placementid}, 'b');
    plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
    if ~isempty(interstatelmoved.graspparams) && ~isempty(placementstri{placementid}.graspparams)
        pair.obj1state = placementstri{placementid};
        pair.obj2state = interstatelmoved;
        assemsgl = [assemsgl;pair];
    end
end
save data/assemsgl assemsgl;