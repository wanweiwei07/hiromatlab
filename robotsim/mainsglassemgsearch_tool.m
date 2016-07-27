dbstop if error

load 'data/assemsgl_tool.mat';

load 'data/placementstool.mat';
load 'data/placementsbolt.mat';

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
mainview = [70, 15];
%mainview = [90, 20];

placements = [placementsbolt;placementstool];
% placements = [placementsl;placementstri];

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

% bolt pose
boltstate = assemsgl_tool.obj1state;
boltp = [0.35;0.35;-0.05];
boltR = eye(3,3);
boltstate_assem = moveinterstate(boltstate, boltp, boltR);

%%%%%%%%%%%%%%%%%%%%%%%%%%% original %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% original tool
cprintf('r', 'tool init\n');
initial_placement = 5;
toolp = [0.35;-0.35;-0.05];
toolR = rodrigues([0;0;1], -pi*3/4);
toolstate = placementstool{initial_placement};
toolstate_init = moveinterstate(toolstate, toolp, toolR);
% motion primitive -- retraction motion
toolstate_inits_ikprggrp = spawnrgtikppgrp(hironx, toolstate_init);
toolstate_inits_ikupdown = spawnrgtikupdown(hironx, toolstate_init);


%%%%%%%%%%%%%%%%%%%%%%%%%%% goal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% goal tool
cprintf('r', 'tool goal\n');
toolstate = assemsgl_tool.obj2state;
toolstate_assem = moveinterstaterel(toolstate, boltp, boltR);
% motion primitive -- retraction motion
toolstate_assem_ikprggrp = spawnrgtikppgrp(hironx, toolstate_assem);
toolstate_assem_ikupdown = spawnrgtikupdown(hironx, toolstate_assem);

% placements
interp = [0.4;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementstool, 1);
intermediatestates_ikprggrp = cell(nintermediatestates, 1);
intermediatestates_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates_ikprggrp{i} =  spawnrgtikppgrp(hironx, placementstool{i}, interp, interR);
    intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placementstool{i}, interp, interR);
end
% combine the states
initstate.ikprggrp = toolstate_inits_ikprggrp;
initstate.ikupdown = toolstate_inits_ikupdown;
goalstate.ikprggrp = toolstate_assem_ikprggrp;
goalstate.ikupdown = toolstate_assem_ikupdown;
interstates = cell(nintermediatestates,1);
for i = 1:nintermediatestates
    interstates{i}.ikprggrp = intermediatestates_ikprggrp{i};
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
    plotactiveobj(boltstate_assem, [0.3, 0.5, 0.3]);
    drawnow;
    saveas(fhdl, ['results/sglassemgsearch_tool/tool_', num2str(i), '.png']);
    cla;
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
    end
end