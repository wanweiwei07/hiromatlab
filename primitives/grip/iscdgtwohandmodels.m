function iscollided = iscdgtwohandmodels( hand1, hand2 )
% check the collision between hand1 and hand2
%
% input
% ----
% - hand1 - hand1.vertpalm, hand1.f3palm, hand1.vertfgr1, hand1.f3fgr1
%           hand1.vertfgr2, hand1.f3fgr2
% - hand2 - hand2.vertpalm, hand2.f3palm, hand2.vertfgr2, hand2.f3fgr2
%           hand2.vertfgr2, hand2.f3fgr2
%
% output
% ----
% - iscollided - whether the two hands are collided

    iscollided = 0;

%     pcdh1p = cvtpcd(hand1.vertpalm, hand1.f3palm, 10000);
%     pcdh1f1 = cvtpcd(hand1.vertfgr1, hand1.f3fgr1, 10000);
%     pcdh1f2 = cvtpcd(hand1.vertfgr2, hand1.f3fgr2, 10000);

    pcdh2p = cvtpcd(hand2.vertpalm', hand2.f3palm', 10000);
    pcdh2f1 = cvtpcd(hand2.vertfgr1', hand2.f3fgr1', 10000);
    pcdh2f2 = cvtpcd(hand2.vertfgr2', hand2.f3fgr2', 10000);
    
    %hand1 and hand2.palm
    h2p_in_h1p = inpolyhedron(hand1.f3palm, hand1.vertpalm, pcdh2p);
    h2p_in_h1f1 = inpolyhedron(hand1.f3fgr1, hand1.vertfgr1, pcdh2p);
    h2p_in_h1f2 = inpolyhedron(hand1.f3fgr2, hand1.vertfgr2, pcdh2p);
    ish2p_in_h1p = sum(h2p_in_h1p);
    ish2p_in_h1f1 = sum(h2p_in_h1f1);
    ish2p_in_h1f2 = sum(h2p_in_h1f2);
    if ish2p_in_h1p || ish2p_in_h1f1 || ish2p_in_h1f2
        iscollided = 1;
    	return;
    end
    %hand1 and hand2.f1
    h2f1_in_h1p = inpolyhedron(hand1.f3palm, hand1.vertpalm, pcdh2f1);
    h2f1_in_h1f1 = inpolyhedron(hand1.f3fgr1, hand1.vertfgr1, pcdh2f1);
    h2f1_in_h1f2 = inpolyhedron(hand1.f3fgr2, hand1.vertfgr2, pcdh2f1);
    ish2f1_in_h1p = sum(h2f1_in_h1p);
    ish2f1_in_h1f1 = sum(h2f1_in_h1f1);
    ish2f1_in_h1f2 = sum(h2f1_in_h1f2);
    if ish2f1_in_h1p || ish2f1_in_h1f1 || ish2f1_in_h1f2
        iscollided = 1;
    	return;
    end
    %hand1 and hand2.f2
    h2f2_in_h1p = inpolyhedron(hand1.f3palm, hand1.vertpalm, pcdh2f2);
    h2f2_in_h1f1 = inpolyhedron(hand1.f3fgr1, hand1.vertfgr1, pcdh2f2);
    h2f2_in_h1f2 = inpolyhedron(hand1.f3fgr2, hand1.vertfgr2, pcdh2f2);
    ish2f2_in_h1p = sum(h2f2_in_h1p);
    ish2f2_in_h1f1 = sum(h2f2_in_h1f1);
    ish2f2_in_h1f2 = sum(h2f2_in_h1f2);
    if ish2f2_in_h1p || ish2f2_in_h1f1 || ish2f2_in_h1f2
        iscollided = 1;
    	return;
    end
    
%     %hand2 and hand1.palm
%     h1p_in_h2p = inpolyhedron(hand2.vertpalm, hand2.f3palm, pcdh1p);
%     h1p_in_h2f1 = inpolyhedron(hand2.vertfgr1, hand2.f3fgr1, pcdh1p);
%     h1p_in_h2f2 = inpolyhedron(hand2.vertfgr2, hand2.f3fgr2, pcdh1p);
%     ish1p_in_h2p = sum(h1p_in_h2p);
%     ish1p_in_h2f1 = sum(h1p_in_h2f1);
%     ish1p_in_h2f2 = sum(h1p_in_h2f2);
%     if ish1p_in_h2p || ish1p_in_h2f1 || ish1p_in_h2f2
%         iscollided = 1;
%     	return;
%     end
%     %hand2 and hand1.f1
%     h1f1_in_h2p = inpolyhedron(hand2.vertpalm, hand2.f3palm, pcdh1f1);
%     h1f1_in_h2f1 = inpolyhedron(hand2.vertfgr1, hand2.f3fgr1, pcdh1f1);
%     h1f1_in_h2f2 = inpolyhedron(hand2.vertfgr2, hand2.f3fgr2, pcdh1f1);
%     ish1f1_in_h2p = sum(h1f1_in_h2p);
%     ish1f1_in_h2f1 = sum(h1f1_in_h2f1);
%     ish1f1_in_h2f2 = sum(h1f1_in_h2f2);
%     if ish1f1_in_h2p || ish1f1_in_h2f1 || ish1f1_in_h2f2
%         iscollided = 1;
%     	return;
%     end
%     %hand2 and hand1.f2
%     h1f2_in_h2p = inpolyhedron(hand2.vertpalm, hand2.f3palm, pcdh1f2);
%     h1f2_in_h2f1 = inpolyhedron(hand2.vertfgr1, hand2.f3fgr1, pcdh1f2);
%     h1f2_in_h2f2 = inpolyhedron(hand2.vertfgr2, hand2.f3fgr2, pcdh1f2);
%     ish1f2_in_h2p = sum(h1f2_in_h2p);
%     ish1f2_in_h2f1 = sum(h1f2_in_h2f1);
%     ish1f2_in_h2f2 = sum(h1f2_in_h2f2);
%     if ish1f2_in_h2p || ish1f2_in_h2f1 || ish1f2_in_h2f2
%         iscollided = 1;
%     	return;
%     end
    
    return;

end

