% prepare workspace
clear all
close all
clc
format short

% physical parameters
tau_w = 100;
tau_e = 50;
Tw_inf = 150;
Tw_inf_real = 100;
Ta = 20;

% numerical parameters
dt = 60  % time step (s)
tend = 600;  % final time (s)
t = 0:dt:tend;  % time vector (s)
method = 'Heun'
clip = 0

% analytical solution
Tw_analyt = Tw_inf + (Ta - Tw_inf)*exp(-t/tau_w);

% discretize time and temperatures
imax = tend/dt;
T = zeros(size(t,2), 2);

% initialize temperatures
T(1,1) = Ta;
T(1,2) = Ta;

% define ratio of time step and time constant
h_w = dt/tau_w
h_e = dt/tau_e

% integrate differential equations numerically
for i=1:imax
    
    switch method
        case 'Euler'
            % Euler's method
            % water temperature (index 1)
            T(i+1, 1) = (1 - h_w)*T(i, 1) + h_w*Tw_inf;
            
            % clip maximum water temperature to realistic value
            if clip & T(i+1, 1) > Tw_inf_real
                T(i+1, 1) = Tw_inf_real;
                Tw_analyt(i+1) = Tw_inf_real;
            end                
    
            % egg temperature (index 2)
            T(i+1, 2) = (1 - h_e)*T(i, 2) + h_e*T(i, 1);
            
        case 'Heun'
            % Heun's or trapezium method
            % water temperature (index 1)
            T(i+1, 1) = (1-0.5*h_w)/(1+0.5*h_w)*T(i, 1) + h_w/(1+0.5*h_w)*Tw_inf;
            
            % clip maximum water temperature to realistic value
            if clip & T(i+1, 1) > Tw_inf_real
                T(i+1, 1) = Tw_inf_real;
                Tw_analyt(i+1) = Tw_inf_real;
            end 
            
            T(i+1, 2) = (1-0.5*h_e)/(1+0.5*h_e)*T(i, 2)...
                      + h_e/(1+0.5*h_e)*(T(i, 1) + T(i+1, 1))/2;
    end
end

% plot temperature profile and error
figure(1);
plot(t, Tw_analyt, '-', t, T, 'o--');
xlabel('time, t / s')
ylabel('temperatures, T / °C')
legend('analyt: water', 'num: water', 'num: egg', 'Location','east')