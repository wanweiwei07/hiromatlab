function J = calcjacobian(armlink)
% calculate the jacobian matrix of jnt1~jntid
%
% input
% -----------
% - armlink - the data structure of robot links
%
% output
% -----------
% - J - the jacobian matrix
%
% author: Weiwei
% date: 20160218
    
    J = zeros(6, 6);
    for n = 2:7
        a = armlink(n).R * armlink(n).a;
        J(:, n-1) = [cross(a, armlink(7).p - armlink(n).p); a];
    end

end

