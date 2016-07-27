function plotrqt85(gpos, grot, jawwidth, scale, plcolor)
% plot the robotiq 85 hand at gpos with grot
%
% input
% ----
% - gpos - 1-by-3 position
% - grot - 3x3 rotation matrix
% - plcolor - 1-by-3 colorarray or 'r'-like char
%
% author: weiwei
% date: 20160707

%     grot=[0,0,1;0,1,0;1,0,0];
%     gpos = [0,1,0];

    jawwidth = 70;
    halfjw = jawwidth/2;
    thetaik = 0;
    if halfjw > 5
        thetaik = asin((halfjw-5)/57.15);
    end
    if halfjw <= 5
        thetaik = asin((5-halfjw)/57.15)+asin(37.5/57.15);
    end

    thetaknuckle_init = asin(4.08552455/31.75);
    knucklex = 0;
    knuckley = 0;
    if thetaik > thetaknuckle_init
        thetaknuckle = thetaik-thetaknuckle_init;
        knuckley = 31.75*cos(thetaknuckle);
        knucklex = -31.75*sin(thetaknuckle);
    else
        thetaknuckle = thetaknuckle_init-thetaik;
        knuckley = 31.75*cos(thetaknuckle);
        knucklex = 31.75*sin(thetaknuckle);
    end

    thetaft_init = asin(43.03959870/57.15);
    ftx = 0;
    fty = 0;
    if thetaik+thetaft_init>1.57
        thetaft = 3.14-(thetaik+thetaft_init);
        fty = 57.15*cos(thetaft);
        ftx = 57.15*sin(thetaft);
    else
        thetaft = thetaft_init+thetaik;
        fty = 57.15*cos(thetaft);
        ftx = 57.15*sin(thetaft);
    end

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_base_link.obj');
    baseverts = scale*V';
    basefaces = F3';
    baseverts=(grot*baseverts')';
    baseverts = bsxfun(@plus, baseverts, gpos);
    patch('faces', basefaces, 'vertices', baseverts, 'facecolor', plcolor, 'edgecolor', 'none');

    hold on;
    material dull;
    view([50, 20]);
    axis equal;
    set(gcf,'color','white');
    % axis([-1.25, +1.25,...
    %     -1.25, +1.25,...
    %     -1.25, +1.25]);
    axis vis3d;
    xlabel('x');
    ylabel('y');
    % axis off;
    delete(findall(gca, 'Type', 'light'));
    light('Position',[-10 -10 10]);
    light('Position',[-10 -10 -10]);
    light('Position',[-10 10 10]);
    light('Position',[-10 10 -10]);
    %         light('Position',[10 10 10]);
    light('Position',[10 10 -10]);
    light('Position',[10 -10 -10]);
    %         light('Position',[10 -10 10]);

    % x plus 
    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_knuckle_link.obj');
    rotmat = rodrigues([0,0,1],thetaik);
    V = scale*rotmat*V;
    knuckleverts = V';
    knucklefaces = F3';
    offset = scale*[54.90451627, -30.60114442, 0];
    knuckleverts = bsxfun(@plus, knuckleverts, offset);
    knuckleverts=(grot*knuckleverts')';
    knuckleverts = bsxfun(@plus, knuckleverts, gpos);
    patch('faces', knucklefaces, 'vertices', knuckleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_finger_link.obj');
    rotmat = rodrigues([0,0,1],thetaik);
    V = scale*rotmat*V;
    fgrleverts = V';
    fgrlefaces = F3';
    offset = scale*[54.90451627-knucklex, -30.60114442-knuckley, 0];
    fgrleverts = bsxfun(@plus, fgrleverts, offset);
    fgrleverts=(grot*fgrleverts')';
    fgrleverts = bsxfun(@plus, fgrleverts, gpos);
    patch('faces', fgrlefaces, 'vertices', fgrleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_inner_knuckle_link.obj');
    rotmat = rodrigues([0,0,1],thetaik);
    V = scale*rotmat*V;
    ikleverts = V';
    iklefaces = F3';
    offset = scale*[61.42, -12.7, 0];
    ikleverts = bsxfun(@plus, ikleverts, offset);
    ikleverts=(grot*ikleverts')';
    ikleverts = bsxfun(@plus, ikleverts, gpos);
    patch('faces', iklefaces, 'vertices', ikleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_finger_tip_link.obj');
    ftleverts = scale*V';
    ftlefaces = F3';
    offset = scale*[61.42+ftx, -12.7-fty, 0];
    ftleverts = bsxfun(@plus, ftleverts, offset);
    ftleverts=(grot*ftleverts')';
    ftleverts = bsxfun(@plus, ftleverts, gpos);
    patch('faces', ftlefaces, 'vertices', ftleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    % x minus 
    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_knuckle_link.obj');
    rotmat = rodrigues([1,0,0], 3.1415926);
    V = scale*rotmat*V;
    rotmat = rodrigues([0,0,1],-thetaik);
    V = rotmat*V;
    knuckleverts = V';
    knucklefaces = F3';
    offset = scale*[54.90451627, 30.60114442, 0];
    knuckleverts = bsxfun(@plus, knuckleverts, offset);
    knuckleverts=(grot*knuckleverts')';
    knuckleverts = bsxfun(@plus, knuckleverts, gpos);
    patch('faces', knucklefaces, 'vertices', knuckleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_finger_link.obj');
    rotmat = rodrigues([1,0,0], 3.1415926);
    V = scale*rotmat*V;
    rotmat = rodrigues([0,0,1],-thetaik);
    V = rotmat*V;
    fgrleverts = V';
    fgrlefaces = F3';
    offset = scale*[54.90451627-knucklex, 30.60114442+knuckley, 0];
    fgrleverts = bsxfun(@plus, fgrleverts, offset);
    fgrleverts=(grot*fgrleverts')';
    fgrleverts = bsxfun(@plus, fgrleverts, gpos);
    patch('faces', fgrlefaces, 'vertices', fgrleverts, 'facecolor', plcolor, 'edgecolor', 'none');

    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_inner_knuckle_link.obj');
    rotmat = rodrigues([1,0,0], 3.1415926);
    V = scale*rotmat*V;
    rotmat = rodrigues([0,0,1],-thetaik);
    V = rotmat*V;
    ikleverts = V';
    iklefaces = F3';
    offset = scale*[61.42, 12.7, 0];
    ikleverts = bsxfun(@plus, ikleverts, offset);
    ikleverts=(grot*ikleverts')';
    ikleverts = bsxfun(@plus, ikleverts, gpos);
    patch('faces', iklefaces, 'vertices', ikleverts, 'facecolor', plcolor, 'edgecolor', 'none');


    [V,F3,F4]=loadwobj('rqt85gripper/robotiq_85_finger_tip_link.obj');
    rotmat = rodrigues([1,0,0], 3.1415926);
    V = scale*rotmat*V;
    ftleverts = V';
    ftlefaces = F3';
    offset = scale*[61.42+ftx, 12.7+fty, 0];
    ftleverts = bsxfun(@plus, ftleverts, offset);
    ftleverts=(grot*ftleverts')';
    ftleverts = bsxfun(@plus, ftleverts, gpos);
    patch('faces', ftlefaces, 'vertices', ftleverts, 'facecolor', plcolor, 'edgecolor', 'none');

