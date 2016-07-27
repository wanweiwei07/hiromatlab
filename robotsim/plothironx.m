function plothironx(hironx, varargin)
% plot hironx with stick models
%
% input
% -----------
% - hironx - the data structure of hironx
% - varargin{1} - whether do clear axis (cla)
%
% author: Weiwei
% date: 20160218

    plotcolor = 'b';
    if nargin > 2
        plotcolor = varargin{1};
    end
    
    global fhdl;
    figure(fhdl);
    global subrow;
    global subcol;
    global mainrowcol;
    subplot(subrow, subcol, mainrowcol);
    if nargin == 3 && varargin{2} == 1
        cla;
    end
    
    plotrgtarm(hironx.rgtarm, plotcolor);
    plotlftarm(hironx.lftarm, plotcolor);
    
end

