function done = waitfinish(handrqcon, waitchars, charnum, expectedchars)
% wait until the gripper finishes last task
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

    done = 0;
    feedback = [];
    starttime = clock;
    while 1
        fwrite(handrqcon, waitchars, 'uint8'); 
        while 1
            timeelapsed = clock - starttime;
            if timeelapsed(end) > 15
                error('Failed to finish in 15 seconds');
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
            break;
        end
        
    end
end