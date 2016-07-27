function plotkeypose(hironx, keypose, varargin)
% plot a single keypose
%
% input
% ----
% - keypose - the keypose to be plotted
% see the searchrgtkeyposes function for details
% - varargin - varargin{1} = color
%
% author: Weiwei
% date: 20160311

    % bodyyaw interpolation should be in numrgtbaik?
    hironxcp = movergtjnts7sim(hironx, keypose.graspparams(1).bodyyaw, ...
        keypose.graspparams(1).rgtjnts);
    plotcolor = 'b';
    if nargin == 3
        plotcolor = varargin{1};
    end
    plothironx(hironxcp, plotcolor, 0);
    plotactiveobj(keypose, [0.3,0.5,0.3]);
end