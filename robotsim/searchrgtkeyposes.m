function [isdone, keyposes] = searchrgtkeyposes(hironx, graphstates)
% create the regraspgraph, search it and generate keyposes
% a key pose includes the key confs of both the robot and the object
%
% input
% ----
% - graphstates - the graphstates with each one includes all primitives
%
% output
% ----
% - isdone - is path found or not
% - keyposes - the same as state except that it has only one associated g
%
% author: Weiwei
% date: 20160310

    isdone = 1;
    keyposes = {};
    
    [dg, rgp] = regraspgraph(graphstates);
    plotregraspgraph(dg, rgp, 1, 1);
    figure;
    plot(dg,'Layout','force');
    [path,~] = shortestpath(dg,1,2);
    npathnode = size(path, 2);
    if npathnode < 2
        isdone = 0;
        return;
    end
    % each segment includes: grasp -> pick up; place down -> release
    for i = 1:npathnode-1
        [~, conidx] = ismember([path(i), path(i+1)], rgp.connectpairs, 'rows');
        % prg and grp of the two pairs
        grasppairs = rgp.connectedges{conidx};
        firstgraspparamprg = rgp.states{path(i)}.ikprggrp(1).graspparams(grasppairs(1,1));
        firstgraspparamidprg = rgp.states{path(i)}.ikprggrp(1).graspparamids(grasppairs(1,1));
        firstgraspparamgrp = rgp.states{path(i)}.ikprggrp(2).graspparams(grasppairs(1,1));
        firstgraspparamidgrp = rgp.states{path(i)}.ikprggrp(2).graspparamids(grasppairs(1,1));
        secondgraspparamprg = rgp.states{path(i+1)}.ikprggrp(1).graspparams(grasppairs(1,2));
        secondgraspparamidprg = rgp.states{path(i+1)}.ikprggrp(1).graspparamids(grasppairs(1,2));
        secondgraspparamgrp = rgp.states{path(i+1)}.ikprggrp(2).graspparams(grasppairs(1,2));
        secondgraspparamidgrp = rgp.states{path(i+1)}.ikprggrp(2).graspparamids(grasppairs(1,2));
        % up and down of the two pairs
        firstgraspparamup = rgp.states{path(i)}.ikupdown(1).graspparams(grasppairs(1,1));
        firstgraspparamidup = rgp.states{path(i)}.ikupdown(1).graspparamids(grasppairs(1,1));
        firstgraspparamdown = rgp.states{path(i)}.ikupdown(2).graspparams(grasppairs(1,1));
        firstgraspparamiddown = rgp.states{path(i)}.ikupdown(2).graspparamids(grasppairs(1,1));
        secondgraspparamup = rgp.states{path(i+1)}.ikupdown(1).graspparams(grasppairs(1,2));
        secondgraspparamidup = rgp.states{path(i+1)}.ikupdown(1).graspparamids(grasppairs(1,2));
        secondgraspparamdown = rgp.states{path(i+1)}.ikupdown(2).graspparams(grasppairs(1,2));
        secondgraspparamiddown = rgp.states{path(i+1)}.ikupdown(2).graspparamids(grasppairs(1,2));
        % each key pose correspond to two sequential commands
        % 1. move to the kinematic pose
        % 2. change hand state to 
        % first prg, hand open
        keyposes{end+1,1} = rgp.states{path(i)}.ikprggrp(1);
        keyposes{end,1}.graspparams=firstgraspparamprg;
        keyposes{end,1}.graspparamids=firstgraspparamidprg;
        keyposes{end,1}.graspparams(1).handstate = 'open';
        % first grp, hand open
        keyposes{end+1,1} = rgp.states{path(i)}.ikprggrp(2);
        keyposes{end,1}.graspparams=firstgraspparamgrp;
        keyposes{end,1}.graspparamids=firstgraspparamidgrp;
        keyposes{end,1}.graspparams(1).handstate = 'open';
        % first down, hand close
        keyposes{end+1,1} = rgp.states{path(i)}.ikupdown(2);
        keyposes{end,1}.graspparams=firstgraspparamdown;
        keyposes{end,1}.graspparamids=firstgraspparamiddown;
        keyposes{end,1}.graspparams(1).handstate = 'close';
        % first up, hand close
        keyposes{end+1,1} = rgp.states{path(i)}.ikupdown(1);
        keyposes{end,1}.graspparams = firstgraspparamup;
        keyposes{end,1}.graspparamids = firstgraspparamidup;
        keyposes{end,1}.graspparams(1).handstate = 'close';
        % second up, hand close
        keyposes{end+1,1} = rgp.states{path(i+1)}.ikupdown(1);
        keyposes{end,1}.graspparams = secondgraspparamup;
        keyposes{end,1}.graspparamids = secondgraspparamidup;
        keyposes{end,1}.graspparams(1).handstate = 'close';
        % second down, hand close
        keyposes{end+1,1} = rgp.states{path(i+1)}.ikupdown(2);
        keyposes{end,1}.graspparams = secondgraspparamdown;
        keyposes{end,1}.graspparamids = secondgraspparamiddown;
        keyposes{end,1}.graspparams(1).handstate = 'close';
        % second grp, hand open
        keyposes{end+1,1} = rgp.states{path(i+1)}.ikprggrp(2);
        keyposes{end,1}.graspparams = secondgraspparamgrp;
        keyposes{end,1}.graspparamids = secondgraspparamidgrp;
        keyposes{end,1}.graspparams(1).handstate = 'open';
        % second prg, hand open
        keyposes{end+1,1} = rgp.states{path(i+1)}.ikprggrp(1);
        keyposes{end,1}.graspparams = secondgraspparamprg;
        keyposes{end,1}.graspparamids = secondgraspparamidprg;
        keyposes{end,1}.graspparams(1).handstate = 'open';
    end
end

