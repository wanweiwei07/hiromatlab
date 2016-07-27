function R = rodrigues(axis, angle)
% calculate the R matrix according to rogrigues formula
%
% input
% -----------
% - axis - rotation axis
% - angle - rotation angle, radian
%
% author: Weiwei
% date: 20160217
    
    axis = axis./norm(axis, 2);
    S = [[0, -axis(3), axis(2)];
         [axis(3), 0, -axis(1)];
         [-axis(2), axis(1), 0]];
    R = eye(3) + sin(angle)*S + (1-cos(angle))*S^2;

end