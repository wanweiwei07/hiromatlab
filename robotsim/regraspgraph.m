function [dg, regraspgraph] = regraspgraph(placements)
% create the regraspgraph
%
% input
% ----
% - placements - placements, the two elements are start and end
%
% output
% ----
% - dg - the directed graph to be used for graph search
% - regraspgraph - a structure including connect pairs
%
% author: Weiwei
% date: 20160222

    nplacements = size(placements, 1);
    [istart, iend] = meshgrid(1:nplacements);
    istart = istart(:);
    iend = iend(:);
    npairs = size(istart, 1);
    connectids = [];
    connectedges = cell(npairs, 1);

    for ipair = 1:npairs
        i = istart(ipair);
        j = iend(ipair);
        
        if i == j
            continue;
        end

        [Lia, Locb] = ismember(placements{i}.ikprggrp(2).graspparamids, ...
            placements{j}.ikprggrp(2).graspparamids);
        graspida = find(Lia);
        ngraspida = size(graspida, 1);
        graspidb = Locb(Locb~=0);

        if ngraspida == 0
            continue;
        end

        connectids = [connectids; ipair];
        connectedges{ipair} = [];
        for iedge = 1:ngraspida
            connectedges{ipair} = [connectedges{ipair}; [graspida(iedge), graspidb(iedge)]];
        end
    end
    
    % connectpairs is the id of graph circles
    % connectededges is the id of grasps in the state's local list
    regraspgraph.connectpairs = [istart(connectids), iend(connectids)];
    regraspgraph.connectedges = connectedges(connectids);
    regraspgraph.states = placements;
    
    dgw = ones(size(regraspgraph.connectpairs, 1), 1);
    dg = sparse(regraspgraph.connectpairs(:,1), regraspgraph.connectpairs(:, 2), dgw);
    ids = {'S', 'G'};
    for i = 3:size(dg, 1)
        ids{i} = ['P', num2str(i-2)];
    end
    dg = digraph(dg, ids);
end

