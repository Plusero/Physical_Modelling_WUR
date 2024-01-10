V_p=33.5; %ml
A_p=50; % cm2
rho_p=1100; % kg/m3
c_pp=3500; % J/kg/K
lambda_p=0.68; % W/m/K
tau_p=400; %s

% convert the variables into  SI units
V_p=V_p*1e-6; %m3
A_p=A_p*1e-4; % cm2

V_w=1.5; % L
A_w=5.76; % dm2
rho_w=1000; %kg/m3
c_pw=4200; % J/kg/K
lambda_w=0.59; % W/m/K
tau_w=5500; %s

% conver units
V_w=V_w*1e-3; %m3
A_w=A_w*1e-2; %m2

alpha_p=rho_p*c_pp*V_p/A_p/tau_p;
alpha_w=rho_w*c_pw*V_w/A_w/tau_w;
% Biot number calculations
L_p=V_p/A_p;
R_ext=1/(alpha_p-lambda_p*L_p);
R_int=L_p/lambda_p;
Biot=R_int/R_ext;

T_w_infy=170+273.15;%
Ta=20+273.15;% 
Q=(T_w_infy-Ta)*A_w*alpha_w;

%simulations

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
dt = 60;  % time step (s)
tend = 600;  % final time (s)
t = 0:dt:tend;  % time vector (s)
method = 'Heun';
clip = 0;

% analytical solution
Tw_analyt = Tw_inf + (Ta - Tw_inf)*exp(-t/tau_w);

% discretize time and temperatures
imax = tend/dt;
T = zeros(size(t,2), 2);

% initialize temperatures
T(1,1) = Ta;
T(1,2) = Ta;

% define ratio of time step and time constant
h_w = dt/tau_w;
h_e = dt/tau_e;

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



