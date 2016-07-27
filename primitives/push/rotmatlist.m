function rotmats = rotmatlist(icospherelevel)
% generate a list of rotmat using icosphere
%
% input
% ----
% - icospherelevel - the level of icosphere starting from 0
%
% output
% ----
% - rotmats - n-by-3-by-3 matrix where each 3-by-3 is a dcm
%
% author: Weiwei
% date: 20160328

    [handorientation, spherefaces] = icosphere(0);
    rotangles = linspace(0, 2*pi, 9);
    for i = 1:8
        rotang = rotangles(i);
        rodrigues(handorientation, rotang);
    end

end

