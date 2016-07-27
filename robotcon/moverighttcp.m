function isdone = moverighttcp(hirosock, xyzrpys)
% move the position of right tcp to the specified x,y,z,ro,pi,ya
%
% input
%----------
% - hirosock - the socket object where users send command to
% - xyzrpys - a list including the x, y, z, r, p, y, speed(in radian/s)
%            the position and orientation of tcp
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160204

    x = num2str(xyzrpys(1));
    y = num2str(xyzrpys(2));
    z = num2str(xyzrpys(3));
    ro = num2str(xyzrpys(4));
    pi = num2str(xyzrpys(5));
    ya = num2str(xyzrpys(6));
    spd = num2str(xyzrpys(7));
    sep = ',';
    fwrite(hirosock, ['moverighttcp',sep,x,sep,y,sep,z,sep,ro,sep,pi,sep,ya,sep,spd]);
    isdone = waitfeedback(hirosock, 'rightcpmoved!');
    
end