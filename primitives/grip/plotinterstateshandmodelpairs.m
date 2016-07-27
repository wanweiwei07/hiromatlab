function plotinterstateshandmodelpairs(interstate1, interstate2, dualgp, varargin)
% plot the pairs of dualarm grasps
%
% input
% ----
% - interstate1 - the intermediate state of the first object
% - interstate2 - the intermediate state of the second object
% - dualgp - dualgp is the list of hand index pairs from interstate1 and
% interstate2
% - varargin{1}, varargin{2} the color of the two handmodels in the pair
%
% author: Weiwei
% date: 20160307

    cmap = colormap('lines');
    % plot the object
    ndualgp = size(dualgp, 1);
    for i = 1:ndualgp
        cla;
        ploth1color = cmap(mod(i, 64)+1, :);
        ploth2color = cmap(mod(i, 64)+1, :);
        if nargin == 4
            ploth1color = varargin{1};
        end
        if nargin == 5
            ploth1color = varargin{1};
            ploth2color = varargin{2};
        end
        indxh1 = dualgp(i, 1);
        h1vp = interstate1.graspparams(indxh1).vertpalm;
        h1f3p = interstate1.graspparams(indxh1).f3palm;
        h1vf1 = interstate1.graspparams(indxh1).vertfgr1;
        h1f3f1 = interstate1.graspparams(indxh1).f3fgr1;
        h1vf2 = interstate1.graspparams(indxh1).vertfgr2;
        h1f3f2 = interstate1.graspparams(indxh1).f3fgr2;
        indxh2 = dualgp(i, 2);
        h2vp = interstate2.graspparams(indxh2).vertpalm;
        h2f3p = interstate2.graspparams(indxh2).f3palm;
        h2vf1 = interstate2.graspparams(indxh2).vertfgr1;
        h2f3f1 = interstate2.graspparams(indxh2).f3fgr1;
        h2vf2 = interstate2.graspparams(indxh2).vertfgr2;
        h2f3f2 = interstate2.graspparams(indxh2).f3fgr2;
        
        drawMesh(h1vp, h1f3p, 'facecolor', ploth1color, 'facealpha', 0.4);
        drawMesh(h1vf1, h1f3f1, 'facecolor', ploth1color, 'facealpha', 0.4);
        drawMesh(h1vf2, h1f3f2, 'facecolor', ploth1color, 'facealpha', 0.4);
        
        drawMesh(h2vp, h2f3p, 'facecolor', ploth2color, 'facealpha', 0.4);
        drawMesh(h2vf1, h2f3f1, 'facecolor', ploth2color, 'facealpha', 0.4);
        drawMesh(h2vf2, h2f3f2, 'facecolor', ploth2color, 'facealpha', 0.4);

        hold on;
        view([50, 20]);
        axis equal;
        axis([interstate1.placementp(1)-0.25, interstate1.placementp(1)+0.25,...
            interstate1.placementp(2)-0.25, interstate1.placementp(2)+0.25,...
            interstate1.placementp(3)-0.25, interstate1.placementp(3)+0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
        plotinterstatesobjmodels(interstate1);
        plotinterstatesobjmodels(interstate2);
        drawnow;
        pause(1);
    end
    
end

