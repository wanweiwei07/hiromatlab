dbstop if error

load 'data/assemthreeblocks/assemsgl_statescell.mat';

load 'data/placementstri.mat'; 
load 'data/interairtri.mat';
load 'data/placementsz3d.mat'; 
load 'data/interairz3d.mat';
load 'data/placementst.mat'; 
load 'data/interairt.mat';

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

% do not plot placements
% nplacements = size(placements, 1);
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

% load obj t
load data/assemthreeblocks/obj1state_init.mat;
load data/assemthreeblocks/obj1state_inits_ikprggrp.mat;
load data/assemthreeblocks/obj1state_inits_ikupdown.mat;
% load assem obj t
load data/assemthreeblocks/obj1state_assem.mat;
load data/assemthreeblocks/obj1state_assem_ikprggrp.mat;
load data/assemthreeblocks/obj1state_assem_ikupdown.mat;
% load placements t
load data/assemthreeblocks/intermediatestates1_ikprggrp.mat;
load data/assemthreeblocks/intermediatestates1_ikupdown.mat;

% load obj z3d
load data/assemthreeblocks/obj2state_init.mat;
load data/assemthreeblocks/obj2state_inits_ikprggrp.mat;
load data/assemthreeblocks/obj2state_inits_ikupdown.mat;
% load assem obj z3d
load data/assemthreeblocks/obj2state_assem.mat;
load data/assemthreeblocks/obj2state_assem_ikprggrp.mat;
load data/assemthreeblocks/obj2state_assem_ikupdown.mat;
% load placements z3d
load data/assemthreeblocks/intermediatestates2_ikprggrp.mat;
load data/assemthreeblocks/intermediatestates2_ikupdown.mat;

% load obj tri
load data/assemthreeblocks/obj3state_init.mat;
load data/assemthreeblocks/obj3state_inits_ikprggrp.mat;
load data/assemthreeblocks/obj3state_inits_ikupdown.mat;
% load assem obj tri
load data/assemthreeblocks/obj3state_assem.mat;
load data/assemthreeblocks/obj3state_assem_ikprggrp.mat;
load data/assemthreeblocks/obj3state_assem_ikupdown.mat;
% load placements tri
load data/assemthreeblocks/intermediatestates3_ikprggrp.mat;
load data/assemthreeblocks/intermediatestates3_ikupdown.mat;

% load assembly direction
load data/assemthreeblocks/obj1state_assem_direct.mat;
load data/assemthreeblocks/obj2state_assem_direct.mat;
load data/assemthreeblocks/obj3state_assem_direct.mat;

% first object
% combine the states
initstate.ikprggrp = obj1state_inits_ikprggrp;
initstate.ikupdown = obj1state_inits_ikupdown;
goalstate.ikprggrp = obj1state_assem_ikprggrp;
goalstate.ikupdown = obj1state_assem_ikupdown;
nintermediatestates1 = size(intermediatestates1_ikprggrp, 1);
interstates = cell(nintermediatestates1,1);
for i = 1:nintermediatestates1
    interstates{i}.ikprggrp = intermediatestates1_ikprggrp{i};
    interstates{i}.ikupdown = intermediatestates1_ikupdown{i};
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
    plotactiveobj(obj2state_init, [0.3,0.5,0.3]);
    plotactiveobj(obj3state_init, [0.3,0.5,0.3]);
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

% % second object
% % combine the states
% initstate.ikprggrp = obj2state_inits_ikprggrp;
% initstate.ikupdown = obj2state_inits_ikupdown;
% goalstate.ikprggrp = obj2state_assem_ikprggrp;
% goalstate.ikupdown = obj2state_assem_ikupdown;
% interstates = cell(nintermediatestates,1);
% for i = 1:nintermediatestates
%     interstates{i}.ikprggrp = intermediatestates_ikprggrp{i};
%     interstates{i}.ikupdown = intermediatestates_ikupdown{i};
% end
% graphstates = [{initstate};{goalstate};interstates];
% graphstates = filterunavailablestates(graphstates);
% 
% % search path for second obj
% [isdone, keyposes] = searchrgtkeyposespp(hironx, graphstates);
% if isdone == 0
%     disp('No path found');
% end
% 
% cmap = colormap(jet);
% nkeyposes = size(keyposes, 1);
% for i = 1:nkeyposes
%     graspid = i;
%     plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
% %     plotactiveobj(obj1state_assem, [0.3,0.5,0.3]);
% %     plotactiveobj(obj3state_init, [0.3,0.5,0.3]);
% %     plotactiveobj(obj4state_init, [0.3,0.5,0.3]);
% %     plotactiveobj(obj5state_init, [0.3,0.5,0.3]);
%     drawnow;
%     saveas(fhdl, ['results/rearrangement/obj_2_', num2str(i), '.png']);
%     cla;
% %     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
% %         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
% %         drawnow;
% %     end
%     if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
%         cla;
%     end
% end

% % third object
% % combine the states
% initstate.ikprggrp = obj3state_inits_ikprggrp;
% initstate.ikupdown = obj3state_inits_ikupdown;
% goalstate.ikprggrp = obj3state_assem_ikprggrp;
% goalstate.ikupdown = obj3state_assem_ikupdown;
% interstates = cell(nintermediatestates,1);
% for i = 1:nintermediatestates
%     interstates{i}.ikprggrp = intermediatestates_ikprggrp{i};
%     interstates{i}.ikupdown = intermediatestates_ikupdown{i};
% end
% graphstates = [{initstate};{goalstate};interstates];
% graphstates = filterunavailablestates(graphstates);
% 
% % search path for third obj
% [isdone, keyposes] = searchrgtkeyposespp(hironx, graphstates);
% if isdone == 0
%     disp('No path found');
% end
% 
% 
% %%
% cmap = colormap(jet);
% nkeyposes = size(keyposes, 1);
% for i = 1:nkeyposes
%     graspid = i;
%     plotkeypose(hironx, keyposes{i}, cmap(mod(i, 63),:));
% %     plotactiveobj(obj1state_assem, [0.3,0.5,0.3]);
% %     plotactiveobj(obj2state_assem, [0.3,0.5,0.3]);
% %     plotactiveobj(obj4state_init, [0.3,0.5,0.3]);
% %     plotactiveobj(obj5state_init, [0.3,0.5,0.3]);
% %     drawnow;
%     saveas(fhdl, ['results/rearrangement/obj_3_', num2str(i), '.png']);
%     cla;
% %     if mod(i,2)==0 && strcmp(keyposes{i}.graspparams(1).handstate, 'closemp') && i ~= nkeyposes
% %         plotkeyposes(hironx, keyposes{i}, keyposes{i+1});
% %         drawnow;
% %     end
%     if strcmp(keyposes{i}.graspparams(1).handstate, 'closemp')
%         cla;
%     end
% end