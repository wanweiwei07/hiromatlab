a=[];
for i = 1:size(rgp.states,1)
    ngp = size(rgp.states{5}.ikprggrp(1).graspparams, 1);
    for j = 1:ngp
        if rgp.states{3}.ikprggrp(1).graspparams(j).fgrcenter(2)~=rgp.states{3}.ikprggrp(3).graspparams(j).fgrcenter(2)
            disp([rgp.states{3}.ikprggrp(1).graspparams(j).tcp, rgp.states{3}.ikprggrp(3).graspparams(j).tcp]);
            a = [a;[rgp.states{3}.ikprggrp(1).graspparams(j).tcp', rgp.states{3}.ikprggrp(3).graspparams(j).tcp']];
        end
    end
end