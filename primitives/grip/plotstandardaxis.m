function plotstandardaxis(posorigin, scale)
% plot the standard axis where x = [1,0,0] y = [0,1,0] z = [0,0,1]
%
% input
% ----
% - posorigin - the position of the origin
% - scale - the value of scaling, default is 1
%
% author: Weiwei
% date: 20160524

    if nargin == 1
        scale = 0.3;
    end

    x = [1;0;0]*scale;
    y = [0;1;0]*scale;
    z = [0;0;1]*scale;
    quiver3(posorigin(1), posorigin(2), posorigin(3), ...
        x(1), x(2), x(3), ...
        'color', 'red');
    hold on;
    view([50, 20]);
    axis equal;
    set(gcf,'color','white');
    axis vis3d;
    axis off;
    quiver3(posorigin(1), posorigin(2), posorigin(3), ...
        y(1), y(2), y(3), ...
        'color', 'green');
    quiver3(posorigin(1), posorigin(2), posorigin(3), ...
        z(1), z(2), z(3), ...
        'color', 'blue');

end

