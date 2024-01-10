% prepare workspace
clear all
close all
clc
format short

% physical parameters
tau_w = 5500;
tau_e = 400;
Tw_inf = 170;
Tw_inf_real = 100;
Ta = 20;

% numerical parameters
dt = 60  % time step (s)
tend = 600;  % final time (s)
t = 0:dt:tend;  % time vector (s)

% analytical solution
Tw_analyt = Tw_inf + (Ta - Tw_inf)*exp(-t/tau_w);

% discretize time and temperatures
imax = tend/dt;
T_euler = zeros(size(t,2), 2);
T_tra = zeros(size(t,2), 2);

% initialize temperatures
T_euler(1,1) = Ta; % temperature of water
T_euler(1,2) = Ta; %temperature of egg/potato
T_tra(1,1) = Ta; % temperature of water
T_tra(1,2) = Ta; %temperature of egg/potato

% define ratio of time step and time constant
h_w = dt/tau_w % this should be small enough, ideally smaller than 0.1
h_e = dt/tau_e 

% integrate differential equations numerically
for i=1:imax
    
        % Euler's method
        % water temperature (index 1)
        T_euler(i+1, 1) = (1 - h_w)*T_euler(i, 1) + h_w*Tw_inf;
        
        % % clip maximum water temperature to realistic value
        % if clip & T(i+1, 1) > Tw_inf_real
        %     T(i+1, 1) = Tw_inf_real;
        %     Tw_analyt(i+1) = Tw_inf_real;
        % end                

        % egg temperature (index 2)
        T_euler(i+1, 2) = (1 - h_e)*T_euler(i, 2) + h_e*T_euler(i, 1);
        

        % Heun's or trapezium method
        % water temperature (index 1)
        T_tra(i+1, 1) = (1-0.5*h_w)/(1+0.5*h_w)*T_tra(i, 1) + h_w/(1+0.5*h_w)*Tw_inf;
        
        % % clip maximum water temperature to realistic value
        % if clip & T(i+1, 1) > Tw_inf_real
        %     T(i+1, 1) = Tw_inf_real;
        %     Tw_analyt(i+1) = Tw_inf_real;
        % end 
        
        T_tra(i+1, 2) = (1-0.5*h_e)/(1+0.5*h_e)*T_tra(i, 2)...
                  + h_e/(1+0.5*h_e)*(T_tra(i, 1) + T_tra(i+1, 1))/2;
end



% temperature of water, euler
subplot(2,1,1);
plot(t, Tw_analyt, '-', t, T_euler, 'o--');
xlabel('time, t / s')
ylabel('temperatures, T / °C')
legend('analyt: water', 'num: water', 'num: potato', 'error','Location','east')
title('Euler Forward')

% temperature of water, euler, trapezium
subplot(2,1,2);
plot(t, Tw_analyt, '-', t, T_tra, 'o--');
xlabel('time, t / s')
ylabel('temperatures, T / °C')
legend('analyt: water', 'num: water', 'num: potato', 'error','Location','east')
title('Trapezium')








