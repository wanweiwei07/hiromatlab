dbstop if error;

load interair.mat;
totalgrasps = interair.graspparams;
ntotalgrasps = size(totalgrasps, 1);

[V,F3,F4]=loadwobj('lpart.obj');

pnts = cvtpcd(V, F3, 10000);

% the table coordinates are global
% unncessry to do transformation
tableverts = [[0.5, 0.5, 0]', [-0.5, 0.5, 0]', ...
    [-0.5, -0.5, 0]', [0.5, -0.5, 0]'];
tablefaces = [[1, 2, 3]', [3, 4, 1]'];
pntstable = cvtpcd(tableverts, tablefaces, 10000);

objo = [0, 0, 0]';
objxx = [1, 0, 0]';
objyy = [0, 1, 0]';
objzz = [0, 0, 1]';

verts = V';
faces = F3';
nfaces = size(faces, 1);

[norms, normsface] = compute_normal(verts, faces);
norms = norms';
normsface = normsface';

% figure;
% plot original mesh    
% for j = 1:nfaces
%     idvertsface = faces(j, :);
%     faceverts = verts(idvertsface, :);
%     patch('vertices',faceverts,'faces',[1,2,3],'facecolor',[0.7,0.7,0.7],'facealpha',0.9);
%     alpha(.7);
%     hold on;
%     view(3);
%     axis vis3d;
%     axis equal;
%     axis([-0.25, 0.25, -0.25, 0.25, -0.25, 0.25]);
%     xlabel('x');
%     ylabel('y');
% end
% create matching template and the related grasping
% calculate the convex hull of an object
facesconv = minConvexHull(verts, 1e-2)';
nfacesconv = size(facesconv, 1);
normsfaceconv = faceNormal(verts, facesconv);
% plot convex mesh
% for j = 1:nfacesconv
%     idvertsface = facesconv(j, :);
%     faceverts = verts(idvertsface{1}, :);
%     placecenter = (sum(faceverts)/size(faceverts, 1));
%     plot3([faceverts(:, 1);faceverts(1, 1)], [faceverts(:, 2);faceverts(1, 2)], ...
%         [faceverts(:, 3);faceverts(1, 3)], 'r');
%     quiver3(placecenter(1, 1), placecenter(1, 2), placecenter(1, 3), ...
%         normsfaceconv(j, 1)*100, normsfaceconv(j, 2)*100, normsfaceconv(j, 3)*100);
%     alpha(.2);
%     hold on;
%     axis equal;
%     axis tight;
% end

centerofmass = mean(pnts);
% plot3(centerofmass(1), centerofmass(2), centerofmass(3), '.', 'markersize', 10, 'color', 'r');

% find support faces
facessupport = [];
for i = 1:nfacesconv
    cprintf('r', [num2str(i), '/', num2str(nfacesconv), '\n']);
    idvertsface = facesconv(i, :);
    faceverts = verts(idvertsface{1}, :);
    facenormal = normsfaceconv(i, :);
    % see if the center of mass is in side this support surface
    inside = 0;
    for j = 1:2
        % random center
        centerofmassnew = centerofmass + [(rand-0.5)*j*1e-4, (rand-0.5)*j*1e-4, (rand-0.5)*j*1e-4];
        [inter, isin] = intersectLinePolygon3d([centerofmassnew, facenormal], faceverts);
        if isin
            inside = 1;
            break;
        end
    end
    if inside == 1
        % avoid repeated neighbour
        normalsold = normsfaceconv(facessupport, :);
        normalsum = bsxfun(@plus, normalsold, facenormal);
        normsumlength = sqrt(normalsum(:,1).^2+normalsum(:,2).^2+normalsum(:,3).^2);
        if all(normsumlength<1.99)
            facessupport = [facessupport; i];
        end
    end
end
nfacessupport = size(facessupport, 1);

figure;
placements = cell(nfacessupport, 1);
% the important part of a grasp is organized as follows
% objmodel: the model of the object
% graspparamid: id of the grasp for comparison between placements
% graspparams: the params of the grasp after transforming
% each grasp params include: handx, handy, handz, tcp, and fgrcenter
for i = 1:nfacessupport
    subplot(ceil(nfacessupport/3), 3, i);
    disp(i);
    plot3(pntstable(:,1), pntstable(:,2), pntstable(:,3), '.b', 'linewidth', 5);
    hold on;
    idvertsface = facesconv(facessupport(i), :);
    faceverts = verts(idvertsface{1}, :);
    % use the center of AABB as the center
    placecenter = [(min(faceverts(:, 1))+max(faceverts(:, 1)))/2, ...
        (min(faceverts(:, 2))+max(faceverts(:, 2)))/2, ...
        (min(faceverts(:, 3))+max(faceverts(:, 3)))/2];
    placenormal = -normsfaceconv(facessupport(i), :)';
    placements{i}.objcenter = placecenter';
    placements{i}.objz = placenormal;
    % use the first edge of this face as the direction of x
    placements{i}.objx = normalizeVector3d(faceverts(2, :) - faceverts(1, :))';
    placements{i}.objy = -cross(placements{i}.objx, placements{i}.objz);
    placements{i}.rotmat = inv([placements{i}.objx, placements{i}.objy, placements{i}.objz]);
    placements{i}.transmat = objo-placements{i}.objcenter;
    % use the placementp, placementR to denote the variable of i/g/inter
    placements{i}.placementp = [0,0,0]';
    placements{i}.placementR = eye(3, 3);
    % % plot original mesh
    %  for j = 1:nfaces
    %      idvertsface = faces(j, :);
    %      faceverts = verts(idvertsface, :);
    %      plot3(faceverts(:, 1), faceverts(:, 2), faceverts(:, 3), 'linestyle', '-');
    %      alpha(.2);
    %      hold on;
    %  end
    %  % plot original normal
    %  quiver3(objo(1), objo(2), objo(3), objxx(1), objxx(2), objxx(3));
    %  quiver3(objo(1), objo(2), objo(3), objyy(1), objyy(2), objyy(3));
    %  quiver3(objo(1), objo(2), objo(3), objzz(1), objzz(2), objzz(3));
    %  hold on;
    % plot stable mesh
    placements{i}.stablemesh.verts = verts;
    placements{i}.stablemesh.verts = bsxfun(@plus, placements{i}.stablemesh.verts', placements{i}.transmat);
    placements{i}.stablemesh.verts = placements{i}.rotmat*placements{i}.stablemesh.verts;
    placements{i}.stablemesh.verts = placements{i}.stablemesh.verts';
    placements{i}.stablemesh.faces = faces;
    % % we can use verts as pcd or create anothre pcd. sparse pcd is fine
    %  placements{i}.stablemesh.pcd = placements{i}.stablemesh.verts;
    placements{i}.stablemesh.pcd = cvtpcd(placements{i}.stablemesh.verts', placements{i}.stablemesh.faces', 10000);
    placements{i}.stablemesh.pcd = [placements{i}.stablemesh.pcd; placements{i}.stablemesh.verts];
    [simplifiedverts, simplifiedfaces] = mergeCoplanarFaces(placements{i}.stablemesh.verts, faces, 1e-1);
    nsimplifiedfaces = size(simplifiedfaces, 1);
    for j = 1:nsimplifiedfaces
        idvertsface = simplifiedfaces{j, 1};
        simplifiedfaces{j, 1} = idvertsface(isfinite(idvertsface(:)));
    end
    placements{i}.stablemesh.simplifiedverts = simplifiedverts;
    placements{i}.stablemesh.simplifiedfaces = simplifiedfaces;
    % prepare the points for collision detection
    pntsforcd = [placements{i}.stablemesh.pcd; pntstable];
    nsimplifiedfaces = size(simplifiedfaces, 1);
    for j = 1:nsimplifiedfaces
        idvertsface = simplifiedfaces{j, 1};
        cmap = colormap('lines');
        patch('vertices', placements{i}.stablemesh.simplifiedverts,...
            'faces',idvertsface,'facecolor',cmap(mod(j, 64)+1, :));
        hold on;
        view([50, 20]);
        axis equal;
        axis([-0.25, 0.25, -0.25, 0.25, -0.25, 0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
        % alpha(.9);
        % % plot normal
        % quiver3(placements{i}.objcenter(1), placements{i}.objcenter(2), placements{i}.objcenter(3), ...
        %     placements{i}.objx(1)*0.001, placements{i}.objx(2)*0.001, placements{i}.objx(3)*0.001);
        % quiver3(placements{i}.objcenter(1), placements{i}.objcenter(2), placements{i}.objcenter(3), ...
        %     placements{i}.objy(1)*0.001, placements{i}.objy(2)*0.001, placements{i}.objy(3)*0.001);
        % quiver3(placements{i}.objcenter(1), placements{i}.objcenter(2), placements{i}.objcenter(3), ...
        %     placements{i}.objz(1)*0.001, placements{i}.objz(2)*0.001, placements{i}.objz(3)*0.001);
        % hold on;
    end
    % all possible grasps relates to this placement
    placements{i}.graspparamid = [];
    placements{i}.graspparams = [];
    for j = 1:ntotalgrasps
        handx = totalgrasps(j).handx;
        theta = vectorAngle3d(handx', placenormal');
        if theta < 2.3
            % a possible grasp
            thisgrasp = totalgrasps(j);
            thisgrasp.handx = placements{i}.rotmat*thisgrasp.handx;
            thisgrasp.handy = placements{i}.rotmat*thisgrasp.handy;
            thisgrasp.handz = placements{i}.rotmat*thisgrasp.handz;
            thisgrasp.tcp = placements{i}.rotmat*(thisgrasp.tcp+placements{i}.transmat);
            thisgrasp.fgr1 = placements{i}.rotmat*(thisgrasp.fgr1+placements{i}.transmat);
            thisgrasp.fgr2 = placements{i}.rotmat*(thisgrasp.fgr2+placements{i}.transmat);
            thisgrasp.fgrcenter = placements{i}.rotmat*(thisgrasp.fgrcenter+placements{i}.transmat);
            thisgrasp.vertpalm = (placements{i}.rotmat*bsxfun(@plus, thisgrasp.vertpalm', placements{i}.transmat))';
            thisgrasp.vertfgr1 = (placements{i}.rotmat*bsxfun(@plus, thisgrasp.vertfgr1', placements{i}.transmat))';
            thisgrasp.vertfgr2 = (placements{i}.rotmat*bsxfun(@plus, thisgrasp.vertfgr2', placements{i}.transmat))';
            
            % plotgrasp transformed
            handx = thisgrasp.handx;
            handy = thisgrasp.handy;
            handz = thisgrasp.handz;
            tcp = thisgrasp.tcp;
            fgr1 = thisgrasp.fgr1;
            fgr2 = thisgrasp.fgr2;
            fgrcenter = thisgrasp.fgrcenter;
            
            if theta > 1.5
                if tcp(3) < 0.08
                    continue;
                end
            end
            
            % collision detection
            % calculate hand mesh
            vertpalm = thisgrasp.vertpalm;
            f3palm = thisgrasp.f3palm;
            vertfgr1 = thisgrasp.vertfgr1;
            f3fgr1 = thisgrasp.f3fgr1;
            vertfgr2 = thisgrasp.vertfgr2;
            f3fgr2 = thisgrasp.f3fgr2;
            % see if there is intersection
            inpalm = inpolyhedron(f3palm, vertpalm, pntsforcd);
            infgr1 = inpolyhedron(f3fgr1, vertfgr1, pntsforcd);
            infgr2 = inpolyhedron(f3fgr2, vertfgr2, pntsforcd);
            %  plot3(pntsforcd(:, 1), pntsforcd(:, 2), pntsforcd(:, 3), '.', 'markersize', 5);
            %  plot3(pntsforcd(inpalm, 1), pntsforcd(inpalm, 2), pntsforcd(inpalm, 3), '.', 'markersize', 5, 'color', 'r');
            isinpalm = sum(inpalm);
            isinfgr1 = sum(infgr1);
            isinfgr2 = sum(infgr2);
            if isinpalm || isinfgr1 || isinfgr2
                pntsinpalm = pntsforcd(find(inpalm),:);
                pntsinfgr1 = pntsforcd(find(infgr1),:);
                pntsinfgr2 = pntsforcd(find(infgr2),:);
                plot3(pntsinpalm(:,1), pntsinpalm(:,2), pntsinpalm(:,3), '.g', 'linewidth', 5);
                plot3(pntsinfgr1(:,1), pntsinfgr1(:,2), pntsinfgr1(:,3), '.g', 'linewidth', 5);
                plot3(pntsinfgr2(:,1), pntsinfgr2(:,2), pntsinfgr2(:,3), '.g', 'linewidth', 5);
%                 drawMesh(vertpalm, f3palm, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
%                 drawMesh(vertfgr1, f3fgr1, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
%                 drawMesh(vertfgr2, f3fgr2, 'facecolor', [1, 0.7, 0.7], 'facealpha', 0.4);
                plot3([thisgrasp.fgrcenter(1); thisgrasp.tcp(1)], ...
                    [thisgrasp.fgrcenter(2); thisgrasp.tcp(2)], ...
                    [thisgrasp.fgrcenter(3); thisgrasp.tcp(3)], 'linestyle', '-', 'linewidth', 2, 'color', 'r');
                drawnow;
                continue;
            end
            
            % all right; we accept it
            % fgrdist doesn't change
            placements{i}.graspparams = [placements{i}.graspparams; thisgrasp];
            placements{i}.graspparamid = [placements{i}.graspparamid; j];
            placements{i}.rotangles = linspace(0,2*pi,9);
            placements{i}.rotangles = placements{i}.rotangles(1:8);
            placements{i}.thisrotangleid = 1;
            placements{i}.type='planar';
            rotaxis = placements{i}.objz;
%             drawMesh(vertpalm, F3palm', 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
%             drawMesh(vertfgr1, F3fgr1', 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
%             drawMesh(vertfgr2, F3fgr2', 'facecolor', [0.9, 0.9, 0.9], 'facealpha', 0.7);
%             drawnow;
            %  plot3(pntstransf(:, 1), pntstransf(:, 2), pntstransf(:, 3), '.', 'markersize', 5);
            %  plot3(pntstransf(inpalm, 1), pntstransf(inpalm, 2), pntstransf(inpalm, 3), '.', 'markersize', 5, 'color', 'r');
            %
            % % plot handnormal
            %  quiver3(fgrcenter(1), fgrcenter(2), fgrcenter(3), handz(1), handz(2), handz(3));
            % plot tcp
            plot3([fgrcenter(1); tcp(1)], ...
                [fgrcenter(2); tcp(2)], ...
                [fgrcenter(3); tcp(3)], 'linestyle', '-', 'linewidth', 2, 'color', 'g');
            drawnow;
            % % plot axis
            %  quiver3(tcp(1), tcp(2), tcp(3), handx(1), handx(2), handx(3));
            %  quiver3(tcp(1), tcp(2), tcp(3), handy(1), handy(2), handy(3));
            %  quiver3(tcp(1), tcp(2), tcp(3), handz(1), handz(2), handz(3));
            % % plot hand
            
            %  % plotgrasp nontransformed
            %  graspparams =  totalgrasps(j);
            %  handx = graspparams.handx;
            %  handy = graspparams.handy;
            %  handz = graspparams.handz;
            %  handcenter = graspparams.handcenter;
            %  tcp = graspparams.tcp;
            %  fgrcenter = graspparams.fgrcenter;
            %  % plot handnormal
            %  quiver3(fgrcenter(1), fgrcenter(2), fgrcenter(3), handz(1), handz(2), handz(3));
            %  % plot tcp
            %  plot3([fgrcenter(1); handcenter(1); tcp(1)], ...
            %      [fgrcenter(2); handcenter(2); tcp(2)], ...
            %      [fgrcenter(3); handcenter(3); tcp(3)], 'linestyle', '-', 'linewidth', 1, 'color', 'b');
            %  % plot axis
            %  quiver3(tcp(1), tcp(2), tcp(3), handx(1), handx(2), handx(3));
            %  quiver3(tcp(1), tcp(2), tcp(3), handy(1), handy(2), handy(3));
            %  quiver3(tcp(1), tcp(2), tcp(3), handz(1), handz(2), handz(3));
        end
    end
end


save placements.mat placements