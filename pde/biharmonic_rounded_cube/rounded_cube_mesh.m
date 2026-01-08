function [V,F] = rounded_cube_mesh(p, n)
    % p = rounding exponent
    % n = grid resolution

    [x,y,z] = meshgrid(linspace(-1.2,1.2,n));
    Fval = abs(x).^p + abs(y).^p + abs(z).^p - 1;

    fv = isosurface(x,y,z,Fval,0);

    V = fv.vertices;
    F = fv.faces;
end