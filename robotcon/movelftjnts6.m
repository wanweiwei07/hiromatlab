function isdone = movelftjnts6(hirosock, ljntspd)
% move the joints of left arm to the values specified by ljntspd
% the metric is degree
%
% input
%----------
% - hirosock - the socket object where users send command to
% - ljntspd - a list including the 6 joints of left arm and the speed
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    lft1 = num2str(ljntspd(1));
    lft2 = num2str(ljntspd(2));
    lft3 = num2str(ljntspd(3));
    lft4 = num2str(ljntspd(4));
    lft5 = num2str(ljntspd(5));
    lft6 = num2str(ljntspd(6));
    spd = num2str(ljntspd(7));
    sep = ',';
    fwrite(hirosock, ['moveleftarmjoints6',sep,lft1,sep,...
        lft2,sep,lft3,sep,lft4,sep,lft5,sep,lft6,sep,spd]);
    isdone = waitfeedback(hirosock, 'leftjoints6moved!');

end

