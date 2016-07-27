function normsface = computefacenormal(vertex, face)
% compute the facenormals
% the mesh is supposed to be in good shape, with
% trimesh edges in counter clock direction
%
% input
% ---------
% - vertex - n-by-3 array which includes the vertices of the mesh models
% - face - n-by-3 array which includes the indices to the vertices
%
% output
% --------
% - normsface - n-by-3 the face normals of triangles

    edge21 = vertex(face(:,2), :)-vertex(face(:,1), :);
    edge32 = vertex(face(:,3), :)-vertex(face(:,2), :);
    
    normsface = normr(cross(edge21, edge32, 2));

end

