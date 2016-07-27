load data/placementsl.mat
load data/placementstri.mat

npltemp = size(placementsl,1);
pltemplate = cell(npltemp, 1);
for i = 1:npltemp
    pltemplate{i}.pcd = cvtpcd(placementsl{i}.stablemesh.verts', ...
        placementsl{i}.stablemesh.faces', 100000);
    disp(size(pltemplate{i}.pcd, 1));
    pltemplate{i}.pcd = pltemplate{i}.pcd(...
        pltemplate{i}.pcd(:,3) > 0.01,:);
    subplot(2,npltemp/2, i);
    plot3(pltemplate{i}.pcd(:,1), pltemplate{i}.pcd(:,2), pltemplate{i}.pcd(:,3), '.r');
    hold on;
    view([50, 20]);
    axis equal;
    set(gcf,'color','white');
    axis([placementsl{i}.placementp(1)-0.25, placementsl{i}.placementp(1)+0.25,...
        placementsl{i}.placementp(2)-0.25, placementsl{i}.placementp(2)+0.25,...
        placementsl{i}.placementp(3)-0.25, placementsl{i}.placementp(3)+0.25]);
    axis vis3d;
    xlabel('x');
    ylabel('y');
    axis off;
end

save datatemp/pltemplate pltemplate;