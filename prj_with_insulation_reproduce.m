clc;
clear all;
close all;
%% Calculation of cable metal part
%thermal conductivity of cable material, W/m/K
lambda_c=395;
%copper resisitvitiy, Ohm*m
resistivity_c=1.68*10^-8;
%radius of cable cross section, m
r=0.023/2;
%cross sectional area of cable, m2
A=pi*r^2;
%Resistance per volume, Ohm/m3
resistivity_vol=resistivity_c/(A^2);
%current in cable, A
I=1600;
%constant c for cable
c_c=lambda_c;
%constant f for cable
f_c=I^2*resistivity_vol;

%% Cable insulation
%thermal conductivity, W/m/K
lambda_XLPE=0.28;
%C factor for insulation material
c_XLPE=lambda_XLPE;
%thickness of insulation, m
th=(0.0646-2*r)/2;
r_XLPE=0.0646/2;
%% PE
lambda_PE=0.28;
th_PE=(0.0736-0.0646)/2;
r_PE=0.0736/2;
c_PE=lambda_PE;
%% PVC
lambda_PVC=1;
c_PVC=lambda_PVC;
th_PVC=(0.1136-0.0736)/2;
r_PVC=0.1136/2;

C1 = [1
    0
    0
    r];
C2 = [1
    0
    0
    r_XLPE];
C3 = [1
    0
    0
    r_PE];
C4 = [1
    0
    0
    r_PVC];
geom = [C1 C2 C3 C4];
ns = char('C1','C2','C3','C4');
ns = ns';
sf = 'C1+C2+C3+C4';

% Create geometry
g = decsg(geom,sf,ns);

% Create geometry model
model = createpde;

% Include the geometry in the model
% and view the geometry
geometryFromEdges(model,g);
figure
pdegplot(model,"EdgeLabels","on","FaceLabels","on")
xlim([-2*r 2*r])
axis equal

msh=generateMesh(model,"Hmax",0.01);
figure
pdemesh(msh)
axis equal

% applyBoundaryCondition(model,"dirichlet", ...
%                              "Edge",[13:16], ...
%                              "u",@bcfuncD);
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[13:16], ...
                             "g",@bcfuncN);

% Specify Coefficient of PDE
specifyCoefficients(model,"m",0,"d",0,"c",c_c,"a",0,"f",f_c,"Face",4);
specifyCoefficients(model,"m",0,"d",0,"c",c_XLPE,"a",0,"f",0,"Face",3);
specifyCoefficients(model,"m",0,"d",0,"c",c_PE,"a",0,"f",0,"Face",1);
specifyCoefficients(model,"m",0,"d",0,"c",c_PVC,"a",0,"f",0,"Face",2);
% d=0, for steady state; d=1, for transient

theta = linspace(0, 2*pi, 100);  % Generate 100 points around the circle
x_c = r*cos(theta);
y_c = r*sin(theta);
x_XLPE = r_XLPE*cos(theta);
y_XLPE = r_XLPE*sin(theta);
x_PE = r_PE*cos(theta);
y_PE = r_PE*sin(theta);
x_PVC = r_PVC*cos(theta);
y_PVC = r_PVC*sin(theta);

results = solvepde(model);
u = results.NodalSolution;

pdeplot(model,"XYData",u)
hold on
plot(x_c, y_c);
plot(x_XLPE, y_XLPE);
plot(x_PE, y_PE);
plot(x_PVC, y_PVC);
axis equal; 

function bc = bcfuncD(location,state)
    bc = 305;
    scatter(location.x,location.y,"filled","black");
    hold on
end

function bc = bcfuncN(location,state);
    %Convection term
    Ta=305;
    bc = 160*(state.u-Ta);
    % scatter(location.x,location.y,"filled","red");
    % hold on 
end





