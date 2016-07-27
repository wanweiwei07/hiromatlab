function isfeasible = checkadfeasibility(checkpcd, obj2interstate, assemdirect, ...
    plotobjcolor, plotedgecolor)
% check the feasibility of an assembly direction found by the
% findassemdirect/findassemdirectpcd functions
%
% input
% -------
% - checkpcd - n-by-3, the point cloud that needs to be checked
% - obj2interstate - interstates of the assembling object
% - assemdirect - the direction of assembly
%
% output
% -------
% - isfeasible - true if the checkpcd is in the swept volume
%
% author: weiwei
% date: 20160526

    initverts = obj2interstate.stablemesh.verts;
    facenormals = computefacenormal(obj2interstate.stablemesh.verts, obj2interstate.stablemesh.faces);
    fnadangles = dot(facenormals, repmat(assemdirect, size(facenormals, 1), 1), 2);
    extfaces = obj2interstate.stablemesh.faces((fnadangles>0.2), :);
    extedges = meshEdges(extfaces);
    extadjfaces = meshEdgeFaces(initverts, extedges, extfaces);
    extbounds = [fliplr(extedges(extadjfaces(:,1)==0, :));extedges(extadjfaces(:,2)==0, :)];
    
    %{
    for i = 1:size(extbounds,1)
        plot3(initverts(extbounds(i, :)', 1), initverts(extbounds(i, :)', 2), ...
            initverts(extbounds(i, :)', 3), '-r', 'linewidth', 1.5);
    end
    %}
    
    extedverts = bsxfun(@plus, initverts, assemdirect*0.2);
    allverts = [initverts;extedverts];
    extedfaces = extfaces+size(initverts,1);
    extedbounds = extbounds+size(initverts,1);
    %{
    for i = 1:size(extbounds,1)
        plot3(allverts(extedbounds(i, :)', 1), allverts(extedbounds(i, :)', 2), ...
            allverts(extedbounds(i, :)', 3), '-r', 'linewidth', 1.5);
    end
    %}
    sweptfaces = [fliplr(extfaces); [extbounds, extedbounds(:,1)]; ...
        [fliplr(extedbounds), extbounds(:,2)]; extedfaces];
    
    insweptvolume = inpolyhedron(sweptfaces, allverts, checkpcd);
    
    if nargin == 5
        patch('vertices', allverts,...
              'faces', sweptfaces,...
              'facecolor', plotobjcolor, ...
              'facealpha', 0.3, 'edgecolor', plotedgecolor);
        hold on;
        %{
        % plot the surface normals of the swept volume
        facecenters = ones(size(sweptfaces, 1), 3);
        normsface = computefacenormal(allverts, sweptfaces);
        for i=1:size(facecenters, 1)
            facecenters(i,:) = mean(allverts(sweptfaces(i,:)', :));
        end
        quiver3(facecenters(:, 1), facecenters(:,2), facecenters(:,3), ...
            normsface(:,1), normsface(:,2), normsface(:,3), 'color', 'g');
        %}
        material dull;
        view([50, 20]);
        axis equal;
        set(gcf,'color','white');
        axis([obj2interstate.placementp(1)-0.25, obj2interstate.placementp(1)+0.25,...
            obj2interstate.placementp(2)-0.25, obj2interstate.placementp(2)+0.25,...
            obj2interstate.placementp(3)-0.25, obj2interstate.placementp(3)+0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
        axis off;
    end
    plot3(checkpcd(insweptvolume, 1), checkpcd(insweptvolume, 2), ...
        checkpcd(insweptvolume, 3), '.r', 'markersize', 3);
    isfeasible = sum(insweptvolume)==0;
end

