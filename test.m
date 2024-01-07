% Define the initial conditions
t0 = 0; % Initial time
y0 = 1; % Initial value of y

% Define the step size and number of iterations
dt = 0.1; % Step size
numIterations = 100; % Number of iterations

% Initialize arrays to store time and y values
t = zeros(numIterations+1, 1);
y = zeros(numIterations+1, 1);

% Set initial values
t(1) = t0;
y(1) = y0;

% Perform Euler's forward method
for i = 1:numIterations
    t(i+1) = t(i) + dt; % Update time
    y(i+1) = y(i) + dt * f(t(i), y(i)); % Update y using the derivative function f(t, y)
end

% Define the derivative function
function dydt = f(t, y)
    dydt = -2 * t * y; % Example derivative function
end

% Plot the results
figure;
plot(t, y, 'r-');
title('Solution using Euler''s forward method');
xlabel('Time (t)');
ylabel('y(t)');
grid on;