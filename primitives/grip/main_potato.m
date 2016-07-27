%% compute interair tool
interairpotato = computeinterstateair('objects/potato.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairpotato.mat interairpotato;
%% compute placements tool
dbstop if error
placementspotato = associnterstateps(interairpotato);
figure;
plotinterstates(placementspotato);
save data/placementspotato.mat placementspotato;

%% plot interairl
figure;
plotinterstates(interairpotato,'r');
figure;
plotinterstates(placementspotato,'r');