%% compute interair box
interairb = computerinterstateairobstacle('objects/box.obj');
save data/interairb.mat interairb;

%% plot interairl
figure;
plotinterstates(interairb,'r');