function updatedinterstate = removecdgbatcho(interstate, objlistpcd)
% remove the grasps that collides with the objects in the objlist
% the batch o means to batch process the objects
%
% input
% ----
% - interstate - a data structure that indicates one interstate
% - objlist - the objects for collision detection, column-first cell
%
% output
% ----
% - updatedinterstateair - the interstate with collided grasps removed
%
% author: Weiwei
% date: 20160224
    
    updatedinterstate = interstate;
    for i = 1:size(objlistpcd, 1)
        objpcd = objlistpcd{i};
        updatedinterstate = removecdgmeta(updatedinterstate, objpcd);
    end

end