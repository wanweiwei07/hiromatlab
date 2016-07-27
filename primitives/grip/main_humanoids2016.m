%% compute interair lpart
% interaircapacitor = computeinterstateair('objects/switch/capacitor1.obj', 'hxgripper/hxpalm.obj', ...
%     'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
% save data/human16/interaircapacitor.mat interaircapacitor;
load data/human16/interaircapacitor.mat;
load data/human16/placementsl.mat;
load data/human16/placementscapacitor1.mat;

pi=3.14
x=-0.1*cos(0*pi/20);
y=0.1*sin(0*pi/20);
poslassem1 = [x;y;0];
rotlassem1 = eye(3,3);
pl1 = placementsl{1};
pc13 = placementscapacitor1{3};

pl1moved = moveinterstate(pl1, poslassem1, rotlassem1);
pc13rem = removecdgmeta(pc13, pl1moved.stablemesh.pcd);

h=figure;
plotinterstates(pc13rem, [0.3,0.5,0.3]);
% plot3(pl1moved.stablemesh.pcd(:,1), pl1moved.stablemesh.pcd(:,2), pl1moved.stablemesh.pcd(:,3), '.', 'markersize', 10);
plotinterstates(pl1moved, 'none', [0.5, 0.5, 0.5]);
% plot3(interaircapacitor.stablemesh.pcd(:,1), interaircapacitor.stablemesh.pcd(:,2), interaircapacitor.stablemesh.pcd(:,3), '.o', 'markersize', 10);
view(45,60);
drawnow;
% savefig(h, ['results/lwrench/', 'interairlwrench', '.fig']);
% plotinterstatesobjpcds(interairlwrench);
% drawnow;
% savefig(h, ['results/lwrench/', 'interairlwrenchwithsample', '.fig']);
% close(h);

%% compute placements lwrench
% dbstop if error
% placementslwrench = associnterstateps(interairlwrench);
% % figure;
% % plotinterstates(placementslwrench);
% for i=1:size(placementslwrench)
%     h=figure;
%     plotinterstates(placementslwrench{i}, 'c');
%     plotinterstatesobjpcds(placementslwrench{i});
%     drawnow;
%     savefig(h, ['results/lwrench/', 'plwrench_', num2str(i), '.fig']);
%     close(h);
% end
% save data/placementslwrench.mat placementslwrench;