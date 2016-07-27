function [ isdone, returnstr ] = waitreturnvalue( hirosock )
% get string feedback from the socket,
% this is different from waitfeedback where only the confirming words are
% returned
%
% input
%----------
% - hirosock - the socket object where users send command to
%
% output
%----------
% - isdone - did we successfully get the return value
% - returnstr - a string of the returned values, need to be further
% processed
%
% author: Weiwei
% date: 20160204

    isdone = false;
    returnstr = [];
    starttime = clock;
    while 1
        thistime = clock;
        timeelapsed = 0;
        if thistime(end) >= starttime(end)
            timeelapsed = thistime(end) - starttime(end);
        else
            timeelapsed = thistime(end) + 60 - starttime(end);
        end
        if timeelapsed > 30
            break;
        end
        if hirosock.BytesAvailable
            returnstr = fscanf(hirosock, '%c', hirosock.BytesAvailable);
            isdone = true;
            flushinput(hirosock);
            flushoutput(hirosock);
            return;
        end
    end

end

