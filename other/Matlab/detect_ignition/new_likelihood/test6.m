function [] = test6()


close all

%make splines
fprintf('Making splines \n');

[p_like_spline,p_deriv_spline,n_deriv_spline] = make_spline(48,2000);
save splines.mat p_like_spline p_deriv_spline n_deriv_spline

%make fire data
cone_slope = 10;
fire_cone = @(x,y) cone_slope*sqrt(( x.^2 + y.^2));
g = 100;
grid_size =2*g+1;
position = linspace(-10,10,grid_size);
[x,y]= meshgrid(position,position);

z = fire_cone(x,y);
fire_top = z > 100;
z(fire_top) = 100;
mesh(x,y,z);
hold on
xlabel('x');


slice_time = [47 49 51];
fires = -1*ones(size(x));


contour3(x,y,z,[49 49],'k')
fires = 5*ones(size(x));
num_pts = 1000;
x_coords = 1+round(2*g*rand(1,num_pts));
y_coords = 1+round(2*g*rand(1,num_pts));
%figure,scatter(x_coords,y_coords);
%make fire mask
hold on
radius = slice_time(2)/10;
angle = linspace(0,2*pi);
perim = zeros(length(angle),2);
perim(:,1) = radius*cos(angle)';
perim(:,2) = radius*sin(angle)';
plot(perim(:,1),perim(:,2),'k')

for i = 1:num_pts
    u = x(x_coords(i),y_coords(i));
    v = y(x_coords(i),y_coords(i));
    zt = norm([u v]);
    if abs(zt - radius) < 2  && zt < radius %49
        fires(x_coords(i),y_coords(i)) = 9;
        scatter(u,v,'r*');
    else
        if rand < 0.98
            fires(x_coords(i),y_coords(i)) = -1;
            scatter(u,v,'b');
        else
            fires(x_coords(i),y_coords(i)) = 9;
            scatter(u,v,'r*');
        end
    end
end

%make all fire detections
%fires = 9*ones(grid_size,grid_size);

% evaluate and plot likelihoods
t = slice_time(2) - z;
[like,deriv]= temp_liker(fires,t,p_like_spline,p_deriv_spline,n_deriv_spline);

fprintf('paused for plotting, etc... \n');
figure,mesh(like),title('like')
figure,mesh(deriv),title('deriv')
figure,plot(t(100,:),like(100,:)),title('like slice')
figure,plot(t(100,:),deriv(100,:)),title('deriv slice')



end % function

