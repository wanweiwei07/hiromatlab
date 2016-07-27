function isdone = movergtjnts6(hirosock, rjntspd)
% move the joints of right arm to the values specified by rjntspd
% the metric is degree
%
% input
%----------
% - hirosock - the socket object where users send command to
% - rjntspd - a list including the 6 joints of right arm,
%             and the speed
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    rgt1 = num2str(rjntspd(1));
    rgt2 = num2str(rjntspd(2));
    rgt3 = num2str(rjntspd(3));
    rgt4 = num2str(rjntspd(4));
    rgt5 = num2str(rjntspd(5));
    rgt6 = num2str(rjntspd(6));
    spd = num2str(rjntspd(7));
    sep = ',';
    fwrite(hirosock, ['moverightarmjoints6',sep,rgt1,sep,...
        rgt2,sep,rgt3,sep,rgt4,sep,rgt5,sep,rgt6,sep,spd]);
    isdone = waitfeedback(hirosock, 'rightjoints6moved!');

end

