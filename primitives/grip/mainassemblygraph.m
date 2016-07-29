load data/interairl.mat
load data/interairtri.mat
load data/interairz3d.mat
load data/interairt.mat

relpos = {[0;0;0.015];...
          [0.0375;0.0075;0.0225];...
          [0.015;0.0225;-0.0225]};
relrot = {rodrigues([1;0;0], pi/2);...
          rodrigues([1;0;0], pi/2);...
          rodrigues([1;0;0], pi/2)*rodrigues([0;0;1], pi/2)};
interairs = [interairt; interairz3d; interairtri];
intercolors = [[0.6,0.85,0.95];[0.55, 0.2, 0.9];[0.1, 0.6, 0.1]];

[abspos, absrot] = computeassemabspose(relpos, relrot);
nobjects = size(interairs, 1);
interstates = interairs;
for i = 1:nobjects
    interstates(i) = moveinterstate(interairs(i), abspos{i}, absrot{i});
end

% plotinterstates(interstates(1), 'none', intercolors(1,:));
% plotinterstates(interstates(2), 'none', intercolors(2,:));
% plotinterstates(interstates(3), 'none', intercolors(3,:));

% obstacle is planery surface
obstacles = [];
tableverts = [[0.5, 0.5, 0]; [-0.5, 0.5, 0]; ...
        [-0.5, -0.5, 0]; [0.5, -0.5, 0]];
tablefaces = [[1, 2, 3]; [3, 4, 1]];
tableobstacle.verts = tableverts;
tableobstacle.faces = tablefaces;
[tablepcd, tablepcdnormals] = cvtpcd(tableverts, tablefaces, 10000, 0.001);
obstacles = cat(1, obstacles, tableobstacle);

% number of objects in the assembly
objidlist = 1:nobjects;
assemorder = perms(objidlist);
norder = size(assemorder, 1);

%{
% plot the orders
for i = 1:norder
    figure;
    for j = 1:nobjects;
        subplot(1, nobjects, j);
        for k = 1:j
            objid = assemorder(i, k);
            interstate = interstates(objid);
            plotinterstates(interstate, 'none', intercolors(objid,:));
            drawnow;
        end
    end
    drawnow;
end
%}

% first filter, check if the assembled structure is stable
figure(20000);
otlpcd = tablepcd;
otlpcdnormals = tablepcdnormals;
isstablelist = ones(norder, nobjects);
creditsfromsquality = zeros(norder, nobjects);
for i = 1:norder
    subplot(3, norder/3+1, i);
    disp([num2str(i), '/', num2str(norder)]);
    objid = assemorder(i, 1);
    interstate = interstates(objid);
    [isstable, quality, supportpolygon] = checkassemstabilitypcd([], ...
        [], interstate, otlpcd, otlpcdnormals);
    figure(20000);
    subplot(3, norder/3+1, i);
    isstablelist(i, 1) = isstable;
    creditsfromsquality(i, 1) = quality;
    plotinterstates(interstate, 'none', intercolors(objid,:), 'k');
    text(0,0,0.25, ['Stability ', num2str(creditsfromsquality(i, 1))]);
    if ~isempty(supportpolygon)
        plot(supportpolygon(:,1),...
            supportpolygon(:,2), '.-', 'color', ...
            'k', 'markersize', 10, 'linewidth', 3);
    end
    drawnow;
end
for iassemobj = 2:nobjects
    figure(20000+iassemobj);
    disp([num2str(iassemobj), '/', num2str(nobjects)]);
    for i = 1:norder
        if(isstablelist(i, iassemobj-1))
            disp([num2str(i), '/', num2str(norder)]);
            subplot(3, norder/3+1, i);
            objs1id = [];
            interstates1 = [];
            interstates1pcd = [];
            interstates1pcdnormals = [];
            for j = 1:iassemobj-1
                obj1id = assemorder(i,j);
                objs1id = cat(1, objs1id, obj1id);
                interstates1 = cat(1, interstates1, interstates(obj1id));
                interstates1pcd = cat(1, interstates1pcd, ...
                    interstates(obj1id).stablemesh.pcdplus);
                interstates1pcdnormals = cat(1, interstates1pcdnormals, ...
                    interstates(obj1id).stablemesh.pcdnormals);
            end
            obj2id = assemorder(i,iassemobj);
            interstate2 = interstates(obj2id);
            [isstable, quality, supportpolygon] = checkassemstabilitypcd(interstates1pcd, ...
                interstates1pcdnormals, interstate2, otlpcd, otlpcdnormals);
            figure(20000+iassemobj);
            subplot(3, norder/3+1, i);
            isstablelist(i, iassemobj) = isstable;
            creditsfromsquality(i, iassemobj) = quality;
            if(isstable)
                for j = 1:size(objs1id, 1)
                    obj1id = objs1id(j);
                    plotinterstates(interstates1(j), 'none', intercolors(obj1id,:));
                end
                plotinterstates(interstate2, 'none', intercolors(obj2id,:), 'k');
                text(0,0,0.25, ['Stability ', num2str(creditsfromsquality(i, iassemobj))]);
                if ~isempty(supportpolygon)
                    plot(supportpolygon(:,1),...
                        supportpolygon(:,2), '.-', 'color', ...
                        'k', 'markersize', 10, 'linewidth', 3);
                end
            else
                for j = 1:size(objs1id, 1)
                    obj1id = objs1id(j);
                    plotinterstates(interstates1(j), 'none', 'k');
                end
                plotinterstates(interstate2, 'none', 'k');
            end
        end
        drawnow;
    end
end
save data/assemthreeblocks/creditsfromsquality.mat creditsfromsquality;


% second filter, check if the assembled structure has good graspability
figure;
creditsfromgraspability = zeros(size(assemorder));
assemsgl_statescell = cell(size(assemorder));
isgraspablelist = ones(norder, nobjects);
% compute the credits for the first object
figure;
for i = 1:norder
    subplot(3, norder/3+1, i);
    disp([num2str(i), '/', num2str(norder)]);
    objid = assemorder(i, 1);
    interstate = interstates(objid);
    interstateupdated = removecdgmeta(interstate, otlpcd);
    assemsgl_statescell{i, 1} = interstateupdated;
    creditsfromgraspability(i, 1) = size(interstateupdated.graspparamids, 1);
    isgraspablelist(i, 1) = creditsfromgraspability(i, 1) > 0;
    plotinterstates(interstateupdated, intercolors(objid,:), intercolors(objid,:), 'k');
    text(0,0,0.25, ['Graspability ', num2str(creditsfromgraspability(i, 1))]);
    drawnow;
end
% compute the credits for the other objects
for iassemobj = 2:nobjects
    figure;
    disp([num2str(iassemobj), '/', num2str(nobjects)]);
    for i = 1:norder
        if(isgraspablelist(i, iassemobj-1))
            disp([num2str(i), '/', num2str(norder)]);
            subplot(3, norder/3+1, i);
            objs1id = [];
            interstates1 = [];
            for j = 1:iassemobj-1
                obj1id = assemorder(i,j);
                objs1id = cat(1, objs1id, obj1id);
                interstates1 = cat(1, interstates1, interstates(obj1id));
            end
            obj2id = assemorder(i,iassemobj);
            interstate2 = interstates(obj2id);
            % collect the objpcd for cd (both obj and otl)
            % there is one extra cell to hold the tablepcd
            objotlpcd = [];
            for j = 1:iassemobj-1
                obj1id = assemorder(i,j);
                objotlpcd = cat(1, objotlpcd, interstates(obj1id).stablemesh.pcd);
            end
            objotlpcd = cat(1, objotlpcd, otlpcd);
            interstate2 = removecdgmeta(interstate2, objotlpcd);
            creditsfromgraspability(i, iassemobj) = size(interstate2.graspparamids, 1);
            assemsgl_statescell{i, iassemobj} = interstate2;
            isgraspablelist(i, iassemobj) = creditsfromgraspability(i, iassemobj) > 0;
            for j = 1:size(objs1id, 1)
                obj1id = objs1id(j);
                plotinterstates(interstates1(j), 'none', intercolors(obj1id,:));
            end
            plotinterstates(interstate2, intercolors(obj2id,:), intercolors(obj2id,:), 'k');
            text(0,0,0.25, ['Graspability ', num2str(creditsfromgraspability(i, iassemobj))]);
            drawnow;
        end
    end
end
save data/assemthreeblocks/creditsfromgraspability.mat creditsfromgraspability;
save data/assemthreeblocks/assemsgl_statescell.mat assemsgl_statescell;

% third filter, check if the assembled structure has good assemdirect
creditsfromcompliance = zeros(size(assemorder));
assemdirectscell = cell(size(assemorder));
iscompliantlist = ones(norder, nobjects);
% find the assemdirect and compliance for the first object
figure;
for i = 1:norder
    subplot(3, norder/3+1, i);
    disp([num2str(i), '/', num2str(norder)]);
    objid = assemorder(i, 1);
    interstate = interstates(objid);
    [compliance, assemdirect] = ...
        findassemdirectpcd([], [], interstate, otlpcd, otlpcdnormals);
    creditsfromcompliance(i, 1) = compliance;
    assemdirectscell{i,1} = assemdirect;
    iscompliantlist(i, 1) = compliance > 0;
    assemdirectforplot = assemdirect*0.15;
    plotinterstates(interstate, 'none', intercolors(objid,:), 'k');
    shrinklength = 0.0105;
    checkpcd = otlpcd;
    checkpcdnormals = otlpcdnormals;
    checkpcdfeasibility = checkpcd - checkpcdnormals*shrinklength;
    if compliance
        plotinterstateav(interstate, assemdirect, intercolors(objid,:), 'none', 0.3);
        %{ 
        isfeasible = checkadfeasibility(checkpcdfeasibility, interstate, assemdirect, ...
            intercolors(objid,:), 'none');
        if isfeasible
            quiver3(interstate.placementp(1), interstate.placementp(2), ...
                interstate.placementp(3), ...
                assemdirectforplot(1), assemdirectforplot(2), assemdirectforplot(3), ...
                'color', 'k', 'linewidth', 2);
        else
            quiver3(interstate.placementp(1), interstate.placementp(2), ...
                interstate.placementp(3), ...
                assemdirectforplot(1), assemdirectforplot(2), assemdirectforplot(3), ...
                'color', 'r', 'linewidth', 2);
            creditsfromcompliance(i, 1) = 0;
            iscompliantlist(i, 1) = 0;
        end
        %}
    end
    text(0,0,0.35, ['Assemcompliance ', num2str(creditsfromcompliance(i, 1))]);
    drawnow;
end
for iassemobj = 2:nobjects
    figure;
    disp([num2str(iassemobj), '/', num2str(nobjects)]);
    for i = 1:norder
        if(iscompliantlist(i, iassemobj-1))
            disp([num2str(i), '/', num2str(norder)]);
            subplot(3, norder/3+1, i);
            
            objs1id = [];
            interstates1 = [];
            interstates1pcd = [];
            interstates1pcdnormals = [];
            for j = 1:iassemobj-1
                obj1id = assemorder(i,j);
                objs1id = cat(1, objs1id, obj1id);
                interstates1 = cat(1, interstates1, interstates(obj1id));
                interstates1pcd = cat(1, interstates1pcd, ...
                    interstates(obj1id).stablemesh.pcdplus);
                interstates1pcdnormals = cat(1, interstates1pcdnormals, ...
                    interstates(obj1id).stablemesh.pcdnormals);
            end
            obj2id = assemorder(i,iassemobj);
            interstate2 = interstates(obj2id);
            
            for j = 1:size(objs1id, 1)
                obj1id = objs1id(j);
                plotinterstates(interstates1(j), 'none', intercolors(obj1id,:));
            end
            plotinterstates(interstate2, 'none', intercolors(obj2id,:), 'k');
            
            [compliance, assemdirect] = ...
                findassemdirectpcd(interstates1pcd, interstates1pcdnormals, ...
                interstate2, otlpcd, otlpcdnormals);
            % check assemdirect feasibility
            shrinklength = 0.0105;
            checkpcd = [interstates1pcd; otlpcd];
            checkpcdnormals = [interstates1pcdnormals; otlpcdnormals];
            checkpcdfeasibility = checkpcd - checkpcdnormals*shrinklength;
            
            creditsfromcompliance(i, iassemobj) = compliance;
            assemdirectscell{i, iassemobj} = assemdirect;
            iscompliantlist(i, iassemobj) = compliance > 0;
            assemdirectforplot = assemdirect*0.15;
            
            if iscompliantlist(i, iassemobj)
                plotinterstateav(interstate2, assemdirect, intercolors(obj2id,:), 'none', 0.3);
                %{
                isfeasible = checkadfeasibility(checkpcdfeasibility, interstate2, assemdirect, ...
                    intercolors(obj2id,:), 'none');
                if isfeasible
                    quiver3(interstate2.placementp(1), interstate2.placementp(2), ...
                        interstate2.placementp(3), ...
                        assemdirectforplot(1), assemdirectforplot(2), assemdirectforplot(3), ...
                        'color', 'k', 'linewidth', 2);
                else
                    quiver3(interstate2.placementp(1), interstate2.placementp(2), ...
                        interstate2.placementp(3), ...
                        assemdirectforplot(1), assemdirectforplot(2), assemdirectforplot(3), ...
                        'color', 'r', 'linewidth', 2);
                    iscompliantlist(i, iassemobj) = 0;
                    creditsfromcompliance(i, iassemobj) = 0;
                end
                %}
            end
            text(0,0,0.35, ['Assemcompliance ', num2str(creditsfromcompliance(i, iassemobj))]);
            drawnow;
        else
            assemdirectscell{i, iassemobj} = [0,0,0];
        end
    end
end
save data/assemthreeblocks/creditsfromcompliance.mat creditsfromcompliance;
save data/assemthreeblocks/assemdirectscell.mat assemdirectscell;