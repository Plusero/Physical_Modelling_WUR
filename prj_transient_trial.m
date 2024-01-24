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
geometryFromEdges(model,g);
applyBoundaryCondition(model,"neumann", ...
                             "Edge",[5:8], ...
                             "g",@bcfuncN);
specifyCoefficients(model,"m",0,"d",1,"c",c_c,"a",0,"f",f_c,"Face",1);
specifyCoefficients(model,"m",0,"d",1,"c",c_i,"a",0,"f",0,"Face",2);
setInitialConditions(model,25);
generateMesh(model);
tlist = 0:20;
results = solvepde(model,tlist);
pdeplot3D(model,"ColorMapData",results.NodalSolution(:,2))
figure
pdeplot3D(model,"ColorMapData",results.NodalSolution(:,21))

function bc = bcfuncN(location,state);
    global alpha;
    %Convection term
    Ta=35;
    bc = alpha*(state.u-Ta);
    % scatter(location.x/2,location.y/2,"filled","red");
    hold on 
end
