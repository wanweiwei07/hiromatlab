function plotactiveobj(interstate, varargin)
% plot the object that is being manipulated
%
% input
% --
% - placement - a data structure the same as the one used in calcgrasp
% - varargin - varargin{1} color, varargin{2} cla, varargin{3}, plot
% grasps, varargin{4}, grasp color
%
% author: Weiwei
% 20180219

    global fhdl;
    figure(fhdl);
    global subrow;
    global subcol;
    global mainrowcol;
    subplot(subrow, subcol, mainrowcol);
    global mainaxlimits;
    global mainview;
    color = [0.9, 0.9, 0.9];
    graspcolor = [0.3, 0.5, 0.3];
    if nargin > 1
        color = varargin{1};
    end
    if nargin > 2 && varargin{2} == 1
        cla;
    end
    
    nfaces = size(interstate.stablemesh.faces,1);
%     for j = 1:nfaces
        patch('vertices', interstate.stablemesh.verts,...
            'faces', interstate.stablemesh.faces,...
            'facecolor',color,'edgecolor', 'none');
        hold on;
        axis equal;
        set(gcf,'color','white');
        axis(mainaxlimits);
        view(mainview);
        xlabel('x');
        ylabel('y');   
        axis vis3d;
        axis off;
%     end
    delete(findall(gca, 'Type', 'light'));
    light('Position',[-10 -10 10]);
    light('Position',[-10 -10 -10]);
    light('Position',[-10 10 10]);
    light('Position',[-10 10 -10]);
%         light('Position',[10 10 10]);
    light('Position',[10 10 -10]);
    light('Position',[10 -10 -10]);
%         light('Position',[10 -10 10]);
    if nargin > 3 && varargin{3} == 1
        % plot grasps
        if nargin > 4
            graspcolor = varargin{4};
        end
        for k = 1:size(interstate.graspparams,1)
            plot3([interstate.graspparams(k).fgrcenter(1,:);interstate.graspparams(k).tcp(1,:)],...
                [interstate.graspparams(k).fgrcenter(2,:);interstate.graspparams(k).tcp(2,:)],...
                [interstate.graspparams(k).fgrcenter(3,:);interstate.graspparams(k).tcp(3,:)],...
                'linestyle','-','linewidth',2,'color',graspcolor);
        end
    end
end

