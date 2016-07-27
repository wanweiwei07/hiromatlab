load data/placementsl.mat

precision=0.001
edgelength = 0.1
tableverts = [[edgelength, edgelength, -precision]; [-edgelength, edgelength, -precision]; ...
    [-edgelength, -edgelength, -precision]; [edgelength, -edgelength, -precision]];
tablefaces = [[2, 1, 3]; [4, 3, 1]];

precision=0.001
edgelength = 0.5
tableverts2 = [[edgelength, edgelength, -precision]; [-edgelength, edgelength, -precision]; ...
    [-edgelength, -edgelength, -precision]; [edgelength, -edgelength, -precision]];
tablefaces2 = [[2, 1, 3]; [4, 3, 1]];
tablepcd = cvtpcd(tableverts2, tablefaces2, 10000);

% for i=1:size(placementsl,1)
%     figure;
%     plotinterstates(placementsl{i}, 'none', [.8, .6, 0]);
%     patch('vertices', tableverts, 'faces', tablefaces, 'facecolor', [.1, .1, .1], 'edgecolor', 'none');
% end
% dbstop if error;

load data/interairl.mat
load data/interairtri.mat
postriassem = [0.0225;-0.0075;-0.0075];
rottriassem = rodrigues([0;1;0], -pi);
interstatetri = moveinterstate(interairtri, postriassem, rottriassem);
interstatetri = removecdgmeta(interstatetri, interairl.stablemesh.pcd);

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
    
%     subplot(2, ceil(size(placementsl, 1)/2), placementid);
    figure;
    if iscollided
        interstatetrimoved.graspparamids = [];
        interstatetrimoved.graspparams = [];
        plotinterstates(interstatetrimoved, 'none', [1, 0.7, 0.7]);
    else
        if(checkassemstability(placementsl{placementid}, interstatetrimoved))
            if(checkassemcdupdown(placementsl{placementid}, interstatetrimoved))
                interstatetrimoved.graspparamids = [];
                interstatetrimoved.graspparams = [];
                plotinterstates(interstatetrimoved, 'none', [0.3, 1, 0.3]);
            else
                interstatetrimoved = removecdgmeta(interstatetrimoved, tablepcd);
                plotinterstates(interstatetrimoved, [.3,.5,.3], [.3,.5,.3]);

%                 assemdirect = [0,0,1];
%                 initverts = interstatetrimoved.stablemesh.verts;
%                 facenormals = computefacenormal(interstatetrimoved.stablemesh.verts, interstatetrimoved.stablemesh.faces);
%                 fnadangles = dot(facenormals, repmat(assemdirect, size(facenormals, 1), 1), 2);
%                 extfaces = interstatetrimoved.stablemesh.faces((fnadangles>0.2), :);
%                 extedges = meshEdges(extfaces);
%                 extadjfaces = meshEdgeFaces(initverts, extedges, extfaces);
%                 extbounds = [fliplr(extedges(extadjfaces(:,1)==0, :));extedges(extadjfaces(:,2)==0, :)];
%                 extedverts = bsxfun(@plus, initverts, assemdirect*0.2);
%                 allverts = [initverts;extedverts];
%                 extedfaces = extfaces+size(initverts,1);
%                 extedbounds = extbounds+size(initverts,1);
%                 sweptfaces = [fliplr(extfaces); [extbounds, extedbounds(:,1)]; ...
%                     [fliplr(extedbounds), extbounds(:,2)]; extedfaces];
%                 patch('vertices', allverts, 'faces', sweptfaces, 'facecolor', [.3, .5, .3], 'facealpha', .3, 'edgecolor', 'none');
            end
        else
            interstatetrimoved.graspparamids = [];
            interstatetrimoved.graspparams = [];
            plotinterstates(interstatetrimoved, 'none', [0.7, 1, 0.7]);
        end
    end
    plotinterstates(placementsl{placementid}, [.8,.6,0], [.8,.6,0]);
    patch('vertices', tableverts, 'faces', tablefaces, 'facecolor', [.1, .1, .1], 'edgecolor', 'none');
%     plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
end