clear; clc;

p = 8;
n = 80;

[V,F] = rounded_cube_mesh(p,n);

[L,M] = cotangent_laplacian(V,F);

k = 12;
opts.isreal = true;
opts.issym = true;

[U,D] = eigs(L,M,k,'sm',opts);

lambda = diag(D);
disp(lambda');

for i = 2:8
    figure;
    trisurf(F, V(:,1), V(:,2), V(:,3), U(:,i), ...
        'EdgeColor','none');
    axis equal off;
    colormap turbo;
    colorbar;
    title(['Eigenmode ', num2str(i)]);
    lighting gouraud;
    camlight;
end
