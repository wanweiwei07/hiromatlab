function [isstable, quality] = checkassemstabilitypcd_gspqlty(basepcd, ...
    basepcdnormals, obj2interstate, otlpcd, otlpcdnormals)
% check the stability of the assembled structure using grasp quality as the
% measurement
%
% input
% ---------
% - basepcd - n-by-3 array, all pcd from the base
% - basepcdnormals - n-by-3 array, the correspondent normals of those basepcd
% - obj2interstate - the moved intermediate state of obj2, this one is
% going to be assembled to the baseinterstates
% - otlpcd - n-by-3 array, all pcd from the obstacles
% - otlpcdnormals - n-by-3 array, the correspondent normals of those otlpcd
%
% output
% ---------
% - isstable - whether the structure is stable or not
% - quality - the quality of stability
    
    checkpcd = cat(1, basepcd, otlpcd);
    checkpcdnormals = cat(1, basepcdnormals, otlpcdnormals);
    
    incheckpcdo2 = inpolyhedron(obj2interstate.stablemesh.faces, ...
        obj2interstate.stablemesh.verts, checkpcd);

    if(sum(incheckpcdo2)) 
        incheckpcd = checkpcd(incheckpcdo2, :);
        incheckpcdnormals = checkpcdnormals(incheckpcdo2, :);
        nincheckpnts = size(incheckpcd, 1);
        [assemnormals, ~] = unique(incheckpcdnormals, 'rows');
        nassemnormals = size(assemnormals, 1);
        % the points at each touch (indicated by touch pcds)
        touchpcds = cell(nassemnormals, 1);
        touchpcdsnormals = cell(nassemnormals, 1);
        for i = 1:nassemnormals
            normal = assemnormals(i, :);
            normangles = dot(incheckpcdnormals, repmat(normal, nincheckpnts, 1), 2);
            touchpcds{i} = incheckpcd(normangles>0.9, :);
            touchpcdsnormals{i} = incheckpcdnormals(normangles>0.9, :);
        end
    end 
    
    ntouch = size(touchpcds, 1);
    rotnum = 8;
    rot = linspace(0, 2*pi, rotnum+1);
    rot = rot(1:rotnum);
    touchpnts = zeros(ntouch*rotnum, 3);
    touchforce = zeros(ntouch*rotnum, 3);
    touchtorque = zeros(ntouch*rotnum, 3);
    fe = 0.2;
    for i = 1:ntouch
        touchpcd = touchpcds{i};
        ntouchpcd = size(touchpcds{i}, 1);
        touchnormal = touchpcdsnormals{i}(1,:);
        vref = normr(touchpcd(1,:)-touchpcd(end,:));
        for j = 1:rotnum
            vrefrot = (rodrigues(touchnormal, rot(j))*vref')';
            pcdangles = dot(touchpcd, repmat(vrefrot, ntouchpcd, 1), 2);
            [~, maxp] = max(pcdangles);
            touchforce((i-1)*rotnum+j, :) = normr(touchnormal+fe*vrefrot);
            touchtorque((i-1)*rotnum+j, :) = normr(cross(...
                touchforce((i-1)*rotnum+j, :), touchpcd(maxp,:)));
            touchpnts((i-1)*rotnum+j, :) = touchpcd(maxp,:);
        end
    end
   
    gravity = normr([0,0,-1]);
    gravitytorque = normr(cross(gravity, obj2interstate.placementp'));
    wrenches = normr([touchforce, touchtorque; gravity, gravitytorque]);
    allforce = [gravity; touchforce];
    alltorque = [touchtorque; gravitytorque];
    [isstablef, qualitylistf] = computegraspquality3d(allforce);
    [isstablet, qualitylistt] = computegraspquality3d(alltorque);
    quality = computegraspquality(wrenches);
    disp(quality);
    isstable = false;
    if quality > 0.2
        isstable = true;
    end
    
    % plot the pcd and pcdnormals
    figure;
    quiver3scale = 0.1;
    plotinterstates(obj2interstate, 'none', 'c', 'none', .3);
    quiver3(obj2interstate.placementp(1), obj2interstate.placementp(2), ...
        obj2interstate.placementp(3), ...
        gravity(1,1)*quiver3scale, gravity(1,2)*quiver3scale,...
        gravity(1,3)*quiver3scale, ...
        'color', 'g', 'linewidth', 3, 'autoscale', 'off');
    hold on;
    cmap = colormap('lines');
    for i = 1:ntouch
        plotcolor = cmap(mod(i, 64)+1, :);
        touchpcd = touchpcds{i};
        touchpcdnormal = touchpcdsnormals{i};
        % plot3(touchpcd(:,1), touchpcd(:,2), touchpcd(:,3), '.', 'color', plotcolor);
        plot3(touchpnts((i-1)*rotnum+1:i*rotnum,1),...
            touchpnts((i-1)*rotnum+1:i*rotnum,2),...
            touchpnts((i-1)*rotnum+1:i*rotnum,3), '.', 'color', ...
            plotcolor, 'markersize', 10);
        hold on;
        quiver3(touchpnts((i-1)*rotnum+1:i*rotnum,1),...
            touchpnts((i-1)*rotnum+1:i*rotnum,2),...
            touchpnts((i-1)*rotnum+1:i*rotnum,3),...
            touchforce((i-1)*rotnum+1:i*rotnum,1)*quiver3scale,...
            touchforce((i-1)*rotnum+1:i*rotnum,2)*quiver3scale,...
            touchforce((i-1)*rotnum+1:i*rotnum,3)*quiver3scale,...
            'color', plotcolor, 'linewidth', 3, 'autoscale', 'off');
%         quiver3(touchpcd(:,1), touchpcd(:,2), touchpcd(:,3), ...
%             touchpcdnormal(:,1)*quiver3scale,...
%             touchpcdnormal(:,2)*quiver3scale,...
%             touchpcdnormal(:,3)*quiver3scale, ...
%             'color', plotcolor, 'autoscale', 'off');
        hold on;
        view([50, 20]);
        axis equal;
        set(gcf,'color','white');
        axis([obj2interstate.placementp(1)-0.25, obj2interstate.placementp(1)+0.25,...
            obj2interstate.placementp(2)-0.25, obj2interstate.placementp(2)+0.25,...
            obj2interstate.placementp(3)-0.25, obj2interstate.placementp(3)+0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
        axis off;
    end
    
    
end

