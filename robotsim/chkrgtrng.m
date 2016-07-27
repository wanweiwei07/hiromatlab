function isdone = chkrgtrng( ulink )
% check weather ranges of each joint is acceptable
%
% input
% --------------
% - ulink - the data structure of robot links
%
% author: Weiwei
% date: 20160218

    isdone = 1;

    safemargin = 5;
%     bodyyawmin = -(163-safemargin);
%     bodyawmax = +(163-safemargin);
    rgt1min = -(88-safemargin);
    rgt1max = +(88-safemargin);
    rgt2min = -(140-safemargin);
    rgt2max = +(60-safemargin);
    rgt3min = -(158-safemargin);
    rgt3max = +(0-safemargin);
    rgt4min = -(165-safemargin);
    rgt4max = +(105-safemargin);
    rgt5min = -(100-safemargin);
    rgt5max = +(100-safemargin);
    rgt6min = -(163-safemargin);
    rgt6max = +(163-safemargin);

    if ulink(2).q < rgt1min*pi/180 || ulink(2).q > rgt1max*pi/180
        disp(['jnt1 out of range, value is ', num2str(ulink(2).q*180/pi), ...
            '; rng is ', num2str(rgt1min), '~', num2str(rgt1max)]);
        isdone = 0;
    end

    if ulink(3).q < rgt2min*pi/180 || ulink(3).q > rgt2max*pi/180
        disp(['jnt2 out of range, value is ', num2str(ulink(3).q*180/pi), ...
            '; rng is ', num2str(rgt2min), '~', num2str(rgt2max)]);
        isdone = 0;
    end
    
    if ulink(4).q < rgt3min*pi/180 || ulink(4).q > rgt3max*pi/180
        disp(['jnt3 out of range, value is ', num2str(ulink(4).q*180/pi), ...
            '; rng is ', num2str(rgt3min), '~', num2str(rgt3max)]);
        isdone = 0;
    end
    
    if ulink(5).q < rgt4min*pi/180 || ulink(5).q > rgt4max*pi/180
        disp(['jnt4 out of range, value is ', num2str(ulink(5).q*180/pi), ...
            '; rng is ', num2str(rgt4min), '~', num2str(rgt4max)]);
        isdone = 0;
    end
    
    if ulink(6).q < rgt5min*pi/180 || ulink(6).q > rgt5max*pi/180
        disp(['jnt5 out of range, value is ', num2str(ulink(6).q*180/pi), ...
            '; rng is ', num2str(rgt5min), '~', num2str(rgt5max)]);
        isdone = 0;
    end
    
    if ulink(7).q < rgt6min*pi/180 || ulink(6).q > rgt6max*pi/180
        disp(['jnt6 out of range, value is ', num2str(ulink(7).q*180/pi), ...
            '; rng is ', num2str(rgt6min), '~', num2str(rgt6max)]);
        isdone = 0;
    end

end

