function plotgraphps(graphps)
% plot the placements in the graph
% the first two are start and end, the others are intermediate state
%
% input
% ----
% - graphps - the placements in the graph
%
% author: Weiwei
% date: 20160222

    ngps = size(graphps, 1);
    for i = 1:ngps
        subplot(3, ceil(ngps/3), i);
        cmap = colormap('lines');
        nfaces = size(graphps{i}.stablemesh.simplifiedfaces,1);
        for j = 1:nfaces
            patch('vertices', graphps{i}.stablemesh.simplifiedverts,...
                'faces', graphps{i}.stablemesh.simplifiedfaces{j},...
                'facecolor',cmap(mod(j, 64)+1, :));
            hold on;
            view([50, 20]);
            axis equal;
            axis([graphps{i}.placementp(1)-0.25, graphps{i}.placementp(1)+0.25,...
                graphps{i}.placementp(2)-0.25, graphps{i}.placementp(2)+0.25,...
                graphps{i}.placementp(3)-0.25, graphps{i}.placementp(3)+0.25]);
            axis vis3d;
            xlabel('x');
            ylabel('y');
        end
        for k = 1:size(graphps{i}.graspparams,1)
            plot3([graphps{i}.graspparams(k).fgrcenter(1,:);graphps{i}.graspparams(k).tcp(1,:)],...
                [graphps{i}.graspparams(k).fgrcenter(2,:);graphps{i}.graspparams(k).tcp(2,:)],...
                [graphps{i}.graspparams(k).fgrcenter(3,:);graphps{i}.graspparams(k).tcp(3,:)],...
                'linestyle','-','linewidth',2,'color','g');
        end
    end
    
end

