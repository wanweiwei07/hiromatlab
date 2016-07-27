function rgtarm = updatergtarm(rgtarm)
% update the positions of different joints
% namely forward kinematics
%
% input
% -----------
% - rgtarm - the data structure of right arm links
%
% author: Weiwei
% date: 20160217

    rgtarm(1).p = [0, 0, 0]';
    rgtarm(1).ep = rgtarm(1).R*rgtarm(1).b + rgtarm(1).p;
    i = 2;
    while i ~= 0
        j = rgtarm(i).mother;
        rgtarm(i).p = rgtarm(j).ep;
        rgtarm(i).R = rgtarm(j).R * rodrigues(rgtarm(i).a, rgtarm(i).q);
        rgtarm(i).ep = rgtarm(i).R * rgtarm(i).b + rgtarm(i).p;
        i = rgtarm(i).child;
    end

end

