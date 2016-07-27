dbstop if error;

load data/interairl.mat
load data/interairtri.mat

% the table coordinates are global
% unncessry to do transformation
precision = 0.001;
tableverts = [[0.5, 0.5, -precision]', [-0.5, 0.5, -precision]', ...
    [-0.5, -0.5, -precision]', [0.5, -0.5, -precision]'];
tablefaces = [[1, 2, 3]', [3, 4, 1]'];
tablepcd = cvtpcd(tableverts, tablefaces, 10000);
    
% postriassem = [-0.0225;0;0.015];
% rottriassem = rodrigues([1;0;0], -pi);
postriassem = [0.0225;-0.0075;-0.0075];
rottriassem = rodrigues([0;1;0], -pi);
interstatetri = moveinterstate(interairtri, postriassem, rottriassem);

figure;
plotinterstates(interstatetri,'r');
interstatetri = removecdgmeta(interstatetri, interairl.stablemesh.pcd);
interstatel = removecdgmeta(interairl, interstatetri.stablemesh.pcd);

figure;
plotinterstates(interstatetri,'r');
% plotinterstatesobjpcds(interstatetri);
% plotinterstateshandmodels(interstatetri,'r');
% plotinterstates(interstatel,'b');
% plotinterstateshandmodels(interstatel);
% plotinterstatesobjpcds(interstatel);

dualgp = getdualgrasppairs(interstatetri, interstatel);
%%
plotinterstateshandmodelpairs(interstatetri, interstatel, dualgp);