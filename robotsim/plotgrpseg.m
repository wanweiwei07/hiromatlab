function plotgrpseg(graspparam, color)
% plot grasp segment
%
% input
% --
% - graspparam - the param of a grasp, defined in computeinterair
% (primitive/grasp)
% - color - the color of the segment
%
% author: Weiwei
% 20160722

    plot3([graspparam.fgrcenter(1,:);graspparam.tcp(1,:)],...
        [graspparam.fgrcenter(2,:);graspparam.tcp(2,:)],...
        [graspparam.fgrcenter(3,:);graspparam.tcp(3,:)],...
        'linestyle','-','linewidth',2,'color',color);
end

