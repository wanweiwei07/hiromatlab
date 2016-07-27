dbstop if warning

load 'data/assemsgl.mat';

load 'data/placementsl.mat';
load 'data/placementstri.mat';
load 'data/interairl.mat';
load 'data/interairtri.mat';

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
mainview = [50, 20];

placements = [placementsl;placementstri];

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

%original object 1
% initial_placement = 1;
% obj1p = [0.45;-0.2;-0.05];
% obj1R = eye(3,3);
% obj1state = placementsl{initial_placement};
% obj1state_init = moveinterstate(obj1state, obj1p, obj1R);
% plotactiveobj(obj1state_init, [.8,.6,0]);
% obj1state_initwithik = spawnrgtik(hironx, obj1state_init);
% for i = 1:1
%     graspid = i;
%     if isfield(obj1state_initwithik.graspparams(graspid), 'bodyyaw');
%         hironxcp = hironx;
%         hironxcp = movergtjnts7sim(hironxcp,...
%             obj1state_initwithik.graspparams(graspid).bodyyaw, ...
%             obj1state_initwithik.graspparams(graspid).rgtjnts);
%         plothironx(hironxcp, 'b', 0);
% %         plot3([obj1state_initwithik.graspparams(graspid).fgrcenter(1,:);obj1state_initwithik.graspparams(graspid).tcp(1,:)],...
% %             [obj1state_initwithik.graspparams(graspid).fgrcenter(2,:);obj1state_initwithik.graspparams(graspid).tcp(2,:)],...
% %             [obj1state_initwithik.graspparams(graspid).fgrcenter(3,:);obj1state_initwithik.graspparams(graspid).tcp(3,:)],...
% %             'linestyle','-','linewidth',2,'color',[.3,.5,.3]);
% %         hironxcp = movergtjnts7sim(hironxcp,...
% %             obj1state_initwithik(2).graspparams(graspid).bodyyaw, ...
% %             obj1state_initwithik(2).graspparams(graspid).rgtjnts);
% %         plothironx(hironxcp, [1,0.2,0.2], 0);
%         drawnow;
%     end
% end
% 
% %% original object 2
% initial_placement = 2;
% obj2p = [0.35;-0.35;-0.05];
% obj2R = eye(3,3);
% obj2state = placementstri{initial_placement};
% obj2state_init = moveinterstate(obj2state, obj2p, obj2R);
% % plotactiveobj(obj2state_init, [.3,.5,.3], 0, 1, [.3, .3, .5]);
% plotactiveobj(obj2state_init, [.3,.5,.3]);
% obj2state_initwithik = spawnrgtik(hironx, obj2state_init);
% for i = 1:1
%     graspid = i;
%     if isfield(obj2state_initwithik.graspparams(graspid), 'bodyyaw');
%         hironxcp = hironx;
%         hironxcp = movergtjnts7sim(hironxcp,...
%             obj2state_initwithik.graspparams(graspid).bodyyaw, ...
%             obj2state_initwithik.graspparams(graspid).rgtjnts);
%         plothironx(hironxcp, 'b', 0);
% %         plot3([obj2state_initwithik.graspparams(graspid).fgrcenter(1,:);obj2state_initwithik.graspparams(graspid).tcp(1,:)],...
% %             [obj2state_initwithik.graspparams(graspid).fgrcenter(2,:);obj2state_initwithik.graspparams(graspid).tcp(2,:)],...
% %             [obj2state_initwithik.graspparams(graspid).fgrcenter(3,:);obj2state_initwithik.graspparams(graspid).tcp(3,:)],...
% %             'linestyle','-','linewidth',2,'color',[.3,.5,.3]);
% %         hironxcp = movergtjnts7sim(hironxcp,...
% %             obj2state_initwithik.graspparams(graspid).bodyyaw1, ...
% %             obj2state_initwithik.graspparams(graspid).rgtjnts1);
% %         plothironx(hironxcp, [1,0.2,0.2], 0);
%         drawnow;
%     end
% end

%% assembled objects
obj1state = assemsgl.obj1state;
obj2state = assemsgl.obj2state;

obj1p = [0.35;0.2;-0.05];
obj1R = eye(3,3);
obj1state_assem = moveinterstate(obj1state, obj1p, obj1R);
obj2state_assem = moveinterstate(obj2state, obj2state.placementp+obj1p, obj1R*obj2state.placementR);

% plothironx(hironx);
% plotactiveobj(obj1state_assem, [0.8, .6, 0]);
% 
% obj1state_assemwithik = spawnrgtik(hironx, obj1state_assem);
% for i = 1:size(obj1state_assemwithik.graspparams, 1)
%     graspid = i;
%     if isfield(obj1state_assemwithik.graspparams(graspid), 'bodyyaw');
%         hironxcp = hironx;
%         hironxcp = movergtjnts7sim(hironxcp, ...
%             obj1state_assemwithik.graspparams(graspid).bodyyaw, ...
%             obj1state_assemwithik.graspparams(graspid).rgtjnts);
%         plothironx(hironxcp, 'b', 0);
% %         hironxcp = movergtjnts7sim(hironxcp, ...
% %             obj1state_assemwithik.graspparams(graspid).bodyyaw1, ...
% %             obj1state_assemwithik.graspparams(graspid).rgtjnts1);
% %         plothironx(hironxcp, [1,0.2,0.2], 0);
%         drawnow;
%     end
% end

%%
% plothironx(hironx);
plotactiveobj(obj1state_assem, [0.8, .6, 0]);
plotactiveobj(obj2state_assem, [.3, .5, .3]);
obj2state_assemwithik = spawnrgtik(hironx, obj2state_assem);
for i = 1:1
    graspid = i;
%     if isfield(obj1state_assemwithik.graspparams(graspid), 'bodyyaw');
        hironxcp = hironx;
        hironxcp = movergtjnts7sim(hironxcp, ...
            obj2state_assemwithik.graspparams(graspid).bodyyaw, ...
            obj2state_assemwithik.graspparams(graspid).rgtjnts);
        plothironx(hironxcp, 'b', 0);
%         plot3([obj2state_assemwithik.graspparams(graspid).fgrcenter(1,:);obj2state_assemwithik.graspparams(graspid).tcp(1,:)],...
%             [obj2state_assemwithik.graspparams(graspid).fgrcenter(2,:);obj2state_assemwithik.graspparams(graspid).tcp(2,:)],...
%             [obj2state_assemwithik.graspparams(graspid).fgrcenter(3,:);obj2state_assemwithik.graspparams(graspid).tcp(3,:)],...
%             'linestyle','-','linewidth',2,'color',[.3,.5,.3]);
%         hironxcp = movergtjnts7sim(hironxcp, ...
%             obj2state_assemwithik.graspparams(graspid).bodyyaw1, ...
%             obj2state_assemwithik.graspparams(graspid).rgtjnts1);
%         plothironx(hironxcp, [1,0.2,0.2], 0);
        drawnow;
%     end
end