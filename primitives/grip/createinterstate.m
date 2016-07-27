function newinterstate = createinterstate(interstateair, pos, rot)
% set the standard interstate to a new pos and rot to create a new
% interstate it updates the objcenter, objx, objy, objz, etc. in interstate
%
% input
% ----
% - interstateair - the datastructure of the standard interstate
% - pos - the new position to set the interstate to, column-first
% - rot - the new rotation to set the interstate to
%
% output
% ----
% - newinterstates - the datastructure of the setted interstate
%
% author: Weiwei
% date: 20160224

    newinterstate.objcenter = pos;
    newinterstate.objx = rot(1,:);
    newinterstate.objy = rot(2,:);
    newinterstate.objz = rot(3,:);
    newinterstate.rotmat = rot;
    newinterstate.transmat = [0;0;0]-newinterstate.objcenter;
    newinterstate.placementp = [0;0;0];
    newinterstate.placementR = eye(3,3);
    
    % verts
    newinterstate.stablemesh.verts = interstateair.stablemesh.verts;
    newinterstate.stablemesh.verts = bsxfun(@plus, newinterstate.stablemesh.verts', newinterstate.transmat);
    newinterstate.stablemesh.verts = newinterstate.rotmat*newinterstate.stablemesh.verts;
    newinterstate.stablemesh.verts = newinterstate.stablemesh.verts';
    % faces
    newinterstate.stablemesh.faces = interstateair.stablemesh.faces;
    % pcd
    newinterstate.stablemesh.pcd = interstateair.stablemesh.pcd;
    newinterstate.stablemesh.pcd = bsxfun(@plus, newinterstate.stablemesh.pcd', newinterstate.transmat);
    newinterstate.stablemesh.pcd = newinterstate.rotmat*newinterstate.stablemesh.pcd;
    newinterstate.stablemesh.pcd = newinterstate.stablemesh.pcd';
    % simplified verts
    newinterstate.stablemesh.simplifiedverts = interstateair.stablemesh.simplifiedverts;
    newinterstate.stablemesh.simplifiedverts = bsxfun(@plus, newinterstate.stablemesh.simplifiedverts', newinterstate.transmat);
    newinterstate.stablemesh.simplifiedverts = newinterstate.rotmat*newinterstate.stablemesh.simplifiedverts;
    newinterstate.stablemesh.simplifiedverts = newinterstate.stablemesh.simplifiedverts';
    % simplified faces
    newinterstate.stablemesh.simplifiedfaces = interstateair.stablemesh.simplifiedfaces;
    % graspparamids
    newinterstate.graspparamids = interstateair.graspparamids;
    % graspparams
    newinterstate.graspparams = [];
    ntotalgrasps = size(interstateair.graspparams, 1);
    for i = 1:ntotalgrasps
        thisgrasp = interstateair.graspparams(i);
        thisgrasp.handx = newinterstate.rotmat*thisgrasp.handx;
        thisgrasp.handy = newinterstate.rotmat*thisgrasp.handy;
        thisgrasp.handz = newinterstate.rotmat*thisgrasp.handz;
        thisgrasp.tcp = newinterstate.rotmat*(thisgrasp.tcp+newinterstate.transmat);
        thisgrasp.fgr1 = newinterstate.rotmat*(thisgrasp.fgr1+newinterstate.transmat);
        thisgrasp.fgr2 = newinterstate.rotmat*(thisgrasp.fgr2+newinterstate.transmat);
        thisgrasp.fgrcenter = newinterstate.rotmat*(thisgrasp.fgrcenter+newinterstate.transmat);
        thisgrasp.vertpalm = (newinterstate.rotmat*bsxfun(@plus, thisgrasp.vertpalm', newinterstate.transmat))';
        thisgrasp.vertfgr1 = (newinterstate.rotmat*bsxfun(@plus, thisgrasp.vertfgr1', newinterstate.transmat))';
        thisgrasp.vertfgr2 = (newinterstate.rotmat*bsxfun(@plus, thisgrasp.vertfgr2', newinterstate.transmat))';

        newinterstate.graspparams = [newinterstate.graspparams; thisgrasp];
        newinterstate.rotangles = linspace(0,2*pi,9);
        newinterstate.rotangles = newinterstate.rotangles(1:8);
        newinterstate.thisrotangleid = 1;
        newinterstate.type = 'air';
    end

end

