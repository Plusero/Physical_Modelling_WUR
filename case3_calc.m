%  properties of water
rho_w=1000; %kg/m3
c_pw=4200; %J/kg/K
lambda_w=0.59;% W/m/K
mu_w=0.6531*1e-3; % N s m-2
%  properties of brass rod
L=0.32; % m
D=0.03; % m
rho_b=8430; % kg/m
c_pb=378;% J/Kg/K
lambda_b=109; % W/m/K
%  properties of air
rho_a=1.3; %kg/m3
c_pa=1000;% J/kg/K
lambda_a=0.021; % W/m/K
mu_a=1.8*1e-5; % W/m/K

v_w=0.3; %m/s

% calculate Biot number from brass to water
Re=rho_w*v_w*D/mu_w;
Pr=mu_w*c_pw/lambda_w;
Nu_lam=0.664*Re^(0.5)*Pr^(1/3);
Nu_turb=0.037*Re^(0.8)*Pr/(1+2.443*Re^(-0.1)*(Pr^(2/3)-1));
Nu=sqrt(Nu_lam^2+Nu_turb^2);
% here we use Nu_turb instead of nu because we found the water is turbulent
% by the Reynolds
alpha_bw=Nu_turb*lambda_w/D;

R_int=D/lambda_b;
R_ext=1/alpha_bw; % if you calculate the alpha by Nusselt, the R_ext is this
% if you calculate the alpha by tau, the alpha is for total
Biot_bw=R_int/R_ext;

%calculate the thermal diffusivity 
a_b=lambda_b/(rho_b*c_pb);

% calculate Biot number from brass to water
v_a=0.01;
Re_ba=rho_a*v_a*D/mu_a;
Pr_ba=mu_a*c_pa/lambda_a;
Nu_lam_ba=0.664*Re_ba^(0.5)*Pr_ba^(1/3);
Nu_turb_ba=0.037*Re_ba^(0.8)*Pr_ba/(1+2.443*Re_ba^(-0.1)*(Pr_ba^(2/3)-1));
Nu_ba=sqrt(Nu_lam_ba^2+Nu_turb_ba^2);
alpha_ba=Nu_lam_ba*lambda_a/D;

R_ext_ba=1/alpha_ba; % if you calculate the alpha by Nusselt, the R_ext is this
% if you calculate the alpha by tau, the alpha is for total
Biot_ba=R_int/R_ext_ba;






