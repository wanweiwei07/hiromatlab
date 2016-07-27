function [isdone, xyzrpy] = readlefttcp( hirosock )
% read the pose of the left tool point center
%
% input
%----------
% - hirosock - the socket object where users send command to
%
% output
%----------
% - isdone - did we successfully get the return value
% - xyzrpy - x, y, z, r, p, y, the position and orientation of tcp
%
% author: Weiwei
% date: 20160205

    fwrite(hirosock, 'getlefttcp');
    [isdone, returnstr] = waitreturnvalue(hirosock);
    if(isdone)
        num_list = cellfun(@str2num, strsplit(returnstr, ','));
        x = num_list(1);
        y = num_list(2);
        z = num_list(3);
        ro = num_list(4);
        pi = num_list(5);
        ya = num_list(6);
        xyzrpy = [x,y,z,ro,pi,ya];
        return
    else
        xyzrpy = [];
    end

end