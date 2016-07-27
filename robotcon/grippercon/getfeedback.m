function feedback = getfeedback(handrqcon, charnum)
% wait for the feedback from the gripper
%
% input
%----------
% - handrqcon - modbus tcp connection between matlab and robotiq gripper
% - charnum - number of chars to read from feedback buffer
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
    
end