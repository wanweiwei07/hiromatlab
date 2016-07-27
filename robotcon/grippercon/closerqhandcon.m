function closerqhandcon( handrqcon )
% close the connection connection between matlab and robotiq gripper
%
% input
%----------
% - handrqcon - the connection between matlab and the gripper
%
% author: Weiwei
% date: 20140809

    fclose(handrqcon);
    
    delete(instrfind);
    clear;
    
end