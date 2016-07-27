function plotinterstateshandmodels(interstates, varargin)
% plot only the hand models of the intermediate states
% interstates could be a single intermediate states or a list of them
%
% input
% ----
% - interstates - the intermediate states
% - varargin - varargin{1} is the hand color
%
% author: Weiwei
% date: 20160224

    plotmodelcolor = [1, 0.7, 0.7];
    if nargin == 2
        plotmodelcolor = varargin{1};
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
        % plot the grasps
        for k = 1:size(thisinter.graspparams,1)
            drawMesh(thisinter.graspparams(k).vertpalm, thisinter.graspparams(k).f3palm, 'facecolor', plotmodelcolor, 'facealpha', 0.4);
            drawMesh(thisinter.graspparams(k).vertfgr1, thisinter.graspparams(k).f3fgr1, 'facecolor', plotmodelcolor, 'facealpha', 0.4);
            drawMesh(thisinter.graspparams(k).vertfgr2, thisinter.graspparams(k).f3fgr2, 'facecolor', plotmodelcolor, 'facealpha', 0.4);
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

