%% compute interair tool
interairbolt = computeinterstateair('objects/bolt.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairbolt.mat interairbolt;
%% compute placements tool
dbstop if error
placementsbolt = associnterstateps(interairbolt);
figure;
plotinterstates(placementsbolt);
save data/placementsbolt.mat placementsbolt;

%% plot interairl
figure;
plotinterstates(interairbolt,'r');
figure;
plotinterstates(placementsbolt,'r');