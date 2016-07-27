function plotinterstateav(interstate, assemdirect, varargin)
% plot four repeated interstates along the assemdirect with different transparency
%
% input
% -------
% - interstate - interstate of the assembling object
% - assemdirect - the direction of assembly
%
% output
% -------
% - isfeasible - true if the checkpcd is in the swept volume
%
% author: weiwei
% date: 20160531

    plotobjcolor = 'none';
    plotedgecolor = 'none';
    plotfacealpha = 'none';
    plotnum = 5;
    plotstep = 0.03;
    if nargin >= 3
        plotobjcolor = varargin{1};
    end
    if nargin >= 4
        plotedgecolor = varargin{2};
    end
    if nargin >= 5
        plotfacealpha = varargin{3};
    end
    if nargin >= 6
        plotnum = varargin{4};
    end
    if nargin >= 7
        plotstep = varargin{5};
    end
    verts = interstate.stablemesh.verts;
    faces = interstate.stablemesh.faces;
    for i = 1:plotnum
        newverts = bsxfun(@plus, verts, plotstep*i*assemdirect);
        drawMesh(newverts, faces, 'facecolor', plotobjcolor, ...
            'edgecolor', plotedgecolor, 'facealpha', plotfacealpha);
    end
end

