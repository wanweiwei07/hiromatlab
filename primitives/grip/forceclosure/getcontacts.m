function [ bin, contactpoint, contactnorm ] = getcontacts( fgrv, objv, hndcenter )
% calculate the contactpoints and contactnorm
%
% input
%----------
% - fgrv - the vertices of fingers, they are with respect to 0,0, nfgrvnum-by-2,
%          [x, y], nfgrnum is the number of fingers.
% - objv - the vertices of object, they are with respect to 0,0,
%          nobjvnum-by-2, [x, y], nobjvnum is the number of object vertices.
%          NOTE! the vertices should be arranged in ccw order
% - hndcenter - the center of hand palm, it is with respect to 0,0, 1-by-2, [x, y].
%
% output
%----------
% - bin - whether the hand center is inside object, this value is returned
%         since the polyxpoly function of matlab has a bug in detecting whether
%         a point is in side a polygon or not.
% - contactpoint - position of contactpoints with respect to 0,0, nfgrvnum-by-2, [x, y].
% - contactnorm - direction of force at contactpoints along normal,
%                 nfgrvnum-by-2, [x, y].
%
% author: Weiwei
% date: 20140110

    bin = 1;
    fgrnum = size(fgrv, 1);
    contactnorm = zeros(fgrnum, 2);
    contactpoint = zeros(fgrnum, 2);
    
    % calculate the surface norm of object
    objedges = objv(2:end, :) - objv(1:end-1, :);
    tmatnorm = [[cos(-pi/2), sin(-pi/2)]; [-sin(-pi/2), cos(-pi/2)]];
    normrawv = objedges*(tmatnorm');
    normmagnitude = sqrt(normrawv(:,1).^2+normrawv(:,2).^2);
    normv = [normrawv(:,1)./normmagnitude, normrawv(:,2)./normmagnitude];
    
    for fgrid = 1:fgrnum
        fgrseg = [fgrv(fgrid, :)+hndcenter; hndcenter];
        [interx, intery, interseg] = polyxpoly(fgrseg(:, 1), fgrseg(:, 2), objv(:, 1), objv(:, 2));
        
        % use the nearest intersection as contact point
        mat_hndcenter = repmat(hndcenter, size(interx, 1), 1);
        distall = sum(([interx, intery] - mat_hndcenter).^2, 2);
        [dist, contactid] = min(distall);
        if isempty(dist)
            bin = 0;
            return;
        end
        if dist == 0
            bin = 0;
            return;
        end
        
        contactpoint(fgrid, :) = [interx(contactid), intery(contactid)];
        
        normid = interseg(contactid, 2);
        contactnorm(fgrid, :) = normv(normid, :);
    end

end

