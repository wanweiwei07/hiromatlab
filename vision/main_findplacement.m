% %% delete all the imaqobjects
% delete(imaqfind)
% % create devices
% colorDevice = imaq.VideoDevice('kinect',1);
% depthDevice = imaq.VideoDevice('kinect',2);
% colorDevice.ReturnedDataType = 'uint8';
% % initialize the camera
% step(colorDevice);
% step(depthDevice);
% colorImage = step(colorDevice);
% depthImage = step(depthDevice);
% colorImage = alignColorToDepth(depthImage,colorImage,depthDevice);
% 
% %% crop object out of workspace
% objThresh = 1200;
% maskDepth = uint16(zeros(size(depthImage)));
% maskDepth(180:430, 100:500) = 1;
% maskDepth = maskDepth.*depthImage < objThresh & maskDepth > 0;
% depthImage(~maskDepth) = 0;
% xyzPoints = depthToPointCloud(depthImage,depthDevice);
% 
% maskRGB = uint8(zeros(size(depthImage)));
% maskRGB(200:450, 150:550) = 1;
% colorImage(:,:,1) = colorImage(:,:,1).*maskRGB;
% colorImage(:,:,2) = colorImage(:,:,2).*maskRGB;
% colorImage(:,:,3) = colorImage(:,:,3).*maskRGB;
% 
% save dataimg/xyzPoints xyzPoints;
% save dataimg/colorImage colorImage;

%%
load dataimg/xyzPoints;
load dataimg/colorImage;

originalX = xyzPoints(:,:,1);
originalY = xyzPoints(:,:,2);
originalZ = xyzPoints(:,:,3);
xyzPoints(:,:,1) = originalX;
xyzPoints(:,:,2) = originalY;
xyzPoints(:,:,3) = 1.2-originalZ;

load datatemp/pltemplate.mat

% plot3(xyzPoints(:,:,1), xyzPoints(:,:,2), xyzPoints(:,:,3), '.r');
% hold on;
% axis equal;
xyzPointsX = xyzPoints(:,:,1);
xyzPointsX = xyzPointsX(:);
xyzPointsY = xyzPoints(:,:,2);
xyzPointsY = xyzPointsY(:);
xyzPointsZ = xyzPoints(:,:,3);
xyzPointsZ = xyzPointsZ(:);
xyzPointsList = [xyzPointsX, xyzPointsY, xyzPointsZ];

T = clusterdata(xyzPointsList, 'criterion', 'distance', 'cutoff', 0.01);
nseg = max(max(T));
cmap = colormap('lines');
cluster = cell(nseg, 1);
for i = 1:nseg
    cluster{i} = xyzPointsList(find(T==i), :);
    plot3(cluster{i}(:,1), cluster{i}(:,2), cluster{i}(:,3), '.', 'color', cmap(i, :));
    hold on;
    axis equal;
    axis off;
    set(gcf,'color','w');
end

ntemp = size(pltemplate, 1);
tform = cell(ntemp, nseg);
movingReg = cell(ntemp, nseg);
rmse = zeros(ntemp, nseg);
minrmse = 1.0;
for i = 1:nseg
    observedPC = pointCloud(cluster{i});
    parfor j = 1:ntemp
        templatePC = pointCloud(pltemplate{j}.pcd);
        [tformtmp, movingRegtmp, rmsetmp] = pcregrigid(templatePC, observedPC);
        tform{j, i} = tformtmp;
        movingReg{j, i} = movingRegtmp.Location;
        rmse(j, i) = rmsetmp;
    end
end

[mintemp, mintempind] = min(rmse);
[minseg, minsegind] = min(mintemp);
mintempind = mintempind(minsegind);
macthedPoints = movingReg{mintempind, minsegind};
plot3(macthedPoints(:,1), macthedPoints(:,2), macthedPoints(:,3), '.', 'color', cmap(nseg+1, :));

%% transform
load data/placementsl.mat
tformmat = tform{mintempind, minsegind};
placementldetected = moveinterstate(placementsl{mintempind}, tformmat.T(4,1:3)', tformmat.T(1:3,1:3)');
plotinterstates(placementldetected);

% pcshow(xyzPoints,colorImage,'VerticalAxis','y','VerticalAxisDir','down');
% originalX = xyzPoints(:,:,1);
% originalY = xyzPoints(:,:,2);
% originalZ = xyzPoints(:,:,3);
% %%im
% release(colorDevice);
% release(depthDevice);