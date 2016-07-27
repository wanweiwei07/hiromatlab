dbstop if error;

load data/interairtool.mat
load data/interairbolt.mat
load data/placementsbolt.mat

% the table coordinates are global
% unncessry to do transformation
precision = 0.001;
tableverts = [[0.5, 0.5, -precision]; [-0.5, 0.5, -precision]; ...
    [-0.5, -0.5, -precision]; [0.5, -0.5, -precision]];
tablefaces = [[1, 2, 3]; [3, 4, 1]];
tablepcd = cvtpcd(tableverts, tablefaces, 10000);


postoolassem = [0;0;0.083];
rottoolassem = eye(3,3);
interstatetool = moveinterstate(interairtool, postoolassem, rottoolassem);
interstatetool = removecdgmeta(interstatetool, interairbolt.stablemesh.pcd);

% placementsbolt = associnterstateps(interairbolt);


% postriassem = [0.0225;-0.0075;-0.0075];
% rottriassem = rodrigues([0;1;0], -pi);
% interstatetri = moveinterstate(interairtri, postriassem, rottriassem);
% interstatetri = removecdgmeta(interstatetri, interairl.stablemesh.pcd);

% placementsl = associnterstateps(interairl);

% plotinterstates(interstatetool)
% plotinterstates(interairbolt)
% plotstandardaxis([0,0,0],0.5)

%
% assemsgl is used to hold the two objects in the assembled structure
% assemsgl.obj1state = the first object and its associated grasps
% assemsgl.obj2state = the second object and its associated grasps
assemsgl_tool = [];
figure;
for placementid = 4:4%1:size(placementsbolt,1)
%     placementid = 4;
    transpl1 = placementsbolt{placementid}.transmat;
    rotpl1 = placementsbolt{placementid}.rotmat;
    interstatetoolmoved = moveinterstate(interstatetool, rotpl1*transpl1+rotpl1*postoolassem, rotpl1*rottoolassem);
    iscollided = sum(inpolyhedron(interstatetoolmoved.stablemesh.faces, interstatetoolmoved.stablemesh.verts, tablepcd));
    
    subplot(2, ceil(size(placementsbolt, 1)/2), placementid);
    if iscollided
        interstatetoolmoved.graspparamids = [];
        interstatetoolmoved.graspparams = [];
        plotinterstates(interstatetoolmoved, 'r', [1, 0.7, 0.7]);
    else
%        if(checkassemstability(placementsbolt{placementid}, interstatetoolmoved))
            if(checkassemcdupdown(placementsbolt{placementid}, interstatetoolmoved))
                interstatetoolmoved.graspparamids = [];
                interstatetoolmoved.graspparams = [];
                plotinterstates(interstatetoolmoved, 'r', [0.3, 1, 0.3]);
            else
                interstatetoolmoved = removecdgmeta(interstatetoolmoved, tablepcd);
                plotinterstates(interstatetoolmoved, 'r');
            end
%        else
%             interstatetoolmoved.graspparamids = [];
%             interstatetoolmoved.graspparams = [];
%             plotinterstates(interstatetoolmoved, 'r', [0.7, 1, 0.7]);
%         end
    end
    plotinterstates(placementsbolt{placementid}, 'b');
    plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
    if ~isempty(interstatetoolmoved.graspparams) && ~isempty(placementsbolt{placementid}.graspparams)
        pair.obj1state = placementsbolt{placementid};
        pair.obj2state = interstatetoolmoved;
        assemsgl_tool = [assemsgl_tool;pair];
    end
end
save data/assemsgl_tool assemsgl_tool;