function isstable = checkassemstability(baseinterstates, obj2interstate, tablepcd)
% check the stability of the assembled structure composed by obj1 and obj2
%
% input
% ---------
% - obj1interstate - the moved intermediate state of obj1
% - obj2interstate - the moved intermediate state of obj2
%
% output
% ---------
% - isstable - whether the structure is stable or not
    
    if nargin == 2
        precision = 0.001;
        tableverts = [[0.5, 0.5, precision]; [-0.5, 0.5, precision]; ...
            [-0.5, -0.5, precision]; [0.5, -0.5, precision]];
        tablefaces = [[1, 2, 3]; [3, 4, 1]];
        tablepcd = cvtpcd(tableverts, tablefaces, 10000);
    end

    nbaseinter = size(baseinterstates, 1);
    obj1pnts = [];
    for i = 1:nbaseinter
        in1 = inpolyhedron(baseinterstates(i).stablemesh.faces, ...
            baseinterstates(i).stablemesh.verts, tablepcd);
        obj1pnts = cat(1, obj1pnts, tablepcd(in1, :));
    end
    in2 = inpolyhedron(obj2interstate.stablemesh.faces, obj2interstate.stablemesh.verts, tablepcd);
    obj2pnts = tablepcd(in2, :);
    tableinpnts = [obj1pnts;obj2pnts];
    
    assempcd = [];
    for i = 1:nbaseinter
        assempcd = cat(1, assempcd, baseinterstates(i).stablemesh.pcd);
    end
    assempcd = [assempcd; obj2interstate.stablemesh.pcd];
    center = sum(assempcd, 1)/size(assempcd, 1);
    k = convhull(tableinpnts(:,1), tableinpnts(:,2));
    isstable = inpolygon(center(1,1), center(1,2), tableinpnts(k,1), tableinpnts(k,2));    
    
end

