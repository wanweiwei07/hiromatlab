function [mindist, minweight, minwrenches] = getminmargin( triangles, wrenches )
% calculate the mindst between convexhull and origin
%
% input
%----------
% - triangles - the facets of convexhull, ntri-by-3, ntri is the number of
%               facets, 3 are indices to wrenches.
% - wrenches - the wrenches exerted by contacts, nwrench-by-3, [x, y, z].
%
% output
%----------
% - mindist - minimum distance between convexhull and origin
% - minweight - minimum weight of each wrench
% - minwrenches - the wrenches that lead to the minimum dist
%
% author: Weiwei
% date: 20140113

    ntri = size(triangles, 1);
    anum = size(triangles, 2);
    
    mindist = 100;
    minweight = zeros(anum, 1);
    minwrenches = zeros(anum, 3);
    for i = 1:ntri
        verticemat = wrenches(triangles(i, :)', :);
        
        % the problem is essentially
        % minimize a'(v*v')a s.t. sum_a=1 a>0
        % here the a is taken as unkown
        H = verticemat*verticemat';
        f = zeros(anum, 1);
        Aeq = ones(1, anum);
        beq = 1;
        lb = zeros(anum, 1);
        opts = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off');
        [x, fval] = quadprog(H, f, [], [], Aeq, beq, lb, [], [], opts);
        
        if fval < mindist
            mindist = fval;
            minweight = x;
            minwrenches = verticemat;
        end
    end

end

