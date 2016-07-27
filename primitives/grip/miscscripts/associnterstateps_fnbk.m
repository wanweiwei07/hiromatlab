function placements = associnterstateps(interstateair)
% compute the placements and associate the computed grasps to the placements
%
% input
% ----
% - interstateair - the standard object pose in the air and its associated grps
%
% output
% ----
% - placements - the data structure that includes
% the object placements on a planar surface and its associated grasps

    verts = interstateair.stablemesh.verts;
    pnts = interstateair.stablemesh.pcd;
    
    % the table coordinates are global
    % unncessry to do transformation
    tableverts = [[0.5, 0.5, 0]', [-0.5, 0.5, 0]', ...
        [-0.5, -0.5, 0]', [0.5, -0.5, 0]'];
    tablefaces = [[1, 2, 3]', [3, 4, 1]'];
    tablepcd = cvtpcd(tableverts, tablefaces, 10000);

    % create matching template and the related grasping
    % calculate the convex hull of an object
    facesconv = minConvexHull(verts, 1e-2)';
    nfacesconv = size(facesconv, 1);
    normsfaceconv = faceNormal(verts, facesconv);

    centerofmass = mean(pnts);
    % plot3(centerofmass(1), centerofmass(2), centerofmass(3), '.', 'markersize', 10, 'color', 'r');

    % find support faces
    facessupport = [];
    for i = 1:nfacesconv
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
    placements = cell(nfacessupport, 1);
    % the important part of a grasp is organized as follows
    % objmodel: the model of the object
    % graspparamids: id of the grasp for comparison between placements
    % graspparams: the params of the grasp after transforming
    % each grasp params include: handx, handy, handz, tcp, and fgrcenter
    for i = 1:nfacessupport
        cprintf('r', [num2str(i), '/', num2str(nfacesconv), '\n']);
        % subplot(ceil(nfacessupport/3), 3, i);
        % disp(i);
        % plot3(pntstable(:,1), pntstable(:,2), pntstable(:,3), '.b', 'linewidth', 5);
        % hold on;
        idvertsface = facesconv(facessupport(i), :);
        faceverts = verts(idvertsface{1}, :);
        % use the center of AABB as the center
        pos = [(min(faceverts(:, 1))+max(faceverts(:, 1)))/2, ...
            (min(faceverts(:, 2))+max(faceverts(:, 2)))/2, ...
            (min(faceverts(:, 3))+max(faceverts(:, 3)))/2]';
        objz = -normsfaceconv(facessupport(i), :)';
        objx = normalizeVector3d(faceverts(2, :) - faceverts(1, :))';
        objy = -cross(objx, objz);
        rotmat = [objx';objy';objz'];
        placements{i} = createinterstate(interstateair, pos, rotmat);
        % all possible grasps relates to this placement
        placements{i} = removecdgmeta(placements{i}, tablepcd);
    end
end

