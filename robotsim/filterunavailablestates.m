function graphstates = filterunavailablestates(graphstates)
% filter the updown and prggrp to make the grasps corresponding to the same
% graps id are available at both of them
% a major revision is done to incoporate the prepregrasp
%
% input
% ----
% - graphstates - this function is run beore regraspgraph
% tomake life esaiser, graphstates are taken as the input
%
% output
% ----
% - graphstates - the graphstates with filtered values
%
% author: Weiwei
% date: 20160314
% date: 20160722
    
    nstates = size(graphstates, 1);
    for i = 1:nstates
        [Lia, Locb] = ismember(graphstates{i}.ikprggrp(1).graspparamids, graphstates{i}.ikupdown(1).graspparamids);
        graphstates{i}.ikprggrp(1).graspparamids = graphstates{i}.ikprggrp(1).graspparamids(Lia);
        graphstates{i}.ikprggrp(1).graspparams = graphstates{i}.ikprggrp(1).graspparams(Lia);
        graphstates{i}.ikprggrp(2).graspparamids = graphstates{i}.ikprggrp(2).graspparamids(Lia);
        graphstates{i}.ikprggrp(2).graspparams = graphstates{i}.ikprggrp(2).graspparams(Lia);
        if size(graphstates{i}.ikprggrp,1)>2
            % temporary for the prepregrasp
            graphstates{i}.ikprggrp(3).graspparamids = graphstates{i}.ikprggrp(3).graspparamids(Lia);
            graphstates{i}.ikprggrp(3).graspparams = graphstates{i}.ikprggrp(3).graspparams(Lia);
        end
        graphstates{i}.ikupdown(1).graspparamids = graphstates{i}.ikupdown(1).graspparamids(Locb(Locb~=0));
        graphstates{i}.ikupdown(1).graspparams = graphstates{i}.ikupdown(1).graspparams(Locb(Locb~=0));
        graphstates{i}.ikupdown(2).graspparamids = graphstates{i}.ikupdown(2).graspparamids(Locb(Locb~=0));
        graphstates{i}.ikupdown(2).graspparams = graphstates{i}.ikupdown(2).graspparams(Locb(Locb~=0));
    end

end