function isdone = movejnts15(hirosock, bodyrls)
% move the joints to the values specified by
% 3->body, 6->right,  6->left, 1->speed
% the metric is degree
%
% input
%----------
% - hirosock - the socket object where users send command to
% - bodyrls - a list including the body joints, right arm joints, and left
% arm joints, hand configuraiton is NOT included
%
% output
%----------
% - isdone - boolean result
%
% author: Weiwei
% date: 20160215

    bodyyaw = num2str(bodyrls(1));
    headyaw = num2str(bodyrls(2));
    headpitch = num2str(bodyrls(3));
    rgt1 = num2str(bodyrls(4));
    rgt2 = num2str(bodyrls(5));
    rgt3 = num2str(bodyrls(6));
    rgt4 = num2str(bodyrls(7));
    rgt5 = num2str(bodyrls(8));
    rgt6 = num2str(bodyrls(9));
    lft1 = num2str(bodyrls(10));
    lft2 = num2str(bodyrls(11));
    lft3 = num2str(bodyrls(12));
    lft4 = num2str(bodyrls(13));
    lft5 = num2str(bodyrls(14));
    lft6 = num2str(bodyrls(15));
    spd = num2str(bodyrls(16));
    sep = ',';
    fwrite(hirosock, ['movejoints15',sep,bodyyaw,sep,headyaw,sep,headpitch, ...
        sep,rgt1,sep,rgt2,sep,rgt3,sep,rgt4,sep,rgt5,sep,rgt6,sep,...
        lft1,sep,lft2,sep,lft3,sep,lft4,sep,lft5,sep,lft6,sep,spd]);
    isdone = waitfeedback(hirosock, 'joints15moved!');

end

