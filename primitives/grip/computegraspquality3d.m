function [isstable, qualitylist] = computegraspquality3d(vec3dlist)
% compute the quality of a closure formed by the vec3dlist
% the quality is the smallest angle between a vec3 and its adjacent faces
% 
% input
% -------
% - vec3dlist - n-by-3 matrix, each row indicates one vec, it is 3d;
%   by default the first row is gravity or gravity torque
% 
% output
% -------
% - isstable - the stability of the closure
% - qualitylist - a list of scalars, each element is the smallest angle
% between a vec3 and its adjacent faces
%
% date: 20160527
% author: weiwei

    isstable = 0;
    qualitylist = [];

    ancverts = [vec3dlist; zeros(1, 3)];
    ancfaces = convhull(ancverts, 'simplify', true);
    ancfacenormals = computefacenormal(ancverts, ancfaces);
    ovnormangles1 = dot(ancverts(ancfaces(:,1), :), ancfacenormals, 2);
    ovnormangles2 = dot(ancverts(ancfaces(:,2), :), ancfacenormals, 2);
    ovnormangles3 = dot(ancverts(ancfaces(:,3), :), ancfacenormals, 2);
    ovnormangles = [ovnormangles1; ovnormangles2; ovnormangles3];
    
    figure;
    % Visualize the convexhull
    patch('vertices', ancverts, 'faces', ancfaces, ...
        'facecolor', 'g', ...
        'facealpha', .7, 'edgecolor', 'none');
    hold on;
    for i = 1:size(ancfaces, 1)
        facecenter = mean(ancverts(ancfaces(i,:)', :));
        quiver3(facecenter(1), facecenter(2), facecenter(3),...
            ancfacenormals(i,1), ancfacenormals(i,2), ancfacenormals(i,3),...
            'color', 'r');
    end
    view([50, 20]);
    axis equal;
    set(gcf,'color','white');
    axis([-0.25, +0.25,...
        -0.25, +0.25,...
        -0.25, +0.25]);
    axis vis3d;
    xlabel('x');
    ylabel('y');
    axis off;
    plotstandardaxis([0;0;0]);
    delete(findall(gca, 'Type', 'light'));
    light('Position',[-1 -1 0.5]);
    light('Position',[-1 1 -0.1]);
    light('Position',[1 -1 -0.5]);
    
    disp(min(ovnormangles));
    if(all(ovnormangles > 0.01))
        % form closure
        isstable = 1;
        ovnormangleswithid = [[ancfaces(:,1);ancfaces(:,2);ancfaces(:,3)]...
            , ovnormangles, [ancfaces;ancfaces;ancfaces]];
        ovnormanglessorted = sortrows(ovnormangleswithid);
        % get the smallest
        idcolumn = ovnormanglessorted(:,1);
        tmp = idcolumn(end);
        idcolumn(2:end) = idcolumn(1:end-1);
        idcolumn(1) = tmp;
        targetitems = (ovnormanglessorted(:,1)-idcolumn)~=0;
        qualitylist = ovnormanglessorted(targetitems, 2);
        worstfacelist = ovnormanglessorted(targetitems, 3:5);
        
        % Visualize the smallest face
        quiver3(0,0,0,...
            ancverts(1,1), ancverts(1,2), ancverts(1,3),...
            'color', 'k');
        patch('vertices', ancverts, 'faces', worstfacelist(1,:), ...
            'facecolor', 'k', ...
            'facealpha', 1, 'edgecolor', 'none');
        material dull;
        hold on;
        
        return;
    end
    
end