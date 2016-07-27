function interair = computerinterstateairobstacle(objfile)
% compute the standard object pose in the air and its associated grasps
% example, computerinterair('objects/lpart.obj', 'hxgripper/hxpalm.obj',
% 'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj')
%
% input
% ----
% - objfile - the obj file of the object
%
% output
% ----
% - interair - the data structure that includes
% the standard object pose in the air and its associated grasps

    [V,F3,F4]=loadwobj(objfile);
    
    verts = V';
    faces = F3';
    nfaces = size(faces, 1);

    % interair
    interair.objcenter = [0,0,0]';
    interair.objx = [1,0,0]';
    interair.objy = [0,1,0]';
    interair.objz = [0,0,1]';
    interair.rotmat = eye(3,3);
    interair.transmat = [0,0,0];
    interair.placementp = [0,0,0]';
    interair.placementR = eye(3, 3);
    interair.stablemesh.verts = verts;
    interair.stablemesh.faces = faces;
    [interair.stablemesh.pcd, interair.stablemesh.pcdnormals] = ...
    	cvtpcd(interair.stablemesh.verts, interair.stablemesh.faces, 10000);
    expandlength = 0.001;
    interair.stablemesh.pcdplus = interair.stablemesh.pcd+...
        interair.stablemesh.pcdnormals*expandlength;
    interair.stablemesh.pcdminus = interair.stablemesh.pcd-...
        interair.stablemesh.pcdnormals*expandlength;
    % uncomment the following sentence to include verts
    % this is not recommended since it will cause pcd and pcd plus to have
    % different number of pnts
    % interair.stablemesh.pcd = [interair.stablemesh.pcd; interair.stablemesh.verts];
    [simplifiedverts, simplifiedfaces] = mergeCoplanarFaces(interair.stablemesh.verts, faces, 1e-1);
    nsimplifiedfaces = size(simplifiedfaces, 1);
    for j = 1:nsimplifiedfaces
        idvertsface = simplifiedfaces{j, 1};
        simplifiedfaces{j, 1} = idvertsface(isfinite(idvertsface(:)));
    end
    interair.stablemesh.simplifiedverts = simplifiedverts;
    interair.stablemesh.simplifiedfaces = simplifiedfaces;

    interair.graspparamids = [];
    interair.graspparams = [];
    interair.rotangles = linspace(0,2*pi,9);
    interair.rotangles = interair.rotangles(1:8);
    interair.thisrotangleid = 1;
    interair.type = 'air';

end

