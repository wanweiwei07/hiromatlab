function plotlftarm(lftarm, varargin)
% plot hiro's leftarm with framemodels
%
% input
% -----------
% - lftarm - the data structure of robot links
% - lfthnd - the data structure of the robot gripper
% - varargin{1} - the plot color
% - varargin{2} - whether do clear axis (cla)
%
% author: Weiwei
% date: 20160218

    plotcolor = 'b';
    if nargin > 1
        plotcolor = varargin{1};
    end

    global fhdl;
    figure(fhdl);
    global subrow;
    global subcol;
    global mainrowcol;
    subplot(subrow, subcol, mainrowcol);
    global mainaxlimits;
    global mainview;
    if nargin == 3 && varargin{2} == 1
        cla;
    end
    
    i = 1;
    while i ~= 0
        pos1 = lftarm(i).p;
        pos2 = lftarm(i).ep;
%         plot3([pos1(1);pos2(1)], [pos1(2);pos2(2)], [pos1(3);pos2(3)], '-', 'linewidth', 2, 'color', plotcolor);
        if i~=7
            drawCylinder([pos1', pos2', 0.03], 'facecolor', [0.5,0.5,0.5], 'facealpha', .5);
        else
            drawCylinder([pos1', pos2', 0.02], 'facecolor', [0.2,0.5,0.2], 'facealpha', .5);
        end
        hold on;
        axis equal;
        axis vis3d;
        axis(mainaxlimits);
        view(mainview);
        xlabel('x');
        ylabel('y');    
        rotate3d off;
        i = lftarm(i).child;
    end
    
    % plot ef axis
    quiver3(lftarm(7).ep(1), lftarm(7).ep(2), lftarm(7).ep(3), lftarm(7).R(1, 1)*0.1, lftarm(7).R(2, 1)*0.1, lftarm(7).R(3, 1)*0.1, 'color', 'r');
    quiver3(lftarm(7).ep(1), lftarm(7).ep(2), lftarm(7).ep(3), lftarm(7).R(1, 2)*0.1, lftarm(7).R(2, 2)*0.1, lftarm(7).R(3, 2)*0.1, 'color', 'g');
    quiver3(lftarm(7).ep(1), lftarm(7).ep(2), lftarm(7).ep(3), lftarm(7).R(1, 3)*0.1, lftarm(7).R(2, 3)*0.1, lftarm(7).R(3, 3)*0.1, 'color', 'b');
    %drawnow;
    
end

