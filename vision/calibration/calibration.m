system('rm calibmat.txt');

% % center kinect
% % center of block (real)
% Pm = [0.3  -0.2  -0.02;
%       0.5  -0.15  -0.02;
%        0.5  0.1  -0.02;
%        0.3  0.2  -0.02]';
% 
% % （from Kinect）
% kPm = [0.1436 0.07616 1.243
%        0.2899 0.02319 1.104
%        0.2784 -0.2343 1.097
%       0.1322 -0.3294 1.238]';
% 
% [t,R] = callSVD(Pm,kPm);

% % left kinect
% % center of block (real)
% Pm = [0.3  -0.2  -0.02;
%       0.5  -0.15  -0.02;
%        0.5  0.1  -0.02;
%        0.3  0.2  -0.02]';
% 
% % （from Kinect）
% kPm = [-0.07013 0.2652 1.252
%        -0.1103 0.06577 1.212
%        -0.2597 0.0747 1.016
%        -0.3054 0.2794 0.928]';
% 
% [t,R] = callSVD(Pm,kPm);

% right kinect
% center of block (real)
Pm = [0.3  -0.2  -0.02;
      0.5  -0.15  -0.02;
       0.5  0.1  -0.02;
       0.3  0.2  -0.02]';

% （from Kinect）
kPm = [0.2999 0.3406 0.968
       0.2845 0.1395 1.022
       0.1334 0.1441 1.229
       0.06163 0.347 1.304]';

[t,R] = callSVD(Pm,kPm);

% Pm = [0.3 -0.2 0.745;
%       0.3 0.15 0.745;
%       0.5 -0.1 0.745;
%       0.5 0.1 0.745]';
% 
% kPm = [0.2651 -0.2430 0.7389;
%       0.2349 0.1034 0.7501;
%       0.4596 -0.1217 0.7451;
%       0.4393 0.0760 0.7474]';
% 
% [t,R] = callSVD(Pm,kPm);
% 
% Pm = [0 0 0;
%       1 0 0;
%       0 1 0;
%       0 0 1]';
% 
% kPm = [0 0 0;
%       1 0 0;
%       0 1 0;
%       0 0 1]';
% 
% [t,R] = callSVD(Pm,kPm);

