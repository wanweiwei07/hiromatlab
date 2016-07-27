function plotinterstates(interstates, varargin)
% plot the intermediate states
% interstates could be a single intermediate states or a list of them
%
% input
% ----
% - interstates - the intermediate states
% - varargin - varargin{1} is grasp color; varargin{2} is obj color;
% varargin{3} is the edge color (sometimes you want to emphasize an object)
% if the interstates have grasps, it will be plotted using colormap
% if the interstates dont have grasps, it will be ploted using
% [0.7,0.7,0.7]
% if varargin{2} exists, it will be ploted using varargin{2}
% varargin{4} is face transparency
%
% author: Weiwei
% date: 20160224

    cmap = colormap('lines');
    plotgrspcolor = 'none';
    if nargin >= 2
        plotgrspcolor = varargin{1};
    end

    % plot the object
    ninterstates = size(interstates, 1);
    for i = 1:ninterstates
        if ninterstates > 1
            subplot(3, ceil(ninterstates/3), i);
        end
        thisinter = interstates;
        if ninterstates > 1
            thisinter = interstates{i};
        end
        % plot with simlifiedfaces
        % commented by weiwei 20160524
%         nfaces = size(thisinter.stablemesh.simplifiedfaces,1);
%         for j = 1:nfaces
%             plotobjcolor = cmap(mod(j, 64)+1, :);
%             if isempty(thisinter.graspparams)
%                 plotobjcolor = [0.7, 0.7, 0.7];
%             end
%             if nargin == 3
%                 plotobjcolor = varargin{2};
%             end
%             patch('vertices', thisinter.stablemesh.simplifiedverts,...
%                 'faces', thisinter.stablemesh.simplifiedfaces{j},...
%                 'facecolor',plotobjcolor, 'edgecolor', 'none');
%             hold on;
%             view([50, 20]);
%             axis equal;
%             set(gcf,'color','white');
%             axis([thisinter.placementp(1)-0.25, thisinter.placementp(1)+0.25,...
%                 thisinter.placementp(2)-0.25, thisinter.placementp(2)+0.25,...
%                 thisinter.placementp(3)-0.25, thisinter.placementp(3)+0.25]);
%             axis vis3d;
%             xlabel('x');
%             ylabel('y');
%             axis off;
%         end
        % new plot with original faces
        nfaces = size(thisinter.stablemesh.faces,1);
%         plotobjcolor = cmap(ceil(rand*64), :);
        plotobjcolor = [0.3, 0.5, 0.3];
        plotedgecolor = 'none';
        plotfacealpha = 1;
        for j = 1:nfaces
            if isempty(thisinter.graspparams)
                plotobjcolor = [0.7, 0.7, 0.7];
            end
            if nargin >= 3
                plotobjcolor = varargin{2};
            end
            if nargin >= 4
                plotedgecolor = varargin{3};
            end
            if nargin >= 5
                plotfacealpha = varargin{4};
            end
            patch('vertices', thisinter.stablemesh.verts,...
                'faces', thisinter.stablemesh.faces(j,:),...
                'facecolor',plotobjcolor, 'edgecolor', plotedgecolor,...
                'facealpha',plotfacealpha, 'ambientstrength', 1);
            hold on;
            material dull;
            view([50, 20]);
            axis equal;
            set(gcf,'color','white');
            axis([thisinter.placementp(1)-1.25, thisinter.placementp(1)+1.25,...
                thisinter.placementp(2)-1.25, thisinter.placementp(2)+1.25,...
                thisinter.placementp(3)-1.25, thisinter.placementp(3)+1.25]);
            axis vis3d;
            xlabel('x');
            ylabel('y');
            axis off;
%             view(200, 30);
        end
%         plotstandardaxis([0;0;0], 3);
        delete(findall(gca, 'Type', 'light'));
        light('Position',[-10 -10 10]);
        light('Position',[-10 -10 -10]);
        light('Position',[-10 10 10]);
        light('Position',[-10 10 -10]);
%         light('Position',[10 10 10]);
        light('Position',[10 10 -10]);
        light('Position',[10 -10 -10]);
%         light('Position',[10 -10 10]);
        % plot the grasps
        if(~strcmp(plotgrspcolor,'none'))
%             for k = 1:ceil(size(thisinter.graspparams,1)/4):size(thisinter.graspparams,1)
            for k = 1:size(thisinter.graspparams,1)
                plot3([thisinter.graspparams(k).fgrcenter(1,:);thisinter.graspparams(k).tcp(1,:)],...
                    [thisinter.graspparams(k).fgrcenter(2,:);thisinter.graspparams(k).tcp(2,:)],...
                    [thisinter.graspparams(k).fgrcenter(3,:);thisinter.graspparams(k).tcp(3,:)],...
                    'linestyle','-','linewidth',2,'color',plotgrspcolor);
%                 
%                 quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2),...
%                     thisinter.graspparams(k).tcp(3), ...
%                     thisinter.graspparams(k).handx(1)*0.1, thisinter.graspparams(k).handx(2)*0.1, ...
%                     thisinter.graspparams(k).handx(3)*0.1, 'color', 'r', 'autoscale', 'off');
%                 quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2), ...
%                     thisinter.graspparams(k).tcp(3), ...
%                     thisinter.graspparams(k).handy(1)*0.1, thisinter.graspparams(k).handy(2)*0.1, ...
%                     thisinter.graspparams(k).handy(3)*0.1, 'color', 'g', 'autoscale', 'off');
%                 quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2),...
%                     thisinter.graspparams(k).tcp(3), ...
%                     thisinter.graspparams(k).handz(1)*0.1, thisinter.graspparams(k).handz(2)*0.1, ...
%                     thisinter.graspparams(k).handz(3)*0.1, 'color', 'b', 'autoscale', 'off');
            end
        end
        % plot the hand meshes
%         k = 100;
%         plotrqt85(thisinter.graspparams(k).tcp', [-thisinter.graspparams(k).handx, -thisinter.graspparams(k).handy, thisinter.graspparams(k).handz], ...
%             70, 0.001, [0.1,0.1,0.1]);
%         patch('Faces', thisinter.graspparams(k).f3palm, 'Vertices', thisinter.graspparams(k).vertpalm, ...
%             'edgecolor', 'none', 'AmbientStrength', 1);
%         patch('Faces', thisinter.graspparams(k).f3fgr1, 'Vertices', thisinter.graspparams(k).vertfgr1, ...
%             'edgecolor', 'none', 'AmbientStrength', 1);
%         patch('Faces', thisinter.graspparams(k).f3fgr2, 'Vertices', thisinter.graspparams(k).vertfgr2, ...
%             'edgecolor', 'none', 'AmbientStrength', 1);
%         plot3([thisinter.graspparams(k).fgrcenter(1,:);thisinter.graspparams(k).tcp(1,:)],...
%             [thisinter.graspparams(k).fgrcenter(2,:);thisinter.graspparams(k).tcp(2,:)],...
%             [thisinter.graspparams(k).fgrcenter(3,:);thisinter.graspparams(k).tcp(3,:)],...
%             'linestyle','-','linewidth',2,'color',[0.3,0.5,0.3]);
%         quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2),...
%             thisinter.graspparams(k).tcp(3), ...
%             thisinter.graspparams(k).handx(1)*0.1, thisinter.graspparams(k).handx(2)*0.1, ...
%             thisinter.graspparams(k).handx(3)*0.1, 'color', 'r', 'autoscale', 'off');
%         quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2), ...
%             thisinter.graspparams(k).tcp(3), ...
%             thisinter.graspparams(k).handy(1)*0.1, thisinter.graspparams(k).handy(2)*0.1, ...
%             thisinter.graspparams(k).handy(3)*0.1, 'color', 'g', 'autoscale', 'off');
%         quiver3(thisinter.graspparams(k).tcp(1),thisinter.graspparams(k).tcp(2),...
%             thisinter.graspparams(k).tcp(3), ...
%             thisinter.graspparams(k).handz(1)*0.1, thisinter.graspparams(k).handz(2)*0.1, ...
%             thisinter.graspparams(k).handz(3)*0.1, 'color', 'b', 'autoscale', 'off');
    end
    
end

