function lftarm = updatelftarm(lftarm)
% update the positions of different joints
% namely forward kinematics
%
% input
% -----------
% - lftarm - the data structure of left arm links
%
% author: Weiwei
% date: 20160217

    lftarm(1).p = [0, 0, 0]';
    lftarm(1).ep = lftarm(1).R*lftarm(1).b + lftarm(1).p;
    i = 2;
    while i ~= 0
        j = lftarm(i).mother;
        lftarm(i).p = lftarm(j).ep;
        lftarm(i).R = lftarm(j).R * rodrigues(lftarm(i).a, lftarm(i).q);
        lftarm(i).ep = lftarm(i).R * lftarm(i).b + lftarm(i).p;
        i = lftarm(i).child;
    end

end

