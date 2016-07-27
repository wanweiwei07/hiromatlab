%% initialize robot
[~, hirosock] = connectrob();

%% initialize gripper
[~, handrqcon] = openrqhandcon();



disconnectrob(hirosock);