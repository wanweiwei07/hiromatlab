function [abspos, absrot] = computeassemabspose(relpos, relrot)
% compute the absolute poses of each object in the assembly structure
% 
% input
% ---------
% - relpos - n-by-3, the relative positions of each object to the base, the first
%               row is the absolute position of the base
% - relrot - n-by-mat3, the relative rotations of each object. Like relpos, the first
%               row is the base's absolute rot.
%
% output
% ---------
% - abspos - n-by-3, the absolute positions of each object
% - absrot - n-by-mat3, the absolute rotations of each object

    abspos = relpos;
    absrot = relrot;
    nrelpos = size(relpos, 1);
    for i = 2:nrelpos
        abspos{i} = absrot{1}*relpos{i}+abspos{1};
        absrot{i} = absrot{1}*relrot{i};
    end

end

