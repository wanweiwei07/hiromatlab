function isdone = disconnectrob( hirosock )
% move hiro to offpose, and close the socket
%
% input
%----------
% - hirosock - the tcpsocket
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160204

    fwrite(hirosock, 'disconnect');
    isdone = waitfeedback(hirosock, 'disconnected!');
    fclose(hirosock);

end