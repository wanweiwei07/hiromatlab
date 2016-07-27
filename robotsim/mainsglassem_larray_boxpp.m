dbstop if error

load 'data/assemsgl_larray_box.mat';
load 'data/placementsl.mat'; 

%% plot
global fhdl;
fhdl = figure;
set(gcf, 'color', 'w');
global subrow;
global subcol;
global mainrowcol;
% subrow = 3;
% subcol = 8;
% mainrowcol = [5 6 7 8 13 14 15 16 21 22 23 24];
subrow = 1;
subcol = 1;
mainrowcol = 1;

global mainaxlimits;
mainaxlimits = [-0.5, 1, -1, 1, -0.5, 1];
global mainview;
mainview = [90, 20];

placements = placementsl;

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


%%%%%%%%%%%%%%%%%%%%%%%%%%% original %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% original object 1
cprintf('r', 'first object\n');
obj1placement = 5;
obj1p = [0.45;-0.15;-0.05];
obj1R = eye(3,3);
obj1state = placementsl{obj1placement};
obj1state_init = moveinterstate(obj1state, obj1p, obj1R);
% plotactiveobj(obj1state_init);
% motion primitive -- retraction motion
obj1state_inits_ikppgrp = spawnrgtikppgrp(hironx, obj1state_init);
obj1state_inits_ikupdown = spawnrgtikupdown(hironx, obj1state_init);

% original object 2
cprintf('r', 'second object\n');
obj2placement = 5;
obj2p = [0.45;-0.3;-0.05];
obj2R = eye(3,3);
obj2state = placementsl{obj2placement};
obj2state_init = moveinterstate(obj2state, obj2p, obj2R);
% plotactiveobj(obj2state_init);
% motion primitive -- retraction motion
obj2state_inits_ikppgrp = spawnrgtikppgrp(hironx, obj2state_init);
obj2state_inits_ikupdown = spawnrgtikupdown(hironx, obj2state_init);

% original object 3
cprintf('r', 'third object\n');
obj3placement = 1;
obj3p = [0.45;-0.4;-0.05];
obj3R = eye(3,3);
obj3state = placementsl{obj3placement};
obj3state_init = moveinterstate(obj3state, obj3p, obj3R);
% plotactiveobj(obj3state_init);
% motion primitive -- retraction motion
obj3state_inits_ikppgrp = spawnrgtikppgrp(hironx, obj3state_init);
obj3state_inits_ikupdown = spawnrgtikupdown(hironx, obj3state_init);

%%%%%%%%%%%%%%%%%%%%%%%%%%% assembled %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assembled object 1
cprintf('r', 'first object in assembly\n');
obj1state = assemsgl_larray_box.obj1state;
obj1p = [0.4;0.3;-0.05];
obj1R = eye(3,3);
obj1state_assem = moveinterstate(obj1state, obj1p, obj1R);
% motion primitive -- retraction motion
obj1state_assem_ikppgrp = spawnrgtikppgrp(hironx, obj1state_assem);
obj1state_assem_ikupdown = spawnrgtikupdown(hironx, obj1state_assem);
% plotactiveobj(obj1state_assem_ikupdown(1));
% plotactiveobj(obj1state_assem_ikupdown(2));

% assembled object 2
cprintf('r', 'second object in assembly\n');
obj2state = assemsgl_larray_box.obj2state;
obj2state_assem = moveinterstaterel(obj2state, obj1p, obj1R);
% motion primitive -- retraction motion
obj2state_assem_ikppgrp = spawnrgtikppgrp(hironx, obj2state_assem);
obj2state_assem_ikupdown = spawnrgtikupdown(hironx, obj2state_assem);
% plotactiveobj(obj2state_assem_ikupdown(1));
% plotactiveobj(obj2state_assem_ikupdown(2));

% assembled object 3
cprintf('r', 'third object in assembly\n');
obj3state = assemsgl_larray_box.obj3state;
obj3state_assem = moveinterstaterel(obj3state, obj1p, obj1R);
% motion primitive -- retraction motion
obj3state_assem_ikppgrp = spawnrgtikppgrp(hironx, obj3state_assem);
obj3state_assem_ikupdown = spawnrgtikupdown(hironx, obj3state_assem);
% plotactiveobj(obj2state_assem_ikupdown(1));
% plotactiveobj(obj2state_assem_ikupdown(2));

% assembled box
objboxstate_assem = moveinterstaterel(assemsgl_larray_box.obstaclestate, obj1p, obj1R);


%%%%%%%%%%%%%%%%%%%%%%%%%%% placements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% placements
interp = [0.4;-0.1;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementsl, 1);
intermediatestates_ikppgrp = cell(nintermediatestates, 1);
intermediatestates_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates_ikppgrp{i} =  spawnrgtikppgrp(hironx, placementsl{i}, interp, interR);
    intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placementsl{i}, interp, interR);
end

% first object
% combine the states
initstate.ikprggrp = obj1state_inits_ikppgrp;
initstate.ikupdown = obj1state_inits_ikupdown;
goalstate.ikprggrp = obj1state_assem_ikppgrp;
goalstate.ikupdown = obj1state_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikppgrp{i};
    interstates{i}.ikupdown = intermediatestates_ikupdown{i};
end
graphstates = [{initstate};{goalstate};interstates];
graphstates = filterunavailablestates(graphstates);

% search path for first obj
[isdone, keyposes] = searchrgtkeyposespp(hironx, graphstates);
if isdone == 0
    disp('No path found');
end

cmap = colormap(jet);
nkeyposes = size(keyposes, 1);
for i = 1:nkeyposes
    graspid = i;
    plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
    plotactiveobj(obj2state_init,[0.3,0.5,0.3]);
    plotactiveobj(obj3state_init,[0.3,0.5,0.3]);
    plotactiveobj(objboxstate_assem,[0.3,0.5,0.3]);
    view(70,25)
%    plotinterstates(objboxstate_assem);
%    plot3(tablepcd(:,1), tablepcd(:,2), tablepcd(:,3), '.c');
    drawnow;
    saveas(fhdl, ['results/rearrangement/obj_1_', num2str(i), '.png']);
    cla;
%     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
%         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
%         drawnow;
%     end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
        disp('firstmotionplan');
    end
end

% second object
% combine the states
initstate.ikprggrp = obj2state_inits_ikppgrp;
initstate.ikupdown = obj2state_inits_ikupdown;
goalstate.ikprggrp = obj2state_assem_ikppgrp;
goalstate.ikupdown = obj2state_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikppgrp{i};
    interstates{i}.ikupdown = intermediatestates_ikupdown{i};
end
graphstates = [{initstate};{goalstate};interstates];
graphstates = filterunavailablestates(graphstates);

% search path for second obj
[isdone, keyposes] = searchrgtkeyposespp(hironx, graphstates);
if isdone == 0
    disp('No path found');
end

cmap = colormap(jet);
nkeyposes = size(keyposes, 1);
for i = 1:nkeyposes
    graspid = i;
    plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
    plotactiveobj(obj1state_assem,[0.3,0.5,0.3]);
    plotactiveobj(obj3state_init,[0.3,0.5,0.3]);
    plotactiveobj(objboxstate_assem,[0.3,0.5,0.3]);
    view(70,25)    
    drawnow;
    saveas(fhdl, ['results/rearrangement/obj_2_', num2str(i), '.png']);
    cla;
%     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
%         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
%         drawnow;
%     end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
    end
end

% third object
% combine the states
initstate.ikprggrp = obj3state_inits_ikppgrp;
initstate.ikupdown = obj3state_inits_ikupdown;
goalstate.ikprggrp = obj3state_assem_ikppgrp;
goalstate.ikupdown = obj3state_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikppgrp{i};
    interstates{i}.ikupdown = intermediatestates_ikupdown{i};
end
graphstates = [{initstate};{goalstate};interstates];
graphstates = filterunavailablestates(graphstates);

% search path for third obj
[isdone, keyposes] = searchrgtkeyposespp(hironx, graphstates);
if isdone == 0
    disp('No path found');
end

cmap = colormap(jet);
nkeyposes = size(keyposes, 1);
for i = 1:nkeyposes
    graspid = i;
    plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
    plotactiveobj(obj1state_assem,[0.3,0.5,0.3]);
    plotactiveobj(obj2state_assem,[0.3,0.5,0.3]);
    plotactiveobj(objboxstate_assem,[0.3,0.5,0.3]);   
    view(70,25)    
    drawnow;
    saveas(fhdl, ['results/rearrangement/obj_3_', num2str(i), '.png']);
    cla;
%     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
%         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
%         drawnow;
%     end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
    end
end