C1 = [1
    0
    0
    1];
geom = [C1];
ns = char('C1');
ns = ns';
sf = 'C1';

% Create geometry
g = decsg(geom,sf,ns);


% Create geometry model
model = createpde;


% Include the geometry in the model
% and view the geometry
geometryFromEdges(model,g);
pdegplot(model,"EdgeLabels","on")
xlim([-1.1 1.1])
axis equal

% applyBoundaryCondition(model,"dirichlet", ...
%                              "Edge",[1:4],"u",32);
applyBoundaryCondition(model,"dirichlet", ...
                             "Edge",[1:4], ...
                             "u",@bcfuncD);
% applyBoundaryCondition(model,"neumann", ...
%                              "Edge",[1:4], ...
%                              "g",@bcfuncN);
specifyCoefficients(model,"m",0,"d",0,"c",1,"a",0,"f",10);
generateMesh(model,"Hmax",0.1);
results = solvepde(model);
u = results.NodalSolution;
pdeplot(model,"XYData",u,"ZData",u)
view(-23,8)

function bc = bcfuncD(location,state)
    bc = 30 + 20*location.x;
    scatter(location.x,location.y,"filled","black");
    hold on
end

function bc = bcfuncN(location,state)
    bc = 30 + 20*location.x;
    scatter(location.x,location.y,"filled","red");
    hold on
end

