%% delete all the imaqobjects
% Detected by 3 pointclouds of center, left and right kinect


%% transform
load data/placementsl.mat
load data/PointsListCalibrated_r.mat
load data/PointsListCalibrated_c.mat
load data/PointsListCalibrated_l.mat
isplot = 0;
% Detect object by ICP
PointsListCalibrated = cat(1,PointsListCalibrated_r,PointsListCalibrated_c,PointsListCalibrated_l);
pcshow(PointsListCalibrated,'VerticalAxis','Z','VerticalAxisDir','Up')
xlabel('X');ylabel('Y');zlabel('Z');
placementdetected = findpstempless(PointsListCalibrated, placementsl, isplot);

global fhdl;
fhdl = figure;
set(gcf, 'color', 'w');
global subrow;
global subcol;
global mainrowcol;
% subrow = 3;
% subcol = 8;
% mainrowcol = [5 6 7 8 13 14 15 16 21 22 23 24];
subrow = 1;
subcol = 1;
mainrowcol = 1;

global mainaxlimits;
mainaxlimits = [-0.5, 1, -1, 1, -0.5, 1];
global mainview;
mainview = [90, 20];

hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);
plothironx(hironx);
hold on;
plotinterstates(placementdetected, 'r')
plotstandardaxis([0,0,0],1);
plot3(PointsListCalibrated(:,1), PointsListCalibrated(:,2), PointsListCalibrated(:,3),'r.');
axis on;
save data/placementdetected.mat placementdetected;
save data/PointsListCalibrated.mat PointsListCalibrated;