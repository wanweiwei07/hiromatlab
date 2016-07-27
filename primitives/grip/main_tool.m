%% compute interair tool
interairtool = computeinterstateair('objects/tool.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairtool.mat interairtool;
%% compute placements tool
dbstop if error
placementstool = associnterstateps(interairtool);
figure;
plotinterstates(placementstool);
save data/placementstool.mat placementstool;

%% plot interairl
figure;
plotinterstates(interairtool,'r');
figure;
plotinterstates(placementstool,'r');