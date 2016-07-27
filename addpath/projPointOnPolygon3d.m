function [isavailable, projectedpoint] = projPointOnPlane3d(point, polygon)
% project a point onto a polygon
%
% input
% ----
% - point - [x,y,z] 1-by-3
% - polygon - [p1;p2;...;pn] n-by-3
%
% output
% ----
% - isavailable - is the point available
% - projectedpoint - [x,y,z] 1-by-3
%
% author: Weiwei
% date? 20160328

    plane = createPlane(polygon(1,:), polygon(2,:), polygon(3,:));
    pointplane = projPointOnPlane(point, plane);
    [projectedpoint, isavailable] = intersectRayPolygon3d([point, pointplane], polygon);

end

