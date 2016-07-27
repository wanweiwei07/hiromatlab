function plotinterstatesobjpcds(interstates, varargin)
% plot the objpointclouds of intermediate states
% interstates could be a single intermediate states or a list of them
%
% input
% ----
% - interstates - the intermediate states
% - varargin - varargin{1} is point cloud color
%
% author: Weiwei
% date: 20160304

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
        plotobjcolor = [0.7, 0.7, 0.7];
        if nargin == 2
            plotobjcolor = varargin{1};
        end
        plot3(thisinter.stablemesh.pcd(:,1), thisinter.stablemesh.pcd(:,2),...
            thisinter.stablemesh.pcd(:,3), '.', 'color', plotobjcolor);
        hold on;
        view([50, 20]);
        axis equal;
        axis([thisinter.placementp(1)-0.25, thisinter.placementp(1)+0.25,...
            thisinter.placementp(2)-0.25, thisinter.placementp(2)+0.25,...
            thisinter.placementp(3)-0.25, thisinter.placementp(3)+0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
    end
    
end

