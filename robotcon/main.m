%% initialize robot
[~, hirosock] = connectrob();

%% get end-effector pose
[~,rtcp] = readrighttcp(hirosock);
[~,ltcp] = readlefttcp(hirosock);

rdcm = angle2dcm(rtcp(6), rtcp(5), rtcp(4));
ldcm = angle2dcm(ltcp(6), ltcp(5), ltcp(4));

scl = 0.1;

% plot the configuration of right hand
quiver3(rtcp(1),rtcp(2),rtcp(3),rdcm(1,1)*scl,rdcm(1,2)*scl,rdcm(1,3)*scl,'color','r');
hold on;
axis vis3d
axis equal
view ([90, 30]);
axis([-0.3, 0.7, -0.7, 0.7, 0, 1.0]);
xlabel('x');
ylabel('y');
quiver3(rtcp(1),rtcp(2),rtcp(3),rdcm(2,1)*scl,rdcm(2,2)*scl,rdcm(2,3)*scl,'color','g');
quiver3(rtcp(1),rtcp(2),rtcp(3),rdcm(3,1)*scl,rdcm(3,2)*scl,rdcm(3,3)*scl,'color','b');
% plot the confiugration of left hand
quiver3(ltcp(1),ltcp(2),ltcp(3),ldcm(1,1)*scl,ldcm(1,2)*scl,ldcm(1,3)*scl,'color','r');
quiver3(ltcp(1),ltcp(2),ltcp(3),ldcm(2,1)*scl,ldcm(2,2)*scl,ldcm(2,3)*scl,'color','g');
quiver3(ltcp(1),ltcp(2),ltcp(3),ldcm(3,1)*scl,ldcm(3,2)*scl,ldcm(3,3)*scl,'color','b');

%% set end-effector pose
axisx = [-1,0,0]';
axisy = [0,1,0]';
axisz = [0,0,-1]';
moverighttcpwithframe(hirosock, [rtcp(1), rtcp(2), rtcp(3)], axisx, axisy, axisz, 5);
movelefttcpwithframe(hirosock, [ltcp(1), ltcp(2), ltcp(3)], axisx, axisy, axisz, 5);

%% set end-effector pose
axisx = [0,0,1]';
axisy = [0,1,0]';
axisz = [-1,0,0]';
moverighttcpwithframe(hirosock, [0.4, rtcp(2), 0.1], axisx, axisy, axisz, 5);

%% read all joints
[~,joints15] = readjoints(hirosock);

%% move righttcp
isdone = moverighttcp(hirosock, [rtcp(1)+0.05,rtcp(2),rtcp(3),rtcp(4),rtcp(5),rtcp(6),30])

%% move lefttcp
isdone = movelefttcp(hirosock, [ltcp(1)+0.05,ltcp(2),ltcp(3),ltcp(4),ltcp(5),ltcp(6),10])

%% move righttcp
isdone = moverighttcp(hirosock, [rtcp(1),rtcp(2),rtcp(3),rtcp(4),rtcp(5),rtcp(6),30])

%% move rightarmjoints7
rjntspd = [joints15(1), joints15(4:9), 3.0];
rjntspd(1) = rjntspd(1) + 10.0;
rjntspd(end) = 1.0;
isdone = movergtjnts7(hirosock, rjntspd);

%% move leftarmjoints7
ljntspd = [joints15(1), joints15(10:15), 3.0];
ljntspd(1) = 0.0;
ljntspd(end) = 1.0;
isdone = movelftjnts7(hirosock, ljntspd);

%% move rightarmjoints6
rjntspd = [joints15(4:9), 3.0];
rjntspd(1) = rjntspd(1) + 30.0;
isdone = movergtjnts6(hirosock, rjntspd);

%% move leftarmjoints6
ljntspd = [joints15(10:15), 3.0];
ljntspd(1) = ljntspd(1) - 10.0;
ljntspd(end) = 1.0;
isdone = movelftjnts6(hirosock, ljntspd);

%% go initial
goinitial(hirosock, 3);

%% hands script1
resethand(hirosock);

%% hands script2
grasplefthand(hirosock, 100);
grasprighthand(hirosock, 0);

%% disconnect
disconnectrob(hirosock)