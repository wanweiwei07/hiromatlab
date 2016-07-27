function [pnts, varargout] = cvtpcd(verts, faces, narea, expandlength)
% create the point cloud of a mesh
%
% narea is
% note: (0, 0) is at the bottom point with minimum moment of intertia.
%
% input
% ----
% - verts, faces - n-by-3
% - narea -  the number per 1 area, usually smaller than 1
% - expandlength - expand the points along normal direction, default 0
%
% output
% ----
% - pnts - n-by-3 discretized point cloud
% - pntsnormals - n-by-3 point normals varargout{1}
%
% author: weiwei
% date: 20160525

    if nargin < 4
        expandlength = 0;
    end

    if size(faces, 2) == 4
        % if rectangular face, cvt to tri
        [faces, ~] = triangulateFaces(faces);
    end
    
    %drawMesh(verts, faces);
    trinum = size(faces, 1);
    pnts = [];
    pntsnormals = [];
    for i = 1:trinum
        p1 = verts(faces(i, 1), :);
        p2 = verts(faces(i, 2), :);
        p3 = verts(faces(i, 3), :);
        ps = [p1; p2; p3];
%         patch(ps(:, 1), ps(:, 2), ps(:, 3), 'r', 'FaceAlpha', 0.2);
%         hold on;
        e21 = p2 - p1;
        e32 = p3 - p2;
%         plot3([e21(:, 1);0], [e21(:, 2);0], [e21(:, 3);0]);
%         plot3([e31(:, 1);0], [e31(:, 2);0], [e31(:, 3);0]);
        
        area = norm(cross(e21, e32));
        pntnormal = cross(e21, e32);
        cnt = 0;
        w1 = [];
        w2 = [];
        w3 = [];
        pntnum = round(area*narea);
        if pntnum == 0
            continue;
        end
        while cnt < pntnum
            r1 = rand(1);
            r2 = rand(1);
            if r1+r2 < 1
                w1 = [w1;r1];
                w2 = [w2;r2];
                w3 = [w3;1-r1-r2];
                cnt = cnt + 1;
            end
        end
        pnt = zeros(pntnum, 3);
        pnt(:, 1) = w1*p1(1) + w2*p2(1) + w3*p3(1);
        pnt(:, 2) = w1*p1(2) + w2*p2(2) + w3*p3(2);
        pnt(:, 3) = w1*p1(3) + w2*p2(3) + w3*p3(3);
        pntnormal = repmat(pntnormal, pntnum, 1);
        pnts = [pnts; [pnt(:, 1), pnt(:, 2), pnt(:, 3)]];
        pntsnormals = [pntsnormals;pntnormal];
    end
    
    pntsnormals = normr(pntsnormals);
    % remove numerical errors
    pntsnormals(abs(pntsnormals)<1e-6) = 0;
    pnts = pnts+pntsnormals*expandlength;
    
    nout = max(nargout,1) - 1;
    k = nout;
    if(k==1)
        varargout{k} = pntsnormals;
    end
    %figure;
    %plot3(pnts(:, 1), pnts(:, 2), pnts(:, 3), '.', 'markersize', 5);
    %axis equal;
end