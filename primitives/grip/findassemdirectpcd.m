function [compliance, assemdirect] = ...
    findassemdirectpcd(basepcd, basepcdnormals, obj2interstate, otlpcd, otlpcdnormals)
% find from which direction should we assemble obj2 to the base which is
% assembled by a single or several interstates
% this one uses pcd, the findassemdirect function uses meshmodels
%
% TODO: add compliance to the findassemdirect function
%
% input
% ---------
% - basepcd - n-by-3 array, all pcd from the base
% - basepcdnormals - n-by-3 array, the correspondent normals of those basepcd
% - obj2interstate - the moved intermediate state of obj2, this one is
% going to be assembled to the baseinterstates
% - otlpcd - n-by-3 array, all pcd from the obstacles
% - otlpcdnormals - n-by-3 array, the correspondent normals of those otlpcd
%
% output
% ---------
% - compliance - this parameter indicates how flexible can the assembly
%               motion be; 0 means the structure is not assemblable, 1
%               means there is strong constraints on assembly (the robot
%               could only assemble obj2 to the base from a single
%               direction), 10 indicates high compliance
% - assemdirect - 3by1 vector which indicates the assemble direction
    
    checkpcd = cat(1, basepcd, otlpcd);
    checkpcdnormals = cat(1, basepcdnormals, otlpcdnormals);
    
    % obj2verts = obj2interstate.stablemesh.verts;
    % obj2faces = obj2interstate.stablemesh.faces;
    % [obj2pcd, obj2pcdnormals] = cvtpcd(obj2verts, obj2faces, 10000, 0.001);
    
    %{
    if ~isempty(basepcd)
        % figure(1000);
        plot3(basepcd(:,1), basepcd(:,2), basepcd(:,3), '.b');
        hold on;
        quiver3(basepcd(:,1), basepcd(:,2), basepcd(:,3), basepcdnormals(:,1), ...
            basepcdnormals(:,2), basepcdnormals(:,3), 'color', 'b');
        view([50, 20]);
        axis equal;
        set(gcf,'color','white');
        % axis([baseinterstates(1).placementp(1)-0.25, baseinterstates(1).placementp(1)+0.25,...
        % baseinterstates(1).placementp(2)-0.25, baseinterstates(1).placementp(2)+0.25,...
        % baseinterstates(1).placementp(3)-0.25, baseinterstates(1).placementp(3)+0.25]);
        axis vis3d;
        xlabel('x');
        ylabel('y');
        axis off;
        %{
        plotinterstates(obj2interstate, 'none');
        plot3(otlpcd(:,1), otlpcd(:,2), otlpcd(:,3), '.r');
        quiver3(otlpcd(:,1), otlpcd(:,2), otlpcd(:,3), otlpcdnormals(:,1), ...
            otlpcdnormals(:,2), otlpcdnormals(:,3), 'color', 'r');
        %}
    end
    %}
    
    incheckpcdo2 = inpolyhedron(obj2interstate.stablemesh.faces, ...
        obj2interstate.stablemesh.verts, checkpcd);
    if(sum(incheckpcdo2)) 
        incheckpcdnormals = checkpcdnormals(incheckpcdo2, :);
        
        % plot all collided points and their normals
        %{
        % figure(1000);
        incheckpcd = checkpcd(incheckpcdo2, :);
        incheckpcdnormalsplot = incheckpcdnormals*100;
        quiver3(incheckpcd(:,1), incheckpcd(:,2), incheckpcd(:,3), ...
            incheckpcdnormalsplot(:,1), incheckpcdnormalsplot(:,2), ...
            incheckpcdnormalsplot(:,3), 'color', 'r');
        hold on;
        view([50, 20]);
        axis equal;
        set(gcf,'color','white');
        axis vis3d;
        xlabel('x');
        ylabel('y');
        axis off;
        %}
        
        % ino2pcd = obj2pcd(ino2pcdo1, :);
        % ino2pcdnormals = obj2pcdnormals(ino2pcdo1, :);
        % ino2pcdnormals = ino2pcdnormals*100;
        % quiver3(ino2pcd(:,1), ino2pcd(:,2), ino2pcd(:,3), ino2pcdnormals(:,1), ...
        %     ino2pcdnormals(:,2), ino2pcdnormals(:,3), 'color', 'r');
 	    % plotinterstates(obj2interstate, 'none');
        
        % algorithm:
        % 1. find surface normals (remove duplicated ones)
        % 2. find opposite pairs, final direction will be projected on to
        % the planes vertical to the pairs
        % 3. find non-paired normals, sum them up, and project the sum to
        % the planes computed in 2
        [assemnormals, ~] = unique(incheckpcdnormals, 'rows');
        %{
        % plot all constraint drections
        quiv3origin=repmat(obj2interstate.placementp', size(assemnormals,1), 1);
        assemnormalsforplot = assemnormals*0.1;
        quiver3(quiv3origin(:,1), quiv3origin(:,2), quiv3origin(:,3), ...
            assemnormalsforplot(:,1), assemnormalsforplot(:,2), assemnormalsforplot(:,3), ...
            'color', 'k', 'linewidth', 1.5);
        %}
        
        % plot the unique points and their associated normals
        % ino1pcd = obj1pcd(ino1pcdo2, :);
        % assempts = ino1pcd(ia, :);
        % quiver3(assempts(:,1), assempts(:,2), assempts(:,3), assempts(:,1)+assemnormals(:,1), ...
        %     assempts(:,2)+assemnormals(:,2), assempts(:,3)+assemnormals(:,3), 'color', 'g');
        
        nassemnormals = size(assemnormals, 1);
        if(nassemnormals > 3)
            
            % check if assemnormals are in formclosure
            % if yes, the assembly is infeasible; anc = assembly normals' convexhull
            ancverts = [assemnormals; 0,0,0];
            ancfaces = convhull(ancverts, 'simplify', true);
            ancfacenormals = computefacenormal(ancverts, ancfaces);
            ovnormangles1 = dot(ancverts(ancfaces(:,1), :), ancfacenormals, 2);
            ovnormangles2 = dot(ancverts(ancfaces(:,2), :), ancfacenormals, 2);
            ovnormangles3 = dot(ancverts(ancfaces(:,3), :), ancfacenormals, 2);
            ovnormangles = [ovnormangles1; ovnormangles2; ovnormangles3];
            if(all(ovnormangles > 0.4))
                % form closure
                compliance = 0;
                assemdirect = [];
                return;
            end
            
            %{
            % standard method using wrench space and quadprog (slow)
            quality = computegraspquality(assemnormals);
            if quality > 0.1
                % form closure
                compliance = 0;
                assemdirect = [];
                return;
            end
            %}
        end
        
        % not in form closure
        % the structure can be assembled by pug-and-pull motion
        nassemnorm = size(assemnormals, 1);
        [comb1, comb2] = meshgrid(1:nassemnorm, 1:nassemnorm);
        pairs = [comb1(:), comb2(:)];
        filtermat = triu(ones(nassemnorm),1);
        pairs = pairs(logical(filtermat(:)), :);
        pairnormals1 = assemnormals(pairs(:,1),:);
        pairnormals2 = assemnormals(pairs(:,2),:);
        dotproducts = dot(pairnormals1, pairnormals2,2);
        idxoppositepairs = find(dotproducts<-0.9);
        idxopvectors = pairs(idxoppositepairs, :);
        idxothervectors = setdiff(1:nassemnorm, idxopvectors(:));
        nonoppositenormals = assemnormals(idxothervectors, :);
        compliance = 10;
        assemdirect = mean(nonoppositenormals, 1);
        if(~isempty(idxoppositepairs))
            oppositepairs1 = pairnormals1(idxoppositepairs,:);
            noppairs = size(oppositepairs1, 1);
            if(noppairs==1)
                compliance = 2;
                % project assemdirect to the plane defined
                % by the opposite pair
            	assemdirect = cross(oppositepairs1, ...
                    cross(assemdirect, oppositepairs1));
            else
                if(noppairs>=2)
                    compliance = 1;
                    % use the first two to compute the intersection
                    assemdirectbyplanes = cross(oppositepairs1(1,:), oppositepairs1(2,:));
                    assemdirectmulti = dot(assemdirect, assemdirectbyplanes);
                    if(assemdirectmulti == 0)
                        % 0 means can be approached from any directions
                        % along the assemdirectbyplanes
                        assemdirect = assemdirectbyplanes;
                    else
                        assemdirect = sign(assemdirectmulti)*assemdirectbyplanes;
                    end
                end
            end
        end
    else
        assemdirect = [];
    end
end



