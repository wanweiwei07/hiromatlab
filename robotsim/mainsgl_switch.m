dbstop if error

load data/interaircapacitor1.mat;
load data/placementscapacitor1.mat;

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
mainview = [70, 25];

placements = placementscapacitor1;

nplacements = size(placements, 1);
% for i = 1:nplacements
%     if i <= 4
%         subplot(3, 8, i);
%     else
%         if i >= 5 && i <= 8
%             subplot(3, 8, i+4);
%         else
%         	if i >= 9 && i <= 12
%                 subplot(3, 8, i+8);
%             end
%         end
%     end
%     plotinterstates(placements{i});
% end

hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);


%%%%%%%%%%%%%%%%%%%%%%%%%%% start %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% original object 1
cprintf('r', 'first object\n');
obj1placement = 5;
obj1p = [0.45;-0.15;-0.05];
obj1R = eye(3,3);
obj1state = placementscapacitor1{obj1placement};
obj1state_init = moveinterstate(obj1state, obj1p, obj1R);
% % motion primitive -- retraction motion
obj1state_inits_ikppgrp = spawnrgtikppgrp(hironx, obj1state_init);
obj1state_inits_ikupdown = spawnrgtikupdown(hironx, obj1state_init);

%%%%%%%%%%%%%%%%%%%%%%%%%%% goal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% goal object 1
cprintf('r', 'first object in assembly\n');
obj1placement = 2;
obj1p = [0.35;0.15;-0.05];
%obj1R = rodrigues([1;0;0], -pi/2);
obj1R = eye(3,3);
obj1state = placementscapacitor1{obj1placement};
obj1state_goal = moveinterstate(obj1state, obj1p, obj1R);
% motion primitive -- retraction motion
obj1state_goal_ikppgrp = spawnrgtikppgrp(hironx, obj1state_goal);
obj1state_goal_ikupdown = spawnrgtikupdown(hironx, obj1state_goal);

% plotactiveobj(obj1state_assem_ikupdown(1));
% plotactiveobj(obj1state_assem_ikupdown(2));

% assembled box
% objboxstate_assem = moveinterstaterel(interair_box, obj1p, obj1R);


%%%%%%%%%%%%%%%%%%%%%%%%%%% placements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% placements
interp = [0.4;0;-0.05];
interR = obj1R;
% interR = eye(3,3);
nintermediatestates = size(placements, 1);
intermediatestates_ikppgrp = cell(nintermediatestates, 1);
intermediatestates_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates_ikppgrp{i} =  spawnrgtikppgrp(hironx, placements{i}, interp, interR);
    intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placements{i}, interp, interR);
end

% first object
% combine the states
initstate.ikprggrp = obj1state_inits_ikppgrp;
initstate.ikupdown = obj1state_inits_ikupdown;
goalstate.ikprggrp = obj1state_goal_ikppgrp;
goalstate.ikupdown = obj1state_goal_ikupdown;
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
%    view(70,25)
    drawnow;
    saveas(fhdl, ['results/rearrangement/obj_1_', num2str(i), '.png']);
    cla;
%     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
%         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
%         drawnow;
%     end
    if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
        cla;
%        disp('firstmotionplan');
    end
end
