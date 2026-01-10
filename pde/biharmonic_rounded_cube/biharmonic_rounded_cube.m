clear; clc; close all;

% Parameters
p = 30;          % rounding exponent (controls cube sharpness)
n = 80;         % mesh resolution
k = 100;         % number of eigenmodes to compute

% Generate mesh (reuse your function)
[V,F] = rounded_cube_mesh(p,n);

figure;
trisurf(F, V(:,1), V(:,2), V(:,3));
axis equal off;
title('Rounded cube surface');

% Assemble Laplace-Beltrami operator and mass matrix
[L,M] = cotangent_laplacian(V,F);

% Invert lumped mass matrix efficiently
Minv = spdiags(1 ./ diag(M), 0, size(M,1), size(M,2));

% Build biharmonic operator
B = L * Minv * L;

% Solve generalized eigenproblem B u = lambda u
opts.isreal = true;
opts.issym = true;

[U_bi,D_bi] = eigs(B, k, 'sm', opts);
lambda_bi = diag(D_bi);

fprintf('Biharmonic eigenvalues:\n');
disp(lambda_bi.');

% Visualize biharmonic eigenmodes
for i = 90:100
    figure;
    trisurf(F, V(:,1), V(:,2), V(:,3), U_bi(:,i), ...
        'EdgeColor','none');
    axis equal off;
    colormap turbo;
    colorbar;
    title(['Biharmonic eigenmode ', num2str(i)]);
    lighting gouraud;
    camlight;
end

% Choose the mode index you want to analyze
mode_idx = 95;  % for example

% Visualize that mode with zero-level set
figure;
trisurf(F, V(:,1), V(:,2), V(:,3), U_bi(:,mode_idx), ...
    'EdgeColor','none');
axis equal off;
colormap turbo;
colorbar;
title(['Biharmonic eigenmode ', num2str(mode_idx)]);
lighting gouraud;
camlight;
hold on;

% Extract zero-level points for this mode
zeroPts = extract_zero_level_set(V, F, U_bi(:,mode_idx));

% Plot zero-level set points as black dots
plot3(zeroPts(:,1), zeroPts(:,2), zeroPts(:,3), 'k.', 'MarkerSize', 12);

hold off;
