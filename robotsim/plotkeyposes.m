function plotkeyposes(hironx, keypose1, keypose2)
% interplate the two keyposes to generate intermediate plots
%
% input
% ----
% - keypose1 - the first keypose
% - keypose2 - the second keypose
% see the searchrgtkeyposes function for details
%
% author: Weiwei
% date: 20160311

    % bodyyaw interpolation should be in numrgtbaik?
    hironxcp = movergtjnts7sim(hironx, ...
        keypose1.graspparams(1).bodyyaw, keypose1.graspparams(1).rgtjnts);
    [isdone, rgtjnts, trajrgtjnts] = ...
        numrgtik(hironxcp.rgtarm, keypose2.graspparams(1).fgrcenter,...
            [keypose2.graspparams(1).handx,...
            keypose2.graspparams(1).handy,...
            keypose2.graspparams(1).handz]');
    if isdone == 1
        ntrajrgtjnts = size(trajrgtjnts, 1); 
        for i = 1:ntrajrgtjnts
            thisbodyyaw = keypose1.graspparams(1).bodyyaw;
            thisrgtjnts = trajrgtjnts(i, :);
            [hironxmoved, keyposeout] = ...
                movekprgt7sim(hironx, keypose1, thisbodyyaw, thisrgtjnts);
            plothironx(hironxmoved);
            plotactiveobj(keyposeout);
            drawnow;
        end
    end
    
end