function [isdone, lftjnts, trajlftjnts] = numlftik(lftarm, pos, dcm)
% compute the jntid jnt of lftarm with tcp = pos, quaternion
%
% input
% ----------
% - lftarm - the data structure of robot links
% - pos - position of jnt, 3-by-1, [x, y, z]
% - dcm - the [handx, handy, handz] rotation mat of tcp
%
% output
% ----------
% - isdone - if the ik is available
% - lftjnts - the left arm joint values in degree
% - trajlftjnts - the sequence of lftarm jnts on the trajectory of motion
%
% author: Weiwei
% date: 20160218

    isdone = 0;
    lftjnts = [];
    trajlftjnts = [];

    % stablizor
    lambda = 0.5;
    
    % convert data format
    pt = pos;
    Rt = dcm;
    
    lftarmcp = lftarm;
    for n = 1:500
        J = calcjacobian(lftarmcp);
        if abs(det(J)) > 1e-6
            err = calcvwerr(lftarmcp, pt, Rt');
            dq = lambda*(J\err);
        else
            disp('J is at singularity, stopped at non-singular point.');
            return;
        end
        if norm(err) < 1e-6
            if chklftrng(lftarmcp) == 0
                return;
            end
            isdone = 1;
            lftjnts = readjoints6sim(lftarmcp);
            return;
        end
        for i = 2:7
           lftarmcp(i).q = lftarmcp(i).q + dq(i-1);
        end
        
        % % check all ik during iteration
        % this must be done if trajpath was to be used
        % if chkrng(rgtarmcp) == 0
        %     return;
        % end
        
        % non-singularity
        lftarmcp = updatelftarm(lftarmcp);

        % plot
%         plotobjrobot(ulink);
%         pause(0.2);
        trajlftjnts = [trajlftjnts; lftarm];
    end
    
end

