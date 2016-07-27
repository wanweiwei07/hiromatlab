function [isdone, joints15] = readjoints( hirosock )
% read the values of all joints
%
% input
%----------
% - hirosock - the socket object where users send command to
%
% output
%----------
% - isdone - did we successfully get the return value
% - joints15 - a 1x15 array where the elements are
%              chestyaw, headyaw, headpitch, rgt1~6, lft1~6
%              NOTE: 23 values are returned, including 8 finger jnt angles
%
% author: Weiwei
% date: 20160205

    fwrite(hirosock, 'getjoints');
    [isdone, returnstr] = waitreturnvalue(hirosock);
    if(isdone)
        joints15 = cellfun(@str2num, strsplit(returnstr, ','));
        return
    else
        joints15 = [];
    end

end

