function [isdone, rgtjnts, trajrgtjnts] = numrgtik(rgtarm, pos, dcm)
% compute the jntid jnt of rgtarm with tcp = pos, quaternion
%
% input
% ----------
% - rgtarm - the data structure of robot links
% - pos - position of jnt, 3-by-1, [x, y, z]
% - dcm - the [handx, handy, handz] rotation mat of tcp
%
% output
% ----------
% - isdone - if the ik is available
% - rgtjnts - the right arm joint values in degree
% - trajrgtjnts - the sequence of rgtarm joints on the trajectory of motion
%
% author: Weiwei
% date: 20160218

    isdone = 0;
    rgtjnts = [];
    trajrgtjnts = [];

    % stablizor
    lambda = 0.5;
    
    % convert data format
    pt = pos;
    Rt = dcm;
    
    rgtarmcp = rgtarm;
    for n = 1:500
        J = calcjacobian(rgtarmcp);
        if abs(det(J)) > 1e-6
            err = calcvwerr(rgtarmcp, pt, Rt');
            dq = lambda*(J\err);
        else
            disp('J is at singularity, stopped at non-singular point.');
            return;
        end
        if norm(err) < 1e-6
            if chkrgtrng(rgtarmcp) == 0
                return;
            end
            isdone = 1;
            rgtjnts = readjoints6sim(rgtarmcp);
            return;
        end
        for i = 2:7
           rgtarmcp(i).q = rgtarmcp(i).q + dq(i-1);
        end
        
        % % check all ik during iteration
        % this must be done if trajpath was to be used
        % if chkrng(rgtarmcp) == 0
        %     return;
        % end
        
        % non-singularity
        rgtarmcp = updatergtarm(rgtarmcp);

        % plot
%         plotobjrobot(ulink);
%         pause(0.2);
        trajrgtjnts = [trajrgtjnts; readjoints6sim(rgtarmcp)];
    end
    
end

