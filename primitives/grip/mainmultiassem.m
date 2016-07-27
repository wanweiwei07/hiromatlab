load data/interairl.mat
load data/interairtri.mat
load data/interairz3d.mat
load data/interairt.mat

% postriassem = [0.0225;-0.0075;-0.0075];
% rottriassem = rodrigues([0;1;0], -pi);
% interstatetri = moveinterstate(interairtri, postriassem, rottriassem);
% interstatetri = removecdgmeta(interstatetri, interairl.stablemesh.pcd);
% plotinterstates(interairl, 'none');
% plotinterstates(interstatetri, 'none');
% 
% assemdirect = findassemdirect(interairl, interstatetri)*0.5;
% if(~isempty(assemdirect))
%     quiver3(0, 0, 0, ...
%         assemdirect(1), assemdirect(2), assemdirect(3), ...
%         'color', 'k', 'linewidth', 5);
% end

obstacles = [];
tableverts = [[0.5, 0.5, 0]; [-0.5, 0.5, 0]; ...
        [-0.5, -0.5, 0]; [0.5, -0.5, 0]];
tablefaces = [[1, 2, 3]; [3, 4, 1]];
tableobstacle.verts = tableverts;
tableobstacle.faces = tablefaces;
obstacles = cat(1, obstacles, tableobstacle);

postassem = [0;0;0.015];
rottassem = rodrigues([1;0;0], pi/2);
interstatet = moveinterstate(interairt, postassem, rottassem);

posz3dassem = rottassem*[0.0375;0.0075;0.0225]+postassem;
rotz3dassem = rottassem*rodrigues([1;0;0], pi/2);
interstatez3d = moveinterstate(interairz3d, posz3dassem, rotz3dassem);
% interstatez3d = removecdgmeta(interstatez3d, interairt.stablemesh.pcd);

postriassem = rottassem*[0.015;0.0225;-0.0225]+postassem;
rottriassem = rodrigues([0;0;1], pi/2);
rottriassem = rottassem*rodrigues([1;0;0], pi/2)*rottriassem;
interstatetri = moveinterstate(interairtri, postriassem, rottriassem);
% interstatetri = removecdgmeta(interstatetri, interstatez3d.stablemesh.pcd);

plotinterstates(interstatet, 'none', [0.6,0.85,0.95]);
plotinterstates(interstatez3d, 'none', [0.55, 0.2, 0.9]);
plotinterstates(interstatetri, 'none', [0.1, 0.6, 0.1]);

% assemdirect = findassemdirect(interairt, interstatez3d)*0.5;
% if(~isempty(assemdirect))
%     quiver3(interstatez3d.placementp(1), interstatez3d.placementp(2), ...
%         interstatez3d.placementp(3), ...
%         assemdirect(1), assemdirect(2), assemdirect(3), ...
%         'color', 'k', 'linewidth', 5);
% end

baseinterstates = [interstatez3d;interstatetri];
assemdirect = findassemdirect(baseinterstates, interstatet, obstacles)*0.5;
if(~isempty(assemdirect))
    quiver3(interstatet.placementp(1), interstatet.placementp(2), ...
        interstatet.placementp(3), ...
        assemdirect(1), assemdirect(2), assemdirect(3), ...
        'color', 'r', 'linewidth', 5);
end

baseinterstates = [interstatet;interstatetri];
assemdirect = findassemdirect(baseinterstates, interstatez3d, obstacles)*0.5;
if(~isempty(assemdirect))
    quiver3(interstatez3d.placementp(1), interstatez3d.placementp(2), ...
        interstatez3d.placementp(3), ...
        assemdirect(1), assemdirect(2), assemdirect(3), ...
        'color', 'g', 'linewidth', 5);
end

baseinterstates = [interstatet;interstatez3d];
assemdirect = findassemdirect(baseinterstates, interstatetri, obstacles)*0.5;
if(~isempty(assemdirect))
    quiver3(interstatetri.placementp(1), interstatetri.placementp(2), ...
        interstatetri.placementp(3), ...
        assemdirect(1), assemdirect(2), assemdirect(3), ...
        'color', 'b', 'linewidth', 5);
end