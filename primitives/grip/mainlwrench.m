%% compute interair lpart
interairlwrench = computeinterstateair('objects/lwrench.obj', 'hxgripper/hxpalm.obj', ...
    'hxgripper/hxfgr1.obj', 'hxgripper/hxfgr2.obj');
save data/interairlwrench.mat interairlwrench;
h=figure;
plotinterstates(interairlwrench);
drawnow;
savefig(h, ['results/lwrench/', 'interairlwrench', '.fig']);
plotinterstatesobjpcds(interairlwrench);
drawnow;
savefig(h, ['results/lwrench/', 'interairlwrenchwithsample', '.fig']);
close(h);

%% compute placements lwrench
dbstop if error
placementslwrench = associnterstateps(interairlwrench);
% figure;
% plotinterstates(placementslwrench);
for i=1:size(placementslwrench)
    h=figure;
    plotinterstates(placementslwrench{i}, 'c');
    plotinterstatesobjpcds(placementslwrench{i});
    drawnow;
    savefig(h, ['results/lwrench/', 'plwrench_', num2str(i), '.fig']);
    close(h);
end
save data/placementslwrench.mat placementslwrench;