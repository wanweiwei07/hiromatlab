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

%% crop object out of workspace
objThresh = 1200;
maskDepth = uint16(zeros(size(depthImage)));
maskDepth(180:430, 100:500) = 1;
maskDepth = maskDepth.*depthImage < objThresh & maskDepth > 0;
depthImage(~maskDepth) = 0;
xyzPoints = depthToPointCloud(depthImage,depthDevice);

originalX = xyzPoints(:,:,1);
originalY = xyzPoints(:,:,2);
originalZ = xyzPoints(:,:,3);
xyzPoints(:,:,1) = originalX;
xyzPoints(:,:,2) = originalY;
xyzPoints(:,:,3) = 1.2-originalZ;

xyzPointsX = xyzPoints(:,:,1);
xyzPointsX = xyzPointsX(:);
xyzPointsY = xyzPoints(:,:,2);
xyzPointsY = xyzPointsY(:);
xyzPointsZ = xyzPoints(:,:,3);
xyzPointsZ = xyzPointsZ(:);
xyzPointsList = [xyzPointsX, xyzPointsY, xyzPointsZ];

%% transform
load data/placementsl.mat
isplot = 1;
[placementdetected, pos, rot] = findpstempless(xyzPointsList, placementsl, isplot);