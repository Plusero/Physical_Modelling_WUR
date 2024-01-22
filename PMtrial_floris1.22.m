%lambda of cable material
lambda_c=390;
%density of cable material
rho_c=8960;
%thermal capacity of cable material
cp_c=390;
%current in cable
I=100;
%cable resisitvitiy
resistivity_c=1.68*10^-8;

%constant c for cable
c_c=-lambda_c/(rho_c*cp_c);
%constant f for cable
f_c=I^2*resistivity_c/(cp_c*rho_c);

C1 = [1
    0
    0
    1];

%create geometry
gd = [C1];
ns = char('C1');
ns=ns';
sf = 'C1';
[dl,bt] = decsg(gd,sf,ns);
xlim([-1.5,1.5])

axis equal
%create model which is container
model=createpde()
geometryFromEdges(model,dl);
%apply Neumann boundary condition
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[1:4],...
                             "g",@bcfuncN);
%sets initial conditions                         
setInitialConditions(model,15);

%c=-lambda/(cp*rho), d=1, m=0, a=0, f=I^2*R/(cp*rho)
specifyCoefficients(model,"m",0,"d",1,"c",c_c, ...
                          "a",0,"f",f_c);                            
%generate and plot mesh
generateMesh(model,"Hmax",0.05);
figure
pdemesh(model)
%timespace and stepsize
tlist=linspace(0,1000,10);                    
results = solvepde(model);
u=results.NodalSolution
pdeplot(model, "XYData", u)


    
%function for Neumann boundary condition                         
function bc = bcfuncN(location,state);
    %outside temperature 
    Ta=20 ;
    alpha=3;
    %Convection term
    bc = alpha*(location.x-Ta) ;
    %scatter(location.x,location.y,"filled","red");
    hold on
end


