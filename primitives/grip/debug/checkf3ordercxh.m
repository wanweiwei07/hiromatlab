load vertfgrs.mat
load f3fgrs.mat

nf3fgrs = size(f3fgrs, 1);
for i = 1:nf3fgrs
    id1 = f3fgrs(i,1);
    id2 = f3fgrs(i,2);
    id3 = f3fgrs(i,3);
    
    quiver3(vertfgrs(id1,1), vertfgrs(id1,2), vertfgrs(id1,3), ...
        vertfgrs(id2,1)-vertfgrs(id1,1), vertfgrs(id2,2)-vertfgrs(id1,2), ...
        vertfgrs(id2,3)-vertfgrs(id1,3));
    hold on;
    axis equal;
    quiver3(vertfgrs(id2,1), vertfgrs(id2,2), vertfgrs(id2,3), ...
        vertfgrs(id3,1)-vertfgrs(id2,1), vertfgrs(id3,2)-vertfgrs(id2,2), ...
        vertfgrs(id3,3)-vertfgrs(id2,3));
    quiver3(vertfgrs(id3,1), vertfgrs(id3,2), vertfgrs(id3,3), ...
        vertfgrs(id1,1)-vertfgrs(id3,1), vertfgrs(id1,2)-vertfgrs(id3,2), ...
        vertfgrs(id1,3)-vertfgrs(id3,3));
    disp(i);
end