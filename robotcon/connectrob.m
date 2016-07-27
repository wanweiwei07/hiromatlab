function [isdone, hirosock] = connectrob()
% init the RTC on hiro-vision, connect them with hiro011, calibrate
% the joints, and move the robot to bodyinfo.initialpose
%
% input
%----------
% - NA
%
% output
%----------
% - isdone - boolean result
% - hirosock - the socket object where users send command to
%
% author: Weiwei
% date: 20160204

    hirosock = tcpip('10.2.0.20', 50305);
    hirosock.InputBufferSize = 2048;
    hirosock.OutputBufferSize = 2048;
    fopen(hirosock);
    fwrite(hirosock, 'connect');
    isdone = waitfeedback(hirosock, 'connected!');
    if(isdone==false)
        disp('connection failed');
    end

end