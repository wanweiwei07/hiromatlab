function isdone = grasprighthand(hirosock, dist)
% actuate the right hand of the robot with a specified finger dist
%
% input
%----------
% - hirosock - the socket object where users send command to
% - dist - the distance between the two finger tips, ranging from 0 to 100
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    sep = ',';
    fwrite(hirosock, ['rhandgrsp',sep,num2str(dist)]);
    isdone = waitfeedback(hirosock, 'righthandactuated!');
    
end

