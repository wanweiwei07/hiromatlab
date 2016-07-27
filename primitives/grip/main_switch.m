% dbstop if error

% %% compute interair base
% interairbase = computeinterstateair('objects/switch/base.obj', 'hxgripper/hxpalm.obj', ...
%     'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
% save data/switch/interairbase.mat interairbase;
% 
% %% plot interair base
% % figure;
% % plotinterstates(interairbase);
% 
% %% compute placements base
% dbstop if error
% placementsbase = associnterstateps(interairbase);
% % figure;
% % plotinterstates(placementsbase);
% save data/switch/placementsbase.mat placementsbase;
% 
% %% compute interair button
% interairbutton = computeinterstateair('objects/switch/button.obj', 'hxgripper/hxpalm.obj', ...
%     'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
% save data/switch/interairbutton.mat interairbutton;
% 
% %% plot interair button
% % figure;
% % plotinterstates(interairbutton, [1,0,0], [0.7, 0.7, 0.7]);
% 
% %% compute placements interair button
% dbstop if error
% placementsbutton = associnterstateps(interairbutton);
% % figure;
% % plotinterstates(placementsbutton);
% save data/switch/placementsbutton.mat placementsbutton;

%% compute interair capacitor
interaircapacitor = computeinterstateair('objects/switch/capacitor1.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
interaircapacitor1 = interaircapacitor;
save data/switch/interaircapacitor1.mat interaircapacitor1;
interaircapacitor2 = interaircapacitor;
save data/switch/interaircapacitor2.mat interaircapacitor2;
interaircapacitor3 = interaircapacitor;
save data/switch/interaircapacitor3.mat interaircapacitor3;

%% plot interair capacitor
% figure;
% plotinterstates(interaircapacitor, [1,0,0], [0.7, 0.7, 0.7]);

%% compute placements interair capacitor
dbstop if error
placementscapacitor = associnterstateps(interaircapacitor);
% figure;
% plotinterstates(placementscapacitor);
placementscapacitor1 = placementscapacitor;
save data/switch/placementscapacitor1.mat placementscapacitor1;
placementscapacitor2 = placementscapacitor;
save data/switch/placementscapacitor2.mat placementscapacitor2;
placementscapacitor3 = placementscapacitor;
save data/switch/placementscapacitor3.mat placementscapacitor3;