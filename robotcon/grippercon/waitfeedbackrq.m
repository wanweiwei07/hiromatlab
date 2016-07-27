function done = waitfeedbackrq(handrqcon, charnum, expectedchars)
% wait for the feedback from the gripper
%
% input
%----------
% - handrqcon - modbus tcp connection between matlab and robotiq gripper
% - charnum - number of chars to read from feedback buffer
% - expectedchars - the expected feedback chars
%
% output
%----------
% - done - boolean result
%
% author: Weiwei
% date: 20140809

    feedback = [];
    starttime = clock;
    while 1
        timeelapsed = clock - starttime;
        if timeelapsed(end) > 3
            break;
        end
        if handrqcon.BytesAvailable
             feedback = fread(handrqcon, charnum);
             flushinput(handrqcon);
             flushoutput(handrqcon);
             break;
        end
    end
    
    if isequal(feedback, expectedchars)
        done = 1;
    else
        done = 0;
    end
end