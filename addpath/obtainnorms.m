function norms = obtainnorms(objboundary, k0, k1)
% This function calculates two k curves by using k0 and k1, and generate
% normal for each boundary point by adding them up
%
% norms = obtainnorms(objboundary, k0, k1)
% objboundary : object boundary clouds
% k0 : the first two points that are employed to compute normal0
% k1 : the second two points that are employed to compute normal1
% norm : norm(normal0+normal1)
%
% Note that it does not matter wheather the surface normals are pointing
% outside or inside surface as their directions compromise each other

    row = size(objboundary, 1);
    rotmatcc = [[0,-1];[1,0]];
    rotmatc = [[0,1];[-1,0]];
    boundarynv = repmat([0,0], row, 1);
    for item = 1:row
      idxpre0 = item - k0;
      idxnxt0 = item + k0;
      idxpre1 = item - k1;
      idxnxt1 = item + k1;
      if idxpre0 < 1
        idxpre0 = idxpre0+row;
      end
      if idxnxt0 > row
        idxnxt0 = idxnxt0-row;
      end
      if idxpre1 < 1
        idxpre1 = idxpre1+row;
      end
      if idxnxt1 > row
        idxnxt1 = idxnxt1-row;
      end
      % Here we rotate the previous one counter-clockwise while rotate the next
      % one clockwise
      point = objboundary(item, :);
      pointpre0 = objboundary(idxpre0, :);
      pointnxt0 = objboundary(idxnxt0, :);
      vpre0 = pointpre0-point;
      vnxt0 = pointnxt0-point;
      nvpre0 = vpre0/norm(vpre0);
      nvnxt0 = vnxt0/norm(vnxt0);
      orthnvpre0 = (rotmatcc*nvpre0')';
      orthnvnxt0 = (rotmatc*nvnxt0')';

      pointpre1 = objboundary(idxpre1, :);
      pointnxt1 = objboundary(idxnxt1, :);
      vpre1 = pointpre1-point;
      vnxt1 = pointnxt1-point;
      nvpre1 = vpre1/norm(vpre1);
      nvnxt1 = vnxt1/norm(vnxt1);
      orthnvpre1 = (rotmatcc*nvpre1')';
      orthnvnxt1 = (rotmatc*nvnxt1')';

      orthv = orthnvpre0+orthnvnxt0+orthnvpre1+orthnvnxt1;
      orthnv = orthv/norm(orthv);
      boundarynv(item, 1) = orthnv(1);
      boundarynv(item, 2) = orthnv(2);
      
      
      if isnan(boundarynv(item, 1))
        boundarynv(item, 1) = 0;
        boundarynv(item, 2) = 0;
      end

    %   a = [boundary(item, 2), 10*norms(item, 2)+boundary(item, 2)];
    %   b = [boundary(item, 1), 10*norms(item, 1)+boundary(item, 2)];
    %   a = [objboundary(item, 2), pointpre0(item, 2)];
    %   b = [objboundary(item, 1), pointpre0(item, 1)];
    %   disp(a);
    %   disp(b);
    %   plot(a,b,'r', 'LineWidth', 3);
    %   a = [objboundary(item, 2), 100*orthnvpre0(item, 2)+objboundary(item, 2)];
    %   b = [objboundary(item, 1), 100*orthnvpre0(item, 1)+objboundary(item, 1)];
    %   disp(a);
    %   disp(b);
    %   plot(a,b,'r', 'LineWidth', 3);
    end

    norms = boundarynv;
    
    % recalculate surface normal
    ray = createRay(objboundary(1, :), objboundary(1, :)+norms(1, :));
    [intersects edgeIndices] = intersectRayPolygon(ray, objboundary);
    reduceinter = bsxfun(@minus, intersects, objboundary(1, :));
    items = abs(sum(reduceinter, 2)) > 1e-6;
    intern = sum(items);
    if mod(intern, 2) == 1
        norms = -norms;
    end