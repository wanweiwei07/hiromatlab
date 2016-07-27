function dualgp = getdualgrasppairs(interstate1, interstate2)
% remove the grasps from the two states that collide with each other
%
% input
% ----
% - interstate1 - a data structure that indicates one interstate
% - interstate1 - a data structure that indicates another interstate
%
% output
% ----
% - dualgp - the grasp pairs where one is the index from interstate1,
% the other is the index from interstate2
%
% author: Weiwei
% date: 20160304

    dualgp = [];

    ninterstate1grasps = size(interstate1.graspparams, 1);
    ninterstate2grasps = size(interstate2.graspparams, 1);
    
    for i = 1:ninterstate1grasps
        hand1.vertpalm = interstate1.graspparams(i).vertpalm;
        hand1.f3palm = interstate1.graspparams(i).f3palm;
        hand1.vertfgr1 = interstate1.graspparams(i).vertfgr1;
        hand1.f3fgr1 = interstate1.graspparams(i).f3fgr1;
        hand1.vertfgr2 = interstate1.graspparams(i).vertfgr2;
        hand1.f3fgr2 = interstate1.graspparams(i).f3fgr2;
        for j = 1:ninterstate2grasps
            hand2.vertpalm = interstate2.graspparams(j).vertpalm;
            hand2.f3palm = interstate2.graspparams(j).f3palm;
            hand2.vertfgr1 = interstate2.graspparams(j).vertfgr1;
            hand2.f3fgr1 = interstate2.graspparams(j).f3fgr1;
            hand2.vertfgr2 = interstate2.graspparams(j).vertfgr2;
            hand2.f3fgr2 = interstate2.graspparams(j).f3fgr2;
            if ~iscdgtwohandmodels(hand1, hand2)
                % it seems we need to save the pair rather than a single
                % one
                dualgp = [dualgp;[i,j]];
            end
        end
    end
    
end