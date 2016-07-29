function isdone = playpose(hirosock, handrqcon, keypose, varargin)
% move the robot to a keypose which is obtained using the robosim regrasp
% planner
%
% input
%----------
% - hirosock - the socket object where users send command to
% - keypose - the definition is in searchrgtkeyposes of robotsim package
% - varargin{1} - time
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160721

    motiontime = 4.0;
    if nargin == 4
        motiontime = 3.0;
    end

    %% set hand
    if strcmp(keypose.graspparams(1).handstate, 'open')
        openrqhandto(handrqcon, 85);
    end
    if strcmp(keypose.graspparams(1).handstate, 'close')
        openrqhandto(handrqcon, 0);
    end

    %% move rightarmjoints7
    rjntspd = [keypose.graspparams(1).bodyyaw, keypose.graspparams(1).rgtjnts, motiontime];
    isdone = movergtjnts7(hirosock, rjntspd);

    
end