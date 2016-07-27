function interair = computeinterstateair(objfile, palmfile, fgr1file, fgr2file)
% compute the standard object pose in the air and its associated grasps
% example, computerinterair('objects/lpart.obj', 'hxgripper/hxpalm.obj',
% 'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj')
%
% input
% ----
% - objfile - the obj file of the object
% - palmfile - the palm file of the robot gripper
% - fgr1file - the obj file of the first finger
% - fgr2file - the obj file of the second finger
%
% output
% ----
% - interair - the data structure that includes
% the standard object pose in the air and its associated grasps

    [V,F3,F4]=loadwobj(objfile);

    % load hand mesh
    [Vpalm,F3palm,F4palm]=loadwobj(palmfile);
    Vpalm = Vpalm';
    F3palm = F3palm';
    [Vfgr1,F3fgr1,F4fgr1]=loadwobj(fgr1file);
    Vfgr1 = Vfgr1';
    F3fgr1 = F3fgr1';
    [Vfgr2,F3fgr2,F4fgr2]=loadwobj(fgr2file);
    Vfgr2 = Vfgr2';
    F3fgr2 = F3fgr2';

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

    normsface = computefacenormal(verts, faces);

    % find all parallel faces
    [fgrface1, fgrface2] = meshgrid(1:nfaces);
    fgrface1 = fgrface1(:);
    fgrface2 = fgrface2(:);
    % more constraints with complicated objects
    % only check whether the two faces are parallel here
    fgrface1norm = normsface(fgrface1, :);
    fgrface2norm = normsface(fgrface2, :);
    fgrnormsum = fgrface1norm + fgrface2norm;
    fgrnormsumlength = fgrnormsum(:, 1).^2+fgrnormsum(:, 2).^2+fgrnormsum(:, 3).^2;
    possiblepairs = find(fgrnormsumlength < 0.2);
    npps = size(possiblepairs, 1);
    fgrfaceposs1 = fgrface1(possiblepairs);
    fgrfaceposs2 = fgrface2(possiblepairs);
    fgrfacenormposs1 = fgrface1norm(possiblepairs, :);
    fgrfacenormposs2 = fgrface2norm(possiblepairs, :);

    % plot object
    %     for i = 1:nfaces
    %         cprintf('r', [num2str(i), '/', num2str(nfaces), '\n']);
    %         idverts = faces(i, :);
    %         faceverts = verts(idverts, :);
    %         patch('vertices', faceverts, 'faces', [1,2,3],'facecolor',[0.7,0.7,0.7],'facealpha',0.9);
    %         hold on;
    %         view(3);
    %         axis vis3d;
    %         axis equal;
    %         axis([-0.25, 0.25, -0.25, 0.25, -0.25, 0.25]);
    %         xlabel('x');
    %         ylabel('y');
    %         facecenter = sum(faceverts, 1)/3;
    %         quiver3(facecenter(1), facecenter(2), facecenter(3), normsface(i, 1)*0.01, normsface(i, 2)*0.01, normsface(i, 3)*0.01, 'color', 'r');
    %     end

    % precision to avoid collision of finger tips
    precision = 0.002;
    totalgrasps = [];
    totalgraspspairs = [];
    anglegran = 8;
    newnpps = 0;
    for i = 1:npps
        cprintf('r', [num2str(i), '/', num2str(npps), '\n']);
        % for each pair, find the center of fgr1 and its projection on fgr2
        idvertsfgr1 = faces(fgrfaceposs1(i), :);
        nvertsfgr1 = size(idvertsfgr1, 2);
        fgr1faceverts = verts(idvertsfgr1, :);
        % sample the face !! must be triangular; 1000 means 1point per cm^2s
        fgr1pnts = sampletriangle(fgr1faceverts(1,:), fgr1faceverts(2,:), fgr1faceverts(3,:), 10000);
        if isempty(fgr1pnts)
            continue;
        end
    %     patch('vertices', fgr1faceverts, 'faces', [1,2,3], 'facecolor', [1,0.8,0.8], 'facealpha',0.9);
    %     hold on;
    %     plot3(fgr1pnts(:,1), fgr1pnts(:,2), fgr1pnts(:,3), '.', 'markersize', 10, 'color', 'g');
        nfgr1pnts = size(fgr1pnts, 1);
        for j = 1:nfgr1pnts
            fgr1 = fgr1pnts(j, :);
            idvertsfgr2 = faces(fgrfaceposs2(i), :);
            fgr2faceverts = verts(idvertsfgr2, :);
            fgr2facenormal = normsface(fgrfaceposs2(i), :);
            [fgr2, inside] = intersectLinePolygon3d([fgr1, fgr2facenormal], fgr2faceverts);
            fgrdist = norm(fgr1-fgr2);
            if ~inside || fgrdist > 0.05
                continue;
            end
%             patch('vertices', fgr2faceverts, 'faces', [1,2,3], 'facecolor', [1,0.8,0.8], 'facealpha',0.9);
            if ~isempty(totalgraspspairs)
                % see if it was too near
                fgr1old = totalgraspspairs(:, 1:3);
                fgr2old = totalgraspspairs(:, 4:6);
                diffgr1 = bsxfun(@minus, fgr1old, fgr1);
                dstdiff1 = sqrt(diffgr1(:,1).^2+diffgr1(:,2).^2+diffgr1(:,3).^2);
                smallids1 = find(dstdiff1<0.005);
                if ~isempty(smallids1)
                    fgr2oldposs = fgr2old(smallids1,:);
                    diffgr2 = bsxfun(@minus, fgr2oldposs, fgr2);
                    dstdiff2 = sqrt(diffgr2(:,1).^2+diffgr2(:,2).^2+diffgr2(:,3).^2);
                    smallids2 = find(dstdiff2<20);
                    if ~isempty(smallids2)
                        fgr1near = fgr1old(smallids1(smallids2),:);
                        fgr2near = fgr2oldposs(smallids2, :);
                        normnew = fgr2-fgr1;
                        normold = fgr2near-fgr1near;
                        normnew = normnew./sqrt(normnew(:,1).^2+normnew(:,2).^2+normnew(:,3).^2);
                        normold = normold./repmat(sqrt(normold(:,1).^2+normold(:,2).^2+normold(:,3).^2), 1, 3);
                        normsum = bsxfun(@plus, normnew, normold);
                        normlength = sqrt(normsum(:,1).^2+normsum(:,2).^2+normsum(:,3).^2);
                        if any(normlength > 1.9)
                            % there should be only one
                            continue;
                        end
                    end
                end
            end
            totalgraspspairs = [totalgraspspairs; [fgr1, fgr2]];
            newnpps = newnpps+1;
            fgrcenter = (fgr1+fgr2)/2;
            facenormal1 = fgrfacenormposs1(i, :);
            facenormal2 = fgrfacenormposs2(i, :);
            % find a normal that is perpendicular to the surface normal of fgr1
            % and the first edge of fgr1face as the hand normal
            fgr1face1stedge = fgr1faceverts(2, :) - fgr1faceverts(1, :);
            fgr1face1stedgenorm = normalizeVector3d(fgr1face1stedge);
            handnormal = cross(facenormal1, fgr1face1stedgenorm);

            % discretize the rotation
            for k = 1:8
                % sample a circle with eight points
                R = rodrigues(facenormal1, 2*pi/anglegran*k);
                % find hand position 
                % the gripper length is supposed to be 130
                % the gripper center is supposed to be 12
                % which means the gripper center is 130 in -handnormal direction
                % plus 12 in cross(fgr1, handnormal) direction
                possiblegrasp.handx = R*handnormal';
                possiblegrasp.handy = facenormal1';
                possiblegrasp.handz = cross(possiblegrasp.handx, possiblegrasp.handy);
                % further retract tcp with 0.22
                possiblegrasp.tcp = fgrcenter'+possiblegrasp.handx*0.22;
                possiblegrasp.fgr1 = possiblegrasp.tcp+(fgrdist/2+0.02+precision)*possiblegrasp.handy;
                possiblegrasp.fgr2 = possiblegrasp.tcp-(fgrdist/2+0.02+precision)*possiblegrasp.handy;
                possiblegrasp.fgrcenter = fgrcenter';
                possiblegrasp.fgrdist = fgrdist;
                vertpalm = [possiblegrasp.handx, possiblegrasp.handy, possiblegrasp.handz]*Vpalm';
                vertpalm = vertpalm';
                vertpalm = bsxfun(@plus, vertpalm, possiblegrasp.tcp'); 
                vertfgr1 = [possiblegrasp.handx, possiblegrasp.handy, possiblegrasp.handz]*Vfgr1';
                vertfgr1 = vertfgr1';
                vertfgr1 = bsxfun(@plus, vertfgr1, possiblegrasp.fgr1'); 
                vertfgr2 = [possiblegrasp.handx, possiblegrasp.handy, possiblegrasp.handz]*Vfgr2';
                vertfgr2 = vertfgr2';
                vertfgr2 = bsxfun(@plus, vertfgr2, possiblegrasp.fgr2');
                
                % see if there is intersection
                inpalm = inpolyhedron(F3palm, vertpalm, interair.stablemesh.pcd);
                infgr1 = inpolyhedron(F3fgr1, vertfgr1, interair.stablemesh.pcd);
                infgr2 = inpolyhedron(F3fgr2, vertfgr2, interair.stablemesh.pcd);
                isinpalm = sum(inpalm);
                isinfgr1 = sum(infgr1);
                isinfgr2 = sum(infgr2);
                if isinpalm || isinfgr1 || isinfgr2
    %                 pntsinpalm = interair.stablemesh.pcd(find(inpalm),:);
    %                 pntsinfgr1 = interair.stablemesh.pcd(find(infgr1),:);
    %                 pntsinfgr2 = interair.stablemesh.pcd(find(infgr2),:);
    %                 plot3(pntsinpalm(:,1), pntsinpalm(:,2), pntsinpalm(:,3), '.g', 'linewidth', 25);
    %                 plot3(pntsinfgr1(:,1), pntsinfgr1(:,2), pntsinfgr1(:,3), '.g', 'linewidth', 25);
    %                 plot3(pntsinfgr2(:,1), pntsinfgr2(:,2), pntsinfgr2(:,3), '.g', 'linewidth', 25);
    %                 plot3(interair.stablemesh.pcd(:,1), interair.stablemesh.pcd(:,2), interair.stablemesh.pcd(:,3), '.r', 'linewidth', 25);
    %                 drawMesh(vertpalm, F3palm, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
    %                 drawMesh(vertfgr1, F3fgr1, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
    %                 drawMesh(vertfgr2, F3fgr2, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
    %                 plot3([possiblegrasp.fgrcenter(1); possiblegrasp.tcp(1)], ...
    %                     [possiblegrasp.fgrcenter(2); possiblegrasp.tcp(2)], ...
    %                     [possiblegrasp.fgrcenter(3); possiblegrasp.tcp(3)], 'linestyle', '-', 'linewidth', 2, 'color', 'r');
    %                 drawnow;
                    continue;
                else
    %                 drawMesh(vertpalm, F3palm, 'facecolor', [0.7, 1.0, 0.7], 'facealpha', 0.4);
    %                 drawMesh(vertfgr1, F3fgr1, 'facecolor', [0.7, 1.0, 0.7], 'facealpha', 0.4);
    %                 drawMesh(vertfgr2, F3fgr2, 'facecolor', [0.7, 1.0, 0.7], 'facealpha', 0.4);
    %                 plot3([possiblegrasp.fgrcenter(1); possiblegrasp.tcp(1)], ...
    %                     [possiblegrasp.fgrcenter(2); possiblegrasp.tcp(2)], ...
    %                     [possiblegrasp.fgrcenter(3); possiblegrasp.tcp(3)], 'linestyle', '-', 'linewidth', 2, 'color', 'g');
                end
                possiblegrasp.vertpalm = vertpalm;
                possiblegrasp.f3palm = F3palm;
                possiblegrasp.vertfgr1 = vertfgr1;
                possiblegrasp.f3fgr1 = F3fgr1;
                possiblegrasp.vertfgr2 = vertfgr2;
                possiblegrasp.f3fgr2 = F3fgr2;
                totalgrasps = [totalgrasps; possiblegrasp];
            end
        end
    end

    % plot grasps
    ntotalgrasps = size(totalgrasps, 1);
    % for j = 1:ntotalgrasps
    %     thisgrasp = totalgrasps(j);
    %     handx = thisgrasp.handx;
    %     handy = thisgrasp.handy;
    %     handz = thisgrasp.handz;
    %     tcp = thisgrasp.tcp;
    %     fgrcenter = thisgrasp.fgrcenter;
    %     plot3([fgrcenter(1); tcp(1)], ...
    %           [fgrcenter(2); tcp(2)], ...
    %           [fgrcenter(3); tcp(3)], 'linestyle', '-', 'linewidth', 2);
    %     quiver3(tcp(1), tcp(2), tcp(3), handx(1)*0.001, handx(2)*0.001,...
    %         handx(3)*0.001, 'color','r');
    %     quiver3(tcp(1), tcp(2), tcp(3), handy(1)*0.001, handy(2)*0.001,...
    %         handy(3)*0.001, 'color','g');
    %     quiver3(tcp(1), tcp(2), tcp(3), handz(1)*0.001, handz(2)*0.001,...
    %         handz(3)*0.001, 'color','b');
    %     
    %     vertpalm = thisgrasp.vertpalm;
    %     f3palm = thisgrasp.f3palm;
    %     vertfgr1 = thisgrasp.vertfgr1;
    %     f3fgr1 = thisgrasp.f3fgr1;
    %     vertfgr2 = thisgrasp.vertfgr2;
    %     f3fgr2 = thisgrasp.f3fgr2;
    %     drawMesh(vertpalm, f3palm, 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
    %     drawMesh(vertfgr1, f3fgr1, 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
    %     drawMesh(vertfgr2, f3fgr2, 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
    %     drawnow;
    % end

    interair.graspparamids = (1:ntotalgrasps)';
    interair.graspparams = totalgrasps;
    interair.rotangles = linspace(0,2*pi,9);
    interair.rotangles = interair.rotangles(1:8);
    interair.thisrotangleid = 1;
    interair.type = 'air';

end

