clearvars, clc

% Initial conditions for three bodies
% Body 1
x10 = 0;
y10 = 20;
z10 = 10;
vx10 = 11;
vy10 = 0;
vz10 = 0;

% Body 2
x20 = 70;
y20 = 0;
z20 = 0;
vx20 = 0;
vy20 = 14;
vz20 = 0;

% Body 3
x30 = 25;
y30 = 50;
z30 = 15;
vx30 = -7;
vy30 = -5;
vz30 = 5;

initial_state = [x10; y10; z10; vx10; vy10; vz10;...
                 x20; y20; z20; vx20; vy20; vz20;...
                 x30; y30; z30; vx30; vy30; vz30];

% Solve
tspan = 0:0.1:100;
[t, state] = ode45(@projectile_derivatives, tspan, initial_state);

% Extract trajectories
x1 = state(:,1);
y1 = state(:,2);
z1 = state(:,3);
x2 = state(:,7);
y2 = state(:,8);
z2 = state(:,9);
x3 = state(:,13);
y3 = state(:,14);
z3 = state(:,15);

% Calculate axis limits based on data
all_x = [x1; x2; x3];
all_y = [y1; y2; y3];
all_z = [z1; z2; z3];
xlims = [min(all_x), max(all_x)] + [-10, 10];
ylims = [min(all_y), max(all_y)] + [-10, 10];
zlims = [min(all_z), max(all_z)] + [-10, 10];

% Setup figure
figure('Color', 'w', 'Position', [100, 100, 1000, 800])

% Create trail lines (initialize first)
trail1 = plot3(x1(1), y1(1), z1(1), 'r-', 'LineWidth', 2);
hold on
trail2 = plot3(x2(1), y2(1), z2(1), 'b-', 'LineWidth', 2);
trail3 = plot3(x3(1), y3(1), z3(1), 'g-', 'LineWidth', 2);

% Create sphere surfaces (will update these)
[X, Y, Z] = sphere(20);
sphere_size = 3;
sphere1 = surf(X*sphere_size + x1(1), Y*sphere_size + y1(1), Z*sphere_size + z1(1), ...
    'FaceColor', 'r', 'EdgeColor', 'none', 'FaceAlpha', 0.9);
sphere2 = surf(X*sphere_size + x2(1), Y*sphere_size + y2(1), Z*sphere_size + z2(1), ...
    'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.9);
sphere3 = surf(X*sphere_size + x3(1), Y*sphere_size + y3(1), Z*sphere_size + z3(1), ...
    'FaceColor', 'g', 'EdgeColor', 'none', 'FaceAlpha', 0.9);

% Setup axes
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

% Animation loop
for i = 1:5:length(t)  % Skip frames for speed
    % Update trails
    set(trail1, 'XData', x1(1:i), 'YData', y1(1:i), 'ZData', z1(1:i));
    set(trail2, 'XData', x2(1:i), 'YData', y2(1:i), 'ZData', z2(1:i));
    set(trail3, 'XData', x3(1:i), 'YData', y3(1:i), 'ZData', z3(1:i));
    
    % Update sphere positions
    set(sphere1, 'XData', X*sphere_size + x1(i), ...
                 'YData', Y*sphere_size + y1(i), ...
                 'ZData', Z*sphere_size + z1(i));
    set(sphere2, 'XData', X*sphere_size + x2(i), ...
                 'YData', Y*sphere_size + y2(i), ...
                 'ZData', Z*sphere_size + z2(i));
    set(sphere3, 'XData', X*sphere_size + x3(i), ...
                 'YData', Y*sphere_size + y3(i), ...
                 'ZData', Z*sphere_size + z3(i));
    
    % Update view angle
    view_angle = 30 + t(i) * 1;
    view(view_angle, 20)
    
    % Update title
    title(sprintf('Three-Body Problem | Time: %.2f s', t(i)), 'FontSize', 14)
    
    % Force redraw
    drawnow;
end

hold off

% LOCAL FUNCTIONS
function dstate = projectile_derivatives(t, state)
    % Extract current state
    x1 = state(1);
    y1 = state(2);
    z1 = state(3);
    vx1 = state(4);
    vy1 = state(5);
    vz1 = state(6);
    x2 = state(7);
    y2 = state(8);
    z2 = state(9);
    vx2 = state(10);
    vy2 = state(11);
    vz2 = state(12);
    x3 = state(13);
    y3 = state(14);
    z3 = state(15);
    vx3 = state(16);
    vy3 = state(17);
    vz3 = state(18);
    
    % Parameters
    m = [10, 10, 10];
    G = 500;
    
    % Distance vectors
    d12 = [x2-x1, y2-y1, z2-z1];
    d13 = [x3-x1, y3-y1, z3-z1];
    d21 = [x1-x2, y1-y2, z1-z2];
    d23 = [x3-x2, y3-y2, z3-z2];
    d31 = [x1-x3, y1-y3, z1-z3];
    d32 = [x2-x3, y2-y3, z2-z3];
    
    % Add epsilon to prevent division by zero
    eps_val = 1e-3;
    
    % Gravitational forces
    f1 = ((G*m(1)*m(2)/(norm(d12)^3 + eps_val))*d12) + ...
         ((G*m(1)*m(3)/(norm(d13)^3 + eps_val))*d13);
    f2 = ((G*m(2)*m(1)/(norm(d21)^3 + eps_val))*d21) + ...
         ((G*m(2)*m(3)/(norm(d23)^3 + eps_val))*d23);
    f3 = ((G*m(3)*m(1)/(norm(d31)^3 + eps_val))*d31) + ...
         ((G*m(3)*m(2)/(norm(d32)^3 + eps_val))*d32);
    
    % Derivatives
    dx1dt = vx1;
    dy1dt = vy1;
    dz1dt = vz1;
    dvx1dt = f1(1) / m(1);
    dvy1dt = f1(2) / m(1);
    dvz1dt = f1(3) / m(1);
    
    dx2dt = vx2;
    dy2dt = vy2;
    dz2dt = vz2;
    dvx2dt = f2(1) / m(2);
    dvy2dt = f2(2) / m(2);
    dvz2dt = f2(3) / m(2);
    
    dx3dt = vx3;
    dy3dt = vy3;
    dz3dt = vz3;
    dvx3dt = f3(1) / m(3);
    dvy3dt = f3(2) / m(3);
    dvz3dt = f3(3) / m(3);
    
    % Return derivatives
    dstate = [dx1dt; dy1dt; dz1dt; dvx1dt; dvy1dt; dvz1dt; 
              dx2dt; dy2dt; dz2dt; dvx2dt; dvy2dt; dvz2dt; 
              dx3dt; dy3dt; dz3dt; dvx3dt; dvy3dt; dvz3dt];
end