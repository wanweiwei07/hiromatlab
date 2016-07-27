function [otlpcd, otlverts, otlfaces] = loadobstacle(otlpath, otlpos, otlR, samplingrate)
% load an obstacle
%
% input
% ----
% - otlpath - path of the obstacle
% - otlpos - 1by3 position of the obstacle
% - otlR - 3by3 orientation of the obstacle
% - samplingrate - 10000 if 'none', else specified
%
% output
% ----
% - otlpcd - the pcd for collision detection nby3
% - otlverts - the verts of the obstacle nby3
% - otlfaces - the faces of the obstacle nby3 (triangles)
%
% author: Weiwei
% date: 20160726

    
    [V,F3,F4]=loadwobj(otlpath);
    verts = V';
    faces = F3';
    nfaces = size(faces, 1);
    
    if strcmp(samplingrate, 'none')
        samplingrate = 10000;
    end
    [otlpcd, otlpcdnormals] = ...
    	cvtpcd(verts, faces, samplingrate);
    
    otlverts = bsxfun(@plus, (otlR*verts')', otlpos);
    otlfaces = faces;
    [otlpcd, otlpcdnormals] = ...
    	cvtpcd(otlverts, faces, samplingrate);
end

