function done = waitfeedback(hirosock, expectedchars)
% wait for the feedback from the gripper
%
% input
%----------
% - tcpsocket - udpsocket connected to the server
% - expectedchars - the expected feedback chars
%
% output
%----------
% - done - boolean result
%
% author: Weiwei
% date: 20160204

    feedback = [];
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
             feedback = fscanf(hirosock, '%c', hirosock.BytesAvailable);
             flushinput(hirosock);
             flushoutput(hirosock);
             break;
        end
    end
    
    if isequal(feedback, expectedchars)
        flushinput(hirosock);
        flushoutput(hirosock);
        done = 1;
    else
        flushinput(hirosock);
        flushoutput(hirosock);
        done = 0;
    end
end