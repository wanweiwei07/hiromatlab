function [placementdetected, pos, rot] = findpstempless(xyzpoints, placements, isplot)
% find the object in the point cloud using placements and icp
% pltemplate is computed inside the function
%
% input
% ----
% - xyzpoints - a matrix with each row denoting the position of one point
% - placements - the placements cells computed using the primitive/grip
% package
%
% output
% ----
% - placementdetected - an interstate structure defined in the
% primitive/grip package; it is transformed
% - pos - the translation vector of the object, 3-by-1 vector
% - rot - the rotation matrix of the object, 3-by-3 mat
% - isplot - do we plot or not inside the function
%
% note
% ----
% generate template is integrated in this func
%
% author: Weiwei
% date: 20160419

    controlplot = 0;
    if nargin == 3
        controlplot = isplot;
    end

    % gentemplate
    npltemp = size(placements,1);
    pltemplate = cell(npltemp, 1);
    if controlplot
        figure;
    end
    for i = 1:npltemp
        pltemplate{i}.pcd = cvtpcd(placements{i}.stablemesh.verts, ...
            placements{i}.stablemesh.faces, 100000);
        pltemplate{i}.pcd = pltemplate{i}.pcd(...
            pltemplate{i}.pcd(:,3) > 0.02,:);
        if controlplot
            subplot(2,npltemp/2, i);
            plot3(pltemplate{i}.pcd(:,1), pltemplate{i}.pcd(:,2), pltemplate{i}.pcd(:,3), '.r');
            hold on;
            view([50, 20]);
            axis equal;
            set(gcf,'color','white');
            axis([placements{i}.placementp(1)-0.25, placements{i}.placementp(1)+0.25,...
                placements{i}.placementp(2)-0.25, placements{i}.placementp(2)+0.25,...
                placements{i}.placementp(3)-0.25, placements{i}.placementp(3)+0.25]);
            axis vis3d;
            xlabel('x');
            ylabel('y');
            axis off;
        end
    end

    clusteredpcid = clusterdata(xyzpoints, 'criterion', 'distance', 'cutoff', 0.015);
    ncluster = max(max(clusteredpcid));
    clusters = cell(ncluster, 1);
    
    cmap = colormap('lines');
    for i = 1:ncluster
        clusters{i} = xyzpoints(find(clusteredpcid==i), :);
        if controlplot
            figure;
            plot3(clusters{i}(:,1), clusters{i}(:,2), clusters{i}(:,3), '.', 'color', cmap(i,:));
            hold on;
            axis equal;
            axis off;
            set(gcf,'color','w');
        end
    end
    
    ntemp = npltemp;
    nseg = ncluster;
    tform = cell(ntemp, ncluster);
    movingReg = cell(ntemp, ncluster);
    rmse = zeros(ntemp, nseg);
    for i = 1:ncluster
        observedPC = pointCloud(clusters{i});
        for j = 1:ntemp
            templatePC = pointCloud(pltemplate{j}.pcd);
            [tformtmp, movingRegtmp, rmsetmp] = pcregrigid(templatePC, observedPC, 'MaxIterations', 200, 'Tolerance', [0.001, 0.0001]);
%            [tformtmp, movingRegtmp, rmsetmp] = pcregrigid(templatePC, observedPC);
            tform{j, i} = tformtmp;
            movingReg{j, i} = movingRegtmp.Location;
            rmse(j, i) = rmsetmp;
        end
    end

    [mintemp, mintempind] = min(rmse);
    [minseg, minsegind] = min(mintemp);
    mintempind = mintempind(minsegind);
    macthedPoints = movingReg{mintempind, minsegind};
    if controlplot
        plot3(macthedPoints(:,1), macthedPoints(:,2), macthedPoints(:,3), '.', 'color', cmap(nseg+1, :));
    end
    
    tformmat = tform{mintempind, minsegind};
    placementdetected = moveinterstate(placements{mintempind}, tformmat.T(4,1:3)', tformmat.T(1:3,1:3)');
    if controlplot
        plotinterstates(placementdetected, 'r', 'none');
    end
end

