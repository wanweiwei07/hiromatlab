function pnts = sampletriangle( vert1, vert2, vert3, narea )
% sample a triangular surface
% all in row order

    p1 = vert1;
    p2 = vert2;
    p3 = vert3;
    e21 = p2 - p1;
    l21 = sqrt(e21(1).^2+e21(2).^2+e21(3).^2);
    e31 = p3 - p1;
    l31 = sqrt(e31(1).^2+e31(2).^2+e31(3).^2);
    e32 = p3 - p2;
    l32 = sqrt(e32(1).^2+e32(2).^2+e32(3).^2);
    area = norm(cross(e21, e31));
    cnt = 0;
    w1 = [];
    w2 = [];
    w3 = [];
    pntnum = round(area*narea);
    if pntnum < 2
        % use the center
        pnts = (p1+p2+p3)/3;
        % remove those too far from edge
        pntsto1 = bsxfun(@minus, pnts, p1);
        dpntse21 = bsxfun(@cross, pntsto1', e21');
        dpntse21 = dpntse21';
        dpntse21 = sqrt(dpntse21(:,1).^2+dpntse21(:,2).^2+dpntse21(:,3).^2);
        dpntse31 = bsxfun(@cross, pntsto1', e31');
        dpntse31 = dpntse31';
        dpntse31 = sqrt(dpntse31(:,1).^2+dpntse31(:,2).^2+dpntse31(:,3).^2);
        pntsto2 = bsxfun(@minus, pnts, p2);
        dpntse32 = bsxfun(@cross, pntsto2', e32');
        dpntse32 = dpntse32';
        dpntse32 = sqrt(dpntse32(:,1).^2+dpntse32(:,2).^2+dpntse32(:,3).^2);
        dpnt = min([dpntse21, dpntse31, dpntse32], [], 2);
        if dpnt > 60
            pnts = [];
        end
        return;
    end
    while cnt < pntnum
        r1 = rand(1);
        r2 = rand(1);
        if r1+r2 < 1
            w1 = [w1;r1];
            w2 = [w2;r2];
            w3 = [w3;1-r1-r2];
            cnt = cnt + 1;
        end
    end
    pnts = zeros(pntnum, 3);
    pnts(:, 1) = w1*p1(1) + w2*p2(1) + w3*p3(1);
    pnts(:, 2) = w1*p1(2) + w2*p2(2) + w3*p3(2);
    pnts(:, 3) = w1*p1(3) + w2*p2(3) + w3*p3(3);

    % remove those too far from edge
    pntsto1 = bsxfun(@minus, pnts, p1);
    dpntse21 = bsxfun(@cross, pntsto1', e21');
    dpntse21 = dpntse21';
    dpntse21 = sqrt(dpntse21(:,1).^2+dpntse21(:,2).^2+dpntse21(:,3).^2)/l21;
    dpntse31 = bsxfun(@cross, pntsto1', e31');
    dpntse31 = dpntse31';
    dpntse31 = sqrt(dpntse31(:,1).^2+dpntse31(:,2).^2+dpntse31(:,3).^2)/l31;
    pntsto2 = bsxfun(@minus, pnts, p2);
    dpntse32 = bsxfun(@cross, pntsto2', e32');
    dpntse32 = dpntse32';
    dpntse32 = sqrt(dpntse32(:,1).^2+dpntse32(:,2).^2+dpntse32(:,3).^2)/l32;
    
    dpnt = min([dpntse21, dpntse31, dpntse32], [], 2);
    finalpnts = find(dpnt<55);
    if ~isempty(finalpnts)
        pnts = pnts(finalpnts, :);
    else
        pnts = [];
    end
    
end

