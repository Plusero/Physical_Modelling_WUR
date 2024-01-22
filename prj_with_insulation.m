clear;
clc;
clear all;
%lambda of cable material
lambda_c=390;
%density of cable material
rho_c=8960;
%thermal capacity of cable material
cp_c=390;
%current in cable
I=380;
% surface area m2
A=0.01;
%cable volume resisitvitiy to Ohm/m3
resistivity_c=1.77*10^-8;
resistivity_c_m3=resistivity_c/A/A;

%constant c for cable
c_c=lambda_c/(rho_c*cp_c);
%constant f for cable
f_c=I^2*resistivity_c_m3/(cp_c*rho_c);

%outside temperature 
Ta=20 ;
%radius of cable cross section
r=0.01;
%lambda of air
lambda_a=0.59;
%dynamic viscosity of air
mu_a=0.6513*10^-3;
%thermal capacity air
cp_a=4200;
%density air
rho_a=1.3;
%velocity of air, m/s
vel_a=1;
%Pr number
pr_a= (mu_a*cp_a)/lambda_a;
%Reynolds number
re_a=(rho_a*vel_a*2*r)/mu_a;
%nusselt number laminar component
nu_lam=0.664*re_a^0.5*pr_a^(1/3);
global alpha_ca
alpha_ca=nu_lam/((2*r)/lambda_a);

C1 = [1
    0
    0
    1];
C2 = [1
    0
    0
    2];
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
xlim([-1.1 1.1])
axis equal

msh=generateMesh(model,"Hmax",0.1);
figure
pdemesh(msh)
axis equal

%% apply Neumann Boundary condition
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[4:8], ...
                             "g",@bcfuncN);

%sets initial conditions                         
setInitialConditions(model,25);

% Specify Coefficient of PDE
specifyCoefficients(model,"m",0,"d",0,"c",c_c,"a",0,"f",f_c,"Face",1);
specifyCoefficients(model,"m",0,"d",0,"c",c_c,"a",0,"f",0,"Face",2);
% d=0, for steady state; d=1, for transient

theta = linspace(0, 2*pi, 100);  % Generate 100 points around the circle
x = cos(theta);
y = sin(theta);

results = solvepde(model);
u = results.NodalSolution;

pdeplot(model,"XYData",u)
hold on
plot(x, y);
axis equal; 
hold on


function bc = bcfuncN(location,state);
    global alpha_ca;
    alpha=alpha_ca;
    %Convection term
    Ta=20;
    bc = alpha*(state.u-Ta);
    %scatter(location.x,location.y,"filled","red");
    hold on 
end


