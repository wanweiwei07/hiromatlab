function quality = computegraspquality6d(wrenches)
% compute the quality of a grasp formed by the wrenches
% this is done by measuring the radius of the wrench ball
% 
% input
% -------
% - wrenches - n-by-x matrix, each row indicates one wrench, it is 3d for
% 2d workspace, and 6d for 3d workspace; especially, when torque is not
% considered in 3d space, wrenches degenerate into forces and have three
% elements
% 
% output
% -------
% - quality - scalar, described by the smallest angle to the face of the convexhull
%
% date: 20160527
% author: weiwei

    ndim = size(wrenches, 2);
    wrenches = [wrenches; zeros(1, ndim)];
    wconvfaces = convhulln(wrenches);
    
    nwconvfaces = size(wconvfaces, 1);
    
    mindist = 100;
    for i = 1:nwconvfaces
        verts = wrenches(wconvfaces(i, :)',:);
        H = verts*verts';
        f = zeros(ndim, 1);
        Aeq = ones(1, ndim);
        beq = 1;
        lb = zeros(ndim, 1);
        opts = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
        [~, fval] = quadprog(H, f, [], [], Aeq, beq, lb, [], [], opts);
        
        if fval < mindist
            mindist = fval;
        end
    end
    
    %{
    % Visualize the convexhull, it only works in 3d wrench space
    patch('vertices', wrenches*0.3, 'faces', wconvfaces, 'facecolor', 'none', ...
        'facealpha', .3, 'edgecolor', 'k');
    hold on;
    %}
    
    quality = mindist;
end