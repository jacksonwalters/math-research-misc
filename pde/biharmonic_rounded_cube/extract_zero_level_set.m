function zeroPoints = extractZeroLevelSet(V, F, u)
% extractZeroLevelSet Extract zero-crossing points on mesh edges
%
% Inputs:
%   V - (n x 3) vertices
%   F - (m x 3) faces (triangles)
%   u - (n x 1) scalar values at vertices
%
% Output:
%   zeroPoints - (k x 3) interpolated points where u crosses zero on edges

    % All edges (each row is one edge vertex pair)
    edges = [F(:,[1 2]); F(:,[2 3]); F(:,[3 1])];

    u1 = u(edges(:,1));
    u2 = u(edges(:,2));

    % Edges where sign changes
    signChange = (u1 .* u2) < 0;

    edgesCross = edges(signChange, :);

    % Preallocate zeroPoints
    zeroPoints = zeros(sum(signChange), 3);

    for i = 1:size(edgesCross,1)
        n1 = edgesCross(i,1);
        n2 = edgesCross(i,2);
        t = abs(u(n1)) / (abs(u(n1)) + abs(u(n2)));
        zeroPoints(i,:) = V(n1,:) + t * (V(n2,:) - V(n1,:));
    end
end
