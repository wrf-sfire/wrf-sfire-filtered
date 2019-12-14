function F=wind2flux(U,X)
% F=wind2flux(U,X)
% compute fluxes at midpoints of side in a hexa grid
% assuming all sides in the y direction are straight vertical
% while horizontal sides may be slanted
% in:
%     U{l}(i,j,k) flow component l at lower side midpoint of cell (i,j,k)
%                 such as output from grad3z
%     X{l}(i,j,k) coordinate l of node (i,j,k), if l=1,2 does not depend on k
% out:
%     F{l}(i,j,k) flux in normal direction through lower side midpoint of cell (i,j,k)
%                 flux through the bottom is zero
%
% Jan Mandel, August 2019

u = U{1}; v = U{2}; w = U{3};
x = X{1}; y = X{2}; z = X{3};
[nx1,ny1,nz1] = size(x);
nx = nx1-1; ny = ny1-1; nz = nz1-1;

% test inputs
if ndims(u)~=3|ndims(v)~=3|ndims(w)~=3|ndims(x)~=3|ndims(y)~=3|ndims(z)~=3,
    error('wind2flux: all input arrays must be 3D')
end
if any(size(u)~=[nx1,ny,nz])|any(size(v)~=[nx,ny1,nz])|any(size(w)~=[nx,ny,nz1])
    error('wind2flux: arrays u v w must be staggered dimensioned with x y z')
end

check_mesh(X)

err=false;
for k=2:nz+1
    if any(x(:,:,k)~=x(:,:,1))|any(y(:,:,k)~=y(:,:,1))
        x(:,:,k)=x(:,:,1);
        y(:,:,k)=y(:,:,1);
        err=true;
    end
end
if err,
    error('wind2flux: arrays x and y must be constant in 3rd dimension')
end


%                                             ^ z,w,k
%     (i,j+1,k+1)---------(i+1,j+1,k+1        |
%     /  |               / |                  |    /
%    /   |              /  |                  |   / y,v,j
%   /    |             /   |                  |  /
%(i,j,k+1)----------(i+1,j,k+1)               | /
%  |    /|            |    |                  |--------> x,u,i
%  |  dy |            |    |
%  | /   |            |    |
%  |/    |            |    |
%  |   (i,j+1,k)---------(i+1,j+1,k)
%  |   /              |  /
%  |  /               | /
%  | /                |/
%(i,j,k)----------(i+1,j,k)


s = cell_sizes(X); 

% flux through vertical sides left to rigth (u,x,i direction)
f_u = u .* s.area_u;

% flux through vertical sides front to back (v,y,j direction)
f_v = v .* s.area_v;

% slope in x direction
dzdx = zeros(nx,ny+1,nz+1);
for k=1:nz+1
    for j=1:ny+1
        for i=1:nx
            dzdx(i,j,k) = ((z(i+1,j,k)-z(i,j,k))/(x(i+1,j,k)-x(i,j,k)));
        end
    end
end

% slope in y direction
dzdy = zeros(nx+1,ny,nz+1);
for k=1:nz+1
    for j=1:ny
        for i=1:nx+1
            dzdy(i,j,k) = ((z(i,j+1,k)-z(i,j,k))/(y(i,j+1,k)-y(i,j,k)));
        end
    end
end
% normal flux through slanted horizontal bottom to top j direction
f_w = zeros(nx,ny,nz+1);
% continue one layer up
u(:,:,nz+1)=u(:,:,nz);
v(:,:,nz+1)=v(:,:,nz);
s.dz_at_u(:,:,nz+1)=s.dz_at_u(:,:,nz);
s.dz_at_v(:,:,nz+1)=s.dz_at_v(:,:,nz);
for k=2:nz+1   % zero normal flux on the ground, k=1
    for j=1:ny
        for i=1:nx
            % mesh horizontal mesh cell sizes of layer k
            % u, v averaged from above and below
            u_at_k = 0.5*( (u(i,j,k)   + u(i+1,j,k))  *s.dz_at_u(i,j,k) ...
                         + (u(i,j,k-1) + u(i+1,j,k-1))*s.dz_at_u(i,j,k-1) ...
                         )/ (s.dz_at_u(i,j,k) + s.dz_at_u(i,j,k-1));
            v_at_k = 0.5*( (v(i,j,k)   +v(i,j+1,k))   *s.dz_at_v(i,j,k) ...
                         + (v(i,j,k-1) +v(i,j+1,k-1)) *s.dz_at_v(i,j,k-1) ...
                         )/ (s.dz_at_v(i,j,k) + s.dz_at_v(i,j,k-1));
            % average slope at midpoints from two sides
            dzdx_at_k = 0.5*(dzdx(i,j,k) + dzdx(i,j+1,k));
            dzdy_at_k = 0.5*(dzdy(i,j,k) + dzdy(i+1,j,k));
            f_w(i,j,k)=s.area_w(i,j,k)*(w(i,j,k) - ...
                dzdx_at_k * u_at_k - dzdy_at_k * v_at_k);
        end
    end
end
F = {f_u, f_v, f_w};
end






