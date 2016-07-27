function isdone = resethand(hirosock)
% reset the hand by servoon/off/open/close
%
% input
%----------
% - hirosock - the socket object where users send command to
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    fwrite(hirosock, 'resethand');
    isdone = waitfeedback(hirosock, 'handreseted!');

end

