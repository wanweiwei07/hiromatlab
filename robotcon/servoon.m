function isdone = servoon(hirosock)
% turn the servo of the robot on
% NOTE: NEXTAGEOPEN
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
% date: 20160603

    sep = ',';
    fwrite(hirosock, 'servoon');
    isdone = waitfeedback(hirosock, 'servoison!');

end
