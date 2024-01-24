clc;
clear all;
close all;
%% Calculation of cable metal part
%lambda of cable material, W/m/K
lambda_c=390;
%density of cable material, kg/m3
rho_c=8960;
%thermal capacity of cable material, J/kg/K
cp_c=390;
%current in cable, A
I=0;
%copper resisitvitiy, Ohm*m
resistivity_c=1.68*10^-8;
%radius of cable cross section, m
r=0.013*0.5;
%cross sectional area of cable, m2
A=pi*r^2;
%Resistance per volume, Ohm m
%R=resisitvity* length/A
resistivity_vol=resistivity_c/A^2;
%constant c for cable
c_c=lambda_c/(rho_c*cp_c);
%constant f for cable
f_c=I^2*resistivity_vol/(cp_c*rho_c);

%% Calculation of cable insulation
%thermal conductivity, W/m/K
lambda_i=0.27;
%heat capacity insulation material, J/kg/K
cp_i= 2000;
%density of insulation material, kg/m3
rho_i=920;
%C factor for insulation material
c_i=lambda_i/(rho_i*cp_i);

%% Heat Transfer Coeffient for boundary
%lambda of air, W/m/K
lambda_a=0.59;
%dynamic viscosity of air, N s m-2
mu_a=0.6513*10^-3;
%thermal capacity air,  J/kg/K
cp_a=4200;
%density air, kg/m3
rho_a=1.3;
%velocity of air, m/s Winter 7 ms temp 3.5C
vel_a=1;

%thickness of insulation, m
global th
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
    (r+th)];

%create geometry
gd = [C1, C2];
ns = char('C1', 'C2');
ns=ns';
sf = 'C1+C2';
[dl,bt] = decsg(gd,sf,ns);
xlim([-0.1,0.1])

axis equal
%create model which is container
model=createpde()
geometryFromEdges(model,dl);
%apply Neumann boundary condition
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[5:8],...
                             "g",@bcfuncN);
%sets initial conditions                         
%setInitialConditions(model,0);

%if d set to zero, steady state
%c=-lambda/(cp*rho), d=1, m=0, a=0, f=I^2*R/(cp*rho)
specifyCoefficients(model,"m",0,"d",0,"c",c_c, ...
                          "a",0,"f",f_c, "Face",1); 
                      
%coefficients for insulation material
specifyCoefficients(model,"m",0,"d",0,"c",c_i, ...
                          "a",0,"f",0, "Face",2); 
                      
%generate and plot mesh
generateMesh(model,"Hmax",0.001);
%pdemesh(model)
%pdegplot(model,'FaceLabels', "on", 'EdgeLabels',"on")
%plot a circle to represent boundary
theta = linspace(0, 2*pi, 100);  % Generate 100 points around the circle
x = r*cos(theta);
y = r*sin(theta);

%timespace and stepsize
tlist=linspace(0,1000,10);                    
results = solvepde(model);
u=results.NodalSolution;
%finds index and value of max temperature
[maxTemperature, maxIndex] = max(u(:));
pdeplot(model, "XYData", u)
hold on
plot(x, y);
xlabel("x")
ylabel("y")

    
%function for Neumann boundary condition                         
function bc = bcfuncN(location,state);
    %Convection term
    global alpha
    Ta=30;
    global th
    bc = alpha*(state.u-Ta) ;
    %scatter(location.x,location.y,"filled","red");
    hold on
end


