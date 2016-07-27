function openrqhandto( handrqcon, position )
% open the robotiq hand to certain position
% the parameter openposition is a range in 0~85
% position indicates how much do we close
% 0 indicates opening the hand to the maximum (85mm distance between fgrs)
% 85 indicates closing the hand to the maximum (0 distance between fgrs)
%
% input
%----------
% - handrqcon - connection between matlab and the robotiq gripper
% - position - the target position, 0~85mm, 0 indicates fully closed
%
% author: weiwei
% date: 20160411

    if position > 85 | position < 0
        error('Position out of range');
    end
    
    closetochars = hex2dec({'34', 'AB', '00', '00', '00', '0D', '02', '10', '00', '00', '00', '03', '06', '09', '00', '00', 'FF', 'FF', 'FF'});
    % scale the 0~85 value to 0~255
    posscaled = floor((85-position)/85.0*255);
%     disp(posscaled);
    closetochars(17) = posscaled;
    closetorspchars = hex2dec({'34', 'AB', '00', '00', '00', '06', '02', '10', '00', '00', '00', '03'});
	closetorspcharnum = 12;
    waitchars = hex2dec({'D6', '05', '00', '00', '00', '06', '02', '04', '00', '00', '00', '03'});
    waitrspcharsyes = hex2dec({'D6', '05', '00', '00', '00', '09', '02', '04', '06', 'F9', '00', '00'});
    waitrspcharnum = 12;
    
    fwrite(handrqcon, closetochars, 'uint8'); 
    if waitfeedbackrq(handrqcon, closetorspcharnum, closetorspchars)
        % write to request status
        if waitfinish(handrqcon, waitchars, waitrspcharnum, waitrspcharsyes)
            done = 1;
            return;
        end
    else
        error('Cannot close the gripper to the specified position');
    end

end

