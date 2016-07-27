function updatedinterstates = removecdgbatchso(interstates, objlist)
% remove the grasps that collides with the objects in the objlist
% the batchso means to batch process both the interstates and objs
%
% input
% ----
% - interstates - a list of interstates, column-first cell
% - objlist - the objects for collision detection, column-first cell
%
% output
% ----
% - updatedinterstateair - the interstate with collided grasps removed
%
% author: Weiwei
% date: 20160224

    % compute objlistpcd
    nobjlist = size(objlist,1);
    objlistpcd = cell(nobjlist, 1);
    for io = 1:nobjlist
        objlistpcd{io} = cvtpcd(objlist{io}.verts, objlist{io}.faces, 10000);
    end

    ninterstates = size(interstates,1);
    updatedinterstates = cell(ninterstates, 1);
    for is = 1:ninterstates
        updatedinterstate = interstates{is};
        updatedinterstate = removecdgbatcho(updatedinterstate, objlistpcd);
        updatedinterstates{is} = updatedinterstate;
    end

end

