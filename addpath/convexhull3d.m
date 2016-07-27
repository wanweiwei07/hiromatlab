function varargout = convexhull3d(pts, varargin)
% following angleSort3d
% modified for the minconvexhull function
%
% input
% ----
% - pts - a set of 3d points on the same plane, n-by-3
% 
% output
% ----
% - pts - 3d points which are the 2D convex hull on the input plane, n-by-3
%
% author: weiwei
% date: 20140903


    % create support plane
    plane   = createPlane(pts(1:3, :));
    % project points onto the plane
    pts2d   = planePosition(pts, plane);
    I = convhull(pts2d(:,1),pts2d(:,2));

    % format output
    if nargout<2
        varargout{1} = pts(I, :);
    elseif nargout==2
        varargout{1} = pts(I, :);
        varargout{2} = I;
    end
end