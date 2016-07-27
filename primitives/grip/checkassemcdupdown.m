function iscd = checkassemcdupdown(obj1interstate, obj2interstate)
% check the cd between obj1 and obj2 in updown primitive
%
% input
% ---------
% - obj1interstate - the moved intermediate state of obj1
% - obj2interstate - the moved intermediate state of obj2
%
% output
% ---------
% - isstable - whether the structure is stable or not

    shrinkprecision = 0.001;
    obj2vertsdown = obj2interstate.stablemesh.verts;
    obj2facesdown = obj2interstate.stablemesh.faces;
    [obj2pcddown, obj2pcdnormaldown] = cvtpcd(obj2vertsdown, obj2facesdown, 10000);
    
    obj2pcdup1 = bsxfun(@plus, obj2pcddown, 0.01*[0,0,1]);
    obj2pcdup1shrinked = obj2pcdup1 - shrinkprecision*obj2pcdnormaldown;
    obj2pcdup2 = bsxfun(@plus, obj2pcddown, 0.02*[0,0,1]);
    obj2pcdup2shrinked = obj2pcdup2 - shrinkprecision*obj2pcdnormaldown;
    obj2pcdup3 = bsxfun(@plus, obj2pcddown, 0.03*[0,0,1]);
    obj2pcdup3shrinked = obj2pcdup3 - shrinkprecision*obj2pcdnormaldown;
    obj2pcdup4 = bsxfun(@plus, obj2pcddown, 0.04*[0,0,1]);
    obj2pcdup4shrinked = obj2pcdup4 - shrinkprecision*obj2pcdnormaldown;
    obj2pcdup5 = bsxfun(@plus, obj2pcddown, 0.05*[0,0,1]);
    obj2pcdup5shrinked = obj2pcdup5 - shrinkprecision*obj2pcdnormaldown;
    
%     plotinterstates(obj1interstate, 'r', [0.3, 1, 0.3]);
%     plot3(obj2pcdup1shrinked(:,1), obj2pcdup1shrinked(:,2), obj2pcdup1shrinked(:,3), '.g');
    
    iscd = 0;
    in1 = inpolyhedron(obj1interstate.stablemesh.faces, obj1interstate.stablemesh.verts, obj2pcdup1shrinked);
    if(sum(in1)) 
        iscd = 1;
        return;
    end
    in2 = inpolyhedron(obj1interstate.stablemesh.faces, obj1interstate.stablemesh.verts, obj2pcdup2shrinked);
    if(sum(in2)) 
        iscd = 1;
        return;
    end
    in3 = inpolyhedron(obj1interstate.stablemesh.faces, obj1interstate.stablemesh.verts, obj2pcdup3shrinked);
    if(sum(in3)) 
        iscd = 1;
        return;
    end
    in4 = inpolyhedron(obj1interstate.stablemesh.faces, obj1interstate.stablemesh.verts, obj2pcdup4shrinked);
    if(sum(in4)) 
        iscd = 1;
        return;
    end
    in5 = inpolyhedron(obj1interstate.stablemesh.faces, obj1interstate.stablemesh.verts, obj2pcdup5shrinked);
    if(sum(in5)) 
        iscd = 1;
        return;
    end  
    
end

