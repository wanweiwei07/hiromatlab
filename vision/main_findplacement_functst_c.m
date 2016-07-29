%% delete all the imaqobjects
delete(imaqfind)

% create devices
colorDevice = imaq.VideoDevice('kinect',1);
depthDevice = imaq.VideoDevice('kinect',2);
colorDevice.ReturnedDataType = 'uint8';
% initialize the camera
step(colorDevice);
step(depthDevice);
colorImage = step(colorDevice);
depthImage = step(depthDevice);
colorImage = alignColorToDepth(depthImage,colorImage,depthDevice);

release(colorDevice);
release(depthDevice);

%imtool(depthImage)

%% crop object out of workspace
% objThresh_high = 1400;
% objThresh_low = 970;
% maskDepth = uint16(zeros(size(depthImage)));
% maskDepth(10:370, 50:310) = 1;
% maskDepth = maskDepth.*depthImage < objThresh_high & maskDepth.*depthImage > objThresh_low & maskDepth > 0;
% depthImage(~maskDepth) = 0;
figure
xyzPoints = depthToPointCloud(depthImage,depthDevice);
pcshow(xyzPoints,'VerticalAxis','Z','VerticalAxisDir','Up')
xlabel('X');ylabel('Y');zlabel('Z');

originalX = xyzPoints(:,:,1);
originalY = xyzPoints(:,:,2);
originalZ = xyzPoints(:,:,3);
xyzPoints(:,:,1) = originalX;
xyzPoints(:,:,2) = originalY;
xyzPoints(:,:,3) = originalZ;

xyzPointsX = xyzPoints(:,:,1);
xyzPointsX = xyzPointsX(:);
xyzPointsY = xyzPoints(:,:,2);
xyzPointsY = xyzPointsY(:);
xyzPointsZ = xyzPoints(:,:,3);
xyzPointsZ = xyzPointsZ(:);
xyzPointsList = [xyzPointsX, xyzPointsY, xyzPointsZ];
t  = [1.05929568186030;-0.103720138597870;0.972515087278678]'; % get from calibration.m
R  = [0.719452651709527,-0.0143731206387763,-0.694392752951262;
    -0.0344132840938860,-0.999295549844042,-0.0149709699006730;
    -0.693688408311688,0.0346672390737501,-0.719440459460684];
xyzPointsListCalibrated = bsxfun(@plus, (R*xyzPointsList')', t);
pcshow(xyzPointsListCalibrated,'VerticalAxis','Z','VerticalAxisDir','Up')
xlabel('X');ylabel('Y');zlabel('Z');

xPointsListCalibrated = xyzPointsListCalibrated(:,1);
yPointsListCalibrated = xyzPointsListCalibrated(:,2);
zPointsListCalibrated = xyzPointsListCalibrated(:,3);
mask_x = xPointsListCalibrated > 0.2 & xPointsListCalibrated < 0.6;
mask_y = yPointsListCalibrated > -0.3 & yPointsListCalibrated < 0.3;
mask_z = zPointsListCalibrated > -0.03 & zPointsListCalibrated < 0.06 ;
mask_xyz = logical(mask_x.*mask_y.*mask_z);
PointsListCalibrated = [xPointsListCalibrated(mask_xyz),yPointsListCalibrated(mask_xyz),zPointsListCalibrated(mask_xyz)];
pcshow(PointsListCalibrated,'VerticalAxis','Z','VerticalAxisDir','Up')
xlabel('X');ylabel('Y');zlabel('Z');
view(50,20)

%% transform
load data/placementsl.mat
isplot = 0;
% Detect object by ICP
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
placementdetected_c = placementdetected;
PointsListCalibrated_c = PointsListCalibrated;
save data/placementdetected_c.mat placementdetected_c;
save data/PointsListCalibrated_c.mat PointsListCalibrated_c;