function plotregraspgraph(dg, regraspgraph, varargin)
% plot the regraspgraph
% 
% input
% ----
% - dg - the directed graph to be used for graph search
% - regraspgraph - a structure including connect pairs
% see the regraspgraph.m file for the details of the previous two
% parameters
% - varargin - varargin{1}==1 plot 1st layer; varargin{2}==1 2nd layer
%
% author: Weiwei
% date: 20160310

    if nargin == 3 && varargin{1} == 1
        figure;
        plot(dg,'Layout','force');
        return
    end
    
    if nargin == 4 && varargin{1} == 1 && varargin{2} == 1
        figure;
        graspnodehinterval = 0.05;
        nstates = height(dg.Nodes);
        circleangles = linspace(0,2*pi, nstates-1)';
        statepos = [[3;-3;cos(circleangles)], [0;0;sin(circleangles)]];
%         for i = 1:size(statepos,1)
%             if i == 1
%                 plot3([statepos(i, 1);statepos(i, 1)],...
%                     [statepos(i, 2);statepos(i, 2)],...
%                     [0;8], 'linewidth', 15, 'color', [1,0.3,0.3, 0.3]);
%                 hold on;
%                 axis equal;
%                 axis vis3d;
%             end
%             if i == 2
%                 plot3([statepos(i, 1);statepos(i, 1)],...
%                     [statepos(i, 2);statepos(i, 2)],...
%                     [0;8], 'linewidth', 15, 'color', [0.3,0.3,1, 0.3]);
%             end
%             if i > 2
%                 plot3([statepos(i, 1);statepos(i, 1)],...
%                     [statepos(i, 2);statepos(i, 2)],...
%                     [0;8], 'linewidth', 15, 'color', [0.3,0.3,0.3, 0.3]);
%             end
%         end
        nedges = size(regraspgraph.connectpairs, 1);
        for i = 1:nedges
            inode1 = regraspgraph.connectpairs(i, 1);
            inode2 = regraspgraph.connectpairs(i, 2);
            igraspids = regraspgraph.connectedges{i};
            ngs = size(igraspids, 1);
            % plot nodes
            if inode1 == 1
                globalgid = regraspgraph.states{inode1}.ikprggrp(2).graspparamids(igraspids(:,1));
                plot3(repmat(statepos(inode1, 1), ngs, 1), ...
                    repmat(statepos(inode1, 2), ngs, 1), ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'r');
                hold on;
                axis equal;
                axis vis3d;
            end
            if inode2 == 1
                globalgid = regraspgraph.states{inode2}.ikprggrp(2).graspparamids(igraspids(:,2));
                plot3(repmat(statepos(inode2, 1), ngs, 1), ...
                    repmat(statepos(inode2, 2), ngs, 1), ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'r');
            end
            if inode1 == 2
                globalgid = regraspgraph.states{inode1}.ikprggrp(2).graspparamids(igraspids(:,1));
                plot3(repmat(statepos(inode1, 1), ngs, 1), ...
                    repmat(statepos(inode1, 2), ngs, 1), ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'b');
            end
            if inode2 == 2
                globalgid = regraspgraph.states{inode2}.ikprggrp(2).graspparamids(igraspids(:,2));
                plot3(repmat(statepos(inode2, 1), ngs, 1), ...
                    repmat(statepos(inode2, 2), ngs, 1),  ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'b');
            end
            if inode1 > 2
                globalgid = regraspgraph.states{inode1}.ikprggrp(2).graspparamids(igraspids(:,1));
                plot3(repmat(statepos(inode1, 1), ngs, 1), ...
                    repmat(statepos(inode1, 2), ngs, 1), ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'y');
            end
            if inode2 > 2
                globalgid = regraspgraph.states{inode2}.ikprggrp(2).graspparamids(igraspids(:,2));
                plot3(repmat(statepos(inode2, 1), ngs, 1), ...
                    repmat(statepos(inode2, 2), ngs, 1), ...
                    graspnodehinterval*globalgid, ....
                    'o', 'markersize', 5, 'markeredgecolor', 'k', 'markerfacecolor', 'y');
            end
            % plot edges
            for j = 1:ngs
%                 if inode1 == 4 && inode2 == 8
                    globalgid1 = regraspgraph.states{inode1}.ikprggrp(2).graspparamids(igraspids(j,1));
                    globalgid2 = regraspgraph.states{inode2}.ikprggrp(2).graspparamids(igraspids(j,2));
                    plot3([statepos(inode1, 1);statepos(inode2, 1)], ...
                        [statepos(inode1, 2);statepos(inode2, 2)], ...
                        [graspnodehinterval*globalgid1; graspnodehinterval*globalgid2], ....
                        '-', 'color', [0.7, 0.7, 0.7]);
%                 end
            end
            set(gcf,'color','white');
            axis off;
        end
    end

end