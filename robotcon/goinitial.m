function isdone = goinitial(hirosock, time)
% move the robot to the initial configuration defined in bodyinfo
% (bodyinfo is a file under the wan folder of the vision pc)
%
% input
%----------
% - hirosock - the socket object where users send command to
% - time - the time limit to move
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    sep = ',';
    fwrite(hirosock, ['goinitial',sep,num2str(time)]);
    isdone = waitfeedback(hirosock, 'wentinitial!');

end

