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
interstatetri = removecdgmeta(interstatetri, interairl.stablemesh.pcd);

placementsl = associnterstateps(interairl);


%%
% assemsgl is used to hold the two objects in the assembled structure
% assemsgl.obj1state = the first object and its associated grasps
% assemsgl.obj2state = the second object and its associated grasps
assemsgl = [];
figure;
for placementid = 1:size(placementsl, 1)
%     placementid = 4;
    transpl1 = placementsl{placementid}.transmat;
    rotpl1 = placementsl{placementid}.rotmat;
    interstatetrimoved = moveinterstate(interstatetri, rotpl1*transpl1+rotpl1*postriassem, rotpl1*rottriassem);
    iscollided = sum(inpolyhedron(interstatetrimoved.stablemesh.faces, interstatetrimoved.stablemesh.verts, tablepcd));
    
    subplot(2, ceil(size(placementsl, 1)/2), placementid);
    if iscollided
        interstatetrimoved.graspparamids = [];
        interstatetrimoved.graspparams = [];
        plotinterstates(interstatetrimoved, 'r', [1, 0.7, 0.7]);
    else
        if(checkassemstability(placementsl{placementid}, interstatetrimoved))
            if(checkassemcdupdown(placementsl{placementid}, interstatetrimoved))
                interstatetrimoved.graspparamids = [];
                interstatetrimoved.graspparams = [];
                plotinterstates(interstatetrimoved, 'r', [0.3, 1, 0.3]);
            else
                interstatetrimoved = removecdgmeta(interstatetrimoved, tablepcd);
                plotinterstates(interstatetrimoved, 'r');
            end
        else
            interstatetrimoved.graspparamids = [];
            interstatetrimoved.graspparams = [];
            plotinterstates(interstatetrimoved, 'r', [0.7, 1, 0.7]);
        end
    end
    plotinterstates(placementsl{placementid}, 'b');
    plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
    if ~isempty(interstatetrimoved.graspparams) && ~isempty(placementsl{placementid}.graspparams)
        pair.obj1state = placementsl{placementid};
        pair.obj2state = interstatetrimoved;
        assemsgl = [assemsgl;pair];
    end
end
save data/assemsgl assemsgl;