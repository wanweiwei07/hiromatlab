dbstop if error

load 'human16/interaircapacitor.mat';
load 'human16/placementscapacitor1.mat';

%% plot
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
mainview = [90, 20];

placements = [placementscapacitor1];

nplacements = size(placements, 1);
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
    plotinterstates(placements{i});
end

hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);

% original object 1
initial_placement = 2;
obj1p = [0.45;-0.2;-0.05];
obj1R = eye(3,3);
obj1state = placementscapacitor1{initial_placement};
obj1state_init = moveinterstate(obj1state, obj1p, obj1R);
% plotactiveobj(obj1state_init);
% obj1p = [0.1;0;0];
% obj1R = eye(3,3)
% obj1state_init = moveinterstaterel(obj1state_init, obj1p, obj1R);
% plotactiveobj(obj1state_init);
% obj1p = [0.55;-0.2;-0.05];
% obj1R = rodrigues([0;0;1], pi/3);
% obj1state_init = moveinterstate(obj1state_init, obj1p, obj1R);
% plotactiveobj(obj1state_init);
% motion primitive -- retraction motion
obj1state_inits_ikprggrp = spawnrgtikprggrp(hironx, obj1state_init);
obj1state_inits_ikupdown = spawnrgtikupdown(hironx, obj1state_init);
% plotactiveobj(obj1state_inits_ikupdown(1));
% plotactiveobj(obj1state_inits_ikupdown(2));

% original object 2
% initial_placement = 5;
% obj2p = [0.35;-0.35;-0.05];
% obj2R = eye(3,3);
% obj2state = placementstri{initial_placement};
% obj2state_init = moveinterstate(obj2state, obj2p, obj2R);
% % motion primitive -- retraction motion
% obj2state_inits_ikprggrp = spawnrgtikprggrp(hironx, obj2state_init);
% obj2state_inits_ikupdown = spawnrgtikupdown(hironx, obj2state_init);
% plotactiveobj(obj2state_inits_ikupdown(1));
% plotactiveobj(obj2state_inits_ikupdown(2));

% assembled object 1
goal_placement = 6;
obj1p = [0.35;0.35;-0.05];
obj1R = eye(3,3);
obj1state = placementscapacitor1{goal_placement};
obj1state_assem = moveinterstate(obj1state, obj1p, obj1R);
% motion primitive -- retraction motion
obj1state_assem_ikprggrp = spawnrgtikprggrp(hironx, obj1state_assem);
obj1state_assem_ikupdown = spawnrgtikupdown(hironx, obj1state_assem);
% plotactiveobj(obj1state_assem_ikupdown(1));
% plotactiveobj(obj1state_assem_ikupdown(2));

% assembled object 2
% obj2state = assemsgl(2).obj2state;
% obj2state_assem = moveinterstaterel(obj2state, obj1p, obj1R);
% % motion primitive -- retraction motion
% obj2state_assem_ikprggrp = spawnrgtikprggrp(hironx, obj2state_assem);
% obj2state_assem_ikupdown = spawnrgtikupdown(hironx, obj2state_assem);
% plotactiveobj(obj2state_assem_ikupdown(1));
% plotactiveobj(obj2state_assem_ikupdown(2));

% placements
interp = [0.3;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementscapacitor1, 1);
intermediatestates_ikprggrp = cell(nintermediatestates, 1);
intermediatestates_ikupdown = cell(nintermediatestates, 1);
interstatewithik = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates_ikprggrp{i} =  spawnrgtikprggrp(hironx, placementscapacitor1{i}, interp, interR);
    intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placementscapacitor1{i}, interp, interR);
    interstatewithik{i} = spawnrgtik(hironx, placementscapacitor1{i}, interp, interR);
end

% first object
% combine the states
initstate.ikprggrp = obj1state_inits_ikprggrp;
initstate.ikupdown = obj1state_inits_ikupdown;
goalstate.ikprggrp = obj1state_assem_ikprggrp;
goalstate.ikupdown = obj1state_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikprggrp{i};
    interstates{i}.ikupdown = intermediatestates_ikupdown{i};
end
graphstates = [{initstate};{goalstate};interstates];
graphstates = filterunavailablestates(graphstates);

% search path for first obj
interp = [0.3;0;-0.05];
[isdone, keyposes] = searchrgtkeyposes(hironx, graphstates);
if isdone == 0
    disp('No path found');
end

cmap = colormap(jet);
nkeyposes = size(keyposes, 1);
for i = 1:nkeyposes
    graspid = i;
    plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
    plotactiveobj(obj2state_init);
    drawnow;
%     cla;
    if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
        plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
        drawnow;
    end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
%         cla;
        disp('firstmotionplan');
    end
end

% placements
interp = [0.3;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementstri, 1);
intermediatestates_ikprggrp = cell(nintermediatestates, 1);
intermediatestates_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates_ikprggrp{i} =  spawnrgtikprggrp(hironx, placementstri{i}, interp, interR);
    intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placementstri{i}, interp, interR);
end
% combine the states
initstate.ikprggrp = obj2state_inits_ikprggrp;
initstate.ikupdown = obj2state_inits_ikupdown;
goalstate.ikprggrp = obj2state_assem_ikprggrp;
goalstate.ikupdown = obj2state_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikprggrp{i};
    interstates{i}.ikupdown = intermediatestates_ikupdown{i};
end
graphstates = [{initstate};{goalstate};interstates];
graphstates = filterunavailablestates(graphstates);

% search path for first obj
interp = [0.3;0;-0.05];
[isdone, keyposes] = searchrgtkeyposes(hironx, graphstates);
if isdone == 0
    disp('No path found');
end

cmap = colormap(jet);
nkeyposes = size(keyposes, 1);
for i = 1:nkeyposes
    graspid = i;
    plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
    plotactiveobj(obj1state_assem);
    drawnow;
%     cla;
    if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
        plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
        drawnow;
    end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
    end
end