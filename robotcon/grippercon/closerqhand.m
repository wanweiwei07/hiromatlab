function isgrasped = closerqhand( handrqcon )
% close mlab hand to maximum close angle
%
% input
%----------
% - handrqcon - connection between matlab and robotiq hand
%
% output
%----------
% - isgrasped - is something inside the gripper or not, 1 true, 0 false,
% -1 nan
%
% author: Weiwei
% date: 20140808

    isgrasped = -1;
    
    closechars = hex2dec({'71', 'EE', '00', '00', '00', '0D', '02', '10', '00', '00', '00', '03', '06', '09', '00', '00', 'FF', 'FF', 'FF'});
    closerspchars = hex2dec({'71', 'EE', '00', '00', '00', '06', '02', '10', '00', '00', '00', '03'});
	closerspcharnum = 12;
    waitchars = hex2dec({'77', '6B', '00', '00', '00', '06', '02', '04', '00', '00', '00', '03'});
    waitcharsgrasped = hex2dec({'77', '6B', '00', '00', '00', '09', '02', '04', '06', 'B9', '00', '00', 'FF', '00', '00'});
    waitcharsempty = hex2dec({'77', '6B', '00', '00', '00', '09', '02', '04', '06', 'F9', '00', '00', 'FF', '00', '00'});
    waitrspcharnum = 15;
    
    fwrite(handrqcon, closechars, 'uint8'); 
    if waitfeedbackrq(handrqcon, closerspcharnum, closerspchars)
        % write to request status
        starttime = clock;
        while 1
            timeelapsed = clock - starttime;
            if timeelapsed(end) > 2003
                break;
            end
            fwrite(handrqcon, waitchars, 'uint8'); 
            feedback = getfeedback(handrqcon, waitrspcharnum);
            if isequal(feedback(1:13), waitcharsgrasped(1:13))
                isgrasped = 1;
                break;
            end
            if isequal(feedback(1:13), waitcharsempty(1:13))
                isgrasped = 0;
                break;
            end
        end
    else
        error('Cannot close the gripper');
    end
end

