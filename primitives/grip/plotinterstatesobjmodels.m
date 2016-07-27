function plotinterstatesobjmodels(interstates, varargin)
% plot the objmodels of intermediate states
% interstates could be a single intermediate states or a list of them
%
% input
% ----
% - interstates - the intermediate states
% - varargin - varargin{1} is obj color
% if the interstates have grasps, it will be plotted using colormap
% if the interstates dont have grasps, it will be ploted using
% [0.7,0.7,0.7]
%
% author: Weiwei
% date: 20160304

    cmap = colormap('lines');

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
        nfaces = size(thisinter.stablemesh.simplifiedfaces,1);
        for j = 1:nfaces
            plotobjcolor = cmap(mod(j, 64)+1, :);
            if isempty(thisinter.graspparams)
                plotobjcolor = [0.7, 0.7, 0.7];
            end
            if nargin == 2
                plotobjcolor = varargin{1};
            end
            patch('vertices', thisinter.stablemesh.simplifiedverts,...
                'faces', thisinter.stablemesh.simplifiedfaces{j},...
                'facecolor',plotobjcolor);
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
    
end

