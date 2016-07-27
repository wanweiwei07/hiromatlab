function [done, handrqcon] = openrqhandcon()
% open the connection between matlab and robotiq hand
%
% input
%----------
% - handipo - ip address of robotiqhand
%
% output
%----------
% - done - boolean result
% - handcon - the tcp connection between matlab and the robotiqhand
%
% author: Weiwei
% date: 20140808

    done = 0;
    
    initialchars = hex2dec({'33', '9A', '00', '00', '00', '0D', '02', '10', '00', '00', '00', '03', '06', '01', '00', '00', '00', '00', '00'});
    initrspchars = hex2dec({'33', '9A', '00', '00', '00', '06', '02', '10', '00', '00', '00', '03'});
    initrspcharnum = 12;
    waitchars = hex2dec({'45', '33', '00', '00', '00', '06', '02', '04', '00', '00', '00', '01'});
%     waitactresponsecharsno = hex2dec({'45', '33', '00', '00', '00', '05', '02', '04', '02', '11', '00'});
    waitrspcharsyes = hex2dec({'45', '33', '00', '00', '00', '05', '02', '04', '02', '31', '00'});
    waitrspcharnum = 11;

    handrqcon = tcpip('10.2.0.21', 502, 'ByteOrder', 'LittleEndian');

    fopen(handrqcon);
    if strcmp(handrqcon.status, 'open')
        % write init
        fwrite(handrqcon, initialchars, 'uint8'); 
        
        if waitfeedbackrq(handrqcon, initrspcharnum, initrspchars)
            % write to request status
            if waitfinish(handrqcon, waitchars, waitrspcharnum, waitrspcharsyes)
                done = 1;
                return;
            end
        else
            error('Wrong initialization feedback');
        end
    else
        error('Cannot connect to the gripper');
    end

end