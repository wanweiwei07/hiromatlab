%% Pre-define the coordinates of the object
% object vertices
% ccw order
objv = [[0, 0]; [0, 5]; [-5, 0]; [0, 0]];
frictioncoeff = 0.5;

%% Pre-define the finger vertices
% finger vertices start from 0, 0
fgrv = [[0, 100]; [-50*sqrt(3), -50]; [50*sqrt(3), -50]];

% rotate finger
rotangle = -pi/4;
quatnum = angle2quat(rotangle, 0, 0);
fgrvrotwithz = quatrotate(quatnum, [fgrv, zeros(size(fgrv, 1), 1)]);
fgrv = fgrvrotwithz(:, 1:2);

fgrnum = size(fgrv, 1);

%% pre-define the range of discretization
samplegranu = 1;
samplerng = -5:samplegranu:5;

[gridx, gridy] = meshgrid(samplerng);
gridz = zeros(size(gridx));

%% Pre-define the rotation center to calculate moment
refpoint = [-1, 1];


%% Calculate the forceclosure at [cx, cy] and measure its quality
% set hand center to a fixed position
cx = -1.5;
cy = 1.5;

% find the position in gridz
idx = round((cx-samplerng(1))/samplegranu)+1;
idy = round((cy-samplerng(1))/samplegranu)+1;
% set default value to zero
gridz(idx, idy) = 0;

[bin, bon] = inpolygon(cx, cy, objv(:, 1), objv(:, 2));
% if only inside the inner, there is some bug in the inpolygon function of matlab
if bin && ~bon
    hndcenter = [cx, cy];
    [binagain, contactpoint, contactnorm] = getcontacts(fgrv, objv, hndcenter);
    if binagain

        % draw obj ############
        hold on;
        plot3(objv(:, 1), objv(:, 2), zeros(size(objv, 1), 1), 'linewidth', 3);
        plot(refpoint(1,1), refpoint(1,2), 'o', 'markersize', 5, 'markerfacecolor', 'k');

        % allocate space for wrenches
        wrenches = zeros(2*size(fgrv, 1), 3);
        for fgrid = 1:fgrnum
            [wrench, force] = getwrench(contactpoint(fgrid,:), contactnorm(fgrid,:), frictioncoeff, refpoint);
            wrenches(2*fgrid-1:2*fgrid, :) = wrench;

            % draw wrenches ############
            for i = 2*fgrid-1:2*fgrid
                plot3([wrenches(i, 1)+refpoint(1, 1);refpoint(1,1)], [wrenches(i, 2)+refpoint(1, 2); ...
                    refpoint(1,2)], [wrenches(i,3);0], 'b', 'linewidth', 0.5);
                plot3([wrenches(i, 1)+contactpoint(fgrid, 1);contactpoint(fgrid, 1)], [wrenches(i, 2)+...
                    contactpoint(fgrid, 2);contactpoint(fgrid, 2)], [wrenches(i,3);0], 'm-', 'linewidth', 2);
            end
            plot([contactnorm(fgrid, 1)+contactpoint(fgrid, 1);contactpoint(fgrid, 1)], ...
                [contactnorm(fgrid, 2)+contactpoint(fgrid, 2);contactpoint(fgrid, 2)], 'k-', 'linewidth', 2);
            plot([fgrv(fgrid, 1)/20+hndcenter(1, 1);hndcenter(1, 1)], [fgrv(fgrid, 2)/20+hndcenter(1, 2);...
                hndcenter(1, 2)], 'c-', 'linewidth', 2); 
            axis equal;
            axis off;
        end
        triangles = convhull(wrenches(:,1), wrenches(:,2), wrenches(:,3), 'simplify', true);

        % draw convexhulls
        wrenchesplot(:,1) = wrenches(:,1)+refpoint(1,1)*ones(2*fgrnum, 1);
        wrenchesplot(:,2) = wrenches(:,2)+refpoint(1,2)*ones(2*fgrnum, 1);
        trisurf(triangles, wrenchesplot(:,1), wrenchesplot(:,2), wrenches(:,3), 'facecolor', 'g', ...
            'facealpha', 0.3, 'edgecolor', 'b', 'edgealpha', 0.3, 'linewidth', 0.5);                    
    
        % use the min distance between origin and convexhull as the quality
        % of forceclosure
        [mindist, minweight, minwrenches] = getminmargin( triangles, wrenches );
        dire = minweight'*minwrenches;

        % draw quality
        plot3([dire(1, 1)+refpoint(1, 1);refpoint(1,1)], [dire(1, 2)+refpoint(1, 2);refpoint(1,2)], ...
            [dire(1,3);0], 'k-', 'linewidth', 3);

        view([-60 30]);

        gridz(idx, idy) = mindist;
    end
end