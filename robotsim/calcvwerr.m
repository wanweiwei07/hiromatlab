function err = calcvwerr( ulink, pt, Rt )
% calculate the difference between current and target position and orientation
% 
% input
% ------------
% - ulink - the data structure of robot links
% - pt - position of target jnt, [x, y, z]'
% - Rt - orientation of target jnt, 3-by-3 rotation matrix
% 
% output
% ------------
% - err - delta p; deltaw, 6-by-1 vector
%
% author: Weiwei
% date: 20160218

    deltap = pt - ulink(7).ep;
    deltaR = Rt*ulink(7).R';
    
    anglesum = trace(deltaR);
    if anglesum == 3
        deltaw = [0, 0, 0]';
    else
        theta = acos((anglesum -1)/2);
        deltaw = theta/(2*sin(theta))*[deltaR(3, 2) - deltaR(2, 3), deltaR(1, 3) - deltaR(3, 1), deltaR(2, 1) - deltaR(1, 2)]';
    end
    
    err = [deltap; deltaw];

end