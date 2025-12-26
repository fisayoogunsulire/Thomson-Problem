clearvars, clc

% theta0 = 360 * rand(4,1)
% phi0 = 360 * rand(4,1)

theta0 = [0;90;270;180]
phi0 = [0;90;90;90]


x10 = sind(phi0(1)) * cosd(theta0(1));
y10 = sind(phi0(1)) * sind(theta0(1));
z10 = cosd(phi0(1));
vx10 = 0;
vy10 = 0;
vz10 = 0;
x20 = sind(phi0(2)) * cosd(theta0(2));
y20 = sind(phi0(2)) * sind(theta0(2));
z20 = cosd(phi0(2));
vx20 = 0;
vy20 = 0;
vz20 = 0;
x30 = sind(phi0(3)) * cosd(theta0(3));
y30 = sind(phi0(3)) * sind(theta0(3));
z30 = cosd(phi0(3));
vx30 = 0;
vy30 = 0;
vz30 = 0;
x40 = sind(phi0(4)) * cosd(theta0(4));
y40 = sind(phi0(4)) * sind(theta0(4));
z40 = cosd(phi0(4));
vx40 = 0;
vy40 = 0;
vz40 = 0;

initial_state = [x10;y10;z10;vx10;vy10;vz10;...
                x20;y20;z20;vx20;vy20;vz20;...
                x30;y30;z30;vx30;vy30;vz30;...
                x40;y40;z40;vx40;vy40;vz40];


% Solve

tspan = 0 : 0.00001 : 20;
[t, state] = ode45(@electron_derivatives, tspan, initial_state);

% Extract positions

x1 = state(:,1);
y1 = state(:,2);
z1 = state(:,3);
x2 = state(:,7);
y2 = state(:,8);
z2 = state(:,9);
x3 = state(:,13);
y3 = state(:,14);
z3 = state(:,15);
x4 = state(:,19);
y4 = state(:,20);
z4 = state(:,21);

% Axis Limits

all_x = [x1; x2; x3; x4];
all_y = [y1; y2; y3; y4];
all_z = [z1; z2; z3; z4];
xlims = [min(all_x), max(all_x)] + [-1, 1];
ylims = [min(all_y), max(all_y)] + [-1, 1];
zlims = [min(all_z), max(all_z)] + [-1, 1];

% Setup

figure('Color', 'w', 'Position', [100, 100, 1000, 800])

% Trail lines 

trail1 = plot3(x1(1), y1(1), z1(1), 'r-', 'LineWidth', 0.2);
hold on
trail2 = plot3(x2(1), y2(1), z2(1), 'b-', 'LineWidth', 0.2);
trail3 = plot3(x3(1), y3(1), z3(1), 'g-', 'LineWidth', 0.2);
trail4 = plot3(x4(1), y4(1), z4(1), 'y-', 'LineWidth', 0.2);


% Spheres

[X, Y, Z] = sphere(10);
sphere_size = 0.1;
sphere1 = surf(X*sphere_size + x1(1), Y*sphere_size + y1(1), Z*sphere_size + z1(1), ...
    'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.9);
sphere2 = surf(X*sphere_size + x2(1), Y*sphere_size + y2(1), Z*sphere_size + z2(1), ...
    'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.9);
sphere3 = surf(X*sphere_size + x3(1), Y*sphere_size + y3(1), Z*sphere_size + z3(1), ...
    'FaceColor', 'g', 'EdgeColor', 'none', 'FaceAlpha', 0.9);
sphere4 = surf(X*sphere_size + x4(1), Y*sphere_size + y4(1), Z*sphere_size + z4(1), ...
    'FaceColor', 'y', 'EdgeColor', 'none', 'FaceAlpha', 0.9);

% Axes

xlabel('X Position', 'FontSize', 12)
ylabel('Y Position', 'FontSize', 12)
zlabel('Z Position', 'FontSize', 12)
grid on
axis equal
xlim(xlims)
ylim(ylims)
zlim(zlims)
lighting gouraud
light('Position', [1, 1, 1])
legend('Body 1', 'Body 2', 'Body 3', 'Location', 'northeast')

% Animation

for i = 1:10000:length(t)
    
    set(trail1, 'XData', x1(1:i), 'YData', y1(1:i), 'ZData', z1(1:i));
    set(trail2, 'XData', x2(1:i), 'YData', y2(1:i), 'ZData', z2(1:i));
    set(trail3, 'XData', x3(1:i), 'YData', y3(1:i), 'ZData', z3(1:i));
    set(trail4, 'XData', x4(1:i), 'YData', y4(1:i), 'ZData', z4(1:i));
    
    set(sphere1, 'XData', X*sphere_size + x1(i), 'YData', Y*sphere_size + y1(i), 'ZData', Z*sphere_size + z1(i));
    set(sphere2, 'XData', X*sphere_size + x2(i), 'YData', Y*sphere_size + y2(i), 'ZData', Z*sphere_size + z2(i));
    set(sphere3, 'XData', X*sphere_size + x3(i), 'YData', Y*sphere_size + y3(i), 'ZData', Z*sphere_size + z3(i));
    set(sphere4, 'XData', X*sphere_size + x4(i), 'YData', Y*sphere_size + y4(i), 'ZData', Z*sphere_size + z4(i));
    
    % Update view angle
    view_angle = 30 + t(i) * 1;
    view(view_angle, 20)
    
    % Update title
    title(sprintf('Three-Body Problem | Time: %.2f s', t(i)), 'FontSize', 14)
    
    drawnow;

    pause(0.1); % Control the animation speed
end

hold off
function dstate = electron_derivatives(t, state)



% Extract values
    
p = [state(1:3).'; state(7:9).'; state(13:15).'; state(19:21).'];
v = [state(4:6).'; state(10:12).'; state(16:18).'; state(22:24).'];
  
% Parameters
    K = 1;
    Q = [1,1,1,1];
    M = [1,1,1,1];
    Mu = 0.8;
   
% Functions

function F = forceBtw(q1,q2)
    
    F = (K*Q(q1)*Q(q2) * ((p(q1,:)-p(q2,:)) /(norm(p(q1,:)-p(q2,:)))^3));

end

function P = projection(v1)

    P = f(v1,:) - (dot(f(v1,:), p(v1,:)) / dot(p(v1,:), p(v1,:)) * p(v1,:));

end



% Calculations

dist = [norm(p(1,:)-p(2,:)),...
        norm(p(1,:)-p(3,:)),...
        norm(p(1,:)-p(4,:)),...
        norm(p(2,:)-p(3,:)),...
        norm(p(2,:)-p(4,:)),...
        norm(p(3,:)-p(4,:)),];


aver_dist = sum(dist)/6;

dist_r = sum(abs(dist-aver_dist));

disp(dist)

f = [(forceBtw(1,2) + forceBtw(1,3) + forceBtw(1,4));...
     forceBtw(2,1) + forceBtw(2,3) + forceBtw(2,4);...
     forceBtw(3,1) + forceBtw(3,2) + forceBtw(3,4);...
     forceBtw(4,1) + forceBtw(4,2) + forceBtw(4,3)];

f_proj = [projection(1);...
          projection(2);...
          projection(3);...
          projection(4)];

f_tot = [f_proj(1,:) - (norm(v(1,:))^2 * p(1,:) / norm(p(1,:))^2) - (Mu * v(1,:));...
         f_proj(2,:) - (norm(v(2,:))^2 * p(2,:) / norm(p(2,:))^2) - (Mu * v(2,:));...
         f_proj(3,:) - (norm(v(3,:))^2 * p(3,:) / norm(p(3,:))^2) - (Mu * v(3,:));...
         f_proj(4,:) - (norm(v(4,:))^2 * p(4,:) / norm(p(4,:))^2) - (Mu * v(4,:))];

dx1dt = v(1,1);
dy1dt = v(1,2);
dz1dt = v(1,3);
dvx1dt = f_tot(1,1) / M(1);
dvy1dt = f_tot(1,2) / M(1);
dvz1dt = f_tot(1,3) / M(1);
dx2dt = v(2,1);
dy2dt = v(2,2);
dz2dt = v(2,3);
dvx2dt = f_tot(2,1) / M(2);
dvy2dt = f_tot(2,2) / M(2);
dvz2dt = f_tot(2,3) / M(2);
dx3dt = v(3,1);
dy3dt = v(3,2);
dz3dt = v(3,3);
dvx3dt = f_tot(3,1) / M(3);
dvy3dt = f_tot(3,2) / M(3);
dvz3dt = f_tot(3,3) / M(3);
dx4dt = v(4,1);
dy4dt = v(4,2);
dz4dt = v(4,3);
dvx4dt = f_tot(4,1) / M(4);
dvy4dt = f_tot(4,2) / M(4);
dvz4dt = f_tot(4,3) / M(4);

dstate = [dx1dt;dy1dt;dz1dt;dvx1dt;dvy1dt;dvz1dt;...
          dx2dt;dy2dt;dz2dt;dvx2dt;dvy2dt;dvz2dt;...
          dx3dt;dy3dt;dz3dt;dvx3dt;dvy3dt;dvz3dt;...
          dx4dt;dy4dt;dz4dt;dvx4dt;dvy4dt;dvz4dt];
end







