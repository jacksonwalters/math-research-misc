# Biharmonic Eigenmodes on a Rounded Cube Surface

This project computes and visualizes eigenmodes of the **Laplacian** and **biharmonic** operators on a rounded cube surface mesh, inspired by Chladni patterns on vibrating plates and shells.

---

## Overview

We study eigenvalue problems of the form:

- **Laplacian eigenproblem:**

$$
L u = \lambda M u,
$$

where $L$ is the discrete Laplace--Beltrami operator, $M$ is the mass matrix, and $\lambda$ are the eigenvalues.

- **Biharmonic eigenproblem:**

$$
B u = \lambda u, \quad \text{where} \quad B = L M^{-1} L,
$$

which corresponds to the surface biharmonic operator $\Delta^2$, modeling bending energy of thin shells.

---

## Mesh Generation

- The geometry is a **rounded cube** defined implicitly as a superellipsoid level set:

$$
|x|^p + |y|^p + |z|^p = 1,
$$

with exponent $p$ controlling the sharpness of edges and corners.

- A volumetric grid is generated and the zero-level is extracted via MATLAB's `isosurface`.

---

## Discretization

- The mesh surface is triangulated as vertices $V$ and faces $F$.

- The **cotangent Laplacian** matrix $L$ and **lumped mass matrix** $M$ are computed using standard discrete differential geometry formulas.

---

## Solving Eigenproblems

- MATLAB's `eigs` function solves for the smallest eigenvalues and eigenvectors of:

  - The generalized eigenproblem $(L, M)$ for Laplacian modes.
  - The standard eigenproblem $B u = \lambda u$ for biharmonic modes, where $B = L M^{-1} L$.

- The first few eigenmodes are visualized on the mesh surface.

---

## Visualization and Nodal Sets

- Eigenfunctions are plotted as vertex colors on the rounded cube mesh.

- To observe **Chladni-like nodal patterns**, zero-level sets of eigenfunctions are extracted by detecting edges where the eigenfunction changes sign.

- A dedicated function `extract_zero_level_set.m` interpolates zero crossings along mesh edges and returns points approximating nodal lines.

- These zero-level points are overlaid on the eigenfunction surface plots.

---

## Usage

1. **Generate the rounded cube mesh and assemble operators:**

   ```matlab
   [V,F] = rounded_cube_mesh(p, n);
   [L,M] = cotangent_laplacian(V,F);
