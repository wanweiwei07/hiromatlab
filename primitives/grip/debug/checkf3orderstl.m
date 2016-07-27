palmfile = 'hxgripper/hxpalm.obj';
fgr1file = 'hxgripper/hxfgr1.obj';
fgr2file = 'hxgripper/hxfgr2.obj';

[vpalm,f3palm,f4palm]=loadwobj(palmfile);
vpalm = vpalm';
f3palm = f3palm';
[vfgr1,f3fgr1,f4fgr1]=loadwobj(fgr1file);
vfgr1 = vfgr1';
f3fgr1 = f3fgr1';
[vfgr2,f3fgr2,f4fgr2]=loadwobj(fgr2file);
vfgr2 = vfgr2';
f3fgr2 = f3fgr2';

% nf3palm = size(f3palm, 1);
% for i = 1:nf3palm
%     id1 = f3palm(i,1);
%     id2 = f3palm(i,2);
%     id3 = f3palm(i,3);
%     
%     quiver3(vpalm(id1,1), vpalm(id1,2), vpalm(id1,3), ...
%         vpalm(id2,1)-vpalm(id1,1), vpalm(id2,2)-vpalm(id1,2), ...
%         vpalm(id2,3)-vpalm(id1,3));
%     hold on;
%     axis equal;
%     quiver3(vpalm(id2,1), vpalm(id2,2), vpalm(id2,3), ...
%         vpalm(id3,1)-vpalm(id2,1), vpalm(id3,2)-vpalm(id2,2), ...
%         vpalm(id3,3)-vpalm(id2,3));
%     quiver3(vpalm(id3,1), vpalm(id3,2), vpalm(id3,3), ...
%         vpalm(id1,1)-vpalm(id3,1), vpalm(id1,2)-vpalm(id3,2), ...
%         vpalm(id1,3)-vpalm(id3,3));
%     disp(i);
% end

nf3fgr1 = size(f3fgr1, 1);
for i = 1:nf3fgr1
    id1 = f3fgr1(i,1);
    id2 = f3fgr1(i,2);
    id3 = f3fgr1(i,3);
    
    quiver3(vfgr1(id1,1), vfgr1(id1,2), vfgr1(id1,3), ...
        vfgr1(id2,1)-vfgr1(id1,1), vfgr1(id2,2)-vfgr1(id1,2), ...
        vfgr1(id2,3)-vfgr1(id1,3));
    hold on;
    axis equal;
    quiver3(vfgr1(id2,1), vfgr1(id2,2), vfgr1(id2,3), ...
        vfgr1(id3,1)-vfgr1(id2,1), vfgr1(id3,2)-vfgr1(id2,2), ...
        vfgr1(id3,3)-vfgr1(id2,3));
    quiver3(vfgr1(id3,1), vfgr1(id3,2), vfgr1(id3,3), ...
        vfgr1(id1,1)-vfgr1(id3,1), vfgr1(id1,2)-vfgr1(id3,2), ...
        vfgr1(id1,3)-vfgr1(id3,3));
    disp(i);
end