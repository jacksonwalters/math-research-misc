function [L,M] = cotangent_laplacian(V,F)
    n = size(V,1);

    I = F(:,[2 3 1]);
    J = F(:,[3 1 2]);

    vi = V(I(:),:);
    vj = V(J(:),:);
    vk = V(F(:),:);

    e1 = vj - vi;
    e2 = vk - vi;

    cot = dot(e1,e2,2) ./ vecnorm(cross(e1,e2,2),2,2);

    W = sparse(I(:),J(:),cot,n,n);
    W = (W + W')/2;

    L = spdiags(sum(W,2),0,n,n) - W;

    % Lumped mass matrix
    A = 0.5 * vecnorm(cross( ...
        V(F(:,2),:) - V(F(:,1),:), ...
        V(F(:,3),:) - V(F(:,1),:), 2),2,2);

    M = sparse(F(:),F(:),repmat(A/3,3,1),n,n);
end
