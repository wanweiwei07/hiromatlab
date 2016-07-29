function interstatesikupdown = spawnrgtikupdownassemdirec(hironx, interstate, assemdirec, varargin)
% spawn a pickup state and associate it with the feasible ik solutions (7dof)
% rgt - right arm
% the retraction along approaching direction assemdirec?is computed in this func
%
% input
% ----
% - hironx - the data structure of the robot
% - interstate - the intermediate state computed by calcgrasps
% - assemdirec - 1by3 vector
% - varargin -
%   - varargin{1}: objp - 3by1 array indicating the x,y,z pos of the placement
%   - varargin{2}: objR - 3by3 array indicating the orientation of the placement
%   - varargin{3}: upD - scalar the retraction distance
%
% output
% ----
% - interstatesikup2down - the spawned interstates, it is a tuple
% the first one is up state, the second one is the down state
%
% author: Weiwei
% date: 20160729

    if nargin == 4
        obj1p = varargin{1};
        obj1R = eye(3,3);
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    if nargin == 5
        obj1p = varargin{1};
        obj1R = varargin{2};
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    upD = 0.1;
    if nargin == 6
        obj1p = varargin{1};
        obj1R = varargin{2};
        upD = varargin{3};
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    interstatesikupdown = [interstate;interstate];
    
    % % % % filter ik for the down state
    hironxcp = hironx;
    graspidtodelete = [];
    for k = 1:size(interstatesikupdown(2).graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatesikupdown(2).graspparams(k).fgrcenter,...
            [interstatesikupdown(2).graspparams(k).handx,...
            interstatesikupdown(2).graspparams(k).handy,...
            interstatesikupdown(2).graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatesikupdown(2).graspparams(k).bodyyaw = bodyyaw;
            interstatesikupdown(2).graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatesikupdown(2).graspparams(graspidtodelete) = [];
    interstatesikupdown(2).graspparamids(graspidtodelete) = [];
    interstatesikupdown(1).graspparams(graspidtodelete) = [];
    interstatesikupdown(1).graspparamids(graspidtodelete) = [];
    
    % % % % filter ik for the up state
    graspidtodelete = [];
    for k = 1:size(interstatesikupdown(1).graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatesikupdown(1).graspparams(k).fgrcenter+...
            upD*assemdirec',...
            [interstatesikupdown(1).graspparams(k).handx,...
            interstatesikupdown(1).graspparams(k).handy,...
            interstatesikupdown(1).graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatesikupdown(1).graspparams(k).bodyyaw = bodyyaw;
            interstatesikupdown(1).graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatesikupdown(2).graspparams(graspidtodelete) = [];
    interstatesikupdown(2).graspparamids(graspidtodelete) = [];
    interstatesikupdown(1).graspparams(graspidtodelete) = [];
    interstatesikupdown(1).graspparamids(graspidtodelete) = [];
    
    % % % % reset the coordinates of interstatesikret(1)
    % % % % changes in stablemesh included
    interstatesikupdown(1) = ...
        moveinterstaterel(interstatesikupdown(1), upD*assemdirec', eye(3,3));
end

