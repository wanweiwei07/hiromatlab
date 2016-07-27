%% main
dbstop if warning

load 'data/placementsl.mat';
load 'data/placementstri.mat';
load 'data/interairl.mat';
load 'data/interairtri.mat';

global fhdl;
fhdl = figure;
global subrow;
global subcol;
global mainrowcol;
subrow = 3;
subcol = 8;
mainrowcol = [5 6 7 8 13 14 15 16 21 22 23 24];
global mainaxlimits;
mainaxlimits = [-0.5, 1, -1, 1, -0.5, 1];
global mainview;
mainview = [50, 20];
% [rgtarm, rgthnd] = initrgtarm();
% [rgtarm, rgthnd] = plotrgtarm(rgtarm, rgthnd);
% [lftarm, lfthnd] = initlftarm();
% [lftarm, lfthnd] = plotlftarm(lftarm, lfthnd);

nplacements = size(placementsl, 1);
for i = 1:nplacements
    if i <= 4
        subplot(3, 8, i);
    else
        if i >= 5 && i <= 8
            subplot(3, 8, i+4);
        else
        	if i >= 9 && i <= 12
                subplot(3, 8, i+8);
            end
        end
    end
    cmap = colormap('lines');
    nfaces = size(placementsl{i}.stablemesh.simplifiedfaces,1);
    for j = 1:nfaces
        patch('vertices', placementsl{i}.stablemesh.simplifiedverts,...
            'faces', placementsl{i}.stablemesh.simplifiedfaces{j},...
            'facecolor',cmap(mod(j, 64)+1, :));
        hold on;
        view([50, 20]);
        axis equal;
        axis([-0.25, 0.25, -0.25, 0.25, -0.25, 0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
    end
end

%% regrasp graph
hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);
plothironx(hironx);

objp = [0.32,-0.4,-0.05]';
objR = eye(3,3);
placementstartid = 3;
placementstart.ikprggrp = spawnrgtikprggrp(hironx, placementsl{placementstartid}, objp, objR);
placementendid = 2;
placementend.ikprggrp = spawnrgtikprggrp(hironx, placementsl{placementendid}, objp, objR);
placementinter1.ikprggrp = spawnrgtikprggrp(hironx, placementsl{1}, objp, objR);
placementinter2.ikprggrp = spawnrgtikprggrp(hironx, placementsl{2}, objp, objR);
placementinter3.ikprggrp = spawnrgtikprggrp(hironx, placementsl{3}, objp, objR);
placementinter4.ikprggrp = spawnrgtikprggrp(hironx, placementsl{4}, objp, objR);
placementinter5.ikprggrp = spawnrgtikprggrp(hironx, placementsl{5}, objp, objR);
placementinter6.ikprggrp = spawnrgtikprggrp(hironx, placementsl{6}, objp, objR);

graphps = {placementstart;placementend;placementinter1;placementinter2;...
    placementinter3;placementinter4;placementinter5;placementinter6};
% plotgraphps(graphps);
[dg, regraspgraph] = regraspgraph(graphps);
h = view(dg);
plotregraspgraph(dg, regraspgraph, 1, 1);

%% object placement and right arm grasps
objp = [0.32,-0.4,-0.05]';
objR = eye(3,3);

placementid = 3;
placementi = spawnpg(placementsl, placementid, objp, objR);

objap = [0.32,0,0.3]';
objaR = eye(3,3);
interairi = spawnag(interairl, objap, objaR);

hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);
for i = 1:size(placementi.graspparams, 1)
    graspid = i;
    % based
    [isdone, bodyyaw, rgtjnts, trajpath] = ...
        numrgt7ik(hironx, placementi.graspparams(graspid).fgrcenter,...
            [placementi.graspparams(graspid).handx,...
            placementi.graspparams(graspid).handy,...
            placementi.graspparams(graspid).handz]');
    if isdone
        hironxcp = hironx;
        hironxcp = movergtjnts7sim(hironxcp, bodyyaw, rgtjnts);
        plothironx(hironxcp, 'b', 0);
        drawnow;
    end
end
for i = 1:size(interairi.graspparams, 1)
    graspid = i;
    % no base
    [isdone, rgtjnts, trajpath] = ...
        numrgtik(hironx.rgtarm, interairi.graspparams(graspid).fgrcenter, ...
        [interairi.graspparams(graspid).handx,...
        interairi.graspparams(graspid).handy,...
        interairi.graspparams(graspid).handz]');
    if isdone
        hironxcp = hironx;
        hironxcp = movergtjnts6sim(hironxcp, rgtjnts);
        plothironx(hironxcp, 'r', 0);
        drawnow;
    end
end

% plot object
plotactiveobj(interairi);
drawnow;

%% object placement and left arm grasps
objp = [0.32,0.4,-0.05]';
objR = eye(3,3);

placementid = 3;
placementi = spawnpg(placementsl, placementid, objp, objR);

hironx = movejnts15sim(hironx, [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0]);
for i = 1:size(placementi.graspparams, 1)
    graspid = i;
    [isdone, bodyyaw, lftjnts, trajpath] = ...
        numlftbaik(hironx, placementi.graspparams(graspid).fgrcenter, ...
        [placementi.graspparams(graspid).handx,...
        placementi.graspparams(graspid).handy,...
        placementi.graspparams(graspid).handz]');
    if isdone
        hironx = movelftjnts7sim(hironx, bodyyaw, lftjnts);
        plothironx(hironx, 'b', 0);
        drawnow;
    end
end

% plot object
plotactiveobj(placementi);
drawnow;