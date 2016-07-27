% a = [0,0.1,0];
% b = [0.1,0,0];
% c = [0,0,0.1];
% d = [0,0,0];
% vectors = [a; b; c; d];
% faces = convhull(vectors);

patch('vertices', ancverts, 'faces', ancfaces, ...
    'facecolor', [0.3, 0.4, 0.6], 'edgecolor', 'k');

hold on;
material dull;
view([50, 20]);
axis equal;
set(gcf,'color','white');
axis([-0.25, +0.25,...
    -0.25, +0.25,...
    -0.25, +0.25]);
axis vis3d;
xlabel('x');
ylabel('y');
axis off;
light('Position',[-1 -1 0.5]);
light('Position',[-1 1 -0.1]);
light('Position',[1 -1 -0.5]);
plotstandardaxis([0;0;0]);