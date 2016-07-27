function interstatesikprggrp = spawnrgtikppgrp(hironx, interstate, varargin)
% spawn two pregrasp state and associate it with the feasible ik solutions (7dof)
% rgt - right arm
% the retraction along approaching direction is also computed in this func
% the order is 1-prg 2-grp 3-prepre
%
% input
% ----
% - hironx - the data structure of the robot
% - interstate - the intermediate state computed by calcgrasps
% - varargin -
%   - varargin{1}: objp - 3by1 array indicating the x,y,z pos of the placement
%   - varargin{2}: objR - 3by3 array indicating the orientation of the placement
%   - varargin{3}: ppD - scalar the retraction distance
%
% output
% ----
% - interstatesikprg2grp - the spawned interstates, it is a tuple
% the first one is pregrasp state, the second one is the grasp state
%
% author: Weiwei
% date: 20160309

    if nargin == 3
        obj1p = varargin{1};
        obj1R = eye(3,3);
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    if nargin == 4
        obj1p = varargin{1};
        obj1R = varargin{2};
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    ppD = 0.1;
    if nargin == 5
        obj1p = varargin{1};
        obj1R = varargin{2};
        ppD = varargin{3};
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    interstatesikprggrp = [interstate;interstate;interstate];
    
    % % % % filter ik
    hironxcp = hironx;
    graspidtodelete = [];
    for k = 1:size(interstatesikprggrp(2).graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatesikprggrp(2).graspparams(k).fgrcenter,...
            [interstatesikprggrp(2).graspparams(k).handx,...
            interstatesikprggrp(2).graspparams(k).handy,...
            interstatesikprggrp(2).graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatesikprggrp(2).graspparams(k).bodyyaw = bodyyaw;
            interstatesikprggrp(2).graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatesikprggrp(2).graspparams(graspidtodelete) = [];
    interstatesikprggrp(2).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(1).graspparams(graspidtodelete) = [];
    interstatesikprggrp(1).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(3).graspparams(graspidtodelete) = [];
    interstatesikprggrp(3).graspparamids(graspidtodelete) = [];
    
    % % % % filter ik for the primitve
    graspidtodelete = [];
    for k = 1:size(interstatesikprggrp(1).graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatesikprggrp(1).graspparams(k).fgrcenter+...
            0.05*interstatesikprggrp(1).graspparams(k).handx,...
            [interstatesikprggrp(1).graspparams(k).handx,...
            interstatesikprggrp(1).graspparams(k).handy,...
            interstatesikprggrp(1).graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatesikprggrp(1).graspparams(k).bodyyaw = bodyyaw;
            interstatesikprggrp(1).graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatesikprggrp(2).graspparams(graspidtodelete) = [];
    interstatesikprggrp(2).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(1).graspparams(graspidtodelete) = [];
    interstatesikprggrp(1).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(3).graspparams(graspidtodelete) = [];
    interstatesikprggrp(3).graspparamids(graspidtodelete) = [];
    
    % % % % reset the coordinates of interstatesikret(1)
    % % % % no changes in stablemesh
    ngrpspup = size(interstatesikprggrp(1).graspparams, 1);
    for k = 1:ngrpspup
       interstatesikprggrp(1).graspparams(k).tcp = ...
           interstatesikprggrp(1).graspparams(k).tcp+...
           0.05*interstatesikprggrp(1).graspparams(k).handx;
       interstatesikprggrp(1).graspparams(k).fgr1 = ...
           interstatesikprggrp(1).graspparams(k).fgr1+...
           0.05*interstatesikprggrp(1).graspparams(k).handx;
       interstatesikprggrp(1).graspparams(k).fgr2 = ...
           interstatesikprggrp(1).graspparams(k).fgr2+...
           0.05*interstatesikprggrp(1).graspparams(k).handx;
       interstatesikprggrp(1).graspparams(k).fgrcenter = ...
           interstatesikprggrp(1).graspparams(k).fgrcenter+...
           0.05*interstatesikprggrp(1).graspparams(k).handx;
       interstatesikprggrp(1).graspparams(k).vertpalm = ...
           bsxfun(@plus, interstatesikprggrp(1).graspparams(k).vertpalm',...
           0.05*interstatesikprggrp(1).graspparams(k).handx)';
       interstatesikprggrp(1).graspparams(k).vertfgr1 = ...
           bsxfun(@plus, interstatesikprggrp(1).graspparams(k).vertfgr1',...
           0.05*interstatesikprggrp(1).graspparams(k).handx)';
       interstatesikprggrp(1).graspparams(k).vertfgr2 = ...
           bsxfun(@plus, interstatesikprggrp(1).graspparams(k).vertfgr2',...
           0.05*interstatesikprggrp(1).graspparams(k).handx)';
    end
    
    % % % % filter ik for the prepre
    graspidtodelete = [];
    for k = 1:size(interstatesikprggrp(3).graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatesikprggrp(3).graspparams(k).fgrcenter+...
            0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1],...
            [interstatesikprggrp(3).graspparams(k).handx,...
            interstatesikprggrp(3).graspparams(k).handy,...
            interstatesikprggrp(3).graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatesikprggrp(3).graspparams(k).bodyyaw = bodyyaw;
            interstatesikprggrp(3).graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatesikprggrp(2).graspparams(graspidtodelete) = [];
    interstatesikprggrp(2).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(1).graspparams(graspidtodelete) = [];
    interstatesikprggrp(1).graspparamids(graspidtodelete) = [];
    interstatesikprggrp(3).graspparams(graspidtodelete) = [];
    interstatesikprggrp(3).graspparamids(graspidtodelete) = [];
    
    % % % % reset the coordinates of interstatesikret(1)
    % % % % no changes in stablemesh
    ngrpspup = size(interstatesikprggrp(3).graspparams, 1);
    for k = 1:ngrpspup
       interstatesikprggrp(3).graspparams(k).tcp = ...
           interstatesikprggrp(3).graspparams(k).tcp+...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1];
       interstatesikprggrp(3).graspparams(k).fgr1 = ...
           interstatesikprggrp(3).graspparams(k).fgr1+...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1];
       interstatesikprggrp(3).graspparams(k).fgr2 = ...
           interstatesikprggrp(3).graspparams(k).fgr2+...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1];
       interstatesikprggrp(3).graspparams(k).fgrcenter = ...
           interstatesikprggrp(3).graspparams(k).fgrcenter+...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1];
       interstatesikprggrp(3).graspparams(k).vertpalm = ...
           bsxfun(@plus, interstatesikprggrp(3).graspparams(k).vertpalm',...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1])';
       interstatesikprggrp(3).graspparams(k).vertfgr1 = ...
           bsxfun(@plus, interstatesikprggrp(3).graspparams(k).vertfgr1',...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1])';
       interstatesikprggrp(3).graspparams(k).vertfgr2 = ...
           bsxfun(@plus, interstatesikprggrp(3).graspparams(k).vertfgr2',...
           0.05*interstatesikprggrp(3).graspparams(k).handx+ppD*[0;0;1])';
    end
end

