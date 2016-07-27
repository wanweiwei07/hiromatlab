% delete all the imaqobjects
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
% depthImage = max(max(depthImage))+100-depthImage;
ptCloud = pcfromkinect(depthDevice, depthImage, colorImage);

maxDistance = 0.02;
referenceVector = [0,0,1];
maxAngularDistance = 5;
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
plane1 = pcdenoise(plane1);
remainPtCloud = select(ptCloud,outlierIndices);
plot3(plane1.Location(:,1),plane1.Location(:,2), plane1.Location(:,3), '.b');
hold on;
plot3(remainPtCloud.Location(:,1),remainPtCloud.Location(:,2), remainPtCloud.Location(:,3), '.r');
axis equal;

% R = [-0.0093 -0.9913 0.1315; ...
%      0.9928 0.0065 0.1192; ...
%      -0.1190 0.1316 0.9841];
% t = [0.4112 -0.2268 -1.5862]';
% transformedpoints = bsxfun(@plus, R*remainPtCloud.Location', t)';
% plot3(transformedpoints(:,1),transformedpoints(:,2), transformedpoints(:,3), '.b');
% hold on;
% 
% 
% transformedpoints = bsxfun(@plus, R*plane1.Location', t)';
% plot3(transformedpoints(:,1),transformedpoints(:,2), transformedpoints(:,3), '.r');
% axis equal;


% cloudPositions = ptCloud.Location;
% cloudColors = ptCloud.Color;
% 
% tform = affine3d(R);
% ptCloud = pctransform(ptCloud,tform);
% player = pcplayer(ptCloud.XLimits,ptCloud.YLimits,ptCloud.ZLimits,...
% 	'VerticalAxis','z','VerticalAxisDir','Down');
% view(player,ptCloud);
% % 
% xlabel(player.Axes,'X (m)');
% ylabel(player.Axes,'Y (m)');
% zlabel(player.Axes,'Z (m)');
% 
% for i = 1:500
%    colorImage = step(colorDevice);  
%    depthImage = step(depthDevice);
%  
%    ptCloud = pcfromkinect(depthDevice,depthImage, colorImage);
%  
%    view(player,ptCloud);
% end

%%
release(colorDevice);
release(depthDevice);