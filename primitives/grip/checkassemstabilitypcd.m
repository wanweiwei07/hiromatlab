function [isstable, quality, supportpolygon] = checkassemstabilitypcd(basepcd, ...
    basepcdnormals, obj2interstate, otlpcd, otlpcdnormals)
% check the stability of the assembled structure using projection as the
% measurement. The boundary of surpporting area is considered 
%
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
% - supportpolygon - n-by-2, the support polygon
    
    checkpcd = cat(1, basepcd, otlpcd);
    checkpcdnormals = cat(1, basepcdnormals, otlpcdnormals);
    
    incheckpcdo2 = inpolyhedron(obj2interstate.stablemesh.faces, ...
        obj2interstate.stablemesh.verts, checkpcd);

    touchpcds = [];
    touchpcdsnormals = [];
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
    
    fe = 0.2;
    ntouch = size(touchpcds, 1);
    touchprojsize = zeros(ntouch, 1);
    touchprojpolygons = cell(ntouch, 1);
    touchprojpnts = [];
    touchprojpntshgt = [];
    gravity = [0, 0, -1];
    for i = 1:ntouch
        touchpcd = touchpcds{i};
        touchnormal = touchpcdsnormals{i}(1,:);
        touchpcdgravityangle = dot(touchnormal, gravity);
        if touchpcdgravityangle < 0.1
            touchpcdproj = touchpcd(:,1:2);
            touchpcdhgt = touchpcd(:,3);
            touchprojpnts = cat(1, touchprojpnts, touchpcdproj);
            touchprojpntshgt = cat(1, touchprojpntshgt, touchpcdhgt);
            x = touchpcdproj(:,1);
            y = touchpcdproj(:,2);
            if touchpcdgravityangle > -fe
                touchprojsize(i) = 0.001;
                touchprojpolygons{i} = [];
            else
                k = convhull(x, y);
                touchprojsize(i) = polygonArea([x(k), y(k)]);
                touchprojpolygons{i} = [x(k), y(k)];
            end
        end
    end
    
    comdist = 0;
    comhgt = 0;
    obj2com = obj2interstate.placementp(1:2)';
    x = touchprojpnts(:,1);
    y = touchprojpnts(:,2);
    z = touchprojpntshgt(:);
    try
        k = convhull(x, y);
    catch
        k = 0;
    end
    if k~=0
        supportpolygon = [x(k), y(k)];
        supportpolygonhgt = z(k);
        [pos, comdist] = projPointOnPolygon(obj2com, supportpolygon);
        heightstart = supportpolygonhgt(floor(pos)+1);
        heightgoal = supportpolygonhgt(ceil(pos)+1);
        ratio = ceil(pos)-pos;
        comhgt = heightstart*ratio+heightgoal*(1-ratio);
            % see if pos is a vert
%         [lia, locb] = ismember(pos, supportpolygon, 'rows')
%         if lia
%             comhgt = supportpolygonhgt(locb);
%         else
%             % see which segment is the pos on
%             nspvert = size(supportpolygon, 1);
%             idstart = linspace(1, nspvert, nspvert);
%             idend = [idstart(2:end), idstart(1)];
%             vstart = supportpolygon(idstart,:);
%             vend = supportpolygon(idend,:);
%             posallseg = repmat(pos, nspvert, 1);
%             segid=find(~cross(posallseg-vstart, posallseg-vend, 2))
%             comhgt = (supportpolygonhgt(idstart(segid))+supportpolygonhgt(idend(segid)))/2;
%         end
    else
        supportpolygon = [];
        comdist = 0;
    end
    isstable = 0;
    quality = 0;
    if comdist < 0
        isstable = 1;
        %quality = sum(touchprojsize)*(-comdist);
        quality = comhgt*(-comdist);
    end
    
   
    % plot the projected points
    %{
    figure;
    quiver3scale = 0.01;
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
        plot3(touchpcd(:,1),...
            touchpcd(:,2),...
            touchpcd(:,3), '.', 'color', ...
            plotcolor, 'markersize', 10);
        hold on;
        quiver3(touchpcd(:,1),...
            touchpcd(:,2),...
            touchpcd(:,3),...
            touchpcdnormal(:,1)*quiver3scale,...
            touchpcdnormal(:,2)*quiver3scale,...
            touchpcdnormal(:,3)*quiver3scale,...
            'color', plotcolor, 'linewidth', 3, 'autoscale', 'off');
        hold on;
        touchprojpolygon = touchprojpolygons{i};
        if ~isempty(touchprojpolygon)
            plot(touchprojpolygon(:,1),...
                touchprojpolygon(:,2), '.-', 'color', ...
                plotcolor, 'markersize', 10, 'linewidth', 3);
        end
        if ~isempty(supportpolygon)
            plot(supportpolygon(:,1),...
                supportpolygon(:,2), '.-', 'color', ...
                'k', 'markersize', 10, 'linewidth', 3);
        end
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
    %}
    
end

