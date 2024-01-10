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
R_int=L_p/lambda_p;
R_ext=1/alpha_p-R_int;
Biot=R_int/R_ext;

T_w_infy=170+273.15;%
Ta=20+273.15;% 
Q=(T_w_infy-Ta)*A_w*alpha_w;

t_100=-log(7/15)*tau_w;




