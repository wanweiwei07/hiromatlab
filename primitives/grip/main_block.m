% dbstop if error

%% compute interair lpart
interairl = computeinterstateair('objects/lpart.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairl.mat interairl;
%% compute placements lpart
dbstop if error
placementsl = associnterstateps(interairl);
figure;
plotinterstates(placementsl);
save data/placementsl.mat placementsl;

%% compute interair 
tripartinterairtri = computeinterstateair('objects/tripart.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairtri.mat interairtri;
%% compute placements tripart
placementstri = associnterstateps(interairtri);
figure;
plotinterstates(placementstri);
save data/placementstri.mat placementstri;

%% compute interair zpart
interairz3d = computeinterstateair('objects/z3dpart.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairz3d.mat interairz3d;
%% compute placements zpart
placementsz3d = associnterstateps(interairz3d);
figure;
plotinterstates(placementsz3d);
save data/placementsz3d.mat placementsz3d;

%% compute interair tpart
interairt = computeinterstateair('objects/tpart.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairt.mat interairt;
%% compute placements tpart
placementst = associnterstateps(interairt);
figure;
plotinterstates(placementst);
save data/placementst.mat placementst;


%% plot interairl
figure;
plotinterstates(interairl);

%% plot interairtri
figure;
plotinterstates(interairtri);

%% plot interairz3d
figure;
plotinterstates(interairz3d);

%% plot interairt
figure;
plotinterstates(interairt);