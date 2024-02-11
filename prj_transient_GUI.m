% This script is written and read by pdetool and should NOT be edited.
% There are two recommended alternatives:
% 1) Export the required variables from pdetool and create a MATLAB script
%    to perform operations on these.
% 2) Define the problem completely using a MATLAB script. See
%    https://www.mathworks.com/help/pde/examples.html for examples
%    of this approach.
function pdemodel
[pde_fig,ax]=pdeinit;
pdetool('appl_cb',1);
set(ax,'DataAspectRatio',[1 1 1]);
set(ax,'PlotBoxAspectRatio',[1.7066666666666666 1 80.723078359504171]);
set(ax,'XLimMode','auto');
set(ax,'YLim',[-0.020067767569861984 0.026315151679534458]);
set(ax,'XTickMode','auto');
set(ax,'YTickMode','auto');

% Geometry description:
pdeellip(0,0,0.0064999999999999997,0.0064999999999999997,...
0,'E1');
pdeellip(0,0,0.019400000000000001,0.019400000000000001,...
0,'E2');
set(findobj(get(pde_fig,'Children'),'Tag','PDEEval'),'String','E1+E2')

% Boundary conditions:
pdetool('changemode',0)
pdesetbd(8,...
'dir',...
1,...
'1',...
'35')
pdesetbd(7,...
'dir',...
1,...
'1',...
'35')
pdesetbd(6,...
'dir',...
1,...
'1',...
'35')
pdesetbd(5,...
'dir',...
1,...
'1',...
'35')

% Mesh generation:
setappdata(pde_fig,'Hgrad',1.3);
setappdata(pde_fig,'refinemethod','regular');
setappdata(pde_fig,'jiggle',char('on','mean',''));
setappdata(pde_fig,'MesherVersion','preR2013a');
pdetool('initmesh')
pdetool('refine')
pdetool('refine')

% PDE coefficients:
pdeseteq(2,...
'1.116071428571429e-04!1.467391304347826e-07',...
'0.0!0.0',...
'87.1813!0',...
'1.0!1.0',...
'0:0.1:100',...
'35',...
'0.0',...
'[0 100]')
setappdata(pde_fig,'currparam',...
['1.116071428571429e-04!1.467391304347826e-07';...
'0.0!0.0                                    ';...
'87.1813!0                                  ';...
'1.0!1.0                                    '])

% Solve parameters:
setappdata(pde_fig,'solveparam',...
char('0','6480','10','pdeadworst',...
'0.5','longest','0','1E-4','','fixed','Inf'))

% Plotflags and user data strings:
setappdata(pde_fig,'plotflags',[1 1 1 1 1 1 1 1 0 0 0 101 1 0 0 0 0 1]);
setappdata(pde_fig,'colstring','');
setappdata(pde_fig,'arrowstring','');
setappdata(pde_fig,'deformstring','');
setappdata(pde_fig,'heightstring','');

% Solve PDE:
pdetool('solve')