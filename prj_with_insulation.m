clc;
clear all;
close all;
%% Calculation of cable metal part
%thermal conductivity of cable material, W/m/K
lambda_c=390;
%density of cable material, kg/m3
rho_c=8960;
%thermal capacity of cable material, J/kg/K
cp_c=390;
%current in cable, A
I=17.6*1e3;
%copper resisitvitiy, Ohm*m
resistivity_c=1.68*10^-8;
%radius of cable cross section, m
r=0.0129/2;
%cross sectional area of cable, m2
A=pi*r^2;
%Resistance per volume, Ohm/m3
resistivity_vol=resistivity_c/(A^2);
%constant c for cable
c_c=lambda_c/(rho_c*cp_c);
% c_c=lambda_c;
%constant f for cable
f_c=I^2*resistivity_vol/(cp_c*rho_c);
% f_c=I^2*resistivity_vol;

%% Calculation of cable insulation
%thermal conductivity, W/m/K
lambda_i=0.27;
%heat capacity insulation material, J/kg/K
cp_i= 2000;
%density of insulation material, kg/m3
rho_i=920;
%C factor for insulation material
c_i=lambda_i/(rho_i*cp_i);
% c_i=lambda_i;

%% Heat Transfer Coeffient for boundary
%lambda of air, W/m/K
lambda_a=0.59;
%dynamic viscosity of air, N s m-2
mu_a=0.6513*10^-3;
%thermal capacity air,  J/kg/K
cp_a=4200;
%density air, kg/m3
rho_a=1.3;
%velocity of air, m/s
vel_a=1; % in July

%thickness of insulation, m
th=0.013;
%Pr number
pr_a= (mu_a*cp_a)/lambda_a;
%Reynolds number
re_a=(rho_a*vel_a*2*r)/mu_a;
%nusselt number laminar component
nu_lam=0.664*re_a^0.5*pr_a^(1/3);
alpha_ca=nu_lam/((2*r)/lambda_a);
global alpha
alpha=alpha_ca;

C1 = [1
    0
    0
    r];
C2 = [1
    0
    0
    r+th];
geom = [C1 C2];
ns = char('C1','C2');
ns = ns';
sf = 'C1+C2';

% Create geometry
g = decsg(geom,sf,ns);

% Create geometry model
model = createpde

% Include the geometry in the model
% and view the geometry
geometryFromEdges(model,g);
figure
pdegplot(model,"EdgeLabels","on","FaceLabels","on")
xlim([-2*r 2*r])
axis equal

msh=generateMesh(model,"Hmax",0.001);
figure
pdemesh(msh)
axis equal

%% apply Neumann Boundary condition
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[5:8], ...
                             "g",@bcfuncN);

%sets initial conditions                         
setInitialConditions(model,25); 
% THE INITIAL CONDITION SHOULD BE DIFFERENT FROM AIR TEMP

% Specify Coefficient of PDE
specifyCoefficients(model,"m",0,"d",0,"c",c_c,"a",0,"f",f_c,"Face",1);
specifyCoefficients(model,"m",0,"d",0,"c",c_i,"a",0,"f",0,"Face",2);
% d=0, for steady state; d=1, for transient

theta = linspace(0, 2*pi, 100);  % Generate 100 points around the circle
x = r*cos(theta);
y = r*sin(theta);

results = solvepde(model);
u = results.NodalSolution;

pdeplot(model,"XYData",u)
hold on
plot(x, y);
axis equal; 
hold on

function bc = bcfuncN(location,state);
    global alpha;
    %Convection term
    Ta=35;
    bc = alpha*(state.u-Ta);
    % scatter(location.x/2,location.y/2,"filled","red");
    hold on 
end


