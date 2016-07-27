function interstatewithik = spawnrgtik(hironx, interstate, varargin)
% spawn a state and associate it with the feasible ik solutions (7dof)
% rgt - right arm
%
% input
% ----
% - hironx - the data structure of the robot
% - interstate - the intermediate state computed by calcgrasps
% - varargin -
%   - varargin{1}: objp - 3by1 array indicating the x,y,z pos of the placement
%   - varargin{2}: objR - 3by3 array indicating the orientation of the placement
%
% output
% ----
% - interstatewithik - the spawned interstate
%
% author: Weiwei
% date: 20160309

    if nargin == 4
        obj1p = varargin{1};
        obj1R = varargin{2};
        % the moveinterstate is a function from calcgrasps
        interstate = moveinterstate(interstate, obj1p, obj1R);
    end
    interstatewithik = interstate;
    % % % % filter ik
    hironxcp = hironx;
    graspidtodelete = [];
    for k = 1:size(interstatewithik.graspparams,1)
        [isdone, bodyyaw, rgtjnts, trajpath] = numrgt7ik(...
            hironxcp, interstatewithik.graspparams(k).fgrcenter,...
            [interstatewithik.graspparams(k).handx,...
            interstatewithik.graspparams(k).handy,...
            interstatewithik.graspparams(k).handz]');
        if ~isdone
            graspidtodelete = [graspidtodelete; k];
        else
            interstatewithik.graspparams(k).bodyyaw = bodyyaw;
            interstatewithik.graspparams(k).rgtjnts = rgtjnts;
        end
    end
    interstatewithik.graspparams(graspidtodelete) = [];
    interstatewithik.graspparamids(graspidtodelete) = [];
end

