dbstop if error;

%% initialize robot
[~, hirosock] = connectrob();

%% read all joints
[~,joints15] = readjoints(hirosock);

%% move rightarmjoints7
rjntspd = [joints15(1), joints15(4:9), 3.0];
rjntspd(1) = rjntspd(1) + 30.0;
rjntspd(end) = 1.0;
isdone = movergtjnts7(hirosock, rjntspd);

%% get end-effector pose
[~,rtcp] = readrighttcp(hirosock);
[~,ltcp] = readlefttcp(hirosock);

%% set end-effector pose
axisx = [0,0,1]';
axisy = [0,1,0]';
axisz = [-1,0,0]';
moverighttcpwithframe(hirosock, [0.4, 0, 0.13], axisx, axisy, axisz, 5);