% ! NOT WORKING

function [isdone, q] = anargtik(rgtarm, gripper, pt, Rt, varargin)
% check whether the joint angles q are inside working range
% direct ik is implemented in this function
%
% input
% ----------
% - rgtarm - the data structure of robot links
%
% output
% ----------
% - isdone - boolean var denoting the result
% - q - a list of angles in degree
%
% author: weiwei
% date: 20160218

    isdone = 1;
    q = [];
    bdbox = [];
    handarm = [];
    
    safemargin = 5;
    bodyyawmin = -(163-safemargin);
    bodyawmax = +(163-safemargin);
    rgt1min = -(88-safemargin);
    rgt1max = +(88-safemargin);
    rgt2min = -(140-safemargin);
    rgt2max = +(60-safemargin);
    rgt3min = -(158-safemargin);
    rgt3max = +(0-safemargin);
    rgt4min = -(165-safemargin);
    rgt4max = +(105-safemargin);
    rgt5min = -(100-safemargin);
    rgt5max = +(100-safemargin);
    rgt6min = -(163-safemargin);
    rgt6max = +(163-safemargin);

    % copy rgt to avoid modification
    rgtarmcp = rgtarm;
    rgtarmcp(1).q = 0;
    rgtarmcp(2).q = 0;
    rgtarmcp(3).q = 0;
    rgtarmcp(4).q = 0;
    rgtarmcp(5).q = 0;
    rgtarmcp(6).q = 0;
    rgtarmcp(7).q = 0;
    [rgtarmcp, gripper] = updatergtarm(rgtarmcp, gripper);
    Initspherical = ulinkcp(7).R;

    % find the pos of joint 6
    pos6 = pt + 0.12*Rt(:, 3);

    % direct ik
    % j1 
    dx1 = pos6(1) - rgtarmcp(2).p(1);
    dy1 = pos6(2) - rgtarmcp(2).p(2);
    q(1) = atan(dx1/dy1);
    if dy1 > 0
        q(1) = pi-q(1);
    else
        if dx1 < 0 && dy1 > 0
            q(1)= q(1)-pi;
        end
    end
    rgtarmcp(2).q = q(1);
    [rgtarmcp, gripper] = updatergtarm(rgtarmcp, gripper);
    
    % j2
    d26 = norm(pos6 - rgtarmcp(3).p);
    l3 = 360;
    l45 = 380;
    angle3and26 = acos((l45^2-l3^2-d26^2)/-(2*l3*d26));
    h6 = pos5(3) - ulinkcp(3).p(3);
    angle26andfloor = asin(h6/d26);
    q(2) = pi/2 - (angle3and26 + angle26andfloor);
    if q(2) < rng2min || q(2) > rng2max || ~isreal(q(2))
        if isempty(varargin)
            disp(['jnt2 out of range, value is ', num2str(q(2)*180/pi), '; rng is ', num2str(rng2min*180/pi), '~', num2str(rng2max*180/pi)]);
        end
        bpass = 0;
        q = [];
        bdbox = [];
        return;
    end

    % j3
    angle3and45 = acos((d26^2-l3^2-l45^2)/-(2*l3*l45));
    q(3) = pi/2 - angle3and45;
    if q(3) < rng3min || q(3) > rng3max || ~isreal(q(3))
        if isempty(varargin)
            disp(['jnt3 out of range, value is ', num2str(q(3)*180/pi), '; rng is ', num2str(rng3min*180/pi), '~', num2str(rng3max*180/pi)]);
        end
        bpass = 0;
        q = [];
        bdbox = [];
        return;
    end

    ulinkcp(3).q = q(2);
    ulinkcp(4).q = q(3);
    [ulinkcp, gripper] = updatefkg(ulinkcp, gripper);

    Rtspherical = ulinkcp(7).R'*Rt;
    Rdiff = Rtspherical*Initspherical';
    % j4
    [q(6), q(5), q(4)] = dcm2angle(Rdiff, 'ZXY');
    q(6) = -q(6);
    q(5) = -q(5);
    if q(5) < rng5min || q(5) > rng5max || ~isreal(q(5))
        if isempty(varargin)
            disp(['jnt5 out of range, value is ', num2str(q(5)*180/pi), '; rng is ', num2str(rng5min*180/pi), '~', num2str(rng5max*180/pi)]);
        end
        bpass = 0;
        q = [];
        bdbox = [];
        return;
    end
    ulinkcp(5).q = q(4);
    ulinkcp(6).q = q(5);
    ulinkcp(7).q = q(6);
    [ulinkcp, gripper] = updatefkg(ulinkcp, gripper);
% 	plotobjrobot(ulinkcp, gripper);

    global olink;
    bdbox.vertices = ulinkcp(11).R*olink(11).V;
    bdbox.vertices = bsxfun(@plus, bdbox.vertices', ulinkcp(11).ep');
    bdbox.faces = olink(11).F3';
    
    handarm(1).vertices = ulinkcp(10).R*olink(10).V;
    handarm(1).vertices = bsxfun(@plus, handarm(1).vertices', ulinkcp(9).ep');
    handarm(1).faces = olink(10).F3';
    handarm(2).vertices = ulinkcp(9).R*olink(9).V;
    handarm(2).vertices = bsxfun(@plus, handarm(2).vertices', ulinkcp(8).ep');
    handarm(2).faces = olink(9).F3';
    handarm(3).vertices = ulinkcp(8).R*olink(8).V;
    handarm(3).vertices = bsxfun(@plus, handarm(3).vertices', ulinkcp(7).ep');
    handarm(3).faces = olink(8).F3';
    handarm(4).vertices = ulinkcp(5).R*olink(5).V;
    handarm(4).vertices = bsxfun(@plus, handarm(4).vertices', ulinkcp(4).ep');
    handarm(4).faces = olink(5).F3';
%     
%     h4 = patch(handarm(4), 'facecolor', 'w');
%     set(h4, 'facealpha', 0.9);
%     %         set(h4, 'edgealpha', .3);
%     set(h4, 'edgecolor', 'm');
%     set(h4, 'linestyle', '-');
% 
%     pause(0.5);
%     delete(h4);

end

