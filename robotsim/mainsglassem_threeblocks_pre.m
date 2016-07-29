% this file is the pre of mainsglassem_threeblocks, which pre-computes the
% data to increase speed

dbstop if error

load 'data/assemthreeblocks/assemsgl_statescell.mat';
load 'data/assemthreeblocks/assemdirectscell.mat';

load 'data/placementstri.mat'; 
load 'data/interairtri.mat';
load 'data/placementsz3d.mat'; 
load 'data/interairz3d.mat';
load 'data/placementst.mat'; 
load 'data/interairt.mat';

hironx = inithironx();
initialjoints = [0,0,0,-15,0,-143,0,0,0,15,0,-143,0,0,0,0];
hironx = movejnts15sim(hironx, initialjoints);

% original object t
cprintf('r', 'first object\n');
obj1placement = 5;
obj1p = [0.45;-0.15;-0.05];
obj1R = eye(3,3);
obj1state = placementst{obj1placement};
obj1state_init = moveinterstate(obj1state, obj1p, obj1R);
% plotactiveobj(obj1state_init);
% motion primitive -- retraction motion
obj1state_inits_ikprggrp = spawnrgtikppgrp(hironx, obj1state_init);
obj1state_inits_ikupdown = spawnrgtikupdown(hironx, obj1state_init);
save data/assemthreeblocks/obj1state_init.mat obj1state_init;
save data/assemthreeblocks/obj1state_inits_ikprggrp.mat obj1state_inits_ikprggrp;
save data/assemthreeblocks/obj1state_inits_ikupdown.mat obj1state_inits_ikupdown;

% original object tri
cprintf('r', 'second object\n');
obj2placement = 1;
obj2p = [0.3;-0.2;-0.05];
obj2R = eye(3,3);
obj2state = placementstri{obj2placement};
obj2state_init = moveinterstate(obj2state, obj2p, obj2R);
% plotactiveobj(obj2state_init);
% motion primitive -- retraction motion
obj2state_inits_ikprggrp = spawnrgtikppgrp(hironx, obj2state_init);
obj2state_inits_ikupdown = spawnrgtikupdown(hironx, obj2state_init);
save data/assemthreeblocks/obj2state_init.mat obj2state_init;
save data/assemthreeblocks/obj2state_inits_ikprggrp.mat obj2state_inits_ikprggrp;
save data/assemthreeblocks/obj2state_inits_ikupdown.mat obj2state_inits_ikupdown;

% original object z3d
cprintf('r', 'third object\n');
obj3placement = 5;
obj3p = [0.45;-0.25;-0.05];
obj3R = eye(3,3);
obj3state = placementsz3d{obj3placement};
obj3state_init = moveinterstate(obj3state, obj3p, obj3R);
% plotactiveobj(obj3state_init);
% motion primitive -- retraction motion
obj3state_inits_ikprggrp = spawnrgtikppgrp(hironx, obj3state_init);
obj3state_inits_ikupdown = spawnrgtikupdown(hironx, obj3state_init);
save data/assemthreeblocks/obj3state_init.mat obj3state_init;
save data/assemthreeblocks/obj3state_inits_ikprggrp.mat obj3state_inits_ikprggrp;
save data/assemthreeblocks/obj3state_inits_ikupdown.mat obj3state_inits_ikupdown;

% assembled object t
cprintf('r', 'first object in assembly\n');
obj1state_assem_direct = assemdirectscell{5,1};
obj1state = assemsgl_statescell{5,1};
obj1p = [0.35;0.15;-0.05];
obj1R = eye(3,3);
obj1state_assem = moveinterstaterel(obj1state, obj1p, obj1R);
% motion primitive -- retraction motion
obj1state_assem_ikprggrp = spawnrgtikppgrp(hironx, obj1state_assem);
obj1state_assem_ikupdown = spawnrgtikupdownassemdirec(hironx, obj1state_assem, obj1state_assem_direct);
save data/assemthreeblocks/obj1state_assem.mat obj1state_assem;
save data/assemthreeblocks/obj1state_assem_ikprggrp.mat obj1state_assem_ikprggrp;
save data/assemthreeblocks/obj1state_assem_ikupdown.mat obj1state_assem_ikupdown;

% assembled object tri
cprintf('r', 'second object in assembly\n');
obj2state_assem_direct = assemdirectscell{5,2};
obj2state = assemsgl_statescell{5,2};
obj2state_assem = moveinterstaterel(obj2state, obj1p, obj1R);
% motion primitive -- retraction motion
obj2state_assem_ikprggrp = spawnrgtikppgrp(hironx, obj2state_assem);
obj2state_assem_ikupdown = spawnrgtikupdownassemdirec(hironx, obj2state_assem, obj2state_assem_direct);
save data/assemthreeblocks/obj2state_assem.mat obj2state_assem;
save data/assemthreeblocks/obj2state_assem_ikprggrp.mat obj2state_assem_ikprggrp;
save data/assemthreeblocks/obj2state_assem_ikupdown.mat obj2state_assem_ikupdown;

% assembled object z3d
cprintf('r', 'third object in assembly\n');
obj3state_assem_direct = assemdirectscell{5,3};
obj3state = assemsgl_statescell{5,3};
obj3state_assem = moveinterstaterel(obj3state, obj1p, obj1R);
% motion primitive -- retraction motion
obj3state_assem_ikprggrp = spawnrgtikppgrp(hironx, obj3state_assem);
obj3state_assem_ikupdown = spawnrgtikupdownassemdirec(hironx, obj3state_assem, obj3state_assem_direct);
save data/assemthreeblocks/obj3state_assem.mat obj3state_assem;
save data/assemthreeblocks/obj3state_assem_ikprggrp.mat obj3state_assem_ikprggrp;
save data/assemthreeblocks/obj3state_assem_ikupdown.mat obj3state_assem_ikupdown;

% placements t
interp = [0.4;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementst, 1);
% two directions
% interR2 = rodrigues([0,0,1],pi/2);
% intermediatestates_ikprggrp = cell(2*nintermediatestates, 1);
% intermediatestates_ikupdown = cell(2*nintermediatestates, 1);
% for i = 1:nintermediatestates
%     intermediatestates_ikprggrp{i} =  spawnrgtikppgrp(hironx, placementst{i}, interp, interR);
%     intermediatestates_ikprggrp{i+nintermediatestates} =  spawnrgtikppgrp(hironx, placementst{i}, interp, interR2);
%     intermediatestates_ikupdown{i} =  spawnrgtikupdown(hironx, placementst{i}, interp, interR);
%     intermediatestates_ikupdown{i+nintermediatestates} =  spawnrgtikupdown(hironx, placementst{i}, interp, interR2);
% end
% single direction
intermediatestates1_ikprggrp = cell(nintermediatestates, 1);
intermediatestates1_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates1_ikprggrp{i} =  spawnrgtikppgrp(hironx, placementst{i}, interp, interR);
    intermediatestates1_ikupdown{i} =  spawnrgtikupdown(hironx, placementst{i}, interp, interR);
end
save data/assemthreeblocks/intermediatestates1_ikprggrp.mat intermediatestates1_ikprggrp;
save data/assemthreeblocks/intermediatestates1_ikupdown.mat intermediatestates1_ikupdown;

% placements tri
interp = [0.4;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementstri, 1);
intermediatestates2_ikprggrp = cell(nintermediatestates, 1);
intermediatestates2_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates2_ikprggrp{i} =  spawnrgtikppgrp(hironx, placementstri{i}, interp, interR);
    intermediatestates2_ikupdown{i} =  spawnrgtikupdown(hironx, placementstri{i}, interp, interR);
end
save data/assemthreeblocks/intermediatestates2_ikprggrp.mat intermediatestates2_ikprggrp;
save data/assemthreeblocks/intermediatestates2_ikupdown.mat intermediatestates2_ikupdown;

% placements z3d
interp = [0.4;0;-0.05];
interR = eye(3,3);
nintermediatestates = size(placementsz3d, 1);
intermediatestates3_ikprggrp = cell(nintermediatestates, 1);
intermediatestates3_ikupdown = cell(nintermediatestates, 1);
for i = 1:nintermediatestates
    intermediatestates3_ikprggrp{i} =  spawnrgtikppgrp(hironx, placementsz3d{i}, interp, interR);
    intermediatestates3_ikupdown{i} =  spawnrgtikupdown(hironx, placementsz3d{i}, interp, interR);
end
save data/assemthreeblocks/intermediatestates3_ikprggrp.mat intermediatestates3_ikprggrp;
save data/assemthreeblocks/intermediatestates3_ikupdown.mat intermediatestates3_ikupdown;